local var0_0 = string
local var1_0 = table
local var2_0 = ipairs
local var3_0 = assert
local var4_0 = require("pb")
local var5_0 = require("protobuf.wire_format")

module("protobuf.encoder")

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

	if arg0_1 <= 34359738367 then
		return 5
	end

	if arg0_1 <= 4398046511103 then
		return 6
	end

	if arg0_1 <= 562949953421311 then
		return 7
	end

	if arg0_1 <= 7.20575940379279e+16 then
		return 8
	end

	if arg0_1 <= 9.22337203685478e+18 then
		return 9
	end

	return 10
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

	if arg0_2 <= 34359738367 then
		return 5
	end

	if arg0_2 <= 4398046511103 then
		return 6
	end

	if arg0_2 <= 562949953421311 then
		return 7
	end

	if arg0_2 <= 7.20575940379279e+16 then
		return 8
	end

	if arg0_2 <= 9.22337203685478e+18 then
		return 9
	end

	return 10
end

function _TagSize(arg0_3)
	return _VarintSize(var5_0.PackTag(arg0_3, 0))
end

function _SimpleSizer(arg0_4)
	return function(arg0_5, arg1_5, arg2_5)
		local var0_5 = _TagSize(arg0_5)

		if arg2_5 then
			local var1_5 = _VarintSize

			return function(arg0_6)
				local var0_6 = 0

				for iter0_6, iter1_6 in var2_0(arg0_6) do
					var0_6 = var0_6 + arg0_4(iter1_6)
				end

				return var0_6 + var1_5(var0_6) + var0_5
			end
		elseif arg1_5 then
			return function(arg0_7)
				local var0_7 = var0_5 * #arg0_7

				for iter0_7, iter1_7 in var2_0(arg0_7) do
					var0_7 = var0_7 + arg0_4(iter1_7)
				end

				return var0_7
			end
		else
			return function(arg0_8)
				return var0_5 + arg0_4(arg0_8)
			end
		end
	end
end

function _ModifiedSizer(arg0_9, arg1_9)
	return function(arg0_10, arg1_10, arg2_10)
		local var0_10 = _TagSize(arg0_10)

		if arg2_10 then
			local var1_10 = _VarintSize

			return function(arg0_11)
				local var0_11 = 0

				for iter0_11, iter1_11 in var2_0(arg0_11) do
					var0_11 = var0_11 + arg0_9(arg1_9(iter1_11))
				end

				return var0_11 + var1_10(var0_11) + var0_10
			end
		elseif arg1_10 then
			return function(arg0_12)
				local var0_12 = var0_10 * #arg0_12

				for iter0_12, iter1_12 in var2_0(arg0_12) do
					var0_12 = var0_12 + arg0_9(arg1_9(iter1_12))
				end

				return var0_12
			end
		else
			return function(arg0_13)
				return var0_10 + arg0_9(arg1_9(arg0_13))
			end
		end
	end
end

function _FixedSizer(arg0_14)
	return function(arg0_15, arg1_15, arg2_15)
		local var0_15 = _TagSize(arg0_15)

		if arg2_15 then
			local var1_15 = _VarintSize

			return function(arg0_16)
				local var0_16 = #arg0_16 * arg0_14

				return var0_16 + var1_15(var0_16) + var0_15
			end
		elseif arg1_15 then
			local var2_15 = arg0_14 + var0_15

			return function(arg0_17)
				return #arg0_17 * var2_15
			end
		else
			local var3_15 = arg0_14 + var0_15

			return function(arg0_18)
				return var3_15
			end
		end
	end
end

Int32Sizer = _SimpleSizer(_SignedVarintSize)
Int64Sizer = _SimpleSizer(var4_0.signed_varint_size)
EnumSizer = Int32Sizer
UInt32Sizer = _SimpleSizer(_VarintSize)
UInt64Sizer = _SimpleSizer(var4_0.varint_size)
SInt32Sizer = _ModifiedSizer(_SignedVarintSize, var5_0.ZigZagEncode32)
SInt64Sizer = SInt32Sizer
Fixed32Sizer = _FixedSizer(4)
SFixed32Sizer = Fixed32Sizer
FloatSizer = Fixed32Sizer
Fixed64Sizer = _FixedSizer(8)
SFixed64Sizer = Fixed64Sizer
DoubleSizer = Fixed64Sizer
BoolSizer = _FixedSizer(1)

function StringSizer(arg0_19, arg1_19, arg2_19)
	local var0_19 = _TagSize(arg0_19)
	local var1_19 = _VarintSize

	var3_0(not arg2_19)

	if arg1_19 then
		return function(arg0_20)
			local var0_20 = var0_19 * #arg0_20

			for iter0_20, iter1_20 in var2_0(arg0_20) do
				local var1_20 = #iter1_20

				var0_20 = var0_20 + var1_19(var1_20) + var1_20
			end

			return var0_20
		end
	else
		return function(arg0_21)
			local var0_21 = #arg0_21

			return var0_19 + var1_19(var0_21) + var0_21
		end
	end
end

function BytesSizer(arg0_22, arg1_22, arg2_22)
	local var0_22 = _TagSize(arg0_22)
	local var1_22 = _VarintSize

	var3_0(not arg2_22)

	if arg1_22 then
		return function(arg0_23)
			local var0_23 = var0_22 * #arg0_23

			for iter0_23, iter1_23 in var2_0(arg0_23) do
				local var1_23 = #iter1_23

				var0_23 = var0_23 + var1_22(var1_23) + var1_23
			end

			return var0_23
		end
	else
		return function(arg0_24)
			local var0_24 = #arg0_24

			return var0_22 + var1_22(var0_24) + var0_24
		end
	end
end

function MessageSizer(arg0_25, arg1_25, arg2_25)
	local var0_25 = _TagSize(arg0_25)
	local var1_25 = _VarintSize

	var3_0(not arg2_25)

	if arg1_25 then
		return function(arg0_26)
			local var0_26 = var0_25 * #arg0_26

			for iter0_26, iter1_26 in var2_0(arg0_26) do
				local var1_26 = iter1_26:ByteSize()

				var0_26 = var0_26 + var1_25(var1_26) + var1_26
			end

			return var0_26
		end
	else
		return function(arg0_27)
			local var0_27 = arg0_27:ByteSize()

			return var0_25 + var1_25(var0_27) + var0_27
		end
	end
end

local var6_0 = var4_0.varint_encoder
local var7_0 = var4_0.signed_varint_encoder
local var8_0 = var4_0.varint_encoder64
local var9_0 = var4_0.signed_varint_encoder64

function _VarintBytes(arg0_28)
	local var0_28 = {}

	local function var1_28(arg0_29)
		var0_28[#var0_28 + 1] = arg0_29
	end

	var7_0(var1_28, arg0_28)

	return var1_0.concat(var0_28)
end

function TagBytes(arg0_30, arg1_30)
	return _VarintBytes(var5_0.PackTag(arg0_30, arg1_30))
end

function _SimpleEncoder(arg0_31, arg1_31, arg2_31)
	return function(arg0_32, arg1_32, arg2_32)
		if arg2_32 then
			local var0_32 = TagBytes(arg0_32, var5_0.WIRETYPE_LENGTH_DELIMITED)
			local var1_32 = var6_0

			return function(arg0_33, arg1_33)
				arg0_33(var0_32)

				local var0_33 = 0

				for iter0_33, iter1_33 in var2_0(arg1_33) do
					var0_33 = var0_33 + arg2_31(iter1_33)
				end

				var1_32(arg0_33, var0_33)

				for iter2_33 in arg1_33 do
					arg1_31(arg0_33, iter2_33)
				end
			end
		elseif arg1_32 then
			local var2_32 = TagBytes(arg0_32, arg0_31)

			return function(arg0_34, arg1_34)
				for iter0_34, iter1_34 in var2_0(arg1_34) do
					arg0_34(var2_32)
					arg1_31(arg0_34, iter1_34)
				end
			end
		else
			local var3_32 = TagBytes(arg0_32, arg0_31)

			return function(arg0_35, arg1_35)
				arg0_35(var3_32)
				arg1_31(arg0_35, arg1_35)
			end
		end
	end
end

function _ModifiedEncoder(arg0_36, arg1_36, arg2_36, arg3_36)
	return function(arg0_37, arg1_37, arg2_37)
		if arg2_37 then
			local var0_37 = TagBytes(arg0_37, var5_0.WIRETYPE_LENGTH_DELIMITED)
			local var1_37 = var6_0

			return function(arg0_38, arg1_38)
				arg0_38(var0_37)

				local var0_38 = 0

				for iter0_38, iter1_38 in var2_0(arg1_38) do
					var0_38 = var0_38 + arg2_36(arg3_36(iter1_38))
				end

				var1_37(arg0_38, var0_38)

				for iter2_38, iter3_38 in var2_0(arg1_38) do
					arg1_36(arg0_38, arg3_36(iter3_38))
				end
			end
		elseif arg1_37 then
			local var2_37 = TagBytes(arg0_37, arg0_36)

			return function(arg0_39, arg1_39)
				for iter0_39, iter1_39 in var2_0(arg1_39) do
					arg0_39(var2_37)
					arg1_36(arg0_39, arg3_36(iter1_39))
				end
			end
		else
			local var3_37 = TagBytes(arg0_37, arg0_36)

			return function(arg0_40, arg1_40)
				arg0_40(var3_37)
				arg1_36(arg0_40, arg3_36(arg1_40))
			end
		end
	end
end

function _StructPackEncoder(arg0_41, arg1_41, arg2_41)
	return function(arg0_42, arg1_42, arg2_42)
		local var0_42 = var4_0.struct_pack

		if arg2_42 then
			local var1_42 = TagBytes(arg0_42, var5_0.WIRETYPE_LENGTH_DELIMITED)
			local var2_42 = var6_0

			return function(arg0_43, arg1_43)
				arg0_43(var1_42)
				var2_42(arg0_43, #arg1_43 * arg1_41)

				for iter0_43, iter1_43 in var2_0(arg1_43) do
					var0_42(arg0_43, arg2_41, iter1_43)
				end
			end
		elseif arg1_42 then
			local var3_42 = TagBytes(arg0_42, arg0_41)

			return function(arg0_44, arg1_44)
				for iter0_44, iter1_44 in var2_0(arg1_44) do
					arg0_44(var3_42)
					var0_42(arg0_44, arg2_41, iter1_44)
				end
			end
		else
			local var4_42 = TagBytes(arg0_42, arg0_41)

			return function(arg0_45, arg1_45)
				arg0_45(var4_42)
				var0_42(arg0_45, arg2_41, arg1_45)
			end
		end
	end
end

Int32Encoder = _SimpleEncoder(var5_0.WIRETYPE_VARINT, var7_0, _SignedVarintSize)
Int64Encoder = _SimpleEncoder(var5_0.WIRETYPE_VARINT, var9_0, _SignedVarintSize)
EnumEncoder = Int32Encoder
UInt32Encoder = _SimpleEncoder(var5_0.WIRETYPE_VARINT, var6_0, _VarintSize)
UInt64Encoder = _SimpleEncoder(var5_0.WIRETYPE_VARINT, var8_0, _VarintSize)
SInt32Encoder = _ModifiedEncoder(var5_0.WIRETYPE_VARINT, var6_0, _VarintSize, var5_0.ZigZagEncode32)
SInt64Encoder = _ModifiedEncoder(var5_0.WIRETYPE_VARINT, var8_0, _VarintSize, var5_0.ZigZagEncode64)
Fixed32Encoder = _StructPackEncoder(var5_0.WIRETYPE_FIXED32, 4, var0_0.byte("I"))
Fixed64Encoder = _StructPackEncoder(var5_0.WIRETYPE_FIXED64, 8, var0_0.byte("Q"))
SFixed32Encoder = _StructPackEncoder(var5_0.WIRETYPE_FIXED32, 4, var0_0.byte("i"))
SFixed64Encoder = _StructPackEncoder(var5_0.WIRETYPE_FIXED64, 8, var0_0.byte("q"))
FloatEncoder = _StructPackEncoder(var5_0.WIRETYPE_FIXED32, 4, var0_0.byte("f"))
DoubleEncoder = _StructPackEncoder(var5_0.WIRETYPE_FIXED64, 8, var0_0.byte("d"))

function BoolEncoder(arg0_46, arg1_46, arg2_46)
	local var0_46 = "\x00"
	local var1_46 = "\x01"

	if arg2_46 then
		local var2_46 = TagBytes(arg0_46, var5_0.WIRETYPE_LENGTH_DELIMITED)
		local var3_46 = var6_0

		return function(arg0_47, arg1_47)
			arg0_47(var2_46)
			var3_46(arg0_47, #arg1_47)

			for iter0_47, iter1_47 in var2_0(arg1_47) do
				if iter1_47 then
					arg0_47(var1_46)
				else
					arg0_47(var0_46)
				end
			end
		end
	elseif arg1_46 then
		local var4_46 = TagBytes(arg0_46, var5_0.WIRETYPE_VARINT)

		return function(arg0_48, arg1_48)
			for iter0_48, iter1_48 in var2_0(arg1_48) do
				arg0_48(var4_46)

				if iter1_48 then
					arg0_48(var1_46)
				else
					arg0_48(var0_46)
				end
			end
		end
	else
		local var5_46 = TagBytes(arg0_46, var5_0.WIRETYPE_VARINT)

		return function(arg0_49, arg1_49)
			arg0_49(var5_46)

			if arg1_49 then
				return arg0_49(var1_46)
			end

			return arg0_49(var0_46)
		end
	end
end

function StringEncoder(arg0_50, arg1_50, arg2_50)
	local var0_50 = TagBytes(arg0_50, var5_0.WIRETYPE_LENGTH_DELIMITED)
	local var1_50 = var6_0

	var3_0(not arg2_50)

	if arg1_50 then
		return function(arg0_51, arg1_51)
			for iter0_51, iter1_51 in var2_0(arg1_51) do
				arg0_51(var0_50)
				var1_50(arg0_51, #iter1_51)
				arg0_51(iter1_51)
			end
		end
	else
		return function(arg0_52, arg1_52)
			arg0_52(var0_50)
			var1_50(arg0_52, #arg1_52)

			return arg0_52(arg1_52)
		end
	end
end

function BytesEncoder(arg0_53, arg1_53, arg2_53)
	local var0_53 = TagBytes(arg0_53, var5_0.WIRETYPE_LENGTH_DELIMITED)
	local var1_53 = var6_0

	var3_0(not arg2_53)

	if arg1_53 then
		return function(arg0_54, arg1_54)
			for iter0_54, iter1_54 in var2_0(arg1_54) do
				arg0_54(var0_53)
				var1_53(arg0_54, #iter1_54)
				arg0_54(iter1_54)
			end
		end
	else
		return function(arg0_55, arg1_55)
			arg0_55(var0_53)
			var1_53(arg0_55, #arg1_55)

			return arg0_55(arg1_55)
		end
	end
end

function MessageEncoder(arg0_56, arg1_56, arg2_56)
	local var0_56 = TagBytes(arg0_56, var5_0.WIRETYPE_LENGTH_DELIMITED)
	local var1_56 = var6_0

	var3_0(not arg2_56)

	if arg1_56 then
		return function(arg0_57, arg1_57)
			for iter0_57, iter1_57 in var2_0(arg1_57) do
				arg0_57(var0_56)
				var1_56(arg0_57, iter1_57:ByteSize())
				iter1_57:_InternalSerialize(arg0_57)
			end
		end
	else
		return function(arg0_58, arg1_58)
			arg0_58(var0_56)
			var1_56(arg0_58, arg1_58:ByteSize())

			return arg1_58:_InternalSerialize(arg0_58)
		end
	end
end
