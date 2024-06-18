local var0_0 = class("Fushun3ItemController")
local var1_0 = 3
local var2_0 = 100

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._sceneTf = arg1_1
	arg0_1._charTf = arg2_1
	arg0_1._itemTpls = arg3_1
	arg0_1._event = arg4_1
	arg0_1._charCollider = GetComponent(findTF(arg0_1._charTf, "collider"), typeof(BoxCollider2D))
	arg0_1._itemPos = findTF(arg0_1._sceneTf, "item")
	arg0_1.weightTotal = 0
	arg0_1.weightItems = {}
	arg0_1.items = {}
	arg0_1.itemPools = {}

	for iter0_1 = 1, #Fushun3GameConst.item_instance_data do
		local var0_1 = Fushun3GameConst.item_instance_data[iter0_1]

		arg0_1.weightTotal = arg0_1.weightTotal + var0_1.weight

		local var1_1 = arg0_1.weightTotal
		local var2_1 = var0_1.id
		local var3_1 = var0_1.map
		local var4_1 = {
			id = var2_1,
			weight = var1_1,
			map = var3_1
		}

		table.insert(arg0_1.weightItems, var4_1)
	end
end

function var0_0.setCallback(arg0_2, arg1_2)
	arg0_2._callback = arg1_2
end

function var0_0.start(arg0_3)
	for iter0_3 = #arg0_3.items, 1, -1 do
		local var0_3 = table.remove(arg0_3.items, iter0_3)

		arg0_3:returnItemToPool(var0_3)
	end

	arg0_3.createTime = math.random(Fushun3GameConst.create_time[1], Fushun3GameConst.create_time[2])
	arg0_3.createPos = Vector2.zero
	arg0_3.itemTime = var1_0
end

function var0_0.step(arg0_4)
	arg0_4:removeOutItems()

	local var0_4 = arg0_4._charCollider.bounds
	local var1_4 = {}

	for iter0_4 = #arg0_4.items, 1, -1 do
		local var2_4 = arg0_4.items[iter0_4]

		if var2_4.collider and var2_4.data.type ~= Fushun3GameConst.item_type_damage then
			local var3_4 = var2_4.collider.bounds

			if Fushun3GameConst.CheckBoxCollider(var0_4.min, var3_4.min, var0_4.size, var3_4.size) then
				local var4_4 = table.remove(arg0_4.items, iter0_4)

				if var4_4.data.effect then
					arg0_4._event:emit(Fushun3GameEvent.add_effect_call, {
						effectName = var4_4.data.effect,
						targetTf = var4_4.tf
					})
				end

				if arg0_4._callback then
					arg0_4._callback(Fushun3GameEvent.catch_item_call, {
						data = var4_4.data
					})
				end

				arg0_4:returnItemToPool(var4_4)
			end
		end

		if var2_4.data.speed then
			local var5_4 = var2_4.tf.anchoredPosition

			var5_4.x = var5_4.x + var2_4.data.speed * Time.deltaTime
			var2_4.tf.anchoredPosition = var5_4
		end

		if var2_4.data.type == Fushun3GameConst.item_type_damage then
			table.insert(var1_4, var2_4)
		end
	end

	for iter1_4 = #var1_4, 1, -1 do
		local var6_4 = var1_4[iter1_4]

		arg0_4._event:emit(Fushun3GameEvent.check_item_damage, {
			collider = var6_4.collider,
			callback = function(arg0_5)
				if arg0_5 then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOOM)
					arg0_4._event:emit(Fushun3GameEvent.add_effect_call, {
						effectName = "EF_fr_Hit_LA",
						targetTf = findTF(var6_4.tf, "effectPos")
					})
					arg0_4:removeItem(var6_4)
				end
			end
		})
	end
end

function var0_0.removeItem(arg0_6, arg1_6)
	for iter0_6 = #arg0_6.items, 1, -1 do
		if arg1_6 == arg0_6.items[iter0_6] then
			local var0_6 = table.remove(arg0_6.items, iter0_6)

			arg0_6:returnItemToPool(var0_6)

			return
		end
	end
end

function var0_0.createPlatformItem(arg0_7, arg1_7, arg2_7)
	local var0_7
	local var1_7 = arg0_7:getWeightItemsMap()

	if var1_7 then
		var0_7 = Fushun3GameConst.item_map[var1_7]
	end

	if var0_7 then
		local var2_7 = var0_7.list
		local var3_7 = arg0_7._itemPos:InverseTransformPoint(arg1_7)
		local var4_7 = 0
		local var5_7 = 0

		for iter0_7 = #var2_7, 1, -1 do
			local var6_7 = var2_7[iter0_7]

			for iter1_7, iter2_7 in ipairs(var6_7) do
				if iter2_7 and iter2_7 > 0 then
					arg0_7:createItemById(iter2_7, Vector2(var3_7.x + var5_7, var3_7.y + var4_7))
				end

				var5_7 = var5_7 + Fushun3GameConst.item_h
			end

			var5_7 = 0
			var4_7 = var4_7 + Fushun3GameConst.item_v
		end
	end
end

function var0_0.createItemById(arg0_8, arg1_8, arg2_8)
	local var0_8

	for iter0_8 = 1, #Fushun3GameConst.item_data do
		if Fushun3GameConst.item_data[iter0_8].id == arg1_8 then
			var0_8 = Fushun3GameConst.item_data[iter0_8].name
		end
	end

	local var1_8 = arg0_8:getOrCreateItem(var0_8)

	if var1_8 then
		setActive(var1_8.tf, true)

		var1_8.tf.anchoredPosition = arg2_8

		table.insert(arg0_8.items, var1_8)
	end
end

function var0_0.createItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:getOrCreateItem(arg1_9)

	if var0_9 then
		var0_9.tf.position = arg2_9

		setActive(var0_9.tf, true)
		table.insert(arg0_9.items, var0_9)
	end
end

function var0_0.itemFollow(arg0_10, arg1_10)
	for iter0_10 = 1, #arg0_10.items do
		local var0_10 = arg0_10.items[iter0_10]

		if var0_10.data.type == Fushun3GameConst.item_type_buff or var0_10.data.type == Fushun3GameConst.item_type_score then
			local var1_10 = var0_10.tf.anchoredPosition

			if math.abs(arg1_10.x - var1_10.x) <= 600 and math.abs(arg1_10.y - var1_10.y) <= 700 then
				local var2_10 = math.sign(arg1_10.x - var1_10.x)
				local var3_10 = 2000 * Time.deltaTime * var2_10
				local var4_10 = 25 * math.sign(arg1_10.y - var1_10.y)

				if math.abs(arg1_10.y - var1_10.y) < 25 then
					var4_10 = 0
				end

				var1_10.x = var1_10.x + var3_10
				var1_10.y = var1_10.y + var4_10
				var0_10.tf.anchoredPosition = var1_10
			end
		end
	end
end

function var0_0.getOrCreateItem(arg0_11, arg1_11)
	for iter0_11 = 1, #arg0_11.itemPools do
		if arg0_11.itemPools[iter0_11].data.name == arg1_11 then
			return table.remove(arg0_11.itemPools, iter0_11)
		end
	end

	for iter1_11 = 1, #Fushun3GameConst.item_data do
		local var0_11 = Clone(Fushun3GameConst.item_data[iter1_11])

		if var0_11.name == arg1_11 then
			local var1_11 = tf(instantiate(findTF(arg0_11._itemTpls, arg1_11)))

			var1_11.localScale = Fushun3GameConst.game_scale_v3

			local var2_11 = GetComponent(findTF(var1_11, "collider"), typeof(BoxCollider2D))

			setParent(var1_11, arg0_11._itemPos)

			return {
				tf = var1_11,
				data = var0_11,
				collider = var2_11
			}
		end
	end
end

function var0_0.getWeightItemsMap(arg0_12)
	if arg0_12.itemTime > 0 then
		if math.random(1, arg0_12.itemTime) == arg0_12.itemTime then
			arg0_12.itemTime = var2_0

			if not arg0_12.itemsMap then
				arg0_12.itemsMap = {}

				for iter0_12 = 1, #arg0_12.weightItems do
					local var0_12 = arg0_12.weightItems[iter0_12]

					if table.contains(Fushun3GameConst.item_map_ids, var0_12.map) then
						table.insert(arg0_12.itemsMap, var0_12.map)
					end
				end
			end

			return arg0_12.itemsMap[math.random(1, #arg0_12.itemsMap)]
		else
			arg0_12.itemTime = arg0_12.itemTime - 1
		end
	end

	local var1_12 = math.random(1, arg0_12.weightTotal)

	for iter1_12 = 1, #arg0_12.weightItems do
		local var2_12 = arg0_12.weightItems[iter1_12]

		if var1_12 <= var2_12.weight then
			return var2_12.map
		end
	end

	return nil
end

function var0_0.removeOutItems(arg0_13)
	for iter0_13 = #arg0_13.items, 1, -1 do
		local var0_13 = arg0_13.items[iter0_13].tf
		local var1_13 = arg0_13.items[iter0_13].data

		if var0_13.anchoredPosition.x < math.abs(arg0_13._sceneTf.anchoredPosition.x) - 1500 then
			local var2_13 = table.remove(arg0_13.items, iter0_13)

			arg0_13:returnItemToPool(var2_13)
		elseif var1_13.type == Fushun3GameConst.item_type_damage and var0_13.anchoredPosition.x >= math.abs(arg0_13._sceneTf.anchoredPosition.x) + 2000 then
			local var3_13 = table.remove(arg0_13.items, iter0_13)

			arg0_13:returnItemToPool(var3_13)
		elseif var0_13.anchoredPosition.x >= math.abs(arg0_13._sceneTf.anchoredPosition.x) + 5000 then
			local var4_13 = table.remove(arg0_13.items, iter0_13)

			arg0_13:returnItemToPool(var4_13)
		end
	end
end

function var0_0.returnItemToPool(arg0_14, arg1_14)
	setActive(arg1_14.tf, false)
	table.insert(arg0_14.itemPools, arg1_14)
end

return var0_0
