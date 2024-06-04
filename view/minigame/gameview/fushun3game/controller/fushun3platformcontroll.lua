local var0 = class("Fushun3PlatformControll")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._tplTf = arg2
	arg0._content = arg3
	arg0._event = arg4
	arg0._platformPool = {}
	arg0._platforms = {}
	arg0._sceneTf = arg1
	arg0._weightTotal = 0
	arg0.createDatas = nil
end

function var0.start(arg0)
	arg0.moveDistance = 0
	arg0.fillDistance = 0
	arg0.level = 0

	for iter0 = #arg0._platforms, 1, -1 do
		local var0 = table.remove(arg0._platforms, iter0)

		setActive(var0.tf, false)
		table.insert(arg0._platformPool, var0)
	end

	arg0.createDatas = {}
	arg0._weightTotal = 0

	for iter1 = 1, #Fushun3GameConst.platform_data do
		local var1 = Clone(Fushun3GameConst.platform_data[iter1])

		arg0._weightTotal = arg0._weightTotal + var1.weight

		table.insert(arg0.createDatas, {
			config = var1,
			weight = arg0._weightTotal
		})
	end

	arg0.initTimes = false

	arg0:fillPlatform()

	arg0.initTimes = true
	arg0.timeFlag = Fushun3GameVo.GetTimeFlag()

	arg0:changePlatformShow(false)
end

function var0.updateCreateData(arg0)
	arg0.createDatas = {}
	arg0._weightTotal = 0

	for iter0 = 1, #Fushun3GameConst.platform_data do
		local var0 = Clone(Fushun3GameConst.platform_data[iter0])

		arg0._weightTotal = arg0._weightTotal + var0.weight + var0.diff * arg0.level

		table.insert(arg0.createDatas, {
			config = var0,
			weight = arg0._weightTotal
		})
	end
end

function var0.fillPlatform(arg0)
	if arg0.fillDistance < arg0.moveDistance + Fushun3GameConst.platform_distance then
		local var0 = arg0:getPlatform()

		if var0.high then
			setActive(findTF(var0.tf, "high_roof"), true)
		end

		table.insert(arg0._platforms, var0)

		var0.anchoredX = arg0.fillDistance
		var0.tf.anchoredPosition = Vector2(arg0.fillDistance, 0)

		setActive(var0.tf, true)

		local var1 = GetComponent(var0.tf, typeof(Animator))
		local var2 = Fushun3GameVo.GetTimeFlag() and "day_no_fade" or "night_no_fade"

		var1:SetTrigger(var2)

		if var0.monster then
			local var3 = findTF(var0.tf, "monster")

			arg0._event:emit(Fushun3GameEvent.create_monster_call, {
				pos = var3.position
			})
		end

		if var0.item then
			local var4 = findTF(var0.tf, "item")
			local var5 = 0

			arg0._event:emit(Fushun3GameEvent.create_platform_item_call, {
				pos = var4.position,
				id = var5
			})
		end

		arg0.fillDistance = arg0.fillDistance + var0.distance

		arg0:fillPlatform()
	end
end

function var0.getPlatform(arg0)
	local var0

	if arg0.powerNum and arg0.powerNum > 0 then
		arg0.powerNum = arg0.powerNum - 1

		if arg0.powerNum <= 15 then
			var0 = arg0:getPowerPlatform()
		else
			var0 = arg0:getRandomPlatform()
		end
	else
		var0 = arg0:getRandomPlatform()
	end

	local var1 = var0.name
	local var2 = var0.distance
	local var3 = var0.monster
	local var4 = var0.high
	local var5 = var0.item
	local var6 = arg0:getPlatformFromPool(var1)

	if not var6 then
		local var7 = tf(instantiate(findTF(arg0._tplTf, var1)))

		var7.localScale = Fushun3GameConst.game_scale_v3

		setParent(var7, arg0._content)

		var6 = {
			name = var1,
			tf = var7,
			distance = var2 * Fushun3GameConst.game_scale,
			monster = var3,
			high = var4,
			item = var5
		}
	end

	return var6
end

function var0.getPowerPlatform(arg0)
	for iter0 = 1, 10 do
		local var0 = arg0.initTimes and math.random(1, arg0._weightTotal) or 1

		for iter1, iter2 in ipairs(arg0.createDatas) do
			if var0 <= iter2.weight and iter2.config.power then
				return iter2.config
			end
		end
	end

	return arg0:getRandomPlatform()
end

function var0.getRandomPlatform(arg0)
	local var0 = arg0.initTimes and math.random(1, arg0._weightTotal) or 1

	for iter0 = 1, #arg0.createDatas do
		local var1 = arg0.createDatas[iter0]

		if var0 <= var1.weight then
			return var1.config
		end
	end
end

function var0.getPlatformFromPool(arg0, arg1)
	for iter0 = 1, #arg0._platformPool do
		if arg0._platformPool[iter0].name == arg1 then
			return table.remove(arg0._platformPool, iter0)
		end
	end

	return nil
end

function var0.removePlatform(arg0)
	for iter0 = #arg0._platforms, 1, -1 do
		local var0 = arg0._platforms[iter0]

		if var0.anchoredX < arg0.moveDistance - Fushun3GameConst.platform_remove then
			setActive(var0.tf, false)
			table.insert(arg0._platformPool, table.remove(arg0._platforms, iter0))
		end
	end
end

function var0.step(arg0)
	arg0.moveDistance = math.abs(arg0._sceneTf.anchoredPosition.x)

	arg0:fillPlatform()
	arg0:removePlatform()
end

function var0.levelUp(arg0)
	arg0.level = arg0.level + 1

	arg0:updateCreateData()
end

function var0.updateDayNight(arg0)
	if arg0.timeFlag ~= Fushun3GameVo.GetTimeFlag() then
		arg0.timeFlag = Fushun3GameVo.GetTimeFlag()

		arg0:changePlatformShow(true)
	end
end

function var0.changePlatformShow(arg0, arg1)
	for iter0 = #arg0._platforms, 1, -1 do
		local var0 = arg0._platforms[iter0].tf

		if arg1 then
			local var1 = GetComponent(var0, typeof(Animator))
			local var2 = Fushun3GameVo.GetTimeFlag() and "day" or "night"

			var1:SetTrigger(var2)
		else
			GetComponent(findTF(var0, "day"), typeof(CanvasGroup)).alpha = Fushun3GameVo.GetTimeFlag() and 1 or 0
			GetComponent(findTF(var0, "night"), typeof(CanvasGroup)).alpha = Fushun3GameVo.GetTimeFlag() and 0 or 1
		end
	end
end

function var0.onPlayerPower(arg0)
	arg0.powerNum = 20
end

function var0.dipose(arg0)
	return
end

return var0
