local var0_0 = class("ChangeMedalDisplayCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().medalList
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = var1_1:getData().displayTrophyList
	local var3_1 = 0

	while var3_1 < 5 do
		if var0_1[var3_1] ~= var2_1[var3_1] then
			break
		end

		if var3_1 == 5 then
			return
		end

		var3_1 = var3_1 + 1
	end

	local var4_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		table.insert(var4_1, iter1_1)
	end

	pg.ConnectionMgr.GetInstance():Send(17401, {
		fixed_const = 1,
		medal_id = var4_1
	}, 17402, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:updatePlayerMedalDisplay(var0_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("change_display_medal_success"))
			arg0_1:sendNotification(GAME.CHANGE_PLAYER_MEDAL_DISPLAY_DONE)
		end
	end)
end

return var0_0
