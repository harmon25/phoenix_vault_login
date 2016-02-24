defmodule VaultLogin do
  import Poison, only: [encode!: 1, decode!: 1]
  @authEndPoint "/v1/auth/userpass/login/"
  @testEndPoint "/v1/auth/token/lookup-self"
  @errMsg {:err, "Invalid request, missing or invalid data." }

  def auth(username, password) do
    System.get_env("VAULT_ADDR")
    |> genAuthRequest(username, password)
    |> sendRequest
    |> authResponse
  end

  def checkToken(token) do
    System.get_env("VAULT_ADDR")
    |> genCheckRequest(token)
    |> sendRequest
    |> checkResponse
  end
  
  defp genCheckRequest(vaultAddr, token) when is_bitstring(vaultAddr) and is_bitstring(token)  do
      {:ok,
      %{
        method: :get,
        url: vaultAddr <> @testEndPoint,
        payload: "",
        headers: [{"Content-Type", 'application/json'}, {"X-Vault-Token", token}]
       }
     }
  end
  defp genCheckRequest(vaultAddr, _) when is_nil(vaultAddr), do: {:err, "VAULT_ADDR Environment Variable not set"}
  defp genCheckRequest(_, _token), do: {:err, "Invalid token"}

  defp checkResponse({:ok, responseCode, _, clientRef}) do
     case responseCode do
      200 ->
         {:ok, respBody} = :hackney.body(clientRef)
         {:ok, decode!(respBody) |> Map.get("data") }
      403 ->
        @errMsg
      400 ->
        @errMsg
      500 ->
        @errMsg
      end
  end

  defp genAuthRequest(vaultAddr, username, password) when is_bitstring(vaultAddr) and is_bitstring(username) and is_bitstring(password) do
    {:ok,
    %{
      method: :post,
      url: vaultAddr <> @authEndPoint <> username,
      payload: encode!(%{username: username, password: password}),
      headers: [{"Content-Type", 'application/json'}]
     }
   }
  end
  defp genAuthRequest(vaultAddr, _, _) when is_nil(vaultAddr), do: {:err, "VAULT_ADDR Environment Variable not set"}
  defp genAuthRequest(_, _username, _password), do: {:err, "username or passord invalid"}


  defp sendRequest({:ok, request}) do
    :hackney.request(request.method,
                    request.url,
                    request.headers,
                    request.payload,
                    [])
  end
  defp sendRequest({:err, msg}), do: {:err, msg}

  defp authResponse({:ok, responseCode, _, clientRef}) do
    case responseCode do
      200 ->
        {:ok, respBody} = :hackney.body(clientRef)
        {:ok, decode!(respBody) |> Map.get("auth") }
      400 ->
        @errMsg
      500 ->
        @errMsg
    end

  end

end
