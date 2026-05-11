defmodule TestingElixir.CouchDB do
  use Tesla

  # http://user:pw@domain:port/

  # current design flaw is that it builds the client each time
  # i need to research GenServer's
  defp client do
    Sofa.init("http://admin:admin@localhost:5984/")
    |> Sofa.client()
    |> Sofa.connect!()
  end

  # all dbs
  # similar to rust, implicit returns
  def get_data do
    Sofa.all_dbs(client())
  end

  def create(db, doc) do
    sofa_db = Sofa.DB.open!(client(), db)

    case Sofa.Doc.put(sofa_db, doc) do
      {:ok, %Sofa.Doc{id: id}} -> {:ok, id}
      {:error, reason} -> {:error, reason}
    end
  end

  # claude helped me with this
  def get_all_docs(db) do
    case Sofa.raw(client(), "/#{db}/_all_docs?include_docs=true") do
      {:ok, _sofa, %Sofa.Response{body: body, status: 200}} -> {:ok, body}
      {:ok, _sofa, %Sofa.Response{body: body}} -> {:error, body}
      {:error, reason} -> {:error, reason}
    end
  end
end
