local var0 = class("ChangeMedalDisplayCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().medalList
	local var1 = getProxy(PlayerProxy)
	local var2 = var1:getData().displayTrophyList
	local var3 = 0

	while var3 < 5 do
		if var0[var3] ~= var2[var3] then
			break
		end

		if var3 == 5 then
			return
		end

		var3 = var3 + 1
	end

	local var4 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var4, iter1)
	end

	pg.ConnectionMgr.GetInstance():Send(17401, {
		fixed_const = 1,
		medal_id = var4
	}, 17402, function(arg0)
		if arg0.result == 0 then
			var1:updatePlayerMedalDisplay(var0)
			pg.TipsMgr.GetInstance():ShowTips(i18n("change_display_medal_success"))
			arg0:sendNotification(GAME.CHANGE_PLAYER_MEDAL_DISPLAY_DONE)
		end
	end)
end

return var0
