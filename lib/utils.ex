defmodule CloudflareApi.Utils do
  @doc ~S"""
  Macro that makes a function public in test, private in non-test

  See:  https://stackoverflow.com/a/47598190/2062384
  """
  defmacro defp_testable(head, body \\ nil) do
    if Mix.env() == :test do
      quote do
        def unquote(head) do
          unquote(body[:do])
        end
      end
    else
      quote do
        defp unquote(head) do
          unquote(body[:do])
        end
      end
    end
  end

  @doc ~S"""
  Easy drop-in to a pipe to inspect the return value of the previous function.

  ## Examples

      conn
      |> put_status(:not_found)
      |> put_view(MalanWeb.ErrorView)
      |> render(:"404")
      |> pry_pipe()

  """
  def pry_pipe(retval, arg1 \\ nil, arg2 \\ nil, arg3 \\ nil, arg4 \\ nil) do
    require IEx
    IEx.pry()
    retval
  end

  @doc ~S"""
  Convert a map with `String` keys into a map with `Atom` keys.

  ## Examples

      iex> Malan.Utils.map_string_keys_to_atoms(%{"one" => "one", "two" => "two"})
      %{one: "one", two: "two"}m

  """
  def map_string_keys_to_atoms(map) do
    for {key, val} <- map, into: %{} do
      {String.to_atom(key), val}
    end
  end

  @doc ~S"""
  Convert a map with `String` keys into a map with `Atom` keys.

  ## Examples

      iex> Malan.Utils.map_atom_keys_to_strings(%{one: "one", two: "two"})
      %{"one" => "one", "two" => "two"}

  """
  def map_atom_keys_to_strings(map) do
    for {key, val} <- map, into: %{} do
      {Atom.to_string(key), val}
    end
  end

  @doc ~S"""
  Converts a struct to a regular map by deleting the `:__meta__` key

  ## Examples

      Malan.Utils.struct_to_map(%Something{hello: "world"})
      %{hello: "world"}

  """
  def struct_to_map(struct) do
    Map.from_struct(struct)
    |> Map.delete(:__meta__)
  end

  @doc ~S"""
  Generate a new UUIDv4

  ## Examples

      Malan.Utils.uuidgen()
      "4c2fd8d3-a6e3-4e4b-a2ce-3f21456eeb85"

  """
  def uuidgen(),
    do: Ecto.UUID.generate()

  @doc ~S"""
  Quick regex check to see if the supplied `string` is a valid UUID

  Check is done by simple regular expression and is not overly sophisticated.

  Return true || false

  ## Examples

      iex> Malan.Utils.is_uuid?(nil)
      false
      iex> Malan.Utils.is_uuid?("hello world")
      false
      iex> Malan.Utils.is_uuid?("4c2fd8d3-a6e3-4e4b-a2ce-3f21456eeb85")
      true

  """
  def is_uuid?(nil), do: false

  def is_uuid?(string),
    do: string =~ ~r/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/

  def is_uuid_or_nil?(nil), do: true
  def is_uuid_or_nil?(string), do: is_uuid?(string)

  # def nil_or_empty?(nil), do: true
  # def nil_or_empty?(str) when is_string(str), do: "" == str |> String.trim()

  @doc """
  Checks if the passed item is nil or empty string.

  The param will be passed to `to_string()`
  and then `String.trim()` and checked for empty string

  ## Examples

      iex> Malan.Utils.nil_or_empty?("hello")
      false
      iex> Malan.Utils.nil_or_empty?("")
      true
      iex> Malan.Utils.nil_or_empty?(nil)
      true

  """
  def nil_or_empty?(str_or_nil) do
    "" == str_or_nil |> to_string() |> String.trim()
  end

  @doc """
  if `value` (value of the argument) is nil, this will raise `Malan.CantBeNil`

  `argn` (name of the argument) will be passed to allow for more helpful error
  messages that tell you the name of the variable that was `nil`

  ## Examples

      iex> Malan.Utils.raise_if_nil!("somevar", "someval")
      "someval"
      iex> Malan.Utils.raise_if_nil!("somevar", nil)
      ** (Malan.CantBeNil) variable 'somevar' was nil but cannot be
          (malan 0.1.0) lib/malan/utils.ex:135: Malan.Utils.raise_if_nil!/2

  """
  def raise_if_nil!(varname, value) do
    case is_nil(value) do
      true -> raise Malan.CantBeNil, varname: varname
      false -> value
    end
  end

  @doc """
  if `value` (value of the argument) is nil, this will raise `Malan.CantBeNil`

  `argn` (name of the argument) will be passed to allow for more helpful error
  messages that tell you the name of the variable that was `nil`

  ## Examples

      iex> Malan.Utils.raise_if_nil!("someval")
      "someval"
      iex> Malan.Utils.raise_if_nil!(nil)
      ** (Malan.CantBeNil) variable 'somevar' was nil but cannot be
          (malan 0.1.0) lib/malan/utils.ex:142: Malan.Utils.raise_if_nil!/1

  """
  def raise_if_nil!(value) do
    case is_nil(value) do
      true -> raise Malan.CantBeNil
      false -> value
    end
  end

  @doc """
  Convert a map to a `String`, suitable for printing.

  Optionally pass a list of keys to mask.

  ## Examples

      iex> map_to_string(%{michael: "knight"})
      "michael: 'knight'"

      iex> map_to_string(%{michael: "knight", kitt: "karr"})
      "kitt: 'karr', michael: 'knight'"

      iex> map_to_string(%{michael: "knight", kitt: "karr"}, [:kitt])
      "kitt: '****', michael: 'knight'"

      iex> map_to_string(%{michael: "knight", kitt: "karr"}, [:kitt, :michael])
      "kitt: '****', michael: '******'"

      iex> map_to_string(%{"michael" => "knight", "kitt" => "karr", "carr" => "hart"}, ["kitt", "michael"])
      "carr: 'hart', kitt: '****', michael: '******'"

  """
  def map_to_string(map, mask_keys \\ []) do
    Map.to_list(map)
    |> Enum.map(fn {key, val} ->
      case key in list_to_strings_and_atoms(mask_keys) do
        true -> {key, String.replace(val, ~r/./, "*")}
        _ -> {key, val}
      end
    end)
    |> Enum.map(fn {key, val} -> "#{key}: '#{val}'" end)
    |> Enum.join(", ")
  end

  defp atom_or_string_to_string_or_atom(atom) when is_atom(atom) do
    Atom.to_string(atom)
  end

  defp atom_or_string_to_string_or_atom(string) when is_binary(string) do
    String.to_atom(string)
  end

  @doc """
  Takes a list of strings or atoms and returns a list with string and atoms.

  ## Examples

      iex> list_to_strings_and_atoms([:circle])
      [:circle, "circle"]

      iex> list_to_strings_and_atoms([:circle, :square])
      [:square, "square", :circle, "circle"]

      iex> list_to_strings_and_atoms(["circle", "square"])
      ["square", :square, "circle", :circle]
  """
  def list_to_strings_and_atoms(list) do
    Enum.reduce(list, [], fn l, acc -> [l | [atom_or_string_to_string_or_atom(l) | acc]] end)
  end
end

defmodule Malan.Utils.Enum do
  @doc """
  will return true if all invocations of the function return false.  If one callback returns `true`, the end result will be `false`

  `Enum.all?` will return true if all invocations of the function return
  true. `Malan.Utils.Enum.none?` is the opposite.
  """
  def none?(enum, func) do
    Enum.all?(enum, fn i -> !func.(i) end)
  end
end

defmodule Malan.Utils.Crypto do
  def strong_random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode64(padding: false)
    |> String.replace(~r{\+}, "C")
    |> String.replace(~r{/}, "z")
    |> binary_part(0, length)
  end

  def hash_password(password) do
    Pbkdf2.hash_pwd_salt(password)
  end

  def verify_password(given_pass, password_hash) do
    Pbkdf2.verify_pass(given_pass, password_hash)
  end

  def fake_verify_password() do
    Pbkdf2.no_user_verify()
  end

  def hash_token(api_token) do
    :crypto.hash(:sha256, api_token)
    |> Base.encode64()
  end
end

defmodule Malan.Utils.DateTime do
  def utc_now_trunc(),
    do: DateTime.truncate(DateTime.utc_now(), :second)

  @doc "Return a DateTime about 200 years into the future"
  def distant_future() do
    round(52.5 * 200 * 7 * 24 * 60 * 60)
    |> adjust_cur_time_trunc(:seconds)
  end

  # New implementation, needs testing
  # def distant_future(),
  #   do: adjust_cur_time(200, :years)

  @doc """
  Add the specified number of units to the current time.

  Supplying a negative number will adjust the time backwards by the
  specified units, while supplying a positive will adjust the time
  forwards by the specified units.
  """
  def adjust_cur_time(num_years, :years),
    do: adjust_cur_time(round(num_years * 52.5), :weeks)

  def adjust_cur_time(num_weeks, :weeks),
    do: adjust_cur_time(num_weeks * 7, :days)

  def adjust_cur_time(num_days, :days),
    do: adjust_cur_time(num_days * 24, :hours)

  def adjust_cur_time(num_hours, :hours),
    do: adjust_cur_time(num_hours * 60, :minutes)

  def adjust_cur_time(num_minutes, :minutes),
    do: adjust_cur_time(num_minutes * 60, :seconds)

  def adjust_cur_time(num_seconds, :seconds),
    do: adjust_time(DateTime.utc_now(), num_seconds, :seconds)

  def adjust_cur_time_trunc(num_weeks, :weeks),
    do: adjust_cur_time_trunc(num_weeks * 7, :days)

  def adjust_cur_time_trunc(num_days, :days),
    do: adjust_cur_time_trunc(num_days * 24, :hours)

  def adjust_cur_time_trunc(num_hours, :hours),
    do: adjust_cur_time_trunc(num_hours * 60, :minutes)

  def adjust_cur_time_trunc(num_minutes, :minutes),
    do: adjust_cur_time_trunc(num_minutes * 60, :seconds)

  def adjust_cur_time_trunc(num_seconds, :seconds),
    do: adjust_time(utc_now_trunc(), num_seconds, :seconds)

  def adjust_time(time, num_weeks, :weeks),
    do: adjust_time(time, num_weeks * 7, :days)

  def adjust_time(time, num_days, :days),
    do: adjust_time(time, num_days * 24, :hours)

  def adjust_time(time, num_hours, :hours),
    do: adjust_time(time, num_hours * 60, :minutes)

  def adjust_time(time, num_minutes, :minutes),
    do: adjust_time(time, num_minutes * 60, :seconds)

  def adjust_time(time, num_seconds, :seconds),
    do: DateTime.add(time, num_seconds, :second)

  @doc "Check if `past_time` occurs before `current_time`.  Equal date returns true"
  @spec in_the_past?(DateTime.t(), DateTime.t()) :: boolean()

  def in_the_past?(past_time, current_time),
    do: DateTime.compare(past_time, current_time) != :gt

  @doc "Check if `past_time` occurs before the current time"
  @spec in_the_past?(DateTime.t()) :: boolean()

  def in_the_past?(nil),
    do: raise(ArgumentError, message: "past_time time must not be nil!")

  def in_the_past?(past_time),
    do: in_the_past?(past_time, DateTime.utc_now())

  def expired?(expires_at, current_time),
    do: in_the_past?(expires_at, current_time)

  def expired?(nil),
    do: raise(ArgumentError, message: "expires_at time must not be nil!")

  def expired?(expires_at),
    do: in_the_past?(expires_at, DateTime.utc_now())
end