defmodule KingOrQueen.Crypto do
  def sign_message(message) do
    private_key = generate_private_key()
    public_key = derive_public_key_from_private_key(private_key)

    signature = do_sign_message(message, private_key)

    {signature, private_key, public_key}
  end

  def auth_message(message, signature, public_key) do
    {:ok, result} = ExPublicKey.verify(message, signature, public_key)

    result
  end

  defp generate_private_key do
    {:ok, rsa_priv_key} = ExPublicKey.generate_key()

    rsa_priv_key
  end

  defp derive_public_key_from_private_key(private_key) do
    {:ok, public_key} = ExPublicKey.public_key_from_private_key(private_key)

    public_key
  end

  defp do_sign_message(message, private_key) do
    {:ok, signature} = ExPublicKey.sign(message, private_key)

    signature
  end
end
