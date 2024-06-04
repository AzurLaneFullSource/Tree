local var0 = {}

var0.__name = "EquipmentTransformUtil"

function var0.SameDrop(arg0, arg1)
	if arg0.type ~= arg1.type then
		return false
	end

	if arg0.type == DROP_TYPE_EQUIP then
		return EquipmentProxy.SameEquip(arg0.template, arg1.template)
	else
		return arg0.id == arg1.id
	end
end

function var0.CheckEquipmentFormulasSucceed(arg0, arg1)
	local var0 = getProxy(PlayerProxy)
	local var1 = getProxy(BagProxy)
	local var2 = {}
	local var3 = arg1

	for iter0, iter1 in ipairs(arg0) do
		local var4 = pg.equip_upgrade_data[iter1]
		local var5 = Equipment.GetRevertRewardsStatic(var3)

		assert(Equipment.CanInBag(var3), "Missing equip_data_template ID: " .. (var3 or "NIL"))

		local var6 = Equipment.CanInBag(var3) and Equipment.getConfigData(var3).destory_gold or 0

		var3 = Equipment.GetEquipRootStatic(var3)

		assert(var4 and var4.upgrade_from == var3, "Transform a non formula equipment, formula " .. (iter1 or -1) .. " equipment " .. (var3 or -1))

		local var7 = var4.material_consume

		for iter2, iter3 in ipairs(var7) do
			local var8 = iter3[1]
			local var9 = iter3[2]

			var2[var8] = (var2[var8] or var1:getItemCountById(var8) or 0) - var9

			if var2[var8] < 0 then
				local var10 = Item.getConfigData(var8)

				return false, var10 and var10.name
			end
		end

		var2.gold = (var2.gold or var0:getRawData().gold or 0) - var4.coin_consume

		if var2.gold < 0 then
			return false, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold
			}):getName()
		end

		for iter4, iter5 in pairs(var5) do
			if iter4 ~= "gold" then
				var2[iter4] = (var2[iter4] or 0) + iter5
			end
		end

		var2.gold = (var2.gold or 0) + var6
		var3 = var4.target_id
	end

	return true
end

function var0.CheckTransformFormulasSucceed(arg0, arg1)
	local var0 = getProxy(PlayerProxy)
	local var1 = getProxy(BagProxy)
	local var2 = {
		gold = var0:getRawData().gold or 0
	}
	local var3

	if arg1.type == DROP_TYPE_EQUIP then
		var3 = arg1.id

		if not arg1.template.shipId then
			local var4 = getProxy(EquipmentProxy):getEquipmentById(var3)

			if not var4 or var4.count <= 0 then
				return false, Equipment.getConfigData(var3).name
			end
		end
	elseif arg1.type == DROP_TYPE_ITEM then
		if var2.gold < arg1.composeCfg.gold_num then
			return false, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold
			}):getName()
		elseif (var1:getItemCountById(arg1.composeCfg.material_id) or 0) < arg1.composeCfg.material_num then
			return false, Item.getConfigData(arg1.composeCfg.material_id).name
		end

		var2.gold = var2.gold - arg1.composeCfg.gold_num
		var3 = arg1.composeCfg.equip_id
	end

	assert(var3)

	local var5 = var3

	for iter0, iter1 in ipairs(arg0) do
		local var6 = pg.equip_upgrade_data[iter1]
		local var7 = Equipment.GetRevertRewardsStatic(var5)

		assert(Equipment.CanInBag(var5), "Missing equip_data_template ID: " .. (var5 or "NIL"))

		local var8 = Equipment.CanInBag(var5) and Equipment.getConfigData(var5).destory_gold or 0

		var5 = Equipment.GetEquipRootStatic(var5)

		assert(var6 and var6.upgrade_from == var5, "Transform a non formula equipment, formula " .. (iter1 or -1) .. " equipment " .. (var5 or -1))

		local var9 = var6.material_consume

		for iter2, iter3 in ipairs(var9) do
			local var10 = iter3[1]
			local var11 = iter3[2]

			var2[var10] = (var2[var10] or var1:getItemCountById(var10) or 0) - var11

			if var2[var10] < 0 then
				local var12 = Item.getConfigData(var10)

				return false, var12 and var12.name
			end
		end

		var2.gold = var2.gold - var6.coin_consume

		if var2.gold < 0 then
			return false, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold
			}):getName()
		end

		for iter4, iter5 in pairs(var7) do
			if iter4 ~= "gold" then
				var2[iter4] = (var2[iter4] or var1:getItemCountById(iter4)) + iter5
			end
		end

		var2.gold = (var2.gold or 0) + var8
		var5 = var6.target_id
	end

	return true
end

function var0.CheckTransformEnoughGold(arg0, arg1)
	local var0 = getProxy(PlayerProxy)
	local var1 = getProxy(BagProxy)
	local var2 = var0:getRawData().gold or 0
	local var3 = 0
	local var4 = 0
	local var5 = true
	local var6

	if arg1.type == DROP_TYPE_EQUIP then
		var6 = arg1.id
	elseif arg1.type == DROP_TYPE_ITEM then
		var2 = var2 - arg1.composeCfg.gold_num
		var4 = var4 + arg1.composeCfg.gold_num
		var5 = var5 and var2 >= 0
		var6 = arg1.composeCfg.equip_id
	end

	assert(var6)

	local var7 = var6

	for iter0, iter1 in ipairs(arg0) do
		local var8 = pg.equip_upgrade_data[iter1]
		local var9 = Equipment.GetRevertRewardsStatic(var7)

		assert(Equipment.CanInBag(var7), "Missing equip_data_template ID: " .. (var7 or "NIL"))

		local var10 = Equipment.CanInBag(var7) and Equipment.getConfigData(var7).destory_gold or 0

		var7 = Equipment.GetEquipRootStatic(var7)

		assert(var8 and var8.upgrade_from == var7, "Transform a non formula equipment, formula " .. (iter1 or -1) .. " equipment " .. (var7 or -1))

		var2 = var2 - var8.coin_consume
		var3 = var3 + var8.coin_consume
		var5 = var5 and var2 >= 0

		for iter2, iter3 in pairs(var9) do
			if iter2 ~= "gold" then
				var2 = var2 + iter3
			end
		end

		var2 = var2 + var10
		var7 = var8.target_id
	end

	return var5, var3, var4
end

local function var1(arg0, arg1)
	local var0 = {
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

	for iter0, iter1 in ipairs(var0) do
		local var1 = arg0:Find(iter1[1])

		if type ~= iter1[2] and not IsNil(var1) then
			setActive(var1, false)
		end
	end

	arg0:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true
end

return var0
