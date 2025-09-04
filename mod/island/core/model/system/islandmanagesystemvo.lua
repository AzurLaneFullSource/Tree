local var0_0 = class("IslandManageSystemVO", import(".IslandSystemVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.id = arg1_1
	arg0_1.name = "_system_manage_" .. arg0_1.id
	arg0_1.restaurant = arg2_1
end

function var0_0.GetType(arg0_2)
	return IslandConst.SYSTEM_TYPE_MANAGE
end

function var0_0.GetBehaviourTree(arg0_3)
	return "island/nodecanvas/system/system_manage_place"
end

function var0_0.GetUnits(arg0_4, arg1_4)
	local var0_4 = {}

	arg0_4.assistants = {}

	if arg1_4 then
		arg0_4.assistants = arg1_4
	else
		arg0_4.assistants = arg0_4.restaurant:GetAssistants()
	end

	for iter0_4, iter1_4 in ipairs(arg0_4.assistants) do
		local var1_4 = iter1_4.id or iter1_4.post_id
		local var2_4 = iter1_4.shipId or iter1_4.ship_id

		if var2_4 ~= 0 then
			local var3_4 = pg.island_manage_assistant[var1_4].birthplace
			local var4_4 = pg.island_world_objects[var3_4]
			local var5_4

			if var2_4 == 1 then
				var5_4 = IslandUnitVO.New({
					behaviourTree = "island/nodecanvas/system/system_manage_assistant_chicken",
					id = var2_4,
					modelId = pg.island_chara_template[var2_4].unit_id,
					type = IslandConst.UNIT_TYPE_MANAGE_CHARA,
					name = "system_unit" .. var2_4,
					position = var4_4.param.position,
					rotation = var4_4.param.rotation,
					scale = Vector3.one
				})
			else
				var5_4 = IslandUnitVO.New({
					behaviourTree = "island/nodecanvas/system/system_manage_assistant",
					id = var2_4,
					modelId = pg.island_chara_template[var2_4].unit_id,
					type = IslandConst.UNIT_TYPE_MANAGE_CHARA,
					name = "system_unit" .. var2_4,
					position = var4_4.param.position,
					rotation = var4_4.param.rotation,
					scale = Vector3.one
				})
			end

			table.insert(var0_4, var5_4)
		end
	end

	local var6_4 = arg0_4.restaurant:getConfig("customer_slot")
	local var7_4 = pg.island_set.island_manage_customer_list.key_value_varchar

	for iter2_4, iter3_4 in ipairs(var6_4) do
		local var8_4 = iter3_4[1]
		local var9_4 = iter3_4[2]
		local var10_4 = pg.island_world_objects[var8_4]
		local var11_4 = pg.island_world_objects[var9_4]
		local var12_4 = var7_4[math.random(#var7_4)]
		local var13_4 = IslandUnitVO.New({
			behaviourTree = "island/nodecanvas/system/system_manage_customer",
			id = var8_4,
			modelId = var12_4,
			type = IslandConst.UNIT_TYPE_MANAGE_CUSTOMER,
			name = "system_unit" .. var8_4,
			position = var10_4.param.position,
			rotation = var10_4.param.rotation,
			scale = Vector3.one
		})

		table.insert(var0_4, var13_4)

		local var14_4 = IslandUnitVO.New({
			behaviourTree = "",
			id = var9_4,
			modelId = var11_4.unitId,
			type = IslandConst.UNIT_TYPE_MANAGE_ITEM,
			name = "system_unit" .. var9_4,
			position = var11_4.param.position,
			rotation = var11_4.param.rotation,
			scale = Vector3.one
		})

		table.insert(var0_4, var14_4)
	end

	return var0_4
end

function var0_0.GetPostUnitNodeList(arg0_5)
	local var0_5 = System.Collections.Generic.List_IslandUnitNode()

	for iter0_5, iter1_5 in ipairs(arg0_5.assistants) do
		local var1_5 = iter1_5.id or iter1_5.post_id

		if (iter1_5.shipId or iter1_5.ship_id) ~= 0 then
			local var2_5

			var2_5.unitId, var2_5 = pg.island_manage_assistant[var1_5].birthplace, IslandUnitNode.New()
			var2_5.unitType = IslandConst.UNIT_LIST_OBJ

			var0_5:Add(var2_5)
		end
	end

	return var0_5
end

function var0_0.GetAssistantUnitNodeList(arg0_6)
	local var0_6 = System.Collections.Generic.List_IslandUnitNode()

	for iter0_6, iter1_6 in ipairs(arg0_6.assistants) do
		local var1_6 = iter1_6.shipId or iter1_6.ship_id

		if var1_6 ~= 0 then
			local var2_6 = IslandUnitNode.New()

			var2_6.unitId = var1_6
			var2_6.unitType = IslandConst.UNIT_LIST_MANAGE

			var0_6:Add(var2_6)
		end
	end

	return var0_6
end

function var0_0.GetCustomerUnitNodeList(arg0_7)
	local var0_7 = System.Collections.Generic.List_IslandUnitNode()
	local var1_7 = arg0_7.restaurant:getConfig("customer_slot")

	for iter0_7, iter1_7 in ipairs(var1_7) do
		local var2_7

		var2_7.unitId, var2_7 = iter1_7[1], IslandUnitNode.New()
		var2_7.unitType = IslandConst.UNIT_LIST_MANAGE

		var0_7:Add(var2_7)
	end

	return var0_7
end

function var0_0.GetFoodUnitIds(arg0_8)
	local var0_8 = {}
	local var1_8 = arg0_8.restaurant:getConfig("customer_slot")

	for iter0_8, iter1_8 in ipairs(var1_8) do
		local var2_8 = iter1_8[2]

		table.insert(var0_8, var2_8)
	end

	return var0_8
end

function var0_0.GetStatus(arg0_9)
	return arg0_9.restaurant:GetStatus()
end

function var0_0.GetRestId(arg0_10)
	return arg0_10.restaurant.id
end

function var0_0.GetPostList(arg0_11)
	return arg0_11.restaurant:GetAssistants()
end

return var0_0
