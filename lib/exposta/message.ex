defmodule ExPosta.Message do

  alias ExPosta.Message

  @from_email Application.get_env(:exposta, :from_email)
  @reply_to_email Application.get_env(:exposta, :reply_to_email)

  defstruct(
    from:         @from_email,
    to:           [],
    cc:           [],
    bcc:          [],
    subject:      "",
    tag:          "",
    html:         "",
    text:         "",
    reply_to:     @reply_to_email,
    headers:      [],
    track_opens:  true,
    attachments:  []
  )

  # There must be a built-in function to do just this...
  defp concat([]), do: ""
  defp concat([head|[]]), do: head
  defp concat([head|tail]), do: head <> "," <> concat(tail)

  def encode(msg=%Message{}) do
    # I don't like this 1-to-1 mapping of my struct to a map at all
    Poison.encode!(%{
      "From"        => msg.from,
      "To"          => concat(msg.to),
      "Cc"          => concat(msg.cc),
      "Bcc"         => concat(msg.bcc),
      "Subject"     => msg.subject,
      "Tag"         => msg.tag,
      "HtmlBody"    => msg.html,
      "TextBody"    => msg.text,
      "Reply_to"    => msg.reply_to,
      "Headers"     => msg.headers,
      "TrackOpen"   => msg.track_opens,
      "Attachments" => msg.attachments
    })
  end

  def new(text \\ "", opts \\ []) do
    msg = %Message{ "text": text }
    Keyword.take(opts, Map.keys(msg))
    |> Map.new
    |> Map.merge(msg, fn k,v,_ -> v end)
  end
end
