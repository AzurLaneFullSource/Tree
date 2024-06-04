local var0 = class("Fushun3ItemController")
local var1 = 3
local var2 = 100

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._sceneTf = arg1
	arg0._charTf = arg2
	arg0._itemTpls = arg3
	arg0._event = arg4
	arg0._charCollider = GetComponent(findTF(arg0._charTf, "collider"), typeof(BoxCollider2D))
	arg0._itemPos = findTF(arg0._sceneTf, "item")
	arg0.weightTotal = 0
	arg0.weightItems = {}
	arg0.items = {}
	arg0.itemPools = {}

	for iter0 = 1, #Fushun3GameConst.item_instance_data do
		local var0 = Fushun3GameConst.item_instance_data[iter0]

		arg0.weightTotal = arg0.weightTotal + var0.weight

		local var1 = arg0.weightTotal
		local var2 = var0.id
		local var3 = var0.map
		local var4 = {
			id = var2,
			weight = var1,
			map = var3
		}

		table.insert(arg0.weightItems, var4)
	end
end

function var0.setCallback(arg0, arg1)
	arg0._callback = arg1
end

function var0.start(arg0)
	for iter0 = #arg0.items, 1, -1 do
		local var0 = table.remove(arg0.items, iter0)

		arg0:returnItemToPool(var0)
	end

	arg0.createTime = math.random(Fushun3GameConst.create_time[1], Fushun3GameConst.create_time[2])
	arg0.createPos = Vector2.zero
	arg0.itemTime = var1
end

function var0.step(arg0)
	arg0:removeOutItems()

	local var0 = arg0._charCollider.bounds
	local var1 = {}

	for iter0 = #arg0.items, 1, -1 do
		local var2 = arg0.items[iter0]

		if var2.collider and var2.data.type ~= Fushun3GameConst.item_type_damage then
			local var3 = var2.collider.bounds

			if Fushun3GameConst.CheckBoxCollider(var0.min, var3.min, var0.size, var3.size) then
				local var4 = table.remove(arg0.items, iter0)

				if var4.data.effect then
					arg0._event:emit(Fushun3GameEvent.add_effect_call, {
						effectName = var4.data.effect,
						targetTf = var4.tf
					})
				end

				if arg0._callback then
					arg0._callback(Fushun3GameEvent.catch_item_call, {
						data = var4.data
					})
				end

				arg0:returnItemToPool(var4)
			end
		end

		if var2.data.speed then
			local var5 = var2.tf.anchoredPosition

			var5.x = var5.x + var2.data.speed * Time.deltaTime
			var2.tf.anchoredPosition = var5
		end

		if var2.data.type == Fushun3GameConst.item_type_damage then
			table.insert(var1, var2)
		end
	end

	for iter1 = #var1, 1, -1 do
		local var6 = var1[iter1]

		arg0._event:emit(Fushun3GameEvent.check_item_damage, {
			collider = var6.collider,
			callback = function(arg0)
				if arg0 then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOOM)
					arg0._event:emit(Fushun3GameEvent.add_effect_call, {
						effectName = "EF_fr_Hit_LA",
						targetTf = findTF(var6.tf, "effectPos")
					})
					arg0:removeItem(var6)
				end
			end
		})
	end
end

function var0.removeItem(arg0, arg1)
	for iter0 = #arg0.items, 1, -1 do
		if arg1 == arg0.items[iter0] then
			local var0 = table.remove(arg0.items, iter0)

			arg0:returnItemToPool(var0)

			return
		end
	end
end

function var0.createPlatformItem(arg0, arg1, arg2)
	local var0
	local var1 = arg0:getWeightItemsMap()

	if var1 then
		var0 = Fushun3GameConst.item_map[var1]
	end

	if var0 then
		local var2 = var0.list
		local var3 = arg0._itemPos:InverseTransformPoint(arg1)
		local var4 = 0
		local var5 = 0

		for iter0 = #var2, 1, -1 do
			local var6 = var2[iter0]

			for iter1, iter2 in ipairs(var6) do
				if iter2 and iter2 > 0 then
					arg0:createItemById(iter2, Vector2(var3.x + var5, var3.y + var4))
				end

				var5 = var5 + Fushun3GameConst.item_h
			end

			var5 = 0
			var4 = var4 + Fushun3GameConst.item_v
		end
	end
end

function var0.createItemById(arg0, arg1, arg2)
	local var0

	for iter0 = 1, #Fushun3GameConst.item_data do
		if Fushun3GameConst.item_data[iter0].id == arg1 then
			var0 = Fushun3GameConst.item_data[iter0].name
		end
	end

	local var1 = arg0:getOrCreateItem(var0)

	if var1 then
		setActive(var1.tf, true)

		var1.tf.anchoredPosition = arg2

		table.insert(arg0.items, var1)
	end
end

function var0.createItem(arg0, arg1, arg2)
	local var0 = arg0:getOrCreateItem(arg1)

	if var0 then
		var0.tf.position = arg2

		setActive(var0.tf, true)
		table.insert(arg0.items, var0)
	end
end

function var0.itemFollow(arg0, arg1)
	for iter0 = 1, #arg0.items do
		local var0 = arg0.items[iter0]

		if var0.data.type == Fushun3GameConst.item_type_buff or var0.data.type == Fushun3GameConst.item_type_score then
			local var1 = var0.tf.anchoredPosition

			if math.abs(arg1.x - var1.x) <= 600 and math.abs(arg1.y - var1.y) <= 700 then
				local var2 = math.sign(arg1.x - var1.x)
				local var3 = 2000 * Time.deltaTime * var2
				local var4 = 25 * math.sign(arg1.y - var1.y)

				if math.abs(arg1.y - var1.y) < 25 then
					var4 = 0
				end

				var1.x = var1.x + var3
				var1.y = var1.y + var4
				var0.tf.anchoredPosition = var1
			end
		end
	end
end

function var0.getOrCreateItem(arg0, arg1)
	for iter0 = 1, #arg0.itemPools do
		if arg0.itemPools[iter0].data.name == arg1 then
			return table.remove(arg0.itemPools, iter0)
		end
	end

	for iter1 = 1, #Fushun3GameConst.item_data do
		local var0 = Clone(Fushun3GameConst.item_data[iter1])

		if var0.name == arg1 then
			local var1 = tf(instantiate(findTF(arg0._itemTpls, arg1)))

			var1.localScale = Fushun3GameConst.game_scale_v3

			local var2 = GetComponent(findTF(var1, "collider"), typeof(BoxCollider2D))

			setParent(var1, arg0._itemPos)

			return {
				tf = var1,
				data = var0,
				collider = var2
			}
		end
	end
end

function var0.getWeightItemsMap(arg0)
	if arg0.itemTime > 0 then
		if math.random(1, arg0.itemTime) == arg0.itemTime then
			arg0.itemTime = var2

			if not arg0.itemsMap then
				arg0.itemsMap = {}

				for iter0 = 1, #arg0.weightItems do
					local var0 = arg0.weightItems[iter0]

					if table.contains(Fushun3GameConst.item_map_ids, var0.map) then
						table.insert(arg0.itemsMap, var0.map)
					end
				end
			end

			return arg0.itemsMap[math.random(1, #arg0.itemsMap)]
		else
			arg0.itemTime = arg0.itemTime - 1
		end
	end

	local var1 = math.random(1, arg0.weightTotal)

	for iter1 = 1, #arg0.weightItems do
		local var2 = arg0.weightItems[iter1]

		if var1 <= var2.weight then
			return var2.map
		end
	end

	return nil
end

function var0.removeOutItems(arg0)
	for iter0 = #arg0.items, 1, -1 do
		local var0 = arg0.items[iter0].tf
		local var1 = arg0.items[iter0].data

		if var0.anchoredPosition.x < math.abs(arg0._sceneTf.anchoredPosition.x) - 1500 then
			local var2 = table.remove(arg0.items, iter0)

			arg0:returnItemToPool(var2)
		elseif var1.type == Fushun3GameConst.item_type_damage and var0.anchoredPosition.x >= math.abs(arg0._sceneTf.anchoredPosition.x) + 2000 then
			local var3 = table.remove(arg0.items, iter0)

			arg0:returnItemToPool(var3)
		elseif var0.anchoredPosition.x >= math.abs(arg0._sceneTf.anchoredPosition.x) + 5000 then
			local var4 = table.remove(arg0.items, iter0)

			arg0:returnItemToPool(var4)
		end
	end
end

function var0.returnItemToPool(arg0, arg1)
	setActive(arg1.tf, false)
	table.insert(arg0.itemPools, arg1)
end

return var0
