local var0 = setmetatable
local var1 = rawset
local var2 = rawget
local var3 = error
local var4 = ipairs
local var5 = pairs
local var6 = print
local var7 = table
local var8 = string
local var9 = tostring
local var10 = type
local var11 = require("pb")
local var12 = require("wire_format")
local var13 = require("type_checkers")
local var14 = require("encoder")
local var15 = require("decoder")
local var16 = require("listener")
local var17 = require("containers")
local var18 = require("descriptor").FieldDescriptor
local var19 = require("text_format")

module("protobuf")

local function var20(arg0, arg1, arg2)
	local var0 = {
		__newindex = function(arg0, arg1, arg2)
			if arg2[arg1] then
				var1(arg0, arg1, arg2)
			else
				var3("error key: " .. arg1)
			end
		end
	}

	var0.__index = var0

	function var0.__call()
		return var0({}, var0)
	end

	_M[arg0] = var0(arg1, var0)
end

var20("Descriptor", {}, {
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
var20("FieldDescriptor", var18, {
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
var20("EnumDescriptor", {}, {
	full_name = true,
	values = true,
	containing_type = true,
	name = true,
	options = true
})
var20("EnumValueDescriptor", {}, {
	index = true,
	name = true,
	type = true,
	options = true,
	number = true
})

local var21 = {
	[var18.TYPE_DOUBLE] = var12.WIRETYPE_FIXED64,
	[var18.TYPE_FLOAT] = var12.WIRETYPE_FIXED32,
	[var18.TYPE_INT64] = var12.WIRETYPE_VARINT,
	[var18.TYPE_UINT64] = var12.WIRETYPE_VARINT,
	[var18.TYPE_INT32] = var12.WIRETYPE_VARINT,
	[var18.TYPE_FIXED64] = var12.WIRETYPE_FIXED64,
	[var18.TYPE_FIXED32] = var12.WIRETYPE_FIXED32,
	[var18.TYPE_BOOL] = var12.WIRETYPE_VARINT,
	[var18.TYPE_STRING] = var12.WIRETYPE_LENGTH_DELIMITED,
	[var18.TYPE_GROUP] = var12.WIRETYPE_START_GROUP,
	[var18.TYPE_MESSAGE] = var12.WIRETYPE_LENGTH_DELIMITED,
	[var18.TYPE_BYTES] = var12.WIRETYPE_LENGTH_DELIMITED,
	[var18.TYPE_UINT32] = var12.WIRETYPE_VARINT,
	[var18.TYPE_ENUM] = var12.WIRETYPE_VARINT,
	[var18.TYPE_SFIXED32] = var12.WIRETYPE_FIXED32,
	[var18.TYPE_SFIXED64] = var12.WIRETYPE_FIXED64,
	[var18.TYPE_SINT32] = var12.WIRETYPE_VARINT,
	[var18.TYPE_SINT64] = var12.WIRETYPE_VARINT
}
local var22 = {
	[var18.TYPE_STRING] = true,
	[var18.TYPE_GROUP] = true,
	[var18.TYPE_MESSAGE] = true,
	[var18.TYPE_BYTES] = true
}
local var23 = {
	[var18.CPPTYPE_INT32] = var13.Int32ValueChecker(),
	[var18.CPPTYPE_INT64] = var13.TypeChecker({
		string = true,
		number = true
	}),
	[var18.CPPTYPE_UINT32] = var13.Uint32ValueChecker(),
	[var18.CPPTYPE_UINT64] = var13.TypeChecker({
		string = true,
		number = true
	}),
	[var18.CPPTYPE_DOUBLE] = var13.TypeChecker({
		number = true
	}),
	[var18.CPPTYPE_FLOAT] = var13.TypeChecker({
		number = true
	}),
	[var18.CPPTYPE_BOOL] = var13.TypeChecker({
		boolean = true,
		int = true,
		bool = true
	}),
	[var18.CPPTYPE_ENUM] = var13.Int32ValueChecker(),
	[var18.CPPTYPE_STRING] = var13.TypeChecker({
		string = true
	})
}
local var24 = {
	[var18.TYPE_DOUBLE] = var12.DoubleByteSize,
	[var18.TYPE_FLOAT] = var12.FloatByteSize,
	[var18.TYPE_INT64] = var12.Int64ByteSize,
	[var18.TYPE_UINT64] = var12.UInt64ByteSize,
	[var18.TYPE_INT32] = var12.Int32ByteSize,
	[var18.TYPE_FIXED64] = var12.Fixed64ByteSize,
	[var18.TYPE_FIXED32] = var12.Fixed32ByteSize,
	[var18.TYPE_BOOL] = var12.BoolByteSize,
	[var18.TYPE_STRING] = var12.StringByteSize,
	[var18.TYPE_GROUP] = var12.GroupByteSize,
	[var18.TYPE_MESSAGE] = var12.MessageByteSize,
	[var18.TYPE_BYTES] = var12.BytesByteSize,
	[var18.TYPE_UINT32] = var12.UInt32ByteSize,
	[var18.TYPE_ENUM] = var12.EnumByteSize,
	[var18.TYPE_SFIXED32] = var12.SFixed32ByteSize,
	[var18.TYPE_SFIXED64] = var12.SFixed64ByteSize,
	[var18.TYPE_SINT32] = var12.SInt32ByteSize,
	[var18.TYPE_SINT64] = var12.SInt64ByteSize
}
local var25 = {
	[var18.TYPE_DOUBLE] = var14.DoubleEncoder,
	[var18.TYPE_FLOAT] = var14.FloatEncoder,
	[var18.TYPE_INT64] = var14.Int64Encoder,
	[var18.TYPE_UINT64] = var14.UInt64Encoder,
	[var18.TYPE_INT32] = var14.Int32Encoder,
	[var18.TYPE_FIXED64] = var14.Fixed64Encoder,
	[var18.TYPE_FIXED32] = var14.Fixed32Encoder,
	[var18.TYPE_BOOL] = var14.BoolEncoder,
	[var18.TYPE_STRING] = var14.StringEncoder,
	[var18.TYPE_GROUP] = var14.GroupEncoder,
	[var18.TYPE_MESSAGE] = var14.MessageEncoder,
	[var18.TYPE_BYTES] = var14.BytesEncoder,
	[var18.TYPE_UINT32] = var14.UInt32Encoder,
	[var18.TYPE_ENUM] = var14.EnumEncoder,
	[var18.TYPE_SFIXED32] = var14.SFixed32Encoder,
	[var18.TYPE_SFIXED64] = var14.SFixed64Encoder,
	[var18.TYPE_SINT32] = var14.SInt32Encoder,
	[var18.TYPE_SINT64] = var14.SInt64Encoder
}
local var26 = {
	[var18.TYPE_DOUBLE] = var14.DoubleSizer,
	[var18.TYPE_FLOAT] = var14.FloatSizer,
	[var18.TYPE_INT64] = var14.Int64Sizer,
	[var18.TYPE_UINT64] = var14.UInt64Sizer,
	[var18.TYPE_INT32] = var14.Int32Sizer,
	[var18.TYPE_FIXED64] = var14.Fixed64Sizer,
	[var18.TYPE_FIXED32] = var14.Fixed32Sizer,
	[var18.TYPE_BOOL] = var14.BoolSizer,
	[var18.TYPE_STRING] = var14.StringSizer,
	[var18.TYPE_GROUP] = var14.GroupSizer,
	[var18.TYPE_MESSAGE] = var14.MessageSizer,
	[var18.TYPE_BYTES] = var14.BytesSizer,
	[var18.TYPE_UINT32] = var14.UInt32Sizer,
	[var18.TYPE_ENUM] = var14.EnumSizer,
	[var18.TYPE_SFIXED32] = var14.SFixed32Sizer,
	[var18.TYPE_SFIXED64] = var14.SFixed64Sizer,
	[var18.TYPE_SINT32] = var14.SInt32Sizer,
	[var18.TYPE_SINT64] = var14.SInt64Sizer
}
local var27 = {
	[var18.TYPE_DOUBLE] = var15.DoubleDecoder,
	[var18.TYPE_FLOAT] = var15.FloatDecoder,
	[var18.TYPE_INT64] = var15.Int64Decoder,
	[var18.TYPE_UINT64] = var15.UInt64Decoder,
	[var18.TYPE_INT32] = var15.Int32Decoder,
	[var18.TYPE_FIXED64] = var15.Fixed64Decoder,
	[var18.TYPE_FIXED32] = var15.Fixed32Decoder,
	[var18.TYPE_BOOL] = var15.BoolDecoder,
	[var18.TYPE_STRING] = var15.StringDecoder,
	[var18.TYPE_GROUP] = var15.GroupDecoder,
	[var18.TYPE_MESSAGE] = var15.MessageDecoder,
	[var18.TYPE_BYTES] = var15.BytesDecoder,
	[var18.TYPE_UINT32] = var15.UInt32Decoder,
	[var18.TYPE_ENUM] = var15.EnumDecoder,
	[var18.TYPE_SFIXED32] = var15.SFixed32Decoder,
	[var18.TYPE_SFIXED64] = var15.SFixed64Decoder,
	[var18.TYPE_SINT32] = var15.SInt32Decoder,
	[var18.TYPE_SINT64] = var15.SInt64Decoder
}
local var28 = {
	[var18.TYPE_DOUBLE] = var12.WIRETYPE_FIXED64,
	[var18.TYPE_FLOAT] = var12.WIRETYPE_FIXED32,
	[var18.TYPE_INT64] = var12.WIRETYPE_VARINT,
	[var18.TYPE_UINT64] = var12.WIRETYPE_VARINT,
	[var18.TYPE_INT32] = var12.WIRETYPE_VARINT,
	[var18.TYPE_FIXED64] = var12.WIRETYPE_FIXED64,
	[var18.TYPE_FIXED32] = var12.WIRETYPE_FIXED32,
	[var18.TYPE_BOOL] = var12.WIRETYPE_VARINT,
	[var18.TYPE_STRING] = var12.WIRETYPE_LENGTH_DELIMITED,
	[var18.TYPE_GROUP] = var12.WIRETYPE_START_GROUP,
	[var18.TYPE_MESSAGE] = var12.WIRETYPE_LENGTH_DELIMITED,
	[var18.TYPE_BYTES] = var12.WIRETYPE_LENGTH_DELIMITED,
	[var18.TYPE_UINT32] = var12.WIRETYPE_VARINT,
	[var18.TYPE_ENUM] = var12.WIRETYPE_VARINT,
	[var18.TYPE_SFIXED32] = var12.WIRETYPE_FIXED32,
	[var18.TYPE_SFIXED64] = var12.WIRETYPE_FIXED64,
	[var18.TYPE_SINT32] = var12.WIRETYPE_VARINT,
	[var18.TYPE_SINT64] = var12.WIRETYPE_VARINT
}

local function var29(arg0)
	return var22[arg0] == nil
end

local function var30(arg0, arg1)
	if arg0 == var18.CPPTYPE_STRING and arg1 == var18.TYPE_STRING then
		return var13.UnicodeValueChecker()
	end

	return var23[arg0]
end

local function var31(arg0)
	if arg0.label == var18.LABEL_REPEATED then
		if var10(arg0.default_value) ~= "table" or #arg0.default_value ~= 0 then
			var3("Repeated field default value not empty list:" .. var9(arg0.default_value))
		end

		if arg0.cpp_type == var18.CPPTYPE_MESSAGE then
			local var0 = arg0.message_type

			return function(arg0)
				return var17.RepeatedCompositeFieldContainer(arg0._listener_for_children, var0)
			end
		else
			local var1 = var30(arg0.cpp_type, arg0.type)

			return function(arg0)
				return var17.RepeatedScalarFieldContainer(arg0._listener_for_children, var1)
			end
		end
	end

	if arg0.cpp_type == var18.CPPTYPE_MESSAGE then
		local var2 = arg0.message_type

		return function(arg0)
			local var0 = var2._concrete_class()

			var0._SetListener(arg0._listener_for_children)

			return var0
		end
	end

	return function(arg0)
		return arg0.default_value
	end
end

local function var32(arg0, arg1)
	local var0 = arg1.label == var18.LABEL_REPEATED
	local var1 = arg1.has_options and arg1.GetOptions().packed

	var1(arg1, "_encoder", var25[arg1.type](arg1.number, var0, var1))
	var1(arg1, "_sizer", var26[arg1.type](arg1.number, var0, var1))
	var1(arg1, "_default_constructor", var31(arg1))

	local function var2(arg0, arg1)
		local var0 = var14.TagBytes(arg1.number, arg0)

		arg0._decoders_by_tag[var0] = var27[arg1.type](arg1.number, var0, arg1, arg1, arg1._default_constructor)
	end

	var2(var28[arg1.type], False)

	if var0 and var29(arg1.type) then
		var2(var12.WIRETYPE_LENGTH_DELIMITED, True)
	end
end

local function var33(arg0, arg1)
	for iter0, iter1 in var4(arg0.enum_types) do
		for iter2, iter3 in var4(iter1.values) do
			arg1._member[iter3.name] = iter3.number
		end
	end
end

local function var34(arg0)
	return function()
		local var0 = {}

		var0._cached_byte_size = 0
		var0._cached_byte_size_dirty = false
		var0._fields = {}
		var0._is_present_in_parent = false
		var0._listener = var16.NullMessageListener()
		var0._listener_for_children = var16.Listener(var0)

		return var0(var0, arg0)
	end
end

local function var35(arg0, arg1)
	local var0 = arg0.name

	arg1._getter[var0] = function(arg0)
		local var0 = arg0._fields[arg0]

		if var0 == nil then
			var0 = arg0._default_constructor(arg0)
			arg0._fields[arg0] = var0

			if not arg0._cached_byte_size_dirty then
				arg1._member._Modified(arg0)
			end
		end

		return var0
	end
	arg1._setter[var0] = function(arg0)
		var3("Assignment not allowed to repeated field \"" .. var0 .. "\" in protocol message object.")
	end
end

local function var36(arg0, arg1)
	local var0 = arg0.name
	local var1 = arg0.message_type

	arg1._getter[var0] = function(arg0)
		local var0 = arg0._fields[arg0]

		if var0 == nil then
			var0 = var1._concrete_class()

			var0:_SetListener(arg0._listener_for_children)

			arg0._fields[arg0] = var0

			if not arg0._cached_byte_size_dirty then
				arg1._member._Modified(arg0)
			end
		end

		return var0
	end
	arg1._setter[var0] = function(arg0, arg1)
		var3("Assignment not allowed to composite field" .. var0 .. "in protocol message object.")
	end
end

local function var37(arg0, arg1)
	local var0 = arg0.name
	local var1 = var30(arg0.cpp_type, arg0.type)
	local var2 = arg0.default_value

	arg1._getter[var0] = function(arg0)
		if arg0._fields[arg0] ~= nil then
			return arg0._fields[arg0]
		else
			return var2
		end
	end
	arg1._setter[var0] = function(arg0, arg1)
		var1(arg1)

		arg0._fields[arg0] = arg1

		if not arg0._cached_byte_size_dirty then
			arg1._member._Modified(arg0)
		end
	end
end

local function var38(arg0, arg1)
	local var0 = arg0.name:upper() .. "_FIELD_NUMBER"

	arg1._member[var0] = arg0.number

	if arg0.label == var18.LABEL_REPEATED then
		var35(arg0, arg1)
	elseif arg0.cpp_type == var18.CPPTYPE_MESSAGE then
		var36(arg0, arg1)
	else
		var37(arg0, arg1)
	end
end

local var39 = {
	__index = function(arg0, arg1)
		local var0 = var2(arg0, "_extended_message")
		local var1 = var0._fields[arg1]

		if var1 ~= nil then
			return var1
		end

		if arg1.label == var18.LABEL_REPEATED then
			var1 = arg1._default_constructor(arg0._extended_message)
		elseif arg1.cpp_type == var18.CPPTYPE_MESSAGE then
			var1 = arg1.message_type._concrete_class()

			var1:_SetListener(var0._listener_for_children)
		else
			return arg1.default_value
		end

		var0._fields[arg1] = var1

		return var1
	end,
	__newindex = function(arg0, arg1, arg2)
		local var0 = var2(arg0, "_extended_message")

		if arg1.label == var18.LABEL_REPEATED or arg1.cpp_type == var18.CPPTYPE_MESSAGE then
			var3("Cannot assign to extension \"" .. arg1.full_name .. "\" because it is a repeated or composite type.")
		end

		var30(arg1.cpp_type, arg1.type).CheckValue(arg2)

		var0._fields[arg1] = arg2

		var0._Modified()
	end
}

local function var40(arg0)
	local var0 = {
		_extended_message = arg0
	}

	return var0(var0, var39)
end

local function var41(arg0, arg1)
	for iter0, iter1 in var4(arg0.fields) do
		var38(iter1, arg1)
	end

	if arg0.is_extendable then
		function arg1._getter.Extensions(arg0)
			return var40(arg0)
		end
	end
end

local function var42(arg0, arg1)
	local var0 = arg0._extensions_by_name

	for iter0, iter1 in var5(var0) do
		local var1 = var8.upper(iter0) .. "_FIELD_NUMBER"

		arg1._member[var1] = iter1.number
	end
end

local function var43(arg0)
	function arg0._member.RegisterExtension(arg0)
		arg0.containing_type = arg0._descriptor

		var32(arg0, arg0)

		if arg0._extensions_by_number[arg0.number] == nil then
			arg0._extensions_by_number[arg0.number] = arg0
		else
			var3(var8.format("Extensions \"%s\" and \"%s\" both try to extend message type \"%s\" with field number %d.", arg0.full_name, actual_handle.full_name, arg0._descriptor.full_name, arg0.number))
		end

		arg0._extensions_by_name[arg0.full_name] = arg0
	end

	function arg0._member.FromString(arg0)
		local var0 = arg0._member.__call()

		var0.MergeFromString(arg0)

		return var0
	end
end

local function var44(arg0, arg1)
	if arg0.label == var18.LABEL_REPEATED then
		return arg1
	elseif arg0.cpp_type == var18.CPPTYPE_MESSAGE then
		return arg1._is_present_in_parent
	else
		return true
	end
end

function sortFunc(arg0, arg1)
	return arg0.index < arg1.index
end

function pairsByKeys(arg0, arg1)
	local var0 = {}

	for iter0 in var5(arg0) do
		var7.insert(var0, iter0)
	end

	var7.sort(var0, arg1)

	local var1 = 0

	return function()
		var1 = var1 + 1

		if var0[var1] == nil then
			return nil
		else
			return var0[var1], arg0[var0[var1]]
		end
	end
end

local function var45(arg0, arg1)
	function arg1._member.ListFields(arg0)
		return (function(arg0)
			local var0, var1, var2 = pairsByKeys(arg0._fields, sortFunc)

			return function(arg0, arg1)
				while true do
					local var0, var1 = var0(arg0, arg1)

					if var0 == nil then
						return
					elseif var44(var0, var1) then
						return var0, var1
					end
				end
			end, var1, var2
		end)(arg0._fields)
	end
end

local function var46(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in var4(arg0.fields) do
		if iter1.label ~= var18.LABEL_REPEATED then
			var0[iter1.name] = iter1
		end
	end

	function arg1._member.HasField(arg0, arg1)
		local var0 = var0[arg1]

		if var0 == nil then
			var3("Protocol message has no singular \"" .. arg1 .. "\" field.")
		end

		if var0.cpp_type == var18.CPPTYPE_MESSAGE then
			local var1 = arg0._fields[var0]

			return var1 ~= nil and var1._is_present_in_parent
		else
			return arg0._fields[var0] ~= nil
		end
	end
end

local function var47(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in var4(arg0.fields) do
		if iter1.label ~= var18.LABEL_REPEATED then
			var0[iter1.name] = iter1
		end
	end

	function arg1._member.ClearField(arg0, arg1)
		field = var0[arg1]

		if field == nil then
			var3("Protocol message has no singular \"" .. arg1 .. "\" field.")
		end

		if arg0._fields[field] then
			arg0._fields[field] = nil
		end

		arg1._member._Modified(arg0)
	end
end

local function var48(arg0)
	function arg0._member.ClearExtension(arg0, arg1)
		if arg0._fields[arg1] == nil then
			arg0._fields[arg1] = nil
		end

		arg0._member._Modified(arg0)
	end
end

local function var49(arg0, arg1)
	function arg1._member.Clear(arg0)
		arg0._fields = {}

		arg1._member._Modified(arg0)
	end
end

local function var50(arg0)
	local var0 = var19.msg_format

	function arg0.__tostring(arg0)
		return var0(arg0)
	end
end

local function var51(arg0)
	function arg0._member.HasExtension(arg0, arg1)
		if arg1.label == var18.LABEL_REPEATED then
			var3(arg1.full_name .. " is repeated.")
		end

		if arg1.cpp_type == var18.CPPTYPE_MESSAGE then
			local var0 = arg0._fields[arg1]

			return var0 ~= nil and var0._is_present_in_parent
		else
			return arg0._fields[arg1]
		end
	end
end

local function var52(arg0)
	function arg0._member._SetListener(arg0, arg1)
		if arg1 ~= nil then
			arg0._listener = var16.NullMessageListener()
		else
			arg0._listener = arg1
		end
	end
end

local function var53(arg0, arg1)
	function arg1._member.ByteSize(arg0)
		if not arg0._cached_byte_size_dirty and arg0._cached_byte_size > 0 then
			return arg0._cached_byte_size
		end

		local var0 = 0

		for iter0, iter1 in arg1._member.ListFields(arg0) do
			var0 = iter0._sizer(iter1) + var0
		end

		arg0._cached_byte_size = var0
		arg0._cached_byte_size_dirty = false
		arg0._listener_for_children.dirty = false

		return var0
	end
end

local function var54(arg0, arg1)
	function arg1._member.SerializeToString(arg0)
		if not arg1._member.IsInitialized(arg0) then
			var3("Message is missing required fields: " .. var7.concat(arg1._member.FindInitializationErrors(arg0), ","))
		end

		return arg1._member.SerializePartialToString(arg0)
	end

	function arg1._member.SerializeToIOString(arg0, arg1)
		if not arg1._member.IsInitialized(arg0) then
			var3("Message is missing required fields: " .. var7.concat(arg1._member.FindInitializationErrors(arg0), ","))
		end

		return arg1._member.SerializePartialToIOString(arg0, arg1)
	end
end

local function var55(arg0, arg1)
	local var0 = var7.concat

	local function var1(arg0, arg1)
		for iter0, iter1 in arg1._member.ListFields(arg0) do
			iter0._encoder(arg1, iter1)
		end
	end

	local function var2(arg0, arg1)
		local var0 = arg1.write

		local function var1(arg0)
			var0(arg1, arg0)
		end

		var1(arg0, var1)
	end

	local function var3(arg0)
		local var0 = {}

		local function var1(arg0)
			var0[#var0 + 1] = arg0
		end

		var1(arg0, var1)

		return var0(var0)
	end

	arg1._member._InternalSerialize = var1
	arg1._member.SerializePartialToIOString = var2
	arg1._member.SerializePartialToString = var3
end

local function var56(arg0, arg1)
	local var0 = var15.ReadTag
	local var1 = var15.SkipField
	local var2 = arg1._decoders_by_tag

	local function var3(arg0, arg1, arg2, arg3)
		arg1._member._Modified(arg0)

		local var0 = arg0._fields
		local var1
		local var2
		local var3

		while arg2 ~= arg3 do
			local var4, var5 = var0(arg1, arg2)
			local var6 = var2[var4]

			if var6 == nil then
				var5 = var1(arg1, var5, arg3, var4)

				if var5 == -1 then
					return arg2
				end

				arg2 = var5
			else
				arg2 = var6(arg1, var5, arg3, arg0, var0)
			end
		end

		return arg2
	end

	arg1._member._InternalParse = var3

	local function var4(arg0, arg1)
		local var0 = #arg1

		if var3(arg0, arg1, 0, var0) ~= var0 then
			var3("Unexpected end-group tag.")
		end

		return var0
	end

	arg1._member.MergeFromString = var4

	function arg1._member.ParseFromString(arg0, arg1)
		arg1._member.Clear(arg0)
		var4(arg0, arg1)
	end
end

local function var57(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in var4(arg0.fields) do
		if iter1.label == var18.LABEL_REQUIRED then
			var0[#var0 + 1] = iter1
		end
	end

	function arg1._member.IsInitialized(arg0, arg1)
		for iter0, iter1 in var4(var0) do
			if arg0._fields[iter1] == nil or iter1.cpp_type == var18.CPPTYPE_MESSAGE and not arg0._fields[iter1]._is_present_in_parent then
				if arg1 ~= nil then
					arg1[#arg1 + 1] = arg1._member.FindInitializationErrors(arg0)
				end

				return false
			end
		end

		for iter2, iter3 in var5(arg0._fields) do
			if iter2.cpp_type == var18.CPPTYPE_MESSAGE then
				if iter2.label == var18.LABEL_REPEATED then
					for iter4, iter5 in var4(iter3) do
						if not iter5:IsInitialized() then
							if arg1 ~= nil then
								arg1[#arg1 + 1] = arg1._member.FindInitializationErrors(arg0)
							end

							return false
						end
					end
				elseif iter3._is_present_in_parent and not iter3:IsInitialized() then
					if arg1 ~= nil then
						arg1[#arg1 + 1] = arg1._member.FindInitializationErrors(arg0)
					end

					return false
				end
			end
		end

		return true
	end

	function arg1._member.FindInitializationErrors(arg0)
		local var0 = {}

		for iter0, iter1 in var4(var0) do
			if not arg1._member.HasField(arg0, iter1.name) then
				var0[#var0 + 1] = iter1.name
			end
		end

		local var1
		local var2
		local var3

		for iter2, iter3 in arg1._member.ListFields(arg0) do
			if iter2.cpp_type == var18.CPPTYPE_MESSAGE then
				if iter2.is_extension then
					var1 = io:format("(%s)", iter2.full_name)
				else
					var1 = iter2.name
				end

				if iter2.label == var18.LABEL_REPEATED then
					for iter4, iter5 in var4(iter3) do
						local var4 = io:format("%s[%d].", var1, iter4)
						local var5 = iter5:FindInitializationErrors()

						for iter6, iter7 in var4(var5) do
							var0[#var0 + 1] = var4 .. iter7
						end
					end
				else
					local var6 = var1 .. "."
					local var7 = iter3:FindInitializationErrors()

					for iter8, iter9 in var4(var7) do
						var0[#var0 + 1] = var6 .. iter9
					end
				end
			end
		end

		return var0
	end
end

local function var58(arg0)
	local var0 = var18.LABEL_REPEATED
	local var1 = var18.CPPTYPE_MESSAGE

	function arg0._member.MergeFrom(arg0, arg1)
		assert(arg1 ~= arg0)
		arg0._member._Modified(arg0)

		local var0 = arg0._fields

		for iter0, iter1 in var5(arg1._fields) do
			if iter0.label == var0 or iter0.cpp_type == var1 then
				local var1 = var0[iter0]

				if var1 == nil then
					var1 = iter0._default_constructor(arg0)
					var0[iter0] = var1
				end

				var1:MergeFrom(iter1)
			else
				arg0._fields[iter0] = iter1
			end
		end
	end
end

local function var59(arg0, arg1)
	var45(arg0, arg1)
	var46(arg0, arg1)
	var47(arg0, arg1)

	if arg0.is_extendable then
		var48(arg1)
		var51(arg1)
	end

	var49(arg0, arg1)
	var50(arg1)
	var52(arg1)
	var53(arg0, arg1)
	var54(arg0, arg1)
	var55(arg0, arg1)
	var56(arg0, arg1)
	var57(arg0, arg1)
	var58(arg1)
end

local function var60(arg0)
	local function var0(arg0)
		if not arg0._cached_byte_size_dirty then
			arg0._cached_byte_size_dirty = true
			arg0._listener_for_children.dirty = true
			arg0._is_present_in_parent = true

			arg0._listener:Modified()
		end
	end

	arg0._member._Modified = var0
	arg0._member.SetInParent = var0
end

local function var61(arg0)
	local var0 = arg0._getter
	local var1 = arg0._member

	return function(arg0, arg1)
		local var0 = var0[arg1]

		if var0 then
			return var0(arg0)
		else
			return var1[arg1]
		end
	end
end

local function var62(arg0)
	local var0 = arg0._setter

	return function(arg0, arg1, arg2)
		local var0 = var0[arg1]

		if var0 then
			var0(arg0, arg2)
		else
			var3(arg1 .. " not found")
		end
	end
end

function _AddClassAttributesForNestedExtensions(arg0, arg1)
	local var0 = arg0._extensions_by_name

	for iter0, iter1 in var5(var0) do
		arg1._member[iter0] = iter1
	end
end

local function var63(arg0)
	local var0 = {
		_decoders_by_tag = {}
	}

	var1(arg0, "_extensions_by_name", {})

	for iter0, iter1 in var4(arg0.extensions) do
		arg0._extensions_by_name[iter1.name] = iter1
	end

	var1(arg0, "_extensions_by_number", {})

	for iter2, iter3 in var4(arg0.extensions) do
		arg0._extensions_by_number[iter3.number] = iter3
	end

	var0._descriptor = arg0
	var0._extensions_by_name = {}
	var0._extensions_by_number = {}
	var0._getter = {}
	var0._setter = {}
	var0._member = {}

	local var1 = var0({}, var0._member)

	var0._member.__call = var34(var0)
	var0._member.__index = var0._member
	var0._member.type = var1

	if var2(arg0, "_concrete_class") == nil then
		var1(arg0, "_concrete_class", var1)

		for iter4, iter5 in var4(arg0.fields) do
			var32(var0, iter5)
		end
	end

	var33(arg0, var0)
	_AddClassAttributesForNestedExtensions(arg0, var0)
	var41(arg0, var0)
	var42(arg0, var0)
	var43(var0)
	var59(arg0, var0)
	var60(var0)

	var0.__index = var61(var0)
	var0.__newindex = var62(var0)

	return var1
end

_M.Message = var63
