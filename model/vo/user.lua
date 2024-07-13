local var0_0 = class("User", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.type = arg1_1.type
	arg0_1.arg1 = arg1_1.arg1
	arg0_1.arg2 = arg1_1.arg2
	arg0_1.arg3 = arg1_1.arg3
	arg0_1.arg4 = arg1_1.arg4
	arg0_1.id = arg1_1.uid
	arg0_1.uid = arg1_1.uid
	arg0_1.token = arg1_1.token
	arg0_1.server = arg1_1.server
end

function var0_0.isLogin(arg0_2)
	return tobool(arg0_2.uid and arg0_2.server and arg0_2.token)
end

function var0_0.clear(arg0_3)
	arg0_3.id = nil
	arg0_3.uid = nil
	arg0_3.token = nil
	arg0_3.server = nil
end

return var0_0
