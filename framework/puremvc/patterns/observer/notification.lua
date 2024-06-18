local var0_0 = class("Notification")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.name = arg1_1
	arg0_1.body = arg2_1
	arg0_1.type = arg3_1
end

function var0_0.getName(arg0_2)
	return arg0_2.name
end

function var0_0.setBody(arg0_3, arg1_3)
	arg0_3.body = arg1_3
end

function var0_0.getBody(arg0_4)
	return arg0_4.body
end

function var0_0.setType(arg0_5, arg1_5)
	arg0_5.type = arg1_5
end

function var0_0.getType(arg0_6)
	return arg0_6.type
end

function var0_0.toString(arg0_7)
	return (("Notification Name: " .. arg0_7:getName()) .. "\nBody: " .. tostring(arg0_7:getBody())) .. "\nType: " .. arg0_7:getType()
end

return var0_0
