local var0_0 = class("Fushun3BgController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1._bgTpl = arg1_1
	arg0_1._fireTpl = arg2_1
	arg0_1._backSceneTf = arg4_1
	arg0_1._petalTpl = arg3_1
	arg0_1._event = arg5_1
	arg0_1._backBgBottomTf = findTF(arg0_1._backSceneTf, "bgBottom")
	arg0_1._backBgMidTf = findTF(arg0_1._backSceneTf, "bgMid")
	arg0_1._backBgTopTf = findTF(arg0_1._backSceneTf, "bgTop")
	arg0_1._backBgPetalTf = findTF(arg0_1._backSceneTf, "bgPetal")
	arg0_1.bgItems = {}
	arg0_1.bgsPool = {}
	arg0_1.bgLoops = {}

	for iter0_1 = 1, #Fushun3GameConst.loop_bg do
		local var0_1 = arg0_1:getBgData(Fushun3GameConst.loop_bg[iter0_1])

		if var0_1 then
			table.insert(arg0_1.bgLoops, {
				data = var0_1,
				pos = Vector2(0, 0)
			})
		end
	end

	arg0_1._bgAnimTf = findTF(arg0_1._backSceneTf, "bg/anim")
	arg0_1.bgAnimator = GetComponent(findTF(arg0_1._backSceneTf, "bg/anim"), typeof(Animator))
end

function var0_0.start(arg0_2)
	arg0_2:clearBg()

	arg0_2.fireTime = math.random() * (Fushun3GameConst.fire_time[2] - Fushun3GameConst.fire_time[1]) + Fushun3GameConst.fire_time[1]

	for iter0_2 = 1, #arg0_2.bgLoops do
		arg0_2.bgLoops[iter0_2].pos = Vector2(0, 0)
	end

	arg0_2.midBgPosX = 0

	arg0_2:createMidBg()

	arg0_2.topBgIds = Clone(Fushun3GameConst.top_bg)
	arg0_2.topBgIdx = math.random(1, #arg0_2.topBgIds)
	arg0_2.topBgPosX = 0
	arg0_2.petalCount = 0

	for iter1_2 = arg0_2.topBgIdx, #arg0_2.topBgIds do
		arg0_2:createTopBg(arg0_2.topBgIds[iter1_2])
	end

	arg0_2:changeDayNight(false)
end

function var0_0.step(arg0_3)
	if arg0_3.fireTime > 0 then
		arg0_3.fireTime = arg0_3.fireTime - Time.deltaTime

		if arg0_3.fireTime <= 0 then
			if not Fushun3GameVo.GetTimeFlag() then
				arg0_3:createFire()
			end

			arg0_3.fireTime = math.random() * (Fushun3GameConst.fire_time[2] - Fushun3GameConst.fire_time[1]) + Fushun3GameConst.fire_time[1]
		end
	end

	if Fushun3GameVo.GetTimeFlag() and arg0_3.petalCount < Fushun3GameConst.petal_count_max then
		arg0_3:createPetal()
	end

	for iter0_3 = 1, #arg0_3.bgLoops do
		local var0_3 = arg0_3._backBgBottomTf.anchoredPosition
		local var1_3 = arg0_3.bgLoops[iter0_3].data
		local var2_3 = arg0_3.bgLoops[iter0_3].pos
		local var3_3 = var1_3.bound.x * Fushun3GameConst.game_scale

		if math.abs(var0_3.x) + var3_3 * Fushun3GameConst.loop_nums >= var2_3.x then
			local var4_3 = arg0_3:getBgFromPool(var1_3.id)

			var4_3.tf.anchoredPosition = Vector2(var2_3.x, var1_3.pos.y)

			setActive(var4_3.tf, true)
			table.insert(arg0_3.bgItems, var4_3)

			var2_3.x = var2_3.x + var3_3
			arg0_3.bgLoops[iter0_3].pos = var2_3
		end
	end

	if arg0_3.topBgPosX < math.abs(arg0_3._backBgTopTf.anchoredPosition.x) + Fushun3GameConst.top_bg_inst_posX then
		local var5_3 = arg0_3.topBgIds[arg0_3.topBgIdx]

		arg0_3:createTopBg(var5_3)

		if arg0_3.topBgIdx >= #arg0_3.topBgIds then
			arg0_3.topBgIdx = 1
		else
			arg0_3.topBgIdx = arg0_3.topBgIdx + 1
		end
	end

	if arg0_3.midBgPosX < math.abs(arg0_3._backBgMidTf.anchoredPosition.x) + Fushun3GameConst.mid_bg_inst_posX then
		arg0_3:createMidBg()
	end

	if arg0_3.dayTimeCount and arg0_3.dayTimeCount > 0 then
		arg0_3.dayTimeCount = arg0_3.dayTimeCount - Time.deltaTime

		if arg0_3.dayTimeCount <= 0 then
			Fushun3GameVo.ChangeTimeType(arg0_3.timeTypeData.next)
			print("切换白天黑夜下一个阶段 = " .. tostring(arg0_3.timeTypeData.next))
			arg0_3:changeDayNight(true)
			arg0_3._event:emit(Fushun3GameEvent.day_night_change)
		end
	end

	for iter1_3 = 1, #arg0_3.bgItems do
		local var6_3 = arg0_3.bgItems[iter1_3]

		if var6_3.data.type == Fushun3GameConst.BG_TYPE_PETAL then
			local var7_3 = var6_3.tf.anchoredPosition

			var7_3.x = var7_3.x + var6_3.speed.x * Time.deltaTime
			var7_3.y = var7_3.y + var6_3.speed.y * Time.deltaTime
			var6_3.tf.anchoredPosition = var7_3

			if var7_3.y < Fushun3GameConst.petal_remove_y then
				var6_3.removeTime = 0
			end
		end
	end

	arg0_3:removeBg()
end

function var0_0.changeDayNight(arg0_4, arg1_4)
	arg0_4.timeTypeData = Fushun3GameVo.GetTimeTypeData()
	arg0_4.dayTimeCount = arg0_4.timeTypeData.time

	arg0_4:changeBg(arg1_4)
	arg0_4:changeBgItems(arg1_4)
end

function var0_0.changeBgItems(arg0_5, arg1_5)
	if arg1_5 and arg0_5.currentItemTimeFlag == Fushun3GameVo.GetTimeFlag() then
		return
	end

	arg0_5.currentItemTimeFlag = Fushun3GameVo.GetTimeFlag()

	for iter0_5 = 1, #arg0_5.bgItems do
		local var0_5 = arg0_5.bgItems[iter0_5].tf
		local var1_5 = arg0_5.bgItems[iter0_5].data

		if var1_5.type == Fushun3GameConst.BG_TYPE_FIRE then
			if arg0_5.bgItems[iter0_5].removeTime and arg0_5.currentItemTimeFlag then
				arg0_5.bgItems[iter0_5].removeTime = 0
			end
		elseif var1_5.type == Fushun3GameConst.BG_TYPE_PETAL then
			if arg0_5.bgItems[iter0_5].removeTime and not arg0_5.currentItemTimeFlag then
				arg0_5.bgItems[iter0_5].removeTime = 0
			end
		else
			local var2_5 = GetComponent(var0_5, typeof(Animator))

			if arg1_5 then
				local var3_5 = arg0_5.currentItemTimeFlag and findTF(var0_5, "day") or findTF(var0_5, "night")

				setActive(var3_5, false)
				setActive(var3_5, true)

				local var4_5 = Fushun3GameVo.GetTimeFlag() and "day" or "night"

				var2_5:SetTrigger(var4_5)
			else
				local var5_5 = Fushun3GameVo.GetTimeFlag() and "day_no_fade" or "night_no_fade"

				var2_5:SetTrigger(var5_5)
			end
		end
	end
end

function var0_0.changeBg(arg0_6, arg1_6)
	if arg1_6 then
		arg0_6.bgAnimator:SetTrigger(arg0_6.timeTypeData.change_anim)
	else
		setActive(arg0_6._bgAnimTf, false)
		setActive(arg0_6._bgAnimTf, true)

		local var0_6 = arg0_6._bgAnimTf.childCount

		for iter0_6 = 0, var0_6 - 1 do
			local var1_6 = arg0_6._bgAnimTf:GetChild(iter0_6)

			setActive(var1_6, var1_6.name == arg0_6.timeTypeData.tf)
		end

		arg0_6.bgAnimator:SetTrigger(arg0_6.timeTypeData.anim)
	end

	print("当前状态" .. tostring(arg0_6.timeTypeData.name))
end

function var0_0.createTopBg(arg0_7, arg1_7)
	local var0_7 = arg0_7:getBgData(arg1_7)

	if var0_7 then
		local var1_7 = arg0_7:getBgFromPool(var0_7.id)

		var1_7.tf.anchoredPosition = Vector2(arg0_7.topBgPosX, var1_7.data.pos.y)
		arg0_7.topBgPosX = arg0_7.topBgPosX + var1_7.data.bound.x * Fushun3GameConst.game_scale

		setActive(var1_7.tf, true)
		table.insert(arg0_7.bgItems, var1_7)
	end
end

function var0_0.createMidBg(arg0_8)
	local var0_8 = 0

	for iter0_8 = 1, #Fushun3GameConst.mid_bg do
		local var1_8 = Fushun3GameConst.mid_bg[iter0_8]
		local var2_8 = var1_8.num
		local var3_8 = var1_8.mid_random
		local var4_8 = Clone(var1_8.ids)

		for iter1_8 = 1, var2_8 do
			local var5_8 = table.remove(var4_8, math.random(1, #var4_8))
			local var6_8 = arg0_8:getBgFromPool(var5_8)

			if var6_8 then
				if var3_8 then
					var6_8.tf.anchoredPosition = Vector2(math.random(900, 1000) + arg0_8.midBgPosX, var6_8.data.pos.y)
				else
					var6_8.tf.anchoredPosition = Vector2(var0_8 + arg0_8.midBgPosX, var6_8.data.pos.y)
					var0_8 = var0_8 + var6_8.data.bound.x * Fushun3GameConst.game_scale
				end

				setActive(var6_8.tf, true)
				table.insert(arg0_8.bgItems, var6_8)
			end
		end
	end

	arg0_8.midBgPosX = arg0_8.midBgPosX + Fushun3GameConst.mid_bg_inst_posX
end

function var0_0.createPetal(arg0_9)
	local var0_9 = Fushun3GameConst.petal_ids[math.random(1, #Fushun3GameConst.petal_ids)]
	local var1_9 = Vector2(math.random(100, 1920), math.random(540, 1080))
	local var2_9 = arg0_9:getBgFromPool(var0_9)

	if var2_9 then
		var1_9.x = var1_9.x + math.abs(var2_9.parentTf.anchoredPosition.x)
		var1_9.y = var1_9.y
		var2_9.tf.anchoredPosition = var1_9
		var2_9.removeTime = math.random(Fushun3GameConst.peta_remove_time[1], Fushun3GameConst.peta_remove_time[2])
		var1_9.x = var1_9.x + var2_9.data.bound.x
		var2_9.speed = Vector2(Fushun3GameConst.petal_speed[1] + math.random(1, Fushun3GameConst.petal_speed_offset), Fushun3GameConst.petal_speed[2] + math.random(1, Fushun3GameConst.petal_speed_offset))

		setActive(var2_9.tf, true)
		table.insert(arg0_9.bgItems, var2_9)

		arg0_9.petalCount = arg0_9.petalCount + 1
	end
end

function var0_0.createFire(arg0_10)
	local var0_10 = Fushun3GameConst.fire_group[math.random(1, #Fushun3GameConst.fire_group)]
	local var1_10 = Vector2(math.random(100, 1920), 0)

	for iter0_10 = 1, #var0_10 do
		local var2_10 = var0_10[iter0_10]
		local var3_10 = arg0_10:getBgFromPool(var2_10)

		if var3_10 then
			var1_10.x = var1_10.x + math.abs(var3_10.parentTf.anchoredPosition.x)
			var1_10.y = var3_10.data.pos.y
			var3_10.tf.anchoredPosition = var1_10
			var3_10.removeTime = Fushun3GameConst.fire_remove
			var1_10.x = var1_10.x + var3_10.data.bound.x

			setActive(var3_10.tf, true)
			table.insert(arg0_10.bgItems, var3_10)
		end
	end
end

function var0_0.getBgData(arg0_11, arg1_11)
	for iter0_11 = 1, #Fushun3GameConst.bg_data do
		if Fushun3GameConst.bg_data[iter0_11].id == arg1_11 then
			return Fushun3GameConst.bg_data[iter0_11]
		end
	end
end

function var0_0.getBgFromPool(arg0_12, arg1_12)
	for iter0_12 = 1, #arg0_12.bgsPool do
		if arg0_12.bgsPool[iter0_12].data.id == arg1_12 then
			return table.remove(arg0_12.bgsPool, iter0_12)
		end
	end

	local var0_12

	for iter1_12 = 1, #Fushun3GameConst.bg_data do
		local var1_12 = Fushun3GameConst.bg_data[iter1_12]

		if var1_12.id == arg1_12 then
			var0_12 = var1_12
		end
	end

	if var0_12 then
		local var2_12
		local var3_12

		if var0_12.type == Fushun3GameConst.BG_TYPE_FIRE then
			var2_12 = tf(instantiate(findTF(arg0_12._fireTpl, var0_12.name)))
			var3_12 = findTF(arg0_12._backSceneTf, "bgFire")
		elseif var0_12.type == Fushun3GameConst.BG_TYPE_TOP then
			var2_12 = tf(instantiate(findTF(arg0_12._bgTpl, var0_12.name)))
			var3_12 = findTF(arg0_12._backSceneTf, "bgTop")
		elseif var0_12.type == Fushun3GameConst.BG_TYPE_MID then
			var2_12 = tf(instantiate(findTF(arg0_12._bgTpl, var0_12.name)))
			var3_12 = findTF(arg0_12._backSceneTf, "bgMid")
		elseif var0_12.type == Fushun3GameConst.BG_TYPE_LOOP then
			var2_12 = tf(instantiate(findTF(arg0_12._bgTpl, var0_12.name)))
			var3_12 = findTF(arg0_12._backSceneTf, "bgBottom")
		elseif var0_12.type == Fushun3GameConst.BG_TYPE_PETAL then
			var2_12 = tf(instantiate(findTF(arg0_12._petalTpl, var0_12.name)))
			var3_12 = findTF(arg0_12._backSceneTf, "bgPetal")
		end

		if var2_12 and var3_12 then
			SetParent(var2_12, var3_12)
		end

		return {
			tf = var2_12,
			data = var0_12,
			parentTf = var3_12
		}
	end

	return nil
end

function var0_0.clearBg(arg0_13)
	for iter0_13 = #arg0_13.bgItems, 1, -1 do
		setActive(arg0_13.bgItems[iter0_13].tf, false)
		table.insert(arg0_13.bgsPool, table.remove(arg0_13.bgItems, iter0_13))
	end
end

function var0_0.removeBg(arg0_14)
	local var0_14 = {}

	for iter0_14 = #arg0_14.bgItems, 1, -1 do
		local var1_14 = arg0_14.bgItems[iter0_14]

		if var0_14[var1_14.parentTf] == nil then
			var0_14[var1_14.parentTf] = math.abs(var1_14.parentTf.anchoredPosition.x) + Fushun3GameConst.bg_remove_posX - var1_14.data.bound.x * Fushun3GameConst.game_scale
		end

		if var1_14.removeTime and var1_14.removeTime > 0 then
			var1_14.removeTime = var1_14.removeTime - Time.deltaTime
		end

		if var1_14.tf.anchoredPosition.x <= var0_14[var1_14.parentTf] then
			setActive(var1_14.tf, false)
			table.insert(arg0_14.bgsPool, table.remove(arg0_14.bgItems, iter0_14))
		elseif var1_14.removeTime and var1_14.removeTime <= 0 then
			if var1_14.data.type == Fushun3GameConst.BG_TYPE_PETAL then
				arg0_14.petalCount = arg0_14.petalCount - 1
			end

			setActive(var1_14.tf, false)
			table.insert(arg0_14.bgsPool, table.remove(arg0_14.bgItems, iter0_14))
		end
	end
end

return var0_0
