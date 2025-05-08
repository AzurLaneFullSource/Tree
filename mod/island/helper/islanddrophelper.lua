local var0_0 = class("IslandDropHelper")

function var0_0.AddItems(arg0_1)
	local var0_1 = arg0_1.drop_list or {}
	local var1_1 = {}
	local var2_1 = {}
	local var3_1 = {}
	local var4_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		if iter1_1.type == DROP_TYPE_ISLAND_ITEM then
			table.insert(var1_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_OVERFLOWITEM then
			table.insert(var2_1, iter1_1)
		elseif iter1_1.type == DROP_TYPE_ISLAND_ABILITY then
			table.insert(var3_1, iter1_1)
		else
			table.insert(var4_1, iter1_1)
		end
	end

	local var5_1 = var0_0.AddIslandItems(var1_1)
	local var6_1 = var0_0.AddIslandOverFlowItems(var2_1)
	local var7_1 = var0_0.AddIslandAbility(var3_1)
	local var8_1 = var0_0.AddPlayerItems(var4_1)

	print(#var5_1, #var6_1, #var7_1, #var8_1)

	return {
		awards = var5_1,
		overflowAwards = var6_1,
		abilitys = var7_1,
		drops = var8_1
	}
end

function var0_0.AddIslandItems(arg0_2)
	local var0_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2) do
		local var2_2 = IslandItem.New(iter1_2)

		var0_2:AddItem(var2_2)
		table.insert(var1_2, Drop.New({
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_2.id,
			count = iter1_2.number or iter1_2.num or iter1_2.count
		}))
	end

	return var1_2
end

function var0_0.AddIslandOverFlowItems(arg0_3)
	local var0_3 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3) do
		local var2_3 = IslandItem.New(iter1_3)

		var0_3:AddOverFlowItem(var2_3)
		table.insert(var1_3, Drop.New({
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_3.id,
			count = iter1_3.number or iter1_3.num or iter1_3.count
		}))
	end

	return var1_3
end

function var0_0.AddIslandAbility(arg0_4)
	local var0_4 = getProxy(IslandProxy):GetIsland():GetAblityAgency()
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4) do
		if not var0_4:HasAbility(iter1_4.id) then
			var0_4:AddAblity(iter1_4.id)
			var0_0.HandleIslandShopAbility(iter1_4.id)
			var0_0.HandleIslandAbilityByType(iter1_4.id)
			table.insert(var1_4, Drop.New({
				count = 1,
				type = DROP_TYPE_ISLAND_ABILITY,
				id = iter1_4.id
			}))
		end
	end

	return var1_4
end

function var0_0.HandleIslandShopAbility(arg0_5)
	local var0_5 = IslandAblityAgency.GetEffect(arg0_5)

	if IslandAblityAgency.IsShopTypeNormal(arg0_5) then
		local var1_5 = pg.island_shop_normal_template[var0_5]

		if var1_5 then
			local var2_5 = var1_5.unlock
			local var3_5 = true

			for iter0_5, iter1_5 in ipairs(var2_5) do
				if not getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(iter1_5) then
					var3_5 = false

					break
				end
			end

			if var3_5 then
				getProxy(IslandProxy):GetIsland():GetShopAgency():RefreshShopData(var0_5)
			end
		end
	elseif IslandAblityAgency.IsShopTypeTemporary(arg0_5) then
		getProxy(IslandProxy):GetIsland():GetShopAgency():RefreshShopData(var0_5)
	end
end

function var0_0.HandleIslandAbilityByType(arg0_6)
	switch(IslandAblityAgency.GetAblityType(arg0_6), {
		[IslandAblityAgency.TYPE_SLOT] = function()
			getProxy(IslandProxy):GetIsland():GetBuildingAgency():InitSlotRoleDataByAbility(arg0_6)
		end
	})
end

function var0_0.AddPlayerItems(arg0_8)
	return PlayerConst.addTranDrop(arg0_8)
end

return var0_0
