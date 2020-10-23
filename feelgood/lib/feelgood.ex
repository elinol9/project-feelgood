defmodule Feelgood do
  use Plug.Router
  require Logger
  alias Feelgood.Guestbook

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch



  get "/" do
    Logger.info("Got request: #{inspect(conn)}")

    form = Guestbook.display_form()
    guestbook = Guestbook.display_guestbook()

    index = form <> guestbook
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

    host = get_req_header(conn, "host")
    IO.inspect(host, label: "host")
    Guestbook.save_comment(name, comment)
    conn
    |> put_resp_header("location", "http://#{host}/")
    |> send_resp(302, "Found")
  end

  match _ do
    send_resp(conn, 404, "FILE NOT FOUND")
  end

end
