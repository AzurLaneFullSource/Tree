local var0_0 = class("CastleGameItem")
local var1_0 = 70
local var2_0 = 300
local var3_0 = 166
local var4_0 = {
	2,
	6
}
local var5_0 = 125
local var6_0 = "bubble_broken"
local var7_0 = "bubble_wait"
local var8_0 = "bubble_hold"
local var9_0 = 130
local var10_0 = 130

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._bubbleTpl = findTF(arg1_1, "bubbleTpl")
	arg0_1._carriageTpl = findTF(arg1_1, "carriageTpl")
	arg0_1._stoneTpl = findTF(arg1_1, "stoneTpl")
	arg0_1._boomTpl = findTF(arg1_1, "boomTpl")
	arg0_1._event = arg2_1
	arg0_1.carriagePool = {}
	arg0_1.bubblePool = {}
	arg0_1.carriages = {}
	arg0_1.bubbles = {}
	arg0_1.stonePool = {}
	arg0_1.stones = {}
	arg0_1.boomPool = {}
	arg0_1.booms = {}
end

function var0_0.setContent(arg0_2, arg1_2)
	if not arg1_2 then
		print("容器不能为nil")

		return
	end

	arg0_2._content = arg1_2
end

function var0_0.start(arg0_3)
	local var0_3 = CastleGameVo.roundData.stone

	arg0_3.stoneDatas = {}

	for iter0_3 = 1, #var0_3 do
		local var1_3 = math.random() * (var0_3[iter0_3].time[2] - var0_3[iter0_3].time[1]) + var0_3[iter0_3].time[1]
		local var2_3 = var0_3[iter0_3].index

		table.insert(arg0_3.stoneDatas, {
			time = var1_3,
			indexs = var2_3
		})
	end

	for iter1_3 = #arg0_3.stones, 1, -1 do
		local var3_3 = table.remove(arg0_3.stones, iter1_3)

		setActive(var3_3.tf, false)
		arg0_3:returnItem(var3_3, arg0_3.stonePool)
	end

	for iter2_3 = #arg0_3.carriages, 1, -1 do
		local var4_3 = table.remove(arg0_3.carriages, iter2_3)

		var4_3.ready = 0

		setActive(var4_3.tf, false)
		arg0_3:returnItem(var4_3, arg0_3.carriagePool)
	end

	for iter3_3 = #arg0_3.bubbles, 1, -1 do
		local var5_3 = table.remove(arg0_3.bubbles, iter3_3)

		var5_3.ready = 0
		var5_3.broken = true
		var5_3.brokenTime = 0
		var5_3.hit = false

		setActive(var5_3.tf, false)
		arg0_3:returnItem(var5_3, arg0_3.bubblePool)
	end

	for iter4_3 = #arg0_3.booms, 1, -1 do
		local var6_3 = table.remove(arg0_3.booms, iter4_3)

		var6_3.ready = 0
		var6_3.broken = true
		var6_3.brokenTime = 0

		setActive(var6_3.tf, false)
		arg0_3:returnItem(var6_3, arg0_3.boomPool)
	end

	arg0_3.floorIndexs = {}
	arg0_3.carriageTime = CastleGameVo.roundData.carriage
	arg0_3.bubbleTime = CastleGameVo.roundData.bubble_time
	arg0_3.boomTimes = {}

	for iter5_3 = 1, #CastleGameVo.roundData.boom do
		local var7_3 = CastleGameVo.roundData.boom[iter5_3].time
		local var8_3 = var7_3[math.random(1, #var7_3)]

		table.insert(arg0_3.boomTimes, {
			time = var8_3
		})
	end
end

function var0_0.step(arg0_4)
	for iter0_4 = #arg0_4.carriageTime, 1, -1 do
		if CastleGameVo.gameStepTime > arg0_4.carriageTime[iter0_4] then
			table.remove(arg0_4.carriageTime, iter0_4)
			arg0_4:appearCarriage()
		end
	end

	for iter1_4 = #arg0_4.bubbleTime, 1, -1 do
		if CastleGameVo.gameStepTime > arg0_4.bubbleTime[iter1_4].time then
			local var0_4 = table.remove(arg0_4.bubbleTime, iter1_4)

			arg0_4:appearBubble(var0_4.num)
		end
	end

	for iter2_4 = #arg0_4.boomTimes, 1, -1 do
		local var1_4 = arg0_4.boomTimes[iter2_4]

		if CastleGameVo.gameStepTime > var1_4.time then
			table.remove(arg0_4.boomTimes, iter2_4)
			arg0_4:appearBoom()
		end
	end

	for iter3_4 = #arg0_4.carriages, 1, -1 do
		local var2_4 = arg0_4.carriages[iter3_4]

		if var2_4.ready and var2_4.ready > 0 then
			var2_4.ready = var2_4.ready - CastleGameVo.deltaTime

			if var2_4.ready <= 0 then
				var2_4.ready = 0

				if arg0_4.itemRemindCallback then
					-- block empty
				end
			end
		else
			local var3_4 = var2_4.tf
			local var4_4 = var2_4.target
			local var5_4 = var3_4.anchoredPosition
			local var6_4 = Vector2(var5_4.x + var2_4.speed.x * CastleGameVo.deltaTime * var2_0, var5_4.y + var2_4.speed.y * CastleGameVo.deltaTime * var2_0)

			var3_4.anchoredPosition = var6_4

			if var5_4.x < var4_4.x and var6_4.x > var4_4.x then
				table.remove(arg0_4.carriages, iter3_4)
				setActive(var2_4.tf, false)
				arg0_4:returnItem(var2_4, arg0_4.carriagePool)
			elseif var5_4.x > var4_4.x and var6_4.x < var4_4.x then
				table.remove(arg0_4.carriages, iter3_4)
				setActive(var2_4.tf, false)
				arg0_4:returnItem(var2_4, arg0_4.carriagePool)
			end
		end
	end

	for iter4_4 = #arg0_4.bubbles, 1, -1 do
		local var7_4 = arg0_4.bubbles[iter4_4]

		if var7_4.ready and var7_4.ready > 0 then
			var7_4.ready = var7_4.ready - CastleGameVo.deltaTime

			if var7_4.ready <= 0 then
				var7_4.ready = 0

				setActive(var7_4.tf, true)
			end
		elseif var7_4.brokenTime and var7_4.brokenTime > 0 then
			var7_4.brokenTime = var7_4.brokenTime - CastleGameVo.deltaTime

			if not var7_4.hit and CastleGameVo.bubble_broken_time - var7_4.brokenTime > 1 then
				var7_4.hit = true
			end

			if var7_4.brokenTime < 0 then
				var7_4.broken = true
				var7_4.brokenTime = 0
				var7_4.hit = false

				if arg0_4.bubbleBrokenCallback then
					arg0_4.bubbleBrokenCallback(var7_4)
				end

				arg0_4:changeAnimAction(var7_4.anims, var6_0, 1, var7_0, function()
					setActive(var7_4.tf, false)
				end)
				arg0_4:returnItem(var7_4, arg0_4.bubblePool)
				table.remove(arg0_4.bubbles, iter4_4)
			end
		end
	end

	for iter5_4 = #arg0_4.stoneDatas, 1, -1 do
		if CastleGameVo.gameStepTime > arg0_4.stoneDatas[iter5_4].time then
			local var8_4 = table.remove(arg0_4.stoneDatas, iter5_4).indexs

			arg0_4:appearStone(var8_4)
		end
	end

	for iter6_4 = #arg0_4.stones, 1, -1 do
		local var9_4 = arg0_4.stones[iter6_4]

		if var9_4.ready and var9_4.ready > 0 then
			var9_4.ready = var9_4.ready - CastleGameVo.deltaTime

			if var9_4.ready <= 0 then
				var9_4.ready = 0

				setActive(var9_4.tf, true)

				if arg0_4.floorBrokenCallback then
					arg0_4.floorBrokenCallback(var9_4.useIndex, 0.5)
				end
			end
		elseif var9_4.brokenTime and var9_4.brokenTime > 0 then
			var9_4.brokenTime = var9_4.brokenTime - CastleGameVo.deltaTime

			if var9_4.brokenTime <= 0 then
				var9_4.broken = true
				var9_4.brokenTime = nil

				table.remove(arg0_4.stones, iter6_4)
				setActive(var9_4.tf, false)
				arg0_4:returnItem(var9_4, arg0_4.stonePool)
			end
		end
	end

	for iter7_4 = #arg0_4.booms, 1, -1 do
		local var10_4 = arg0_4.booms[iter7_4]
		local var11_4 = arg0_4.booms[iter7_4].tf.anchoredPosition
		local var12_4 = var10_4.bound.points
		local var13_4 = {}

		for iter8_4 = 0, var12_4.Length - 1 do
			local var14_4 = var12_4[iter8_4]

			findTF(var10_4.tf, "zPos/" .. iter8_4 + 1).anchoredPosition = Vector2(var14_4.x, var14_4.y)

			local var15_4 = Vector2(var11_4.x + var14_4.x, var11_4.y + var14_4.y)

			table.insert(var13_4, var15_4)
		end

		var10_4.boundPoints = var13_4

		if var10_4.ready and var10_4.ready > 0 then
			var10_4.ready = var10_4.ready - CastleGameVo.deltaTime

			if var10_4.ready <= 0 then
				var10_4.ready = 0

				setActive(var10_4.tf, true)

				if arg0_4.floorBrokenCallback then
					arg0_4.floorBrokenCallback(var10_4.useIndex, 0.5)
				end
			end
		elseif var10_4.brokenTime and var10_4.brokenTime > 0 then
			var10_4.brokenTime = var10_4.brokenTime - CastleGameVo.deltaTime

			if var10_4.brokenTime < 0 then
				var10_4.broken = true
				var10_4.brokenTime = 0

				setActive(var10_4.tf, false)

				local var16_4 = table.remove(arg0_4.booms, iter7_4)

				arg0_4:returnItem(var16_4, arg0_4.boomPool)
			end
		end
	end
end

function var0_0.appearStone(arg0_6, arg1_6)
	local var0_6
	local var1_6 = {}
	local var2_6 = arg0_6:getItemActiveIndex()

	for iter0_6 = 1, #var2_6 do
		if not table.contains(arg1_6, var2_6[iter0_6]) then
			table.insert(var1_6, var2_6[iter0_6])
		end
	end

	if #var1_6 == 0 then
		return
	end

	if #arg0_6.stonePool > 0 then
		var0_6 = table.remove(arg0_6.stonePool, 1)
	else
		local var3_6 = tf(instantiate(arg0_6._stoneTpl))

		setParent(var3_6, arg0_6._content)

		local var4_6 = GetComponent(findTF(var3_6, "zPos/anim/collider"), typeof(BoxCollider2D))

		var0_6 = {
			tf = var3_6,
			bound = var4_6
		}
	end

	local var5_6 = findTF(var0_6.tf, "zPos/anim/img")
	local var6_6 = var5_6.childCount
	local var7_6 = math.random(1, var6_6) - 1

	for iter1_6 = 0, var6_6 - 1 do
		setActive(var5_6:GetChild(iter1_6), iter1_6 == var7_6)
	end

	var0_6.ready = CastleGameVo.item_ready_time
	var0_6.brokenTime = CastleGameVo.stone_broken_time

	local var8_6 = var1_6[math.random(1, #var1_6)]
	local var9_6 = var8_6 % CastleGameVo.w_count
	local var10_6 = math.floor(var8_6 / CastleGameVo.w_count)

	var0_6.tf.anchoredPosition = CastleGameVo.GetRotationPosByWH(var9_6, var10_6)

	setActive(var0_6.tf, false)

	var0_6.index = var8_6
	var0_6.useIndex = {
		var8_6
	}

	if arg0_6.itemRemindCallback then
		arg0_6.itemRemindCallback({
			{
				w = var9_6,
				h = var10_6,
				type = CastleGameRemind.remind_type_1
			}
		})
	end

	table.insert(arg0_6.stones, var0_6)
end

function var0_0.returnItem(arg0_7, arg1_7, arg2_7)
	if arg0_7.itemChangeCallback then
		arg0_7.itemChangeCallback(arg1_7, false)
	end

	table.insert(arg2_7, arg1_7)
end

function var0_0.appearBubble(arg0_8, arg1_8)
	for iter0_8 = 1, arg1_8 do
		local var0_8
		local var1_8 = arg0_8:getItemActiveIndex()

		if #var1_8 == 0 then
			return
		end

		if #arg0_8.bubblePool > 0 then
			var0_8 = table.remove(arg0_8.bubblePool, 1)
		else
			local var2_8 = tf(instantiate(arg0_8._bubbleTpl))
			local var3_8 = findTF(var2_8, "zPos/pos")
			local var4_8 = GetComponent(findTF(var2_8, "zPos/spine1"), typeof(SpineAnimUI))
			local var5_8 = GetComponent(findTF(var2_8, "zPos/spine2"), typeof(SpineAnimUI))
			local var6_8 = GetComponent(findTF(var2_8, "zPos/collider"), typeof(BoxCollider2D))
			local var7_8 = var2_8:InverseTransformPoint(var6_8.bounds.min)
			local var8_8 = var2_8:InverseTransformPoint(var6_8.bounds.max)

			setParent(var2_8, arg0_8._content)

			var0_8 = {
				tf = var2_8,
				anims = {
					var4_8,
					var5_8
				},
				bound = var6_8,
				pos = var3_8,
				bmin = var7_8,
				bmax = var8_8
			}
		end

		local var9_8 = var1_8[math.random(1, #var1_8)]
		local var10_8 = var9_8 % CastleGameVo.w_count
		local var11_8 = math.floor(var9_8 / CastleGameVo.w_count)

		var0_8.start = CastleGameVo.GetRotationPosByWH(var10_8, var11_8)
		var0_8.start.y = var0_8.start.y + var5_0
		var0_8.tf.anchoredPosition = var0_8.start

		setActive(var0_8.tf, false)

		var0_8.ready = CastleGameVo.bubble_ready_time
		var0_8.broken = false
		var0_8.brokenTime = CastleGameVo.bubble_broken_time
		var0_8.useIndex = {
			var9_8
		}
		var0_8.index = var9_8

		if arg0_8.itemChangeCallback then
			arg0_8.itemChangeCallback(var0_8, true)
		end

		setActive(var0_8.tf, false)
		table.insert(arg0_8.bubbles, var0_8)
		arg0_8:changeAnimAction(var0_8.anims, var8_0, -1)
	end
end

function var0_0.appearBoom(arg0_9)
	local var0_9 = {}
	local var1_9 = arg0_9:getItemActiveIndex()

	for iter0_9 = 1, #var1_9 do
		local var2_9 = var1_9[iter0_9]

		if var2_9 % CastleGameVo.w_count ~= CastleGameVo.w_count - 1 then
			local var3_9 = var2_9 + 1
			local var4_9 = var2_9 + CastleGameVo.w_count
			local var5_9 = var2_9 + 1 + CastleGameVo.w_count

			if table.contains(var1_9, var3_9) and table.contains(var1_9, var4_9) and table.contains(var1_9, var5_9) then
				table.insert(var0_9, var2_9)
			end
		end
	end

	local var6_9 = var0_9[math.random(1, #var0_9)]

	if #var0_9 == 0 then
		return
	end

	local var7_9

	if #arg0_9.boomPool > 0 then
		var7_9 = table.remove(arg0_9.boomPool, 1)
	else
		local var8_9 = tf(instantiate(arg0_9._boomTpl))
		local var9_9 = GetComponent(findTF(var8_9, "zPos/collider"), typeof("UnityEngine.PolygonCollider2D"))

		setParent(var8_9, arg0_9._content)

		var7_9 = {
			tf = var8_9,
			bound = var9_9
		}
	end

	local var10_9 = var6_9 % CastleGameVo.w_count
	local var11_9 = math.floor(var6_9 / CastleGameVo.w_count)
	local var12_9 = CastleGameVo.GetRotationPosByWH(var10_9, var11_9)

	var12_9.x = var12_9.x + var9_0
	var12_9.y = var12_9.y + var10_0
	var7_9.tf.anchoredPosition = var12_9
	var7_9.ready = CastleGameVo.item_ready_time
	var7_9.broken = false

	setActive(var7_9.tf, false)

	var7_9.index = var6_9
	var7_9.useIndex = {
		var6_9,
		var6_9 + 1,
		var6_9 + CastleGameVo.w_count,
		var6_9 + CastleGameVo.w_count + 1
	}
	var7_9.brokenTime = 1.5

	if arg0_9.itemChangeCallback then
		arg0_9.itemChangeCallback(var7_9, true)
	end

	if arg0_9.itemRemindCallback then
		arg0_9.itemRemindCallback({
			{
				w = var10_9,
				h = var11_9,
				type = CastleGameRemind.remind_type_2
			}
		})
	end

	table.insert(arg0_9.booms, var7_9)
end

function var0_0.setFloorBroken(arg0_10, arg1_10)
	arg0_10.floorBrokenCallback = arg1_10
end

function var0_0.setBubbleBroken(arg0_11, arg1_11)
	arg0_11.bubbleBrokenCallback = arg1_11
end

function var0_0.setItemChange(arg0_12, arg1_12)
	arg0_12.itemChangeCallback = arg1_12
end

function var0_0.setFloorIndexs(arg0_13, arg1_13)
	arg0_13.floorIndexs = arg1_13
end

function var0_0.getItemActiveIndex(arg0_14)
	local var0_14 = {}
	local var1_14 = {}

	for iter0_14 = 1, #arg0_14.bubbles do
		for iter1_14, iter2_14 in ipairs(arg0_14.bubbles[iter0_14].useIndex) do
			table.insert(var1_14, iter2_14)
		end
	end

	for iter3_14 = 1, #arg0_14.booms do
		for iter4_14, iter5_14 in ipairs(arg0_14.booms[iter3_14].useIndex) do
			table.insert(var1_14, iter5_14)
		end
	end

	for iter6_14 = 1, #arg0_14.stones do
		for iter7_14, iter8_14 in ipairs(arg0_14.stones[iter6_14].useIndex) do
			table.insert(var1_14, iter8_14)
		end
	end

	for iter9_14 = 1, #arg0_14.floorIndexs do
		local var2_14 = arg0_14.floorIndexs[iter9_14]

		if not table.contains(var1_14, var2_14) then
			table.insert(var0_14, var2_14)
		end
	end

	return var0_14
end

function var0_0.appearCarriage(arg0_15)
	local var0_15

	if #arg0_15.carriagePool > 0 then
		var0_15 = table.remove(arg0_15.carriagePool, 1)
	else
		local var1_15 = tf(instantiate(arg0_15._carriageTpl))
		local var2_15 = GetComponent(findTF(var1_15, "zPos/spine"), typeof(SpineAnimUI))
		local var3_15 = GetComponent(findTF(var1_15, "zPos/collider"), typeof(BoxCollider2D))
		local var4_15 = var1_15:InverseTransformPoint(var3_15.bounds.min)
		local var5_15 = var1_15:InverseTransformPoint(var3_15.bounds.max)

		setParent(var1_15, arg0_15._content)

		var0_15 = {
			tf = var1_15,
			bound = var3_15,
			anims = {
				var2_15
			},
			bmin = var4_15,
			bmax = var5_15
		}
	end

	local var6_15 = arg0_15:getCarriageRoadlist()

	if #var6_15 > 0 then
		local var7_15 = var6_15[math.random(1, #var6_15)]
		local var8_15 = var7_15.w
		local var9_15 = var7_15.h
		local var10_15 = var7_15.target_w
		local var11_15 = var7_15.target_h
		local var12_15 = var7_15.scale

		var0_15.w = var8_15
		var0_15.h = var9_15
		var0_15.target_w = var10_15
		var0_15.target_h = var11_15
		findTF(var0_15.tf, "zPos").localScale = var12_15
		var0_15.start = CastleGameVo.GetRotationPosByWH(var0_15.w, var0_15.h)
		var0_15.start.y = var0_15.start.y + var1_0
		var0_15.target = CastleGameVo.GetRotationPosByWH(var0_15.target_w, var0_15.target_h)
		var0_15.target.y = var0_15.target.y + var1_0
		var0_15.tf.anchoredPosition = var0_15.start
		var0_15.ready = CastleGameVo.item_ready_time

		setActive(var0_15.tf, false)
		setActive(var0_15.tf, true)

		local var13_15, var14_15 = arg0_15:countSpeed(var0_15.start, var0_15.target)

		var0_15.speed = var13_15
		var0_15.direct = var14_15

		if arg0_15.itemChangeCallback then
			arg0_15.itemChangeCallback(var0_15, true)
		end

		table.insert(arg0_15.carriages, var0_15)
	else
		print("当前不存在可以出现马车的位置")
	end
end

function var0_0.getCarriageRoadlist(arg0_16)
	local var0_16 = {}

	for iter0_16 = 0, CastleGameVo.w_count - 1 do
		local var1_16 = true

		for iter1_16 = 0, CastleGameVo.h_count - 1 do
			local var2_16 = iter0_16 + iter1_16 * CastleGameVo.w_count

			if var1_16 and not table.contains(arg0_16.floorIndexs, var2_16) then
				var1_16 = false
			end
		end

		if var1_16 then
			table.insert(var0_16, {
				h = -1,
				w = iter0_16,
				target_w = iter0_16,
				target_h = CastleGameVo.h_count,
				scale = Vector3(-1, 1, 1)
			})
		end
	end

	for iter2_16 = 0, CastleGameVo.h_count - 1 do
		local var3_16 = true

		for iter3_16 = 0, CastleGameVo.w_count - 1 do
			local var4_16 = iter3_16 + iter2_16 * CastleGameVo.w_count

			if var3_16 and not table.contains(arg0_16.floorIndexs, var4_16) then
				var3_16 = false
			end
		end

		if var3_16 then
			table.insert(var0_16, {
				w = -1,
				h = iter2_16,
				target_w = CastleGameVo.w_count,
				target_h = iter2_16,
				scale = Vector3(1, 1, 1)
			})
		end
	end

	return var0_16
end

function var0_0.setItemRemindCallback(arg0_17, arg1_17)
	arg0_17.itemRemindCallback = arg1_17
end

function var0_0.countSpeed(arg0_18, arg1_18, arg2_18)
	local var0_18 = math.atan(math.abs(arg2_18.y - arg1_18.y) / math.abs(arg2_18.x - arg1_18.x))
	local var1_18 = arg2_18.x > arg1_18.x and 1 or -1
	local var2_18 = arg2_18.y > arg1_18.y and 1 or -1
	local var3_18 = math.cos(var0_18) * var1_18
	local var4_18 = math.sin(var0_18) * var2_18

	return Vector2(var3_18, var4_18), Vector2(var1_18, var2_18)
end

function var0_0.changeAnimAction(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19)
	local var0_19 = 0

	for iter0_19 = 1, #arg1_19 do
		local var1_19 = arg1_19[iter0_19]

		var1_19:SetActionCallBack(nil)
		var1_19:SetAction(arg2_19, 0)
		var1_19:SetActionCallBack(function(arg0_20)
			if arg0_20 == "finish" then
				if arg3_19 == 1 then
					var1_19:SetActionCallBack(nil)
					var1_19:SetAction(arg4_19, 0)
				end

				if arg5_19 and var0_19 == 0 then
					var0_19 = 1

					arg5_19()
				end
			end
		end)

		if arg3_19 ~= 1 and arg5_19 and var0_19 == 0 then
			var0_19 = 1

			arg5_19()
		end
	end
end

function var0_0.playerInBubble(arg0_21, arg1_21, arg2_21)
	arg1_21.char = arg2_21
end

function var0_0.getBooms(arg0_22)
	return arg0_22.booms
end

function var0_0.getBubbles(arg0_23)
	return arg0_23.bubbles
end

function var0_0.getCarriages(arg0_24)
	return arg0_24.carriages
end

function var0_0.clear(arg0_25)
	return
end

return var0_0
