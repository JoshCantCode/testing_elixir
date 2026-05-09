defmodule TestingElixirWeb.PageLive do
  alias TestingElixir.CouchDB
  alias TestingElixir.Doc
  use TestingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, message: "", docs: [])}
  end

  def handle_event("get", _params, socket) do
    # similar to rust
    # :ok returns the right result if the function goes through, but if it fails it returns the error as well as the reason
    # inspect is just the equivalent of print in this i think...

    # noreply just tells the server that its not a client side update, because phoenix updates on its own anyway
    # assign is like useState

    data =
      case CouchDB.get_data() do
        {:ok, result} -> result
        {:error, reason} -> "Error: #{inspect(reason)}"
      end

    {:noreply, assign(socket, message: data)}
  end

  def handle_event("post", _params, socket) do
    case CouchDB.create("test", %{"name" => "Josh", "age" => 20}) do
      {:ok, result} ->
        {:noreply, assign(socket, message: "Created with id: #{result["id"]}")}

      {:error, reason} ->
        {:noreply, assign(socket, message: "Error: #{inspect(reason)}")}
    end
  end

  def handle_event("list", _params, socket) do
    case CouchDB.get_all_docs("test") do
      {:ok, result} ->
        # all the documents live in this
        rows = result["rows"]

        docs =
          Enum.map(rows, fn row ->
            doc = row["doc"]

            %Doc{name: doc["name"], age: doc["age"], email: "N/A"}
          end)

        {:noreply, assign(socket, docs: docs)}

      {:error, reason} ->
        {:noreply, assign(socket, message: "Error: #{inspect(reason)}")}
    end
  end
end
