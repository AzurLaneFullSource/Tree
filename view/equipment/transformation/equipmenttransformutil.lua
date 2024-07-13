local var0_0 = {}

var0_0.__name = "EquipmentTransformUtil"

function var0_0.SameDrop(arg0_1, arg1_1)
	if arg0_1.type ~= arg1_1.type then
		return false
	end

	if arg0_1.type == DROP_TYPE_EQUIP then
		return EquipmentProxy.SameEquip(arg0_1.template, arg1_1.template)
	else
		return arg0_1.id == arg1_1.id
	end
end

function var0_0.CheckEquipmentFormulasSucceed(arg0_2, arg1_2)
	local var0_2 = getProxy(PlayerProxy)
	local var1_2 = getProxy(BagProxy)
	local var2_2 = {}
	local var3_2 = arg1_2

	for iter0_2, iter1_2 in ipairs(arg0_2) do
		local var4_2 = pg.equip_upgrade_data[iter1_2]
		local var5_2 = Equipment.GetRevertRewardsStatic(var3_2)

		assert(Equipment.CanInBag(var3_2), "Missing equip_data_template ID: " .. (var3_2 or "NIL"))

		local var6_2 = Equipment.CanInBag(var3_2) and Equipment.getConfigData(var3_2).destory_gold or 0

		var3_2 = Equipment.GetEquipRootStatic(var3_2)

		assert(var4_2 and var4_2.upgrade_from == var3_2, "Transform a non formula equipment, formula " .. (iter1_2 or -1) .. " equipment " .. (var3_2 or -1))

		local var7_2 = var4_2.material_consume

		for iter2_2, iter3_2 in ipairs(var7_2) do
			local var8_2 = iter3_2[1]
			local var9_2 = iter3_2[2]

			var2_2[var8_2] = (var2_2[var8_2] or var1_2:getItemCountById(var8_2) or 0) - var9_2

			if var2_2[var8_2] < 0 then
				local var10_2 = Item.getConfigData(var8_2)

				return false, var10_2 and var10_2.name
			end
		end

		var2_2.gold = (var2_2.gold or var0_2:getRawData().gold or 0) - var4_2.coin_consume

		if var2_2.gold < 0 then
			return false, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold
			}):getName()
		end

		for iter4_2, iter5_2 in pairs(var5_2) do
			if iter4_2 ~= "gold" then
				var2_2[iter4_2] = (var2_2[iter4_2] or 0) + iter5_2
			end
		end

		var2_2.gold = (var2_2.gold or 0) + var6_2
		var3_2 = var4_2.target_id
	end

	return true
end

function var0_0.CheckTransformFormulasSucceed(arg0_3, arg1_3)
	local var0_3 = getProxy(PlayerProxy)
	local var1_3 = getProxy(BagProxy)
	local var2_3 = {
		gold = var0_3:getRawData().gold or 0
	}
	local var3_3

	if arg1_3.type == DROP_TYPE_EQUIP then
		var3_3 = arg1_3.id

		if not arg1_3.template.shipId then
			local var4_3 = getProxy(EquipmentProxy):getEquipmentById(var3_3)

			if not var4_3 or var4_3.count <= 0 then
				return false, Equipment.getConfigData(var3_3).name
			end
		end
	elseif arg1_3.type == DROP_TYPE_ITEM then
		if var2_3.gold < arg1_3.composeCfg.gold_num then
			return false, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold
			}):getName()
		elseif (var1_3:getItemCountById(arg1_3.composeCfg.material_id) or 0) < arg1_3.composeCfg.material_num then
			return false, Item.getConfigData(arg1_3.composeCfg.material_id).name
		end

		var2_3.gold = var2_3.gold - arg1_3.composeCfg.gold_num
		var3_3 = arg1_3.composeCfg.equip_id
	end

	assert(var3_3)

	local var5_3 = var3_3

	for iter0_3, iter1_3 in ipairs(arg0_3) do
		local var6_3 = pg.equip_upgrade_data[iter1_3]
		local var7_3 = Equipment.GetRevertRewardsStatic(var5_3)

		assert(Equipment.CanInBag(var5_3), "Missing equip_data_template ID: " .. (var5_3 or "NIL"))

		local var8_3 = Equipment.CanInBag(var5_3) and Equipment.getConfigData(var5_3).destory_gold or 0

		var5_3 = Equipment.GetEquipRootStatic(var5_3)

		assert(var6_3 and var6_3.upgrade_from == var5_3, "Transform a non formula equipment, formula " .. (iter1_3 or -1) .. " equipment " .. (var5_3 or -1))

		local var9_3 = var6_3.material_consume

		for iter2_3, iter3_3 in ipairs(var9_3) do
			local var10_3 = iter3_3[1]
			local var11_3 = iter3_3[2]

			var2_3[var10_3] = (var2_3[var10_3] or var1_3:getItemCountById(var10_3) or 0) - var11_3

			if var2_3[var10_3] < 0 then
				local var12_3 = Item.getConfigData(var10_3)

				return false, var12_3 and var12_3.name
			end
		end

		var2_3.gold = var2_3.gold - var6_3.coin_consume

		if var2_3.gold < 0 then
			return false, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold
			}):getName()
		end

		for iter4_3, iter5_3 in pairs(var7_3) do
			if iter4_3 ~= "gold" then
				var2_3[iter4_3] = (var2_3[iter4_3] or var1_3:getItemCountById(iter4_3)) + iter5_3
			end
		end

		var2_3.gold = (var2_3.gold or 0) + var8_3
		var5_3 = var6_3.target_id
	end

	return true
end

function var0_0.CheckTransformEnoughGold(arg0_4, arg1_4)
	local var0_4 = getProxy(PlayerProxy)
	local var1_4 = getProxy(BagProxy)
	local var2_4 = var0_4:getRawData().gold or 0
	local var3_4 = 0
	local var4_4 = 0
	local var5_4 = true
	local var6_4

	if arg1_4.type == DROP_TYPE_EQUIP then
		var6_4 = arg1_4.id
	elseif arg1_4.type == DROP_TYPE_ITEM then
		var2_4 = var2_4 - arg1_4.composeCfg.gold_num
		var4_4 = var4_4 + arg1_4.composeCfg.gold_num
		var5_4 = var5_4 and var2_4 >= 0
		var6_4 = arg1_4.composeCfg.equip_id
	end

	assert(var6_4)

	local var7_4 = var6_4

	for iter0_4, iter1_4 in ipairs(arg0_4) do
		local var8_4 = pg.equip_upgrade_data[iter1_4]
		local var9_4 = Equipment.GetRevertRewardsStatic(var7_4)

		assert(Equipment.CanInBag(var7_4), "Missing equip_data_template ID: " .. (var7_4 or "NIL"))

		local var10_4 = Equipment.CanInBag(var7_4) and Equipment.getConfigData(var7_4).destory_gold or 0

		var7_4 = Equipment.GetEquipRootStatic(var7_4)

		assert(var8_4 and var8_4.upgrade_from == var7_4, "Transform a non formula equipment, formula " .. (iter1_4 or -1) .. " equipment " .. (var7_4 or -1))

		var2_4 = var2_4 - var8_4.coin_consume
		var3_4 = var3_4 + var8_4.coin_consume
		var5_4 = var5_4 and var2_4 >= 0

		for iter2_4, iter3_4 in pairs(var9_4) do
			if iter2_4 ~= "gold" then
				var2_4 = var2_4 + iter3_4
			end
		end

		var2_4 = var2_4 + var10_4
		var7_4 = var8_4.target_id
	end

	return var5_4, var3_4, var4_4
end

local function var1_0(arg0_5, arg1_5)
	local var0_5 = {
		{
			"icon_bg/slv"
		},
		{
			"icon_bg/frame/IconColorful(Clone)"
		},
		{
			"icon_bg/frame/Item_duang5(Clone)"
		},
		{
			"icon_bg/frame/specialFrame"
		},
		{
			"ship_type"
		},
		{
			"icon_bg/new"
		},
		{
			"icon_bg/npc"
		}
	}

	for iter0_5, iter1_5 in ipairs(var0_5) do
		local var1_5 = arg0_5:Find(iter1_5[1])

		if type ~= iter1_5[2] and not IsNil(var1_5) then
			setActive(var1_5, false)
		end
	end

	arg0_5:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true
end

return var0_0
