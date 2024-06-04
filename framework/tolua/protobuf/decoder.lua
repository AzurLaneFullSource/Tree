local var0 = string
local var1 = table
local var2 = assert
local var3 = ipairs
local var4 = error
local var5 = print
local var6 = require("pb")
local var7 = require("protobuf.encoder")
local var8 = require("protobuf.wire_format")

module("protobuf.decoder")

local var9 = var6.varint_decoder
local var10 = var6.signed_varint_decoder
local var11 = var6.varint_decoder
local var12 = var6.signed_varint_decoder
local var13 = var6.varint_decoder64
local var14 = var6.signed_varint_decoder64

ReadTag = var6.read_tag

local function var15(arg0, arg1)
	return function(arg0, arg1, arg2, arg3, arg4)
		if arg2 then
			local var0 = var9

			return function(arg0, arg1, arg2, arg3, arg4)
				local var0 = arg4[arg3]

				if var0 == nil then
					var0 = arg4(arg3)
					arg4[arg3] = var0
				end

				local var1
				local var2, var3 = var0(arg0, arg1)

				arg1 = var3

				local var4 = var2 + arg1

				if arg2 < var4 then
					var4("Truncated message.")
				end

				local var5

				while arg1 < var4 do
					local var6

					var6, arg1 = arg1(arg0, arg1)
					var0[#var0 + 1] = var6
				end

				if var4 < arg1 then
					var0:remove(#var0)
					var4("Packed element was truncated.")
				end

				return arg1
			end
		elseif arg1 then
			local var1 = var7.TagBytes(arg0, arg0)
			local var2 = #var1
			local var3 = var0.sub

			return function(arg0, arg1, arg2, arg3, arg4)
				local var0 = arg4[arg3]

				if var0 == nil then
					var0 = arg4(arg3)
					arg4[arg3] = var0
				end

				while true do
					local var1, var2 = arg1(arg0, arg1)

					var0:append(var1)

					arg1 = var2 + var2

					if var3(arg0, var2 + 1, arg1) ~= var1 or arg2 <= var2 then
						if arg2 < var2 then
							var4("Truncated message.")
						end

						return var2
					end
				end
			end
		else
			return function(arg0, arg1, arg2, arg3, arg4)
				arg4[arg3], arg1 = arg1(arg0, arg1)

				if arg2 < arg1 then
					arg4[arg3] = nil

					var4("Truncated message.")
				end

				return arg1
			end
		end
	end
end

local function var16(arg0, arg1, arg2)
	local function var0(arg0, arg1)
		local var0, var1 = arg1(arg0, arg1)

		return arg2(var0), var1
	end

	return var15(arg0, var0)
end

local function var17(arg0, arg1, arg2)
	local var0 = var6.struct_unpack

	function InnerDecode(arg0, arg1)
		local var0 = arg1 + arg1

		return var0(arg2, arg0, arg1), var0
	end

	return var15(arg0, InnerDecode)
end

local function var18(arg0)
	return arg0 ~= 0
end

Int32Decoder = var15(var8.WIRETYPE_VARINT, var12)
EnumDecoder = Int32Decoder
Int64Decoder = var15(var8.WIRETYPE_VARINT, var14)
UInt32Decoder = var15(var8.WIRETYPE_VARINT, var11)
UInt64Decoder = var15(var8.WIRETYPE_VARINT, var13)
SInt32Decoder = var16(var8.WIRETYPE_VARINT, var11, var8.ZigZagDecode32)
SInt64Decoder = var16(var8.WIRETYPE_VARINT, var13, var8.ZigZagDecode64)
Fixed32Decoder = var17(var8.WIRETYPE_FIXED32, 4, var0.byte("I"))
Fixed64Decoder = var17(var8.WIRETYPE_FIXED64, 8, var0.byte("Q"))
SFixed32Decoder = var17(var8.WIRETYPE_FIXED32, 4, var0.byte("i"))
SFixed64Decoder = var17(var8.WIRETYPE_FIXED64, 8, var0.byte("q"))
FloatDecoder = var17(var8.WIRETYPE_FIXED32, 4, var0.byte("f"))
DoubleDecoder = var17(var8.WIRETYPE_FIXED64, 8, var0.byte("d"))
BoolDecoder = var16(var8.WIRETYPE_VARINT, var9, var18)

function StringDecoder(arg0, arg1, arg2, arg3, arg4)
	local var0 = var9
	local var1 = var0.sub

	var2(not arg2)

	if arg1 then
		local var2 = var7.TagBytes(arg0, var8.WIRETYPE_LENGTH_DELIMITED)
		local var3 = #var2

		return function(arg0, arg1, arg2, arg3, arg4)
			local var0 = arg4[arg3]

			if var0 == nil then
				var0 = arg4(arg3)
				arg4[arg3] = var0
			end

			while true do
				local var1
				local var2
				local var3, var4 = var0(arg0, arg1)

				arg1 = var4

				local var5 = arg1 + var3

				if arg2 < var5 then
					var4("Truncated string.")
				end

				var0:append(var1(arg0, arg1 + 1, var5))

				arg1 = var5 + var3

				if var1(arg0, var5 + 1, arg1) ~= var2 or var5 == arg2 then
					return var5
				end
			end
		end
	else
		return function(arg0, arg1, arg2, arg3, arg4)
			local var0
			local var1
			local var2, var3 = var0(arg0, arg1)

			arg1 = var3

			local var4 = arg1 + var2

			if arg2 < var4 then
				var4("Truncated string.")
			end

			arg4[arg3] = var1(arg0, arg1 + 1, var4)

			return var4
		end
	end
end

function BytesDecoder(arg0, arg1, arg2, arg3, arg4)
	local var0 = var9
	local var1 = var0.sub

	var2(not arg2)

	if arg1 then
		local var2 = var7.TagBytes(arg0, var8.WIRETYPE_LENGTH_DELIMITED)
		local var3 = #var2

		return function(arg0, arg1, arg2, arg3, arg4)
			local var0 = arg4[arg3]

			if var0 == nil then
				var0 = arg4(arg3)
				arg4[arg3] = var0
			end

			while true do
				local var1
				local var2
				local var3, var4 = var0(arg0, arg1)

				arg1 = var4

				local var5 = arg1 + var3

				if arg2 < var5 then
					var4("Truncated string.")
				end

				var0:append(var1(arg0, arg1 + 1, var5))

				arg1 = var5 + var3

				if var1(arg0, var5 + 1, arg1) ~= var2 or var5 == arg2 then
					return var5
				end
			end
		end
	else
		return function(arg0, arg1, arg2, arg3, arg4)
			local var0
			local var1
			local var2, var3 = var0(arg0, arg1)

			arg1 = var3

			local var4 = arg1 + var2

			if arg2 < var4 then
				var4("Truncated string.")
			end

			arg4[arg3] = var1(arg0, arg1 + 1, var4)

			return var4
		end
	end
end

function MessageDecoder(arg0, arg1, arg2, arg3, arg4)
	local var0 = var9
	local var1 = var0.sub

	var2(not arg2)

	if arg1 then
		local var2 = var7.TagBytes(arg0, var8.WIRETYPE_LENGTH_DELIMITED)
		local var3 = #var2

		return function(arg0, arg1, arg2, arg3, arg4)
			local var0 = arg4[arg3]

			if var0 == nil then
				var0 = arg4(arg3)
				arg4[arg3] = var0
			end

			while true do
				local var1
				local var2
				local var3, var4 = var0(arg0, arg1)

				arg1 = var4

				local var5 = arg1 + var3

				if arg2 < var5 then
					var4("Truncated message.")
				end

				if var0:add():_InternalParse(arg0, arg1, var5) ~= var5 then
					var4("Unexpected end-group tag.")
				end

				arg1 = var5 + var3

				if var1(arg0, var5 + 1, arg1) ~= var2 or var5 == arg2 then
					return var5
				end
			end
		end
	else
		return function(arg0, arg1, arg2, arg3, arg4)
			local var0 = arg4[arg3]

			if var0 == nil then
				var0 = arg4(arg3)
				arg4[arg3] = var0
			end

			local var1
			local var2
			local var3, var4 = var0(arg0, arg1)

			arg1 = var4

			local var5 = arg1 + var3

			if arg2 < var5 then
				var4("Truncated message.")
			end

			if var0:_InternalParse(arg0, arg1, var5) ~= var5 then
				var4("Unexpected end-group tag.")
			end

			return var5
		end
	end
end

function _SkipVarint(arg0, arg1, arg2)
	local var0
	local var1

	var1, arg1 = var9(arg0, arg1)

	return arg1
end

function _SkipFixed64(arg0, arg1, arg2)
	arg1 = arg1 + 8

	if arg2 < arg1 then
		var4("Truncated message.")
	end

	return arg1
end

function _SkipLengthDelimited(arg0, arg1, arg2)
	local var0
	local var1, var2 = var9(arg0, arg1)

	arg1 = var2
	arg1 = arg1 + var1

	if arg2 < arg1 then
		var4("Truncated message.")
	end

	return arg1
end

function _SkipFixed32(arg0, arg1, arg2)
	arg1 = arg1 + 4

	if arg2 < arg1 then
		var4("Truncated message.")
	end

	return arg1
end

function _RaiseInvalidWireType(arg0, arg1, arg2)
	var4("Tag had invalid wire type.")
end

function _FieldSkipper()
	WIRETYPE_TO_SKIPPER = {
		_SkipVarint,
		_SkipFixed64,
		_SkipLengthDelimited,
		_SkipGroup,
		_EndGroup,
		_SkipFixed32,
		_RaiseInvalidWireType,
		_RaiseInvalidWireType
	}

	local var0 = var0.byte
	local var1 = var0.sub

	return function(arg0, arg1, arg2, arg3)
		local var0 = var0(var1(arg3, 1, 1)) % 8 + 1

		return WIRETYPE_TO_SKIPPER[var0](arg0, arg1, arg2)
	end
end

SkipField = _FieldSkipper()
