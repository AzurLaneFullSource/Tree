local var0_0 = class("SendCmdCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	assert(var0_1.cmd, "cmd should exist")

	local var1_1 = var0_1.cmd
	local var2_1 = var0_1.arg1

	pg.ConnectionMgr.GetInstance():Send(11100, {
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg3 = var0_1.arg3,
		arg4 = var0_1.arg4
	}, 11101, function(arg0_2)
		print("response: " .. arg0_2.msg)
		arg0_1:sendNotification(GAME.SEND_CMD_DONE, arg0_2.msg)
	end)
end

return var0_0
