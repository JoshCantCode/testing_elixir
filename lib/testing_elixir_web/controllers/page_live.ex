defmodule TestingElixirWeb.PageLive do
  alias TestingElixir.CouchDB
  use TestingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, data: "")}
  end

  def render(assigns) do
    # renders html
    ~H"""
    <div>
      hi <button type="button" phx-click="click">click here</button>
      <%= @data %>
    </div>
    """
  end

  def handle_event("click", _params, socket) do
    # similar to rust
    # :ok returns the right result if the function goes through, but if it fails it returns the error as well as the reason
    # inspect is just the equivalent of print in this i think...
    # and idk what assign is, or noreply

    data =
      case CouchDB.get_data() do
        {:ok, result} -> result
        {:error, reason} -> "Error: #{inspect(reason)}"
      end

    {:noreply, assign(socket, data: data)}
  end
end
