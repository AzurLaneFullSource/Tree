local var0_0 = class("DailiyQuickBattleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.dailyLevelId
	local var2_1 = var0_1.stageId
	local var3_1 = var0_1.cnt
	local var4_1 = getProxy(DailyLevelProxy)
	local var5_1 = var4_1.data[var1_1] or 0
	local var6_1 = pg.expedition_daily_template[var1_1]

	if var5_1 + var3_1 > var6_1.limit_time then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(40007, {
		system = SYSTEM_ROUTINE,
		id = var2_1,
		cnt = var3_1
	}, 40008, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.reward_list) do
				var0_2[iter0_2] = PlayerConst.addTranDrop(iter1_2.drop_list)
			end

			var4_1.data[var1_1] = (var4_1.data[var1_1] or 0) + var3_1

			arg0_1:sendNotification(GAME.DAILY_LEVEL_QUICK_BATTLE_DONE, {
				awards = var0_2,
				stageId = var2_1,
				dailyLevelId = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
