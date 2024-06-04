local var0 = class("GameHallContainerUI")
local var1 = 4
local var2 = Vector3(0.7, 0.7, 0.7)
local var3 = "mingshi"
local var4 = 0.1
local var5 = 100
local var6 = 4
local var7
local var8
local var9 = 3256
local var10 = 1920
local var11 = {
	{
		"item3",
		"item3/spine"
	}
}
local var12 = {
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

function var0.Ctor(arg0, arg1)
	local var0 = pg.UIMgr.GetInstance().uiCamera.gameObject.transform:Find("Canvas").sizeDelta.x - var10
	local var1 = var10 - var9 + var0

	var7 = {
		var1,
		0
	}
	var8 = {
		0,
		0
	}
	arg0.container = arg1
	arg0.content = findTF(arg0.container, "content")
	arg0.pos = findTF(arg0.content, "pos")
	arg0.boundContainer = findTF(arg0.content, "bound")
	arg0.charContentEvents = {}
	arg0.charContentCollider = {}
	arg0.items = {}

	for iter0 = 0, arg0.pos.childCount - 1 do
		table.insert(arg0.items, arg0.pos:GetChild(iter0))
	end

	arg0.sitItems = {}

	for iter1 = 1, #var12 do
		local var2 = var12[iter1]
		local var3 = findTF(arg0.pos, var2.pos)
		local var4 = GetComponent(findTF(arg0.pos, var2.spine), typeof(SpineAnimUI))

		print(var2.bound)

		local var5 = GetComponent(findTF(arg0.pos, var2.bound), typeof(BoxCollider2D))
		local var6 = arg0.pos:InverseTransformPoint(var5.bounds.min)
		local var7 = arg0.pos:InverseTransformPoint(var5.bounds.max)

		table.insert(arg0.sitItems, {
			sit = false,
			pos = var3,
			min = var6,
			max = var7,
			anim = var4
		})
	end

	local var8 = getProxy(BayProxy):getShips()
	local var9 = {}

	for iter2 = 1, #var8 do
		if not table.contains(var9, var8[iter2].name) then
			table.insert(var9, var8[iter2]:getPrefab())
		end
	end

	if var1 > #var9 then
		var1 = #var9
	end

	arg0.chars = {}

	for iter3 = 1, var1 do
		local var10 = iter3
		local var11 = table.remove(var9, math.random(1, #var9))

		PoolMgr.GetInstance():GetSpineChar(var11, true, function(arg0)
			local var0 = tf(arg0):GetComponent(typeof(SpineAnimUI))

			var0:SetAction("stand2", 0)
			setParent(tf(arg0), arg0.pos)
			setLocalScale(arg0, var2)

			local var1 = findTF(arg0.boundContainer, tostring(var10))
			local var2 = GetComponent(var1, typeof(BoxCollider2D))
			local var3 = arg0.pos:InverseTransformPoint(var2.bounds.min)
			local var4 = arg0.pos:InverseTransformPoint(var2.bounds.max)

			tf(arg0).anchoredPosition = arg0:getTargetPos(var3, var4)

			table.insert(arg0.chars, {
				tf = tf(arg0),
				anim = var0,
				vel = Vector2(0, 0),
				bound = {
					var3.x,
					var3.y,
					var4.x,
					var4.y
				},
				min = var3,
				max = var4,
				pos = tf(arg0).anchoredPosition,
				curScale = tf(arg0).localScale
			})
			table.insert(arg0.items, tf(arg0))
		end)
	end

	arg0.bataiTf = findTF(arg0.pos, "batai")
	arg0.coinChar = nil

	PoolMgr.GetInstance():GetSpineChar(var3, true, function(arg0)
		arg0.coinChar = tf(arg0)

		tf(arg0):GetComponent(typeof(SpineAnimUI)):SetAction("stand2", 0)
		setParent(tf(arg0), findTF(arg0.bataiTf, "char"))
		setLocalScale(arg0, var2)
	end)

	arg0.content.anchoredPosition = Vector2(0, 0)

	local var12 = GetOrAddComponent(arg0.content, typeof(EventTriggerListener))

	arg0.velocityXSmoothing = Vector2(0, 0)
	arg0.offsetPosition = arg0.content.anchoredPosition

	var12:AddBeginDragFunc(function(arg0, arg1)
		arg0.prevPosition = arg1.position
		arg0.scenePosition = arg0.content.anchoredPosition
		arg0.velocityXSmoothing = Vector2(0, 0)
		arg0.offsetPosition = arg0.content.anchoredPosition
	end)
	var12:AddDragFunc(function(arg0, arg1)
		arg0.offsetPosition.x = arg1.position.x - arg0.prevPosition.x + arg0.scenePosition.x
		arg0.offsetPosition.y = arg1.position.y - arg0.prevPosition.y + arg0.scenePosition.y
		arg0.offsetPosition.x = arg0.offsetPosition.x > var7[2] and var7[2] or arg0.offsetPosition.x
		arg0.offsetPosition.x = arg0.offsetPosition.x < var7[1] and var7[1] or arg0.offsetPosition.x
		arg0.offsetPosition.y = arg0.offsetPosition.y > var8[2] and var8[2] or arg0.offsetPosition.y
		arg0.offsetPosition.y = arg0.offsetPosition.y < var8[1] and var8[1] or arg0.offsetPosition.y
	end)
	var12:AddDragEndFunc(function(arg0, arg1)
		return
	end)

	arg0.clickItems = {}

	for iter4 = 1, #var11 do
		local var13 = findTF(arg0.pos, var11[iter4][1])
		local var14 = GetComponent(findTF(arg0.pos, var11[iter4][2]), typeof(SpineAnimUI))

		table.insert(arg0.clickItems, {
			time = 0,
			tf = var13,
			anim = var14
		})
		onButton(arg0._event, var13, function()
			if arg0:checkClickTime(var14) then
				arg0:setAnimAction(var14, "action", 1, "normal")
			end
		end)
	end
end

function var0.setCharSit(arg0, arg1, arg2)
	if arg1.sitFlag or arg2.sitFlag then
		return
	end

	local var0 = arg1.tf
	local var1 = arg1.anim
	local var2 = arg2.pos
	local var3 = arg2.anim

	arg0:setAnimAction(var1, "sit", 0, nil)
	arg0:setAnimAction(var3, "sit", 0, nil)

	arg1.curAction = "sit"
	arg2.curAction = "sit"
	arg1.target = nil
	arg1.sitItem = arg2
	arg1.sitFlag = true
	arg1.time = math.random(10, 20)
	arg1.tf.localScale = var2
	arg1.vel = Vector2(0, 0)
	arg2.sitFlag = true

	setParent(arg1.tf, var2)

	arg1.tf.anchoredPosition = Vector2(0, 0)
end

function var0.stopCharSit(arg0, arg1)
	arg1.sitItem.sitFlag = false

	arg0:setAnimAction(arg1.anim, "walk", 0, nil)
	arg0:setAnimAction(arg1.sitItem.anim, "normal", 0, nil)

	arg1.sitItem = nil
	arg1.sitFlag = false

	setParent(arg1.tf, arg0.pos)

	arg1.tf.anchoredPosition = arg1.pos
end

function var0.checkClickTime(arg0, arg1)
	for iter0 = 1, #arg0.clickItems do
		if arg0.clickItems[iter0].anim == arg1 and (arg0.clickItems[iter0].time == 0 or Time.realtimeSinceStartup > arg0.clickItems[iter0].time) then
			arg0.clickItems[iter0].time = Time.realtimeSinceStartup + 2

			return true
		end
	end

	return false
end

function var0.step(arg0)
	arg0.content.anchoredPosition, arg0.velocityXSmoothing = Vector2.SmoothDamp(arg0.content.anchoredPosition, arg0.offsetPosition, arg0.velocityXSmoothing, var4)

	for iter0 = 1, #arg0.chars do
		local var0 = arg0.chars[iter0]
		local var1 = var0.time
		local var2 = var0.pos

		if not var1 or var1 <= 0 then
			if var0.sitFlag then
				arg0:stopCharSit(var0)
			elseif math.random(1, 10) > 5 then
				local var3 = arg0:getTargetPos(var0.min, var0.max)

				var0.vel, var0.target = arg0:getVel(var2, var3), var3
			end

			var0.time = math.random(1, var6)
		end

		if var0.target and not var0.sitFlag then
			local var4 = {
				var0.vel.x * var5 * Time.deltaTime,
				var0.vel.y * var5 * Time.deltaTime
			}

			if var4[1] ~= 0 then
				var0.pos.x = var0.pos.x + var4[1]
			end

			if var4[2] ~= 0 then
				var0.pos.y = var0.pos.y + var4[2]
			end

			local var5 = var0.bound

			if var0.pos.x < var5[1] then
				var0.pos.x = var5[1]
				var0.vel.x = 0
			end

			if var0.pos.x > var5[3] then
				var0.pos.x = var5[3]
				var0.vel.x = 0
			end

			if var0.pos.y < var5[2] then
				var0.pos.y = var5[2]
				var0.vel.y = 0
			end

			if var0.pos.y > var5[4] then
				var0.pos.y = var5[4]
				var0.vel.y = 0
			end

			var0.tf.anchoredPosition = var0.pos

			local var6 = var0.target

			if math.abs(var0.target.x - var0.pos.x) < 10 then
				var0.vel.x = 0
			end

			if math.abs(var0.target.y - var0.pos.y) < 10 then
				var0.vel.y = 0
			end
		end

		local var7 = true
		local var8 = var0.sitFlag

		if var0.vel.x == 0 and var0.vel.y == 0 then
			var0.time = var0.time - Time.deltaTime
			var7 = false
		end

		if not var7 and var0.target then
			var0.target = nil
		end

		if not var0.sitFlag and not var7 then
			var0.ableSit = true
		end

		if var7 then
			if var0.curAction ~= "walk" then
				var0.curAction = "walk"

				var0.anim:SetAction("walk", 0)
			end
		elseif var8 then
			if var0.curAction ~= "sit" then
				var0.curAction = "sit"

				var0.anim:SetAction("sit", 0)
			end
		elseif var0.curAction ~= "stand2" then
			var0.curAction = "stand2"

			var0.anim:SetAction("stand2", 0)
		end

		if var0.vel.x ~= 0 then
			local var9 = var0.vel.x > 0 and 1 or -1

			if var0.curScale.x ~= var9 then
				var0.curScale.x = var9 * var2.x
				var0.tf.localScale = var0.curScale
			end
		end

		if var7 then
			arg0:checkCharSit(var0)
		end
	end

	table.sort(arg0.items, function(arg0, arg1)
		if arg0.anchoredPosition.y < arg1.anchoredPosition.y then
			return true
		end
	end)

	for iter1, iter2 in ipairs(arg0.items) do
		iter2:SetAsFirstSibling()
	end
end

function var0.checkCharSit(arg0, arg1)
	if not arg1.ableSit then
		return
	end

	local var0 = arg1.pos

	for iter0 = 1, #arg0.sitItems do
		local var1 = arg0.sitItems[iter0]
		local var2 = var1.min
		local var3 = var1.max

		if var0.x > var2.x and var0.x < var3.x and var0.y > var2.y and var0.y < var3.y then
			if math.random(1, 10) > 7 then
				print("角色想坐下")
				arg0:setCharSit(arg1, var1)
			else
				arg1.ableSit = false

				print("角色不想坐下")
			end
		end
	end
end

function var0.getVel(arg0, arg1, arg2)
	local var0 = math.atan(math.abs(arg2.y - arg1.y) / math.abs(arg2.x - arg1.x))
	local var1 = arg2.x > arg1.x and 1 or -1
	local var2 = arg2.y > arg1.y and 1 or -1
	local var3 = math.cos(var0) * var1
	local var4 = math.sin(var0) * var2

	return Vector2(var3, var4)
end

function var0.setAnimAction(arg0, arg1, arg2, arg3, arg4)
	arg1:SetActionCallBack(nil)
	arg1:SetAction(arg2, 0)
	arg1:SetActionCallBack(function(arg0)
		if arg0 == "finish" and arg3 == 1 then
			arg1:SetActionCallBack(nil)
			arg1:SetAction(arg4, 0)
		end
	end)
end

function var0.getTargetPos(arg0, arg1, arg2)
	local var0 = tonumber(arg2.x) - tonumber(arg1.x)
	local var1 = tonumber(arg2.y) - tonumber(arg1.y)

	return Vector2(arg1.x + math.random(1, var0), arg1.y + math.random(1, var1))
end

function var0.isPointInMatrix(arg0, arg1, arg2, arg3, arg4, arg5)
	return arg0:getCross(arg1, arg2, arg5) * arg0:getCross(arg3, arg4, arg5) >= 0 and arg0:getCross(arg2, arg3, arg5) * arg0:getCross(arg4, arg1, arg5) >= 0
end

return var0
