defmodule Feelgood do
  use Plug.Router
  require Logger

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  @guestbook_dir "guestbook"

  get "/" do
    Logger.info("Got request: #{inspect(conn)}")

    index = File.read!("index.html")
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, index)
  end

  get "/guestbook" do
    output = @guestbook_dir
    |> File.ls!()
    |> Enum.sort()
    |> Enum.map(fn file ->
      [name, comment] = @guestbook_dir
      |> Path.join(file)
      |> File.read!()
      |> String.split(": ", parts: 2)

      timestamp = Path.basename(file, ".txt")
      """
      <strong>#{name}</strong><br>
      <em>#{timestamp}</em>
      <p>#{comment}</p>
      """
    end)
    |> Enum.join("<hr>")

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, output)
  end

  post "/guestbook" do
    %{
      params: %{
        "name" => name,
        "comment" => comment
      }
    } = conn

    File.mkdir_p!(@guestbook_dir)

    current_timestamp = DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()
    filename = "#{current_timestamp}.txt"

    comment_path = Path.join(@guestbook_dir, filename)

    name = name
    |> String.replace(":", "")
    |> clean_string()

    comment = clean_string(comment)
    File.write!(comment_path, "#{name}: #{comment}")

    index = File.read!("index.html")
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, index)
  end

  match _ do
    send_resp(conn, 404, "FILE NOT FOUND")
  end

  defp clean_string(dirty_string) do
    dirty_string
    |> String.replace(">", "&gt;")
    |> String.replace("<", "&lt;")
  end
end
