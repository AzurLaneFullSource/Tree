local var0 = string
local var1 = table
local var2 = ipairs
local var3 = assert
local var4 = require("pb")
local var5 = require("wire_format")

module("encoder")

function _VarintSize(arg0)
	if arg0 <= 127 then
		return 1
	end

	if arg0 <= 16383 then
		return 2
	end

	if arg0 <= 2097151 then
		return 3
	end

	if arg0 <= 268435455 then
		return 4
	end

	if arg0 <= 34359738367 then
		return 5
	end

	if arg0 <= 4398046511103 then
		return 6
	end

	if arg0 <= 562949953421311 then
		return 7
	end

	if arg0 <= 7.20575940379279e+16 then
		return 8
	end

	if arg0 <= 9.22337203685478e+18 then
		return 9
	end

	return 10
end

function _SignedVarintSize(arg0)
	if arg0 < 0 then
		return 10
	end

	if arg0 <= 127 then
		return 1
	end

	if arg0 <= 16383 then
		return 2
	end

	if arg0 <= 2097151 then
		return 3
	end

	if arg0 <= 268435455 then
		return 4
	end

	if arg0 <= 34359738367 then
		return 5
	end

	if arg0 <= 4398046511103 then
		return 6
	end

	if arg0 <= 562949953421311 then
		return 7
	end

	if arg0 <= 7.20575940379279e+16 then
		return 8
	end

	if arg0 <= 9.22337203685478e+18 then
		return 9
	end

	return 10
end

function _TagSize(arg0)
	return _VarintSize(var5.PackTag(arg0, 0))
end

function _SimpleSizer(arg0)
	return function(arg0, arg1, arg2)
		local var0 = _TagSize(arg0)

		if arg2 then
			local var1 = _VarintSize

			return function(arg0)
				local var0 = 0

				for iter0, iter1 in var2(arg0) do
					var0 = var0 + arg0(iter1)
				end

				return var0 + var1(var0) + var0
			end
		elseif arg1 then
			return function(arg0)
				local var0 = var0 * #arg0

				for iter0, iter1 in var2(arg0) do
					var0 = var0 + arg0(iter1)
				end

				return var0
			end
		else
			return function(arg0)
				return var0 + arg0(arg0)
			end
		end
	end
end

function _ModifiedSizer(arg0, arg1)
	return function(arg0, arg1, arg2)
		local var0 = _TagSize(arg0)

		if arg2 then
			local var1 = _VarintSize

			return function(arg0)
				local var0 = 0

				for iter0, iter1 in var2(arg0) do
					var0 = var0 + arg0(arg1(iter1))
				end

				return var0 + var1(var0) + var0
			end
		elseif arg1 then
			return function(arg0)
				local var0 = var0 * #arg0

				for iter0, iter1 in var2(arg0) do
					var0 = var0 + arg0(arg1(iter1))
				end

				return var0
			end
		else
			return function(arg0)
				return var0 + arg0(arg1(arg0))
			end
		end
	end
end

function _FixedSizer(arg0)
	return function(arg0, arg1, arg2)
		local var0 = _TagSize(arg0)

		if arg2 then
			local var1 = _VarintSize

			return function(arg0)
				local var0 = #arg0 * arg0

				return var0 + var1(var0) + var0
			end
		elseif arg1 then
			local var2 = arg0 + var0

			return function(arg0)
				return #arg0 * var2
			end
		else
			local var3 = arg0 + var0

			return function(arg0)
				return var3
			end
		end
	end
end

Int32Sizer = _SimpleSizer(_SignedVarintSize)
Int64Sizer = _SimpleSizer(var4.signed_varint_size)
EnumSizer = Int32Sizer
UInt32Sizer = _SimpleSizer(_VarintSize)
UInt64Sizer = _SimpleSizer(var4.varint_size)
SInt32Sizer = _ModifiedSizer(_SignedVarintSize, var5.ZigZagEncode32)
SInt64Sizer = SInt32Sizer
Fixed32Sizer = _FixedSizer(4)
SFixed32Sizer = Fixed32Sizer
FloatSizer = Fixed32Sizer
Fixed64Sizer = _FixedSizer(8)
SFixed64Sizer = Fixed64Sizer
DoubleSizer = Fixed64Sizer
BoolSizer = _FixedSizer(1)

function StringSizer(arg0, arg1, arg2)
	local var0 = _TagSize(arg0)
	local var1 = _VarintSize

	var3(not arg2)

	if arg1 then
		return function(arg0)
			local var0 = var0 * #arg0

			for iter0, iter1 in var2(arg0) do
				local var1 = #iter1

				var0 = var0 + var1(var1) + var1
			end

			return var0
		end
	else
		return function(arg0)
			local var0 = #arg0

			return var0 + var1(var0) + var0
		end
	end
end

function BytesSizer(arg0, arg1, arg2)
	local var0 = _TagSize(arg0)
	local var1 = _VarintSize

	var3(not arg2)

	if arg1 then
		return function(arg0)
			local var0 = var0 * #arg0

			for iter0, iter1 in var2(arg0) do
				local var1 = #iter1

				var0 = var0 + var1(var1) + var1
			end

			return var0
		end
	else
		return function(arg0)
			local var0 = #arg0

			return var0 + var1(var0) + var0
		end
	end
end

function MessageSizer(arg0, arg1, arg2)
	local var0 = _TagSize(arg0)
	local var1 = _VarintSize

	var3(not arg2)

	if arg1 then
		return function(arg0)
			local var0 = var0 * #arg0

			for iter0, iter1 in var2(arg0) do
				local var1 = iter1:ByteSize()

				var0 = var0 + var1(var1) + var1
			end

			return var0
		end
	else
		return function(arg0)
			local var0 = arg0:ByteSize()

			return var0 + var1(var0) + var0
		end
	end
end

local var6 = var4.varint_encoder
local var7 = var4.signed_varint_encoder
local var8 = var4.varint_encoder64
local var9 = var4.signed_varint_encoder64

function _VarintBytes(arg0)
	local var0 = {}

	local function var1(arg0)
		var0[#var0 + 1] = arg0
	end

	var7(var1, arg0)

	return var1.concat(var0)
end

function TagBytes(arg0, arg1)
	return _VarintBytes(var5.PackTag(arg0, arg1))
end

function _SimpleEncoder(arg0, arg1, arg2)
	return function(arg0, arg1, arg2)
		if arg2 then
			local var0 = TagBytes(arg0, var5.WIRETYPE_LENGTH_DELIMITED)
			local var1 = var6

			return function(arg0, arg1)
				arg0(var0)

				local var0 = 0

				for iter0, iter1 in var2(arg1) do
					var0 = var0 + arg2(iter1)
				end

				var1(arg0, var0)

				for iter2 in arg1 do
					arg1(arg0, iter2)
				end
			end
		elseif arg1 then
			local var2 = TagBytes(arg0, arg0)

			return function(arg0, arg1)
				for iter0, iter1 in var2(arg1) do
					arg0(var2)
					arg1(arg0, iter1)
				end
			end
		else
			local var3 = TagBytes(arg0, arg0)

			return function(arg0, arg1)
				arg0(var3)
				arg1(arg0, arg1)
			end
		end
	end
end

function _ModifiedEncoder(arg0, arg1, arg2, arg3)
	return function(arg0, arg1, arg2)
		if arg2 then
			local var0 = TagBytes(arg0, var5.WIRETYPE_LENGTH_DELIMITED)
			local var1 = var6

			return function(arg0, arg1)
				arg0(var0)

				local var0 = 0

				for iter0, iter1 in var2(arg1) do
					var0 = var0 + arg2(arg3(iter1))
				end

				var1(arg0, var0)

				for iter2, iter3 in var2(arg1) do
					arg1(arg0, arg3(iter3))
				end
			end
		elseif arg1 then
			local var2 = TagBytes(arg0, arg0)

			return function(arg0, arg1)
				for iter0, iter1 in var2(arg1) do
					arg0(var2)
					arg1(arg0, arg3(iter1))
				end
			end
		else
			local var3 = TagBytes(arg0, arg0)

			return function(arg0, arg1)
				arg0(var3)
				arg1(arg0, arg3(arg1))
			end
		end
	end
end

function _StructPackEncoder(arg0, arg1, arg2)
	return function(arg0, arg1, arg2)
		local var0 = var4.struct_pack

		if arg2 then
			local var1 = TagBytes(arg0, var5.WIRETYPE_LENGTH_DELIMITED)
			local var2 = var6

			return function(arg0, arg1)
				arg0(var1)
				var2(arg0, #arg1 * arg1)

				for iter0, iter1 in var2(arg1) do
					var0(arg0, arg2, iter1)
				end
			end
		elseif arg1 then
			local var3 = TagBytes(arg0, arg0)

			return function(arg0, arg1)
				for iter0, iter1 in var2(arg1) do
					arg0(var3)
					var0(arg0, arg2, iter1)
				end
			end
		else
			local var4 = TagBytes(arg0, arg0)

			return function(arg0, arg1)
				arg0(var4)
				var0(arg0, arg2, arg1)
			end
		end
	end
end

Int32Encoder = _SimpleEncoder(var5.WIRETYPE_VARINT, var7, _SignedVarintSize)
Int64Encoder = _SimpleEncoder(var5.WIRETYPE_VARINT, var9, _SignedVarintSize)
EnumEncoder = Int32Encoder
UInt32Encoder = _SimpleEncoder(var5.WIRETYPE_VARINT, var6, _VarintSize)
UInt64Encoder = _SimpleEncoder(var5.WIRETYPE_VARINT, var8, _VarintSize)
SInt32Encoder = _ModifiedEncoder(var5.WIRETYPE_VARINT, var6, _VarintSize, var5.ZigZagEncode32)
SInt64Encoder = _ModifiedEncoder(var5.WIRETYPE_VARINT, var8, _VarintSize, var5.ZigZagEncode64)
Fixed32Encoder = _StructPackEncoder(var5.WIRETYPE_FIXED32, 4, var0.byte("I"))
Fixed64Encoder = _StructPackEncoder(var5.WIRETYPE_FIXED64, 8, var0.byte("Q"))
SFixed32Encoder = _StructPackEncoder(var5.WIRETYPE_FIXED32, 4, var0.byte("i"))
SFixed64Encoder = _StructPackEncoder(var5.WIRETYPE_FIXED64, 8, var0.byte("q"))
FloatEncoder = _StructPackEncoder(var5.WIRETYPE_FIXED32, 4, var0.byte("f"))
DoubleEncoder = _StructPackEncoder(var5.WIRETYPE_FIXED64, 8, var0.byte("d"))

function BoolEncoder(arg0, arg1, arg2)
	local var0 = "\x00"
	local var1 = "\x01"

	if arg2 then
		local var2 = TagBytes(arg0, var5.WIRETYPE_LENGTH_DELIMITED)
		local var3 = var6

		return function(arg0, arg1)
			arg0(var2)
			var3(arg0, #arg1)

			for iter0, iter1 in var2(arg1) do
				if iter1 then
					arg0(var1)
				else
					arg0(var0)
				end
			end
		end
	elseif arg1 then
		local var4 = TagBytes(arg0, var5.WIRETYPE_VARINT)

		return function(arg0, arg1)
			for iter0, iter1 in var2(arg1) do
				arg0(var4)

				if iter1 then
					arg0(var1)
				else
					arg0(var0)
				end
			end
		end
	else
		local var5 = TagBytes(arg0, var5.WIRETYPE_VARINT)

		return function(arg0, arg1)
			arg0(var5)

			if arg1 then
				return arg0(var1)
			end

			return arg0(var0)
		end
	end
end

function StringEncoder(arg0, arg1, arg2)
	local var0 = TagBytes(arg0, var5.WIRETYPE_LENGTH_DELIMITED)
	local var1 = var6

	var3(not arg2)

	if arg1 then
		return function(arg0, arg1)
			for iter0, iter1 in var2(arg1) do
				arg0(var0)
				var1(arg0, #iter1)
				arg0(iter1)
			end
		end
	else
		return function(arg0, arg1)
			arg0(var0)
			var1(arg0, #arg1)

			return arg0(arg1)
		end
	end
end

function BytesEncoder(arg0, arg1, arg2)
	local var0 = TagBytes(arg0, var5.WIRETYPE_LENGTH_DELIMITED)
	local var1 = var6

	var3(not arg2)

	if arg1 then
		return function(arg0, arg1)
			for iter0, iter1 in var2(arg1) do
				arg0(var0)
				var1(arg0, #iter1)
				arg0(iter1)
			end
		end
	else
		return function(arg0, arg1)
			arg0(var0)
			var1(arg0, #arg1)

			return arg0(arg1)
		end
	end
end

function MessageEncoder(arg0, arg1, arg2)
	local var0 = TagBytes(arg0, var5.WIRETYPE_LENGTH_DELIMITED)
	local var1 = var6

	var3(not arg2)

	if arg1 then
		return function(arg0, arg1)
			for iter0, iter1 in var2(arg1) do
				arg0(var0)
				var1(arg0, iter1:ByteSize())
				iter1:_InternalSerialize(arg0)
			end
		end
	else
		return function(arg0, arg1)
			arg0(var0)
			var1(arg0, arg1:ByteSize())

			return arg1:_InternalSerialize(arg0)
		end
	end
end
