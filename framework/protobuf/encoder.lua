local var0_0 = string
local var1_0 = table
local var2_0 = ipairs
local var3_0 = assert
local var4_0 = uint64
local var5_0 = type
local var6_0 = require("pb")
local var7_0 = require("wire_format")

module("encoder")

function _VarintSize(arg0_1)
	if arg0_1 <= 127 then
		return 1
	end

	if arg0_1 <= 16383 then
		return 2
	end

	if arg0_1 <= 2097151 then
		return 3
	end

	if arg0_1 <= 268435455 then
		return 4
	end

	return 5
end

function _SignedVarintSize(arg0_2)
	if arg0_2 < 0 then
		return 10
	end

	if arg0_2 <= 127 then
		return 1
	end

	if arg0_2 <= 16383 then
		return 2
	end

	if arg0_2 <= 2097151 then
		return 3
	end

	if arg0_2 <= 268435455 then
		return 4
	end

	return 5
end

function _VarintSize64(arg0_3)
	local var0_3 = 0
	local var1_3 = 0

	if var5_0(arg0_3) == "number" then
		var1_3 = arg0_3
	else
		var1_3, var0_3 = var4_0.new(arg0_3):tonum2()
	end

	if var0_3 == 0 then
		if var1_3 <= 127 then
			return 1
		end

		if var1_3 <= 16383 then
			return 2
		end

		if var1_3 <= 2097151 then
			return 3
		end

		if var1_3 <= 268435455 then
			return 4
		end

		return 5
	else
		if var0_3 <= 7 then
			return 5
		end

		if var0_3 <= 1023 then
			return 6
		end

		if var0_3 <= 131071 then
			return 7
		end

		if var0_3 <= 16777215 then
			return 8
		end

		if var0_3 <= 2147483647 then
			return 9
		end

		return 10
	end
end

function _SignedVarintSize64(arg0_4)
	local var0_4 = 0
	local var1_4 = 0
	local var2_4 = 0

	if var5_0(arg0_4) == "number" then
		var2_4 = arg0_4
		var0_4 = arg0_4 < 0 and 1 or 0
	else
		var2_4, var1_4 = int64.new(arg0_4):tonum2()
		var0_4 = var1_4 > 2147483647 and 1 or 0
	end

	if var0_4 == 1 then
		return 10
	end

	if var1_4 == 0 then
		if var2_4 <= 127 then
			return 1
		end

		if var2_4 <= 16383 then
			return 2
		end

		if var2_4 <= 2097151 then
			return 3
		end

		if var2_4 <= 268435455 then
			return 4
		end

		return 5
	else
		if var1_4 <= 7 then
			return 5
		end

		if var1_4 <= 1023 then
			return 6
		end

		if var1_4 <= 131071 then
			return 7
		end

		if var1_4 <= 16777215 then
			return 8
		end

		if var1_4 <= 2147483647 then
			return 9
		end

		return 10
	end
end

function _TagSize(arg0_5)
	return _VarintSize(var7_0.PackTag(arg0_5, 0))
end

function _SimpleSizer(arg0_6)
	return function(arg0_7, arg1_7, arg2_7)
		local var0_7 = _TagSize(arg0_7)

		if arg2_7 then
			local var1_7 = _VarintSize

			return function(arg0_8)
				local var0_8 = 0

				for iter0_8, iter1_8 in var2_0(arg0_8) do
					var0_8 = var0_8 + arg0_6(iter1_8)
				end

				return var0_8 + var1_7(var0_8) + var0_7
			end
		elseif arg1_7 then
			return function(arg0_9)
				local var0_9 = var0_7 * #arg0_9

				for iter0_9, iter1_9 in var2_0(arg0_9) do
					var0_9 = var0_9 + arg0_6(iter1_9)
				end

				return var0_9
			end
		else
			return function(arg0_10)
				return var0_7 + arg0_6(arg0_10)
			end
		end
	end
end

function _ModifiedSizer(arg0_11, arg1_11)
	return function(arg0_12, arg1_12, arg2_12)
		local var0_12 = _TagSize(arg0_12)

		if arg2_12 then
			local var1_12 = _VarintSize

			return function(arg0_13)
				local var0_13 = 0

				for iter0_13, iter1_13 in var2_0(arg0_13) do
					var0_13 = var0_13 + arg0_11(arg1_11(iter1_13))
				end

				return var0_13 + var1_12(var0_13) + var0_12
			end
		elseif arg1_12 then
			return function(arg0_14)
				local var0_14 = var0_12 * #arg0_14

				for iter0_14, iter1_14 in var2_0(arg0_14) do
					var0_14 = var0_14 + arg0_11(arg1_11(iter1_14))
				end

				return var0_14
			end
		else
			return function(arg0_15)
				return var0_12 + arg0_11(arg1_11(arg0_15))
			end
		end
	end
end

function _FixedSizer(arg0_16)
	return function(arg0_17, arg1_17, arg2_17)
		local var0_17 = _TagSize(arg0_17)

		if arg2_17 then
			local var1_17 = _VarintSize

			return function(arg0_18)
				local var0_18 = #arg0_18 * arg0_16

				return var0_18 + var1_17(var0_18) + var0_17
			end
		elseif arg1_17 then
			local var2_17 = arg0_16 + var0_17

			return function(arg0_19)
				return #arg0_19 * var2_17
			end
		else
			local var3_17 = arg0_16 + var0_17

			return function(arg0_20)
				return var3_17
			end
		end
	end
end

Int32Sizer = _SimpleSizer(_SignedVarintSize)
Int64Sizer = _SimpleSizer(_SignedVarintSize64)
EnumSizer = Int32Sizer
UInt32Sizer = _SimpleSizer(_VarintSize)
UInt64Sizer = _SimpleSizer(_VarintSize64)
SInt32Sizer = _ModifiedSizer(_VarintSize, var7_0.ZigZagEncode32)
SInt64Sizer = _ModifiedSizer(_VarintSize64, var7_0.ZigZagEncode32)
Fixed32Sizer = _FixedSizer(4)
SFixed32Sizer = Fixed32Sizer
FloatSizer = Fixed32Sizer
Fixed64Sizer = _FixedSizer(8)
SFixed64Sizer = Fixed64Sizer
DoubleSizer = Fixed64Sizer
BoolSizer = _FixedSizer(1)

function StringSizer(arg0_21, arg1_21, arg2_21)
	local var0_21 = _TagSize(arg0_21)
	local var1_21 = _VarintSize

	var3_0(not arg2_21)

	if arg1_21 then
		return function(arg0_22)
			local var0_22 = var0_21 * #arg0_22

			for iter0_22, iter1_22 in var2_0(arg0_22) do
				local var1_22 = #iter1_22

				var0_22 = var0_22 + var1_21(var1_22) + var1_22
			end

			return var0_22
		end
	else
		return function(arg0_23)
			local var0_23 = #arg0_23

			return var0_21 + var1_21(var0_23) + var0_23
		end
	end
end

function BytesSizer(arg0_24, arg1_24, arg2_24)
	local var0_24 = _TagSize(arg0_24)
	local var1_24 = _VarintSize

	var3_0(not arg2_24)

	if arg1_24 then
		return function(arg0_25)
			local var0_25 = var0_24 * #arg0_25

			for iter0_25, iter1_25 in var2_0(arg0_25) do
				local var1_25 = #iter1_25

				var0_25 = var0_25 + var1_24(var1_25) + var1_25
			end

			return var0_25
		end
	else
		return function(arg0_26)
			local var0_26 = #arg0_26

			return var0_24 + var1_24(var0_26) + var0_26
		end
	end
end

function MessageSizer(arg0_27, arg1_27, arg2_27)
	local var0_27 = _TagSize(arg0_27)
	local var1_27 = _VarintSize

	var3_0(not arg2_27)

	if arg1_27 then
		return function(arg0_28)
			local var0_28 = var0_27 * #arg0_28

			for iter0_28, iter1_28 in var2_0(arg0_28) do
				local var1_28 = iter1_28:ByteSize()

				var0_28 = var0_28 + var1_27(var1_28) + var1_28
			end

			return var0_28
		end
	else
		return function(arg0_29)
			local var0_29 = arg0_29:ByteSize()

			return var0_27 + var1_27(var0_29) + var0_29
		end
	end
end

local var8_0 = var6_0.varint_encoder
local var9_0 = var6_0.signed_varint_encoder
local var10_0 = var6_0.varint_encoder64
local var11_0 = var6_0.signed_varint_encoder64

function _VarintBytes(arg0_30)
	local var0_30 = {}

	local function var1_30(arg0_31)
		var0_30[#var0_30 + 1] = arg0_31
	end

	var9_0(var1_30, arg0_30)

	return var1_0.concat(var0_30)
end

function TagBytes(arg0_32, arg1_32)
	return _VarintBytes(var7_0.PackTag(arg0_32, arg1_32))
end

function _SimpleEncoder(arg0_33, arg1_33, arg2_33)
	return function(arg0_34, arg1_34, arg2_34)
		if arg2_34 then
			local var0_34 = TagBytes(arg0_34, var7_0.WIRETYPE_LENGTH_DELIMITED)
			local var1_34 = var8_0

			return function(arg0_35, arg1_35)
				arg0_35(var0_34)

				local var0_35 = 0

				for iter0_35, iter1_35 in var2_0(arg1_35) do
					var0_35 = var0_35 + arg2_33(iter1_35)
				end

				var1_34(arg0_35, var0_35)

				for iter2_35 in arg1_35 do
					arg1_33(arg0_35, iter2_35)
				end
			end
		elseif arg1_34 then
			local var2_34 = TagBytes(arg0_34, arg0_33)

			return function(arg0_36, arg1_36)
				for iter0_36, iter1_36 in var2_0(arg1_36) do
					arg0_36(var2_34)
					arg1_33(arg0_36, iter1_36)
				end
			end
		else
			local var3_34 = TagBytes(arg0_34, arg0_33)

			return function(arg0_37, arg1_37)
				arg0_37(var3_34)
				arg1_33(arg0_37, arg1_37)
			end
		end
	end
end

function _ModifiedEncoder(arg0_38, arg1_38, arg2_38, arg3_38)
	return function(arg0_39, arg1_39, arg2_39)
		if arg2_39 then
			local var0_39 = TagBytes(arg0_39, var7_0.WIRETYPE_LENGTH_DELIMITED)
			local var1_39 = var8_0

			return function(arg0_40, arg1_40)
				arg0_40(var0_39)

				local var0_40 = 0

				for iter0_40, iter1_40 in var2_0(arg1_40) do
					var0_40 = var0_40 + arg2_38(arg3_38(iter1_40))
				end

				var1_39(arg0_40, var0_40)

				for iter2_40, iter3_40 in var2_0(arg1_40) do
					arg1_38(arg0_40, arg3_38(iter3_40))
				end
			end
		elseif arg1_39 then
			local var2_39 = TagBytes(arg0_39, arg0_38)

			return function(arg0_41, arg1_41)
				for iter0_41, iter1_41 in var2_0(arg1_41) do
					arg0_41(var2_39)
					arg1_38(arg0_41, arg3_38(iter1_41))
				end
			end
		else
			local var3_39 = TagBytes(arg0_39, arg0_38)

			return function(arg0_42, arg1_42)
				arg0_42(var3_39)
				arg1_38(arg0_42, arg3_38(arg1_42))
			end
		end
	end
end

function _StructPackEncoder(arg0_43, arg1_43, arg2_43)
	return function(arg0_44, arg1_44, arg2_44)
		local var0_44 = var6_0.struct_pack

		if arg2_44 then
			local var1_44 = TagBytes(arg0_44, var7_0.WIRETYPE_LENGTH_DELIMITED)
			local var2_44 = var8_0

			return function(arg0_45, arg1_45)
				arg0_45(var1_44)
				var2_44(arg0_45, #arg1_45 * arg1_43)

				for iter0_45, iter1_45 in var2_0(arg1_45) do
					var0_44(arg0_45, arg2_43, iter1_45)
				end
			end
		elseif arg1_44 then
			local var3_44 = TagBytes(arg0_44, arg0_43)

			return function(arg0_46, arg1_46)
				for iter0_46, iter1_46 in var2_0(arg1_46) do
					arg0_46(var3_44)
					var0_44(arg0_46, arg2_43, iter1_46)
				end
			end
		else
			local var4_44 = TagBytes(arg0_44, arg0_43)

			return function(arg0_47, arg1_47)
				arg0_47(var4_44)
				var0_44(arg0_47, arg2_43, arg1_47)
			end
		end
	end
end

Int32Encoder = _SimpleEncoder(var7_0.WIRETYPE_VARINT, var9_0, _SignedVarintSize)
Int64Encoder = _SimpleEncoder(var7_0.WIRETYPE_VARINT, var11_0, _SignedVarintSize64)
EnumEncoder = Int32Encoder
UInt32Encoder = _SimpleEncoder(var7_0.WIRETYPE_VARINT, var8_0, _VarintSize)
UInt64Encoder = _SimpleEncoder(var7_0.WIRETYPE_VARINT, var10_0, _VarintSize64)
SInt32Encoder = _ModifiedEncoder(var7_0.WIRETYPE_VARINT, var8_0, _VarintSize, var7_0.ZigZagEncode32)
SInt64Encoder = _ModifiedEncoder(var7_0.WIRETYPE_VARINT, var10_0, _VarintSize64, var7_0.ZigZagEncode64)
Fixed32Encoder = _StructPackEncoder(var7_0.WIRETYPE_FIXED32, 4, var0_0.byte("I"))
Fixed64Encoder = _StructPackEncoder(var7_0.WIRETYPE_FIXED64, 8, var0_0.byte("Q"))
SFixed32Encoder = _StructPackEncoder(var7_0.WIRETYPE_FIXED32, 4, var0_0.byte("i"))
SFixed64Encoder = _StructPackEncoder(var7_0.WIRETYPE_FIXED64, 8, var0_0.byte("q"))
FloatEncoder = _StructPackEncoder(var7_0.WIRETYPE_FIXED32, 4, var0_0.byte("f"))
DoubleEncoder = _StructPackEncoder(var7_0.WIRETYPE_FIXED64, 8, var0_0.byte("d"))

function BoolEncoder(arg0_48, arg1_48, arg2_48)
	local var0_48 = "\x00"
	local var1_48 = "\x01"

	if arg2_48 then
		local var2_48 = TagBytes(arg0_48, var7_0.WIRETYPE_LENGTH_DELIMITED)
		local var3_48 = var8_0

		return function(arg0_49, arg1_49)
			arg0_49(var2_48)
			var3_48(arg0_49, #arg1_49)

			for iter0_49, iter1_49 in var2_0(arg1_49) do
				if iter1_49 then
					arg0_49(var1_48)
				else
					arg0_49(var0_48)
				end
			end
		end
	elseif arg1_48 then
		local var4_48 = TagBytes(arg0_48, var7_0.WIRETYPE_VARINT)

		return function(arg0_50, arg1_50)
			for iter0_50, iter1_50 in var2_0(arg1_50) do
				arg0_50(var4_48)

				if iter1_50 then
					arg0_50(var1_48)
				else
					arg0_50(var0_48)
				end
			end
		end
	else
		local var5_48 = TagBytes(arg0_48, var7_0.WIRETYPE_VARINT)

		return function(arg0_51, arg1_51)
			arg0_51(var5_48)

			if arg1_51 then
				return arg0_51(var1_48)
			end

			return arg0_51(var0_48)
		end
	end
end

function StringEncoder(arg0_52, arg1_52, arg2_52)
	local var0_52 = TagBytes(arg0_52, var7_0.WIRETYPE_LENGTH_DELIMITED)
	local var1_52 = var8_0

	var3_0(not arg2_52)

	if arg1_52 then
		return function(arg0_53, arg1_53)
			for iter0_53, iter1_53 in var2_0(arg1_53) do
				arg0_53(var0_52)
				var1_52(arg0_53, #iter1_53)
				arg0_53(iter1_53)
			end
		end
	else
		return function(arg0_54, arg1_54)
			arg0_54(var0_52)
			var1_52(arg0_54, #arg1_54)

			return arg0_54(arg1_54)
		end
	end
end

function BytesEncoder(arg0_55, arg1_55, arg2_55)
	local var0_55 = TagBytes(arg0_55, var7_0.WIRETYPE_LENGTH_DELIMITED)
	local var1_55 = var8_0

	var3_0(not arg2_55)

	if arg1_55 then
		return function(arg0_56, arg1_56)
			for iter0_56, iter1_56 in var2_0(arg1_56) do
				arg0_56(var0_55)
				var1_55(arg0_56, #iter1_56)
				arg0_56(iter1_56)
			end
		end
	else
		return function(arg0_57, arg1_57)
			arg0_57(var0_55)
			var1_55(arg0_57, #arg1_57)

			return arg0_57(arg1_57)
		end
	end
end

function MessageEncoder(arg0_58, arg1_58, arg2_58)
	local var0_58 = TagBytes(arg0_58, var7_0.WIRETYPE_LENGTH_DELIMITED)
	local var1_58 = var8_0

	var3_0(not arg2_58)

	if arg1_58 then
		return function(arg0_59, arg1_59)
			for iter0_59, iter1_59 in var2_0(arg1_59) do
				arg0_59(var0_58)
				var1_58(arg0_59, iter1_59:ByteSize())
				iter1_59:_InternalSerialize(arg0_59)
			end
		end
	else
		return function(arg0_60, arg1_60)
			arg0_60(var0_58)
			var1_58(arg0_60, arg1_60:ByteSize())

			return arg1_60:_InternalSerialize(arg0_60)
		end
	end
end
