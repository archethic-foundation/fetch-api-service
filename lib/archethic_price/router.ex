defmodule ArchethicPrice.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get("/api/v1/quotes/latest", to: ArchethicPrice.Route.V1.QuotesLatest)

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
