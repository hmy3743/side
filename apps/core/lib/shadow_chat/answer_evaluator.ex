defmodule ShadowChat.AnswerEvaluator do
  defmodule Evaluation do
    defstruct [:judge, :reason, :score, :improvement]
  end

  @spec evaluate(question: String.t(), answer: String.t()) :: %{
          critical: %Evaluation{},
          positive: %Evaluation{}
        }
  def evaluate(question: question, answer: answer) do
    {:ok, resp} =
      OpenAI.chat_completion(
        model: "gpt-3.5-turbo",
        messages: [
          %{
            role: "system",
            content: "You are a helpful chatbot that helps people learn English."
          },
          %{
            role: "user",
            content: """
            Answer in the format of json with the following keys:
            - critical: Evaluation; evaluate answer in critical way.
            - positive: Evaluation; evaluate answer in positive way.  evaluate the sentence structure and grammar too.
            Make it as if two people with different tendencies are evaluating answer.

            Evaluation is type which has following keys:
            - judge: true | false; whether the answer is correct or not.
            - reason: String; the reason why the answer is correct or not.
            - score: Float; the score of the answer.  The higher the better. Minimum is 0.0, maximum is 1.0.
            - improvement: String; the improvement of the answer.  That makes answer more naturally and must includes model answer.

            * improvement must not be empty string when score is less than 1.0.

            Question student got:
            "#{escape(question)}"

            Answer student gave:
            "#{escape(answer)}"
            """
          }
        ]
      )

    parse_resp(resp)
  end

  defp parse_resp(resp) do
    %{choices: [choice]} = resp |> IO.inspect(label: :resp)
    result = Jason.decode!(choice["message"]["content"], keys: :atoms)

    %{
      critical: %Evaluation{
        judge: result.critical.judge,
        reason: result.critical.reason,
        score: result.critical.score,
        improvement: result.critical.improvement
      },
      positive: %Evaluation{
        judge: result.positive.judge,
        reason: result.positive.reason,
        score: result.positive.score,
        improvement: result.positive.improvement
      }
    }
  end

  defp escape(answer) do
    String.replace(answer, "\"", "\\\"")
  end
end
