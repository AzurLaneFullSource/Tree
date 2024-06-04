local var0 = class("SendCmdCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	assert(var0.cmd, "cmd should exist")

	local var1 = var0.cmd
	local var2 = var0.arg1

	pg.ConnectionMgr.GetInstance():Send(11100, {
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg3 = var0.arg3,
		arg4 = var0.arg4
	}, 11101, function(arg0)
		print("response: " .. arg0.msg)
		arg0:sendNotification(GAME.SEND_CMD_DONE, arg0.msg)
	end)
end

return var0
