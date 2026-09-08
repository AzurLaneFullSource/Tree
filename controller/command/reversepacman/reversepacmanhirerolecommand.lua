local var0_0 = class("ReversePacmanHireRoleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.roleID

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0_1.activityID,
		arg1 = var1_1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = ReversePacmanTools.GetActivity()
			local var1_2 = pg.activity_chasing_character[var1_1]

			var0_2:AddFavorability(var1_1, var1_2.love_point)
			var0_2:AddVitemNumber(var1_2.need[1], var1_2.need[2] * -1)
			getProxy(ReversePacmanDormProxy):AddShip(var1_1)
			arg0_1:sendNotification(GAME.REVERSE_PACMAN_HIRE_ROLE_DONE, var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
