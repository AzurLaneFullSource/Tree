local var0 = class("ReplaceRivalsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = getProxy(MilitaryExerciseProxy)
	local var1 = var0:getSeasonInfo()
	local var2 = var1:getconsumeGem()

	if var1:getFlashCount() > MAX_REPLACE_RIVAL_COUNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_refresh_count_insufficient"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(18003, {
		type = 0
	}, 18004, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.target_list) do
				local var1 = Rival.New(iter1)

				table.insert(var0, var1)
			end

			var0:updateRivals(var0)

			var1 = var0:getSeasonInfo()

			var1:increaseFlashCount()
			var0:updateSeasonInfo(var1)
			arg0:sendNotification(GAME.REPLACE_RIVALS_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
