defmodule CloudflareApi.UtilsTest do
  use ExUnit.Case, async: true

  alias CloudflareApi.Utils
  alias CloudflareApi.Utils.Enum, as: EnumUtils
  alias CloudflareApi.Utils.Crypto
  alias CloudflareApi.Utils.DateTime, as: DateTimeUtils
  alias CloudflareApi.Utils.IPv4
  alias CloudflareApi.Utils.FromEnv
  alias CloudflareApi.Utils.Logger, as: LoggerUtils
  alias CloudflareApi.Utils.LoggerColor
  alias CloudflareApi.Utils.Number

  import ExUnit.CaptureLog

  defmodule SampleStruct do
    defstruct [:field]
  end

  describe "extract/process/transform" do
    test "extracts from list by index" do
      assert Utils.extract([:a, :b, :c], 1) == :b
    end

    test "extracts from tuple by index" do
      assert Utils.extract({:a, :b, :c}, 2) == :c
    end

    test "extracts from struct by atom or string key" do
      s = %SampleStruct{field: 42}
      assert Utils.extract(s, :field) == 42
      assert Utils.extract(s, "field") == 42
    end

    test "extracts from access-type map" do
      map = %{"bar" => 2, foo: 1}
      assert Utils.extract(map, :foo) == 1
      assert Utils.extract(map, "bar") == 2
    end

    test "extracts using function" do
      assert Utils.extract(%{a: 2}, fn m -> m.a * 2 end) == 4
    end

    test "process/2 and transform/2 delegate to extract/2" do
      map = %{v: 10}
      assert Utils.process(map, :v) == 10
      assert Utils.transform(map, :v) == 10
    end
  end

  describe "inspect helpers" do
    test "inspect_syntax_colors/0 returns expected keys" do
      colors = Utils.inspect_syntax_colors()
      assert Keyword.get(colors, :number) == :yellow
      assert Keyword.get(colors, :atom) == :cyan
    end

    test "inspect_format/2 builds options list" do
      opts = Utils.inspect_format(false, 10)
      assert Keyword.get(opts, :structs) == false
      assert Keyword.get(opts, :limit) == 10
      assert Keyword.get(opts, :width) == 80
    end

    test "inspect/3 returns a string representation" do
      s = Utils.inspect(%{a: 1}, true, 5)
      assert is_binary(s)
      assert String.contains?(s, "a")
    end
  end

  describe "map and list utilities" do
    test "map_string_keys_to_atoms/1 converts keys" do
      assert Utils.map_string_keys_to_atoms(%{"one" => 1, "two" => 2}) == %{one: 1, two: 2}
    end

    test "map_atom_keys_to_strings/1 converts keys" do
      assert Utils.map_atom_keys_to_strings(%{one: 1, two: 2}) == %{"one" => 1, "two" => 2}
    end

    test "struct_to_map/2 removes __meta__ and masks keys" do
      s = %SampleStruct{field: "secret"}
      map = Utils.struct_to_map(s, [:field])
      assert map == %{field: "******"}
    end

    test "mask_map_key_values/2 masks requested keys" do
      map = %{name: "Ben", age: 39}
      masked = Utils.mask_map_key_values(map, [:age])
      assert masked.name == "Ben"
      assert masked.age == "**"
    end

    test "uuid?/1 and uuid_or_nil?/1 behave correctly" do
      refute Utils.uuid?(nil)
      refute Utils.uuid?("hello")
      assert Utils.uuid?("4c2fd8d3-a6e3-4e4b-a2ce-3f21456eeb85")

      assert Utils.uuid_or_nil?(nil)
      assert Utils.uuid_or_nil?("4c2fd8d3-a6e3-4e4b-a2ce-3f21456eeb85")
      refute Utils.uuid_or_nil?("nope")
    end

    test "nil_or_empty?/1 and not_nil_or_empty?/1" do
      refute Utils.nil_or_empty?("hello")
      assert Utils.nil_or_empty?("")
      assert Utils.nil_or_empty?(nil)

      assert Utils.not_nil_or_empty?("hello")
      refute Utils.not_nil_or_empty?("")
      refute Utils.not_nil_or_empty?(nil)
    end

    test "raise_if_nil!/2 raises for nil" do
      assert Utils.raise_if_nil!("var", "value") == "value"

      assert_raise CloudflareApi.CantBeNil, fn ->
        Utils.raise_if_nil!("var", nil)
      end
    end

    test "raise_if_nil!/1 raises for nil" do
      assert Utils.raise_if_nil!("value") == "value"

      assert_raise CloudflareApi.CantBeNil, fn ->
        Utils.raise_if_nil!(nil)
      end
    end

    test "mask_str/1 handles nil, string, and other values" do
      assert Utils.mask_str(nil) == nil
      assert Utils.mask_str("abcd") == "****"
      assert Utils.mask_str(123) == "***"
    end

    test "list_to_string/2 stringifies and masks nested values" do
      list = [%{secret: "value"}, {:ok, "fine"}, 42]
      s = Utils.list_to_string(list, [:secret])
      assert String.contains?(s, "secret: '*****'")
      assert String.contains?(s, "ok, fine")
      assert String.contains?(s, "42")
    end

    test "tuple_to_string/2 handles key/value and plain tuples" do
      s1 = Utils.tuple_to_string({:password, "secret"}, [:password])
      assert s1 == "password, ******"

      s2 = Utils.tuple_to_string({1, 2, 3}, [])
      assert s2 == "1, 2, 3"
    end

    test "map_to_string/2 formats and masks map entries" do
      s = Utils.map_to_string(%{michael: "knight", kitt: "karr"}, [:kitt])
      assert String.contains?(s, "michael: 'knight'")
      assert String.contains?(s, "kitt: '****'")
    end

    test "map_to_string/2 falls back to Kernel.to_string/1 when not a map" do
      assert Utils.map_to_string(123, []) == "123"
    end

    test "to_string/2 delegates based on type" do
      assert Utils.to_string(%{a: "b"}, []) =~ "a: 'b'"
      assert Utils.to_string([1, 2], []) == "1, 2"
      assert Utils.to_string({1, 2}, []) == "1, 2"
      assert Utils.to_string(5, []) == "5"
    end

    test "list_to_strings_and_atoms/1 expands atoms and strings" do
      result = Utils.list_to_strings_and_atoms([:circle, "square"])
      assert :circle in result
      assert "circle" in result
      assert :square in result
      assert "square" in result
    end

    test "trunc_str/2 truncates strings" do
      assert Utils.trunc_str("abcdef", 3) == "abc"
      assert Utils.trunc_str("short") == "short"
    end
  end

  describe "explicit boolean helpers" do
    test "explicitly_true?/1" do
      assert Utils.explicitly_true?("t")
      assert Utils.explicitly_true?("TRUE")
      refute Utils.explicitly_true?("no")
    end

    test "explicitly_false?/1" do
      assert Utils.explicitly_false?("f")
      assert Utils.explicitly_false?("FALSE")
      refute Utils.explicitly_false?("yes")
    end

    test "false_or_explicitly_true?/1" do
      assert Utils.false_or_explicitly_true?("true")
      refute Utils.false_or_explicitly_true?("no")
      assert Utils.false_or_explicitly_true?(true)
      refute Utils.false_or_explicitly_true?(false)
    end

    test "true_or_explicitly_false?/1" do
      refute Utils.true_or_explicitly_false?("false")
      assert Utils.true_or_explicitly_false?("yes")
      assert Utils.true_or_explicitly_false?(nil)
      assert Utils.true_or_explicitly_false?(true)
      refute Utils.true_or_explicitly_false?(false)
    end
  end

  describe "Enum utils" do
    test "none?/2 returns true when predicate is false for all" do
      assert EnumUtils.none?([1, 2, 3], fn i -> i > 10 end)
    end

    test "none?/2 returns false when predicate is true for any" do
      refute EnumUtils.none?([1, 2, 3], fn i -> i == 2 end)
    end
  end

  describe "Crypto utils" do
    test "strong_random_string/1 returns correct length and charset" do
      s = Crypto.strong_random_string(32)
      assert String.length(s) == 32
      assert Regex.match?(~r/^[A-Za-z0-9Cz]+$/, s)
    end

    test "hash_token/1 is deterministic" do
      h1 = Crypto.hash_token("secret")
      h2 = Crypto.hash_token("secret")
      h3 = Crypto.hash_token("other")
      assert h1 == h2
      refute h1 == h3
    end
  end

  describe "DateTime utils" do
    test "utc_now_trunc/0 has second precision" do
      t = DateTimeUtils.utc_now_trunc()
      assert t.microsecond == {0, 0}
    end

    test "adjust_time/3 adds the correct number of seconds" do
      now = DateTime.utc_now()
      later = DateTimeUtils.adjust_time(now, 120, :seconds)
      assert DateTime.diff(later, now, :second) == 120
    end

    test "in_the_past?/2 compares correctly" do
      now = DateTime.utc_now()
      earlier = DateTime.add(now, -10, :second)
      later = DateTime.add(now, 10, :second)

      assert DateTimeUtils.in_the_past?(earlier, now)
      refute DateTimeUtils.in_the_past?(later, now)
      assert DateTimeUtils.in_the_past?(now, now)
    end

    test "in_the_past?/1 raises on nil" do
      assert_raise ArgumentError, fn ->
        DateTimeUtils.in_the_past?(nil)
      end
    end

    test "expired?/2 and expired?/1 behave as wrappers" do
      now = DateTime.utc_now()
      earlier = DateTime.add(now, -10, :second)
      later = DateTime.add(now, 10, :second)

      assert DateTimeUtils.expired?(earlier, now)
      refute DateTimeUtils.expired?(later, now)

      assert DateTimeUtils.expired?(earlier)
      refute DateTimeUtils.expired?(later)
    end

    test "expired?/1 raises on nil" do
      assert_raise ArgumentError, fn ->
        DateTimeUtils.expired?(nil)
      end
    end
  end

  describe "IPv4 utils" do
    test "to_s/1 converts tuple to dotted string" do
      assert IPv4.to_s({127, 0, 0, 1}) == "127.0.0.1"
    end
  end

  describe "FromEnv utils" do
    test "log_str/1 formats module and function" do
      env = __ENV__
      s = FromEnv.log_str(env)
      assert String.starts_with?(s, "[")
      assert String.contains?(s, "CloudflareApi.UtilsTest")
    end

    test "mfa_str/1 and func_str/1 format correctly" do
      env = __ENV__
      mfa = FromEnv.mfa_str(env)
      assert String.contains?(mfa, "CloudflareApi.UtilsTest.")

      assert FromEnv.func_str({:my_fun, 2}) == "#my_fun/2"
    end
  end

  describe "Logger and LoggerColor utils" do
    test "LoggerColor helpers return atoms" do
      assert LoggerColor.green() == :green
      assert LoggerColor.red() == :red
      assert LoggerColor.debug() == :cyan
    end

    test "Logger wrappers emit logs" do
      log =
        capture_log(fn ->
          LoggerUtils.info("info message")
          LoggerUtils.error(__ENV__, "error with env")
          LoggerUtils.trace("trace message")
        end)

      assert String.contains?(log, "info message")
      assert String.contains?(log, "error with env")
      assert String.contains?(log, "[trace]: trace message")
    end
  end

  describe "CantBeNil exception" do
    test "exception/1 builds message with varname" do
      ex = CloudflareApi.CantBeNil.exception(varname: "myvar")
      assert ex.message == "variable 'myvar' was nil but cannot be"
    end

    test "exception/1 builds default message" do
      ex = CloudflareApi.CantBeNil.exception([])
      assert ex.message == "value was set to nil but cannot be"
    end
  end

  describe "Number utils" do
    test "format/2 and format_us/2 format numbers" do
      assert Number.format(1000) == "1,000"
      assert Number.format(1000.5) == "1,000.50"
      assert Number.format_us(1000) == "1,000"
    end

    test "format_intl/2 formats using international style" do
      assert Number.format_intl(1000) == "1,000"
      assert Number.format_intl(1000.5) == "1,000,50"
    end

    test "internal option helpers are exposed in test via defp_testable" do
      assert Number.get_int_opts([])[:delimit] == ","
      assert Number.get_float_opts([])[:precision] == 2
      assert Number.get_intl_int_opts([])[:delimit] == "."
      assert Number.get_intl_float_opts([])[:separator] == ","
    end
  end
end
