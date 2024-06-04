local var0 = class("CastleGameItem")
local var1 = 70
local var2 = 300
local var3 = 166
local var4 = {
	2,
	6
}
local var5 = 125
local var6 = "bubble_broken"
local var7 = "bubble_wait"
local var8 = "bubble_hold"
local var9 = 130
local var10 = 130

function var0.Ctor(arg0, arg1, arg2)
	arg0._bubbleTpl = findTF(arg1, "bubbleTpl")
	arg0._carriageTpl = findTF(arg1, "carriageTpl")
	arg0._stoneTpl = findTF(arg1, "stoneTpl")
	arg0._boomTpl = findTF(arg1, "boomTpl")
	arg0._event = arg2
	arg0.carriagePool = {}
	arg0.bubblePool = {}
	arg0.carriages = {}
	arg0.bubbles = {}
	arg0.stonePool = {}
	arg0.stones = {}
	arg0.boomPool = {}
	arg0.booms = {}
end

function var0.setContent(arg0, arg1)
	if not arg1 then
		print("容器不能为nil")

		return
	end

	arg0._content = arg1
end

function var0.start(arg0)
	local var0 = CastleGameVo.roundData.stone

	arg0.stoneDatas = {}

	for iter0 = 1, #var0 do
		local var1 = math.random() * (var0[iter0].time[2] - var0[iter0].time[1]) + var0[iter0].time[1]
		local var2 = var0[iter0].index

		table.insert(arg0.stoneDatas, {
			time = var1,
			indexs = var2
		})
	end

	for iter1 = #arg0.stones, 1, -1 do
		local var3 = table.remove(arg0.stones, iter1)

		setActive(var3.tf, false)
		arg0:returnItem(var3, arg0.stonePool)
	end

	for iter2 = #arg0.carriages, 1, -1 do
		local var4 = table.remove(arg0.carriages, iter2)

		var4.ready = 0

		setActive(var4.tf, false)
		arg0:returnItem(var4, arg0.carriagePool)
	end

	for iter3 = #arg0.bubbles, 1, -1 do
		local var5 = table.remove(arg0.bubbles, iter3)

		var5.ready = 0
		var5.broken = true
		var5.brokenTime = 0
		var5.hit = false

		setActive(var5.tf, false)
		arg0:returnItem(var5, arg0.bubblePool)
	end

	for iter4 = #arg0.booms, 1, -1 do
		local var6 = table.remove(arg0.booms, iter4)

		var6.ready = 0
		var6.broken = true
		var6.brokenTime = 0

		setActive(var6.tf, false)
		arg0:returnItem(var6, arg0.boomPool)
	end

	arg0.floorIndexs = {}
	arg0.carriageTime = CastleGameVo.roundData.carriage
	arg0.bubbleTime = CastleGameVo.roundData.bubble_time
	arg0.boomTimes = {}

	for iter5 = 1, #CastleGameVo.roundData.boom do
		local var7 = CastleGameVo.roundData.boom[iter5].time
		local var8 = var7[math.random(1, #var7)]

		table.insert(arg0.boomTimes, {
			time = var8
		})
	end
end

function var0.step(arg0)
	for iter0 = #arg0.carriageTime, 1, -1 do
		if CastleGameVo.gameStepTime > arg0.carriageTime[iter0] then
			table.remove(arg0.carriageTime, iter0)
			arg0:appearCarriage()
		end
	end

	for iter1 = #arg0.bubbleTime, 1, -1 do
		if CastleGameVo.gameStepTime > arg0.bubbleTime[iter1].time then
			local var0 = table.remove(arg0.bubbleTime, iter1)

			arg0:appearBubble(var0.num)
		end
	end

	for iter2 = #arg0.boomTimes, 1, -1 do
		local var1 = arg0.boomTimes[iter2]

		if CastleGameVo.gameStepTime > var1.time then
			table.remove(arg0.boomTimes, iter2)
			arg0:appearBoom()
		end
	end

	for iter3 = #arg0.carriages, 1, -1 do
		local var2 = arg0.carriages[iter3]

		if var2.ready and var2.ready > 0 then
			var2.ready = var2.ready - CastleGameVo.deltaTime

			if var2.ready <= 0 then
				var2.ready = 0

				if arg0.itemRemindCallback then
					-- block empty
				end
			end
		else
			local var3 = var2.tf
			local var4 = var2.target
			local var5 = var3.anchoredPosition
			local var6 = Vector2(var5.x + var2.speed.x * CastleGameVo.deltaTime * var2, var5.y + var2.speed.y * CastleGameVo.deltaTime * var2)

			var3.anchoredPosition = var6

			if var5.x < var4.x and var6.x > var4.x then
				table.remove(arg0.carriages, iter3)
				setActive(var2.tf, false)
				arg0:returnItem(var2, arg0.carriagePool)
			elseif var5.x > var4.x and var6.x < var4.x then
				table.remove(arg0.carriages, iter3)
				setActive(var2.tf, false)
				arg0:returnItem(var2, arg0.carriagePool)
			end
		end
	end

	for iter4 = #arg0.bubbles, 1, -1 do
		local var7 = arg0.bubbles[iter4]

		if var7.ready and var7.ready > 0 then
			var7.ready = var7.ready - CastleGameVo.deltaTime

			if var7.ready <= 0 then
				var7.ready = 0

				setActive(var7.tf, true)
			end
		elseif var7.brokenTime and var7.brokenTime > 0 then
			var7.brokenTime = var7.brokenTime - CastleGameVo.deltaTime

			if not var7.hit and CastleGameVo.bubble_broken_time - var7.brokenTime > 1 then
				var7.hit = true
			end

			if var7.brokenTime < 0 then
				var7.broken = true
				var7.brokenTime = 0
				var7.hit = false

				if arg0.bubbleBrokenCallback then
					arg0.bubbleBrokenCallback(var7)
				end

				arg0:changeAnimAction(var7.anims, var6, 1, var7, function()
					setActive(var7.tf, false)
				end)
				arg0:returnItem(var7, arg0.bubblePool)
				table.remove(arg0.bubbles, iter4)
			end
		end
	end

	for iter5 = #arg0.stoneDatas, 1, -1 do
		if CastleGameVo.gameStepTime > arg0.stoneDatas[iter5].time then
			local var8 = table.remove(arg0.stoneDatas, iter5).indexs

			arg0:appearStone(var8)
		end
	end

	for iter6 = #arg0.stones, 1, -1 do
		local var9 = arg0.stones[iter6]

		if var9.ready and var9.ready > 0 then
			var9.ready = var9.ready - CastleGameVo.deltaTime

			if var9.ready <= 0 then
				var9.ready = 0

				setActive(var9.tf, true)

				if arg0.floorBrokenCallback then
					arg0.floorBrokenCallback(var9.useIndex, 0.5)
				end
			end
		elseif var9.brokenTime and var9.brokenTime > 0 then
			var9.brokenTime = var9.brokenTime - CastleGameVo.deltaTime

			if var9.brokenTime <= 0 then
				var9.broken = true
				var9.brokenTime = nil

				table.remove(arg0.stones, iter6)
				setActive(var9.tf, false)
				arg0:returnItem(var9, arg0.stonePool)
			end
		end
	end

	for iter7 = #arg0.booms, 1, -1 do
		local var10 = arg0.booms[iter7]
		local var11 = arg0.booms[iter7].tf.anchoredPosition
		local var12 = var10.bound.points
		local var13 = {}

		for iter8 = 0, var12.Length - 1 do
			local var14 = var12[iter8]

			findTF(var10.tf, "zPos/" .. iter8 + 1).anchoredPosition = Vector2(var14.x, var14.y)

			local var15 = Vector2(var11.x + var14.x, var11.y + var14.y)

			table.insert(var13, var15)
		end

		var10.boundPoints = var13

		if var10.ready and var10.ready > 0 then
			var10.ready = var10.ready - CastleGameVo.deltaTime

			if var10.ready <= 0 then
				var10.ready = 0

				setActive(var10.tf, true)

				if arg0.floorBrokenCallback then
					arg0.floorBrokenCallback(var10.useIndex, 0.5)
				end
			end
		elseif var10.brokenTime and var10.brokenTime > 0 then
			var10.brokenTime = var10.brokenTime - CastleGameVo.deltaTime

			if var10.brokenTime < 0 then
				var10.broken = true
				var10.brokenTime = 0

				setActive(var10.tf, false)

				local var16 = table.remove(arg0.booms, iter7)

				arg0:returnItem(var16, arg0.boomPool)
			end
		end
	end
end

function var0.appearStone(arg0, arg1)
	local var0
	local var1 = {}
	local var2 = arg0:getItemActiveIndex()

	for iter0 = 1, #var2 do
		if not table.contains(arg1, var2[iter0]) then
			table.insert(var1, var2[iter0])
		end
	end

	if #var1 == 0 then
		return
	end

	if #arg0.stonePool > 0 then
		var0 = table.remove(arg0.stonePool, 1)
	else
		local var3 = tf(instantiate(arg0._stoneTpl))

		setParent(var3, arg0._content)

		local var4 = GetComponent(findTF(var3, "zPos/anim/collider"), typeof(BoxCollider2D))

		var0 = {
			tf = var3,
			bound = var4
		}
	end

	local var5 = findTF(var0.tf, "zPos/anim/img")
	local var6 = var5.childCount
	local var7 = math.random(1, var6) - 1

	for iter1 = 0, var6 - 1 do
		setActive(var5:GetChild(iter1), iter1 == var7)
	end

	var0.ready = CastleGameVo.item_ready_time
	var0.brokenTime = CastleGameVo.stone_broken_time

	local var8 = var1[math.random(1, #var1)]
	local var9 = var8 % CastleGameVo.w_count
	local var10 = math.floor(var8 / CastleGameVo.w_count)

	var0.tf.anchoredPosition = CastleGameVo.GetRotationPosByWH(var9, var10)

	setActive(var0.tf, false)

	var0.index = var8
	var0.useIndex = {
		var8
	}

	if arg0.itemRemindCallback then
		arg0.itemRemindCallback({
			{
				w = var9,
				h = var10,
				type = CastleGameRemind.remind_type_1
			}
		})
	end

	table.insert(arg0.stones, var0)
end

function var0.returnItem(arg0, arg1, arg2)
	if arg0.itemChangeCallback then
		arg0.itemChangeCallback(arg1, false)
	end

	table.insert(arg2, arg1)
end

function var0.appearBubble(arg0, arg1)
	for iter0 = 1, arg1 do
		local var0
		local var1 = arg0:getItemActiveIndex()

		if #var1 == 0 then
			return
		end

		if #arg0.bubblePool > 0 then
			var0 = table.remove(arg0.bubblePool, 1)
		else
			local var2 = tf(instantiate(arg0._bubbleTpl))
			local var3 = findTF(var2, "zPos/pos")
			local var4 = GetComponent(findTF(var2, "zPos/spine1"), typeof(SpineAnimUI))
			local var5 = GetComponent(findTF(var2, "zPos/spine2"), typeof(SpineAnimUI))
			local var6 = GetComponent(findTF(var2, "zPos/collider"), typeof(BoxCollider2D))
			local var7 = var2:InverseTransformPoint(var6.bounds.min)
			local var8 = var2:InverseTransformPoint(var6.bounds.max)

			setParent(var2, arg0._content)

			var0 = {
				tf = var2,
				anims = {
					var4,
					var5
				},
				bound = var6,
				pos = var3,
				bmin = var7,
				bmax = var8
			}
		end

		local var9 = var1[math.random(1, #var1)]
		local var10 = var9 % CastleGameVo.w_count
		local var11 = math.floor(var9 / CastleGameVo.w_count)

		var0.start = CastleGameVo.GetRotationPosByWH(var10, var11)
		var0.start.y = var0.start.y + var5
		var0.tf.anchoredPosition = var0.start

		setActive(var0.tf, false)

		var0.ready = CastleGameVo.bubble_ready_time
		var0.broken = false
		var0.brokenTime = CastleGameVo.bubble_broken_time
		var0.useIndex = {
			var9
		}
		var0.index = var9

		if arg0.itemChangeCallback then
			arg0.itemChangeCallback(var0, true)
		end

		setActive(var0.tf, false)
		table.insert(arg0.bubbles, var0)
		arg0:changeAnimAction(var0.anims, var8, -1)
	end
end

function var0.appearBoom(arg0)
	local var0 = {}
	local var1 = arg0:getItemActiveIndex()

	for iter0 = 1, #var1 do
		local var2 = var1[iter0]

		if var2 % CastleGameVo.w_count ~= CastleGameVo.w_count - 1 then
			local var3 = var2 + 1
			local var4 = var2 + CastleGameVo.w_count
			local var5 = var2 + 1 + CastleGameVo.w_count

			if table.contains(var1, var3) and table.contains(var1, var4) and table.contains(var1, var5) then
				table.insert(var0, var2)
			end
		end
	end

	local var6 = var0[math.random(1, #var0)]

	if #var0 == 0 then
		return
	end

	local var7

	if #arg0.boomPool > 0 then
		var7 = table.remove(arg0.boomPool, 1)
	else
		local var8 = tf(instantiate(arg0._boomTpl))
		local var9 = GetComponent(findTF(var8, "zPos/collider"), typeof("UnityEngine.PolygonCollider2D"))

		setParent(var8, arg0._content)

		var7 = {
			tf = var8,
			bound = var9
		}
	end

	local var10 = var6 % CastleGameVo.w_count
	local var11 = math.floor(var6 / CastleGameVo.w_count)
	local var12 = CastleGameVo.GetRotationPosByWH(var10, var11)

	var12.x = var12.x + var9
	var12.y = var12.y + var10
	var7.tf.anchoredPosition = var12
	var7.ready = CastleGameVo.item_ready_time
	var7.broken = false

	setActive(var7.tf, false)

	var7.index = var6
	var7.useIndex = {
		var6,
		var6 + 1,
		var6 + CastleGameVo.w_count,
		var6 + CastleGameVo.w_count + 1
	}
	var7.brokenTime = 1.5

	if arg0.itemChangeCallback then
		arg0.itemChangeCallback(var7, true)
	end

	if arg0.itemRemindCallback then
		arg0.itemRemindCallback({
			{
				w = var10,
				h = var11,
				type = CastleGameRemind.remind_type_2
			}
		})
	end

	table.insert(arg0.booms, var7)
end

function var0.setFloorBroken(arg0, arg1)
	arg0.floorBrokenCallback = arg1
end

function var0.setBubbleBroken(arg0, arg1)
	arg0.bubbleBrokenCallback = arg1
end

function var0.setItemChange(arg0, arg1)
	arg0.itemChangeCallback = arg1
end

function var0.setFloorIndexs(arg0, arg1)
	arg0.floorIndexs = arg1
end

function var0.getItemActiveIndex(arg0)
	local var0 = {}
	local var1 = {}

	for iter0 = 1, #arg0.bubbles do
		for iter1, iter2 in ipairs(arg0.bubbles[iter0].useIndex) do
			table.insert(var1, iter2)
		end
	end

	for iter3 = 1, #arg0.booms do
		for iter4, iter5 in ipairs(arg0.booms[iter3].useIndex) do
			table.insert(var1, iter5)
		end
	end

	for iter6 = 1, #arg0.stones do
		for iter7, iter8 in ipairs(arg0.stones[iter6].useIndex) do
			table.insert(var1, iter8)
		end
	end

	for iter9 = 1, #arg0.floorIndexs do
		local var2 = arg0.floorIndexs[iter9]

		if not table.contains(var1, var2) then
			table.insert(var0, var2)
		end
	end

	return var0
end

function var0.appearCarriage(arg0)
	local var0

	if #arg0.carriagePool > 0 then
		var0 = table.remove(arg0.carriagePool, 1)
	else
		local var1 = tf(instantiate(arg0._carriageTpl))
		local var2 = GetComponent(findTF(var1, "zPos/spine"), typeof(SpineAnimUI))
		local var3 = GetComponent(findTF(var1, "zPos/collider"), typeof(BoxCollider2D))
		local var4 = var1:InverseTransformPoint(var3.bounds.min)
		local var5 = var1:InverseTransformPoint(var3.bounds.max)

		setParent(var1, arg0._content)

		var0 = {
			tf = var1,
			bound = var3,
			anims = {
				var2
			},
			bmin = var4,
			bmax = var5
		}
	end

	local var6 = arg0:getCarriageRoadlist()

	if #var6 > 0 then
		local var7 = var6[math.random(1, #var6)]
		local var8 = var7.w
		local var9 = var7.h
		local var10 = var7.target_w
		local var11 = var7.target_h
		local var12 = var7.scale

		var0.w = var8
		var0.h = var9
		var0.target_w = var10
		var0.target_h = var11
		findTF(var0.tf, "zPos").localScale = var12
		var0.start = CastleGameVo.GetRotationPosByWH(var0.w, var0.h)
		var0.start.y = var0.start.y + var1
		var0.target = CastleGameVo.GetRotationPosByWH(var0.target_w, var0.target_h)
		var0.target.y = var0.target.y + var1
		var0.tf.anchoredPosition = var0.start
		var0.ready = CastleGameVo.item_ready_time

		setActive(var0.tf, false)
		setActive(var0.tf, true)

		local var13, var14 = arg0:countSpeed(var0.start, var0.target)

		var0.speed = var13
		var0.direct = var14

		if arg0.itemChangeCallback then
			arg0.itemChangeCallback(var0, true)
		end

		table.insert(arg0.carriages, var0)
	else
		print("当前不存在可以出现马车的位置")
	end
end

function var0.getCarriageRoadlist(arg0)
	local var0 = {}

	for iter0 = 0, CastleGameVo.w_count - 1 do
		local var1 = true

		for iter1 = 0, CastleGameVo.h_count - 1 do
			local var2 = iter0 + iter1 * CastleGameVo.w_count

			if var1 and not table.contains(arg0.floorIndexs, var2) then
				var1 = false
			end
		end

		if var1 then
			table.insert(var0, {
				h = -1,
				w = iter0,
				target_w = iter0,
				target_h = CastleGameVo.h_count,
				scale = Vector3(-1, 1, 1)
			})
		end
	end

	for iter2 = 0, CastleGameVo.h_count - 1 do
		local var3 = true

		for iter3 = 0, CastleGameVo.w_count - 1 do
			local var4 = iter3 + iter2 * CastleGameVo.w_count

			if var3 and not table.contains(arg0.floorIndexs, var4) then
				var3 = false
			end
		end

		if var3 then
			table.insert(var0, {
				w = -1,
				h = iter2,
				target_w = CastleGameVo.w_count,
				target_h = iter2,
				scale = Vector3(1, 1, 1)
			})
		end
	end

	return var0
end

function var0.setItemRemindCallback(arg0, arg1)
	arg0.itemRemindCallback = arg1
end

function var0.countSpeed(arg0, arg1, arg2)
	local var0 = math.atan(math.abs(arg2.y - arg1.y) / math.abs(arg2.x - arg1.x))
	local var1 = arg2.x > arg1.x and 1 or -1
	local var2 = arg2.y > arg1.y and 1 or -1
	local var3 = math.cos(var0) * var1
	local var4 = math.sin(var0) * var2

	return Vector2(var3, var4), Vector2(var1, var2)
end

function var0.changeAnimAction(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = 0

	for iter0 = 1, #arg1 do
		local var1 = arg1[iter0]

		var1:SetActionCallBack(nil)
		var1:SetAction(arg2, 0)
		var1:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				if arg3 == 1 then
					var1:SetActionCallBack(nil)
					var1:SetAction(arg4, 0)
				end

				if arg5 and var0 == 0 then
					var0 = 1

					arg5()
				end
			end
		end)

		if arg3 ~= 1 and arg5 and var0 == 0 then
			var0 = 1

			arg5()
		end
	end
end

function var0.playerInBubble(arg0, arg1, arg2)
	arg1.char = arg2
end

function var0.getBooms(arg0)
	return arg0.booms
end

function var0.getBubbles(arg0)
	return arg0.bubbles
end

function var0.getCarriages(arg0)
	return arg0.carriages
end

function var0.clear(arg0)
	return
end

return var0
