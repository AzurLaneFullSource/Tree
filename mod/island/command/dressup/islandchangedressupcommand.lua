local var0_0 = class("IslandChangeDressupCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ship_id
	local var2_1 = var0_1.unload_dress
	local var3_1 = var0_1.dress_List
	local var4_1 = var0_1.skin_id
	local var5_1 = var0_1.color_id

	pg.ConnectionMgr.GetInstance():Send(21617, {
		ship_id = var1_1,
		dress_List = var3_1,
		unload_dress = var2_1,
		skin_id = var4_1,
		color_id = var5_1
	}, 21618, function(arg0_2)
		if arg0_2.result == 0 then
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandWearDress(var1_1, var3_1))

			local var0_2 = getProxy(IslandProxy):GetIsland()
			local var1_2 = var0_2:GetCharacterAgency()
			local var2_2 = var1_2:GetShipById(var1_1)
			local var3_2

			if var4_1 ~= var2_2:GetCurSkinId() then
				var3_2 = var4_1
			end

			var2_2:ChangeSkinId(var4_1)

			local var4_2

			if var5_1 ~= var1_2:GetSkinCurrentColor(var2_2:GetCurSkinId()) then
				var4_2 = var5_1
			end

			var1_2:SetSkinCurrentColor(var4_1, var5_1)

			local var5_2 = {}

			for iter0_2, iter1_2 in ipairs(var2_1) do
				var1_2:AddDressItem(iter1_2, 1)
				var1_2:DischargeDressOnShip(var1_1, iter1_2)
				table.insert(var5_2, iter1_2)
			end

			local var6_2 = {}
			local var7_2 = {}

			for iter2_2, iter3_2 in ipairs(var3_1) do
				local var8_2 = iter3_2.ship_id
				local var9_2 = iter3_2.dress_id

				if var8_2 == 0 then
					var1_2:ReduceDressItem(var9_2, 1)
				else
					var1_2:DischargeDressOnShip(var8_2, var9_2)

					if not var7_2[var8_2] then
						var7_2[var8_2] = {}
					end

					table.insert(var7_2[var8_2], var9_2)
				end

				var1_2:ChargeDressOnShip(var1_1, var9_2)
				table.insert(var6_2, var9_2)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_save1"))

			local var10_2

			if var4_2 then
				if var4_2 ~= 0 then
					var10_2 = pg.island_skin_colordiff_template[var4_2].model
				elseif var3_2 then
					if var3_2 ~= 0 then
						var10_2 = pg.island_skin_template[var3_2].model
					else
						var10_2 = var2_2:GetModelBySkinAndColorId(0, 0)
					end
				end
			elseif var3_2 then
				if var3_2 ~= 0 then
					var10_2 = pg.island_skin_template[var3_2].model
				else
					var10_2 = var2_2:GetModelBySkinAndColorId(0, 0)
				end
			end

			var0_2:DispatchEvent(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, var1_1, var10_2, var5_2, var6_2)

			for iter4_2, iter5_2 in pairs(var7_2) do
				var0_2:DispatchEvent(IslandCharacterAgency.CHANGE_CHARACTER_DRESS, iter4_2, nil, iter5_2, {})
			end

			arg0_1:sendNotification(GAME.ISLAND_CHANGE_ROLE_DRESS_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
