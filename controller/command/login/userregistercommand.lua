local var0_0 = class("UserRegisterCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	assert(isa(var0_1, User), "should be an instance of User")

	if var0_1.type ~= 2 then
		originalPrint("用户类型错误")

		return
	end

	originalPrint("connect to gateway - " .. NetConst.GATEWAY_HOST .. ":" .. NetConst.GATEWAY_PORT)
	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function()
		pg.ConnectionMgr.GetInstance():Send(10001, {
			account = var0_1.arg1,
			password = var0_1.arg2,
			mail_box = var0_1.arg3
		}, 10002, function(arg0_3)
			originalPrint("disconnect from gateway...")
			pg.ConnectionMgr.GetInstance():Disconnect()

			if arg0_3.result == 0 then
				arg0_1.facade:sendNotification(GAME.USER_REGISTER_SUCCESS, var0_1)
			else
				arg0_1.facade:sendNotification(GAME.USER_REGISTER_FAILED, arg0_3.result)
			end
		end, false)
	end)
end

return var0_0
