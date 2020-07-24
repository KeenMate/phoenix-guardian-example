defmodule ProtectedHelloWeb.Auth.EnsureRolesPlug do
  import Plug.Conn

  require Logger

  @spec init(Keyword.t()) :: %{roles: [String.t()], operation: atom()}
  def init(opts) do
    %{
      roles: Keyword.get(opts, :roles, []) |> Enum.map(&normalize_role/1),
      operation: Keyword.get(opts, :op, :and)
    }
  end

  def call(conn, %{roles: []}) do
    conn
  end

  def call(conn, %{roles: roles, operation: op}) do
    extracted_roles =
      Guardian.Plug.current_claims(conn)
      |> get_in(["resource_access", "phoenix-demo", "roles"])

    Logger.info(
      "Extracted roles: #{inspect(extracted_roles)}. Roles to ensure: #{inspect(roles)}"
    )

    extracted_roles
    |> check_roles(op, roles)
    |> handle_authorization(conn, extracted_roles)
  end

  defp handle_authorization(true, conn, extracted_roles) do
    conn
    |> assign(:user_roles, extracted_roles)
  end

  defp handle_authorization(false, conn, _extracted_roles) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(403, "FORBIDDEN")
    |> halt()
  end

  defp check_roles(current_roles, op, roles) do
    check_roles(current_roles, nil, op, roles)
  end

  defp check_roles(_current_roles, true, _op, []), do: true

  defp check_roles(_current_roles, _acc, _op, []) do
    false
  end

  defp check_roles(_current_roles, false, :and, _roles_to_check), do: false

  defp check_roles(current_roles, acc, :and, [role_to_check | other_roles_to_check])
       when acc in [nil, true] do
    check_roles(
      current_roles,
      normalize_role(role_to_check) in current_roles,
      :and,
      other_roles_to_check
    )
  end

  defp check_roles(_current_roles, true, :or, _roles_to_check) do
    true
  end

  defp check_roles(current_roles, acc, :or, [role_to_check | other_roles_to_check])
       when acc in [nil, false] do
    check_roles(
      current_roles,
      normalize_role(role_to_check) in current_roles,
      :or,
      other_roles_to_check
    )
  end

  def normalize_role(role) when is_atom(role) do
    Atom.to_string(role)
    |> String.downcase()
  end

  def normalize_role(role) when is_bitstring(role) do
    role
    |> String.downcase()
  end
end
