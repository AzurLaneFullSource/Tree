local var0_0 = class("ChangeRandomFlagShipModeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().mode

	pg.ConnectionMgr.GetInstance():Send(12206, {
		flag = var0_1
	}, 12207, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(PlayerProxy):getRawData():UpdateRandomFlagShipMode(var0_1)
			arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIP_MODE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
