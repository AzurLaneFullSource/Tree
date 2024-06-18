local var0_0 = string
local var1_0 = table
local var2_0 = assert
local var3_0 = ipairs
local var4_0 = error
local var5_0 = print
local var6_0 = require("pb")
local var7_0 = require("encoder")
local var8_0 = require("wire_format")

module("decoder")

local var9_0 = var6_0.varint_decoder
local var10_0 = var6_0.signed_varint_decoder
local var11_0 = var6_0.varint_decoder
local var12_0 = var6_0.signed_varint_decoder
local var13_0 = var6_0.varint_decoder64
local var14_0 = var6_0.signed_varint_decoder64

ReadTag = var6_0.read_tag

local function var15_0(arg0_1, arg1_1)
	return function(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		if arg2_2 then
			local var0_2 = var9_0

			return function(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
				local var0_3 = arg4_3[arg3_2]

				if var0_3 == nil then
					var0_3 = arg4_2(arg3_3)
					arg4_3[arg3_2] = var0_3
				end

				local var1_3
				local var2_3, var3_3 = var0_2(arg0_3, arg1_3)

				arg1_3 = var3_3

				local var4_3 = var2_3 + arg1_3

				if arg2_3 < var4_3 then
					var4_0("Truncated message.")
				end

				local var5_3

				while arg1_3 < var4_3 do
					local var6_3

					var6_3, arg1_3 = arg1_1(arg0_3, arg1_3)
					var0_3[#var0_3 + 1] = var6_3
				end

				if var4_3 < arg1_3 then
					var0_3:remove(#var0_3)
					var4_0("Packed element was truncated.")
				end

				return arg1_3
			end
		elseif arg1_2 then
			local var1_2 = var7_0.TagBytes(arg0_2, arg0_1)
			local var2_2 = #var1_2
			local var3_2 = var0_0.sub

			return function(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
				local var0_4 = arg4_4[arg3_2]

				if var0_4 == nil then
					var0_4 = arg4_2(arg3_4)
					arg4_4[arg3_2] = var0_4
				end

				while true do
					local var1_4, var2_4 = arg1_1(arg0_4, arg1_4)

					var0_4:append(var1_4)

					arg1_4 = var2_4 + var2_2

					if var3_2(arg0_4, var2_4 + 1, arg1_4) ~= var1_2 or arg2_4 <= var2_4 then
						if arg2_4 < var2_4 then
							var4_0("Truncated message.")
						end

						return var2_4
					end
				end
			end
		else
			return function(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
				arg4_5[arg3_2], arg1_5 = arg1_1(arg0_5, arg1_5)

				if arg2_5 < arg1_5 then
					arg4_5[arg3_2] = nil

					var4_0("Truncated message.")
				end

				return arg1_5
			end
		end
	end
end

local function var16_0(arg0_6, arg1_6, arg2_6)
	local function var0_6(arg0_7, arg1_7)
		local var0_7, var1_7 = arg1_6(arg0_7, arg1_7)

		return arg2_6(var0_7), var1_7
	end

	return var15_0(arg0_6, var0_6)
end

local function var17_0(arg0_8, arg1_8, arg2_8)
	local var0_8 = var6_0.struct_unpack

	local function var1_8(arg0_9, arg1_9)
		local var0_9 = arg1_9 + arg1_8

		return var0_8(arg2_8, arg0_9, arg1_9), var0_9
	end

	return var15_0(arg0_8, var1_8)
end

local function var18_0(arg0_10)
	return arg0_10 ~= 0
end

Int32Decoder = var15_0(var8_0.WIRETYPE_VARINT, var12_0)
EnumDecoder = Int32Decoder
Int64Decoder = var15_0(var8_0.WIRETYPE_VARINT, var14_0)
UInt32Decoder = var15_0(var8_0.WIRETYPE_VARINT, var11_0)
UInt64Decoder = var15_0(var8_0.WIRETYPE_VARINT, var13_0)
SInt32Decoder = var16_0(var8_0.WIRETYPE_VARINT, var11_0, var8_0.ZigZagDecode32)
SInt64Decoder = var16_0(var8_0.WIRETYPE_VARINT, var13_0, var8_0.ZigZagDecode64)
Fixed32Decoder = var17_0(var8_0.WIRETYPE_FIXED32, 4, var0_0.byte("I"))
Fixed64Decoder = var17_0(var8_0.WIRETYPE_FIXED64, 8, var0_0.byte("Q"))
SFixed32Decoder = var17_0(var8_0.WIRETYPE_FIXED32, 4, var0_0.byte("i"))
SFixed64Decoder = var17_0(var8_0.WIRETYPE_FIXED64, 8, var0_0.byte("q"))
FloatDecoder = var17_0(var8_0.WIRETYPE_FIXED32, 4, var0_0.byte("f"))
DoubleDecoder = var17_0(var8_0.WIRETYPE_FIXED64, 8, var0_0.byte("d"))
BoolDecoder = var16_0(var8_0.WIRETYPE_VARINT, var9_0, var18_0)

function StringDecoder(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = var9_0
	local var1_11 = var0_0.sub

	var2_0(not arg2_11)

	if arg1_11 then
		local var2_11 = var7_0.TagBytes(arg0_11, var8_0.WIRETYPE_LENGTH_DELIMITED)
		local var3_11 = #var2_11

		return function(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
			local var0_12 = arg4_12[arg3_11]

			if var0_12 == nil then
				var0_12 = arg4_11(arg3_12)
				arg4_12[arg3_11] = var0_12
			end

			while true do
				local var1_12
				local var2_12
				local var3_12, var4_12 = var0_11(arg0_12, arg1_12)

				arg1_12 = var4_12

				local var5_12 = arg1_12 + var3_12

				if arg2_12 < var5_12 then
					var4_0("Truncated string.")
				end

				var0_12:append(var1_11(arg0_12, arg1_12 + 1, var5_12))

				arg1_12 = var5_12 + var3_11

				if var1_11(arg0_12, var5_12 + 1, arg1_12) ~= var2_11 or var5_12 == arg2_12 then
					return var5_12
				end
			end
		end
	else
		return function(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
			local var0_13
			local var1_13
			local var2_13, var3_13 = var0_11(arg0_13, arg1_13)

			arg1_13 = var3_13

			local var4_13 = arg1_13 + var2_13

			if arg2_13 < var4_13 then
				var4_0("Truncated string.")
			end

			arg4_13[arg3_11] = var1_11(arg0_13, arg1_13 + 1, var4_13)

			return var4_13
		end
	end
end

function BytesDecoder(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	local var0_14 = var9_0
	local var1_14 = var0_0.sub

	var2_0(not arg2_14)

	if arg1_14 then
		local var2_14 = var7_0.TagBytes(arg0_14, var8_0.WIRETYPE_LENGTH_DELIMITED)
		local var3_14 = #var2_14

		return function(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
			local var0_15 = arg4_15[arg3_14]

			if var0_15 == nil then
				var0_15 = arg4_14(arg3_15)
				arg4_15[arg3_14] = var0_15
			end

			while true do
				local var1_15
				local var2_15
				local var3_15, var4_15 = var0_14(arg0_15, arg1_15)

				arg1_15 = var4_15

				local var5_15 = arg1_15 + var3_15

				if arg2_15 < var5_15 then
					var4_0("Truncated string.")
				end

				var0_15:append(var1_14(arg0_15, arg1_15 + 1, var5_15))

				arg1_15 = var5_15 + var3_14

				if var1_14(arg0_15, var5_15 + 1, arg1_15) ~= var2_14 or var5_15 == arg2_15 then
					return var5_15
				end
			end
		end
	else
		return function(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
			local var0_16
			local var1_16
			local var2_16, var3_16 = var0_14(arg0_16, arg1_16)

			arg1_16 = var3_16

			local var4_16 = arg1_16 + var2_16

			if arg2_16 < var4_16 then
				var4_0("Truncated string.")
			end

			arg4_16[arg3_14] = var1_14(arg0_16, arg1_16 + 1, var4_16)

			return var4_16
		end
	end
end

function MessageDecoder(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	local var0_17 = var9_0
	local var1_17 = var0_0.sub

	var2_0(not arg2_17)

	if arg1_17 then
		local var2_17 = var7_0.TagBytes(arg0_17, var8_0.WIRETYPE_LENGTH_DELIMITED)
		local var3_17 = #var2_17

		return function(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
			local var0_18 = arg4_18[arg3_17]

			if var0_18 == nil then
				var0_18 = arg4_17(arg3_18)
				arg4_18[arg3_17] = var0_18
			end

			while true do
				local var1_18
				local var2_18
				local var3_18, var4_18 = var0_17(arg0_18, arg1_18)

				arg1_18 = var4_18

				local var5_18 = arg1_18 + var3_18

				if arg2_18 < var5_18 then
					var4_0("Truncated message.")
				end

				if var0_18:add():_InternalParse(arg0_18, arg1_18, var5_18) ~= var5_18 then
					var4_0("Unexpected end-group tag.")
				end

				arg1_18 = var5_18 + var3_17

				if var1_17(arg0_18, var5_18 + 1, arg1_18) ~= var2_17 or var5_18 == arg2_18 then
					return var5_18
				end
			end
		end
	else
		return function(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
			local var0_19 = arg4_19[arg3_17]

			if var0_19 == nil then
				var0_19 = arg4_17(arg3_19)
				arg4_19[arg3_17] = var0_19
			end

			local var1_19
			local var2_19
			local var3_19, var4_19 = var0_17(arg0_19, arg1_19)

			arg1_19 = var4_19

			local var5_19 = arg1_19 + var3_19

			if arg2_19 < var5_19 then
				var4_0("Truncated message.")
			end

			if var0_19:_InternalParse(arg0_19, arg1_19, var5_19) ~= var5_19 then
				var4_0("Unexpected end-group tag.")
			end

			return var5_19
		end
	end
end

function _SkipVarint(arg0_20, arg1_20, arg2_20)
	local var0_20
	local var1_20

	var1_20, arg1_20 = var9_0(arg0_20, arg1_20)

	return arg1_20
end

function _SkipFixed64(arg0_21, arg1_21, arg2_21)
	arg1_21 = arg1_21 + 8

	if arg2_21 < arg1_21 then
		var4_0("Truncated message.")
	end

	return arg1_21
end

function _SkipLengthDelimited(arg0_22, arg1_22, arg2_22)
	local var0_22
	local var1_22, var2_22 = var9_0(arg0_22, arg1_22)

	arg1_22 = var2_22
	arg1_22 = arg1_22 + var1_22

	if arg2_22 < arg1_22 then
		var4_0("Truncated message.")
	end

	return arg1_22
end

function _SkipFixed32(arg0_23, arg1_23, arg2_23)
	arg1_23 = arg1_23 + 4

	if arg2_23 < arg1_23 then
		var4_0("Truncated message.")
	end

	return arg1_23
end

function _RaiseInvalidWireType(arg0_24, arg1_24, arg2_24)
	var4_0("Tag had invalid wire type.")
end

function _FieldSkipper()
	local var0_25 = {
		_SkipVarint,
		_SkipFixed64,
		_SkipLengthDelimited,
		_SkipGroup,
		_EndGroup,
		_SkipFixed32,
		_RaiseInvalidWireType,
		_RaiseInvalidWireType
	}
	local var1_25 = var0_0.byte
	local var2_25 = var0_0.sub

	return function(arg0_26, arg1_26, arg2_26, arg3_26)
		local var0_26 = var1_25(var2_25(arg3_26, 1, 1)) % 8 + 1

		return var0_25[var0_26](arg0_26, arg1_26, arg2_26)
	end
end

SkipField = _FieldSkipper()
