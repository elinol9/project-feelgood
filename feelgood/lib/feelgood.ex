defmodule Feelgood do
  use Plug.Router
  require Logger

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  get "/" do
    Logger.info("Got request: #{inspect(conn)}")

    index = File.read!("index.html")
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, index)
  end

  post "/guestbook" do
    %{
      params: %{
        "name" => name,
        "comment" => comment
      }
    } = conn

    dir = "guestbook"
    File.mkdir_p!(dir)

    current_timestamp = DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()
    filename = "#{current_timestamp}.txt"

    comment_path = Path.join(dir, filename)

    File.write!(comment_path, "#{name}: #{comment}")

    index = File.read!("index.html")
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, index)
  end

  match _ do
    send_resp(conn, 404, "FILE NOT FOUND")
  end
end
