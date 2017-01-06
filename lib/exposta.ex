defmodule ExPosta do

  alias ExPosta.Message

  defp headers do
    [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"X-Postmark-Server-Token", Application.get_env(:exposta, :server_token)}
    ]
  end

  defp deliver(payload) do
    response = HTTPoison.post!(Application.get_env(:exposta, :api_endpoint), Poison.encode!(payload), headers)
    case response.status_code do
      200 ->
        {:ok, Poison.decode!(response.body)}
      422 ->
        {:error, Poison.decode!(response.body)}
      _ ->
        {:error, response.status_code}
    end
  end

  def send(msg=%Message{}) do
    Task.async(fn -> deliver(msg) end)
  end

end
