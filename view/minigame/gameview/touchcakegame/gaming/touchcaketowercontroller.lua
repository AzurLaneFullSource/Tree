local var0_0 = class("TouchCakeTowerController")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = TouchCakeGameVo
	arg0_1._content = arg1_1
	arg0_1._event = arg2_1
	arg0_1._cakeContainer = findTF(arg0_1._content, "container")
	arg0_1.cakeItems = {}

	for iter0_1 = 1, TouchCakeGameConst.max_cake_count do
		local var0_1 = var1_0.GetTplItemFromPool("CakeTpl", arg0_1._cakeContainer)
		local var1_1 = TouchCakeItem.New(var0_1, arg0_1._event)

		table.insert(arg0_1.cakeItems, var1_1)
	end

	arg0_1._cakeContainerPool = findTF(arg0_1._content, "containerPool")
	arg0_1.cakeItemPool = {}
end

function var0_0.start(arg0_2)
	arg0_2.touchAble = true
	arg0_2._moveBottomCallback = nil
	arg0_2._cakeBottomPos = Vector2(TouchCakeGameConst.cake_init_pos[1], TouchCakeGameConst.cake_init_pos[2])
	arg0_2._cakeContainer.anchoredPosition = arg0_2._cakeBottomPos
	arg0_2._cakeTargetHeight = arg0_2._cakeBottomPos.y
	arg0_2._cakeDownHeight = 0
	arg0_2.removeTimeTick = nil
	arg0_2.removeTimeTickCallback = nil

	for iter0_2 = #arg0_2.cakeItemPool, 1, -1 do
		local var0_2 = arg0_2:getItemFromPool()

		if var0_2 then
			table.insert(arg0_2.cakeItems, var0_2)
		end
	end

	arg0_2.weightTotal = nil

	arg0_2:randomCakeData()
	arg0_2:updateCakePos()
end

function var0_0.step(arg0_3)
	if arg0_3.removeTimeTick and arg0_3.removeTimeTick >= 0 then
		arg0_3.removeTimeTick = arg0_3.removeTimeTick - var1_0.deltaTime

		if arg0_3.removeTimeTick <= 0 then
			arg0_3.removeTimeTick = nil

			if arg0_3.removeTimeTickCallback then
				arg0_3.removeTimeTickCallback()
			end
		end
	end

	if arg0_3._cakeBottomPos.y ~= arg0_3._cakeTargetHeight then
		local var0_3 = math.sign(arg0_3._cakeBottomPos.y - arg0_3._cakeTargetHeight)
		local var1_3 = TouchCakeGameConst.cake_down_speed * var1_0.deltaTime * math.sign(arg0_3._cakeBottomPos.y - arg0_3._cakeTargetHeight)

		arg0_3._cakeBottomPos.y = arg0_3._cakeBottomPos.y - var1_3

		if math.sign(arg0_3._cakeBottomPos.y - arg0_3._cakeTargetHeight) ~= var0_3 then
			arg0_3._cakeBottomPos.y = arg0_3._cakeTargetHeight
		end

		arg0_3._cakeContainer.anchoredPosition = arg0_3._cakeBottomPos
	end

	if arg0_3._moveBottomCallback and arg0_3._cakeBottomPos.y == arg0_3._cakeTargetHeight then
		arg0_3._moveBottomCallback()

		arg0_3._moveBottomCallback = nil
	end
end

function var0_0.randomCakeData(arg0_4)
	for iter0_4 = 1, #arg0_4.cakeItems do
		local var0_4 = arg0_4.cakeItems[iter0_4]
		local var1_4 = arg0_4:getRandCakeData()
		local var2_4
		local var3_4

		if iter0_4 ~= 1 then
			var2_4, var3_4 = arg0_4:getRandPropDataByRate()
		end

		var0_4:setData(var1_4, var2_4, var3_4)
	end
end

function var0_0.getRandCakeData(arg0_5)
	return Clone(TouchCakeGameConst.cake_data[TouchCakeGameConst.cake_data.all[math.random(1, #TouchCakeGameConst.cake_data.all)]])
end

function var0_0.getItemFromPool(arg0_6)
	if #arg0_6.cakeItemPool > 0 then
		local var0_6 = table.remove(arg0_6.cakeItemPool, 1)

		var0_6:setParent(arg0_6._cakeContainer)
		print("从pool中拿取item, pool长度 =" .. #arg0_6.cakeItemPool)

		return var0_6
	end

	return nil
end

function var0_0.addItemPool(arg0_7, arg1_7)
	table.insert(arg0_7.cakeItemPool, arg1_7)
	arg1_7:setParent(arg0_7._cakeContainerPool)
	print("item放入pool  pool长度 =" .. #arg0_7.cakeItemPool)
end

function var0_0.getRandPropDataByRate(arg0_8)
	if not arg0_8.weightTotal then
		arg0_8.weightTotal = 0
		arg0_8.weightData = {}

		for iter0_8, iter1_8 in ipairs(TouchCakeGameConst.prop_rate) do
			arg0_8.weightTotal = arg0_8.weightTotal + iter1_8.weight

			local var0_8 = 100000000

			if TouchCakeGameConst.prop_times and TouchCakeGameConst.prop_times[iter1_8.id] then
				var0_8 = TouchCakeGameConst.prop_times[iter1_8.id].times
			end

			table.insert(arg0_8.weightData, {
				weight = arg0_8.weightTotal,
				id = iter1_8.id,
				times = var0_8
			})
		end
	end

	if not arg0_8.propDirectPool or #arg0_8.propDirectPool == 0 then
		arg0_8.propDirectPool = Clone(TouchCakeGameConst.prop_random_direct[math.random(1, #TouchCakeGameConst.prop_random_direct)])
	end

	local var1_8 = table.remove(arg0_8.propDirectPool, 1)

	if var1_8 == 0 then
		return nil
	end

	local var2_8 = math.random(1, arg0_8.weightTotal)
	local var3_8

	for iter2_8, iter3_8 in ipairs(arg0_8.weightData) do
		if not var3_8 and var2_8 <= iter3_8.weight then
			if iter3_8.times < 1000 then
				iter3_8.times = iter3_8.times - 1
			end

			if iter3_8.times < 0 then
				print("道具id " .. iter3_8.id .. "次数用尽")

				break
			end

			var3_8 = iter3_8.id

			break
		end
	end

	if var3_8 and var3_8 ~= 0 then
		return Clone(TouchCakeGameConst.prop_data[var3_8]), var1_8
	end

	return nil
end

function var0_0.updateCakePos(arg0_9)
	local var0_9 = Vector2(0, 0)

	for iter0_9 = 1, #arg0_9.cakeItems do
		local var1_9 = arg0_9.cakeItems[iter0_9]

		var1_9:setPosition(var0_9)

		var0_9 = var1_9:getTopPos()
	end

	for iter1_9 = 1, #arg0_9.cakeItems do
		arg0_9.cakeItems[iter1_9]:setLayerFirst()
	end
end

function var0_0.touchBottomCake(arg0_10, arg1_10, arg2_10)
	if not arg0_10:getTouchAble() then
		return
	end

	arg0_10.touchAble = false

	seriesAsync({
		function(arg0_11)
			arg0_10:removeBottomCake(arg1_10, arg0_11)

			arg0_10.removeTimeTick = TouchCakeGameConst.remove_time
			arg0_10.removeTimeTickCallback = arg0_11
		end,
		function(arg0_12)
			arg0_10:activeCakeProp(arg0_12)
		end,
		function(arg0_13)
			arg0_10:moveCakeToBottom(arg0_13)
		end
	}, function()
		arg0_10.touchAble = true
	end)
end

function var0_0.getTouchAble(arg0_15)
	return arg0_15.touchAble
end

function var0_0.removeBottomCake(arg0_16, arg1_16, arg2_16)
	local var0_16 = table.remove(arg0_16.cakeItems, 1)

	arg0_16:addItemPool(var0_16)
	var0_16:touchAction(arg1_16, function()
		arg0_16:addCakeToTop()
	end)

	arg0_16._cakeDownHeight = arg0_16._cakeDownHeight - var0_16:getCakeConfig("height")
end

function var0_0.moveCakeToBottom(arg0_18, arg1_18)
	arg0_18._cakeTargetHeight = arg0_18._cakeDownHeight
	arg0_18._moveBottomCallback = arg1_18
end

function var0_0.addCakeToTop(arg0_19)
	local var0_19 = arg0_19:getItemFromPool()

	if var0_19 then
		local var1_19 = arg0_19.cakeItems[#arg0_19.cakeItems]
		local var2_19 = var1_19:getTopPos()
		local var3_19 = var1_19:getPropDirect()

		var0_19:setPosition(var2_19)

		local var4_19, var5_19 = arg0_19:getRandPropDataByRate()

		var0_19:setData(arg0_19:getRandCakeData(), var4_19, var5_19)
		table.insert(arg0_19.cakeItems, var0_19)

		for iter0_19 = 1, #arg0_19.cakeItems do
			arg0_19.cakeItems[iter0_19]:setLayerFirst()
		end
	end
end

function var0_0.activeCakeProp(arg0_20, arg1_20)
	local var0_20 = arg0_20.cakeItems[1]:propAction()

	if arg1_20 then
		arg1_20()
	end
end

function var0_0.onKeyCode(arg0_21)
	return
end

function var0_0.stop(arg0_22)
	for iter0_22 = 1, #arg0_22.cakeItems do
		arg0_22.cakeItems[iter0_22]:stop()
	end

	for iter1_22 = 1, #arg0_22.cakeItemPool do
		arg0_22.cakeItemPool[iter1_22]:stop()
	end
end

function var0_0.resume(arg0_23)
	for iter0_23 = 1, #arg0_23.cakeItems do
		arg0_23.cakeItems[iter0_23]:resume()
	end

	for iter1_23 = 1, #arg0_23.cakeItemPool do
		arg0_23.cakeItemPool[iter1_23]:resume()
	end
end

function var0_0.clear(arg0_24)
	return
end

function var0_0.dispose(arg0_25)
	return
end

return var0_0
