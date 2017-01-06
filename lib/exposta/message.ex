defmodule ExPosta.Message do

  alias ExPosta.Message

  defstruct(
    from:         Application.get_env(:exposta, :from_email),
    to:           [],
    cc:           [],
    bcc:          [],
    subject:      "",
    tag:          "",
    html:         "",
    text:         "",
    reply_to:     Application.get_env(:exposta, :reply_to_email),
    headers:      [],
    track_opens:  true,
    attachments:  []
  )

  def new(opts \\ []) do
    msg = %Message{}
    Keyword.take(opts, Map.keys(msg))
    |> Map.new
    |> Map.merge(msg, fn _,v,_ -> v end)
  end
end

defimpl Poison.Encoder, for: ExPosta.Message do

  alias Poison.Encoder
  alias ExPosta.Message

  # There must be a built-in function to do just this...
  defp concat([]), do: ""
  defp concat([head|[]]), do: head
  defp concat([head|tail]), do: head <> "," <> concat(tail)

  def encode(msg=%Message{}, options) do
    Encoder.encode(%{
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
    }, options)
  end
end
