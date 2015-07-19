defmodule ExPosta do

  @endpoint Application.get_env(:postmark, :api_endpoint)
  @headers [
    "Accept": "application/json",
    "Content-Type": "application/json",
    "X-Postmark-Server-Token": Application.get_env(:postmark, :server_token),
  ]

  # Do I need several strategies, including async, await, etc?
  def send(to, subject, textBody, htmlBody) do
    {:ok, json} = JSX.encode %{
      "from"      => Application.get_env(:postmark, :from_email),
      "to"        => to,
      "subject"   => subject,
      "textBody"  => textBody,
      "htmlBody"  => htmlBody
    }
    response = HTTPotion.post(@endpoint, [body: json, headers: @headers])
    IO.inspect response
  end
  
end
