local var0 = class("Fushun3BgController")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._bgTpl = arg1
	arg0._fireTpl = arg2
	arg0._backSceneTf = arg4
	arg0._petalTpl = arg3
	arg0._event = arg5
	arg0._backBgBottomTf = findTF(arg0._backSceneTf, "bgBottom")
	arg0._backBgMidTf = findTF(arg0._backSceneTf, "bgMid")
	arg0._backBgTopTf = findTF(arg0._backSceneTf, "bgTop")
	arg0._backBgPetalTf = findTF(arg0._backSceneTf, "bgPetal")
	arg0.bgItems = {}
	arg0.bgsPool = {}
	arg0.bgLoops = {}

	for iter0 = 1, #Fushun3GameConst.loop_bg do
		local var0 = arg0:getBgData(Fushun3GameConst.loop_bg[iter0])

		if var0 then
			table.insert(arg0.bgLoops, {
				data = var0,
				pos = Vector2(0, 0)
			})
		end
	end

	arg0._bgAnimTf = findTF(arg0._backSceneTf, "bg/anim")
	arg0.bgAnimator = GetComponent(findTF(arg0._backSceneTf, "bg/anim"), typeof(Animator))
end

function var0.start(arg0)
	arg0:clearBg()

	arg0.fireTime = math.random() * (Fushun3GameConst.fire_time[2] - Fushun3GameConst.fire_time[1]) + Fushun3GameConst.fire_time[1]

	for iter0 = 1, #arg0.bgLoops do
		arg0.bgLoops[iter0].pos = Vector2(0, 0)
	end

	arg0.midBgPosX = 0

	arg0:createMidBg()

	arg0.topBgIds = Clone(Fushun3GameConst.top_bg)
	arg0.topBgIdx = math.random(1, #arg0.topBgIds)
	arg0.topBgPosX = 0
	arg0.petalCount = 0

	for iter1 = arg0.topBgIdx, #arg0.topBgIds do
		arg0:createTopBg(arg0.topBgIds[iter1])
	end

	arg0:changeDayNight(false)
end

function var0.step(arg0)
	if arg0.fireTime > 0 then
		arg0.fireTime = arg0.fireTime - Time.deltaTime

		if arg0.fireTime <= 0 then
			if not Fushun3GameVo.GetTimeFlag() then
				arg0:createFire()
			end

			arg0.fireTime = math.random() * (Fushun3GameConst.fire_time[2] - Fushun3GameConst.fire_time[1]) + Fushun3GameConst.fire_time[1]
		end
	end

	if Fushun3GameVo.GetTimeFlag() and arg0.petalCount < Fushun3GameConst.petal_count_max then
		arg0:createPetal()
	end

	for iter0 = 1, #arg0.bgLoops do
		local var0 = arg0._backBgBottomTf.anchoredPosition
		local var1 = arg0.bgLoops[iter0].data
		local var2 = arg0.bgLoops[iter0].pos
		local var3 = var1.bound.x * Fushun3GameConst.game_scale

		if math.abs(var0.x) + var3 * Fushun3GameConst.loop_nums >= var2.x then
			local var4 = arg0:getBgFromPool(var1.id)

			var4.tf.anchoredPosition = Vector2(var2.x, var1.pos.y)

			setActive(var4.tf, true)
			table.insert(arg0.bgItems, var4)

			var2.x = var2.x + var3
			arg0.bgLoops[iter0].pos = var2
		end
	end

	if arg0.topBgPosX < math.abs(arg0._backBgTopTf.anchoredPosition.x) + Fushun3GameConst.top_bg_inst_posX then
		local var5 = arg0.topBgIds[arg0.topBgIdx]

		arg0:createTopBg(var5)

		if arg0.topBgIdx >= #arg0.topBgIds then
			arg0.topBgIdx = 1
		else
			arg0.topBgIdx = arg0.topBgIdx + 1
		end
	end

	if arg0.midBgPosX < math.abs(arg0._backBgMidTf.anchoredPosition.x) + Fushun3GameConst.mid_bg_inst_posX then
		arg0:createMidBg()
	end

	if arg0.dayTimeCount and arg0.dayTimeCount > 0 then
		arg0.dayTimeCount = arg0.dayTimeCount - Time.deltaTime

		if arg0.dayTimeCount <= 0 then
			Fushun3GameVo.ChangeTimeType(arg0.timeTypeData.next)
			print("切换白天黑夜下一个阶段 = " .. tostring(arg0.timeTypeData.next))
			arg0:changeDayNight(true)
			arg0._event:emit(Fushun3GameEvent.day_night_change)
		end
	end

	for iter1 = 1, #arg0.bgItems do
		local var6 = arg0.bgItems[iter1]

		if var6.data.type == Fushun3GameConst.BG_TYPE_PETAL then
			local var7 = var6.tf.anchoredPosition

			var7.x = var7.x + var6.speed.x * Time.deltaTime
			var7.y = var7.y + var6.speed.y * Time.deltaTime
			var6.tf.anchoredPosition = var7

			if var7.y < Fushun3GameConst.petal_remove_y then
				var6.removeTime = 0
			end
		end
	end

	arg0:removeBg()
end

function var0.changeDayNight(arg0, arg1)
	arg0.timeTypeData = Fushun3GameVo.GetTimeTypeData()
	arg0.dayTimeCount = arg0.timeTypeData.time

	arg0:changeBg(arg1)
	arg0:changeBgItems(arg1)
end

function var0.changeBgItems(arg0, arg1)
	if arg1 and arg0.currentItemTimeFlag == Fushun3GameVo.GetTimeFlag() then
		return
	end

	arg0.currentItemTimeFlag = Fushun3GameVo.GetTimeFlag()

	for iter0 = 1, #arg0.bgItems do
		local var0 = arg0.bgItems[iter0].tf
		local var1 = arg0.bgItems[iter0].data

		if var1.type == Fushun3GameConst.BG_TYPE_FIRE then
			if arg0.bgItems[iter0].removeTime and arg0.currentItemTimeFlag then
				arg0.bgItems[iter0].removeTime = 0
			end
		elseif var1.type == Fushun3GameConst.BG_TYPE_PETAL then
			if arg0.bgItems[iter0].removeTime and not arg0.currentItemTimeFlag then
				arg0.bgItems[iter0].removeTime = 0
			end
		else
			local var2 = GetComponent(var0, typeof(Animator))

			if arg1 then
				local var3 = arg0.currentItemTimeFlag and findTF(var0, "day") or findTF(var0, "night")

				setActive(var3, false)
				setActive(var3, true)

				local var4 = Fushun3GameVo.GetTimeFlag() and "day" or "night"

				var2:SetTrigger(var4)
			else
				local var5 = Fushun3GameVo.GetTimeFlag() and "day_no_fade" or "night_no_fade"

				var2:SetTrigger(var5)
			end
		end
	end
end

function var0.changeBg(arg0, arg1)
	if arg1 then
		arg0.bgAnimator:SetTrigger(arg0.timeTypeData.change_anim)
	else
		setActive(arg0._bgAnimTf, false)
		setActive(arg0._bgAnimTf, true)

		local var0 = arg0._bgAnimTf.childCount

		for iter0 = 0, var0 - 1 do
			local var1 = arg0._bgAnimTf:GetChild(iter0)

			setActive(var1, var1.name == arg0.timeTypeData.tf)
		end

		arg0.bgAnimator:SetTrigger(arg0.timeTypeData.anim)
	end

	print("当前状态" .. tostring(arg0.timeTypeData.name))
end

function var0.createTopBg(arg0, arg1)
	local var0 = arg0:getBgData(arg1)

	if var0 then
		local var1 = arg0:getBgFromPool(var0.id)

		var1.tf.anchoredPosition = Vector2(arg0.topBgPosX, var1.data.pos.y)
		arg0.topBgPosX = arg0.topBgPosX + var1.data.bound.x * Fushun3GameConst.game_scale

		setActive(var1.tf, true)
		table.insert(arg0.bgItems, var1)
	end
end

function var0.createMidBg(arg0)
	local var0 = 0

	for iter0 = 1, #Fushun3GameConst.mid_bg do
		local var1 = Fushun3GameConst.mid_bg[iter0]
		local var2 = var1.num
		local var3 = var1.mid_random
		local var4 = Clone(var1.ids)

		for iter1 = 1, var2 do
			local var5 = table.remove(var4, math.random(1, #var4))
			local var6 = arg0:getBgFromPool(var5)

			if var6 then
				if var3 then
					var6.tf.anchoredPosition = Vector2(math.random(900, 1000) + arg0.midBgPosX, var6.data.pos.y)
				else
					var6.tf.anchoredPosition = Vector2(var0 + arg0.midBgPosX, var6.data.pos.y)
					var0 = var0 + var6.data.bound.x * Fushun3GameConst.game_scale
				end

				setActive(var6.tf, true)
				table.insert(arg0.bgItems, var6)
			end
		end
	end

	arg0.midBgPosX = arg0.midBgPosX + Fushun3GameConst.mid_bg_inst_posX
end

function var0.createPetal(arg0)
	local var0 = Fushun3GameConst.petal_ids[math.random(1, #Fushun3GameConst.petal_ids)]
	local var1 = Vector2(math.random(100, 1920), math.random(540, 1080))
	local var2 = arg0:getBgFromPool(var0)

	if var2 then
		var1.x = var1.x + math.abs(var2.parentTf.anchoredPosition.x)
		var1.y = var1.y
		var2.tf.anchoredPosition = var1
		var2.removeTime = math.random(Fushun3GameConst.peta_remove_time[1], Fushun3GameConst.peta_remove_time[2])
		var1.x = var1.x + var2.data.bound.x
		var2.speed = Vector2(Fushun3GameConst.petal_speed[1] + math.random(1, Fushun3GameConst.petal_speed_offset), Fushun3GameConst.petal_speed[2] + math.random(1, Fushun3GameConst.petal_speed_offset))

		setActive(var2.tf, true)
		table.insert(arg0.bgItems, var2)

		arg0.petalCount = arg0.petalCount + 1
	end
end

function var0.createFire(arg0)
	local var0 = Fushun3GameConst.fire_group[math.random(1, #Fushun3GameConst.fire_group)]
	local var1 = Vector2(math.random(100, 1920), 0)

	for iter0 = 1, #var0 do
		local var2 = var0[iter0]
		local var3 = arg0:getBgFromPool(var2)

		if var3 then
			var1.x = var1.x + math.abs(var3.parentTf.anchoredPosition.x)
			var1.y = var3.data.pos.y
			var3.tf.anchoredPosition = var1
			var3.removeTime = Fushun3GameConst.fire_remove
			var1.x = var1.x + var3.data.bound.x

			setActive(var3.tf, true)
			table.insert(arg0.bgItems, var3)
		end
	end
end

function var0.getBgData(arg0, arg1)
	for iter0 = 1, #Fushun3GameConst.bg_data do
		if Fushun3GameConst.bg_data[iter0].id == arg1 then
			return Fushun3GameConst.bg_data[iter0]
		end
	end
end

function var0.getBgFromPool(arg0, arg1)
	for iter0 = 1, #arg0.bgsPool do
		if arg0.bgsPool[iter0].data.id == arg1 then
			return table.remove(arg0.bgsPool, iter0)
		end
	end

	local var0

	for iter1 = 1, #Fushun3GameConst.bg_data do
		local var1 = Fushun3GameConst.bg_data[iter1]

		if var1.id == arg1 then
			var0 = var1
		end
	end

	if var0 then
		local var2
		local var3

		if var0.type == Fushun3GameConst.BG_TYPE_FIRE then
			var2 = tf(instantiate(findTF(arg0._fireTpl, var0.name)))
			var3 = findTF(arg0._backSceneTf, "bgFire")
		elseif var0.type == Fushun3GameConst.BG_TYPE_TOP then
			var2 = tf(instantiate(findTF(arg0._bgTpl, var0.name)))
			var3 = findTF(arg0._backSceneTf, "bgTop")
		elseif var0.type == Fushun3GameConst.BG_TYPE_MID then
			var2 = tf(instantiate(findTF(arg0._bgTpl, var0.name)))
			var3 = findTF(arg0._backSceneTf, "bgMid")
		elseif var0.type == Fushun3GameConst.BG_TYPE_LOOP then
			var2 = tf(instantiate(findTF(arg0._bgTpl, var0.name)))
			var3 = findTF(arg0._backSceneTf, "bgBottom")
		elseif var0.type == Fushun3GameConst.BG_TYPE_PETAL then
			var2 = tf(instantiate(findTF(arg0._petalTpl, var0.name)))
			var3 = findTF(arg0._backSceneTf, "bgPetal")
		end

		if var2 and var3 then
			SetParent(var2, var3)
		end

		return {
			tf = var2,
			data = var0,
			parentTf = var3
		}
	end

	return nil
end

function var0.clearBg(arg0)
	for iter0 = #arg0.bgItems, 1, -1 do
		setActive(arg0.bgItems[iter0].tf, false)
		table.insert(arg0.bgsPool, table.remove(arg0.bgItems, iter0))
	end
end

function var0.removeBg(arg0)
	local var0 = {}

	for iter0 = #arg0.bgItems, 1, -1 do
		local var1 = arg0.bgItems[iter0]

		if var0[var1.parentTf] == nil then
			var0[var1.parentTf] = math.abs(var1.parentTf.anchoredPosition.x) + Fushun3GameConst.bg_remove_posX - var1.data.bound.x * Fushun3GameConst.game_scale
		end

		if var1.removeTime and var1.removeTime > 0 then
			var1.removeTime = var1.removeTime - Time.deltaTime
		end

		if var1.tf.anchoredPosition.x <= var0[var1.parentTf] then
			setActive(var1.tf, false)
			table.insert(arg0.bgsPool, table.remove(arg0.bgItems, iter0))
		elseif var1.removeTime and var1.removeTime <= 0 then
			if var1.data.type == Fushun3GameConst.BG_TYPE_PETAL then
				arg0.petalCount = arg0.petalCount - 1
			end

			setActive(var1.tf, false)
			table.insert(arg0.bgsPool, table.remove(arg0.bgItems, iter0))
		end
	end
end

return var0
