defmodule TestingElixirWeb.PageLive do
  alias TestingElixir.CouchDB
  use TestingElixirWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, message: "", docs: [])}
  end

  def handle_event("get", _params, socket) do
    case CouchDB.get_data() do
      {:ok, dbs} -> {:noreply, assign(socket, message: inspect(dbs))}
      {:error, reason} -> {:noreply, assign(socket, message: "Error: #{inspect(reason)}")}
    end
  end

  def handle_event("post", _params, socket) do
    id = :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
    doc = Sofa.Doc.new(id)

    case CouchDB.create("test", %{doc | body: %{"name" => "Josh", "age" => 20, "works" => true}}) do
      {:ok, id} -> {:noreply, assign(socket, message: "Created with id: #{id}")}
      {:error, reason} -> {:noreply, assign(socket, message: "Error: #{inspect(reason)}")}
    end
  end

  def handle_event("list", _params, socket) do
    case CouchDB.get_all_docs("test") do
      {:ok, body} ->
        docs = Enum.map(body["rows"], fn row -> row["doc"] end)
        {:noreply, assign(socket, docs: docs)}

      {:error, _} ->
        {:noreply, assign(socket, message: "Failed to fetch")}
    end
  end
end
