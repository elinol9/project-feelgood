defmodule Feelgood.Guestbook do

  @guestbook_dir "guestbook"

  def display_form do
    File.read!("index.html")
  end

  def display_guestbook do
    @guestbook_dir
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
  end

  def save_comment(name, comment) do
    File.mkdir_p!(@guestbook_dir)

    current_timestamp = DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()
    filename = "#{current_timestamp}.txt"

    comment_path = Path.join(@guestbook_dir, filename)

    name = name
    |> String.replace(":", "")
    |> clean_string()

    comment = clean_string(comment)
    File.write!(comment_path, "#{name}: #{comment}")
  end

  defp clean_string(dirty_string) do
    dirty_string
    |> String.replace(">", "&gt;")
    |> String.replace("<", "&lt;")
  end
end
