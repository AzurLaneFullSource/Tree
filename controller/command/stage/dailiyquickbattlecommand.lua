local var0 = class("DailiyQuickBattleCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.dailyLevelId
	local var2 = var0.stageId
	local var3 = var0.cnt
	local var4 = getProxy(DailyLevelProxy)
	local var5 = var4.data[var1] or 0
	local var6 = pg.expedition_daily_template[var1]

	if var5 + var3 > var6.limit_time then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(40007, {
		system = SYSTEM_ROUTINE,
		id = var2,
		cnt = var3
	}, 40008, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.reward_list) do
				var0[iter0] = PlayerConst.addTranDrop(iter1.drop_list)
			end

			var4.data[var1] = (var4.data[var1] or 0) + var3

			arg0:sendNotification(GAME.DAILY_LEVEL_QUICK_BATTLE_DONE, {
				awards = var0,
				stageId = var2,
				dailyLevelId = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
