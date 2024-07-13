local var0_0 = require("pb")

module("protobuf.wire_format")

WIRETYPE_VARINT = 0
WIRETYPE_FIXED64 = 1
WIRETYPE_LENGTH_DELIMITED = 2
WIRETYPE_START_GROUP = 3
WIRETYPE_END_GROUP = 4
WIRETYPE_FIXED32 = 5
_WIRETYPE_MAX = 5

local function var1_0(arg0_1)
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

function PackTag(arg0_2, arg1_2)
	return arg0_2 * 8 + arg1_2
end

function UnpackTag(arg0_3)
	local var0_3 = arg0_3 % 8

	return (arg0_3 - var0_3) / 8, var0_3
end

ZigZagEncode32 = var0_0.zig_zag_encode32
ZigZagDecode32 = var0_0.zig_zag_decode32
ZigZagEncode64 = var0_0.zig_zag_encode64
ZigZagDecode64 = var0_0.zig_zag_decode64

function Int32ByteSize(arg0_4, arg1_4)
	return Int64ByteSize(arg0_4, arg1_4)
end

function Int32ByteSizeNoTag(arg0_5)
	return var1_0(arg0_5)
end

function Int64ByteSize(arg0_6, arg1_6)
	return UInt64ByteSize(arg0_6, arg1_6)
end

function UInt32ByteSize(arg0_7, arg1_7)
	return UInt64ByteSize(arg0_7, arg1_7)
end

function UInt64ByteSize(arg0_8, arg1_8)
	return TagByteSize(arg0_8) + var1_0(arg1_8)
end

function SInt32ByteSize(arg0_9, arg1_9)
	return UInt32ByteSize(arg0_9, ZigZagEncode(arg1_9))
end

function SInt64ByteSize(arg0_10, arg1_10)
	return UInt64ByteSize(arg0_10, ZigZagEncode(arg1_10))
end

function Fixed32ByteSize(arg0_11, arg1_11)
	return TagByteSize(arg0_11) + 4
end

function Fixed64ByteSize(arg0_12, arg1_12)
	return TagByteSize(arg0_12) + 8
end

function SFixed32ByteSize(arg0_13, arg1_13)
	return TagByteSize(arg0_13) + 4
end

function SFixed64ByteSize(arg0_14, arg1_14)
	return TagByteSize(arg0_14) + 8
end

function FloatByteSize(arg0_15, arg1_15)
	return TagByteSize(arg0_15) + 4
end

function DoubleByteSize(arg0_16, arg1_16)
	return TagByteSize(arg0_16) + 8
end

function BoolByteSize(arg0_17, arg1_17)
	return TagByteSize(arg0_17) + 1
end

function EnumByteSize(arg0_18, arg1_18)
	return UInt32ByteSize(arg0_18, arg1_18)
end

function StringByteSize(arg0_19, arg1_19)
	return BytesByteSize(arg0_19, arg1_19)
end

function BytesByteSize(arg0_20, arg1_20)
	return TagByteSize(arg0_20) + var1_0(#arg1_20) + #arg1_20
end

function MessageByteSize(arg0_21, arg1_21)
	return TagByteSize(arg0_21) + var1_0(arg1_21.ByteSize()) + arg1_21.ByteSize()
end

function MessageSetItemByteSize(arg0_22, arg1_22)
	local var0_22 = 2 * TagByteSize(1) + TagByteSize(2) + TagByteSize(3) + var1_0(arg0_22)
	local var1_22 = arg1_22.ByteSize()

	return var0_22 + var1_0(var1_22) + var1_22
end

function TagByteSize(arg0_23)
	return var1_0(PackTag(arg0_23, 0))
end
