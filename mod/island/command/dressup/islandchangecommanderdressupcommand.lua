local var0_0 = class("IslandChangeCommanderDressupCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.island_id
	local var2_1 = var0_1.dress_List
	local var3_1 = var0_1.color_list
	local var4_1 = var0_1.callback
	local var5_1 = var0_1.hideTip
	local var6_1 = getProxy(IslandProxy):GetIsland()

	pg.ConnectionMgr.GetInstance():Send(21626, {
		island_id = var1_1,
		dress_list = var2_1,
		color_list = var3_1
	}, 21627, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var6_1:GetDressUpAgency()

			var0_2:ChangeCapState(arg0_2.cap_list)

			for iter0_2, iter1_2 in ipairs(var3_1) do
				var0_2:ChangeDressColor(iter1_2)
			end

			var0_2:ChangeDress(var2_1)
			var6_1:DispatchEvent(IslandDressUpAgency.CHANGE_PLAYER_DRESS, var2_1, var3_1)
			arg0_1:sendNotification(GAME.ISLAND_CHANGE_COMMANDER_DRESS_DONE)

			if not var5_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save1"))
			end

			existCall(var4_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
			existCall(var4_1)
		end
	end)
end

return var0_0
