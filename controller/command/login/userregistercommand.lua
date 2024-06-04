local var0 = class("UserRegisterCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	assert(isa(var0, User), "should be an instance of User")

	if var0.type ~= 2 then
		originalPrint("用户类型错误")

		return
	end

	originalPrint("connect to gateway - " .. NetConst.GATEWAY_HOST .. ":" .. NetConst.GATEWAY_PORT)
	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function()
		pg.ConnectionMgr.GetInstance():Send(10001, {
			account = var0.arg1,
			password = var0.arg2,
			mail_box = var0.arg3
		}, 10002, function(arg0)
			originalPrint("disconnect from gateway...")
			pg.ConnectionMgr.GetInstance():Disconnect()

			if arg0.result == 0 then
				arg0.facade:sendNotification(GAME.USER_REGISTER_SUCCESS, var0)
			else
				arg0.facade:sendNotification(GAME.USER_REGISTER_FAILED, arg0.result)
			end
		end, false)
	end)
end

return var0
