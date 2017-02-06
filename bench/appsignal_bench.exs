defmodule Bench do
  use Benchfella
  import Appsignal.Instrumentation.Helpers, only: [instrument: 4]

  bench "bench" do
    {:ok, _} = Application.ensure_all_started(:appsignal)

    transaction = Appsignal.Transaction.start(
      Appsignal.Transaction.generate_id,
      :http_request
    )
    |> Appsignal.Transaction.set_action("HomeController#hello")


    instrument(transaction, "template.render", "Rendering something slow", fn() ->
      instrument(transaction, "ecto.query", "Query", fn() ->
        for _ <- 0..10  do 
          instrument(transaction, "ecto.query", "Nested query", fn() -> :ok end)
        end
      end)
      instrument(transaction, "template.render", "Rendering template", fn() ->
        for _ <- 0..5  do 
          instrument(transaction, "template.render", "Rendering partial", fn() ->
            for _ <- 0..3  do 
              instrument(transaction, "cache.read", "Read from cache", fn() -> :ok end)
            end
          end)
        end
      end)
    end)

    Appsignal.Transaction.finish(transaction)
    :ok = Appsignal.Transaction.complete(transaction)
  end
end
