pg = pg or {}

local var0_0 = pg

var0_0.Protocol = class("Protocol")

function var0_0.Protocol.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	assert(arg1_1 ~= nil and arg2_1 ~= nil and arg3_1 ~= nil, "pg.Protocol:Ctor invalid argument")

	arg0_1._id = arg1_1
	arg0_1._name = arg2_1
	arg0_1._object = arg3_1
end

function var0_0.Protocol.GetMessage(arg0_2)
	assert(arg0_2._name ~= nil and arg0_2._object ~= nil, "pg.Protocol:GetMessage object and name must not be nil")

	return arg0_2._object[arg0_2._name]()
end

function var0_0.Protocol.GetId(arg0_3)
	return arg0_3._id
end

function var0_0.Protocol.GetName(arg0_4)
	return arg0_4._name
end
