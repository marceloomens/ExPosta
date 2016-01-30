defmodule ExPosta do

  alias ExPosta.Message

  @endpoint Application.get_env(:exposta, :api_endpoint)
  @headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"},
    {"X-Postmark-Server-Token", Application.get_env(:exposta, :server_token)}
  ]

  defp process(response) do
    {:ok, body} = Poison.decode(response.body)
    case response.status_code do
      200 ->
        {:ok, body["Message"]}
      401 ->
        {:error, body["Message"]}
      422 ->
        # Unprocessible entity needs further inspection
        {:error, body["Message"]}
      500 ->
        {:error, body["Message"]}
    end
  end

  # Do I need several strategies, including async, await, etc?
  def send(msg=%Message{}) do
    payload = Message.encode msg
    {:ok, resp} = HTTPoison.post(@endpoint, payload, @headers)
    process resp
  end

end
