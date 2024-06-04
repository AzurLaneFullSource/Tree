local var0 = class("Notification")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.name = arg1
	arg0.body = arg2
	arg0.type = arg3
end

function var0.getName(arg0)
	return arg0.name
end

function var0.setBody(arg0, arg1)
	arg0.body = arg1
end

function var0.getBody(arg0)
	return arg0.body
end

function var0.setType(arg0, arg1)
	arg0.type = arg1
end

function var0.getType(arg0)
	return arg0.type
end

function var0.toString(arg0)
	return (("Notification Name: " .. arg0:getName()) .. "\nBody: " .. tostring(arg0:getBody())) .. "\nType: " .. arg0:getType()
end

return var0
