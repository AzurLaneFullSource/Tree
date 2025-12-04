local var0_0 = class("IslandDropHelper")

function var0_0.AddItems(arg0_1, arg1_1)
	local var0_1 = arg0_1.drop_list or {}
	local var1_1 = {}
	local var2_1 = {}
	local var3_1 = {}
	local var4_1 = {}
	local var5_1 = {}
	local var6_1 = {}
	local var7_1 = {}
	local var8_1 = {}
	local var9_1 = {}
	local var10_1 = {}
	local var11_1 = {}
	local var12_1 = {}
	local var13_1 = {}
	local var14_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		if iter1_1.type == DROP_TYPE_ISLAND_ITEM then
			table.insert(var1_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_OVERFLOWITEM then
			table.insert(var2_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_ABILITY then
			table.insert(var3_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_INVITATION then
			table.insert(var5_1, iter1_1)
		elseif iter1_1.type == VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT then
			if iter1_1.count > 0 then
				table.insert(var14_1, iter1_1)
			end
		elseif iter1_1.type == DROP_TYPE_ISLAND_FURNITURE then
			table.insert(var6_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_DRESS then
			table.insert(var7_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_SKIN then
			table.insert(var8_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_ACTION then
			table.insert(var9_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_CARD_DIY then
			table.insert(var10_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_SPEEDUP_TICKET then
			table.insert(var11_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_TIMESTAMP then
			table.insert(var12_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_COLLECTION then
			table.insert(var13_1, iter1_1)
		else
			table.insert(var4_1, iter1_1)
		end
	end

	local var15_1 = var0_0.GetIslandTimestamps(var12_1)
	local var16_1 = var0_0.AddIslandItems(var1_1)
	local var17_1 = var0_0.AddIslandOverFlowItems(var2_1)
	local var18_1 = var0_0.AddIslandAbility(var3_1)
	local var19_1 = var0_0.AddPlayerItems(var4_1)
	local var20_1 = var0_0.AddShipInvitations(var5_1)
	local var21_1 = var0_0.AddVirtualDrops(var14_1)
	local var22_1 = var0_0.AddIslandFurnitureDrops(var6_1)
	local var23_1 = var0_0.AddIslandDressDrops(var7_1)
	local var24_1 = var0_0.AddIslandSkinDrops(var8_1)
	local var25_1 = var0_0.AddIslandActionDrops(var9_1)
	local var26_1 = var0_0.AddIslandCardDiyDrops(var10_1)
	local var27_1 = var0_0.AddIslandTicketDrops(var11_1, var15_1)
	local var28_1 = var0_0.AddIslandCollectDrops(var13_1)

	if #var20_1 > 0 then
		for iter2_1, iter3_1 in ipairs(var20_1) do
			table.insert(var16_1, iter3_1)
		end
	end

	if #var21_1 > 0 then
		for iter4_1, iter5_1 in ipairs(var21_1) do
			table.insert(var16_1, iter5_1)
		end
	end

	if #var22_1 > 0 then
		for iter6_1, iter7_1 in ipairs(var22_1) do
			table.insert(var16_1, iter7_1)
		end
	end

	if #var23_1 > 0 then
		for iter8_1, iter9_1 in ipairs(var23_1) do
			table.insert(var16_1, iter9_1)
		end
	end

	if #var24_1 > 0 then
		for iter10_1, iter11_1 in ipairs(var24_1) do
			table.insert(var16_1, iter11_1)
		end
	end

	if #var25_1 > 0 then
		for iter12_1, iter13_1 in ipairs(var25_1) do
			table.insert(var16_1, iter13_1)
		end
	end

	if #var26_1 > 0 then
		for iter14_1, iter15_1 in ipairs(var26_1) do
			table.insert(var16_1, iter15_1)
		end
	end

	if #var27_1 > 0 then
		for iter16_1, iter17_1 in ipairs(var27_1) do
			table.insert(var16_1, iter17_1)
		end
	end

	if #var28_1 > 0 then
		for iter18_1, iter19_1 in ipairs(var28_1) do
			table.insert(var16_1, iter19_1)
		end
	end

	if arg1_1 and arg1_1 > 0 then
		var0_0.AddIslandExp(arg1_1)
	end

	return {
		awards = var16_1,
		overflowAwards = var17_1,
		abilitys = var18_1,
		exp = arg1_1,
		drops = var19_1
	}
end

function var0_0.GetIslandTimestamps(arg0_2)
	local var0_2 = pg.island_drop_time_set
	local var1_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2) do
		local var2_2 = var0_2[iter1_2.id]
		local var3_2 = var2_2.drop_type
		local var4_2 = var2_2.link_id
		local var5_2 = iter1_2.number

		if not var1_2[var3_2] then
			var1_2[var3_2] = {}
		end

		var1_2[var3_2][var4_2] = var5_2
	end

	return var1_2
end

function var0_0.AddIslandExp(arg0_3)
	getProxy(IslandProxy):GetIsland():AddExp(arg0_3)
end

function var0_0.AddIslandItems(arg0_4)
	local var0_4 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4) do
		local var2_4 = IslandItem.New(iter1_4)

		var0_4:AddItem(var2_4)
		table.insert(var1_4, Drop.New({
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_4.id,
			count = iter1_4.number or iter1_4.num or iter1_4.count
		}))
	end

	return var1_4
end

function var0_0.AddIslandOverFlowItems(arg0_5)
	local var0_5 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5) do
		local var2_5 = IslandItem.New(iter1_5)

		var0_5:AddOverFlowItem(var2_5)
		table.insert(var1_5, Drop.New({
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_5.id,
			count = iter1_5.number or iter1_5.num or iter1_5.count
		}))
	end

	return var1_5
end

function var0_0.AddIslandAbility(arg0_6)
	local var0_6 = getProxy(IslandProxy):GetIsland():GetAblityAgency()
	local var1_6 = {}

	for iter0_6, iter1_6 in ipairs(arg0_6) do
		if not var0_6:HasAbility(iter1_6.id) then
			var0_6:AddAblity(iter1_6.id)
			var0_0.HandleIslandShopAbility(iter1_6.id)
			var0_0.HandleIslandAbilityByType(iter1_6.id)
			table.insert(var1_6, Drop.New({
				count = 1,
				type = DROP_TYPE_ISLAND_ABILITY,
				id = iter1_6.id
			}))
		end
	end

	return var1_6
end

function var0_0.HandleIslandShopAbility(arg0_7)
	local var0_7 = IslandAblityAgency.GetEffect(arg0_7)

	if IslandAblityAgency.IsShopTypeNormal(arg0_7) then
		local var1_7 = pg.island_shop_normal_template[var0_7]

		if var1_7 then
			local var2_7 = var1_7.unlock == "" and {} or var1_7.unlock
			local var3_7 = true

			for iter0_7, iter1_7 in ipairs(var2_7) do
				if not getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(iter1_7) then
					var3_7 = false

					break
				end
			end

			if var3_7 then
				getProxy(IslandProxy):GetIsland():GetShopAgency():RefreshShopData(var0_7)
			end
		end
	elseif IslandAblityAgency.IsShopTypeTemporary(arg0_7) then
		getProxy(IslandProxy):GetIsland():GetShopAgency():RefreshShopData(var0_7)
	end
end

function var0_0.HandleIslandAbilityByType(arg0_8)
	local var0_8 = getProxy(IslandProxy):GetIsland()
	local var1_8 = IslandAblityAgency.GetEffect(arg0_8)

	switch(IslandAblityAgency.GetAblityType(arg0_8), {
		[IslandAblityAgency.TYPE_SLOT] = function()
			var0_8:GetBuildingAgency():InitSlotDataByAbility(arg0_8)
		end,
		[IslandAblityAgency.TYPE_RESTAURANT] = function()
			var0_8:GetManageAgency():UnlockNewRestaurant(var1_8)
		end,
		[IslandAblityAgency.TYPE_ASSISTANT] = function()
			var0_8:GetManageAgency():UnlockNewAssistant(var1_8)
		end,
		[IslandAblityAgency.TYPE_ANIMAL] = function()
			var0_8:GetBuildingAgency():InitBuildAnimalDataByAbility(var1_8)
		end,
		[IslandAblityAgency.TYPE_RECOVER_CAMP] = function()
			local var0_13 = var0_8:GetBuildingAgency():GetBuilding(IslandProductConst.FellingPlaceId):GetBuildingCollectData()
			local var1_13 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_13 = pg.TimeMgr.GetInstance():GetZeroTimeStamp(var1_13) + var1_8

			if var2_13 < var0_13:GetNextRecoverTimes() then
				var0_13:UpdateCollectRefreshtTime(var2_13)
			end
		end,
		[IslandAblityAgency.TYPE_RECOVER_ORE] = function()
			local var0_14 = var0_8:GetBuildingAgency():GetBuilding(IslandProductConst.MinePlaceId):GetBuildingCollectData()
			local var1_14 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_14 = pg.TimeMgr.GetInstance():GetZeroTimeStamp(var1_14) + var1_8

			if var2_14 < var0_14:GetNextRecoverTimes() then
				var0_14:UpdateCollectRefreshtTime(var2_14)
			end
		end,
		[IslandAblityAgency.TYPE_FISHING_ROD] = function()
			var0_8:GetFishingAgency():UpdateFishRodId(var1_8)
		end
	})
end

function var0_0.AddPlayerItems(arg0_16)
	return PlayerConst.addTranDrop(arg0_16)
end

function var0_0.AddShipInvitations(arg0_17)
	local var0_17 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17) do
		var0_17:AddInvite(iter1_17.id)
		table.insert(var1_17, Drop.New({
			type = DROP_TYPE_ISLAND_INVITATION,
			id = iter1_17.id,
			count = iter1_17.number or iter1_17.num or iter1_17.count
		}))
	end

	return var1_17
end

function var0_0.AddVirtualDrops(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in ipairs(arg0_18) do
		switch(iter1_18.type, {
			[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function()
				local var0_19 = Drop.New({
					type = iter1_18.type,
					id = iter1_18.id,
					count = iter1_18.number or iter1_18.num or iter1_18.count
				})

				table.insert(var0_18, var0_19)
				getProxy(IslandProxy):GetIsland():GetSeasonAgency():AddPt(var0_19.count)
			end
		})
	end

	return var0_18
end

function var0_0.AddIslandFurnitureDrops(arg0_20)
	local var0_20 = getProxy(IslandProxy):GetIsland():GetAgoraAgency()
	local var1_20 = {}

	for iter0_20, iter1_20 in ipairs(arg0_20) do
		local var2_20 = IslandFurniture.New({
			id = iter1_20.id,
			count = iter1_20.number or iter1_20.num or iter1_20.count
		})

		var2_20:SetTime(pg.TimeMgr:GetInstance():GetServerTime())
		var0_20:AddFurniture(var2_20)
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.FURNITURE)
		table.insert(var1_20, Drop.New({
			type = DROP_TYPE_ISLAND_FURNITURE,
			id = iter1_20.id,
			count = iter1_20.number or iter1_20.num or iter1_20.count
		}))
	end

	return var1_20
end

function var0_0.AddIslandDressDrops(arg0_21)
	local var0_21 = {}
	local var1_21 = getProxy(IslandProxy):GetIsland()

	for iter0_21, iter1_21 in ipairs(arg0_21) do
		local var2_21 = pg.island_dress_template[iter1_21.id]

		if var2_21.belongto == 1 then
			var1_21:GetDressUpAgency():AddDressByDressId(iter1_21.id)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.COMMANDER_DRESS)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.COMMANDER_DRESS_ID)
			IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.COMMANDER_DRESS_TYPE, var2_21.type, 1)
		else
			local var3_21 = var1_21:GetCharacterAgency()
			local var4_21 = not var3_21:ExistDressId(iter1_21.id)

			var3_21:AddDressItem(iter1_21.id, iter1_21.number, true)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.SHIP_DRESS_ID)

			if var4_21 then
				IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.SHIP_DRESS)
				IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.SHIP_DRESS_TYPE, var2_21.type, 1)
			end
		end

		table.insert(var0_21, Drop.New({
			type = DROP_TYPE_ISLAND_DRESS,
			id = iter1_21.id,
			count = iter1_21.number or iter1_21.num or iter1_21.count
		}))
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandGetDress(var2_21.belongto, iter1_21.id))
	end

	return var0_21
end

function var0_0.AddIslandSkinDrops(arg0_22)
	local var0_22 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	local var1_22 = {}

	for iter0_22, iter1_22 in ipairs(arg0_22) do
		var0_22:AddSkin(iter1_22.id)
		table.insert(var1_22, Drop.New({
			type = DROP_TYPE_ISLAND_SKIN,
			id = iter1_22.id,
			count = iter1_22.number or iter1_22.num or iter1_22.count
		}))
	end

	if #arg0_22 > 0 then
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.SHIP_SKIN)
		IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.SHIP_SKIN, 0, #arg0_22)
	end

	return var1_22
end

function var0_0.AddIslandActionDrops(arg0_23)
	local var0_23 = getProxy(IslandProxy):GetIsland():GetActionAgency()
	local var1_23 = {}

	for iter0_23, iter1_23 in ipairs(arg0_23) do
		var0_23:AddAction(iter1_23.id)
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.ACTION)
		IslandAchievementHelper.UpdateRecordWithAdd(IslandTaskTargetType.ACTION, 0, 1)
		table.insert(var1_23, Drop.New({
			type = DROP_TYPE_ISLAND_ACTION,
			id = iter1_23.id,
			count = iter1_23.number or iter1_23.num or iter1_23.count
		}))
	end

	return var1_23
end

function var0_0.AddIslandCardDiyDrops(arg0_24)
	local var0_24 = getProxy(IslandProxy):GetIsland():GetCardDiyAgency()
	local var1_24 = {}

	for iter0_24, iter1_24 in ipairs(arg0_24) do
		var0_24:AddCardDiy(iter1_24)
		table.insert(var1_24, Drop.New({
			type = DROP_TYPE_ISLAND_CARD_DIY,
			id = iter1_24.id,
			count = iter1_24.number or iter1_24.num or iter1_24.count
		}))
	end

	return var1_24
end

function var0_0.AddIslandTicketDrops(arg0_25, arg1_25)
	local var0_25 = getProxy(IslandProxy):GetIsland():GetTicketAgency()
	local var1_25 = {}

	for iter0_25, iter1_25 in ipairs(arg0_25) do
		local var2_25 = arg1_25[DROP_TYPE_ISLAND_SPEEDUP_TICKET][iter1_25.id]
		local var3_25 = IslandTicket.GetEndTimeById(iter1_25.id, var2_25)
		local var4_25 = iter1_25.number or iter1_25.num or iter1_25.count

		var0_25:AddTicket(iter1_25.id, var3_25, var4_25)
		table.insert(var1_25, Drop.New({
			type = DROP_TYPE_ISLAND_SPEEDUP_TICKET,
			id = iter1_25.id,
			count = var4_25
		}))
	end

	return var1_25
end

function var0_0.AddIslandCollectDrops(arg0_26)
	local var0_26 = getProxy(IslandProxy):GetIsland():GetWildCollectAgency()
	local var1_26 = {}

	for iter0_26, iter1_26 in ipairs(arg0_26) do
		var0_26:AddFinishCollectData(iter1_26.id)
		table.insert(var1_26, Drop.New({
			type = DROP_TYPE_ISLAND_COLLECTION,
			id = iter1_26.id,
			count = iter1_26.number or iter1_26.num or iter1_26.count
		}))
	end

	return var1_26
end

return var0_0
