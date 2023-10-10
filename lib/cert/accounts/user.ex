defmodule Cert.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cert.Repo
  import Ecto.Query, warn: false

  schema "users" do
    field :email, :string
    field :firstname, :string
    field :lastname, :string
    field :password_hash, :string
    field :status, :string, default: "active"
    field :user_type, :string, default: "regular"
    field :username, :string
    #virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(email firstname lastname password status user_type username)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required([:firstname, :lastname, :email, :username, :user_type, :status, :password])
    |> validate_common_fields()
    |> validate_confirmation(:password)
    |> validate_email()
    |> check_email_exists()
    |> encrypt_password()
  end

  def update_profile(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required([:firstname, :lastname, :email, :username, :password, :status])
    |> validate_common_fields()
    |> validate_confirmation(:password)
    |> validate_email()
    |> check_email_exists()
    |> encrypt_password()
  end

  def update_status(user, attrs) do
    user
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> validate_format(:status, ~r/^[a-zA-Z]+$/, message: "cannot contain whitespace and must consist of letters")
  end


  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end

  defp validate_common_fields(changeset) do
    changeset
    |> validate_length(:firstname, min: 2, max: 20)
    |> validate_length(:lastname, min: 2, max: 20)
    |> validate_length(:username, min: 2, max: 20)
    |> validate_format(:firstname, ~r/^[a-zA-Z]+$/, message: "cannot contain whitespace and must consist of letters")
    |> validate_format(:lastname, ~r/^[a-zA-Z]+$/, message: "cannot contain whitespace and must consist of letters")
    |> validate_format(:username, ~r/^[a-zA-Z]+$/, message: "cannot contain whitespace and must consist of letters")
  end

  defp check_email_exists(changeset) do
    case get_change(changeset, :email) do
      nil -> changeset
      email ->
        query = from(u0 in Cert.Accounts.User,
             where: u0.email == ^email)
        case Repo.one(query) do
          nil -> changeset
          _ -> add_error(changeset, :email, "Email already exists")
        end
    end
  end


  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        password_hash = Pbkdf2.hash_pwd_salt(password)
        put_change(changeset, :password_hash, password_hash)
      _ ->
        changeset
    end
  end











end
