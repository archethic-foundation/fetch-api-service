defmodule ArchethicFAS.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get("/api/v1/quotes/latest", to: ArchethicFAS.Route.V1.QuotesLatest)
  get("/api/v1/quotes/history", to: ArchethicFAS.Route.V1.QuotesHistorical)

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
