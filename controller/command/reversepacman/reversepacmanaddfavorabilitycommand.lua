local var0_0 = class("ReversePacmanAddFavorabilityCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.roleID

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 4,
		activity_id = var0_1.activityID,
		arg1 = var1_1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			ReversePacmanTools.GetActivity():AddFavorability(var1_1, 1)
			arg0_1:sendNotification(GAME.REVERSE_PACMAN_ADD_FAVORABILITY_DONE, var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
