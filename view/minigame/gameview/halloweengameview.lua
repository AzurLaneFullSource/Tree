local var0_0 = class("HalloweenGameView", import("..BaseMiniGameView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 1
local var4_0 = 2
local var5_0 = 1
local var6_0 = 2
local var7_0 = 1
local var8_0 = 2
local var9_0 = {
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
local var10_0 = {
	30,
	80,
	120,
	160,
	180
}
local var11_0 = {
	4,
	6
}
local var12_0 = {
	0,
	30
}
local var13_0 = 0.5
local var14_0 = {
	{
		10,
		13
	},
	{
		7,
		10
	}
}
local var15_0 = {
	30
}
local var16_0 = {
	0,
	3
}
local var17_0 = {
	1,
	2
}
local var18_0 = {
	100,
	100,
	100,
	100
}
local var19_0 = {
	0,
	0,
	0,
	0,
	0,
	0,
	0
}
local var20_0 = {
	3,
	3.5,
	4,
	4.8,
	5.6,
	6.6,
	8.4
}
local var21_0 = {
	30,
	80,
	120,
	140,
	160,
	180
}
local var22_0 = {
	3,
	3.5,
	4,
	4.5,
	4.7,
	5
}
local var23_0 = {
	30,
	80,
	120,
	160,
	180
}
local var24_0 = 3
local var25_0 = {
	110,
	193,
	1170,
	193
}
local var26_0 = {
	117,
	848,
	1167,
	848
}
local var27_0 = Vector2(90, 244)
local var28_0 = 200
local var29_0 = 5
local var30_0 = 0
local var31_0 = 1000000
local var32_0 = 50000
local var33_0 = "event:/ui/getcandy"
local var34_0 = "event:/ui/jackboom"

local function var35_0(arg0_1)
	return
end

function var0_0.getUIName(arg0_2)
	return "HalloweenGameUI"
end

function var0_0.getBGM(arg0_3)
	return "backyard"
end

local function var36_0(arg0_4, arg1_4, arg2_4)
	local var0_4 = {}
	local var1_4 = {
		{
			0,
			4
		},
		{
			4,
			6
		}
	}
	local var2_4 = 1
	local var3_4 = -1

	var0_4.charactorTf = arg0_4
	var0_4.moveRanges = arg1_4
	var0_4.scene = arg2_4
	var0_4.speedX = 0
	var0_4.direct = 0
	var0_4.moveRightFlag = false
	var0_4.moveLeftFlag = false
	var0_4.charactorIdleCallback = false

	function var0_4.ctor(arg0_5)
		arg0_5.collider = findTF(arg0_5.charactorTf, "collider")
		arg0_5.follow = findTF(arg0_5.charactorTf, "follow")
		arg0_5.charAnimator = GetComponent(findTF(arg0_5.charactorTf, "char"), typeof(Animator))
		arg0_5.posLight = findTF(arg0_5.charactorTf, "posLight")
		arg0_5.lightCharAnimator = GetComponent(findTF(arg0_5.posLight, "char"), typeof(Animator))
		arg0_5.lightCharDft = GetComponent(findTF(arg0_5.posLight, "char"), typeof(DftAniEvent))
		arg0_5.lightEffectAnimator = GetComponent(findTF(arg0_5.posLight, "light"), typeof(Animator))
		arg0_5.charactorDft = GetComponent(findTF(arg0_5.charactorTf, "char"), typeof(DftAniEvent))

		arg0_5.charactorDft:SetEndEvent(function(arg0_6)
			arg0_5:onAnimationEnd()
		end)
		arg0_5:clearData()
	end

	function var0_4.clearData(arg0_7)
		arg0_7.inAction = false
		arg0_7.direct = 0
		arg0_7.directType = var2_4
		arg0_7.currentDirectType = nil
		arg0_7.ghostFlag = false
		arg0_7.ghostPlayFlag = false
		arg0_7.speedRangeIndex = 1
		arg0_7.maxSpeed = var11_0[arg0_7.speedRangeIndex]
		arg0_7.playLightFlag = false
		arg0_7.moveLeftFlag = false
		arg0_7.moveRightFlag = false
		arg0_7.speedX = 0
	end

	function var0_4.setGhostFlag(arg0_8, arg1_8, arg2_8)
		if arg1_8 and (arg0_8.ghostFlag or arg0_8.ghostPlayFlag) then
			return
		end

		arg0_8:ghostAniCallback(true)

		function arg0_8.aniCallback(arg0_9)
			if not arg0_9 then
				arg0_8.ghostFlag = arg1_8
			else
				arg0_8.ghostFlag = false
			end

			if arg2_8 then
				arg2_8()
			end
		end

		if arg1_8 then
			arg0_8:playGhostDrump()
		else
			arg0_8:hideDrumpGhost()

			arg0_8.ghostPlayFlag = false
			arg0_8.ghostFlag = false
		end
	end

	function var0_4.playLight(arg0_10, arg1_10, arg2_10)
		if arg0_10.playLightFlag or arg0_10.inAction then
			if arg1_10 then
				arg1_10(false)
			end

			return
		end

		arg0_10.playLightFlag = true

		setActive(arg0_10.posLight, true)
		arg0_10.lightCharDft:SetEndEvent(function()
			arg0_10.playLightFlag = false
		end)
		arg0_10.lightCharDft:SetTriggerEvent(function()
			if arg1_10 then
				arg1_10(true)
			end
		end)

		if arg2_10 == var3_0 then
			arg0_10.lightCharAnimator:Play("charLight", -1, 0)
			arg0_10.lightEffectAnimator:Play("lightOn", -1, 0)
		elseif arg2_10 == var4_0 then
			arg0_10.lightCharAnimator:Play("charUnLight", -1, 0)
			arg0_10.lightEffectAnimator:Play("lightOff", -1, 0)
		end
	end

	function var0_4.ghostAniCallback(arg0_13, arg1_13)
		if arg0_13.aniCallback then
			arg0_13.aniCallback(arg1_13)

			arg0_13.aniCallback = nil
		end
	end

	function var0_4.hideDrumpGhost(arg0_14)
		local var0_14 = findTF(arg0_14.charactorTf, "ghostContainer/posGhost")

		setActive(var0_14, false)
	end

	function var0_4.getGhostFlag(arg0_15)
		return arg0_15.ghostFlag or arg0_15.ghostPlayFlag
	end

	function var0_4.getActionFlag(arg0_16)
		return arg0_16.inAction
	end

	function var0_4.playGhostDrump(arg0_17)
		arg0_17.ghostPlayFlag = true

		local var0_17 = findTF(arg0_17.charactorTf, "ghostContainer/posGhost")

		setActive(var0_17, true)

		local var1_17 = GetComponent(var0_17, typeof(Animator))

		GetComponent(var0_17, typeof(DftAniEvent)):SetEndEvent(function()
			arg0_17:ghostAniCallback()
			setActive(var0_17, false)

			arg0_17.ghostPlayFlag = false

			if arg0_17.inSpecial then
				arg0_17.currentDirectType = nil

				arg0_17:checkPlayerAnimation(true)

				arg0_17.inSpecial = false
			end
		end)
		var1_17:Play("drump", -1, 0)

		local var2_17 = findTF(var0_17, "drumpGhost/char")
		local var3_17 = GetComponent(var2_17, typeof(Animator))

		var3_17:SetInteger("state_type", 0)
		var3_17:SetInteger("state_type", 3)
	end

	function var0_4.boom(arg0_19)
		if arg0_19.inAction then
			return
		end

		local var0_19 = "boom"

		if arg0_19.currentDirectType == var1_0 then
			var0_19 = var0_19 .. "_left"
		else
			var0_19 = var0_19 .. "_right"
		end

		if arg0_19.ghostFlag then
			var0_19 = var0_19 .. "_ghost"
		end

		arg0_19:PlayAniamtion(var0_19, function()
			arg0_19:checkPlayerAnimation(true)

			arg0_19.inAction = false
		end)

		arg0_19.inAction = true
	end

	function var0_4.fail(arg0_21, arg1_21)
		if arg0_21.inAction then
			return
		end

		local var0_21 = "fail"

		if arg0_21.currentDirectType == var1_0 then
			var0_21 = var0_21 .. "_left"
		else
			var0_21 = var0_21 .. "_right"
		end

		if arg1_21 == var7_0 then
			var0_21 = var0_21 .. "_miss"
		elseif arg1_21 == var8_0 then
			var0_21 = var0_21 .. "_boom"
		end

		if arg0_21.ghostFlag then
			var0_21 = var0_21 .. "_ghost"
		end

		arg0_21:PlayAniamtion(var0_21, function()
			arg0_21.inAction = false
		end)

		arg0_21.inAction = true
	end

	function var0_4.gameOver(arg0_23)
		arg0_23.moveFlag = false

		if arg0_23.charactorIdleCallback then
			arg0_23.charactorIdleCallback(false)
		end
	end

	function var0_4.start(arg0_24)
		arg0_24.moveFlag = true
		arg0_24.startTime = var30_0

		arg0_24:clearData()
	end

	function var0_4.step(arg0_25)
		if not arg0_25.moveFlag then
			return
		end

		if not arg0_25.inAction then
			if arg0_25.direct ~= 0 then
				if arg0_25.maxSpeed - math.abs(arg0_25.speedX) < var13_0 then
					arg0_25.speedX = arg0_25.maxSpeed * arg0_25.direct
				elseif math.abs(arg0_25.speedX) ~= arg0_25.maxSpeed then
					arg0_25.speedX = (math.abs(arg0_25.speedX) + var13_0) * arg0_25.direct
				end

				local var0_25 = arg0_25.ghostFlag and 0.5 or 1
				local var1_25 = arg0_25.charactorTf.localPosition.x + arg0_25.speedX * var0_25

				if var1_25 < arg0_25.moveRanges[1] then
					var1_25 = arg0_25.moveRanges[1]
				end

				if var1_25 > arg0_25.moveRanges[3] then
					var1_25 = arg0_25.moveRanges[3]
				end

				arg0_25.charactorTf.localPosition = Vector3(var1_25, arg0_25.charactorTf.localPosition.y, arg0_25.charactorTf.localPosition.z)
			end

			arg0_25:checkPlayerAnimation()
		end

		if arg0_25.speedRangeIndex < #var12_0 then
			for iter0_25 = #var12_0, 1, -1 do
				if var30_0 - arg0_25.startTime > var12_0[iter0_25] and arg0_25.speedRangeIndex ~= iter0_25 then
					var35_0("角色速度提升")

					arg0_25.speedRangeIndex = iter0_25
					arg0_25.maxSpeed = var11_0[arg0_25.speedRangeIndex]

					break
				end
			end
		end

		if arg0_25.speedX == 0 and not arg0_25.ghostFlag and not arg0_25.inAction then
			if arg0_25.specialTime then
				if var30_0 - arg0_25.specialTime >= 7 then
					arg0_25.specialTime = nil
					arg0_25.inSpecial = true

					arg0_25:PlayAniamtion("special", function()
						arg0_25.currentDirectType = nil

						arg0_25:checkPlayerAnimation(true)

						arg0_25.inSpecial = false
					end)
				end
			else
				arg0_25.specialTime = var30_0
			end
		else
			arg0_25.specialTime = nil
		end

		if arg0_25.speedX == 0 and not arg0_25.inAction then
			if arg0_25.idleTime then
				if var30_0 - arg0_25.idleTime >= 5 then
					arg0_25.idleTime = nil

					if arg0_25.charactorIdleCallback then
						arg0_25.charactorIdleCallback(true)
					end
				end
			else
				arg0_25.idleTime = var30_0
			end
		else
			arg0_25.idleTime = nil

			if arg0_25.charactorIdleCallback then
				arg0_25.charactorIdleCallback(false)
			end
		end
	end

	function var0_4.checkPlayerAnimation(arg0_27, arg1_27)
		if arg0_27.currentDirectType ~= arg0_27.directType or arg1_27 then
			arg0_27.currentDirectType = arg0_27.directType

			if arg0_27.currentDirectType == var2_0 then
				arg0_27:PlayAniamtion("idle_right")
			else
				arg0_27:PlayAniamtion("idle_left")
			end
		end

		local var0_27

		if arg0_27.speedX == 0 then
			var0_27 = 0
		else
			for iter0_27 = 1, #var1_4 do
				local var1_27 = var1_4[iter0_27]

				if math.abs(arg0_27.speedX) ~= 0 and arg0_27.maxSpeed > var1_27[1] and arg0_27.maxSpeed <= var1_27[2] then
					var0_27 = iter0_27
				end
			end
		end

		if arg0_27.charAnimator:GetInteger("speed_type") ~= var0_27 then
			arg0_27.charAnimator:SetInteger("speed_type", var0_27)
		end

		if arg0_27.charAnimator:GetBool("ghost") ~= arg0_27.ghostFlag then
			arg0_27.charAnimator:SetBool("ghost", arg0_27.ghostFlag)
		end
	end

	function var0_4.PlayAniamtion(arg0_28, arg1_28, arg2_28)
		var35_0("开始播放动作:" .. arg1_28)
		arg0_28.charAnimator:Play(arg1_28, -1, 0)

		if arg0_28.onAniCallback then
			var35_0(arg0_28.onAniamtionName .. "的animation被" .. arg1_28 .. "中断")
		end

		arg0_28.onAniamtionName = arg1_28
		arg0_28.onAniCallback = arg2_28
	end

	function var0_4.onAnimationEnd(arg0_29)
		var35_0("动作播放结束:" .. arg0_29.onAniamtionName)

		if arg0_29.onAniCallback then
			local var0_29 = arg0_29.onAniCallback

			arg0_29.onAniCallback = nil

			var0_29()
		end
	end

	function var0_4.onDirectChange(arg0_30, arg1_30, arg2_30)
		if not arg0_30.moveFlag then
			return
		end

		if arg0_30.inSpecial then
			arg0_30.currentDirectType = nil

			arg0_30:checkPlayerAnimation(true)

			arg0_30.inSpecial = false
		end

		if arg1_30 == var1_0 then
			arg0_30.moveLeftFlag = arg2_30
		elseif arg1_30 == var2_0 then
			arg0_30.moveRightFlag = arg2_30
		end

		local var0_30

		if arg2_30 then
			var0_30 = arg1_30 == var1_0 and var3_4 or var2_4
		else
			var0_30 = arg0_30.moveRightFlag and 1 or arg0_30.moveLeftFlag and -1 or 0
		end

		if arg0_30.direct ~= var0_30 or var0_30 == 0 then
			arg0_30.speedX = 0
		end

		arg0_30.direct = var0_30

		if arg0_30.direct ~= 0 then
			arg0_30.directType = arg0_30.direct == var3_4 and var1_0 or var2_0
		end
	end

	function var0_4.getCollider(arg0_31)
		if not arg0_31.collider then
			-- block empty
		end

		local var0_31 = arg0_31.collider.sizeDelta.x
		local var1_31 = arg0_31.collider.sizeDelta.y
		local var2_31 = arg0_31.collider.position
		local var3_31 = arg0_31.scene:InverseTransformPoint(var2_31.x, var2_31.y, 0)

		var3_31.x = var3_31.x - var0_31 / 2

		return {
			pos = var3_31,
			width = var0_31,
			height = var1_31
		}
	end

	function var0_4.getFollowPos(arg0_32)
		return arg0_32.follow.position
	end

	function var0_4.getLeavePos(arg0_33)
		local var0_33

		if arg0_33.ghostPlayFlag then
			var0_33 = findTF(arg0_33.charactorTf, "ghostContainer/posGhost").position

			var35_0("播放动画中，获取幽灵当前位置")
		else
			if not arg0_33.leavePos then
				arg0_33.leavePos = findTF(arg0_33.charactorTf, "posGhostLeave")
			end

			var0_33 = arg0_33.leavePos.position

			var35_0("播放动画结束，获取头顶位置")
		end

		return var0_33
	end

	function var0_4.clearDirect(arg0_34)
		arg0_34.direct = 0
		arg0_34.speedX = 0
	end

	var0_4:ctor()

	return var0_4
end

local function var37_0(arg0_35, arg1_35)
	local var0_35 = {
		moveTf = arg0_35,
		useLightTf = arg1_35
	}

	var0_35.initFlag = false
	var0_35.direct = 0
	var0_35.pointChangeCallback = nil
	var0_35.pointUpCallback = nil
	var0_35.pointLightCallback = nil
	var0_35.lightTime = nil

	function var0_35.Ctor(arg0_36)
		arg0_36.buttonDelegate = GetOrAddComponent(arg0_36.useLightTf, "EventTriggerListener")

		arg0_36.buttonDelegate:AddPointDownFunc(function(arg0_37, arg1_37)
			local var0_37

			if not arg0_36.lightTime or var30_0 - arg0_36.lightTime > var29_0 then
				var0_37 = var3_0
				arg0_36.lightTime = var30_0
			else
				var0_37 = var4_0
			end

			if arg0_36.pointLightCallback then
				arg0_36.pointLightCallback(var0_37)
			end
		end)

		arg0_36.delegateLeft = GetOrAddComponent(findTF(arg0_36.moveTf, "left"), "EventTriggerListener")
		arg0_36.delegateRight = GetOrAddComponent(findTF(arg0_36.moveTf, "right"), "EventTriggerListener")

		arg0_36.delegateLeft:AddPointDownFunc(function(arg0_38, arg1_38)
			if arg0_36.pointChangeCallback then
				arg0_36.pointChangeCallback(var1_0)
			end
		end)
		arg0_36.delegateRight:AddPointDownFunc(function(arg0_39, arg1_39)
			if arg0_36.pointChangeCallback then
				arg0_36.pointChangeCallback(var2_0)
			end
		end)
		arg0_36.delegateLeft:AddPointUpFunc(function(arg0_40, arg1_40)
			if arg0_36.pointUpCallback then
				arg0_36.pointUpCallback(var1_0)
			end
		end)
		arg0_36.delegateRight:AddPointUpFunc(function(arg0_41, arg1_41)
			if arg0_36.pointUpCallback then
				arg0_36.pointUpCallback(var2_0)
			end
		end)

		arg0_36.initFlag = true
	end

	function var0_35.callbackDirect(arg0_42, arg1_42, arg2_42)
		if not arg2_42 then
			return
		end

		local var0_42 = arg0_42:getPointFromEventData(arg1_42)

		var35_0(var0_42.x .. "  " .. var0_42.y)

		local var1_42 = arg0_42:getDirect(var0_42)

		arg2_42(var1_42)
	end

	function var0_35.getPointFromEventData(arg0_43, arg1_43)
		if not arg0_43.uiCam then
			arg0_43.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
		end

		local var0_43 = arg0_43.uiCam:ScreenToWorldPoint(arg1_43.position)

		return (arg0_43.moveTf:InverseTransformPoint(var0_43))
	end

	function var0_35.getDirect(arg0_44, arg1_44)
		local var0_44 = arg0_44.moveTf.sizeDelta.x
		local var1_44 = arg0_44.moveTf.sizeDelta.y

		if arg1_44.x >= 0 then
			return var2_0
		else
			return var1_0
		end
	end

	function var0_35.changeRemind(arg0_45, arg1_45)
		arg0_45.remindFlag = arg1_45

		local var0_45 = GetComponent(arg0_45.useLightTf, typeof(Animator))

		if arg1_45 and isActive(findTF(arg0_45.useLightTf, "light")) then
			var0_45:Play("useLightRemind", -1, 0)
		else
			var0_45:Play("useLightIdle", -1, 0)
		end
	end

	function var0_35.start(arg0_46)
		setActive(findTF(arg0_46.useLightTf, "light"), true)

		arg0_46.lightTime = nil
	end

	function var0_35.step(arg0_47)
		if not arg0_47.lightTime or var30_0 - arg0_47.lightTime > var29_0 then
			if not isActive(findTF(arg0_47.useLightTf, "light")) then
				setActive(findTF(arg0_47.useLightTf, "light"), true)
				arg0_47:changeRemind(arg0_47.remindFlag)
			end
		elseif isActive(findTF(arg0_47.useLightTf, "light")) then
			setActive(findTF(arg0_47.useLightTf, "light"), false)
		end
	end

	function var0_35.gameOver(arg0_48)
		setActive(findTF(arg0_48.useLightTf, "light"), false)
	end

	function var0_35.destroy(arg0_49)
		if arg0_49.delegateLeft then
			ClearEventTrigger(arg0_49.delegateLeft)
		end

		if arg0_49.delegateRight then
			ClearEventTrigger(arg0_49.delegateRight)
		end
	end

	var0_35:Ctor()

	return var0_35
end

local function var38_0(arg0_50, arg1_50)
	local var0_50 = {
		_tf = arg0_50,
		moveRange = arg1_50
	}

	var0_50.targetX = nil
	var0_50.speedX = 1
	var0_50.dropCallback = nil
	var0_50.dropNum = 0

	function var0_50.Ctor(arg0_51)
		arg0_51.bodyAnimator = GetComponent(findTF(arg0_51._tf, "char/body"), typeof(Animator))
		arg0_51.bodyDft = GetComponent(findTF(arg0_51._tf, "char/body"), typeof(DftAniEvent))

		arg0_51.bodyDft:SetEndEvent(function()
			arg0_51:dropEnd()
		end)
		arg0_51.bodyDft:SetTriggerEvent(function()
			arg0_51:dropItem()
		end)
	end

	function var0_50.start(arg0_54)
		arg0_54.moveFlag = true
		arg0_54.speedLevel = 1
	end

	function var0_50.gameOver(arg0_55)
		arg0_55.moveFlag = false
	end

	function var0_50.step(arg0_56)
		if not arg0_56.moveFlag then
			return
		end

		if arg0_56.targetX then
			if arg0_56.targetX ~= arg0_56._tf.localPosition.x then
				if arg0_56.targetX > arg0_56._tf.localPosition.x then
					arg0_56._tf.localPosition = Vector3(arg0_56._tf.localPosition.x + arg0_56:getSpeed(), arg0_56._tf.localPosition.y, arg0_56._tf.localPosition.z)
				else
					arg0_56._tf.localPosition = Vector3(arg0_56._tf.localPosition.x - arg0_56:getSpeed(), arg0_56._tf.localPosition.y, arg0_56._tf.localPosition.z)
				end
			end

			if math.abs(arg0_56.targetX - arg0_56._tf.localPosition.x) <= arg0_56:getSpeed() then
				arg0_56.targetX = nil
			end
		end

		if not arg0_56.targetX then
			arg0_56:setNextTarget()
		end

		if arg0_56.speedLevel < #var22_0 and var23_0[arg0_56.speedLevel] < var30_0 then
			arg0_56.speedLevel = arg0_56.speedLevel + 1
		end
	end

	function var0_50.getSpeed(arg0_57)
		return var22_0[arg0_57.speedLevel]
	end

	function var0_50.dropItem(arg0_58)
		if arg0_58.dropCallback then
			arg0_58.dropCallback()
		end
	end

	function var0_50.dropEnd(arg0_59)
		if arg0_59.dropNum > 0 then
			arg0_59.dropNum = arg0_59.dropNum - 1
		end

		arg0_59.bodyAnimator:SetInteger("dropNums", arg0_59.dropNum)
	end

	function var0_50.addDropNum(arg0_60)
		arg0_60.dropNum = arg0_60.dropNum + 1

		arg0_60.bodyAnimator:SetInteger("dropNums", arg0_60.dropNum)
	end

	function var0_50.setNextTarget(arg0_61)
		if not arg0_61.targetX then
			if arg0_61._tf.localPosition.x < arg0_61.moveRange[3] / 3 then
				arg0_61.targetX = math.random(arg0_61.moveRange[3] * 2 / 3, arg0_61.moveRange[3])
			else
				arg0_61.targetX = math.random(arg0_61.moveRange[1], arg0_61.moveRange[3] / 3)
			end
		end

		if arg0_61._tf.localPosition.x > arg0_61.targetX then
			arg0_61._tf.localScale = Vector3(-1, 1, 1)
		else
			arg0_61._tf.localScale = Vector3(1, 1, 1)
		end
	end

	function var0_50.getDropWorldPos(arg0_62)
		if not arg0_62.posDrop then
			arg0_62.posDrop = findTF(arg0_62._tf, "char/posDrop")
		end

		return arg0_62.posDrop.position
	end

	function var0_50.clear(arg0_63)
		arg0_63.dropNum = 0
		arg0_63.dropCallback = nil
	end

	var0_50:Ctor()

	return var0_50
end

local function var39_0()
	local var0_64 = {}

	var0_64.speedLevel = 1
	var0_64.dropRequestCallback = nil

	function var0_64.start(arg0_65)
		arg0_65.startFlag = true
		arg0_65.speedLevel = 1
		arg0_65.startTime = var30_0
	end

	function var0_64.gameOver(arg0_66)
		arg0_66.startFlag = false
		arg0_66.stepTime = nil
		arg0_66.speedLevel = nil
	end

	function var0_64.step(arg0_67)
		if not arg0_67.startFlag then
			return
		end

		if not arg0_67.stepTime then
			arg0_67.stepTime = arg0_67.startTime + math.random() * (var9_0[arg0_67.speedLevel][1] - var9_0[arg0_67.speedLevel][2]) + var9_0[arg0_67.speedLevel][1]
		elseif var30_0 >= arg0_67.stepTime then
			arg0_67.stepTime = var30_0 + math.random(var9_0[arg0_67.speedLevel][1], var9_0[arg0_67.speedLevel][2])

			if arg0_67.dropRequestCallback then
				arg0_67.dropRequestCallback()
			end
		end

		if arg0_67.speedLevel <= #var10_0 then
			if not arg0_67.nextSpeedUpTime then
				arg0_67.nextSpeedUpTime = arg0_67.startTime + var10_0[arg0_67.speedLevel]
			end

			if var30_0 >= arg0_67.nextSpeedUpTime then
				arg0_67.speedLevel = arg0_67.speedLevel + 1
				arg0_67.nextSpeedUpTime = arg0_67.speedLevel <= #var10_0 and var30_0 + var10_0[arg0_67.speedLevel] or nil
			end
		end
	end

	return var0_64
end

local function var40_0(arg0_68, arg1_68)
	local var0_68 = {
		flyer = arg0_68,
		scene = arg1_68,
		dropItems = {}
	}

	var0_68.lostCallback = nil
	var0_68.boomCallback = nil
	var0_68.dropSpeedUpCallback = nil

	function var0_68.start(arg0_69)
		arg0_69.startFlag = true
		arg0_69.speedLevel = 1
		arg0_69.nextSpeedUpTime = nil
		arg0_69.startTime = var30_0
	end

	function var0_68.gameOver(arg0_70)
		arg0_70.startFlag = false

		for iter0_70 = #arg0_70.dropItems, 1, -1 do
			local var0_70 = arg0_70.dropItems[iter0_70].tf
			local var1_70 = table.remove(arg0_70.dropItems, iter0_70)

			arg0_70:returnDropItem(var1_70)
		end
	end

	function var0_68.createDropItem(arg0_71)
		local var0_71 = arg0_71:getDropItem()
		local var1_71 = arg0_71.flyer:getDropWorldPos()
		local var2_71 = arg0_71.scene:InverseTransformPoint(var1_71)

		var0_71.tf.localPosition = var2_71

		if not arg0_71.dropItems then
			arg0_71.dropItems = {}
		end

		table.insert(arg0_71.dropItems, var0_71)
	end

	function var0_68.getDropItem(arg0_72)
		if not arg0_72.dropItemPool then
			arg0_72.dropItemPool = {}
		end

		local var0_72

		if #arg0_72.dropItemPool > 0 then
			var0_72 = table.remove(arg0_72.dropItemPool, 1)
		else
			local var1_72 = tf(instantiate(findTF(arg0_72.scene, "tplItem")))

			SetParent(var1_72, arg0_72.scene, false)

			var0_72 = {
				tf = var1_72
			}
		end

		local var2_72 = math.random(var17_0[1], var17_0[2]) <= var17_0[1] and var6_0 or var5_0

		var0_72.type = var2_72
		var0_72.speed = var20_0[arg0_72.speedLevel]

		setActive(var0_72.tf, true)
		arg0_72:setItemData(var0_72, var2_72)

		return var0_72
	end

	function var0_68.setItemData(arg0_73, arg1_73, arg2_73)
		local var0_73 = arg1_73.tf
		local var1_73 = findTF(var0_73, "candy")
		local var2_73 = findTF(var0_73, "boom")

		arg1_73.score = 0

		if arg2_73 == var5_0 then
			setActive(var1_73, true)
			setActive(var2_73, false)

			local var3_73 = math.random(var16_0[1], var16_0[2])
			local var4_73 = GetComponent(findTF(var1_73, "img"), typeof(Animator))

			var4_73:SetInteger("type", var3_73)
			var4_73:Play("candyIdle", -1, 0)

			arg1_73.score = var18_0[var3_73 + 1]
		else
			setActive(var1_73, false)
			setActive(var2_73, true)
		end
	end

	function var0_68.returnDropItem(arg0_74, arg1_74)
		setActive(arg1_74.tf, false)
		table.insert(arg0_74.dropItemPool, arg1_74)
	end

	function var0_68.step(arg0_75)
		if not arg0_75.startFlag then
			return
		end

		if arg0_75.speedLevel <= #var21_0 then
			if not arg0_75.nextSpeedUpTime then
				arg0_75.nextSpeedUpTime = arg0_75.startTime + var21_0[arg0_75.speedLevel]
			end

			if var30_0 >= arg0_75.nextSpeedUpTime then
				arg0_75.speedLevel = arg0_75.speedLevel + 1
				arg0_75.nextSpeedUpTime = arg0_75.speedLevel <= #var21_0 and arg0_75.startTime + var21_0[arg0_75.speedLevel] or nil

				if arg0_75.dropSpeedUpCallback then
					arg0_75.dropSpeedUpCallback()
				end
			end
		end

		if arg0_75.dropItems and #arg0_75.dropItems > 0 then
			for iter0_75 = #arg0_75.dropItems, 1, -1 do
				local var0_75 = arg0_75.dropItems[iter0_75].tf
				local var1_75 = arg0_75.dropItems[iter0_75].speed + var19_0[arg0_75.speedLevel]

				arg0_75.dropItems[iter0_75].speed = var1_75

				if var0_75.localPosition.y <= var28_0 then
					local var2_75 = table.remove(arg0_75.dropItems, iter0_75)

					if var2_75.type == var5_0 and arg0_75.lostCallback then
						arg0_75:playItemLost(var2_75)
						arg0_75.lostCallback()
					else
						arg0_75:returnDropItem(var2_75)
					end
				else
					var0_75.localPosition = Vector3(var0_75.localPosition.x, var0_75.localPosition.y - var1_75, var0_75.localPosition.z)
				end
			end
		end
	end

	function var0_68.dropItemCollider(arg0_76, arg1_76)
		for iter0_76 = #arg0_76.dropItems, 1, -1 do
			if table.contains(arg1_76, iter0_76) then
				local var0_76 = table.remove(arg0_76.dropItems, iter0_76)

				arg0_76:playItemEffect(var0_76)
			end
		end
	end

	function var0_68.playItemEffect(arg0_77, arg1_77)
		local var0_77 = arg1_77.type

		if var0_77 == var5_0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var33_0)

			local var1_77 = GetComponent(findTF(arg1_77.tf, "candy/img"), typeof(Animator))

			GetComponent(findTF(arg1_77.tf, "candy/img"), typeof(DftAniEvent)):SetEndEvent(function()
				arg0_77:returnDropItem(arg1_77)
			end)
			var1_77:SetTrigger("effect")
		elseif var0_77 == var6_0 then
			local var2_77 = GetComponent(findTF(arg1_77.tf, "boom/img"), typeof(Animator))
			local var3_77 = GetComponent(findTF(arg1_77.tf, "boom/img"), typeof(DftAniEvent))

			var3_77:SetEndEvent(function()
				arg0_77:returnDropItem(arg1_77)
			end)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var34_0)
			var3_77:SetTriggerEvent(function()
				if arg0_77.boomCallback then
					arg0_77.boomCallback()
				end
			end)
			var2_77:SetTrigger("effect")
		end
	end

	function var0_68.playItemLost(arg0_81, arg1_81)
		if arg1_81.type == var5_0 then
			local var0_81 = GetComponent(findTF(arg1_81.tf, "candy/img"), typeof(Animator))
			local var1_81 = findTF(arg1_81.tf, "candy/candy_glow")
			local var2_81 = GetComponent(findTF(arg1_81.tf, "candy/img"), typeof(DftAniEvent))
			local var3_81 = var0_81:GetLayerIndex("newLayer")

			var2_81:SetEndEvent(function()
				setActive(var1_81, false)
				arg0_81:returnDropItem(arg1_81)
			end)
			var2_81:SetTriggerEvent(function()
				setActive(var1_81, true)
			end)
			var0_81:Play("candyLost", var3_81, 0)
		end
	end

	function var0_68.getDropItemsCollider(arg0_84)
		if not arg0_84.dropItems then
			return
		end

		local var0_84 = {}

		for iter0_84 = 1, #arg0_84.dropItems do
			local var1_84 = findTF(arg0_84.dropItems[iter0_84].tf, "collider")
			local var2_84 = var1_84.sizeDelta.x
			local var3_84 = var1_84.sizeDelta.y
			local var4_84 = var1_84.position

			table.insert(var0_84, {
				x = var4_84.x,
				y = var4_84.y,
				width = var2_84,
				height = var3_84,
				index = iter0_84,
				type = arg0_84.dropItems[iter0_84].type,
				score = arg0_84.dropItems[iter0_84].score
			})
		end

		return var0_84
	end

	return var0_68
end

local function var41_0(arg0_85, arg1_85, arg2_85)
	local var0_85 = {
		charactor = arg0_85,
		dropItemController = arg1_85,
		scene = arg2_85
	}

	var0_85.colliderDropItemCallback = nil

	function var0_85.start(arg0_86)
		arg0_86.startFlag = true
	end

	function var0_85.gameOver(arg0_87)
		arg0_87.startFlag = false
	end

	function var0_85.step(arg0_88)
		if not arg0_88.startFlag then
			return
		end

		arg0_88:checkCollider()
	end

	function var0_85.checkCollider(arg0_89)
		local var0_89 = {}
		local var1_89 = arg0_89.dropItemController:getDropItemsCollider()
		local var2_89 = arg0_89.charactor:getCollider()
		local var3_89 = var2_89.pos

		if var1_89 and #var1_89 > 0 then
			for iter0_89 = 1, #var1_89 do
				local var4_89 = var1_89[iter0_89]
				local var5_89 = arg0_89.scene:InverseTransformPoint(var4_89.x, var4_89.y, 0)

				if arg0_89:checkRectCollider(var3_89, var5_89, var2_89, var4_89) then
					table.insert(var0_89, var4_89.index)

					if arg0_89.colliderDropItemCallback then
						arg0_89.colliderDropItemCallback(var4_89)
					end
				end
			end
		end

		if #var0_89 > 0 then
			arg0_89.dropItemController:dropItemCollider(var0_89)
		end
	end

	function var0_85.checkRectCollider(arg0_90, arg1_90, arg2_90, arg3_90, arg4_90)
		local var0_90 = arg1_90.x
		local var1_90 = arg1_90.y
		local var2_90 = arg3_90.width
		local var3_90 = arg3_90.height
		local var4_90 = arg2_90.x
		local var5_90 = arg2_90.y
		local var6_90 = arg4_90.width
		local var7_90 = arg4_90.height

		if var4_90 <= var0_90 and var0_90 >= var4_90 + var6_90 then
			return false
		elseif var0_90 <= var4_90 and var4_90 >= var0_90 + var2_90 then
			return false
		elseif var5_90 <= var1_90 and var1_90 >= var5_90 + var7_90 then
			return false
		elseif var1_90 <= var5_90 and var5_90 >= var1_90 + var3_90 then
			return false
		else
			return true
		end
	end

	return var0_85
end

local function var42_0(arg0_91)
	local var0_91 = {
		_tf = arg0_91
	}

	var0_91.speedLevel = 1
	var0_91.createGhostCallback = nil
	var0_91.ghostSpeedUpCallback = nil

	function var0_91.start(arg0_92)
		arg0_92.startFlag = true
		arg0_92.speedLevel = 1
		arg0_92.startTime = var30_0
		arg0_92.bossAnimator = GetComponent(findTF(arg0_92._tf, "char"), typeof(Animator))
		arg0_92.tip = findTF(arg0_92._tf, "tip")
	end

	function var0_91.gameOver(arg0_93)
		arg0_93.startFlag = false
		arg0_93.stepTime = nil

		setActive(arg0_93.tip, false)
		arg0_93.bossAnimator:SetInteger("state_type", 0)
	end

	function var0_91.step(arg0_94)
		if not arg0_94.startFlag then
			return
		end

		if not arg0_94.stepTime then
			arg0_94.stepTime = arg0_94.startTime + math.random(var14_0[arg0_94.speedLevel][1], var14_0[arg0_94.speedLevel][2])
		elseif var30_0 >= arg0_94.stepTime then
			arg0_94.stepTime = var30_0 + math.random(var14_0[arg0_94.speedLevel][1], var14_0[arg0_94.speedLevel][2])

			if arg0_94.createGhostCallback then
				arg0_94.createGhostCallback()
			end
		end

		if arg0_94.speedLevel <= #var15_0 then
			if not arg0_94.nextSpeedUpTime then
				arg0_94.nextSpeedUpTime = arg0_94.startTime + var15_0[arg0_94.speedLevel]
			end

			if var30_0 >= arg0_94.nextSpeedUpTime then
				arg0_94.speedLevel = arg0_94.speedLevel + 1
				arg0_94.nextSpeedUpTime = arg0_94.speedLevel <= #var15_0 and arg0_94.nextSpeedUpTime + var15_0[arg0_94.speedLevel] or nil

				if arg0_94.ghostSpeedUpCallback then
					arg0_94.ghostSpeedUpCallback()
				end

				var35_0("幽灵生成速度提升" .. (arg0_94.nextSpeedUpTime or "(已经达到最高速度)"))
			end
		end
	end

	function var0_91.showTip(arg0_95, arg1_95)
		if LeanTween.isTweening(go(arg0_95.tip)) then
			LeanTween.cancel(go(arg0_95.tip))
		end

		setActive(findTF(arg0_95.tip, "img1"), false)
		setActive(findTF(arg0_95.tip, "img2"), false)
		setActive(findTF(arg0_95.tip, "img" .. arg1_95), true)
		setActive(arg0_95.tip, true)
		LeanTween.delayedCall(go(arg0_95.tip), 10, System.Action(function()
			setActive(arg0_95.tip, false)
		end))
	end

	function var0_91.onCreate(arg0_97)
		arg0_97.bossAnimator:SetInteger("state_type", 3)
	end

	function var0_91.onCatch(arg0_98)
		arg0_98.bossAnimator:SetInteger("state_type", 2)
	end

	function var0_91.onGhostDestroy(arg0_99)
		arg0_99.bossAnimator:SetInteger("state_type", 1)

		arg0_99.stepTime = var30_0 + math.random(var14_0[arg0_99.speedLevel][1], var14_0[arg0_99.speedLevel][2])
	end

	function var0_91.destory(arg0_100)
		if LeanTween.isTweening(go(arg0_100.tip)) then
			LeanTween.cancel(go(arg0_100.tip))
		end
	end

	return var0_91
end

local function var43_0(arg0_101, arg1_101, arg2_101)
	local var0_101 = {}
	local var1_101 = 4

	var0_101.tplGhost = arg0_101
	var0_101.charactor = arg1_101
	var0_101.scene = arg2_101
	var0_101.catchCharactorCallback = nil

	function var0_101.start(arg0_102)
		arg0_102.startFlag = true
	end

	function var0_101.gameOver(arg0_103)
		arg0_103.startFlag = false

		if not arg0_103.ghostChilds then
			return
		end

		for iter0_103 = #arg0_103.ghostChilds, 1, -1 do
			local var0_103 = arg0_103.ghostChilds[iter0_103]

			arg0_103:removeChild(var0_103)
		end
	end

	function var0_101.step(arg0_104)
		if not arg0_104.startFlag or not arg0_104.ghostChilds then
			return
		end

		local var0_104 = arg0_104.charactor:getFollowPos()
		local var1_104 = arg0_104.scene:InverseTransformPoint(var0_104)

		for iter0_104 = #arg0_104.ghostChilds, 1, -1 do
			local var2_104 = arg0_104.ghostChilds[iter0_104]

			if isActive(var2_104) then
				local var3_104 = var2_104.anchoredPosition
				local var4_104 = 0
				local var5_104 = 0
				local var6_104 = false
				local var7_104 = false

				if math.abs(var1_104.x - var3_104.x) > 10 then
					var4_104 = var1_101 * (var1_104.x > var3_104.x and 1 or -1)
				else
					var6_104 = true
				end

				if math.abs(var1_104.y - var3_104.y) > 10 then
					var5_104 = var1_101 * (var1_104.y > var3_104.y and 1 or -1)
				else
					var7_104 = true
				end

				if not arg0_104.charactor:getGhostFlag() and not arg0_104.charactor:getActionFlag() and var7_104 and var6_104 then
					setActive(var2_104, false)

					if arg0_104.catchCharactorCallback then
						arg0_104.catchCharactorCallback(var2_104)
					end

					return
				end

				var3_104.x = var3_104.x + var4_104
				var3_104.y = var3_104.y + var5_104
				arg0_104.ghostChilds[iter0_104].anchoredPosition = var3_104
			end
		end
	end

	function var0_101.removeChild(arg0_105, arg1_105)
		for iter0_105 = 1, #arg0_105.ghostChilds do
			if arg1_105 == arg0_105.ghostChilds[iter0_105] then
				local var0_105 = table.remove(arg0_105.ghostChilds, iter0_105)

				arg0_105:returnGhost(var0_105)

				return
			end
		end
	end

	function var0_101.createGhost(arg0_106)
		if not arg0_106.ghostChilds then
			arg0_106.ghostChilds = {}
		end

		if #arg0_106.ghostChilds > 0 or arg1_101:getGhostFlag() then
			return false
		end

		local var0_106 = arg0_106:getGhostChild()

		var0_106.anchoredPosition = var27_0

		GetComponent(findTF(var0_106, "char"), typeof(Animator)):SetInteger("state_type", 1)
		table.insert(arg0_106.ghostChilds, var0_106)

		return true
	end

	function var0_101.getGhostChild(arg0_107)
		if not arg0_107.ghostPool then
			arg0_107.ghostPool = {}
		end

		local var0_107

		if #arg0_107.ghostPool > 0 then
			var0_107 = table.remove(arg0_107.ghostPool, #arg0_107.ghostPool)
		else
			var0_107 = tf(instantiate(arg0_107.tplGhost))

			SetParent(var0_107, arg0_107.scene, false)
		end

		setActive(var0_107, true)

		return var0_107
	end

	function var0_101.returnGhost(arg0_108, arg1_108)
		setActive(arg1_108, false)
		table.insert(arg0_108.ghostPool, arg1_108)
	end

	function var0_101.createGhostLight(arg0_109, arg1_109)
		if not arg0_109.lightGhost then
			arg0_109.lightGhost = tf(instantiate(arg0_109.tplGhost))
			arg0_109.lightGhost.name = "lightGhost"
			arg0_109.lightAnimator = GetComponent(findTF(arg0_109.lightGhost, "char"), typeof(Animator))

			GetComponent(findTF(arg0_109.lightGhost, "char"), typeof(DftAniEvent)):SetEndEvent(function()
				setActive(arg0_109.lightGhost, false)
			end)
			setParent(arg0_109.lightGhost, arg0_109.scene)
		end

		if arg0_109.charactor:getGhostFlag() then
			arg0_109.lightGhost.anchoredPosition = arg0_109.scene:InverseTransformPoint(arg0_109.charactor:getLeavePos())

			setActive(arg0_109.lightGhost, true)
			arg0_109.lightAnimator:SetInteger("state_type", 0)
			arg0_109.lightAnimator:SetInteger("state_type", 2)
			arg1_109(true)
		else
			arg1_109(false)
		end
	end

	return var0_101
end

local function var44_0(arg0_111, arg1_111)
	local var0_111 = {
		eyeTf = arg0_111
	}
	local var1_111 = 3

	function var0_111.changeEyeShow(arg0_112, arg1_112)
		return
	end

	function var0_111.start(arg0_113)
		if not arg0_113.eyes then
			arg0_113.eyes = {}

			for iter0_113 = 1, 3 do
				table.insert(arg0_113.eyes, findTF(arg0_113.eyeTf, "eye" .. iter0_113))
			end
		end

		arg0_113.centerX = (var25_0[3] - var25_0[1]) / 2
		arg0_113.halfRnage = (var25_0[3] - var25_0[1]) / 2

		arg0_113:changeEyeShow(true)
	end

	function var0_111.step(arg0_114)
		local var0_114 = (arg1_111.anchoredPosition.x - var25_0[1] - arg0_114.centerX) / arg0_114.halfRnage * var1_111

		for iter0_114 = 1, #arg0_114.eyes do
			setAnchoredPosition(findTF(arg0_114.eyes[iter0_114], "img"), Vector3(var0_114, 0, 0))
		end
	end

	function var0_111.gameOver(arg0_115)
		return
	end

	return var0_111
end

function var0_0.init(arg0_116)
	arg0_116:initUI()
	arg0_116:initData()
	arg0_116:gameReadyStart()
end

function var0_0.initUI(arg0_117)
	onButton(arg0_117, findTF(arg0_117._tf, "conLeft/btnClose"), function()
		if not arg0_117.gameStartFlag then
			arg0_117:closeView()
		else
			setActive(arg0_117.leaveUI, true)
			arg0_117:timerStop()

			arg0_117.gameStartFlag = false
		end
	end, SFX_CANCEL)

	arg0_117.playerIdleTip = findTF(arg0_117._tf, "idleTip")

	setActive(arg0_117.playerIdleTip, false)

	arg0_117.hearts = {}

	for iter0_117 = 1, var24_0 do
		table.insert(arg0_117.hearts, findTF(arg0_117._tf, "conRight/heart/heart" .. iter0_117))
	end

	arg0_117.wanshengjie = findTF(arg0_117._tf, "wanshengjie")

	setActive(arg0_117.wanshengjie, false)

	arg0_117.scoreText = findTF(arg0_117._tf, "conRight/score/text")
	arg0_117.scene = findTF(arg0_117._tf, "scene")
	arg0_117.countUI = findTF(arg0_117._tf, "pop/CountUI")
	arg0_117.settlementUI = findTF(arg0_117._tf, "pop/SettleMentUI")

	onButton(arg0_117, findTF(arg0_117.settlementUI, "ad/btnOver"), function()
		arg0_117:clearUI()
		arg0_117:closeView()
	end, SFX_CANCEL)

	arg0_117.leaveUI = findTF(arg0_117._tf, "pop/LeaveUI")

	onButton(arg0_117, findTF(arg0_117.leaveUI, "ad/btnOk"), function()
		setActive(arg0_117.leaveUI, false)
		arg0_117:gameOver()
	end, SFX_CANCEL)
	onButton(arg0_117, findTF(arg0_117.leaveUI, "ad/btnCancel"), function()
		setActive(arg0_117.leaveUI, false)
		arg0_117:timerStart()

		arg0_117.gameStartFlag = true
	end, SFX_CANCEL)
end

function var0_0.initData(arg0_122)
	arg0_122.timer = Timer.New(function()
		arg0_122:onTimer()
	end, 0.0166666666666667, -1)
	arg0_122.charactor = var36_0(findTF(arg0_122.scene, "charactor"), var25_0, arg0_122.scene)

	function arg0_122.charactor.charactorIdleCallback(arg0_124)
		setActive(arg0_122.playerIdleTip, arg0_124)
	end

	arg0_122.flyer = var38_0(findTF(arg0_122.scene, "flyCharactor"), var26_0)

	function arg0_122.flyer.dropCallback()
		arg0_122:onCreateDropItem()
	end

	arg0_122.controllerUI = var37_0(findTF(arg0_122._tf, "controller"), findTF(arg0_122._tf, "conRight/useLight"))

	function arg0_122.controllerUI.pointChangeCallback(arg0_126)
		arg0_122:onControllerDirectChange(arg0_126)
	end

	function arg0_122.controllerUI.pointUpCallback(arg0_127)
		arg0_122:onControllerDirectUp(arg0_127)
	end

	function arg0_122.controllerUI.pointLightCallback(arg0_128)
		arg0_122:onUseLight(arg0_128)
	end

	arg0_122.dropControl = var39_0()

	function arg0_122.dropControl.dropRequestCallback()
		arg0_122:onRequestDrop()
	end

	arg0_122.dropItemController = var40_0(arg0_122.flyer, arg0_122.scene)

	function arg0_122.dropItemController.lostCallback()
		arg0_122:lostCandy()
	end

	function arg0_122.dropItemController.boomCallback()
		arg0_122:touchBoom()
	end

	function arg0_122.dropItemController.dropSpeedUpCallback()
		arg0_122:dropSpeedUp()
	end

	arg0_122.dropColliderControll = var41_0(arg0_122.charactor, arg0_122.dropItemController, arg0_122.scene)

	function arg0_122.dropColliderControll.colliderDropItemCallback(arg0_133)
		arg0_122:addScore(arg0_133.score)
	end

	arg0_122.ghostBossController = var42_0(findTF(arg0_122._tf, "ghostBoss"))

	function arg0_122.ghostBossController.createGhostCallback()
		arg0_122:createGhost()
	end

	function arg0_122.ghostBossController.ghostSpeedUpCallback()
		if arg0_122.eyesController then
			arg0_122.eyesController:changeEyeShow(false)
		end
	end

	arg0_122.ghostChildController = var43_0(findTF(arg0_122.scene, "tplGhost"), arg0_122.charactor, arg0_122.scene)

	function arg0_122.ghostChildController.catchCharactorCallback(arg0_136)
		arg0_122:onGhostCatch(arg0_136)
	end

	arg0_122.eyesController = var44_0(findTF(arg0_122._tf, "bg/eyes"), findTF(arg0_122.scene, "charactor"))

	if not arg0_122.handle then
		arg0_122.handle = UpdateBeat:CreateListener(arg0_122.Update, arg0_122)
	end

	UpdateBeat:AddListener(arg0_122.handle)

	arg0_122.countAnimator = GetComponent(findTF(arg0_122.countUI, "count"), typeof(Animator))
	arg0_122.countDft = GetComponent(findTF(arg0_122.countUI, "count"), typeof(DftAniEvent))

	arg0_122.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_122.countDft:SetEndEvent(function()
		setActive(arg0_122.countUI, false)
		arg0_122:gameStart()
	end)
end

function var0_0.gameReadyStart(arg0_139)
	setActive(arg0_139.countUI, true)
	arg0_139.countAnimator:Play("count")
end

function var0_0.gameStart(arg0_140)
	arg0_140.heartNum = var24_0
	arg0_140.scoreNum = 0
	arg0_140.gameStartFlag = true
	var30_0 = 0

	setActive(arg0_140.scene, true)
	arg0_140:updateUI()
	arg0_140.charactor:start()
	arg0_140.flyer:start()
	arg0_140.dropControl:start()
	arg0_140.dropItemController:start()
	arg0_140.dropColliderControll:start()
	arg0_140.ghostBossController:start()
	arg0_140.ghostChildController:start()
	arg0_140.controllerUI:start()
	arg0_140.eyesController:start()
	arg0_140:timerStart()
end

function var0_0.timerStart(arg0_141)
	if not arg0_141.timer.running then
		arg0_141.timer:Start()
	end

	setActive(arg0_141.wanshengjie, true)
end

function var0_0.timerStop(arg0_142)
	if arg0_142.timer.running then
		arg0_142.timer:Stop()
	end

	setActive(arg0_142.wanshengjie, false)
end

function var0_0.getGameTimes(arg0_143)
	return arg0_143:GetMGHubData().count
end

function var0_0.getSoundData(arg0_144, arg1_144)
	CueData.GetCueData().channelName = pg.CriMgr.C_GALLERY_MUSIC
	arg0_144.cueData.cueSheetName = arg1_144
	arg0_144.cueData.cueName = ""
end

function var0_0.onTimer(arg0_145)
	var30_0 = var30_0 + arg0_145.timer.duration

	arg0_145.charactor:step()
	arg0_145.flyer:step()
	arg0_145.dropControl:step()
	arg0_145.dropItemController:step()
	arg0_145.dropColliderControll:step()
	arg0_145.ghostBossController:step()
	arg0_145.ghostChildController:step()
	arg0_145.controllerUI:step()
	arg0_145.eyesController:step()
end

function var0_0.updateUI(arg0_146)
	for iter0_146 = 1, #arg0_146.hearts do
		if iter0_146 <= arg0_146.heartNum then
			setActive(findTF(arg0_146.hearts[iter0_146], "img"), true)
		else
			setActive(findTF(arg0_146.hearts[iter0_146], "img"), false)
		end
	end

	if not arg0_146.showOverTip and (arg0_146.scoreNum >= var31_0 or var30_0 * 1000 >= var32_0) and arg0_146.ghostBossController then
		arg0_146.showOverTip = true

		arg0_146.ghostBossController:showTip(2)
	end

	setText(arg0_146.scoreText, arg0_146.scoreNum)
end

function var0_0.dropSpeedUp(arg0_147)
	if arg0_147.ghostBossController then
		arg0_147.ghostBossController:showTip(1)
	end
end

function var0_0.loseHeart(arg0_148, arg1_148)
	if arg0_148.heartNum and arg0_148.heartNum > 0 then
		arg0_148.heartNum = arg0_148.heartNum - 1

		arg0_148:updateUI()

		if arg0_148.heartNum == 0 then
			local var0_148 = arg1_148 == var5_0 and var7_0 or var8_0

			arg0_148.charactor:fail(var0_148)

			if var0_148 == var8_0 then
				arg0_148.ghostChildController:createGhostLight(function(arg0_149)
					if arg0_149 then
						arg0_148.ghostBossController:onGhostDestroy()
					end
				end)
				arg0_148.charactor:setGhostFlag(false)
			end

			arg0_148.gameStartFlag = false

			arg0_148:timerStop()
			LeanTween.delayedCall(go(arg0_148._tf), 3, System.Action(function()
				arg0_148:gameOver()
			end))
		elseif arg1_148 == var6_0 then
			arg0_148.charactor:boom()
		end
	end
end

function var0_0.addScore(arg0_151, arg1_151)
	arg0_151.scoreNum = arg0_151.scoreNum + arg1_151

	arg0_151:updateUI()
end

function var0_0.gameOver(arg0_152)
	arg0_152.charactor:gameOver()
	arg0_152.flyer:gameOver()
	arg0_152.dropControl:gameOver()
	arg0_152.dropItemController:gameOver()
	arg0_152.dropColliderControll:gameOver()
	arg0_152.ghostBossController:gameOver()
	arg0_152.ghostChildController:gameOver()
	arg0_152.controllerUI:gameOver()
	arg0_152.eyesController:gameOver()

	if arg0_152:getGameTimes() and arg0_152:getGameTimes() > 0 then
		arg0_152:SendSuccess(0)
	end

	arg0_152:showSettlement()
end

function var0_0.showSettlement(arg0_153)
	setActive(arg0_153.settlementUI, true)
	GetComponent(findTF(arg0_153.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_153 = arg0_153:GetMGData():GetRuntimeData("elements")
	local var1_153 = arg0_153.scoreNum
	local var2_153 = var0_153 and #var0_153 > 0 and var0_153[1] or 0

	if var2_153 <= var1_153 then
		var2_153 = var1_153

		arg0_153:StoreDataToServer({
			var2_153
		})
	end

	local var3_153 = findTF(arg0_153.settlementUI, "ad/highText")
	local var4_153 = findTF(arg0_153.settlementUI, "ad/currentText")

	setText(var3_153, var2_153)
	setText(var4_153, var1_153)
end

function var0_0.lostCandy(arg0_154)
	arg0_154:loseHeart(var5_0)
end

function var0_0.touchBoom(arg0_155)
	arg0_155:loseHeart(var6_0)
end

function var0_0.createGhost(arg0_156)
	if arg0_156.ghostChildController and arg0_156.ghostChildController:createGhost() then
		arg0_156.ghostBossController:onCreate()
	end
end

function var0_0.onCreateDropItem(arg0_157)
	if arg0_157.dropItemController then
		arg0_157.dropItemController:createDropItem()
	end
end

function var0_0.onRequestDrop(arg0_158)
	if arg0_158.flyer then
		arg0_158.flyer:addDropNum()
	end
end

function var0_0.onGhostCatch(arg0_159, arg1_159)
	if not arg0_159.charactor:getGhostFlag() then
		arg0_159.charactor:setGhostFlag(true, function()
			arg0_159.ghostChildController:removeChild(arg1_159)
		end)
		arg0_159.controllerUI:changeRemind(true)
		arg0_159.ghostBossController:onCatch()
	end
end

function var0_0.onUseLight(arg0_161, arg1_161)
	if not arg0_161.gameStartFlag then
		return
	end

	arg0_161.charactor:playLight(function(arg0_162)
		if arg0_162 and arg1_161 == var3_0 then
			arg0_161.ghostChildController:createGhostLight(function(arg0_163)
				if arg0_163 then
					arg0_161.ghostBossController:onGhostDestroy()
					arg0_161.controllerUI:changeRemind(false)
				end
			end)
			arg0_161.charactor:setGhostFlag(false)
		end
	end, arg1_161)
end

function var0_0.onColliderItem(arg0_164, arg1_164)
	var35_0("碰撞到了物品，数量:" .. #arg1_164)
end

function var0_0.onControllerDirectChange(arg0_165, arg1_165)
	arg0_165:changeDirect(arg1_165, true)
end

function var0_0.onControllerDirectUp(arg0_166, arg1_166)
	arg0_166:changeDirect(arg1_166, false)
end

function var0_0.changeDirect(arg0_167, arg1_167, arg2_167)
	if arg0_167.gameStartFlag then
		arg0_167.charactor:onDirectChange(arg1_167, arg2_167)
	end
end

function var0_0.Update(arg0_168)
	arg0_168:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_169)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_169:changeDirect(var1_0, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_169:changeDirect(var1_0, false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_169:changeDirect(var2_0, true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_169:changeDirect(var2_0, false)
		end
	end
end

function var0_0.clearUI(arg0_170)
	setActive(arg0_170.scene, false)
	setActive(arg0_170.settlementUI, false)
	setActive(arg0_170.countUI, false)
end

function var0_0.onBackPressed(arg0_171)
	if not arg0_171.gameStartFlag then
		arg0_171:emit(var0_0.ON_BACK_PRESSED)
	else
		setActive(arg0_171.leaveUI, true)
		arg0_171:timerStop()

		arg0_171.gameStartFlag = false
	end
end

function var0_0.willExit(arg0_172)
	if arg0_172.timer and arg0_172.timer.running then
		arg0_172.timer:Stop()
	end

	if LeanTween.isTweening(go(arg0_172._tf)) then
		LeanTween.cancel(go(arg0_172._tf))
	end
end

return var0_0
