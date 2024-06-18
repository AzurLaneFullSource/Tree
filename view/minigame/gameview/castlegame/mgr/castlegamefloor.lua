local var0_0 = class("CastleGameFloor")
local var1_0 = 999999

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tpl = arg1_1
	arg0_1._event = arg2_1
	arg0_1.floors = {}
	arg0_1.colliders = {}
	arg0_1.floorTfs = {}
	arg0_1.bounds = {}

	local var0_1 = CastleGameVo.h_count * CastleGameVo.w_count

	for iter0_1 = 0, var0_1 - 1 do
		local var1_1 = tf(instantiate(arg0_1._tpl))

		var1_1.name = tostring(iter0_1 + 1)

		setActive(var1_1, true)

		local var2_1 = findTF(var1_1, "zPos")
		local var3_1 = findTF(var1_1, "zPos/floor/img")

		setImageSprite(var3_1, CastleGameVo.getFloorImage(iter0_1 + 1), true)

		local var4_1 = var1_1.anchoredPosition
		local var5_1 = findTF(var1_1, "zPos/collider")
		local var6_1 = GetComponent(var5_1, typeof("UnityEngine.PolygonCollider2D"))
		local var7_1 = GetComponent(findTF(var1_1, "zPos/floor"), typeof(Animator))
		local var8_1 = iter0_1 % CastleGameVo.h_count
		local var9_1 = math.floor(iter0_1 / CastleGameVo.w_count)

		table.insert(arg0_1.colliders, var6_1)
		table.insert(arg0_1.floorTfs, var1_1)
		table.insert(arg0_1.floors, {
			fall = false,
			tf = var1_1,
			zPos = var2_1,
			anim = var7_1,
			index = iter0_1,
			collider = var6_1,
			w = var8_1,
			h = var9_1
		})
	end

	arg0_1:updateFloorPos()
	arg0_1:updateBounds()
end

function var0_0.getTfs(arg0_2)
	return arg0_2.floorTfs
end

function var0_0.getFloors(arg0_3)
	return arg0_3.floors
end

function var0_0.getActiveIndexs(arg0_4)
	return arg0_4.activeIndexs
end

function var0_0.updateBounds(arg0_5)
	for iter0_5 = 1, #arg0_5.floors do
		local var0_5 = arg0_5.floors[iter0_5].collider.points
		local var1_5 = arg0_5.floors[iter0_5].tf.anchoredPosition
		local var2_5 = {}

		for iter1_5 = 0, var0_5.Length - 1 do
			local var3_5 = Vector2(var1_5.x + var0_5[iter1_5].x, var1_5.y + var0_5[iter1_5].y)

			table.insert(var2_5, var3_5)
		end

		arg0_5.floors[iter0_5].bound = var2_5

		table.insert(arg0_5.bounds, var2_5)
	end
end

function var0_0.getBounds(arg0_6)
	return arg0_6.bounds
end

function var0_0.setContent(arg0_7, arg1_7)
	if not arg1_7 then
		print("地板的容器不能为nil")

		return
	end

	arg0_7._content = arg1_7

	for iter0_7 = 1, #arg0_7.floorTfs do
		SetParent(arg0_7.floorTfs[iter0_7], arg1_7)
	end
end

function var0_0.start(arg0_8)
	arg0_8.fallDatas = arg0_8:getFallDatas()
	arg0_8.floorFallStep = var1_0
	arg0_8.activeIndexs = {}

	for iter0_8 = 1, #arg0_8.floors do
		arg0_8.floors[iter0_8].fall = false
		arg0_8.floors[iter0_8].removeTime = nil
		arg0_8.floors[iter0_8].revertTime = nil

		setActive(arg0_8.floors[iter0_8].tf, false)
		setActive(arg0_8.floors[iter0_8].tf, true)
		table.insert(arg0_8.activeIndexs, arg0_8.floors[iter0_8].index)
	end

	arg0_8:updateFloorPos()
end

function var0_0.step(arg0_9)
	if arg0_9.floorFallStep and arg0_9.floorFallStep > 0 then
		arg0_9.floorFallStep = arg0_9.floorFallStep - CastleGameVo.deltaTime

		if arg0_9.floorFallStep <= 0 then
			-- block empty
		end
	end

	for iter0_9 = #arg0_9.floors, 1, -1 do
		local var0_9 = arg0_9.floors[iter0_9]

		if var0_9.removeTime and var0_9.removeTime > 0 then
			var0_9.removeTime = var0_9.removeTime - CastleGameVo.deltaTime

			if var0_9.removeTime <= 0 then
				var0_9.removeTime = nil

				arg0_9:applyFloorFall(var0_9)
			end
		end
	end

	for iter1_9 = #arg0_9.floors, 1, -1 do
		local var1_9 = arg0_9.floors[iter1_9]

		if var1_9.revertTime and var1_9.revertTime > 0 then
			var1_9.revertTime = var1_9.revertTime - CastleGameVo.deltaTime

			if var1_9.revertTime <= 0 then
				var1_9.revertTime = nil

				arg0_9:revertFloorFall(var1_9)
				arg0_9:revertActiveFloor(var1_9)
			end
		end
	end

	for iter2_9 = #arg0_9.fallDatas, 1, -1 do
		if CastleGameVo.gameStepTime >= arg0_9.fallDatas[iter2_9].time then
			local var2_9 = table.remove(arg0_9.fallDatas, iter2_9)

			arg0_9:removeFloorByFallData(var2_9)

			break
		end
	end
end

function var0_0.setBroken(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:getFloorByIndex(arg1_10)

	arg0_10:setFloorFallTime(var0_10, false, arg2_10)
end

function var0_0.removeFloorByFallData(arg0_11, arg1_11)
	local var0_11 = table.remove(arg1_11.rule_id, math.random(1, #arg1_11.rule_id))
	local var1_11 = CastleGameVo.floor_rule[var0_11]

	for iter0_11 = 1, #var1_11 do
		local var2_11 = arg0_11:getFloorByIndex(var1_11[iter0_11])

		arg0_11:setFloorFallTime(var2_11, true, nil)
	end
end

function var0_0.clear(arg0_12)
	return
end

function var0_0.setFloorFallCallback(arg0_13, arg1_13)
	arg0_13.floorFallCallback = arg1_13
end

function var0_0.getFallDatas(arg0_14)
	return CastleGameVo.roundData.floors
end

function var0_0.applyFloorFall(arg0_15, arg1_15)
	local var0_15 = arg1_15.zPos
	local var1_15 = arg1_15.anim

	arg1_15.fall = true
	arg1_15.revertTime = CastleGameVo.floor_revert_time

	var1_15:Play("hide")
end

function var0_0.revertFloorFall(arg0_16, arg1_16)
	local var0_16 = arg1_16.anim

	arg1_16.fall = false

	var0_16:Play("revert")
end

function var0_0.revertActiveFloor(arg0_17, arg1_17)
	if not table.contains(arg0_17.activeIndexs, arg1_17.index) then
		table.insert(arg0_17.activeIndexs, arg1_17.index)
	end
end

function var0_0.removeActiveFloor(arg0_18, arg1_18)
	for iter0_18 = #arg0_18.activeIndexs, 1, -1 do
		if arg0_18.activeIndexs[iter0_18] == arg1_18.index then
			table.remove(arg0_18.activeIndexs, iter0_18)
		end
	end
end

function var0_0.setFloorFallTime(arg0_19, arg1_19, arg2_19, arg3_19)
	for iter0_19 = 1, #arg1_19 do
		if arg2_19 then
			arg1_19[iter0_19].anim:Play("shake")
		end

		if not arg1_19[iter0_19].fall then
			arg1_19[iter0_19].removeTime = arg3_19 and arg3_19 or CastleGameVo.floor_remove_time
			arg1_19[iter0_19].revertTime = nil

			arg0_19:removeActiveFloor(arg1_19[iter0_19])
		else
			print(arg1_19[iter0_19].index .. "已经被移除，无法设置掉落")
		end
	end
end

function var0_0.getFloorByIndex(arg0_20, arg1_20, arg2_20)
	for iter0_20 = 1, #arg0_20.floors do
		if arg0_20.floors[iter0_20].index == arg1_20 then
			return {
				arg0_20.floors[iter0_20]
			}
		end
	end

	print("找不到index = " .. arg1_20 .. "的地板")

	return {}
end

function var0_0.updateFloorPos(arg0_21)
	for iter0_21 = 1, #arg0_21.floors do
		local var0_21 = arg0_21.floors[iter0_21].index
		local var1_21 = var0_21 % CastleGameVo.w_count
		local var2_21 = math.floor(var0_21 / CastleGameVo.h_count)

		arg0_21.floors[iter0_21].tf.anchoredPosition = CastleGameVo.GetRotationPosByWH(var1_21, var2_21)
	end
end

function var0_0.getOutLandPoint(arg0_22)
	local var0_22 = arg0_22.floors[1].bound[1]
	local var1_22 = arg0_22.floors[(CastleGameVo.h_count - 1) * CastleGameVo.w_count + 1].bound[2]
	local var2_22 = arg0_22.floors[CastleGameVo.w_count].bound[4]
	local var3_22 = arg0_22.floors[CastleGameVo.h_count * CastleGameVo.w_count].bound[3]

	return {
		lb = var0_22,
		lt = var1_22,
		rt = var3_22,
		rb = var2_22
	}
end

function var0_0.press(arg0_23, arg1_23)
	return
end

return var0_0
