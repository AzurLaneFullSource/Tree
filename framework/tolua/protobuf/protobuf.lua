local var0_0 = setmetatable
local var1_0 = rawset
local var2_0 = rawget
local var3_0 = error
local var4_0 = ipairs
local var5_0 = pairs
local var6_0 = print
local var7_0 = table
local var8_0 = string
local var9_0 = tostring
local var10_0 = type
local var11_0 = require("pb")
local var12_0 = require("protobuf.wire_format")
local var13_0 = require("protobuf.type_checkers")
local var14_0 = require("protobuf.encoder")
local var15_0 = require("protobuf.decoder")
local var16_0 = require("protobuf.listener")
local var17_0 = require("protobuf.containers")
local var18_0 = require("protobuf.descriptor").FieldDescriptor
local var19_0 = require("protobuf.text_format")

module("protobuf.protobuf")

local function var20_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		__newindex = function(arg0_2, arg1_2, arg2_2)
			if arg2_1[arg1_2] then
				var1_0(arg0_2, arg1_2, arg2_2)
			else
				var3_0("error key: " .. arg1_2)
			end
		end
	}

	var0_1.__index = var0_1

	function var0_1.__call()
		return var0_0({}, var0_1)
	end

	_M[arg0_1] = var0_0(arg1_1, var0_1)
end

var20_0("Descriptor", {}, {
	full_name = true,
	name = true,
	containing_type = true,
	is_extendable = true,
	extensions = true,
	fields = true,
	filename = true,
	nested_types = true,
	options = true,
	enum_types = true,
	extension_ranges = true
})
var20_0("FieldDescriptor", var18_0, {
	full_name = true,
	name = true,
	containing_type = true,
	type = true,
	index = true,
	label = true,
	default_value = true,
	number = true,
	extension_scope = true,
	is_extension = true,
	enum_type = true,
	has_default_value = true,
	message_type = true,
	cpp_type = true
})
var20_0("EnumDescriptor", {}, {
	full_name = true,
	values = true,
	containing_type = true,
	name = true,
	options = true
})
var20_0("EnumValueDescriptor", {}, {
	index = true,
	name = true,
	type = true,
	options = true,
	number = true
})

local var21_0 = {
	[var18_0.TYPE_DOUBLE] = var12_0.WIRETYPE_FIXED64,
	[var18_0.TYPE_FLOAT] = var12_0.WIRETYPE_FIXED32,
	[var18_0.TYPE_INT64] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_UINT64] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_INT32] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_FIXED64] = var12_0.WIRETYPE_FIXED64,
	[var18_0.TYPE_FIXED32] = var12_0.WIRETYPE_FIXED32,
	[var18_0.TYPE_BOOL] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_STRING] = var12_0.WIRETYPE_LENGTH_DELIMITED,
	[var18_0.TYPE_GROUP] = var12_0.WIRETYPE_START_GROUP,
	[var18_0.TYPE_MESSAGE] = var12_0.WIRETYPE_LENGTH_DELIMITED,
	[var18_0.TYPE_BYTES] = var12_0.WIRETYPE_LENGTH_DELIMITED,
	[var18_0.TYPE_UINT32] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_ENUM] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_SFIXED32] = var12_0.WIRETYPE_FIXED32,
	[var18_0.TYPE_SFIXED64] = var12_0.WIRETYPE_FIXED64,
	[var18_0.TYPE_SINT32] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_SINT64] = var12_0.WIRETYPE_VARINT
}
local var22_0 = {
	[var18_0.TYPE_STRING] = true,
	[var18_0.TYPE_GROUP] = true,
	[var18_0.TYPE_MESSAGE] = true,
	[var18_0.TYPE_BYTES] = true
}
local var23_0 = {
	[var18_0.CPPTYPE_INT32] = var13_0.Int32ValueChecker(),
	[var18_0.CPPTYPE_INT64] = var13_0.TypeChecker({
		string = true,
		number = true
	}),
	[var18_0.CPPTYPE_UINT32] = var13_0.Uint32ValueChecker(),
	[var18_0.CPPTYPE_UINT64] = var13_0.TypeChecker({
		string = true,
		number = true
	}),
	[var18_0.CPPTYPE_DOUBLE] = var13_0.TypeChecker({
		number = true
	}),
	[var18_0.CPPTYPE_FLOAT] = var13_0.TypeChecker({
		number = true
	}),
	[var18_0.CPPTYPE_BOOL] = var13_0.TypeChecker({
		boolean = true,
		int = true,
		bool = true
	}),
	[var18_0.CPPTYPE_ENUM] = var13_0.Int32ValueChecker(),
	[var18_0.CPPTYPE_STRING] = var13_0.TypeChecker({
		string = true
	})
}
local var24_0 = {
	[var18_0.TYPE_DOUBLE] = var12_0.DoubleByteSize,
	[var18_0.TYPE_FLOAT] = var12_0.FloatByteSize,
	[var18_0.TYPE_INT64] = var12_0.Int64ByteSize,
	[var18_0.TYPE_UINT64] = var12_0.UInt64ByteSize,
	[var18_0.TYPE_INT32] = var12_0.Int32ByteSize,
	[var18_0.TYPE_FIXED64] = var12_0.Fixed64ByteSize,
	[var18_0.TYPE_FIXED32] = var12_0.Fixed32ByteSize,
	[var18_0.TYPE_BOOL] = var12_0.BoolByteSize,
	[var18_0.TYPE_STRING] = var12_0.StringByteSize,
	[var18_0.TYPE_GROUP] = var12_0.GroupByteSize,
	[var18_0.TYPE_MESSAGE] = var12_0.MessageByteSize,
	[var18_0.TYPE_BYTES] = var12_0.BytesByteSize,
	[var18_0.TYPE_UINT32] = var12_0.UInt32ByteSize,
	[var18_0.TYPE_ENUM] = var12_0.EnumByteSize,
	[var18_0.TYPE_SFIXED32] = var12_0.SFixed32ByteSize,
	[var18_0.TYPE_SFIXED64] = var12_0.SFixed64ByteSize,
	[var18_0.TYPE_SINT32] = var12_0.SInt32ByteSize,
	[var18_0.TYPE_SINT64] = var12_0.SInt64ByteSize
}
local var25_0 = {
	[var18_0.TYPE_DOUBLE] = var14_0.DoubleEncoder,
	[var18_0.TYPE_FLOAT] = var14_0.FloatEncoder,
	[var18_0.TYPE_INT64] = var14_0.Int64Encoder,
	[var18_0.TYPE_UINT64] = var14_0.UInt64Encoder,
	[var18_0.TYPE_INT32] = var14_0.Int32Encoder,
	[var18_0.TYPE_FIXED64] = var14_0.Fixed64Encoder,
	[var18_0.TYPE_FIXED32] = var14_0.Fixed32Encoder,
	[var18_0.TYPE_BOOL] = var14_0.BoolEncoder,
	[var18_0.TYPE_STRING] = var14_0.StringEncoder,
	[var18_0.TYPE_GROUP] = var14_0.GroupEncoder,
	[var18_0.TYPE_MESSAGE] = var14_0.MessageEncoder,
	[var18_0.TYPE_BYTES] = var14_0.BytesEncoder,
	[var18_0.TYPE_UINT32] = var14_0.UInt32Encoder,
	[var18_0.TYPE_ENUM] = var14_0.EnumEncoder,
	[var18_0.TYPE_SFIXED32] = var14_0.SFixed32Encoder,
	[var18_0.TYPE_SFIXED64] = var14_0.SFixed64Encoder,
	[var18_0.TYPE_SINT32] = var14_0.SInt32Encoder,
	[var18_0.TYPE_SINT64] = var14_0.SInt64Encoder
}
local var26_0 = {
	[var18_0.TYPE_DOUBLE] = var14_0.DoubleSizer,
	[var18_0.TYPE_FLOAT] = var14_0.FloatSizer,
	[var18_0.TYPE_INT64] = var14_0.Int64Sizer,
	[var18_0.TYPE_UINT64] = var14_0.UInt64Sizer,
	[var18_0.TYPE_INT32] = var14_0.Int32Sizer,
	[var18_0.TYPE_FIXED64] = var14_0.Fixed64Sizer,
	[var18_0.TYPE_FIXED32] = var14_0.Fixed32Sizer,
	[var18_0.TYPE_BOOL] = var14_0.BoolSizer,
	[var18_0.TYPE_STRING] = var14_0.StringSizer,
	[var18_0.TYPE_GROUP] = var14_0.GroupSizer,
	[var18_0.TYPE_MESSAGE] = var14_0.MessageSizer,
	[var18_0.TYPE_BYTES] = var14_0.BytesSizer,
	[var18_0.TYPE_UINT32] = var14_0.UInt32Sizer,
	[var18_0.TYPE_ENUM] = var14_0.EnumSizer,
	[var18_0.TYPE_SFIXED32] = var14_0.SFixed32Sizer,
	[var18_0.TYPE_SFIXED64] = var14_0.SFixed64Sizer,
	[var18_0.TYPE_SINT32] = var14_0.SInt32Sizer,
	[var18_0.TYPE_SINT64] = var14_0.SInt64Sizer
}
local var27_0 = {
	[var18_0.TYPE_DOUBLE] = var15_0.DoubleDecoder,
	[var18_0.TYPE_FLOAT] = var15_0.FloatDecoder,
	[var18_0.TYPE_INT64] = var15_0.Int64Decoder,
	[var18_0.TYPE_UINT64] = var15_0.UInt64Decoder,
	[var18_0.TYPE_INT32] = var15_0.Int32Decoder,
	[var18_0.TYPE_FIXED64] = var15_0.Fixed64Decoder,
	[var18_0.TYPE_FIXED32] = var15_0.Fixed32Decoder,
	[var18_0.TYPE_BOOL] = var15_0.BoolDecoder,
	[var18_0.TYPE_STRING] = var15_0.StringDecoder,
	[var18_0.TYPE_GROUP] = var15_0.GroupDecoder,
	[var18_0.TYPE_MESSAGE] = var15_0.MessageDecoder,
	[var18_0.TYPE_BYTES] = var15_0.BytesDecoder,
	[var18_0.TYPE_UINT32] = var15_0.UInt32Decoder,
	[var18_0.TYPE_ENUM] = var15_0.EnumDecoder,
	[var18_0.TYPE_SFIXED32] = var15_0.SFixed32Decoder,
	[var18_0.TYPE_SFIXED64] = var15_0.SFixed64Decoder,
	[var18_0.TYPE_SINT32] = var15_0.SInt32Decoder,
	[var18_0.TYPE_SINT64] = var15_0.SInt64Decoder
}
local var28_0 = {
	[var18_0.TYPE_DOUBLE] = var12_0.WIRETYPE_FIXED64,
	[var18_0.TYPE_FLOAT] = var12_0.WIRETYPE_FIXED32,
	[var18_0.TYPE_INT64] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_UINT64] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_INT32] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_FIXED64] = var12_0.WIRETYPE_FIXED64,
	[var18_0.TYPE_FIXED32] = var12_0.WIRETYPE_FIXED32,
	[var18_0.TYPE_BOOL] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_STRING] = var12_0.WIRETYPE_LENGTH_DELIMITED,
	[var18_0.TYPE_GROUP] = var12_0.WIRETYPE_START_GROUP,
	[var18_0.TYPE_MESSAGE] = var12_0.WIRETYPE_LENGTH_DELIMITED,
	[var18_0.TYPE_BYTES] = var12_0.WIRETYPE_LENGTH_DELIMITED,
	[var18_0.TYPE_UINT32] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_ENUM] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_SFIXED32] = var12_0.WIRETYPE_FIXED32,
	[var18_0.TYPE_SFIXED64] = var12_0.WIRETYPE_FIXED64,
	[var18_0.TYPE_SINT32] = var12_0.WIRETYPE_VARINT,
	[var18_0.TYPE_SINT64] = var12_0.WIRETYPE_VARINT
}

local function var29_0(arg0_4)
	return var22_0[arg0_4] == nil
end

local function var30_0(arg0_5, arg1_5)
	if arg0_5 == var18_0.CPPTYPE_STRING and arg1_5 == var18_0.TYPE_STRING then
		return var13_0.UnicodeValueChecker()
	end

	return var23_0[arg0_5]
end

local function var31_0(arg0_6)
	if arg0_6.label == var18_0.LABEL_REPEATED then
		if var10_0(arg0_6.default_value) ~= "table" or #arg0_6.default_value ~= 0 then
			var3_0("Repeated field default value not empty list:" .. var9_0(arg0_6.default_value))
		end

		if arg0_6.cpp_type == var18_0.CPPTYPE_MESSAGE then
			local var0_6 = arg0_6.message_type

			return function(arg0_7)
				return var17_0.RepeatedCompositeFieldContainer(arg0_7._listener_for_children, var0_6)
			end
		else
			local var1_6 = var30_0(arg0_6.cpp_type, arg0_6.type)

			return function(arg0_8)
				return var17_0.RepeatedScalarFieldContainer(arg0_8._listener_for_children, var1_6)
			end
		end
	end

	if arg0_6.cpp_type == var18_0.CPPTYPE_MESSAGE then
		local var2_6 = arg0_6.message_type

		return function(arg0_9)
			result = var2_6._concrete_class()

			result._SetListener(arg0_9._listener_for_children)

			return result
		end
	end

	return function(arg0_10)
		return arg0_6.default_value
	end
end

local function var32_0(arg0_11, arg1_11)
	local var0_11 = arg1_11.label == var18_0.LABEL_REPEATED
	local var1_11 = arg1_11.has_options and arg1_11.GetOptions().packed

	var1_0(arg1_11, "_encoder", var25_0[arg1_11.type](arg1_11.number, var0_11, var1_11))
	var1_0(arg1_11, "_sizer", var26_0[arg1_11.type](arg1_11.number, var0_11, var1_11))
	var1_0(arg1_11, "_default_constructor", var31_0(arg1_11))

	local function var2_11(arg0_12, arg1_12)
		local var0_12 = var14_0.TagBytes(arg1_11.number, arg0_12)

		arg0_11._decoders_by_tag[var0_12] = var27_0[arg1_11.type](arg1_11.number, var0_11, arg1_12, arg1_11, arg1_11._default_constructor)
	end

	var2_11(var28_0[arg1_11.type], False)

	if var0_11 and var29_0(arg1_11.type) then
		var2_11(var12_0.WIRETYPE_LENGTH_DELIMITED, True)
	end
end

local function var33_0(arg0_13, arg1_13)
	for iter0_13, iter1_13 in var4_0(arg0_13.enum_types) do
		for iter2_13, iter3_13 in var4_0(iter1_13.values) do
			arg1_13._member[iter3_13.name] = iter3_13.number
		end
	end
end

local function var34_0(arg0_14)
	return function()
		local var0_15 = {}

		var0_15._cached_byte_size = 0
		var0_15._cached_byte_size_dirty = false
		var0_15._fields = {}
		var0_15._is_present_in_parent = false
		var0_15._listener = var16_0.NullMessageListener()
		var0_15._listener_for_children = var16_0.Listener(var0_15)

		return var0_0(var0_15, arg0_14)
	end
end

local function var35_0(arg0_16, arg1_16)
	local var0_16 = arg0_16.name

	arg1_16._getter[var0_16] = function(arg0_17)
		local var0_17 = arg0_17._fields[arg0_16]

		if var0_17 == nil then
			var0_17 = arg0_16._default_constructor(arg0_17)
			arg0_17._fields[arg0_16] = var0_17

			if not arg0_17._cached_byte_size_dirty then
				arg1_16._member._Modified(arg0_17)
			end
		end

		return var0_17
	end
	arg1_16._setter[var0_16] = function(arg0_18)
		var3_0("Assignment not allowed to repeated field \"" .. var0_16 .. "\" in protocol message object.")
	end
end

local function var36_0(arg0_19, arg1_19)
	local var0_19 = arg0_19.name
	local var1_19 = arg0_19.message_type

	arg1_19._getter[var0_19] = function(arg0_20)
		local var0_20 = arg0_20._fields[arg0_19]

		if var0_20 == nil then
			var0_20 = var1_19._concrete_class()

			var0_20:_SetListener(arg0_20._listener_for_children)

			arg0_20._fields[arg0_19] = var0_20

			if not arg0_20._cached_byte_size_dirty then
				arg1_19._member._Modified(arg0_20)
			end
		end

		return var0_20
	end
	arg1_19._setter[var0_19] = function(arg0_21, arg1_21)
		var3_0("Assignment not allowed to composite field" .. var0_19 .. "in protocol message object.")
	end
end

local function var37_0(arg0_22, arg1_22)
	local var0_22 = arg0_22.name
	local var1_22 = var30_0(arg0_22.cpp_type, arg0_22.type)
	local var2_22 = arg0_22.default_value

	arg1_22._getter[var0_22] = function(arg0_23)
		if arg0_23._fields[arg0_22] ~= nil then
			return arg0_23._fields[arg0_22]
		else
			return var2_22
		end
	end
	arg1_22._setter[var0_22] = function(arg0_24, arg1_24)
		var1_22(arg1_24)

		arg0_24._fields[arg0_22] = arg1_24

		if not arg0_24._cached_byte_size_dirty then
			arg1_22._member._Modified(arg0_24)
		end
	end
end

local function var38_0(arg0_25, arg1_25)
	constant_name = arg0_25.name:upper() .. "_FIELD_NUMBER"
	arg1_25._member[constant_name] = arg0_25.number

	if arg0_25.label == var18_0.LABEL_REPEATED then
		var35_0(arg0_25, arg1_25)
	elseif arg0_25.cpp_type == var18_0.CPPTYPE_MESSAGE then
		var36_0(arg0_25, arg1_25)
	else
		var37_0(arg0_25, arg1_25)
	end
end

local var39_0 = {
	__index = function(arg0_26, arg1_26)
		local var0_26 = var2_0(arg0_26, "_extended_message")
		local var1_26 = var0_26._fields[arg1_26]

		if var1_26 ~= nil then
			return var1_26
		end

		if arg1_26.label == var18_0.LABEL_REPEATED then
			var1_26 = arg1_26._default_constructor(arg0_26._extended_message)
		elseif arg1_26.cpp_type == var18_0.CPPTYPE_MESSAGE then
			var1_26 = arg1_26.message_type._concrete_class()

			var1_26:_SetListener(var0_26._listener_for_children)
		else
			return arg1_26.default_value
		end

		var0_26._fields[arg1_26] = var1_26

		return var1_26
	end,
	__newindex = function(arg0_27, arg1_27, arg2_27)
		local var0_27 = var2_0(arg0_27, "_extended_message")

		if arg1_27.label == var18_0.LABEL_REPEATED or arg1_27.cpp_type == var18_0.CPPTYPE_MESSAGE then
			var3_0("Cannot assign to extension \"" .. arg1_27.full_name .. "\" because it is a repeated or composite type.")
		end

		var30_0(arg1_27.cpp_type, arg1_27.type).CheckValue(arg2_27)

		var0_27._fields[arg1_27] = arg2_27

		var0_27._Modified()
	end
}

local function var40_0(arg0_28)
	local var0_28 = {
		_extended_message = arg0_28
	}

	return var0_0(var0_28, var39_0)
end

local function var41_0(arg0_29, arg1_29)
	for iter0_29, iter1_29 in var4_0(arg0_29.fields) do
		var38_0(iter1_29, arg1_29)
	end

	if arg0_29.is_extendable then
		function arg1_29._getter.Extensions(arg0_30)
			return var40_0(arg0_30)
		end
	end
end

local function var42_0(arg0_31, arg1_31)
	local var0_31 = arg0_31._extensions_by_name

	for iter0_31, iter1_31 in var5_0(var0_31) do
		local var1_31 = var8_0.upper(iter0_31) .. "_FIELD_NUMBER"

		arg1_31._member[var1_31] = iter1_31.number
	end
end

local function var43_0(arg0_32)
	function arg0_32._member.RegisterExtension(arg0_33)
		arg0_33.containing_type = arg0_32._descriptor

		var32_0(arg0_32, arg0_33)

		if arg0_32._extensions_by_number[arg0_33.number] == nil then
			arg0_32._extensions_by_number[arg0_33.number] = arg0_33
		else
			var3_0(var8_0.format("Extensions \"%s\" and \"%s\" both try to extend message type \"%s\" with field number %d.", arg0_33.full_name, actual_handle.full_name, arg0_32._descriptor.full_name, arg0_33.number))
		end

		arg0_32._extensions_by_name[arg0_33.full_name] = arg0_33
	end

	function arg0_32._member.FromString(arg0_34)
		local var0_34 = arg0_32._member.__call()

		var0_34.MergeFromString(arg0_34)

		return var0_34
	end
end

local function var44_0(arg0_35, arg1_35)
	if arg0_35.label == var18_0.LABEL_REPEATED then
		return arg1_35
	elseif arg0_35.cpp_type == var18_0.CPPTYPE_MESSAGE then
		return arg1_35._is_present_in_parent
	else
		return true
	end
end

function sortFunc(arg0_36, arg1_36)
	return arg0_36.index < arg1_36.index
end

function pairsByKeys(arg0_37, arg1_37)
	local var0_37 = {}

	for iter0_37 in var5_0(arg0_37) do
		var7_0.insert(var0_37, iter0_37)
	end

	var7_0.sort(var0_37, arg1_37)

	local var1_37 = 0

	return function()
		var1_37 = var1_37 + 1

		if var0_37[var1_37] == nil then
			return nil
		else
			return var0_37[var1_37], arg0_37[var0_37[var1_37]]
		end
	end
end

local function var45_0(arg0_39, arg1_39)
	function arg1_39._member.ListFields(arg0_40)
		return (function(arg0_41)
			local var0_41, var1_41, var2_41 = pairsByKeys(arg0_40._fields, sortFunc)

			return function(arg0_42, arg1_42)
				while true do
					local var0_42, var1_42 = var0_41(arg0_42, arg1_42)

					if var0_42 == nil then
						return
					elseif var44_0(var0_42, var1_42) then
						return var0_42, var1_42
					end
				end
			end, var1_41, var2_41
		end)(arg0_40._fields)
	end
end

local function var46_0(arg0_43, arg1_43)
	local var0_43 = {}

	for iter0_43, iter1_43 in var4_0(arg0_43.fields) do
		if iter1_43.label ~= var18_0.LABEL_REPEATED then
			var0_43[iter1_43.name] = iter1_43
		end
	end

	function arg1_43._member.HasField(arg0_44, arg1_44)
		field = var0_43[arg1_44]

		if field == nil then
			var3_0("Protocol message has no singular \"" .. arg1_44 .. "\" field.")
		end

		if field.cpp_type == var18_0.CPPTYPE_MESSAGE then
			value = arg0_44._fields[field]

			return value ~= nil and value._is_present_in_parent
		else
			return arg0_44._fields[field] ~= nil
		end
	end
end

local function var47_0(arg0_45, arg1_45)
	local var0_45 = {}

	for iter0_45, iter1_45 in var4_0(arg0_45.fields) do
		if iter1_45.label ~= var18_0.LABEL_REPEATED then
			var0_45[iter1_45.name] = iter1_45
		end
	end

	function arg1_45._member.ClearField(arg0_46, arg1_46)
		field = var0_45[arg1_46]

		if field == nil then
			var3_0("Protocol message has no singular \"" .. arg1_46 .. "\" field.")
		end

		if arg0_46._fields[field] then
			arg0_46._fields[field] = nil
		end

		arg1_45._member._Modified(arg0_46)
	end
end

local function var48_0(arg0_47)
	function arg0_47._member.ClearExtension(arg0_48, arg1_48)
		if arg0_48._fields[arg1_48] == nil then
			arg0_48._fields[arg1_48] = nil
		end

		arg0_47._member._Modified(arg0_48)
	end
end

local function var49_0(arg0_49, arg1_49)
	function arg1_49._member.Clear(arg0_50)
		arg0_50._fields = {}

		arg1_49._member._Modified(arg0_50)
	end
end

local function var50_0(arg0_51)
	local var0_51 = var19_0.msg_format

	function arg0_51.__tostring(arg0_52)
		return var0_51(arg0_52)
	end
end

local function var51_0(arg0_53)
	function arg0_53._member.HasExtension(arg0_54, arg1_54)
		if arg1_54.label == var18_0.LABEL_REPEATED then
			var3_0(arg1_54.full_name .. " is repeated.")
		end

		if arg1_54.cpp_type == var18_0.CPPTYPE_MESSAGE then
			value = arg0_54._fields[arg1_54]

			return value ~= nil and value._is_present_in_parent
		else
			return arg0_54._fields[arg1_54]
		end
	end
end

local function var52_0(arg0_55)
	function arg0_55._member._SetListener(arg0_56, arg1_56)
		if arg1_56 ~= nil then
			arg0_56._listener = var16_0.NullMessageListener()
		else
			arg0_56._listener = arg1_56
		end
	end
end

local function var53_0(arg0_57, arg1_57)
	function arg1_57._member.ByteSize(arg0_58)
		if not arg0_58._cached_byte_size_dirty and arg0_58._cached_byte_size > 0 then
			return arg0_58._cached_byte_size
		end

		local var0_58 = 0

		for iter0_58, iter1_58 in arg1_57._member.ListFields(arg0_58) do
			var0_58 = iter0_58._sizer(iter1_58) + var0_58
		end

		arg0_58._cached_byte_size = var0_58
		arg0_58._cached_byte_size_dirty = false
		arg0_58._listener_for_children.dirty = false

		return var0_58
	end
end

local function var54_0(arg0_59, arg1_59)
	function arg1_59._member.SerializeToString(arg0_60)
		if not arg1_59._member.IsInitialized(arg0_60) then
			var3_0("Message is missing required fields: " .. var7_0.concat(arg1_59._member.FindInitializationErrors(arg0_60), ","))
		end

		return arg1_59._member.SerializePartialToString(arg0_60)
	end

	function arg1_59._member.SerializeToIOString(arg0_61, arg1_61)
		if not arg1_59._member.IsInitialized(arg0_61) then
			var3_0("Message is missing required fields: " .. var7_0.concat(arg1_59._member.FindInitializationErrors(arg0_61), ","))
		end

		return arg1_59._member.SerializePartialToIOString(arg0_61, arg1_61)
	end
end

local function var55_0(arg0_62, arg1_62)
	local var0_62 = var7_0.concat

	local function var1_62(arg0_63, arg1_63)
		for iter0_63, iter1_63 in arg1_62._member.ListFields(arg0_63) do
			iter0_63._encoder(arg1_63, iter1_63)
		end
	end

	local function var2_62(arg0_64, arg1_64)
		local var0_64 = arg1_64.write

		local function var1_64(arg0_65)
			var0_64(arg1_64, arg0_65)
		end

		var1_62(arg0_64, var1_64)
	end

	local function var3_62(arg0_66)
		local var0_66 = {}

		local function var1_66(arg0_67)
			var0_66[#var0_66 + 1] = arg0_67
		end

		var1_62(arg0_66, var1_66)

		return var0_62(var0_66)
	end

	arg1_62._member._InternalSerialize = var1_62
	arg1_62._member.SerializePartialToIOString = var2_62
	arg1_62._member.SerializePartialToString = var3_62
end

local function var56_0(arg0_68, arg1_68)
	local var0_68 = var15_0.ReadTag
	local var1_68 = var15_0.SkipField
	local var2_68 = arg1_68._decoders_by_tag

	local function var3_68(arg0_69, arg1_69, arg2_69, arg3_69)
		arg1_68._member._Modified(arg0_69)

		local var0_69 = arg0_69._fields
		local var1_69
		local var2_69
		local var3_69

		while arg2_69 ~= arg3_69 do
			local var4_69, var5_69 = var0_68(arg1_69, arg2_69)
			local var6_69 = var2_68[var4_69]

			var6_0("===========================", var4_69)

			if var6_69 == nil then
				var5_69 = var1_68(arg1_69, var5_69, arg3_69, var4_69)

				if var5_69 == -1 then
					return arg2_69
				end

				arg2_69 = var5_69
			else
				arg2_69 = var6_69(arg1_69, var5_69, arg3_69, arg0_69, var0_69)
			end
		end

		return arg2_69
	end

	arg1_68._member._InternalParse = var3_68

	local function var4_68(arg0_70, arg1_70)
		local var0_70 = #arg1_70

		if var3_68(arg0_70, arg1_70, 0, var0_70) ~= var0_70 then
			var3_0("Unexpected end-group tag.")
		end

		return var0_70
	end

	arg1_68._member.MergeFromString = var4_68

	function arg1_68._member.ParseFromString(arg0_71, arg1_71)
		arg1_68._member.Clear(arg0_71)
		var6_0("------------------------------")
		var4_68(arg0_71, arg1_71)
	end
end

local function var57_0(arg0_72, arg1_72)
	local var0_72 = {}

	for iter0_72, iter1_72 in var4_0(arg0_72.fields) do
		if iter1_72.label == var18_0.LABEL_REQUIRED then
			var0_72[#var0_72 + 1] = iter1_72
		end
	end

	function arg1_72._member.IsInitialized(arg0_73, arg1_73)
		for iter0_73, iter1_73 in var4_0(var0_72) do
			if arg0_73._fields[iter1_73] == nil or iter1_73.cpp_type == var18_0.CPPTYPE_MESSAGE and not arg0_73._fields[iter1_73]._is_present_in_parent then
				if arg1_73 ~= nil then
					arg1_73[#arg1_73 + 1] = arg1_72._member.FindInitializationErrors(arg0_73)
				end

				return false
			end
		end

		for iter2_73, iter3_73 in var5_0(arg0_73._fields) do
			if iter2_73.cpp_type == var18_0.CPPTYPE_MESSAGE then
				if iter2_73.label == var18_0.LABEL_REPEATED then
					for iter4_73, iter5_73 in var4_0(iter3_73) do
						if not iter5_73:IsInitialized() then
							if arg1_73 ~= nil then
								arg1_73[#arg1_73 + 1] = arg1_72._member.FindInitializationErrors(arg0_73)
							end

							return false
						end
					end
				elseif iter3_73._is_present_in_parent and not iter3_73:IsInitialized() then
					if arg1_73 ~= nil then
						arg1_73[#arg1_73 + 1] = arg1_72._member.FindInitializationErrors(arg0_73)
					end

					return false
				end
			end
		end

		return true
	end

	function arg1_72._member.FindInitializationErrors(arg0_74)
		local var0_74 = {}

		for iter0_74, iter1_74 in var4_0(var0_72) do
			if not arg1_72._member.HasField(arg0_74, iter1_74.name) then
				var0_74[#var0_74 + 1] = iter1_74.name
			end
		end

		for iter2_74, iter3_74 in arg1_72._member.ListFields(arg0_74) do
			if iter2_74.cpp_type == var18_0.CPPTYPE_MESSAGE then
				if iter2_74.is_extension then
					name = var8_0.format("(%s)", iter2_74.full_name)
				else
					name = iter2_74.name
				end

				if iter2_74.label == var18_0.LABEL_REPEATED then
					for iter4_74, iter5_74 in var4_0(iter3_74) do
						prefix = var8_0.format("%s[%d].", name, iter4_74)
						sub_errors = iter5_74:FindInitializationErrors()

						for iter6_74, iter7_74 in var4_0(sub_errors) do
							var0_74[#var0_74 + 1] = prefix .. iter7_74
						end
					end
				else
					prefix = name .. "."
					sub_errors = iter3_74:FindInitializationErrors()

					for iter8_74, iter9_74 in var4_0(sub_errors) do
						var0_74[#var0_74 + 1] = prefix .. iter9_74
					end
				end
			end
		end

		return var0_74
	end
end

local function var58_0(arg0_75)
	local var0_75 = var18_0.LABEL_REPEATED
	local var1_75 = var18_0.CPPTYPE_MESSAGE

	function arg0_75._member.MergeFrom(arg0_76, arg1_76)
		assert(arg1_76 ~= arg0_76)
		arg0_75._member._Modified(arg0_76)

		local var0_76 = arg0_76._fields

		for iter0_76, iter1_76 in var5_0(arg1_76._fields) do
			if iter0_76.label == var0_75 or iter0_76.cpp_type == var1_75 then
				field_value = var0_76[iter0_76]

				if field_value == nil then
					field_value = iter0_76._default_constructor(arg0_76)
					var0_76[iter0_76] = field_value
				end

				field_value:MergeFrom(iter1_76)
			else
				arg0_76._fields[iter0_76] = iter1_76
			end
		end
	end
end

local function var59_0(arg0_77, arg1_77)
	var45_0(arg0_77, arg1_77)
	var46_0(arg0_77, arg1_77)
	var47_0(arg0_77, arg1_77)

	if arg0_77.is_extendable then
		var48_0(arg1_77)
		var51_0(arg1_77)
	end

	var49_0(arg0_77, arg1_77)
	var50_0(arg1_77)
	var52_0(arg1_77)
	var53_0(arg0_77, arg1_77)
	var54_0(arg0_77, arg1_77)
	var55_0(arg0_77, arg1_77)
	var56_0(arg0_77, arg1_77)
	var57_0(arg0_77, arg1_77)
	var58_0(arg1_77)
end

local function var60_0(arg0_78)
	local function var0_78(arg0_79)
		if not arg0_79._cached_byte_size_dirty then
			arg0_79._cached_byte_size_dirty = true
			arg0_79._listener_for_children.dirty = true
			arg0_79._is_present_in_parent = true

			arg0_79._listener:Modified()
		end
	end

	arg0_78._member._Modified = var0_78
	arg0_78._member.SetInParent = var0_78
end

local function var61_0(arg0_80)
	local var0_80 = arg0_80._getter
	local var1_80 = arg0_80._member

	return function(arg0_81, arg1_81)
		local var0_81 = var0_80[arg1_81]

		if var0_81 then
			return var0_81(arg0_81)
		else
			return var1_80[arg1_81]
		end
	end
end

local function var62_0(arg0_82)
	local var0_82 = arg0_82._setter

	return function(arg0_83, arg1_83, arg2_83)
		local var0_83 = var0_82[arg1_83]

		if var0_83 then
			var0_83(arg0_83, arg2_83)
		else
			var3_0(arg1_83 .. " not found")
		end
	end
end

function _AddClassAttributesForNestedExtensions(arg0_84, arg1_84)
	local var0_84 = arg0_84._extensions_by_name

	for iter0_84, iter1_84 in var5_0(var0_84) do
		arg1_84._member[iter0_84] = iter1_84
	end
end

local function var63_0(arg0_85)
	local var0_85 = {
		_decoders_by_tag = {}
	}

	var1_0(arg0_85, "_extensions_by_name", {})

	for iter0_85, iter1_85 in var4_0(arg0_85.extensions) do
		arg0_85._extensions_by_name[iter1_85.name] = iter1_85
	end

	var1_0(arg0_85, "_extensions_by_number", {})

	for iter2_85, iter3_85 in var4_0(arg0_85.extensions) do
		arg0_85._extensions_by_number[iter3_85.number] = iter3_85
	end

	var0_85._descriptor = arg0_85
	var0_85._extensions_by_name = {}
	var0_85._extensions_by_number = {}
	var0_85._getter = {}
	var0_85._setter = {}
	var0_85._member = {}

	local var1_85 = var0_0({}, var0_85._member)

	var0_85._member.__call = var34_0(var0_85)
	var0_85._member.__index = var0_85._member
	var0_85._member.type = var1_85

	if var2_0(arg0_85, "_concrete_class") == nil then
		var1_0(arg0_85, "_concrete_class", var1_85)

		for iter4_85, iter5_85 in var4_0(arg0_85.fields) do
			var32_0(var0_85, iter5_85)
		end
	end

	var33_0(arg0_85, var0_85)
	_AddClassAttributesForNestedExtensions(arg0_85, var0_85)
	var41_0(arg0_85, var0_85)
	var42_0(arg0_85, var0_85)
	var43_0(var0_85)
	var59_0(arg0_85, var0_85)
	var60_0(var0_85)

	var0_85.__index = var61_0(var0_85)
	var0_85.__newindex = var62_0(var0_85)

	return var1_85
end

_M.Message = var63_0
