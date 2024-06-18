local var0_0 = class("ReplaceRivalsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(MilitaryExerciseProxy)
	local var1_1 = var0_1:getSeasonInfo()
	local var2_1 = var1_1:getconsumeGem()

	if var1_1:getFlashCount() > MAX_REPLACE_RIVAL_COUNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_refresh_count_insufficient"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(18003, {
		type = 0
	}, 18004, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.target_list) do
				local var1_2 = Rival.New(iter1_2)

				table.insert(var0_2, var1_2)
			end

			var0_1:updateRivals(var0_2)

			var1_1 = var0_1:getSeasonInfo()

			var1_1:increaseFlashCount()
			var0_1:updateSeasonInfo(var1_1)
			arg0_1:sendNotification(GAME.REPLACE_RIVALS_DONE, var0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
