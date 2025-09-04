local var0_0 = class("IslandChangeDressupCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ship_id
	local var2_1 = var0_1.dress_List
	local var3_1 = var0_1.skin_id
	local var4_1 = var0_1.color_id
	local var5_1 = var0_1.color_list

	pg.ConnectionMgr.GetInstance():Send(21617, {
		ship_id = var1_1,
		dress_List = var2_1,
		color_list = var5_1,
		skin_id = var3_1,
		color_id = var4_1
	}, 21618, function(arg0_2)
		if arg0_2.result == 0 then
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandWearDress(var1_1, var2_1))

			local var0_2 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
			local var1_2 = var0_2:GetShipById(var1_1)

			var1_2:ChangeSkinId(var3_1)
			var0_2:SetSkinCurrentColor(var3_1, var4_1)

			for iter0_2, iter1_2 in ipairs(var5_1) do
				var1_2:ChangeDressColor(iter1_2)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save1"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
