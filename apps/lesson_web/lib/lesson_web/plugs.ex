defmodule LessonWeb.Plugs do
  def set_locale_by_accept_language_header(conn, _opts) do
    Plug.Conn.put_session(conn, :locale, get_locale_from_accept_language_header(conn))
  end

  defp get_locale_from_accept_language_header(conn) do
    candidates =
      Plug.Conn.get_req_header(conn, "accept-language")
      |> Enum.join(",")
      |> String.split([",", ";"])

    known_locales = Gettext.known_locales(LessonWeb.Gettext)

    Enum.find(candidates, "ko", &Kernel.in(&1, known_locales))
  end
end
