local var0 = class("HalloweenGameView", import("..BaseMiniGameView"))
local var1 = 1
local var2 = 2
local var3 = 1
local var4 = 2
local var5 = 1
local var6 = 2
local var7 = 1
local var8 = 2
local var9 = {
	{
		3,
		5
	},
	{
		2,
		3
	},
	{
		1.5,
		3
	},
	{
		1,
		2.5
	},
	{
		1,
		2
	},
	{
		0.8,
		1.4
	}
}
local var10 = {
	30,
	80,
	120,
	160,
	180
}
local var11 = {
	4,
	6
}
local var12 = {
	0,
	30
}
local var13 = 0.5
local var14 = {
	{
		10,
		13
	},
	{
		7,
		10
	}
}
local var15 = {
	30
}
local var16 = {
	0,
	3
}
local var17 = {
	1,
	2
}
local var18 = {
	100,
	100,
	100,
	100
}
local var19 = {
	0,
	0,
	0,
	0,
	0,
	0,
	0
}
local var20 = {
	3,
	3.5,
	4,
	4.8,
	5.6,
	6.6,
	8.4
}
local var21 = {
	30,
	80,
	120,
	140,
	160,
	180
}
local var22 = {
	3,
	3.5,
	4,
	4.5,
	4.7,
	5
}
local var23 = {
	30,
	80,
	120,
	160,
	180
}
local var24 = 3
local var25 = {
	110,
	193,
	1170,
	193
}
local var26 = {
	117,
	848,
	1167,
	848
}
local var27 = Vector2(90, 244)
local var28 = 200
local var29 = 5
local var30 = 0
local var31 = 1000000
local var32 = 50000
local var33 = "event:/ui/getcandy"
local var34 = "event:/ui/jackboom"

local function var35(arg0)
	return
end

function var0.getUIName(arg0)
	return "HalloweenGameUI"
end

function var0.getBGM(arg0)
	return "backyard"
end

local function var36(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {
		{
			0,
			4
		},
		{
			4,
			6
		}
	}
	local var2 = 1
	local var3 = -1

	var0.charactorTf = arg0
	var0.moveRanges = arg1
	var0.scene = arg2
	var0.speedX = 0
	var0.direct = 0
	var0.moveRightFlag = false
	var0.moveLeftFlag = false
	var0.charactorIdleCallback = false

	function var0.ctor(arg0)
		arg0.collider = findTF(arg0.charactorTf, "collider")
		arg0.follow = findTF(arg0.charactorTf, "follow")
		arg0.charAnimator = GetComponent(findTF(arg0.charactorTf, "char"), typeof(Animator))
		arg0.posLight = findTF(arg0.charactorTf, "posLight")
		arg0.lightCharAnimator = GetComponent(findTF(arg0.posLight, "char"), typeof(Animator))
		arg0.lightCharDft = GetComponent(findTF(arg0.posLight, "char"), typeof(DftAniEvent))
		arg0.lightEffectAnimator = GetComponent(findTF(arg0.posLight, "light"), typeof(Animator))
		arg0.charactorDft = GetComponent(findTF(arg0.charactorTf, "char"), typeof(DftAniEvent))

		arg0.charactorDft:SetEndEvent(function(arg0)
			arg0:onAnimationEnd()
		end)
		arg0:clearData()
	end

	function var0.clearData(arg0)
		arg0.inAction = false
		arg0.direct = 0
		arg0.directType = var2
		arg0.currentDirectType = nil
		arg0.ghostFlag = false
		arg0.ghostPlayFlag = false
		arg0.speedRangeIndex = 1
		arg0.maxSpeed = var11[arg0.speedRangeIndex]
		arg0.playLightFlag = false
		arg0.moveLeftFlag = false
		arg0.moveRightFlag = false
		arg0.speedX = 0
	end

	function var0.setGhostFlag(arg0, arg1, arg2)
		if arg1 and (arg0.ghostFlag or arg0.ghostPlayFlag) then
			return
		end

		arg0:ghostAniCallback(true)

		function arg0.aniCallback(arg0)
			if not arg0 then
				arg0.ghostFlag = arg1
			else
				arg0.ghostFlag = false
			end

			if arg2 then
				arg2()
			end
		end

		if arg1 then
			arg0:playGhostDrump()
		else
			arg0:hideDrumpGhost()

			arg0.ghostPlayFlag = false
			arg0.ghostFlag = false
		end
	end

	function var0.playLight(arg0, arg1, arg2)
		if arg0.playLightFlag or arg0.inAction then
			if arg1 then
				arg1(false)
			end

			return
		end

		arg0.playLightFlag = true

		setActive(arg0.posLight, true)
		arg0.lightCharDft:SetEndEvent(function()
			arg0.playLightFlag = false
		end)
		arg0.lightCharDft:SetTriggerEvent(function()
			if arg1 then
				arg1(true)
			end
		end)

		if arg2 == var3 then
			arg0.lightCharAnimator:Play("charLight", -1, 0)
			arg0.lightEffectAnimator:Play("lightOn", -1, 0)
		elseif arg2 == var4 then
			arg0.lightCharAnimator:Play("charUnLight", -1, 0)
			arg0.lightEffectAnimator:Play("lightOff", -1, 0)
		end
	end

	function var0.ghostAniCallback(arg0, arg1)
		if arg0.aniCallback then
			arg0.aniCallback(arg1)

			arg0.aniCallback = nil
		end
	end

	function var0.hideDrumpGhost(arg0)
		local var0 = findTF(arg0.charactorTf, "ghostContainer/posGhost")

		setActive(var0, false)
	end

	function var0.getGhostFlag(arg0)
		return arg0.ghostFlag or arg0.ghostPlayFlag
	end

	function var0.getActionFlag(arg0)
		return arg0.inAction
	end

	function var0.playGhostDrump(arg0)
		arg0.ghostPlayFlag = true

		local var0 = findTF(arg0.charactorTf, "ghostContainer/posGhost")

		setActive(var0, true)

		local var1 = GetComponent(var0, typeof(Animator))

		GetComponent(var0, typeof(DftAniEvent)):SetEndEvent(function()
			arg0:ghostAniCallback()
			setActive(var0, false)

			arg0.ghostPlayFlag = false

			if arg0.inSpecial then
				arg0.currentDirectType = nil

				arg0:checkPlayerAnimation(true)

				arg0.inSpecial = false
			end
		end)
		var1:Play("drump", -1, 0)

		local var2 = findTF(var0, "drumpGhost/char")
		local var3 = GetComponent(var2, typeof(Animator))

		var3:SetInteger("state_type", 0)
		var3:SetInteger("state_type", 3)
	end

	function var0.boom(arg0)
		if arg0.inAction then
			return
		end

		local var0 = "boom"

		if arg0.currentDirectType == var1 then
			var0 = var0 .. "_left"
		else
			var0 = var0 .. "_right"
		end

		if arg0.ghostFlag then
			var0 = var0 .. "_ghost"
		end

		arg0:PlayAniamtion(var0, function()
			arg0:checkPlayerAnimation(true)

			arg0.inAction = false
		end)

		arg0.inAction = true
	end

	function var0.fail(arg0, arg1)
		if arg0.inAction then
			return
		end

		local var0 = "fail"

		if arg0.currentDirectType == var1 then
			var0 = var0 .. "_left"
		else
			var0 = var0 .. "_right"
		end

		if arg1 == var7 then
			var0 = var0 .. "_miss"
		elseif arg1 == var8 then
			var0 = var0 .. "_boom"
		end

		if arg0.ghostFlag then
			var0 = var0 .. "_ghost"
		end

		arg0:PlayAniamtion(var0, function()
			arg0.inAction = false
		end)

		arg0.inAction = true
	end

	function var0.gameOver(arg0)
		arg0.moveFlag = false

		if arg0.charactorIdleCallback then
			arg0.charactorIdleCallback(false)
		end
	end

	function var0.start(arg0)
		arg0.moveFlag = true
		arg0.startTime = var30

		arg0:clearData()
	end

	function var0.step(arg0)
		if not arg0.moveFlag then
			return
		end

		if not arg0.inAction then
			if arg0.direct ~= 0 then
				if arg0.maxSpeed - math.abs(arg0.speedX) < var13 then
					arg0.speedX = arg0.maxSpeed * arg0.direct
				elseif math.abs(arg0.speedX) ~= arg0.maxSpeed then
					arg0.speedX = (math.abs(arg0.speedX) + var13) * arg0.direct
				end

				local var0 = arg0.ghostFlag and 0.5 or 1
				local var1 = arg0.charactorTf.localPosition.x + arg0.speedX * var0

				if var1 < arg0.moveRanges[1] then
					var1 = arg0.moveRanges[1]
				end

				if var1 > arg0.moveRanges[3] then
					var1 = arg0.moveRanges[3]
				end

				arg0.charactorTf.localPosition = Vector3(var1, arg0.charactorTf.localPosition.y, arg0.charactorTf.localPosition.z)
			end

			arg0:checkPlayerAnimation()
		end

		if arg0.speedRangeIndex < #var12 then
			for iter0 = #var12, 1, -1 do
				if var30 - arg0.startTime > var12[iter0] and arg0.speedRangeIndex ~= iter0 then
					var35("角色速度提升")

					arg0.speedRangeIndex = iter0
					arg0.maxSpeed = var11[arg0.speedRangeIndex]

					break
				end
			end
		end

		if arg0.speedX == 0 and not arg0.ghostFlag and not arg0.inAction then
			if arg0.specialTime then
				if var30 - arg0.specialTime >= 7 then
					arg0.specialTime = nil
					arg0.inSpecial = true

					arg0:PlayAniamtion("special", function()
						arg0.currentDirectType = nil

						arg0:checkPlayerAnimation(true)

						arg0.inSpecial = false
					end)
				end
			else
				arg0.specialTime = var30
			end
		else
			arg0.specialTime = nil
		end

		if arg0.speedX == 0 and not arg0.inAction then
			if arg0.idleTime then
				if var30 - arg0.idleTime >= 5 then
					arg0.idleTime = nil

					if arg0.charactorIdleCallback then
						arg0.charactorIdleCallback(true)
					end
				end
			else
				arg0.idleTime = var30
			end
		else
			arg0.idleTime = nil

			if arg0.charactorIdleCallback then
				arg0.charactorIdleCallback(false)
			end
		end
	end

	function var0.checkPlayerAnimation(arg0, arg1)
		if arg0.currentDirectType ~= arg0.directType or arg1 then
			arg0.currentDirectType = arg0.directType

			if arg0.currentDirectType == var2 then
				arg0:PlayAniamtion("idle_right")
			else
				arg0:PlayAniamtion("idle_left")
			end
		end

		local var0

		if arg0.speedX == 0 then
			var0 = 0
		else
			for iter0 = 1, #var1 do
				local var1 = var1[iter0]

				if math.abs(arg0.speedX) ~= 0 and arg0.maxSpeed > var1[1] and arg0.maxSpeed <= var1[2] then
					var0 = iter0
				end
			end
		end

		if arg0.charAnimator:GetInteger("speed_type") ~= var0 then
			arg0.charAnimator:SetInteger("speed_type", var0)
		end

		if arg0.charAnimator:GetBool("ghost") ~= arg0.ghostFlag then
			arg0.charAnimator:SetBool("ghost", arg0.ghostFlag)
		end
	end

	function var0.PlayAniamtion(arg0, arg1, arg2)
		var35("开始播放动作:" .. arg1)
		arg0.charAnimator:Play(arg1, -1, 0)

		if arg0.onAniCallback then
			var35(arg0.onAniamtionName .. "的animation被" .. arg1 .. "中断")
		end

		arg0.onAniamtionName = arg1
		arg0.onAniCallback = arg2
	end

	function var0.onAnimationEnd(arg0)
		var35("动作播放结束:" .. arg0.onAniamtionName)

		if arg0.onAniCallback then
			local var0 = arg0.onAniCallback

			arg0.onAniCallback = nil

			var0()
		end
	end

	function var0.onDirectChange(arg0, arg1, arg2)
		if not arg0.moveFlag then
			return
		end

		if arg0.inSpecial then
			arg0.currentDirectType = nil

			arg0:checkPlayerAnimation(true)

			arg0.inSpecial = false
		end

		if arg1 == var1 then
			arg0.moveLeftFlag = arg2
		elseif arg1 == var2 then
			arg0.moveRightFlag = arg2
		end

		local var0

		if arg2 then
			var0 = arg1 == var1 and var3 or var2
		else
			var0 = arg0.moveRightFlag and 1 or arg0.moveLeftFlag and -1 or 0
		end

		if arg0.direct ~= var0 or var0 == 0 then
			arg0.speedX = 0
		end

		arg0.direct = var0

		if arg0.direct ~= 0 then
			arg0.directType = arg0.direct == var3 and var1 or var2
		end
	end

	function var0.getCollider(arg0)
		if not arg0.collider then
			-- block empty
		end

		local var0 = arg0.collider.sizeDelta.x
		local var1 = arg0.collider.sizeDelta.y
		local var2 = arg0.collider.position
		local var3 = arg0.scene:InverseTransformPoint(var2.x, var2.y, 0)

		var3.x = var3.x - var0 / 2

		return {
			pos = var3,
			width = var0,
			height = var1
		}
	end

	function var0.getFollowPos(arg0)
		return arg0.follow.position
	end

	function var0.getLeavePos(arg0)
		local var0

		if arg0.ghostPlayFlag then
			var0 = findTF(arg0.charactorTf, "ghostContainer/posGhost").position

			var35("播放动画中，获取幽灵当前位置")
		else
			if not arg0.leavePos then
				arg0.leavePos = findTF(arg0.charactorTf, "posGhostLeave")
			end

			var0 = arg0.leavePos.position

			var35("播放动画结束，获取头顶位置")
		end

		return var0
	end

	function var0.clearDirect(arg0)
		arg0.direct = 0
		arg0.speedX = 0
	end

	var0:ctor()

	return var0
end

local function var37(arg0, arg1)
	local var0 = {
		moveTf = arg0,
		useLightTf = arg1
	}

	var0.initFlag = false
	var0.direct = 0
	var0.pointChangeCallback = nil
	var0.pointUpCallback = nil
	var0.pointLightCallback = nil
	var0.lightTime = nil

	function var0.Ctor(arg0)
		arg0.buttonDelegate = GetOrAddComponent(arg0.useLightTf, "EventTriggerListener")

		arg0.buttonDelegate:AddPointDownFunc(function(arg0, arg1)
			local var0

			if not arg0.lightTime or var30 - arg0.lightTime > var29 then
				var0 = var3
				arg0.lightTime = var30
			else
				var0 = var4
			end

			if arg0.pointLightCallback then
				arg0.pointLightCallback(var0)
			end
		end)

		arg0.delegateLeft = GetOrAddComponent(findTF(arg0.moveTf, "left"), "EventTriggerListener")
		arg0.delegateRight = GetOrAddComponent(findTF(arg0.moveTf, "right"), "EventTriggerListener")

		arg0.delegateLeft:AddPointDownFunc(function(arg0, arg1)
			if arg0.pointChangeCallback then
				arg0.pointChangeCallback(var1)
			end
		end)
		arg0.delegateRight:AddPointDownFunc(function(arg0, arg1)
			if arg0.pointChangeCallback then
				arg0.pointChangeCallback(var2)
			end
		end)
		arg0.delegateLeft:AddPointUpFunc(function(arg0, arg1)
			if arg0.pointUpCallback then
				arg0.pointUpCallback(var1)
			end
		end)
		arg0.delegateRight:AddPointUpFunc(function(arg0, arg1)
			if arg0.pointUpCallback then
				arg0.pointUpCallback(var2)
			end
		end)

		arg0.initFlag = true
	end

	function var0.callbackDirect(arg0, arg1, arg2)
		if not arg2 then
			return
		end

		local var0 = arg0:getPointFromEventData(arg1)

		var35(var0.x .. "  " .. var0.y)

		local var1 = arg0:getDirect(var0)

		arg2(var1)
	end

	function var0.getPointFromEventData(arg0, arg1)
		if not arg0.uiCam then
			arg0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
		end

		local var0 = arg0.uiCam:ScreenToWorldPoint(arg1.position)

		return (arg0.moveTf:InverseTransformPoint(var0))
	end

	function var0.getDirect(arg0, arg1)
		local var0 = arg0.moveTf.sizeDelta.x
		local var1 = arg0.moveTf.sizeDelta.y

		if arg1.x >= 0 then
			return var2
		else
			return var1
		end
	end

	function var0.changeRemind(arg0, arg1)
		arg0.remindFlag = arg1

		local var0 = GetComponent(arg0.useLightTf, typeof(Animator))

		if arg1 and isActive(findTF(arg0.useLightTf, "light")) then
			var0:Play("useLightRemind", -1, 0)
		else
			var0:Play("useLightIdle", -1, 0)
		end
	end

	function var0.start(arg0)
		setActive(findTF(arg0.useLightTf, "light"), true)

		arg0.lightTime = nil
	end

	function var0.step(arg0)
		if not arg0.lightTime or var30 - arg0.lightTime > var29 then
			if not isActive(findTF(arg0.useLightTf, "light")) then
				setActive(findTF(arg0.useLightTf, "light"), true)
				arg0:changeRemind(arg0.remindFlag)
			end
		elseif isActive(findTF(arg0.useLightTf, "light")) then
			setActive(findTF(arg0.useLightTf, "light"), false)
		end
	end

	function var0.gameOver(arg0)
		setActive(findTF(arg0.useLightTf, "light"), false)
	end

	function var0.destroy(arg0)
		if arg0.delegateLeft then
			ClearEventTrigger(arg0.delegateLeft)
		end

		if arg0.delegateRight then
			ClearEventTrigger(arg0.delegateRight)
		end
	end

	var0:Ctor()

	return var0
end

local function var38(arg0, arg1)
	local var0 = {
		_tf = arg0,
		moveRange = arg1
	}

	var0.targetX = nil
	var0.speedX = 1
	var0.dropCallback = nil
	var0.dropNum = 0

	function var0.Ctor(arg0)
		arg0.bodyAnimator = GetComponent(findTF(arg0._tf, "char/body"), typeof(Animator))
		arg0.bodyDft = GetComponent(findTF(arg0._tf, "char/body"), typeof(DftAniEvent))

		arg0.bodyDft:SetEndEvent(function()
			arg0:dropEnd()
		end)
		arg0.bodyDft:SetTriggerEvent(function()
			arg0:dropItem()
		end)
	end

	function var0.start(arg0)
		arg0.moveFlag = true
		arg0.speedLevel = 1
	end

	function var0.gameOver(arg0)
		arg0.moveFlag = false
	end

	function var0.step(arg0)
		if not arg0.moveFlag then
			return
		end

		if arg0.targetX then
			if arg0.targetX ~= arg0._tf.localPosition.x then
				if arg0.targetX > arg0._tf.localPosition.x then
					arg0._tf.localPosition = Vector3(arg0._tf.localPosition.x + arg0:getSpeed(), arg0._tf.localPosition.y, arg0._tf.localPosition.z)
				else
					arg0._tf.localPosition = Vector3(arg0._tf.localPosition.x - arg0:getSpeed(), arg0._tf.localPosition.y, arg0._tf.localPosition.z)
				end
			end

			if math.abs(arg0.targetX - arg0._tf.localPosition.x) <= arg0:getSpeed() then
				arg0.targetX = nil
			end
		end

		if not arg0.targetX then
			arg0:setNextTarget()
		end

		if arg0.speedLevel < #var22 and var23[arg0.speedLevel] < var30 then
			arg0.speedLevel = arg0.speedLevel + 1
		end
	end

	function var0.getSpeed(arg0)
		return var22[arg0.speedLevel]
	end

	function var0.dropItem(arg0)
		if arg0.dropCallback then
			arg0.dropCallback()
		end
	end

	function var0.dropEnd(arg0)
		if arg0.dropNum > 0 then
			arg0.dropNum = arg0.dropNum - 1
		end

		arg0.bodyAnimator:SetInteger("dropNums", arg0.dropNum)
	end

	function var0.addDropNum(arg0)
		arg0.dropNum = arg0.dropNum + 1

		arg0.bodyAnimator:SetInteger("dropNums", arg0.dropNum)
	end

	function var0.setNextTarget(arg0)
		if not arg0.targetX then
			if arg0._tf.localPosition.x < arg0.moveRange[3] / 3 then
				arg0.targetX = math.random(arg0.moveRange[3] * 2 / 3, arg0.moveRange[3])
			else
				arg0.targetX = math.random(arg0.moveRange[1], arg0.moveRange[3] / 3)
			end
		end

		if arg0._tf.localPosition.x > arg0.targetX then
			arg0._tf.localScale = Vector3(-1, 1, 1)
		else
			arg0._tf.localScale = Vector3(1, 1, 1)
		end
	end

	function var0.getDropWorldPos(arg0)
		if not arg0.posDrop then
			arg0.posDrop = findTF(arg0._tf, "char/posDrop")
		end

		return arg0.posDrop.position
	end

	function var0.clear(arg0)
		arg0.dropNum = 0
		arg0.dropCallback = nil
	end

	var0:Ctor()

	return var0
end

local function var39()
	local var0 = {}

	var0.speedLevel = 1
	var0.dropRequestCallback = nil

	function var0.start(arg0)
		arg0.startFlag = true
		arg0.speedLevel = 1
		arg0.startTime = var30
	end

	function var0.gameOver(arg0)
		arg0.startFlag = false
		arg0.stepTime = nil
		arg0.speedLevel = nil
	end

	function var0.step(arg0)
		if not arg0.startFlag then
			return
		end

		if not arg0.stepTime then
			arg0.stepTime = arg0.startTime + math.random() * (var9[arg0.speedLevel][1] - var9[arg0.speedLevel][2]) + var9[arg0.speedLevel][1]
		elseif var30 >= arg0.stepTime then
			arg0.stepTime = var30 + math.random(var9[arg0.speedLevel][1], var9[arg0.speedLevel][2])

			if arg0.dropRequestCallback then
				arg0.dropRequestCallback()
			end
		end

		if arg0.speedLevel <= #var10 then
			if not arg0.nextSpeedUpTime then
				arg0.nextSpeedUpTime = arg0.startTime + var10[arg0.speedLevel]
			end

			if var30 >= arg0.nextSpeedUpTime then
				arg0.speedLevel = arg0.speedLevel + 1
				arg0.nextSpeedUpTime = arg0.speedLevel <= #var10 and var30 + var10[arg0.speedLevel] or nil
			end
		end
	end

	return var0
end

local function var40(arg0, arg1)
	local var0 = {
		flyer = arg0,
		scene = arg1,
		dropItems = {}
	}

	var0.lostCallback = nil
	var0.boomCallback = nil
	var0.dropSpeedUpCallback = nil

	function var0.start(arg0)
		arg0.startFlag = true
		arg0.speedLevel = 1
		arg0.nextSpeedUpTime = nil
		arg0.startTime = var30
	end

	function var0.gameOver(arg0)
		arg0.startFlag = false

		for iter0 = #arg0.dropItems, 1, -1 do
			local var0 = arg0.dropItems[iter0].tf
			local var1 = table.remove(arg0.dropItems, iter0)

			arg0:returnDropItem(var1)
		end
	end

	function var0.createDropItem(arg0)
		local var0 = arg0:getDropItem()
		local var1 = arg0.flyer:getDropWorldPos()
		local var2 = arg0.scene:InverseTransformPoint(var1)

		var0.tf.localPosition = var2

		if not arg0.dropItems then
			arg0.dropItems = {}
		end

		table.insert(arg0.dropItems, var0)
	end

	function var0.getDropItem(arg0)
		if not arg0.dropItemPool then
			arg0.dropItemPool = {}
		end

		local var0

		if #arg0.dropItemPool > 0 then
			var0 = table.remove(arg0.dropItemPool, 1)
		else
			local var1 = tf(instantiate(findTF(arg0.scene, "tplItem")))

			SetParent(var1, arg0.scene, false)

			var0 = {
				tf = var1
			}
		end

		local var2 = math.random(var17[1], var17[2]) <= var17[1] and var6 or var5

		var0.type = var2
		var0.speed = var20[arg0.speedLevel]

		setActive(var0.tf, true)
		arg0:setItemData(var0, var2)

		return var0
	end

	function var0.setItemData(arg0, arg1, arg2)
		local var0 = arg1.tf
		local var1 = findTF(var0, "candy")
		local var2 = findTF(var0, "boom")

		arg1.score = 0

		if arg2 == var5 then
			setActive(var1, true)
			setActive(var2, false)

			local var3 = math.random(var16[1], var16[2])
			local var4 = GetComponent(findTF(var1, "img"), typeof(Animator))

			var4:SetInteger("type", var3)
			var4:Play("candyIdle", -1, 0)

			arg1.score = var18[var3 + 1]
		else
			setActive(var1, false)
			setActive(var2, true)
		end
	end

	function var0.returnDropItem(arg0, arg1)
		setActive(arg1.tf, false)
		table.insert(arg0.dropItemPool, arg1)
	end

	function var0.step(arg0)
		if not arg0.startFlag then
			return
		end

		if arg0.speedLevel <= #var21 then
			if not arg0.nextSpeedUpTime then
				arg0.nextSpeedUpTime = arg0.startTime + var21[arg0.speedLevel]
			end

			if var30 >= arg0.nextSpeedUpTime then
				arg0.speedLevel = arg0.speedLevel + 1
				arg0.nextSpeedUpTime = arg0.speedLevel <= #var21 and arg0.startTime + var21[arg0.speedLevel] or nil

				if arg0.dropSpeedUpCallback then
					arg0.dropSpeedUpCallback()
				end
			end
		end

		if arg0.dropItems and #arg0.dropItems > 0 then
			for iter0 = #arg0.dropItems, 1, -1 do
				local var0 = arg0.dropItems[iter0].tf
				local var1 = arg0.dropItems[iter0].speed + var19[arg0.speedLevel]

				arg0.dropItems[iter0].speed = var1

				if var0.localPosition.y <= var28 then
					local var2 = table.remove(arg0.dropItems, iter0)

					if var2.type == var5 and arg0.lostCallback then
						arg0:playItemLost(var2)
						arg0.lostCallback()
					else
						arg0:returnDropItem(var2)
					end
				else
					var0.localPosition = Vector3(var0.localPosition.x, var0.localPosition.y - var1, var0.localPosition.z)
				end
			end
		end
	end

	function var0.dropItemCollider(arg0, arg1)
		for iter0 = #arg0.dropItems, 1, -1 do
			if table.contains(arg1, iter0) then
				local var0 = table.remove(arg0.dropItems, iter0)

				arg0:playItemEffect(var0)
			end
		end
	end

	function var0.playItemEffect(arg0, arg1)
		local var0 = arg1.type

		if var0 == var5 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var33)

			local var1 = GetComponent(findTF(arg1.tf, "candy/img"), typeof(Animator))

			GetComponent(findTF(arg1.tf, "candy/img"), typeof(DftAniEvent)):SetEndEvent(function()
				arg0:returnDropItem(arg1)
			end)
			var1:SetTrigger("effect")
		elseif var0 == var6 then
			local var2 = GetComponent(findTF(arg1.tf, "boom/img"), typeof(Animator))
			local var3 = GetComponent(findTF(arg1.tf, "boom/img"), typeof(DftAniEvent))

			var3:SetEndEvent(function()
				arg0:returnDropItem(arg1)
			end)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var34)
			var3:SetTriggerEvent(function()
				if arg0.boomCallback then
					arg0.boomCallback()
				end
			end)
			var2:SetTrigger("effect")
		end
	end

	function var0.playItemLost(arg0, arg1)
		if arg1.type == var5 then
			local var0 = GetComponent(findTF(arg1.tf, "candy/img"), typeof(Animator))
			local var1 = findTF(arg1.tf, "candy/candy_glow")
			local var2 = GetComponent(findTF(arg1.tf, "candy/img"), typeof(DftAniEvent))
			local var3 = var0:GetLayerIndex("newLayer")

			var2:SetEndEvent(function()
				setActive(var1, false)
				arg0:returnDropItem(arg1)
			end)
			var2:SetTriggerEvent(function()
				setActive(var1, true)
			end)
			var0:Play("candyLost", var3, 0)
		end
	end

	function var0.getDropItemsCollider(arg0)
		if not arg0.dropItems then
			return
		end

		local var0 = {}

		for iter0 = 1, #arg0.dropItems do
			local var1 = findTF(arg0.dropItems[iter0].tf, "collider")
			local var2 = var1.sizeDelta.x
			local var3 = var1.sizeDelta.y
			local var4 = var1.position

			table.insert(var0, {
				x = var4.x,
				y = var4.y,
				width = var2,
				height = var3,
				index = iter0,
				type = arg0.dropItems[iter0].type,
				score = arg0.dropItems[iter0].score
			})
		end

		return var0
	end

	return var0
end

local function var41(arg0, arg1, arg2)
	local var0 = {
		charactor = arg0,
		dropItemController = arg1,
		scene = arg2
	}

	var0.colliderDropItemCallback = nil

	function var0.start(arg0)
		arg0.startFlag = true
	end

	function var0.gameOver(arg0)
		arg0.startFlag = false
	end

	function var0.step(arg0)
		if not arg0.startFlag then
			return
		end

		arg0:checkCollider()
	end

	function var0.checkCollider(arg0)
		local var0 = {}
		local var1 = arg0.dropItemController:getDropItemsCollider()
		local var2 = arg0.charactor:getCollider()
		local var3 = var2.pos

		if var1 and #var1 > 0 then
			for iter0 = 1, #var1 do
				local var4 = var1[iter0]
				local var5 = arg0.scene:InverseTransformPoint(var4.x, var4.y, 0)

				if arg0:checkRectCollider(var3, var5, var2, var4) then
					table.insert(var0, var4.index)

					if arg0.colliderDropItemCallback then
						arg0.colliderDropItemCallback(var4)
					end
				end
			end
		end

		if #var0 > 0 then
			arg0.dropItemController:dropItemCollider(var0)
		end
	end

	function var0.checkRectCollider(arg0, arg1, arg2, arg3, arg4)
		local var0 = arg1.x
		local var1 = arg1.y
		local var2 = arg3.width
		local var3 = arg3.height
		local var4 = arg2.x
		local var5 = arg2.y
		local var6 = arg4.width
		local var7 = arg4.height

		if var4 <= var0 and var0 >= var4 + var6 then
			return false
		elseif var0 <= var4 and var4 >= var0 + var2 then
			return false
		elseif var5 <= var1 and var1 >= var5 + var7 then
			return false
		elseif var1 <= var5 and var5 >= var1 + var3 then
			return false
		else
			return true
		end
	end

	return var0
end

local function var42(arg0)
	local var0 = {
		_tf = arg0
	}

	var0.speedLevel = 1
	var0.createGhostCallback = nil
	var0.ghostSpeedUpCallback = nil

	function var0.start(arg0)
		arg0.startFlag = true
		arg0.speedLevel = 1
		arg0.startTime = var30
		arg0.bossAnimator = GetComponent(findTF(arg0._tf, "char"), typeof(Animator))
		arg0.tip = findTF(arg0._tf, "tip")
	end

	function var0.gameOver(arg0)
		arg0.startFlag = false
		arg0.stepTime = nil

		setActive(arg0.tip, false)
		arg0.bossAnimator:SetInteger("state_type", 0)
	end

	function var0.step(arg0)
		if not arg0.startFlag then
			return
		end

		if not arg0.stepTime then
			arg0.stepTime = arg0.startTime + math.random(var14[arg0.speedLevel][1], var14[arg0.speedLevel][2])
		elseif var30 >= arg0.stepTime then
			arg0.stepTime = var30 + math.random(var14[arg0.speedLevel][1], var14[arg0.speedLevel][2])

			if arg0.createGhostCallback then
				arg0.createGhostCallback()
			end
		end

		if arg0.speedLevel <= #var15 then
			if not arg0.nextSpeedUpTime then
				arg0.nextSpeedUpTime = arg0.startTime + var15[arg0.speedLevel]
			end

			if var30 >= arg0.nextSpeedUpTime then
				arg0.speedLevel = arg0.speedLevel + 1
				arg0.nextSpeedUpTime = arg0.speedLevel <= #var15 and arg0.nextSpeedUpTime + var15[arg0.speedLevel] or nil

				if arg0.ghostSpeedUpCallback then
					arg0.ghostSpeedUpCallback()
				end

				var35("幽灵生成速度提升" .. (arg0.nextSpeedUpTime or "(已经达到最高速度)"))
			end
		end
	end

	function var0.showTip(arg0, arg1)
		if LeanTween.isTweening(go(arg0.tip)) then
			LeanTween.cancel(go(arg0.tip))
		end

		setActive(findTF(arg0.tip, "img1"), false)
		setActive(findTF(arg0.tip, "img2"), false)
		setActive(findTF(arg0.tip, "img" .. arg1), true)
		setActive(arg0.tip, true)
		LeanTween.delayedCall(go(arg0.tip), 10, System.Action(function()
			setActive(arg0.tip, false)
		end))
	end

	function var0.onCreate(arg0)
		arg0.bossAnimator:SetInteger("state_type", 3)
	end

	function var0.onCatch(arg0)
		arg0.bossAnimator:SetInteger("state_type", 2)
	end

	function var0.onGhostDestroy(arg0)
		arg0.bossAnimator:SetInteger("state_type", 1)

		arg0.stepTime = var30 + math.random(var14[arg0.speedLevel][1], var14[arg0.speedLevel][2])
	end

	function var0.destory(arg0)
		if LeanTween.isTweening(go(arg0.tip)) then
			LeanTween.cancel(go(arg0.tip))
		end
	end

	return var0
end

local function var43(arg0, arg1, arg2)
	local var0 = {}
	local var1 = 4

	var0.tplGhost = arg0
	var0.charactor = arg1
	var0.scene = arg2
	var0.catchCharactorCallback = nil

	function var0.start(arg0)
		arg0.startFlag = true
	end

	function var0.gameOver(arg0)
		arg0.startFlag = false

		if not arg0.ghostChilds then
			return
		end

		for iter0 = #arg0.ghostChilds, 1, -1 do
			local var0 = arg0.ghostChilds[iter0]

			arg0:removeChild(var0)
		end
	end

	function var0.step(arg0)
		if not arg0.startFlag or not arg0.ghostChilds then
			return
		end

		local var0 = arg0.charactor:getFollowPos()
		local var1 = arg0.scene:InverseTransformPoint(var0)

		for iter0 = #arg0.ghostChilds, 1, -1 do
			local var2 = arg0.ghostChilds[iter0]

			if isActive(var2) then
				local var3 = var2.anchoredPosition
				local var4 = 0
				local var5 = 0
				local var6 = false
				local var7 = false

				if math.abs(var1.x - var3.x) > 10 then
					var4 = var1 * (var1.x > var3.x and 1 or -1)
				else
					var6 = true
				end

				if math.abs(var1.y - var3.y) > 10 then
					var5 = var1 * (var1.y > var3.y and 1 or -1)
				else
					var7 = true
				end

				if not arg0.charactor:getGhostFlag() and not arg0.charactor:getActionFlag() and var7 and var6 then
					setActive(var2, false)

					if arg0.catchCharactorCallback then
						arg0.catchCharactorCallback(var2)
					end

					return
				end

				var3.x = var3.x + var4
				var3.y = var3.y + var5
				arg0.ghostChilds[iter0].anchoredPosition = var3
			end
		end
	end

	function var0.removeChild(arg0, arg1)
		for iter0 = 1, #arg0.ghostChilds do
			if arg1 == arg0.ghostChilds[iter0] then
				local var0 = table.remove(arg0.ghostChilds, iter0)

				arg0:returnGhost(var0)

				return
			end
		end
	end

	function var0.createGhost(arg0)
		if not arg0.ghostChilds then
			arg0.ghostChilds = {}
		end

		if #arg0.ghostChilds > 0 or arg1:getGhostFlag() then
			return false
		end

		local var0 = arg0:getGhostChild()

		var0.anchoredPosition = var27

		GetComponent(findTF(var0, "char"), typeof(Animator)):SetInteger("state_type", 1)
		table.insert(arg0.ghostChilds, var0)

		return true
	end

	function var0.getGhostChild(arg0)
		if not arg0.ghostPool then
			arg0.ghostPool = {}
		end

		local var0

		if #arg0.ghostPool > 0 then
			var0 = table.remove(arg0.ghostPool, #arg0.ghostPool)
		else
			var0 = tf(instantiate(arg0.tplGhost))

			SetParent(var0, arg0.scene, false)
		end

		setActive(var0, true)

		return var0
	end

	function var0.returnGhost(arg0, arg1)
		setActive(arg1, false)
		table.insert(arg0.ghostPool, arg1)
	end

	function var0.createGhostLight(arg0, arg1)
		if not arg0.lightGhost then
			arg0.lightGhost = tf(instantiate(arg0.tplGhost))
			arg0.lightGhost.name = "lightGhost"
			arg0.lightAnimator = GetComponent(findTF(arg0.lightGhost, "char"), typeof(Animator))

			GetComponent(findTF(arg0.lightGhost, "char"), typeof(DftAniEvent)):SetEndEvent(function()
				setActive(arg0.lightGhost, false)
			end)
			setParent(arg0.lightGhost, arg0.scene)
		end

		if arg0.charactor:getGhostFlag() then
			arg0.lightGhost.anchoredPosition = arg0.scene:InverseTransformPoint(arg0.charactor:getLeavePos())

			setActive(arg0.lightGhost, true)
			arg0.lightAnimator:SetInteger("state_type", 0)
			arg0.lightAnimator:SetInteger("state_type", 2)
			arg1(true)
		else
			arg1(false)
		end
	end

	return var0
end

local function var44(arg0, arg1)
	local var0 = {
		eyeTf = arg0
	}
	local var1 = 3

	function var0.changeEyeShow(arg0, arg1)
		return
	end

	function var0.start(arg0)
		if not arg0.eyes then
			arg0.eyes = {}

			for iter0 = 1, 3 do
				table.insert(arg0.eyes, findTF(arg0.eyeTf, "eye" .. iter0))
			end
		end

		arg0.centerX = (var25[3] - var25[1]) / 2
		arg0.halfRnage = (var25[3] - var25[1]) / 2

		arg0:changeEyeShow(true)
	end

	function var0.step(arg0)
		local var0 = (arg1.anchoredPosition.x - var25[1] - arg0.centerX) / arg0.halfRnage * var1

		for iter0 = 1, #arg0.eyes do
			setAnchoredPosition(findTF(arg0.eyes[iter0], "img"), Vector3(var0, 0, 0))
		end
	end

	function var0.gameOver(arg0)
		return
	end

	return var0
end

function var0.init(arg0)
	arg0:initUI()
	arg0:initData()
	arg0:gameReadyStart()
end

function var0.initUI(arg0)
	onButton(arg0, findTF(arg0._tf, "conLeft/btnClose"), function()
		if not arg0.gameStartFlag then
			arg0:closeView()
		else
			setActive(arg0.leaveUI, true)
			arg0:timerStop()

			arg0.gameStartFlag = false
		end
	end, SFX_CANCEL)

	arg0.playerIdleTip = findTF(arg0._tf, "idleTip")

	setActive(arg0.playerIdleTip, false)

	arg0.hearts = {}

	for iter0 = 1, var24 do
		table.insert(arg0.hearts, findTF(arg0._tf, "conRight/heart/heart" .. iter0))
	end

	arg0.wanshengjie = findTF(arg0._tf, "wanshengjie")

	setActive(arg0.wanshengjie, false)

	arg0.scoreText = findTF(arg0._tf, "conRight/score/text")
	arg0.scene = findTF(arg0._tf, "scene")
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		arg0:clearUI()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		setActive(arg0.leaveUI, false)
		arg0:gameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		setActive(arg0.leaveUI, false)
		arg0:timerStart()

		arg0.gameStartFlag = true
	end, SFX_CANCEL)
end

function var0.initData(arg0)
	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 0.0166666666666667, -1)
	arg0.charactor = var36(findTF(arg0.scene, "charactor"), var25, arg0.scene)

	function arg0.charactor.charactorIdleCallback(arg0)
		setActive(arg0.playerIdleTip, arg0)
	end

	arg0.flyer = var38(findTF(arg0.scene, "flyCharactor"), var26)

	function arg0.flyer.dropCallback()
		arg0:onCreateDropItem()
	end

	arg0.controllerUI = var37(findTF(arg0._tf, "controller"), findTF(arg0._tf, "conRight/useLight"))

	function arg0.controllerUI.pointChangeCallback(arg0)
		arg0:onControllerDirectChange(arg0)
	end

	function arg0.controllerUI.pointUpCallback(arg0)
		arg0:onControllerDirectUp(arg0)
	end

	function arg0.controllerUI.pointLightCallback(arg0)
		arg0:onUseLight(arg0)
	end

	arg0.dropControl = var39()

	function arg0.dropControl.dropRequestCallback()
		arg0:onRequestDrop()
	end

	arg0.dropItemController = var40(arg0.flyer, arg0.scene)

	function arg0.dropItemController.lostCallback()
		arg0:lostCandy()
	end

	function arg0.dropItemController.boomCallback()
		arg0:touchBoom()
	end

	function arg0.dropItemController.dropSpeedUpCallback()
		arg0:dropSpeedUp()
	end

	arg0.dropColliderControll = var41(arg0.charactor, arg0.dropItemController, arg0.scene)

	function arg0.dropColliderControll.colliderDropItemCallback(arg0)
		arg0:addScore(arg0.score)
	end

	arg0.ghostBossController = var42(findTF(arg0._tf, "ghostBoss"))

	function arg0.ghostBossController.createGhostCallback()
		arg0:createGhost()
	end

	function arg0.ghostBossController.ghostSpeedUpCallback()
		if arg0.eyesController then
			arg0.eyesController:changeEyeShow(false)
		end
	end

	arg0.ghostChildController = var43(findTF(arg0.scene, "tplGhost"), arg0.charactor, arg0.scene)

	function arg0.ghostChildController.catchCharactorCallback(arg0)
		arg0:onGhostCatch(arg0)
	end

	arg0.eyesController = var44(findTF(arg0._tf, "bg/eyes"), findTF(arg0.scene, "charactor"))

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)

	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:gameStart()
	end)
end

function var0.gameReadyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
end

function var0.gameStart(arg0)
	arg0.heartNum = var24
	arg0.scoreNum = 0
	arg0.gameStartFlag = true
	var30 = 0

	setActive(arg0.scene, true)
	arg0:updateUI()
	arg0.charactor:start()
	arg0.flyer:start()
	arg0.dropControl:start()
	arg0.dropItemController:start()
	arg0.dropColliderControll:start()
	arg0.ghostBossController:start()
	arg0.ghostChildController:start()
	arg0.controllerUI:start()
	arg0.eyesController:start()
	arg0:timerStart()
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end

	setActive(arg0.wanshengjie, true)
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end

	setActive(arg0.wanshengjie, false)
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getSoundData(arg0, arg1)
	CueData.GetCueData().channelName = pg.CriMgr.C_GALLERY_MUSIC
	arg0.cueData.cueSheetName = arg1
	arg0.cueData.cueName = ""
end

function var0.onTimer(arg0)
	var30 = var30 + arg0.timer.duration

	arg0.charactor:step()
	arg0.flyer:step()
	arg0.dropControl:step()
	arg0.dropItemController:step()
	arg0.dropColliderControll:step()
	arg0.ghostBossController:step()
	arg0.ghostChildController:step()
	arg0.controllerUI:step()
	arg0.eyesController:step()
end

function var0.updateUI(arg0)
	for iter0 = 1, #arg0.hearts do
		if iter0 <= arg0.heartNum then
			setActive(findTF(arg0.hearts[iter0], "img"), true)
		else
			setActive(findTF(arg0.hearts[iter0], "img"), false)
		end
	end

	if not arg0.showOverTip and (arg0.scoreNum >= var31 or var30 * 1000 >= var32) and arg0.ghostBossController then
		arg0.showOverTip = true

		arg0.ghostBossController:showTip(2)
	end

	setText(arg0.scoreText, arg0.scoreNum)
end

function var0.dropSpeedUp(arg0)
	if arg0.ghostBossController then
		arg0.ghostBossController:showTip(1)
	end
end

function var0.loseHeart(arg0, arg1)
	if arg0.heartNum and arg0.heartNum > 0 then
		arg0.heartNum = arg0.heartNum - 1

		arg0:updateUI()

		if arg0.heartNum == 0 then
			local var0 = arg1 == var5 and var7 or var8

			arg0.charactor:fail(var0)

			if var0 == var8 then
				arg0.ghostChildController:createGhostLight(function(arg0)
					if arg0 then
						arg0.ghostBossController:onGhostDestroy()
					end
				end)
				arg0.charactor:setGhostFlag(false)
			end

			arg0.gameStartFlag = false

			arg0:timerStop()
			LeanTween.delayedCall(go(arg0._tf), 3, System.Action(function()
				arg0:gameOver()
			end))
		elseif arg1 == var6 then
			arg0.charactor:boom()
		end
	end
end

function var0.addScore(arg0, arg1)
	arg0.scoreNum = arg0.scoreNum + arg1

	arg0:updateUI()
end

function var0.gameOver(arg0)
	arg0.charactor:gameOver()
	arg0.flyer:gameOver()
	arg0.dropControl:gameOver()
	arg0.dropItemController:gameOver()
	arg0.dropColliderControll:gameOver()
	arg0.ghostBossController:gameOver()
	arg0.ghostChildController:gameOver()
	arg0.controllerUI:gameOver()
	arg0.eyesController:gameOver()

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0:SendSuccess(0)
	end

	arg0:showSettlement()
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = findTF(arg0.settlementUI, "ad/highText")
	local var4 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var3, var2)
	setText(var4, var1)
end

function var0.lostCandy(arg0)
	arg0:loseHeart(var5)
end

function var0.touchBoom(arg0)
	arg0:loseHeart(var6)
end

function var0.createGhost(arg0)
	if arg0.ghostChildController and arg0.ghostChildController:createGhost() then
		arg0.ghostBossController:onCreate()
	end
end

function var0.onCreateDropItem(arg0)
	if arg0.dropItemController then
		arg0.dropItemController:createDropItem()
	end
end

function var0.onRequestDrop(arg0)
	if arg0.flyer then
		arg0.flyer:addDropNum()
	end
end

function var0.onGhostCatch(arg0, arg1)
	if not arg0.charactor:getGhostFlag() then
		arg0.charactor:setGhostFlag(true, function()
			arg0.ghostChildController:removeChild(arg1)
		end)
		arg0.controllerUI:changeRemind(true)
		arg0.ghostBossController:onCatch()
	end
end

function var0.onUseLight(arg0, arg1)
	if not arg0.gameStartFlag then
		return
	end

	arg0.charactor:playLight(function(arg0)
		if arg0 and arg1 == var3 then
			arg0.ghostChildController:createGhostLight(function(arg0)
				if arg0 then
					arg0.ghostBossController:onGhostDestroy()
					arg0.controllerUI:changeRemind(false)
				end
			end)
			arg0.charactor:setGhostFlag(false)
		end
	end, arg1)
end

function var0.onColliderItem(arg0, arg1)
	var35("碰撞到了物品，数量:" .. #arg1)
end

function var0.onControllerDirectChange(arg0, arg1)
	arg0:changeDirect(arg1, true)
end

function var0.onControllerDirectUp(arg0, arg1)
	arg0:changeDirect(arg1, false)
end

function var0.changeDirect(arg0, arg1, arg2)
	if arg0.gameStartFlag then
		arg0.charactor:onDirectChange(arg1, arg2)
	end
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0:changeDirect(var1, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0:changeDirect(var1, false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0:changeDirect(var2, true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0:changeDirect(var2, false)
		end
	end
end

function var0.clearUI(arg0)
	setActive(arg0.scene, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		setActive(arg0.leaveUI, true)
		arg0:timerStop()

		arg0.gameStartFlag = false
	end
end

function var0.willExit(arg0)
	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	if LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end
end

return var0
