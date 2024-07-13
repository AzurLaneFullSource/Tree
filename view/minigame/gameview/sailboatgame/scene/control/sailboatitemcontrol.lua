local var0_0 = class("SailBoatItemControl")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._items = {}
	arg0_1._itemsPool = {}
	arg0_1._content = findTF(arg0_1._tf, "scene/content")
end

function var0_0.start(arg0_2)
	arg0_2:clear()

	arg0_2._rules = {}

	local var0_2 = var1_0.GetRoundData().item_rule

	for iter0_2 = 1, #var0_2 do
		local var1_2 = SailBoatGameConst.item_rule[var0_2[iter0_2]]

		table.insert(arg0_2._rules, {
			time = 0,
			data = var1_2
		})
	end

	var1_0.SetGameItems(arg0_2._items)
end

function var0_0.step(arg0_3, arg1_3)
	local var0_3 = var1_0.gameTime

	for iter0_3 = 1, #arg0_3._rules do
		local var1_3 = arg0_3._rules[iter0_3]
		local var2_3 = var1_3.data.create_time

		if var0_3 > var2_3[1] and var0_3 < var2_3[2] and var1_3.time and var1_3.time >= 0 then
			var1_3.time = var1_3.time - arg1_3

			if var1_3.time <= 0 then
				var1_3.time = math.random(var1_3.data.time[1], var1_3.data.time[2])

				arg0_3:applyRule(var1_3)
			end
		end
	end

	for iter1_3 = #arg0_3._items, 1, -1 do
		local var3_3 = arg0_3._items[iter1_3]

		var3_3:step(arg1_3)

		if var3_3:getRemoveFlag() then
			table.remove(arg0_3._items, iter1_3)
			arg0_3:returnItem(var3_3)
		end
	end

	for iter2_3 = #arg0_3._rules, 1, -1 do
		local var4_3 = arg0_3._rules[iter2_3].data

		if var1_0.gameTime <= var4_3.create_time[1] then
			table.remove(arg0_3._rules, iter2_3)
		end
	end
end

function var0_0.dispose(arg0_4)
	return
end

function var0_0.applyRule(arg0_5, arg1_5)
	local var0_5 = arg1_5.data
	local var1_5 = var0_5.items
	local var2_5 = var0_5.screen_pos_x
	local var3_5 = var0_5.screen_pos_y
	local var4_5 = var1_5[math.random(1, #var1_5)]
	local var5_5 = var1_0.GetRangePos(var2_5, var3_5)

	if var5_5 then
		local var6_5 = arg0_5:getOrCreateItem(var4_5, var5_5)

		table.insert(arg0_5._items, var6_5)
	end
end

function var0_0.getOrCreateItem(arg0_6, arg1_6, arg2_6)
	local var0_6

	if #arg0_6._itemsPool > 0 then
		for iter0_6 = 1, #arg0_6._itemsPool do
			if arg0_6._itemsPool[iter0_6]:getId() == arg1_6 then
				var0_6 = table.remove(arg0_6._itemsPool, 1)

				break
			end
		end
	end

	if not var0_6 then
		local var1_6 = SailBoatGameConst.game_item[arg1_6]
		local var2_6 = var1_0.GetGameItemTf(var1_6.tpl)

		var0_6 = SailBoatItem.New(var2_6, arg0_6._event)

		var0_6:setData(var1_6)
		var0_6:setContent(arg0_6._content)
	end

	var0_6:start()

	if arg2_6 then
		var0_6:setPosition(arg2_6)
	end

	return var0_6
end

function var0_0.returnItem(arg0_7, arg1_7)
	arg1_7:clear()
	table.insert(arg0_7._itemsPool, arg1_7)
end

function var0_0.clear(arg0_8)
	for iter0_8 = #arg0_8._items, 1, -1 do
		local var0_8 = table.remove(arg0_8._items, iter0_8)

		var0_8:clear()
		table.insert(arg0_8._itemsPool, var0_8)
	end

	arg0_8._rules = {}
end

return var0_0
