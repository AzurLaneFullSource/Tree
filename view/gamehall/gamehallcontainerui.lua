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

function var0_0.Ctor(arg0_1)
	local var0_1 = getProxy(BayProxy):getShips()

	arg0_1.shipNames = {}

	for iter0_1 = 1, #var0_1 do
		if not table.contains(arg0_1.shipNames, var0_1[iter0_1].name) then
			table.insert(arg0_1.shipNames, var0_1[iter0_1]:getPrefab())
		end
	end

	if var1_0 > #arg0_1.shipNames then
		var1_0 = #arg0_1.shipNames
	end
end

function var0_0.InitUI(arg0_2, arg1_2)
	arg0_2.container = arg1_2

	local var0_2 = pg.UIMgr.GetInstance().uiCamera.gameObject.transform:Find("Canvas").sizeDelta.x - var10_0
	local var1_2 = var10_0 - var9_0 + var0_2

	var7_0 = {
		var1_2,
		0
	}
	var8_0 = {
		0,
		0
	}
	arg0_2.container = arg1_2
	arg0_2.content = findTF(arg0_2.container, "content")
	arg0_2.pos = findTF(arg0_2.content, "pos")
	arg0_2.boundContainer = findTF(arg0_2.content, "bound")
	arg0_2.charContentEvents = {}
	arg0_2.charContentCollider = {}
	arg0_2.items = {}

	for iter0_2 = 0, arg0_2.pos.childCount - 1 do
		table.insert(arg0_2.items, arg0_2.pos:GetChild(iter0_2))
	end

	arg0_2.sitItems = {}

	for iter1_2 = 1, #var12_0 do
		local var2_2 = var12_0[iter1_2]
		local var3_2 = findTF(arg0_2.pos, var2_2.pos)
		local var4_2 = GetComponent(findTF(arg0_2.pos, var2_2.spine), typeof(SpineAnimUI))
		local var5_2 = GetComponent(findTF(arg0_2.pos, var2_2.bound), typeof(BoxCollider2D))
		local var6_2 = arg0_2.pos:InverseTransformPoint(var5_2.bounds.min)
		local var7_2 = arg0_2.pos:InverseTransformPoint(var5_2.bounds.max)

		table.insert(arg0_2.sitItems, {
			sit = false,
			pos = var3_2,
			min = var6_2,
			max = var7_2,
			anim = var4_2
		})
	end

	arg0_2.chars = {}

	for iter2_2 = 1, var1_0 do
		local var8_2 = iter2_2
		local var9_2 = table.remove(arg0_2.shipNames, math.random(1, #arg0_2.shipNames))
		local var10_2 = SpineAnimChar.New()

		var10_2:SetPaint(var9_2)
		var10_2:Load(true, function(arg0_3)
			arg0_3:SetAction("stand2", 0)
			arg0_3:SetParent(arg0_2.pos)
			arg0_3:SetLocalScale(var2_0)

			local var0_3 = findTF(arg0_2.boundContainer, tostring(var8_2))
			local var1_3 = GetComponent(var0_3, typeof(BoxCollider2D))
			local var2_3 = arg0_2.pos:InverseTransformPoint(var1_3.bounds.min)
			local var3_3 = arg0_2.pos:InverseTransformPoint(var1_3.bounds.max)

			arg0_3:SetAnchoredPosition(arg0_2:getTargetPos(var2_3, var3_3))
			table.insert(arg0_2.chars, {
				model = arg0_3,
				vel = Vector2(0, 0),
				bound = {
					var2_3.x,
					var2_3.y,
					var3_3.x,
					var3_3.y
				},
				min = var2_3,
				max = var3_3,
				pos = arg0_3:GetAnchoredPosition(),
				curScale = arg0_3:GetLocalScale()
			})
			table.insert(arg0_2.items, tf(arg0_3:GetModel()))
		end)
	end

	arg0_2.bataiTf = findTF(arg0_2.pos, "batai")
	arg0_2.coinChar = nil

	PoolMgr.GetInstance():GetSpineChar(var3_0, true, function(arg0_4)
		arg0_2.coinChar = tf(arg0_4)

		tf(arg0_4):GetComponent(typeof(SpineAnimUI)):SetAction("stand2", 0)
		setParent(tf(arg0_4), findTF(arg0_2.bataiTf, "char"))
		setLocalScale(arg0_4, var2_0)
	end)

	arg0_2.content.anchoredPosition = Vector2(0, 0)

	local var11_2 = GetOrAddComponent(arg0_2.content, typeof(EventTriggerListener))

	arg0_2.velocityXSmoothing = Vector2(0, 0)
	arg0_2.offsetPosition = arg0_2.content.anchoredPosition

	var11_2:AddBeginDragFunc(function(arg0_5, arg1_5)
		arg0_2.prevPosition = arg1_5.position
		arg0_2.scenePosition = arg0_2.content.anchoredPosition
		arg0_2.velocityXSmoothing = Vector2(0, 0)
		arg0_2.offsetPosition = arg0_2.content.anchoredPosition
	end)
	var11_2:AddDragFunc(function(arg0_6, arg1_6)
		arg0_2.offsetPosition.x = arg1_6.position.x - arg0_2.prevPosition.x + arg0_2.scenePosition.x
		arg0_2.offsetPosition.y = arg1_6.position.y - arg0_2.prevPosition.y + arg0_2.scenePosition.y
		arg0_2.offsetPosition.x = arg0_2.offsetPosition.x > var7_0[2] and var7_0[2] or arg0_2.offsetPosition.x
		arg0_2.offsetPosition.x = arg0_2.offsetPosition.x < var7_0[1] and var7_0[1] or arg0_2.offsetPosition.x
		arg0_2.offsetPosition.y = arg0_2.offsetPosition.y > var8_0[2] and var8_0[2] or arg0_2.offsetPosition.y
		arg0_2.offsetPosition.y = arg0_2.offsetPosition.y < var8_0[1] and var8_0[1] or arg0_2.offsetPosition.y
	end)
	var11_2:AddDragEndFunc(function(arg0_7, arg1_7)
		return
	end)

	arg0_2.clickItems = {}

	for iter3_2 = 1, #var11_0 do
		local var12_2 = findTF(arg0_2.pos, var11_0[iter3_2][1])
		local var13_2 = GetComponent(findTF(arg0_2.pos, var11_0[iter3_2][2]), typeof(SpineAnimUI))

		table.insert(arg0_2.clickItems, {
			time = 0,
			tf = var12_2,
			anim = var13_2
		})
		onButton(arg0_2._event, var12_2, function()
			if arg0_2:checkClickTime(var13_2) then
				arg0_2:setAnimAction(var13_2, "action", 1, "normal")
			end
		end)
	end
end

function var0_0.setCharSit(arg0_9, arg1_9, arg2_9)
	if arg1_9.sitFlag or arg2_9.sitFlag then
		return
	end

	local var0_9 = arg1_9.model
	local var1_9 = arg2_9.pos
	local var2_9 = arg2_9.anim

	arg1_9.model:SetLocalScale(var2_0)
	arg0_9:setCharAction(var0_9, "sit", 0, nil)
	arg0_9:setAnimAction(var2_9, "sit", 0, nil)

	arg1_9.curAction = "sit"
	arg2_9.curAction = "sit"
	arg1_9.target = nil
	arg1_9.sitItem = arg2_9
	arg1_9.sitFlag = true
	arg1_9.time = math.random(10, 20)
	arg1_9.vel = Vector2(0, 0)
	arg2_9.sitFlag = true

	arg1_9.model:SetParent(var1_9)
	arg1_9.model:SetAnchoredPosition(Vector2(0, 0))
end

function var0_0.stopCharSit(arg0_10, arg1_10)
	arg1_10.sitItem.sitFlag = false

	arg0_10:setCharAction(arg1_10.model, "walk", 0, nil)
	arg0_10:setAnimAction(arg1_10.sitItem.anim, "normal", 0, nil)

	arg1_10.sitItem = nil
	arg1_10.sitFlag = false

	arg1_10.model:SetParent(arg0_10.pos)
	arg1_10.model:SetAnchoredPosition(arg1_10.pos)
end

function var0_0.checkClickTime(arg0_11, arg1_11)
	for iter0_11 = 1, #arg0_11.clickItems do
		if arg0_11.clickItems[iter0_11].anim == arg1_11 and (arg0_11.clickItems[iter0_11].time == 0 or Time.realtimeSinceStartup > arg0_11.clickItems[iter0_11].time) then
			arg0_11.clickItems[iter0_11].time = Time.realtimeSinceStartup + 2

			return true
		end
	end

	return false
end

function var0_0.step(arg0_12)
	arg0_12.content.anchoredPosition, arg0_12.velocityXSmoothing = Vector2.SmoothDamp(arg0_12.content.anchoredPosition, arg0_12.offsetPosition, arg0_12.velocityXSmoothing, var4_0)

	for iter0_12 = 1, #arg0_12.chars do
		local var0_12 = arg0_12.chars[iter0_12]
		local var1_12 = var0_12.time
		local var2_12 = var0_12.pos

		if not var1_12 or var1_12 <= 0 then
			if var0_12.sitFlag then
				arg0_12:stopCharSit(var0_12)
			elseif math.random(1, 10) > 5 then
				local var3_12 = arg0_12:getTargetPos(var0_12.min, var0_12.max)

				var0_12.vel, var0_12.target = arg0_12:getVel(var2_12, var3_12), var3_12
			end

			var0_12.time = math.random(1, var6_0)
		end

		if var0_12.target and not var0_12.sitFlag then
			local var4_12 = {
				var0_12.vel.x * var5_0 * Time.deltaTime,
				var0_12.vel.y * var5_0 * Time.deltaTime
			}

			if var4_12[1] ~= 0 then
				var0_12.pos.x = var0_12.pos.x + var4_12[1]
			end

			if var4_12[2] ~= 0 then
				var0_12.pos.y = var0_12.pos.y + var4_12[2]
			end

			local var5_12 = var0_12.bound

			if var0_12.pos.x < var5_12[1] then
				var0_12.pos.x = var5_12[1]
				var0_12.vel.x = 0
			end

			if var0_12.pos.x > var5_12[3] then
				var0_12.pos.x = var5_12[3]
				var0_12.vel.x = 0
			end

			if var0_12.pos.y < var5_12[2] then
				var0_12.pos.y = var5_12[2]
				var0_12.vel.y = 0
			end

			if var0_12.pos.y > var5_12[4] then
				var0_12.pos.y = var5_12[4]
				var0_12.vel.y = 0
			end

			var0_12.model:SetAnchoredPosition(var0_12.pos)

			local var6_12 = var0_12.target

			if math.abs(var0_12.target.x - var0_12.pos.x) < 10 then
				var0_12.vel.x = 0
			end

			if math.abs(var0_12.target.y - var0_12.pos.y) < 10 then
				var0_12.vel.y = 0
			end
		end

		local var7_12 = true
		local var8_12 = var0_12.sitFlag

		if var0_12.vel.x == 0 and var0_12.vel.y == 0 then
			var0_12.time = var0_12.time - Time.deltaTime
			var7_12 = false
		end

		if not var7_12 and var0_12.target then
			var0_12.target = nil
		end

		if not var0_12.sitFlag and not var7_12 then
			var0_12.ableSit = true
		end

		if var0_12.vel.x ~= 0 then
			local var9_12 = var0_12.vel.x > 0 and 1 or -1

			if math.sign(var0_12.curScale.x) ~= var9_12 then
				var0_12.curScale.x = var9_12 * var2_0.x

				var0_12.model:SetLocalScale(var0_12.curScale)
			end
		end

		if var7_12 then
			if var0_12.curAction ~= "walk" then
				var0_12.curAction = "walk"

				var0_12.model:SetAction("walk", 0)
			end
		elseif var8_12 then
			if var0_12.curAction ~= "sit" then
				var0_12.curAction = "sit"

				var0_12.model:SetAction("sit", 0)
			end
		elseif var0_12.curAction ~= "stand2" then
			var0_12.curAction = "stand2"

			var0_12.model:SetAction("stand2", 0)
		end

		if var7_12 then
			arg0_12:checkCharSit(var0_12)
		end
	end

	table.sort(arg0_12.items, function(arg0_13, arg1_13)
		if arg0_13.anchoredPosition.y < arg1_13.anchoredPosition.y then
			return true
		end
	end)

	for iter1_12, iter2_12 in ipairs(arg0_12.items) do
		iter2_12:SetAsFirstSibling()
	end
end

function var0_0.checkCharSit(arg0_14, arg1_14)
	if not arg1_14.ableSit then
		return
	end

	local var0_14 = arg1_14.pos

	for iter0_14 = 1, #arg0_14.sitItems do
		local var1_14 = arg0_14.sitItems[iter0_14]
		local var2_14 = var1_14.min
		local var3_14 = var1_14.max

		if var0_14.x > var2_14.x and var0_14.x < var3_14.x and var0_14.y > var2_14.y and var0_14.y < var3_14.y then
			if math.random(1, 10) > 7 then
				print("角色想坐下")
				arg0_14:setCharSit(arg1_14, var1_14)
			else
				arg1_14.ableSit = false

				print("角色不想坐下")
			end
		end
	end
end

function var0_0.getVel(arg0_15, arg1_15, arg2_15)
	local var0_15 = math.atan(math.abs(arg2_15.y - arg1_15.y) / math.abs(arg2_15.x - arg1_15.x))
	local var1_15 = arg2_15.x > arg1_15.x and 1 or -1
	local var2_15 = arg2_15.y > arg1_15.y and 1 or -1
	local var3_15 = math.cos(var0_15) * var1_15
	local var4_15 = math.sin(var0_15) * var2_15

	return Vector2(var3_15, var4_15)
end

function var0_0.setCharAction(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	arg1_16:SetActionCallBack(nil)
	arg1_16:SetAction(arg2_16, 0)
	arg1_16:SetActionCallBack(function(arg0_17)
		if arg0_17 == "finish" and arg3_16 == 1 then
			arg1_16:SetActionCallBack(nil)
			arg1_16:SetAction(arg4_16, 0)
		end
	end)
end

function var0_0.setAnimAction(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	arg1_18:SetActionCallBack(nil)
	arg1_18:SetAction(arg2_18, 0)
	arg1_18:SetActionCallBack(function(arg0_19)
		if arg0_19 == "finish" and arg3_18 == 1 then
			arg1_18:SetActionCallBack(nil)
			arg1_18:SetAction(arg4_18, 0)
		end
	end)
end

function var0_0.getTargetPos(arg0_20, arg1_20, arg2_20)
	local var0_20 = tonumber(arg2_20.x) - tonumber(arg1_20.x)
	local var1_20 = tonumber(arg2_20.y) - tonumber(arg1_20.y)

	return Vector2(arg1_20.x + math.random(1, var0_20), arg1_20.y + math.random(1, var1_20))
end

function var0_0.isPointInMatrix(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21, arg5_21)
	return arg0_21:getCross(arg1_21, arg2_21, arg5_21) * arg0_21:getCross(arg3_21, arg4_21, arg5_21) >= 0 and arg0_21:getCross(arg2_21, arg3_21, arg5_21) * arg0_21:getCross(arg4_21, arg1_21, arg5_21) >= 0
end

function var0_0.Dispose(arg0_22)
	if arg0_22.coinChar then
		PoolMgr.GetInstance():ReturnSpineChar(var3_0, go(arg0_22.coinChar))

		arg0_22.coinChar = nil
	end

	if arg0_22.chars and #arg0_22.chars > 0 then
		for iter0_22 = 1, #arg0_22.chars do
			arg0_22.chars[iter0_22].model:Dispose()
		end

		arg0_22.chars = nil
	end
end

return var0_0
