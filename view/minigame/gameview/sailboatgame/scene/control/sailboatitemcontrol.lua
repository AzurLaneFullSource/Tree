local var0 = class("SailBoatItemControl")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._event = arg2
	arg0._items = {}
	arg0._itemsPool = {}
	arg0._content = findTF(arg0._tf, "scene/content")
end

function var0.start(arg0)
	arg0:clear()

	arg0._rules = {}

	local var0 = var1.GetRoundData().item_rule

	for iter0 = 1, #var0 do
		local var1 = SailBoatGameConst.item_rule[var0[iter0]]

		table.insert(arg0._rules, {
			time = 0,
			data = var1
		})
	end

	var1.SetGameItems(arg0._items)
end

function var0.step(arg0, arg1)
	local var0 = var1.gameTime

	for iter0 = 1, #arg0._rules do
		local var1 = arg0._rules[iter0]
		local var2 = var1.data.create_time

		if var0 > var2[1] and var0 < var2[2] and var1.time and var1.time >= 0 then
			var1.time = var1.time - arg1

			if var1.time <= 0 then
				var1.time = math.random(var1.data.time[1], var1.data.time[2])

				arg0:applyRule(var1)
			end
		end
	end

	for iter1 = #arg0._items, 1, -1 do
		local var3 = arg0._items[iter1]

		var3:step(arg1)

		if var3:getRemoveFlag() then
			table.remove(arg0._items, iter1)
			arg0:returnItem(var3)
		end
	end

	for iter2 = #arg0._rules, 1, -1 do
		local var4 = arg0._rules[iter2].data

		if var1.gameTime <= var4.create_time[1] then
			table.remove(arg0._rules, iter2)
		end
	end
end

function var0.dispose(arg0)
	return
end

function var0.applyRule(arg0, arg1)
	local var0 = arg1.data
	local var1 = var0.items
	local var2 = var0.screen_pos_x
	local var3 = var0.screen_pos_y
	local var4 = var1[math.random(1, #var1)]
	local var5 = var1.GetRangePos(var2, var3)

	if var5 then
		local var6 = arg0:getOrCreateItem(var4, var5)

		table.insert(arg0._items, var6)
	end
end

function var0.getOrCreateItem(arg0, arg1, arg2)
	local var0

	if #arg0._itemsPool > 0 then
		for iter0 = 1, #arg0._itemsPool do
			if arg0._itemsPool[iter0]:getId() == arg1 then
				var0 = table.remove(arg0._itemsPool, 1)

				break
			end
		end
	end

	if not var0 then
		local var1 = SailBoatGameConst.game_item[arg1]
		local var2 = var1.GetGameItemTf(var1.tpl)

		var0 = SailBoatItem.New(var2, arg0._event)

		var0:setData(var1)
		var0:setContent(arg0._content)
	end

	var0:start()

	if arg2 then
		var0:setPosition(arg2)
	end

	return var0
end

function var0.returnItem(arg0, arg1)
	arg1:clear()
	table.insert(arg0._itemsPool, arg1)
end

function var0.clear(arg0)
	for iter0 = #arg0._items, 1, -1 do
		local var0 = table.remove(arg0._items, iter0)

		var0:clear()
		table.insert(arg0._itemsPool, var0)
	end

	arg0._rules = {}
end

return var0
