defmodule ProtectedHelloWeb.Guardian do
  use Guardian,
    otp_app: :protected_hello,
    permissions: %{
      keycloak: []
    }

  use Guardian.Permissions, encoding: Guardian.Permissions.TextEncoding

  require Logger

  alias ProtectedHelloWeb.UserStore

  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.

    sub = resource.email
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.

    id = claims["sub"]
    resource = UserStore.get_user_by_id(id)
    {:ok, resource}
  end

  def build_claims(claims, resource, opts) do
    Logger.info(
      "\[Building claims\]: claims: #{inspect(claims)}, resource: #{inspect(resource)}, opts: #{
        inspect(opts)
      }"
    )

    # keycloak_roles =
    #   claims
    #   |> Map.get("resource_access", %{})
    #   |> Map.get("phoenix-demo", %{})
    #   |> Map.get("roles", [])

    # new_claims = encode_permissions_into_claims!(claims, %{keycloak: keycloak_roles})

    {:ok, claims}
  end
end
