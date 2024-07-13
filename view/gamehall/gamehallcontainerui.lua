local var0_0 = class("GameHallContainerUI")
local var1_0 = 4
local var2_0 = Vector3(0.7, 0.7, 0.7)
local var3_0 = "mingshi"
local var4_0 = 0.1
local var5_0 = 100
local var6_0 = 4
local var7_0
local var8_0
local var9_0 = 3256
local var10_0 = 1920
local var11_0 = {
	{
		"item3",
		"item3/spine"
	}
}
local var12_0 = {
	{
		bound = "item1/spine/bound",
		pos = "item1/spine/pos",
		spine = "item1/spine"
	},
	{
		bound = "item2/spine2/bound",
		pos = "item2/spine2/pos",
		spine = "item2/spine2"
	},
	{
		bound = "item2/spine3/bound",
		pos = "item2/spine3/pos",
		spine = "item2/spine3"
	},
	{
		bound = "item4/spine1/bound",
		pos = "item4/spine1/pos",
		spine = "item4/spine1"
	},
	{
		bound = "item4/spine2/bound",
		pos = "item4/spine2/pos",
		spine = "item4/spine2"
	},
	{
		bound = "item6/spine1/bound",
		pos = "item6/spine1/pos",
		spine = "item6/spine1"
	},
	{
		bound = "item6/spine2/bound",
		pos = "item6/spine2/pos",
		spine = "item6/spine2"
	}
}

function var0_0.Ctor(arg0_1, arg1_1)
	local var0_1 = pg.UIMgr.GetInstance().uiCamera.gameObject.transform:Find("Canvas").sizeDelta.x - var10_0
	local var1_1 = var10_0 - var9_0 + var0_1

	var7_0 = {
		var1_1,
		0
	}
	var8_0 = {
		0,
		0
	}
	arg0_1.container = arg1_1
	arg0_1.content = findTF(arg0_1.container, "content")
	arg0_1.pos = findTF(arg0_1.content, "pos")
	arg0_1.boundContainer = findTF(arg0_1.content, "bound")
	arg0_1.charContentEvents = {}
	arg0_1.charContentCollider = {}
	arg0_1.items = {}

	for iter0_1 = 0, arg0_1.pos.childCount - 1 do
		table.insert(arg0_1.items, arg0_1.pos:GetChild(iter0_1))
	end

	arg0_1.sitItems = {}

	for iter1_1 = 1, #var12_0 do
		local var2_1 = var12_0[iter1_1]
		local var3_1 = findTF(arg0_1.pos, var2_1.pos)
		local var4_1 = GetComponent(findTF(arg0_1.pos, var2_1.spine), typeof(SpineAnimUI))

		print(var2_1.bound)

		local var5_1 = GetComponent(findTF(arg0_1.pos, var2_1.bound), typeof(BoxCollider2D))
		local var6_1 = arg0_1.pos:InverseTransformPoint(var5_1.bounds.min)
		local var7_1 = arg0_1.pos:InverseTransformPoint(var5_1.bounds.max)

		table.insert(arg0_1.sitItems, {
			sit = false,
			pos = var3_1,
			min = var6_1,
			max = var7_1,
			anim = var4_1
		})
	end

	local var8_1 = getProxy(BayProxy):getShips()
	local var9_1 = {}

	for iter2_1 = 1, #var8_1 do
		if not table.contains(var9_1, var8_1[iter2_1].name) then
			table.insert(var9_1, var8_1[iter2_1]:getPrefab())
		end
	end

	if var1_0 > #var9_1 then
		var1_0 = #var9_1
	end

	arg0_1.chars = {}

	for iter3_1 = 1, var1_0 do
		local var10_1 = iter3_1
		local var11_1 = table.remove(var9_1, math.random(1, #var9_1))

		PoolMgr.GetInstance():GetSpineChar(var11_1, true, function(arg0_2)
			local var0_2 = tf(arg0_2):GetComponent(typeof(SpineAnimUI))

			var0_2:SetAction("stand2", 0)
			setParent(tf(arg0_2), arg0_1.pos)
			setLocalScale(arg0_2, var2_0)

			local var1_2 = findTF(arg0_1.boundContainer, tostring(var10_1))
			local var2_2 = GetComponent(var1_2, typeof(BoxCollider2D))
			local var3_2 = arg0_1.pos:InverseTransformPoint(var2_2.bounds.min)
			local var4_2 = arg0_1.pos:InverseTransformPoint(var2_2.bounds.max)

			tf(arg0_2).anchoredPosition = arg0_1:getTargetPos(var3_2, var4_2)

			table.insert(arg0_1.chars, {
				tf = tf(arg0_2),
				anim = var0_2,
				vel = Vector2(0, 0),
				bound = {
					var3_2.x,
					var3_2.y,
					var4_2.x,
					var4_2.y
				},
				min = var3_2,
				max = var4_2,
				pos = tf(arg0_2).anchoredPosition,
				curScale = tf(arg0_2).localScale
			})
			table.insert(arg0_1.items, tf(arg0_2))
		end)
	end

	arg0_1.bataiTf = findTF(arg0_1.pos, "batai")
	arg0_1.coinChar = nil

	PoolMgr.GetInstance():GetSpineChar(var3_0, true, function(arg0_3)
		arg0_1.coinChar = tf(arg0_3)

		tf(arg0_3):GetComponent(typeof(SpineAnimUI)):SetAction("stand2", 0)
		setParent(tf(arg0_3), findTF(arg0_1.bataiTf, "char"))
		setLocalScale(arg0_3, var2_0)
	end)

	arg0_1.content.anchoredPosition = Vector2(0, 0)

	local var12_1 = GetOrAddComponent(arg0_1.content, typeof(EventTriggerListener))

	arg0_1.velocityXSmoothing = Vector2(0, 0)
	arg0_1.offsetPosition = arg0_1.content.anchoredPosition

	var12_1:AddBeginDragFunc(function(arg0_4, arg1_4)
		arg0_1.prevPosition = arg1_4.position
		arg0_1.scenePosition = arg0_1.content.anchoredPosition
		arg0_1.velocityXSmoothing = Vector2(0, 0)
		arg0_1.offsetPosition = arg0_1.content.anchoredPosition
	end)
	var12_1:AddDragFunc(function(arg0_5, arg1_5)
		arg0_1.offsetPosition.x = arg1_5.position.x - arg0_1.prevPosition.x + arg0_1.scenePosition.x
		arg0_1.offsetPosition.y = arg1_5.position.y - arg0_1.prevPosition.y + arg0_1.scenePosition.y
		arg0_1.offsetPosition.x = arg0_1.offsetPosition.x > var7_0[2] and var7_0[2] or arg0_1.offsetPosition.x
		arg0_1.offsetPosition.x = arg0_1.offsetPosition.x < var7_0[1] and var7_0[1] or arg0_1.offsetPosition.x
		arg0_1.offsetPosition.y = arg0_1.offsetPosition.y > var8_0[2] and var8_0[2] or arg0_1.offsetPosition.y
		arg0_1.offsetPosition.y = arg0_1.offsetPosition.y < var8_0[1] and var8_0[1] or arg0_1.offsetPosition.y
	end)
	var12_1:AddDragEndFunc(function(arg0_6, arg1_6)
		return
	end)

	arg0_1.clickItems = {}

	for iter4_1 = 1, #var11_0 do
		local var13_1 = findTF(arg0_1.pos, var11_0[iter4_1][1])
		local var14_1 = GetComponent(findTF(arg0_1.pos, var11_0[iter4_1][2]), typeof(SpineAnimUI))

		table.insert(arg0_1.clickItems, {
			time = 0,
			tf = var13_1,
			anim = var14_1
		})
		onButton(arg0_1._event, var13_1, function()
			if arg0_1:checkClickTime(var14_1) then
				arg0_1:setAnimAction(var14_1, "action", 1, "normal")
			end
		end)
	end
end

function var0_0.setCharSit(arg0_8, arg1_8, arg2_8)
	if arg1_8.sitFlag or arg2_8.sitFlag then
		return
	end

	local var0_8 = arg1_8.tf
	local var1_8 = arg1_8.anim
	local var2_8 = arg2_8.pos
	local var3_8 = arg2_8.anim

	arg0_8:setAnimAction(var1_8, "sit", 0, nil)
	arg0_8:setAnimAction(var3_8, "sit", 0, nil)

	arg1_8.curAction = "sit"
	arg2_8.curAction = "sit"
	arg1_8.target = nil
	arg1_8.sitItem = arg2_8
	arg1_8.sitFlag = true
	arg1_8.time = math.random(10, 20)
	arg1_8.tf.localScale = var2_0
	arg1_8.vel = Vector2(0, 0)
	arg2_8.sitFlag = true

	setParent(arg1_8.tf, var2_8)

	arg1_8.tf.anchoredPosition = Vector2(0, 0)
end

function var0_0.stopCharSit(arg0_9, arg1_9)
	arg1_9.sitItem.sitFlag = false

	arg0_9:setAnimAction(arg1_9.anim, "walk", 0, nil)
	arg0_9:setAnimAction(arg1_9.sitItem.anim, "normal", 0, nil)

	arg1_9.sitItem = nil
	arg1_9.sitFlag = false

	setParent(arg1_9.tf, arg0_9.pos)

	arg1_9.tf.anchoredPosition = arg1_9.pos
end

function var0_0.checkClickTime(arg0_10, arg1_10)
	for iter0_10 = 1, #arg0_10.clickItems do
		if arg0_10.clickItems[iter0_10].anim == arg1_10 and (arg0_10.clickItems[iter0_10].time == 0 or Time.realtimeSinceStartup > arg0_10.clickItems[iter0_10].time) then
			arg0_10.clickItems[iter0_10].time = Time.realtimeSinceStartup + 2

			return true
		end
	end

	return false
end

function var0_0.step(arg0_11)
	arg0_11.content.anchoredPosition, arg0_11.velocityXSmoothing = Vector2.SmoothDamp(arg0_11.content.anchoredPosition, arg0_11.offsetPosition, arg0_11.velocityXSmoothing, var4_0)

	for iter0_11 = 1, #arg0_11.chars do
		local var0_11 = arg0_11.chars[iter0_11]
		local var1_11 = var0_11.time
		local var2_11 = var0_11.pos

		if not var1_11 or var1_11 <= 0 then
			if var0_11.sitFlag then
				arg0_11:stopCharSit(var0_11)
			elseif math.random(1, 10) > 5 then
				local var3_11 = arg0_11:getTargetPos(var0_11.min, var0_11.max)

				var0_11.vel, var0_11.target = arg0_11:getVel(var2_11, var3_11), var3_11
			end

			var0_11.time = math.random(1, var6_0)
		end

		if var0_11.target and not var0_11.sitFlag then
			local var4_11 = {
				var0_11.vel.x * var5_0 * Time.deltaTime,
				var0_11.vel.y * var5_0 * Time.deltaTime
			}

			if var4_11[1] ~= 0 then
				var0_11.pos.x = var0_11.pos.x + var4_11[1]
			end

			if var4_11[2] ~= 0 then
				var0_11.pos.y = var0_11.pos.y + var4_11[2]
			end

			local var5_11 = var0_11.bound

			if var0_11.pos.x < var5_11[1] then
				var0_11.pos.x = var5_11[1]
				var0_11.vel.x = 0
			end

			if var0_11.pos.x > var5_11[3] then
				var0_11.pos.x = var5_11[3]
				var0_11.vel.x = 0
			end

			if var0_11.pos.y < var5_11[2] then
				var0_11.pos.y = var5_11[2]
				var0_11.vel.y = 0
			end

			if var0_11.pos.y > var5_11[4] then
				var0_11.pos.y = var5_11[4]
				var0_11.vel.y = 0
			end

			var0_11.tf.anchoredPosition = var0_11.pos

			local var6_11 = var0_11.target

			if math.abs(var0_11.target.x - var0_11.pos.x) < 10 then
				var0_11.vel.x = 0
			end

			if math.abs(var0_11.target.y - var0_11.pos.y) < 10 then
				var0_11.vel.y = 0
			end
		end

		local var7_11 = true
		local var8_11 = var0_11.sitFlag

		if var0_11.vel.x == 0 and var0_11.vel.y == 0 then
			var0_11.time = var0_11.time - Time.deltaTime
			var7_11 = false
		end

		if not var7_11 and var0_11.target then
			var0_11.target = nil
		end

		if not var0_11.sitFlag and not var7_11 then
			var0_11.ableSit = true
		end

		if var7_11 then
			if var0_11.curAction ~= "walk" then
				var0_11.curAction = "walk"

				var0_11.anim:SetAction("walk", 0)
			end
		elseif var8_11 then
			if var0_11.curAction ~= "sit" then
				var0_11.curAction = "sit"

				var0_11.anim:SetAction("sit", 0)
			end
		elseif var0_11.curAction ~= "stand2" then
			var0_11.curAction = "stand2"

			var0_11.anim:SetAction("stand2", 0)
		end

		if var0_11.vel.x ~= 0 then
			local var9_11 = var0_11.vel.x > 0 and 1 or -1

			if var0_11.curScale.x ~= var9_11 then
				var0_11.curScale.x = var9_11 * var2_0.x
				var0_11.tf.localScale = var0_11.curScale
			end
		end

		if var7_11 then
			arg0_11:checkCharSit(var0_11)
		end
	end

	table.sort(arg0_11.items, function(arg0_12, arg1_12)
		if arg0_12.anchoredPosition.y < arg1_12.anchoredPosition.y then
			return true
		end
	end)

	for iter1_11, iter2_11 in ipairs(arg0_11.items) do
		iter2_11:SetAsFirstSibling()
	end
end

function var0_0.checkCharSit(arg0_13, arg1_13)
	if not arg1_13.ableSit then
		return
	end

	local var0_13 = arg1_13.pos

	for iter0_13 = 1, #arg0_13.sitItems do
		local var1_13 = arg0_13.sitItems[iter0_13]
		local var2_13 = var1_13.min
		local var3_13 = var1_13.max

		if var0_13.x > var2_13.x and var0_13.x < var3_13.x and var0_13.y > var2_13.y and var0_13.y < var3_13.y then
			if math.random(1, 10) > 7 then
				print("角色想坐下")
				arg0_13:setCharSit(arg1_13, var1_13)
			else
				arg1_13.ableSit = false

				print("角色不想坐下")
			end
		end
	end
end

function var0_0.getVel(arg0_14, arg1_14, arg2_14)
	local var0_14 = math.atan(math.abs(arg2_14.y - arg1_14.y) / math.abs(arg2_14.x - arg1_14.x))
	local var1_14 = arg2_14.x > arg1_14.x and 1 or -1
	local var2_14 = arg2_14.y > arg1_14.y and 1 or -1
	local var3_14 = math.cos(var0_14) * var1_14
	local var4_14 = math.sin(var0_14) * var2_14

	return Vector2(var3_14, var4_14)
end

function var0_0.setAnimAction(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	arg1_15:SetActionCallBack(nil)
	arg1_15:SetAction(arg2_15, 0)
	arg1_15:SetActionCallBack(function(arg0_16)
		if arg0_16 == "finish" and arg3_15 == 1 then
			arg1_15:SetActionCallBack(nil)
			arg1_15:SetAction(arg4_15, 0)
		end
	end)
end

function var0_0.getTargetPos(arg0_17, arg1_17, arg2_17)
	local var0_17 = tonumber(arg2_17.x) - tonumber(arg1_17.x)
	local var1_17 = tonumber(arg2_17.y) - tonumber(arg1_17.y)

	return Vector2(arg1_17.x + math.random(1, var0_17), arg1_17.y + math.random(1, var1_17))
end

function var0_0.isPointInMatrix(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18, arg5_18)
	return arg0_18:getCross(arg1_18, arg2_18, arg5_18) * arg0_18:getCross(arg3_18, arg4_18, arg5_18) >= 0 and arg0_18:getCross(arg2_18, arg3_18, arg5_18) * arg0_18:getCross(arg4_18, arg1_18, arg5_18) >= 0
end

return var0_0
