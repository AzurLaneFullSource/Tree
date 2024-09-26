local var0_0 = class("SelectDorm3dEnterCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(28017, {
		type = 0
	}, 28018, function(arg0_2)
		if arg0_2.result == 0 then
			pg.m02:sendNotification(GAME.SELECT_DORM_ENTER_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
