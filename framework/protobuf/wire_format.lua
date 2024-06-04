local var0 = require("pb")

module("wire_format")

WIRETYPE_VARINT = 0
WIRETYPE_FIXED64 = 1
WIRETYPE_LENGTH_DELIMITED = 2
WIRETYPE_START_GROUP = 3
WIRETYPE_END_GROUP = 4
WIRETYPE_FIXED32 = 5
_WIRETYPE_MAX = 5

local function var1(arg0)
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

	return 5
end

function PackTag(arg0, arg1)
	return arg0 * 8 + arg1
end

function UnpackTag(arg0)
	local var0 = arg0 % 8

	return (arg0 - var0) / 8, var0
end

ZigZagEncode32 = var0.zig_zag_encode32
ZigZagDecode32 = var0.zig_zag_decode32
ZigZagEncode64 = var0.zig_zag_encode64
ZigZagDecode64 = var0.zig_zag_decode64

function Int32ByteSize(arg0, arg1)
	return Int64ByteSize(arg0, arg1)
end

function Int32ByteSizeNoTag(arg0)
	return var1(arg0)
end

function Int64ByteSize(arg0, arg1)
	return UInt64ByteSize(arg0, arg1)
end

function UInt32ByteSize(arg0, arg1)
	return UInt64ByteSize(arg0, arg1)
end

function UInt64ByteSize(arg0, arg1)
	return TagByteSize(arg0) + var1(arg1)
end

function SInt32ByteSize(arg0, arg1)
	return UInt32ByteSize(arg0, ZigZagEncode(arg1))
end

function SInt64ByteSize(arg0, arg1)
	return UInt64ByteSize(arg0, ZigZagEncode(arg1))
end

function Fixed32ByteSize(arg0, arg1)
	return TagByteSize(arg0) + 4
end

function Fixed64ByteSize(arg0, arg1)
	return TagByteSize(arg0) + 8
end

function SFixed32ByteSize(arg0, arg1)
	return TagByteSize(arg0) + 4
end

function SFixed64ByteSize(arg0, arg1)
	return TagByteSize(arg0) + 8
end

function FloatByteSize(arg0, arg1)
	return TagByteSize(arg0) + 4
end

function DoubleByteSize(arg0, arg1)
	return TagByteSize(arg0) + 8
end

function BoolByteSize(arg0, arg1)
	return TagByteSize(arg0) + 1
end

function EnumByteSize(arg0, arg1)
	return UInt32ByteSize(arg0, arg1)
end

function StringByteSize(arg0, arg1)
	return BytesByteSize(arg0, arg1)
end

function BytesByteSize(arg0, arg1)
	return TagByteSize(arg0) + var1(#arg1) + #arg1
end

function MessageByteSize(arg0, arg1)
	return TagByteSize(arg0) + var1(arg1.ByteSize()) + arg1.ByteSize()
end

function MessageSetItemByteSize(arg0, arg1)
	local var0 = 2 * TagByteSize(1) + TagByteSize(2) + TagByteSize(3) + var1(arg0)
	local var1 = arg1.ByteSize()

	return var0 + var1(var1) + var1
end

function TagByteSize(arg0)
	return var1(PackTag(arg0, 0))
end
