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
end
