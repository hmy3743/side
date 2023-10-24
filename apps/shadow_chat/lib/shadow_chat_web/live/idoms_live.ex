defmodule ShadowChatWeb.IdomsLive do
  use ShadowChatWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Task.start(__MODULE__, :quiz, [self(), []])
    end

    form = to_form(%{"answer" => ""})

    socket =
      assign(
        socket,
        history: [],
        question: nil,
        example_sentences: [],
        hint: nil,
        evaluation: nil,
        form: form,
        quota: ShadowChat.QuotaCounter.get()
      )

    {:ok, socket}
  end

  defp valid_answer?(answer) do
    answer != "" && String.length(answer) <= 300
  end

  def handle_event("submit", %{"answer" => answer}, socket) do
    if valid_answer?(answer) do
      Task.start(__MODULE__, :evaluate, [self(), socket.assigns.question, answer])
    end

    {:noreply, socket}
  end

  def handle_event("edit_answer", %{"answer" => answer} = params, socket) do
    errors = if answer == "", do: [answer: {"Answer can't be blank", []}], else: []

    errors =
      if 300 < String.length(answer) do
        Keyword.put(errors, :answer, {"Answer is too long", []})
      else
        errors
      end

    form = to_form(params, errors: errors)

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("next", _, socket) do
    Task.start(__MODULE__, :quiz, [self(), [socket.assigns.expression | socket.assigns.history]])

    socket =
      assign(socket,
        evaluation: nil,
        question: nil,
        example_sentences: [],
        hint: nil,
        form: to_form(%{})
      )

    {:noreply, socket}
  end

  def quiz(pid, exclude) do
    if 0 < ShadowChat.QuotaCounter.count() do
      quiz = ShadowChat.QuizGenerator.generate(exclude: exclude)
      send(pid, {:update_quiz, quiz})
    else
      send(pid, :quota_exceeded)
    end
  end

  def evaluate(pid, question, answer) do
    if 0 < ShadowChat.QuotaCounter.count() do
      evaluation =
        ShadowChat.AnswerEvaluator.evaluate(question: question, answer: answer)

      send(pid, {:update_evaluation, evaluation})
    else
      send(pid, :quota_exceeded)
    end
  end

  def handle_info({:update_quiz, quiz}, socket) do
    socket = assign(socket, quiz)
    {:noreply, socket}
  end

  def handle_info({:update_evaluation, evaluation}, socket) do
    socket = assign(socket, evaluation: evaluation)
    {:noreply, socket}
  end

  def handle_info(:quota_exceeded, socket) do
    {:noreply, put_flash(socket, :error, "You have reached the daily quota.")}
  end
end
