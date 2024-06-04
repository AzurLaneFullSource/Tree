local var0 = class("CastleGameFloor")
local var1 = 999999

function var0.Ctor(arg0, arg1, arg2)
	arg0._tpl = arg1
	arg0._event = arg2
	arg0.floors = {}
	arg0.colliders = {}
	arg0.floorTfs = {}
	arg0.bounds = {}

	local var0 = CastleGameVo.h_count * CastleGameVo.w_count

	for iter0 = 0, var0 - 1 do
		local var1 = tf(instantiate(arg0._tpl))

		var1.name = tostring(iter0 + 1)

		setActive(var1, true)

		local var2 = findTF(var1, "zPos")
		local var3 = findTF(var1, "zPos/floor/img")

		setImageSprite(var3, CastleGameVo.getFloorImage(iter0 + 1), true)

		local var4 = var1.anchoredPosition
		local var5 = findTF(var1, "zPos/collider")
		local var6 = GetComponent(var5, typeof("UnityEngine.PolygonCollider2D"))
		local var7 = GetComponent(findTF(var1, "zPos/floor"), typeof(Animator))
		local var8 = iter0 % CastleGameVo.h_count
		local var9 = math.floor(iter0 / CastleGameVo.w_count)

		table.insert(arg0.colliders, var6)
		table.insert(arg0.floorTfs, var1)
		table.insert(arg0.floors, {
			fall = false,
			tf = var1,
			zPos = var2,
			anim = var7,
			index = iter0,
			collider = var6,
			w = var8,
			h = var9
		})
	end

	arg0:updateFloorPos()
	arg0:updateBounds()
end

function var0.getTfs(arg0)
	return arg0.floorTfs
end

function var0.getFloors(arg0)
	return arg0.floors
end

function var0.getActiveIndexs(arg0)
	return arg0.activeIndexs
end

function var0.updateBounds(arg0)
	for iter0 = 1, #arg0.floors do
		local var0 = arg0.floors[iter0].collider.points
		local var1 = arg0.floors[iter0].tf.anchoredPosition
		local var2 = {}

		for iter1 = 0, var0.Length - 1 do
			local var3 = Vector2(var1.x + var0[iter1].x, var1.y + var0[iter1].y)

			table.insert(var2, var3)
		end

		arg0.floors[iter0].bound = var2

		table.insert(arg0.bounds, var2)
	end
end

function var0.getBounds(arg0)
	return arg0.bounds
end

function var0.setContent(arg0, arg1)
	if not arg1 then
		print("地板的容器不能为nil")

		return
	end

	arg0._content = arg1

	for iter0 = 1, #arg0.floorTfs do
		SetParent(arg0.floorTfs[iter0], arg1)
	end
end

function var0.start(arg0)
	arg0.fallDatas = arg0:getFallDatas()
	arg0.floorFallStep = var1
	arg0.activeIndexs = {}

	for iter0 = 1, #arg0.floors do
		arg0.floors[iter0].fall = false
		arg0.floors[iter0].removeTime = nil
		arg0.floors[iter0].revertTime = nil

		setActive(arg0.floors[iter0].tf, false)
		setActive(arg0.floors[iter0].tf, true)
		table.insert(arg0.activeIndexs, arg0.floors[iter0].index)
	end

	arg0:updateFloorPos()
end

function var0.step(arg0)
	if arg0.floorFallStep and arg0.floorFallStep > 0 then
		arg0.floorFallStep = arg0.floorFallStep - CastleGameVo.deltaTime

		if arg0.floorFallStep <= 0 then
			-- block empty
		end
	end

	for iter0 = #arg0.floors, 1, -1 do
		local var0 = arg0.floors[iter0]

		if var0.removeTime and var0.removeTime > 0 then
			var0.removeTime = var0.removeTime - CastleGameVo.deltaTime

			if var0.removeTime <= 0 then
				var0.removeTime = nil

				arg0:applyFloorFall(var0)
			end
		end
	end

	for iter1 = #arg0.floors, 1, -1 do
		local var1 = arg0.floors[iter1]

		if var1.revertTime and var1.revertTime > 0 then
			var1.revertTime = var1.revertTime - CastleGameVo.deltaTime

			if var1.revertTime <= 0 then
				var1.revertTime = nil

				arg0:revertFloorFall(var1)
				arg0:revertActiveFloor(var1)
			end
		end
	end

	for iter2 = #arg0.fallDatas, 1, -1 do
		if CastleGameVo.gameStepTime >= arg0.fallDatas[iter2].time then
			local var2 = table.remove(arg0.fallDatas, iter2)

			arg0:removeFloorByFallData(var2)

			break
		end
	end
end

function var0.setBroken(arg0, arg1, arg2)
	local var0 = arg0:getFloorByIndex(arg1)

	arg0:setFloorFallTime(var0, false, arg2)
end

function var0.removeFloorByFallData(arg0, arg1)
	local var0 = table.remove(arg1.rule_id, math.random(1, #arg1.rule_id))
	local var1 = CastleGameVo.floor_rule[var0]

	for iter0 = 1, #var1 do
		local var2 = arg0:getFloorByIndex(var1[iter0])

		arg0:setFloorFallTime(var2, true, nil)
	end
end

function var0.clear(arg0)
	return
end

function var0.setFloorFallCallback(arg0, arg1)
	arg0.floorFallCallback = arg1
end

function var0.getFallDatas(arg0)
	return CastleGameVo.roundData.floors
end

function var0.applyFloorFall(arg0, arg1)
	local var0 = arg1.zPos
	local var1 = arg1.anim

	arg1.fall = true
	arg1.revertTime = CastleGameVo.floor_revert_time

	var1:Play("hide")
end

function var0.revertFloorFall(arg0, arg1)
	local var0 = arg1.anim

	arg1.fall = false

	var0:Play("revert")
end

function var0.revertActiveFloor(arg0, arg1)
	if not table.contains(arg0.activeIndexs, arg1.index) then
		table.insert(arg0.activeIndexs, arg1.index)
	end
end

function var0.removeActiveFloor(arg0, arg1)
	for iter0 = #arg0.activeIndexs, 1, -1 do
		if arg0.activeIndexs[iter0] == arg1.index then
			table.remove(arg0.activeIndexs, iter0)
		end
	end
end

function var0.setFloorFallTime(arg0, arg1, arg2, arg3)
	for iter0 = 1, #arg1 do
		if arg2 then
			arg1[iter0].anim:Play("shake")
		end

		if not arg1[iter0].fall then
			arg1[iter0].removeTime = arg3 and arg3 or CastleGameVo.floor_remove_time
			arg1[iter0].revertTime = nil

			arg0:removeActiveFloor(arg1[iter0])
		else
			print(arg1[iter0].index .. "已经被移除，无法设置掉落")
		end
	end
end

function var0.getFloorByIndex(arg0, arg1, arg2)
	for iter0 = 1, #arg0.floors do
		if arg0.floors[iter0].index == arg1 then
			return {
				arg0.floors[iter0]
			}
		end
	end

	print("找不到index = " .. arg1 .. "的地板")

	return {}
end

function var0.updateFloorPos(arg0)
	for iter0 = 1, #arg0.floors do
		local var0 = arg0.floors[iter0].index
		local var1 = var0 % CastleGameVo.w_count
		local var2 = math.floor(var0 / CastleGameVo.h_count)

		arg0.floors[iter0].tf.anchoredPosition = CastleGameVo.GetRotationPosByWH(var1, var2)
	end
end

function var0.getOutLandPoint(arg0)
	local var0 = arg0.floors[1].bound[1]
	local var1 = arg0.floors[(CastleGameVo.h_count - 1) * CastleGameVo.w_count + 1].bound[2]
	local var2 = arg0.floors[CastleGameVo.w_count].bound[4]
	local var3 = arg0.floors[CastleGameVo.h_count * CastleGameVo.w_count].bound[3]

	return {
		lb = var0,
		lt = var1,
		rt = var3,
		rb = var2
	}
end

function var0.press(arg0, arg1)
	return
end

return var0
