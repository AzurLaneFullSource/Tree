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
				table.insert(var9_1, iter1_1)
			end
		elseif iter1_1.type == DROP_TYPE_ISLAND_FURNITURE then
			table.insert(var6_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_DRESS then
			table.insert(var7_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_SKIN then
			table.insert(var8_1, iter1_1)
		else
			table.insert(var4_1, iter1_1)
		end
	end

	local var10_1 = var0_0.AddIslandItems(var1_1)
	local var11_1 = var0_0.AddIslandOverFlowItems(var2_1)
	local var12_1 = var0_0.AddIslandAbility(var3_1)
	local var13_1 = var0_0.AddPlayerItems(var4_1)
	local var14_1 = var0_0.AddShipInvitations(var5_1)
	local var15_1 = var0_0.AddVirtualDrops(var9_1)
	local var16_1 = var0_0.AddIslandFurnitureDrops(var6_1)
	local var17_1 = var0_0.AddIslandDressDrops(var7_1)
	local var18_1 = var0_0.AddIslandSkinDrops(var8_1)

	if #var14_1 > 0 then
		for iter2_1, iter3_1 in ipairs(var14_1) do
			table.insert(var10_1, iter3_1)
		end
	end

	if #var15_1 > 0 then
		for iter4_1, iter5_1 in ipairs(var15_1) do
			table.insert(var10_1, iter5_1)
		end
	end

	if #var16_1 > 0 then
		for iter6_1, iter7_1 in ipairs(var16_1) do
			table.insert(var10_1, iter7_1)
		end
	end

	if #var17_1 > 0 then
		for iter8_1, iter9_1 in ipairs(var17_1) do
			table.insert(var10_1, iter9_1)
		end
	end

	if #var18_1 > 0 then
		for iter10_1, iter11_1 in ipairs(var18_1) do
			table.insert(var10_1, iter11_1)
		end
	end

	if arg1_1 and arg1_1 > 0 then
		var0_0.AddIslandExp(arg1_1)
	end

	return {
		awards = var10_1,
		overflowAwards = var11_1,
		abilitys = var12_1,
		exp = arg1_1,
		drops = var13_1
	}
end

function var0_0.AddIslandExp(arg0_2)
	getProxy(IslandProxy):GetIsland():AddExp(arg0_2)
end

function var0_0.AddIslandItems(arg0_3)
	local var0_3 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3) do
		local var2_3 = IslandItem.New(iter1_3)

		var0_3:AddItem(var2_3)
		table.insert(var1_3, Drop.New({
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_3.id,
			count = iter1_3.number or iter1_3.num or iter1_3.count
		}))
	end

	return var1_3
end

function var0_0.AddIslandOverFlowItems(arg0_4)
	local var0_4 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4) do
		local var2_4 = IslandItem.New(iter1_4)

		var0_4:AddOverFlowItem(var2_4)
		table.insert(var1_4, Drop.New({
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_4.id,
			count = iter1_4.number or iter1_4.num or iter1_4.count
		}))
	end

	return var1_4
end

function var0_0.AddIslandAbility(arg0_5)
	local var0_5 = getProxy(IslandProxy):GetIsland():GetAblityAgency()
	local var1_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5) do
		if not var0_5:HasAbility(iter1_5.id) then
			var0_5:AddAblity(iter1_5.id)
			var0_0.HandleIslandShopAbility(iter1_5.id)
			var0_0.HandleIslandAbilityByType(iter1_5.id)
			table.insert(var1_5, Drop.New({
				count = 1,
				type = DROP_TYPE_ISLAND_ABILITY,
				id = iter1_5.id
			}))
		end
	end

	return var1_5
end

function var0_0.HandleIslandShopAbility(arg0_6)
	local var0_6 = IslandAblityAgency.GetEffect(arg0_6)

	if IslandAblityAgency.IsShopTypeNormal(arg0_6) then
		local var1_6 = pg.island_shop_normal_template[var0_6]

		if var1_6 then
			local var2_6 = var1_6.unlock == "" and {} or var1_6.unlock
			local var3_6 = true

			for iter0_6, iter1_6 in ipairs(var2_6) do
				if not getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(iter1_6) then
					var3_6 = false

					break
				end
			end

			if var3_6 then
				getProxy(IslandProxy):GetIsland():GetShopAgency():RefreshShopData(var0_6)
			end
		end
	elseif IslandAblityAgency.IsShopTypeTemporary(arg0_6) then
		getProxy(IslandProxy):GetIsland():GetShopAgency():RefreshShopData(var0_6)
	end
end

function var0_0.HandleIslandAbilityByType(arg0_7)
	local var0_7 = getProxy(IslandProxy):GetIsland()
	local var1_7 = IslandAblityAgency.GetEffect(arg0_7)

	switch(IslandAblityAgency.GetAblityType(arg0_7), {
		[IslandAblityAgency.TYPE_SLOT] = function()
			var0_7:GetBuildingAgency():InitSlotDataByAbility(arg0_7)
		end,
		[IslandAblityAgency.TYPE_RESTAURANT] = function()
			var0_7:GetManageAgency():UnlockNewRestaurant(var1_7)
		end,
		[IslandAblityAgency.TYPE_ASSISTANT] = function()
			var0_7:GetManageAgency():UnlockNewAssistant(var1_7)
		end,
		[IslandAblityAgency.TYPE_ANIMAL] = function()
			var0_7:GetBuildingAgency():InitBuildAnimalDataByAbility(var1_7)
		end
	})
end

function var0_0.AddPlayerItems(arg0_12)
	return PlayerConst.addTranDrop(arg0_12)
end

function var0_0.AddShipInvitations(arg0_13)
	local var0_13 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	local var1_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13) do
		var0_13:AddInvite(iter1_13.id)
		table.insert(var1_13, Drop.New({
			type = DROP_TYPE_ISLAND_INVITATION,
			id = iter1_13.id,
			count = iter1_13.number or iter1_13.num or iter1_13.count
		}))
	end

	return var1_13
end

function var0_0.AddVirtualDrops(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14) do
		switch(iter1_14.type, {
			[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function()
				local var0_15 = Drop.New({
					type = iter1_14.type,
					id = iter1_14.id,
					count = iter1_14.number or iter1_14.num or iter1_14.count
				})

				table.insert(var0_14, var0_15)
				getProxy(IslandProxy):GetIsland():GetSeasonAgency():AddPt(var0_15.count)
			end
		})
	end

	return var0_14
end

function var0_0.AddIslandFurnitureDrops(arg0_16)
	local var0_16 = getProxy(IslandProxy):GetIsland():GetAgoraAgency()
	local var1_16 = {}

	for iter0_16, iter1_16 in ipairs(arg0_16) do
		local var2_16 = IslandFurniture.New({
			id = iter1_16.id,
			count = iter1_16.number or iter1_16.num or iter1_16.count
		})

		var0_16:AddFurniture(var2_16)
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.FURNITURE)
		table.insert(var1_16, Drop.New({
			type = DROP_TYPE_ISLAND_FURNITURE,
			id = iter1_16.id,
			count = iter1_16.number or iter1_16.num or iter1_16.count
		}))
	end

	return var1_16
end

function var0_0.AddIslandDressDrops(arg0_17)
	local var0_17 = {}
	local var1_17 = getProxy(IslandProxy):GetIsland()

	for iter0_17, iter1_17 in ipairs(arg0_17) do
		local var2_17 = pg.island_dress_template[iter1_17.id]

		if var2_17.belongto == 1 then
			var1_17:GetDressUpAgency():AddDressByDressId(iter1_17.id)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.COMMANDER_DRESS)
			IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.COMMANDER_DRESS_TYPE, var2_17.type, 1)
		else
			local var3_17 = var1_17:GetCharacterAgency()
			local var4_17 = not var3_17:ExistDressId(iter1_17.id)

			var3_17:AddDressItem(iter1_17.id, iter1_17.number)

			if var4_17 then
				IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.SHIP_DRESS)
				IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.SHIP_DRESS_TYPE, var2_17.type, 1)
			end
		end

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandGetDress(var2_17.belongto, iter1_17.id))
	end

	return var0_17
end

function var0_0.AddIslandSkinDrops(arg0_18)
	local var0_18 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	local var1_18 = {}

	for iter0_18, iter1_18 in ipairs(arg0_18) do
		var0_18:AddSkin(iter1_18.id)
		table.insert(var1_18, Drop.New({
			type = DROP_TYPE_ISLAND_SKIN,
			id = iter1_18.id,
			count = iter1_18.number or iter1_18.num or iter1_18.count
		}))
	end

	if #arg0_18 > 0 then
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.SHIP_SKIN)
		IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.SHIP_SKIN, 0, #arg0_18)
	end

	return var1_18
end

return var0_0
