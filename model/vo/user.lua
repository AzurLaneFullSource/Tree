local var0 = class("User", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.type = arg1.type
	arg0.arg1 = arg1.arg1
	arg0.arg2 = arg1.arg2
	arg0.arg3 = arg1.arg3
	arg0.arg4 = arg1.arg4
	arg0.id = arg1.uid
	arg0.uid = arg1.uid
	arg0.token = arg1.token
	arg0.server = arg1.server
end

function var0.isLogin(arg0)
	return tobool(arg0.uid and arg0.server and arg0.token)
end

function var0.clear(arg0)
	arg0.id = nil
	arg0.uid = nil
	arg0.token = nil
	arg0.server = nil
end

return var0
