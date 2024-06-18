local var0_0 = class("Fushun3PlatformControll")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._tplTf = arg2_1
	arg0_1._content = arg3_1
	arg0_1._event = arg4_1
	arg0_1._platformPool = {}
	arg0_1._platforms = {}
	arg0_1._sceneTf = arg1_1
	arg0_1._weightTotal = 0
	arg0_1.createDatas = nil
end

function var0_0.start(arg0_2)
	arg0_2.moveDistance = 0
	arg0_2.fillDistance = 0
	arg0_2.level = 0

	for iter0_2 = #arg0_2._platforms, 1, -1 do
		local var0_2 = table.remove(arg0_2._platforms, iter0_2)

		setActive(var0_2.tf, false)
		table.insert(arg0_2._platformPool, var0_2)
	end

	arg0_2.createDatas = {}
	arg0_2._weightTotal = 0

	for iter1_2 = 1, #Fushun3GameConst.platform_data do
		local var1_2 = Clone(Fushun3GameConst.platform_data[iter1_2])

		arg0_2._weightTotal = arg0_2._weightTotal + var1_2.weight

		table.insert(arg0_2.createDatas, {
			config = var1_2,
			weight = arg0_2._weightTotal
		})
	end

	arg0_2.initTimes = false

	arg0_2:fillPlatform()

	arg0_2.initTimes = true
	arg0_2.timeFlag = Fushun3GameVo.GetTimeFlag()

	arg0_2:changePlatformShow(false)
end

function var0_0.updateCreateData(arg0_3)
	arg0_3.createDatas = {}
	arg0_3._weightTotal = 0

	for iter0_3 = 1, #Fushun3GameConst.platform_data do
		local var0_3 = Clone(Fushun3GameConst.platform_data[iter0_3])

		arg0_3._weightTotal = arg0_3._weightTotal + var0_3.weight + var0_3.diff * arg0_3.level

		table.insert(arg0_3.createDatas, {
			config = var0_3,
			weight = arg0_3._weightTotal
		})
	end
end

function var0_0.fillPlatform(arg0_4)
	if arg0_4.fillDistance < arg0_4.moveDistance + Fushun3GameConst.platform_distance then
		local var0_4 = arg0_4:getPlatform()

		if var0_4.high then
			setActive(findTF(var0_4.tf, "high_roof"), true)
		end

		table.insert(arg0_4._platforms, var0_4)

		var0_4.anchoredX = arg0_4.fillDistance
		var0_4.tf.anchoredPosition = Vector2(arg0_4.fillDistance, 0)

		setActive(var0_4.tf, true)

		local var1_4 = GetComponent(var0_4.tf, typeof(Animator))
		local var2_4 = Fushun3GameVo.GetTimeFlag() and "day_no_fade" or "night_no_fade"

		var1_4:SetTrigger(var2_4)

		if var0_4.monster then
			local var3_4 = findTF(var0_4.tf, "monster")

			arg0_4._event:emit(Fushun3GameEvent.create_monster_call, {
				pos = var3_4.position
			})
		end

		if var0_4.item then
			local var4_4 = findTF(var0_4.tf, "item")
			local var5_4 = 0

			arg0_4._event:emit(Fushun3GameEvent.create_platform_item_call, {
				pos = var4_4.position,
				id = var5_4
			})
		end

		arg0_4.fillDistance = arg0_4.fillDistance + var0_4.distance

		arg0_4:fillPlatform()
	end
end

function var0_0.getPlatform(arg0_5)
	local var0_5

	if arg0_5.powerNum and arg0_5.powerNum > 0 then
		arg0_5.powerNum = arg0_5.powerNum - 1

		if arg0_5.powerNum <= 15 then
			var0_5 = arg0_5:getPowerPlatform()
		else
			var0_5 = arg0_5:getRandomPlatform()
		end
	else
		var0_5 = arg0_5:getRandomPlatform()
	end

	local var1_5 = var0_5.name
	local var2_5 = var0_5.distance
	local var3_5 = var0_5.monster
	local var4_5 = var0_5.high
	local var5_5 = var0_5.item
	local var6_5 = arg0_5:getPlatformFromPool(var1_5)

	if not var6_5 then
		local var7_5 = tf(instantiate(findTF(arg0_5._tplTf, var1_5)))

		var7_5.localScale = Fushun3GameConst.game_scale_v3

		setParent(var7_5, arg0_5._content)

		var6_5 = {
			name = var1_5,
			tf = var7_5,
			distance = var2_5 * Fushun3GameConst.game_scale,
			monster = var3_5,
			high = var4_5,
			item = var5_5
		}
	end

	return var6_5
end

function var0_0.getPowerPlatform(arg0_6)
	for iter0_6 = 1, 10 do
		local var0_6 = arg0_6.initTimes and math.random(1, arg0_6._weightTotal) or 1

		for iter1_6, iter2_6 in ipairs(arg0_6.createDatas) do
			if var0_6 <= iter2_6.weight and iter2_6.config.power then
				return iter2_6.config
			end
		end
	end

	return arg0_6:getRandomPlatform()
end

function var0_0.getRandomPlatform(arg0_7)
	local var0_7 = arg0_7.initTimes and math.random(1, arg0_7._weightTotal) or 1

	for iter0_7 = 1, #arg0_7.createDatas do
		local var1_7 = arg0_7.createDatas[iter0_7]

		if var0_7 <= var1_7.weight then
			return var1_7.config
		end
	end
end

function var0_0.getPlatformFromPool(arg0_8, arg1_8)
	for iter0_8 = 1, #arg0_8._platformPool do
		if arg0_8._platformPool[iter0_8].name == arg1_8 then
			return table.remove(arg0_8._platformPool, iter0_8)
		end
	end

	return nil
end

function var0_0.removePlatform(arg0_9)
	for iter0_9 = #arg0_9._platforms, 1, -1 do
		local var0_9 = arg0_9._platforms[iter0_9]

		if var0_9.anchoredX < arg0_9.moveDistance - Fushun3GameConst.platform_remove then
			setActive(var0_9.tf, false)
			table.insert(arg0_9._platformPool, table.remove(arg0_9._platforms, iter0_9))
		end
	end
end

function var0_0.step(arg0_10)
	arg0_10.moveDistance = math.abs(arg0_10._sceneTf.anchoredPosition.x)

	arg0_10:fillPlatform()
	arg0_10:removePlatform()
end

function var0_0.levelUp(arg0_11)
	arg0_11.level = arg0_11.level + 1

	arg0_11:updateCreateData()
end

function var0_0.updateDayNight(arg0_12)
	if arg0_12.timeFlag ~= Fushun3GameVo.GetTimeFlag() then
		arg0_12.timeFlag = Fushun3GameVo.GetTimeFlag()

		arg0_12:changePlatformShow(true)
	end
end

function var0_0.changePlatformShow(arg0_13, arg1_13)
	for iter0_13 = #arg0_13._platforms, 1, -1 do
		local var0_13 = arg0_13._platforms[iter0_13].tf

		if arg1_13 then
			local var1_13 = GetComponent(var0_13, typeof(Animator))
			local var2_13 = Fushun3GameVo.GetTimeFlag() and "day" or "night"

			var1_13:SetTrigger(var2_13)
		else
			GetComponent(findTF(var0_13, "day"), typeof(CanvasGroup)).alpha = Fushun3GameVo.GetTimeFlag() and 1 or 0
			GetComponent(findTF(var0_13, "night"), typeof(CanvasGroup)).alpha = Fushun3GameVo.GetTimeFlag() and 0 or 1
		end
	end
end

function var0_0.onPlayerPower(arg0_14)
	arg0_14.powerNum = 20
end

function var0_0.dipose(arg0_15)
	return
end

return var0_0
