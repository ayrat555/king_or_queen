defmodule KingOrQueen.Player do
  alias KingOrQueen.Crypto

  @allowed_cards ["King", "Queen"]
  @alice_table :alice_table
  @bob_table :bob_table

  def choose_card() do
    choosed_card = prompt_task("Choose card (King or Queen):")

    sign_card(choosed_card)
  end

  def guess_card(result_signature) do
    guessed_card = prompt_task("Guess card (King or Queen):")

    save_key_value_to_cache(@bob_table, result_signature, guessed_card)

    {result_signature, guessed_card}
  end

  def public_key(result_signature, guessed_card) do
    {:ok, public_key} = fetch_value_from_cache(@alice_table, result_signature)

    if Crypto.auth_message(guessed_card, result_signature, public_key) do
      IO.puts("You lost\n")
    else
      IO.puts("You won\n")
    end

    public_key
  end

  def check_guess(result_signature, public_key) do
    {:ok, guess} = fetch_value_from_cache(@bob_table, result_signature)

    Crypto.auth_message(guess, result_signature, public_key)
  end

  defp prompt_task(message) do
    task = Task.async(fn -> prompt(message) end)

    Task.await(task, :infinity)
  end

  defp prompt(message) do
    result =
      "#{message}\n"
      |> IO.gets()
      |> String.replace("\n", "")

    if result in @allowed_cards do
      result
    else
      prompt(message)
    end
  end

  defp sign_card(card) do
    {signature, _private_key, public_key} = Crypto.sign_message(card)

    save_key_value_to_cache(@alice_table, signature, public_key)

    signature
  end

  defp save_key_value_to_cache(table_name, key, value) do
    if :ets.whereis(table_name) == :undefined do
      :ets.new(table_name, [
        :set,
        :named_table,
        :public,
        write_concurrency: true
      ])
    end

    :ets.insert(table_name, {key, value})
  end

  defp fetch_value_from_cache(table_name, key) do
    case :ets.lookup(table_name, key) do
      [{^key, value}] -> {:ok, value}
      _ -> :not_found
    end
  end
end
