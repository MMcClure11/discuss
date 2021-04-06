defmodule Discuss.Plugs.RequireAuth do 
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Router.Helpers

  def init(_params)do
  end

  def call(conn, _params) do 
    if conn.assigns[:user] do 
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.topic_path(conn, :index)) #must use Helpers.topic_path because we are not doing the same setup with use Discuss.Web
      |> halt() #do nothing else, do not continue on to the next plug in the pipeline
    end
  end
end