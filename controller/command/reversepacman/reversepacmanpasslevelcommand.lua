local var0_0 = class("ReversePacmanPassLevelCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.actId
	local var2_1 = var0_1.levelId
	local var3_1 = var0_1.time

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 3,
		activity_id = var0_1.actId,
		arg1 = var2_1,
		arg2 = var3_1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			ReversePacmanTools.GetActivity():UpdatePassStage(var2_1, var3_1)

			local var0_2 = {}
			local var1_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			arg0_1:sendNotification(GAME.REVERSE_PACMAN_PASS_LEVEL_DONE, {
				awards = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
