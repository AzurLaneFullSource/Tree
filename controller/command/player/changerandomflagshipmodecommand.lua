local var0 = class("ChangeRandomFlagShipModeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().mode

	pg.ConnectionMgr.GetInstance():Send(12206, {
		flag = var0
	}, 12207, function(arg0)
		if arg0.result == 0 then
			getProxy(PlayerProxy):getRawData():UpdateRandomFlagShipMode(var0)
			arg0:sendNotification(GAME.CHANGE_RANDOM_SHIP_MODE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
