defmodule Bench do
  use Benchfella

  bench "bench" do
    {:ok, _} = Application.ensure_all_started(:appsignal)

    transaction = Appsignal.Transaction.start(
      Appsignal.Transaction.generate_id,
      :http_request
    )

    ^transaction = Appsignal.Transaction.finish_event(
      transaction,
      "name",
      "title",
      %{number: :rand.uniform(1000000)},
      1
    )

    Appsignal.Transaction.finish(transaction)
    :ok = Appsignal.Transaction.complete(transaction)
  end
end
