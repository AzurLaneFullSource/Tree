pg = pg or {}

local var0 = pg

var0.Protocol = class("Protocol")

function var0.Protocol.Ctor(arg0, arg1, arg2, arg3)
	assert(arg1 ~= nil and arg2 ~= nil and arg3 ~= nil, "pg.Protocol:Ctor invalid argument")

	arg0._id = arg1
	arg0._name = arg2
	arg0._object = arg3
end

function var0.Protocol.GetMessage(arg0)
	assert(arg0._name ~= nil and arg0._object ~= nil, "pg.Protocol:GetMessage object and name must not be nil")

	return arg0._object[arg0._name]()
end

function var0.Protocol.GetId(arg0)
	return arg0._id
end

function var0.Protocol.GetName(arg0)
	return arg0._name
end
