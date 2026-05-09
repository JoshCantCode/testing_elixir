defmodule TestingElixir.CouchDB do
  use Tesla

  def get_data do
    case Tesla.get(client(), "/_all_dbs") do
      {:ok, %{body: body}} -> {:ok, inspect(body)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp client do
    # configuration for the client
    # JSON makes everything return as json
    # basic auth sets the credentaials
    # url is self explanatory
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://localhost:5984"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BasicAuth, %{username: "admin", password: "admin"}}
    ]

    Tesla.client(middleware)
  end

  def create(db, doc) do
    case post(client(), "/#{db}/", doc) do
      # returns the body and the status if the status is within 200 and 299?
      # otherwise it returns an error?
      # and if it errors for whatever reason anyway then just return that
      {:ok, %{body: body, status: status}} when status in 200..299 -> {:ok, body}
      {:ok, %{body: body}} -> {:error, body}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_all_docs(db) do
    # by default _all_docs doesnt return the documents... idk why
    case get(client(), "/#{db}/_all_docs?include_docs=true") do
      {:ok, %{body: body, status: status}} when status in 200..299 -> {:ok, body}
      {:ok, %{body: body}} -> {:error, body}
      {:error, reason} -> {:error, reason}
    end
  end
end

# structs are like interfaces in TypeScript
defmodule TestingElixir.Doc do
  defstruct [:name, :age, :email]
end
