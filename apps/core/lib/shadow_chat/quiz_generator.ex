defmodule ShadowChat.QuizGenerator do
  @spec generate() :: %{question: String.t(), example_sentences: [String.t()], hint: String.t()}
  def generate([exclude: exclude] \\ [exclude: []]) do
    {:ok, resp} =
      OpenAI.chat_completion(
        model: "gpt-3.5-turbo",
        temperature: 1.0,
        messages: [
          %{
            role: "system",
            content: """
            You are a helpful chatbot that helps people learn English.
            You always give response in a json format.
            """
          },
          %{
            role: "user",
            content: """
            Answer in the format of json with the following keys:
            - expression: String; expression it self. For example "a piece of cake"
            - question: String; The question you make.  User will try to answer this question.  Use <strong> to highlight the idiom or expression.
            - example_sentences: [String]; About two to three of example sentences that uses the idiom or expression. Use <strong> to highlight the idiom or expression.
            - hint: String; A hint for the question.

            Make a idiom or expression question.  that widly used in north American English.
            Below list is the idiom or expression that already used in the quiz.
            #{exclude |> Enum.map(&"- #{&1}") |> Enum.join("\n")}
            """
          }
        ]
      )

    parse_resp(resp)
  end

  defp parse_resp(resp) do
    %{choices: [choice]} = resp
    Jason.decode!(choice["message"]["content"], keys: :atoms)
  end
end
