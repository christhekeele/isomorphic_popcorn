defmodule IsomorphicSiteWeb.PageController do
  use IsomorphicSiteWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
