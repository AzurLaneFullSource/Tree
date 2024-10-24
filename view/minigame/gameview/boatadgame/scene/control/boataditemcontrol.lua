local var0_0 = class("BoatAdItemControl")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._items = {}
	arg0_1._itemsPool = {}
	arg0_1._content = findTF(arg0_1._tf, "scene/content")
end

function var0_0.start(arg0_2)
	arg0_2:clear()

	arg0_2._rules = {}

	var1_0.SetGameItems(arg0_2._items)
end

function var0_0.step(arg0_3, arg1_3)
	local var0_3 = var1_0.gameTime

	for iter0_3 = #arg0_3._items, 1, -1 do
		local var1_3 = arg0_3._items[iter0_3]

		var1_3:step(arg1_3)

		if var1_3:getRemoveFlag() then
			table.remove(arg0_3._items, iter0_3)
			arg0_3:returnItem(var1_3)
		end
	end
end

function var0_0.dispose(arg0_4)
	return
end

function var0_0.createItem(arg0_5, arg1_5)
	local var0_5 = arg1_5.id
	local var1_5 = arg1_5.move_count
	local var2_5 = arg1_5.line
	local var3_5 = arg1_5.round
	local var4_5 = arg0_5:getOrCreateItem(var0_5)

	var4_5:start()
	var4_5:setMoveCount(var1_5, var2_5)
	table.insert(arg0_5._items, var4_5)
end

function var0_0.getOrCreateItem(arg0_6, arg1_6, arg2_6)
	local var0_6

	if #arg0_6._itemsPool > 0 then
		for iter0_6 = 1, #arg0_6._itemsPool do
			if arg0_6._itemsPool[iter0_6]:getId() == arg1_6 then
				var0_6 = table.remove(arg0_6._itemsPool, iter0_6)

				break
			end
		end
	end

	if not var0_6 then
		local var1_6 = BoatAdGameConst.game_item[arg1_6]

		if not var1_6 then
			print("不存在物品id" .. arg1_6)
		end

		local var2_6 = var1_0.GetGameTplTf(var1_6.tpl)

		var0_6 = BoatAdItem.New(var2_6, arg0_6._event)

		var0_6:setData(var1_6)
		var0_6:setContent(arg0_6._content)
	end

	var0_6:start()

	if arg2_6 then
		var0_6:setPosition(arg2_6)
	end

	return var0_6
end

function var0_0.setMoveSpeed(arg0_7, arg1_7)
	arg0_7._moveSpeed = arg1_7

	for iter0_7 = 1, #arg0_7._items do
		arg0_7._items[iter0_7]:setSpeed(arg1_7)
	end
end

function var0_0.stop(arg0_8)
	arg0_8.lastMoveSpeed = arg0_8._moveSpeed or 1

	arg0_8:setMoveSpeed(0)
end

function var0_0.resume(arg0_9)
	arg0_9:setMoveSpeed(arg0_9.lastMoveSpeed)
end

function var0_0.getMoveSpeed(arg0_10)
	return arg0_10._moveSpeed
end

function var0_0.returnItem(arg0_11, arg1_11)
	arg1_11:clear()
	table.insert(arg0_11._itemsPool, arg1_11)
end

function var0_0.clear(arg0_12)
	for iter0_12 = #arg0_12._items, 1, -1 do
		local var0_12 = table.remove(arg0_12._items, iter0_12)

		var0_12:clear()
		table.insert(arg0_12._itemsPool, var0_12)
	end

	arg0_12._rules = {}

	arg0_12:setMoveSpeed(1)
end

return var0_0
