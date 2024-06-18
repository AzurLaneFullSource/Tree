local var0_0 = class("CurlingGameView", import("..BaseMiniGameView"))
local var1_0 = "event:/ui/ddldaoshu2"
local var2_0 = "event:/ui/taosheng"
local var3_0 = "event:/ui/minigame_hitcake"
local var4_0 = "event:/ui/zhengque"
local var5_0 = "event:/ui/shibai"
local var6_0 = 1
local var7_0 = 2
local var8_0 = 3
local var9_0 = {
	20,
	40,
	60
}
local var10_0 = 4
local var11_0 = Vector2(-720, 0)
local var12_0 = {
	-250,
	250
}
local var13_0 = Vector2(-250, -42)
local var14_0 = {
	1,
	10,
	30
}
local var15_0 = 0.2
local var16_0 = false
local var17_0 = {
	walker = 0.1,
	miner = 0.2,
	wall = 0,
	oil = 0.2,
	cube = 0.2
}
local var18_0 = {
	walker = 2,
	miner = 2,
	wall = 0,
	oil = 2,
	cube = 2
}
local var19_0 = {
	0.5,
	5,
	10
}
local var20_0 = {
	0.5,
	5,
	10
}
local var21_0 = Vector2(400, -600)
local var22_0 = Vector2(400, 500)
local var23_0 = 1
local var24_0 = 2
local var25_0 = 3
local var26_0 = 4
local var27_0 = Vector2(617, -108)
local var28_0 = 0.7
local var29_0 = {
	111,
	222,
	333
}
local var30_0 = {
	3000,
	2000,
	1000
}
local var31_0 = 1
local var32_0 = 2
local var33_0 = 3
local var34_0 = 4
local var35_0 = {
	walker = 900,
	miner = 300,
	wall = 100,
	oil = 300,
	cube = 300
}
local var36_0 = 1
local var37_0 = {
	oil = {
		{
			appear = 0.8,
			num = 1
		},
		{
			appear = 0.1,
			num = 1
		}
	},
	cube = {
		{
			appear = 0.8,
			num = 1
		},
		{
			appear = 0.1,
			num = 1
		}
	},
	miner = {
		{
			appear = 1,
			num = 1
		},
		{
			appear = 0.1,
			num = 1
		}
	},
	walker = {
		appear = 1,
		path = {
			var23_0,
			var24_0,
			var25_0,
			var26_0
		}
	}
}
local var38_0 = {
	cube = 3.5,
	miner = 3.5,
	walker = 4.5,
	oil = 3.5
}
local var39_0 = true
local var40_0 = "event_push"
local var41_0 = "event_speed"
local var42_0 = "event_hit"
local var43_0 = "event_result"
local var44_0 = "event_next"
local var45_0 = "event_game_pause"
local var46_0 = "event_game_resume"
local var47_0 = "event_add_score"

local function var48_0(arg0_1, arg1_1)
	local var0_1 = {
		Ctor = function(arg0_2)
			arg0_2._tf = arg0_1
			arg0_2._event = arg1_1
			arg0_2.powerTF = findTF(arg0_2._tf, "power")
			arg0_2.powerSlider = GetComponent(arg0_2.powerTF, typeof(Slider))

			arg0_2:InitPowerSlider()

			arg0_2.animator = GetComponent(arg0_2._tf, typeof(Animator))
			arg0_2.aniDft = GetComponent(arg0_2._tf, typeof(DftAniEvent))

			arg0_2.aniDft:SetTriggerEvent(function()
				arg0_2:Push()
			end)

			arg0_2.dragTrigger = GetOrAddComponent(arg0_2._tf, "EventTriggerListener")

			arg0_2.dragTrigger:AddPointDownFunc(function(arg0_4, arg1_4)
				if not arg0_2.canClick then
					return
				end

				arg0_2.canClick = false
				arg0_2.charging = true
				arg0_2.originScreenY = arg1_4.position.y
				arg0_2.originY = arg0_2._tf.anchoredPosition.y

				arg0_2:Charge()
			end)
			arg0_2.dragTrigger:AddDragFunc(function(arg0_5, arg1_5)
				if not arg0_2.charging then
					return
				end

				local var0_5 = arg1_5.position.y - arg0_2.originScreenY + arg0_2.originY

				var0_5 = var0_5 >= var12_0[1] and var0_5 or var12_0[1]
				var0_5 = var0_5 <= var12_0[2] and var0_5 or var12_0[2]

				setLocalPosition(arg0_2._tf, Vector2(arg0_2._tf.anchoredPosition.x, var0_5))
			end)
			arg0_2.dragTrigger:AddPointUpFunc(function(arg0_6, arg1_6)
				if not arg0_2.charging then
					return
				end

				arg0_2.charging = false

				arg0_2.animator:SetInteger("Throw", arg0_2.phase)
				arg0_2.animator:SetInteger("Charge", 0)
			end)
			arg0_2._event:bind(var43_0, function(arg0_7, arg1_7, arg2_7)
				arg0_2.animator:SetInteger("Result", arg1_7.result)
			end)
			arg0_2._event:bind(var44_0, function(arg0_8, arg1_8, arg2_8)
				arg0_2:Reset()
				arg0_2:Start()
			end)
			arg0_2:Reset()
		end,
		Start = function(arg0_9)
			arg0_9.canClick = true
		end,
		Reset = function(arg0_10)
			setActive(arg0_10.powerTF, false)
			setLocalPosition(arg0_10._tf, var11_0)
			arg0_10.animator:SetInteger("Charge", 0)
			arg0_10.animator:SetInteger("Throw", 0)
			arg0_10.animator:SetInteger("Result", 0)
			arg0_10.animator:Play("WaitA")

			arg0_10.power = 0
			arg0_10.phase = 0
			arg0_10.charging = false
			arg0_10.canClick = false
			arg0_10.powerSlider.value = 0
		end,
		InitPowerSlider = function(arg0_11)
			local var0_11 = 24
			local var1_11 = 162
			local var2_11 = var9_0[1] / var9_0[3] * var1_11

			findTF(arg0_11.powerTF, "progress/green").sizeDelta = Vector2(var2_11, var0_11)

			local var3_11 = (var9_0[2] - var9_0[1]) / var9_0[3] * var1_11

			findTF(arg0_11.powerTF, "progress/green/yellow").sizeDelta = Vector2(var3_11, var0_11)

			local var4_11 = (var9_0[3] - var9_0[2]) / var9_0[3] * var1_11

			findTF(arg0_11.powerTF, "progress/green/yellow/red").sizeDelta = Vector2(var4_11, var0_11)
		end,
		Charge = function(arg0_12)
			setActive(arg0_12.powerTF, true)
			setActive(findTF(arg0_12.powerTF, "binghu_huoyan"), false)

			arg0_12.phase = var6_0

			arg0_12.animator:SetInteger("Charge", arg0_12.phase)
			LeanTween.value(go(arg0_12._tf), arg0_12.power, var9_0[3], var10_0):setOnUpdate(System.Action_float(function(arg0_13)
				arg0_12.power = arg0_13
				arg0_12.powerSlider.value = arg0_12.power / var9_0[3]

				if arg0_12.phase == var6_0 and arg0_12.power >= var9_0[1] then
					arg0_12.phase = var7_0

					arg0_12.animator:SetInteger("Charge", arg0_12.phase)
				elseif arg0_12.phase == var7_0 and arg0_12.power >= var9_0[2] then
					arg0_12.phase = var8_0

					arg0_12.animator:SetInteger("Charge", arg0_12.phase)
					setActive(findTF(arg0_12.powerTF, "binghu_huoyan"), true)
				end

				if not arg0_12.charging then
					LeanTween.cancel(go(arg0_12._tf))
				end
			end))
		end,
		Push = function(arg0_14)
			arg0_14._event:emit(var40_0, {
				power = arg0_14.power
			})
			setActive(arg0_14.powerTF, false)
		end
	}

	var0_1:Ctor()

	return var0_1
end

local function var49_0(arg0_15, arg1_15, arg2_15)
	local var0_15 = {
		Ctor = function(arg0_16)
			arg0_16.tpls = arg0_15
			arg0_16._event = arg2_15
			arg0_16.player = arg1_15
			arg0_16.scene = arg0_16.player.parent

			arg0_16._event:bind(var40_0, function(arg0_17, arg1_17, arg2_17)
				if arg0_16.isPush then
					return
				end

				arg0_16:Push(arg1_17.power)
			end)
			arg0_16._event:bind(var44_0, function(arg0_18, arg1_18, arg2_18)
				arg0_16:Reset()
				arg0_16:Start()
			end)
			arg0_16._event:bind(var45_0, function(arg0_19, arg1_19, arg2_19)
				arg0_16:Pause()
			end)
			arg0_16._event:bind(var46_0, function(arg0_20, arg1_20, arg2_20)
				arg0_16:Resume()
			end)
			arg0_16:Reset()
		end,
		Start = function(arg0_21)
			return
		end,
		RandomRole = function(arg0_22)
			if arg0_22._tf then
				arg0_22._tf:SetParent(arg0_22.tpls, false)
				setActive(arg0_22._tf, false)
			end

			local var0_22 = math.random(1, 4)

			arg0_22._tf = arg0_22.tpls:GetChild(var0_22 - 1)

			setActive(arg0_22._tf, true)

			arg0_22.speedTF = findTF(arg0_22._tf, "speed")

			setActive(arg0_22.speedTF, var16_0)

			arg0_22.animator = GetComponent(arg0_22._tf, typeof(Animator))
			arg0_22.rigbody = GetComponent(arg0_22._tf, "Rigidbody2D")
			arg0_22.rigbody.velocity = Vector2.zero
			arg0_22.phyItem = GetComponent(arg0_22._tf, "Physics2DItem")

			arg0_22.phyItem.CollisionEnter:RemoveAllListeners()
			arg0_22.phyItem.CollisionEnter:AddListener(function(arg0_23)
				arg0_22:OnCollision(arg0_23)
			end)
		end,
		Reset = function(arg0_24)
			arg0_24:RandomRole()

			arg0_24.rigbody.velocity = Vector2.zero

			arg0_24._tf:SetParent(findTF(arg0_24.player, "chargePos"), false)
			setText(arg0_24.speedTF, 0)
			setLocalPosition(arg0_24._tf, Vector2.zero)
			setLocalScale(arg0_24._tf, Vector2.one)
			arg0_24.animator:Play("Neutral")
			arg0_24.animator:SetBool("Stop", false)
			arg0_24.animator:SetInteger("Result", 0)
			arg0_24.animator:SetInteger("SpeedPhase", 0)

			arg0_24.isPush = false
			arg0_24.isStop = true
			arg0_24.phase = 0
		end,
		Step = function(arg0_25)
			if var16_0 then
				setText(arg0_25.speedTF, arg0_25.rigbody.velocity:Magnitude())
			end

			if not arg0_25.isPush or arg0_25.isStop then
				return
			end

			local var0_25 = arg0_25:GetSpeed()

			arg0_25._event:emit(var41_0, {
				speed = var0_25
			})

			if var0_25 > var14_0[1] then
				arg0_25.animator:SetInteger("SpeedPhase", 1)
			elseif var0_25 > var14_0[2] then
				arg0_25.animator:SetInteger("SpeedPhase", 2)
			elseif var0_25 > var14_0[3] then
				arg0_25.animator:SetInteger("SpeedPhase", 3)
			end

			if var0_25 < var15_0 then
				arg0_25.animator:SetBool("Stop", true)

				arg0_25.isStop = true

				arg0_25:Result()
			end
		end,
		Push = function(arg0_26, arg1_26)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)

			arg0_26.isPush = true
			arg0_26.isStop = false

			arg0_26._tf:SetParent(arg0_26.scene, true)

			local var0_26 = Vector2(var13_0.x - arg0_26._tf.anchoredPosition.x, var13_0.y - arg0_26._tf.anchoredPosition.y)

			arg0_26.rigbody.velocity = var0_26:Normalize():Mul(arg1_26)

			arg0_26:Slip()
		end,
		Slip = function(arg0_27)
			arg0_27.animator:SetBool("Stop", false)

			arg0_27.isStop = false
		end,
		OnCollision = function(arg0_28, arg1_28)
			arg0_28.animator:SetTrigger("Hit")
			arg0_28._event:emit(var42_0)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_0)

			local var0_28 = arg1_28.collider.gameObject.name
			local var1_28 = 0
			local var2_28 = Vector2(1, 0)
			local var3_28 = Vector2(arg0_28.rigbody.velocity.x, arg0_28.rigbody.velocity.y)

			if var0_28 == "wall" then
				var3_28:Mul(var17_0.wall)

				var1_28 = var35_0.wall

				var2_28:Mul(var18_0.wall)
			elseif var0_28 == "oil" then
				var3_28:Mul(var17_0.oil)

				var1_28 = var35_0.oil

				var2_28:Mul(var18_0.oil)
			elseif var0_28 == "cube" then
				var3_28:Mul(var17_0.cube)

				var1_28 = var35_0.cube

				var2_28:Mul(var18_0.cube)
			elseif var0_28 == "miner" then
				var3_28:Mul(var17_0.miner)

				var1_28 = var35_0.miner

				var2_28:Mul(var18_0.miner)
			elseif var0_28 == "walker" then
				var3_28:Mul(var17_0.walker)

				var1_28 = var35_0.walker

				var2_28:Mul(var18_0.walker)
			end

			arg0_28.rigbody.velocity = arg0_28.rigbody.velocity:Sub(var3_28)
			arg0_28.rigbody.velocity = arg0_28.rigbody.velocity:Add(var2_28)

			local var4_28 = arg0_28._tf.anchoredPosition

			arg0_28._event:emit(var47_0, {
				score = var1_28,
				pos = var4_28
			})
		end,
		Result = function(arg0_29)
			local var0_29 = Vector2(arg0_29._tf.anchoredPosition.x, arg0_29._tf.anchoredPosition.y / var28_0)
			local var1_29 = Vector2.Distance(var27_0, var0_29)
			local var2_29 = 0
			local var3_29 = var1_29 <= var29_0[1] and 1 or var1_29 <= var29_0[2] and 2 or var1_29 <= var29_0[3] and 3 or 4

			arg0_29.animator:SetInteger("Result", var3_29)
			arg0_29._event:emit(var43_0, {
				result = var3_29
			})

			if var3_29 == 0 or var3_29 == 4 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_0)
			else
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4_0)
			end
		end,
		Pause = function(arg0_30)
			arg0_30.speedRecord = arg0_30.rigbody.velocity
			arg0_30.rigbody.velocity = Vector2.zero
			arg0_30.animator.speed = 0
		end,
		Resume = function(arg0_31)
			arg0_31.rigbody.velocity = arg0_31.speedRecord
			arg0_31.animator.speed = 1
		end,
		GetSpeed = function(arg0_32)
			return arg0_32.rigbody.velocity:Magnitude()
		end
	}

	var0_15:Ctor()

	return var0_15
end

local function var50_0(arg0_33, arg1_33)
	local var0_33 = {
		Ctor = function(arg0_34)
			arg0_34._tf = arg0_33
			arg0_34._event = arg1_33
			arg0_34.animator = GetComponent(arg0_34._tf, typeof(Animator))

			arg0_34._event:bind(var40_0, function(arg0_35, arg1_35, arg2_35)
				arg0_34:TurnLeft()
			end)
			arg0_34._event:bind(var42_0, function(arg0_36, arg1_36, arg2_36)
				arg0_34:Hit()
			end)
			arg0_34._event:bind(var43_0, function(arg0_37, arg1_37, arg2_37)
				arg0_34:Result(arg1_37.result)
			end)
			arg0_34._event:bind(var44_0, function(arg0_38, arg1_38, arg2_38)
				arg0_34:Reset()
				arg0_34:Start()
			end)
		end,
		Start = function(arg0_39)
			return
		end,
		Reset = function(arg0_40)
			arg0_40.animator:SetInteger("Result", 0)
			arg0_40.animator:Play("WaitA")
		end,
		TurnLeft = function(arg0_41)
			arg0_41.animator:SetTrigger("TurnLeft")
		end,
		Result = function(arg0_42, arg1_42)
			arg0_42.animator:SetInteger("Result", arg1_42)
		end,
		Hit = function(arg0_43)
			arg0_43.animator:SetTrigger("Hit")
		end
	}

	var0_33:Ctor()

	return var0_33
end

local function var51_0(arg0_44, arg1_44)
	local var0_44 = {
		Ctor = function(arg0_45)
			arg0_45._tf = arg0_44
			arg0_45._event = arg1_44
			arg0_45.animator = GetComponent(arg0_45._tf, typeof(Animator))

			arg0_45._event:bind(var44_0, function(arg0_46, arg1_46, arg2_46)
				arg0_45:NextRound()
			end)
			arg0_45:Reset()
		end,
		Start = function(arg0_47)
			arg0_47:NextRound()
		end,
		Reset = function(arg0_48)
			arg0_48.animator:SetInteger("Round", 0)
			arg0_48.animator:Play("IdleA")

			arg0_48.roundNum = 1
		end,
		NextRound = function(arg0_49)
			arg0_49.animator:SetInteger("Round", arg0_49.roundNum)

			if arg0_49.roundNum == 3 then
				arg0_49.roundNum = 1
			else
				arg0_49.roundNum = arg0_49.roundNum + 1
			end
		end
	}

	var0_44:Ctor()

	return var0_44
end

local function var52_0(arg0_50, arg1_50)
	local var0_50 = {
		Ctor = function(arg0_51)
			arg0_51._tf = arg0_50
			arg0_51._event = arg1_50
			arg0_51.config = var37_0.miner
			arg0_51.animator = GetComponent(arg0_51._tf, typeof(Animator))
			arg0_51.phyItem = GetComponent(arg0_51._tf, "Physics2DItem")

			arg0_51.phyItem.CollisionEnter:AddListener(function(arg0_52)
				arg0_51:OnCollision()
			end)

			arg0_51.phyGrazeItem = GetComponent(findTF(arg0_51._tf, "GrazeCollider"), "Physics2DItem")

			arg0_51.phyGrazeItem.TriggerEnter:AddListener(function(arg0_53)
				arg0_51:OnGrazeTrigger(arg0_53)
			end)
			arg0_51._event:bind(var41_0, function(arg0_54, arg1_54, arg2_54)
				arg0_51.hitSpeed = arg1_54.speed
			end)
			arg0_51:Reset()
		end,
		Start = function(arg0_55)
			return
		end,
		Reset = function(arg0_56)
			arg0_56.isClash = false
			arg0_56.hitSpeed = 0
		end,
		OnCollision = function(arg0_57)
			arg0_57.isClash = true

			local var0_57 = 0

			if arg0_57.hitSpeed > var19_0[3] then
				var0_57 = 3
			elseif arg0_57.hitSpeed > var19_0[2] then
				var0_57 = 2
			elseif arg0_57.hitSpeed > var19_0[1] then
				var0_57 = 1
			end

			arg0_57.animator:SetInteger("Speed", var0_57)
			arg0_57.animator:SetTrigger("Clash")
		end,
		OnGrazeTrigger = function(arg0_58, arg1_58)
			if arg1_58.gameObject.name ~= "Ayanami" then
				return
			end

			onDelayTick(function()
				if arg0_58.isClash then
					return
				end

				arg0_58.animator:SetTrigger("Graze")
			end, 0.3)
		end
	}

	var0_50:Ctor()

	return var0_50
end

local function var53_0(arg0_60, arg1_60)
	local var0_60 = {}
	local var1_60 = 1000

	function var0_60.Ctor(arg0_61)
		arg0_61._tf = arg0_60
		arg0_61._event = arg1_60
		arg0_61.config = var37_0.walker
		arg0_61.obstacleTF = arg0_61._tf.parent
		arg0_61.bgFrontTF = findTF(arg0_61.obstacleTF.parent.parent, "bg_front")
		arg0_61.animator = GetComponent(arg0_61._tf, typeof(Animator))
		arg0_61.rigbody = GetComponent(arg0_61._tf, "Rigidbody2D")
		arg0_61.phyItem = GetComponent(arg0_61._tf, "Physics2DItem")

		arg0_61.phyItem.CollisionEnter:AddListener(function(arg0_62)
			arg0_61:OnCollision(arg0_62)
		end)
		arg0_61._event:bind(var41_0, function(arg0_63, arg1_63, arg2_63)
			arg0_61.hitSpeed = arg1_63.speed
		end)
		arg0_61._event:bind(var45_0, function(arg0_64, arg1_64, arg2_64)
			arg0_61:Pause()
		end)
		arg0_61._event:bind(var46_0, function(arg0_65, arg1_65, arg2_65)
			arg0_61:Resume()
		end)
	end

	function var0_60.SetPath(arg0_66, arg1_66)
		arg0_66.pathType = arg1_66
	end

	function var0_60.Start(arg0_67)
		arg0_67:WalkPath()
	end

	function var0_60.Reset(arg0_68)
		setActive(arg0_68._tf, false)
		setLocalPosition(arg0_68._tf, Vector2(-1400, 0))

		arg0_68.rigbody.velocity = Vector2.zero
		arg0_68.isJumpDown = false
		arg0_68.isJumpUp = false
		arg0_68.isForwardNorth = false
		arg0_68.isForwardSouth = false
		arg0_68.hitSpeed = 0
		arg0_68.pathType = 0
	end

	function var0_60.OnCollision(arg0_69, arg1_69)
		arg0_69.animator:SetTrigger("Clash")

		local var0_69 = 0

		if arg0_69.hitSpeed > var20_0[3] then
			var0_69 = 3
		elseif arg0_69.hitSpeed > var20_0[2] then
			var0_69 = 2
		elseif arg0_69.hitSpeed > var20_0[1] then
			var0_69 = 1
		end

		arg0_69.animator:SetInteger("Speed", var0_69)

		arg0_69.rigbody.velocity = Vector2.zero
	end

	function var0_60.WalkPath(arg0_70)
		if arg0_70.pathType == var25_0 or arg0_70.pathType == var26_0 then
			setLocalPosition(arg0_70._tf, var21_0)
			arg0_70._tf:SetParent(arg0_70.bgFrontTF, false)

			arg0_70.isForwardNorth = true

			arg0_70.animator:SetBool("IsNorth", true)
			arg0_70:WalkNorth()
		elseif arg0_70.pathType == var23_0 or arg0_70.pathType == var24_0 then
			setLocalPosition(arg0_70._tf, var22_0)
			arg0_70._tf:SetParent(arg0_70.obstacleTF, false)

			arg0_70.isForwardSouth = true

			arg0_70.animator:SetBool("IsSouth", true)
			arg0_70:WalkSouth()
		end
	end

	function var0_60.WalkNorth(arg0_71)
		arg0_71.animator:SetTrigger("WalkN")

		arg0_71.rigbody.velocity = Vector2(0, 1.5)
	end

	function var0_60.JumpNorth(arg0_72)
		arg0_72.animator:SetTrigger("JumpN")

		if arg0_72.isJumpUp then
			arg0_72:WalkNorth()
		elseif arg0_72.pathType == var26_0 then
			arg0_72:WalkNorthwest()
		else
			arg0_72:WalkNorth()
		end
	end

	function var0_60.WalkNorthwest(arg0_73)
		arg0_73.animator:SetTrigger("WalkNW")

		arg0_73.rigbody.velocity = Vector2(-1.5, 1.5)
	end

	function var0_60.WalkSouth(arg0_74)
		arg0_74.animator:SetTrigger("WalkS")

		arg0_74.rigbody.velocity = Vector2(0, -1.5)
	end

	function var0_60.JumpSouth(arg0_75)
		arg0_75.animator:SetTrigger("JumpS")

		if arg0_75.isJumpDown then
			arg0_75:WalkSouth()
		elseif arg0_75.pathType == var24_0 then
			arg0_75:WalkSouthwest()
		else
			arg0_75:WalkSouth()
		end
	end

	function var0_60.WalkSouthwest(arg0_76)
		arg0_76.animator:SetTrigger("WalkSW")

		arg0_76.rigbody.velocity = Vector2(-1.5, -1.5)
	end

	function var0_60.Step(arg0_77)
		local var0_77 = arg0_77._tf.anchoredPosition.y

		if var0_77 > var1_60 or var0_77 < -var1_60 then
			arg0_77.rigbody.velocity = Vector2.zero

			return
		end

		if arg0_77.isForwardNorth then
			if not arg0_77.isJumpDown and var0_77 >= -470 then
				arg0_77.isJumpDown = true

				arg0_77:JumpNorth()
				onDelayTick(function()
					arg0_77._tf:SetParent(arg0_77.obstacleTF, false)
				end, 0.3)
			end

			if not arg0_77.isJumpUp and var0_77 >= 310 then
				arg0_77.isJumpUp = true

				arg0_77:JumpNorth()
			end
		end

		if arg0_77.isForwardSouth then
			if not arg0_77.isJumpUp and var0_77 <= 370 then
				arg0_77.isJumpUp = true

				arg0_77:JumpSouth()
			end

			if not arg0_77.isJumpDown and var0_77 <= -420 then
				arg0_77.isJumpDown = true

				arg0_77:JumpSouth()
				onDelayTick(function()
					arg0_77._tf:SetParent(arg0_77.bgFrontTF, false)
				end, 0.3)
			end
		end
	end

	function var0_60.Pause(arg0_80)
		arg0_80.speedRecord = arg0_80.rigbody.velocity
		arg0_80.rigbody.velocity = Vector2.zero
		arg0_80.animator.speed = 0
	end

	function var0_60.Resume(arg0_81)
		arg0_81.rigbody.velocity = arg0_81.speedRecord
		arg0_81.animator.speed = 1
	end

	var0_60:Ctor()

	return var0_60
end

function var0_0.getUIName(arg0_82)
	return "CurlingGameUI"
end

function var0_0.didEnter(arg0_83)
	arg0_83:initEvent()
	arg0_83:initData()
	arg0_83:initUI()
	arg0_83:initGameUI()
	arg0_83:initController()
	arg0_83:updateMainUI()
	arg0_83:openMainUI()
	arg0_83:AutoFitScreen()
end

function var0_0.AutoFitScreen(arg0_84)
	local var0_84 = Screen.width / Screen.height
	local var1_84 = 1.77777777777778
	local var2_84 = arg0_84:findTF("bg_back")
	local var3_84 = 2331
	local var4_84 = var2_84.rect.height
	local var5_84

	if var1_84 <= var0_84 then
		local var6_84 = 1080 * var0_84

		var5_84 = math.clamp(var6_84 / var3_84, 1, 2)
	else
		local var7_84 = 1920 / var0_84

		var5_84 = math.clamp(var7_84 / var4_84, 1, 2)
	end

	setLocalScale(arg0_84._tf, {
		x = var5_84,
		y = var5_84,
		z = var5_84
	})
end

function var0_0.initEvent(arg0_85)
	arg0_85:bind(var43_0, function(arg0_86, arg1_86, arg2_86)
		if arg1_86.result ~= var34_0 then
			arg0_85:addScore(var30_0[arg1_86.result])
		end

		arg0_85:obsFadeOut()
		onDelayTick(function()
			arg0_85:nextRoundGame()
		end, var36_0)
	end)
	arg0_85:bind(var47_0, function(arg0_88, arg1_88, arg2_88)
		if arg1_88.score and arg1_88.score ~= 0 then
			arg0_85:addScore(arg1_88.score, arg1_88.pos)
		end
	end)
end

function var0_0.initData(arg0_89)
	local var0_89 = Application.targetFrameRate or 60

	if var0_89 > 60 then
		var0_89 = 60
	end

	if not Physics2D.autoSimulation then
		arg0_89.needManualSimulate = true
	end

	arg0_89.timer = Timer.New(function()
		arg0_89:onTimer()

		if arg0_89.needManualSimulate then
			Physics2D.Simulate(1 / var0_89)
		end
	end, 1 / var0_89, -1)
end

function var0_0.initUI(arg0_91)
	arg0_91.clickMask = arg0_91:findTF("ui/click_mask")
	arg0_91.mainUI = arg0_91:findTF("ui/main_ui")
	arg0_91.listScrollRect = GetComponent(findTF(arg0_91.mainUI, "item_list"), typeof(ScrollRect))

	onButton(arg0_91, arg0_91:findTF("skin_btn", arg0_91.mainUI), function()
		local var0_92 = pg.mini_game[arg0_91:GetMGData().id].simple_config_data.skin_shop_id

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP, {
			skinId = var0_92
		})
	end, SFX_PANEL)
	onButton(arg0_91, arg0_91:findTF("return_btn", arg0_91.mainUI), function()
		arg0_91:emit(var0_0.ON_BACK_PRESSED)
	end, SFX_PANEL)
	onButton(arg0_91, arg0_91:findTF("help_btn", arg0_91.mainUI), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.CurlingGame_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0_91, arg0_91:findTF("start_btn", arg0_91.mainUI), function()
		arg0_91:readyStart()
	end, SFX_PANEL)

	arg0_91.totalTimes = arg0_91:getGameTotalTime()

	local var0_91 = arg0_91:getGameUsedTimes() - 4 < 0 and 0 or arg0_91:getGameUsedTimes() - 4

	scrollTo(arg0_91.listScrollRect, 0, 1 - var0_91 / (arg0_91.totalTimes - 4))
	onButton(arg0_91, arg0_91:findTF("right_panel/arrows_up", arg0_91.mainUI), function()
		local var0_96 = arg0_91.listScrollRect.normalizedPosition.y + 1 / (arg0_91.totalTimes - 4)

		if var0_96 > 1 then
			var0_96 = 1
		end

		scrollTo(arg0_91.listScrollRect, 0, var0_96)
	end, SFX_PANEL)
	onButton(arg0_91, arg0_91:findTF("right_panel/arrows_down", arg0_91.mainUI), function()
		local var0_97 = arg0_91.listScrollRect.normalizedPosition.y - 1 / (arg0_91.totalTimes - 4)

		if var0_97 < 0 then
			var0_97 = 0
		end

		scrollTo(arg0_91.listScrollRect, 0, var0_97)
	end, SFX_PANEL)

	local var1_91 = arg0_91:findTF("item_tpl", arg0_91.mainUI)

	arg0_91.itemList = {}

	local var2_91 = pg.mini_game[arg0_91:GetMGData().id].simple_config_data.drop

	for iter0_91 = 1, #var2_91 do
		local var3_91 = tf(instantiate(var1_91))

		var3_91.name = "item_" .. iter0_91

		setParent(var3_91, arg0_91:findTF("item_list/Viewport/Content", arg0_91.mainUI))

		local var4_91 = iter0_91

		GetSpriteFromAtlasAsync("ui/minigameui/curlinggameui_atlas", "text_" .. var4_91, function(arg0_98)
			setImageSprite(arg0_91:findTF("bg/text", var3_91), arg0_98, true)
		end)
		setActive(var3_91, true)
		table.insert(arg0_91.itemList, var3_91)

		local var5_91 = arg0_91:findTF("award", var3_91)
		local var6_91 = {
			type = var2_91[iter0_91][1],
			id = var2_91[iter0_91][2],
			count = var2_91[iter0_91][3]
		}

		updateDrop(var5_91, var6_91)
		onButton(arg0_91, var5_91, function()
			arg0_91:emit(BaseUI.ON_DROP, var6_91)
		end, SFX_PANEL)
	end

	arg0_91.countUI = arg0_91:findTF("ui/count_ui")
	arg0_91.countAnimator = GetComponent(arg0_91:findTF("count", arg0_91.countUI), typeof(Animator))
	arg0_91.countDft = GetOrAddComponent(arg0_91:findTF("count", arg0_91.countUI), typeof(DftAniEvent))

	arg0_91.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_91.countDft:SetEndEvent(function()
		setActive(arg0_91.countUI, false)
		arg0_91:startGame()
	end)

	arg0_91.pauseUI = arg0_91:findTF("ui/pause_ui")

	onButton(arg0_91, arg0_91:findTF("ad/panel/sure_btn", arg0_91.pauseUI), function()
		setActive(arg0_91.pauseUI, false)
		arg0_91:resumeGame()
	end, SFX_PANEL)

	arg0_91.returnUI = arg0_91:findTF("ui/return_ui")

	onButton(arg0_91, arg0_91:findTF("ad/panel/sure_btn", arg0_91.returnUI), function()
		setActive(arg0_91.returnUI, false)
		arg0_91:resumeGame()
		arg0_91:endGame()
	end, SFX_PANEL)
	onButton(arg0_91, arg0_91:findTF("ad/panel/cancel_btn", arg0_91.returnUI), function()
		setActive(arg0_91.returnUI, false)
		arg0_91:resumeGame()
	end, SFX_PANEL)

	arg0_91.endUI = arg0_91:findTF("ui/end_ui")

	onButton(arg0_91, arg0_91:findTF("ad/panel/end_btn", arg0_91.endUI), function()
		setActive(arg0_91.endUI, false)
		arg0_91:openMainUI()
	end, SFX_PANEL)

	if not arg0_91.handle then
		arg0_91.handle = UpdateBeat:CreateListener(arg0_91.Update, arg0_91)
	end

	UpdateBeat:AddListener(arg0_91.handle)
end

function var0_0.initGameUI(arg0_106)
	arg0_106.gameUI = arg0_106:findTF("ui/game_ui")
	arg0_106.roundTF = arg0_106:findTF("score_panel/round_text", arg0_106.gameUI)
	arg0_106.scoreTF = arg0_106:findTF("score_panel/score_text", arg0_106.gameUI)

	onButton(arg0_106, arg0_106:findTF("pause_btn", arg0_106.gameUI), function()
		arg0_106:pauseGame()
		setActive(arg0_106.pauseUI, true)
	end)
	onButton(arg0_106, arg0_106:findTF("return_btn", arg0_106.gameUI), function()
		arg0_106:pauseGame()
		setActive(arg0_106.returnUI, true)
	end)

	arg0_106.scoreGroup = arg0_106:findTF("score_group", arg0_106.gameUI)

	setActive(arg0_106:findTF("bg_front/wall"), var39_0)
end

function var0_0.initController(arg0_109)
	arg0_109.scene = arg0_109:findTF("scene")
	arg0_109.gridTF = arg0_109:findTF("ui/grid")
	arg0_109.player = var48_0(arg0_109:findTF("player", arg0_109.scene), arg0_109)
	arg0_109.phy = arg0_109:findTF("Ayanami_phy", arg0_109.scene)
	arg0_109.drawDot = arg0_109:findTF("draw_dot", arg0_109.scene)
	arg0_109.curlingTpls = arg0_109:findTF("curling_Tpl", arg0_109.scene)
	arg0_109.curling = var49_0(arg0_109.curlingTpls, arg0_109.player._tf, arg0_109)
	arg0_109.ofunya = var50_0(arg0_109:findTF("bg_back/07_Ofunya"), arg0_109)
	arg0_109.manjuu = var51_0(arg0_109:findTF("bg_back/08_Manjuu"), arg0_109)
	arg0_109.walker = var53_0(arg0_109:findTF("obstacle/walker", arg0_109.scene), arg0_109)
	arg0_109.obsTF = arg0_109:findTF("scene/obstacle")
	arg0_109.obsCanvas = GetComponent(arg0_109.obsTF, typeof(CanvasGroup))
	arg0_109.obsTpl = arg0_109:findTF("scene/obstacle_Tpl")
	arg0_109.minerGroups = arg0_109:findTF("miner_groups", arg0_109.obsTF)
	arg0_109.oilGroups = arg0_109:findTF("oil_groups", arg0_109.obsTF)
	arg0_109.cubeGroups = arg0_109:findTF("cube_groups", arg0_109.obsTF)
end

function var0_0.updateMainUI(arg0_110)
	local var0_110 = arg0_110:getGameUsedTimes()
	local var1_110 = arg0_110:getGameTimes()

	for iter0_110 = 1, #arg0_110.itemList do
		setActive(arg0_110:findTF("lock", arg0_110.itemList[iter0_110]), false)
		setActive(arg0_110:findTF("finish", arg0_110.itemList[iter0_110]), false)

		if iter0_110 <= var0_110 then
			setActive(arg0_110:findTF("finish", arg0_110.itemList[iter0_110]), true)
		elseif iter0_110 == var0_110 + 1 and var1_110 >= 1 then
			-- block empty
		elseif var0_110 < iter0_110 and iter0_110 <= var0_110 + var1_110 then
			-- block empty
		else
			setActive(arg0_110:findTF("award", arg0_110.itemList[iter0_110]), false)
			setActive(arg0_110:findTF("lock", arg0_110.itemList[iter0_110]), true)
		end
	end

	arg0_110.totalTimes = arg0_110:getGameTotalTime()

	local var2_110 = 1 - (arg0_110:getGameUsedTimes() - 3 < 0 and 0 or arg0_110:getGameUsedTimes() - 3) / (arg0_110.totalTimes - 4)

	if var2_110 > 1 then
		var2_110 = 1
	end

	scrollTo(arg0_110.listScrollRect, 0, var2_110)
	arg0_110:checkGet()
end

function var0_0.checkGet(arg0_111)
	if arg0_111:getUltimate() == 0 then
		if arg0_111:getGameTotalTime() > arg0_111:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_111:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.openMainUI(arg0_112)
	setActive(arg0_112.gameUI, false)
	setActive(arg0_112.mainUI, true)
	arg0_112:updateMainUI()
end

function var0_0.readyStart(arg0_113)
	setActive(arg0_113.mainUI, false)
	setActive(arg0_113.countUI, true)
	arg0_113.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0)
	arg0_113:resetGame()
end

function var0_0.resetGame(arg0_114)
	arg0_114.gameStartFlag = false
	arg0_114.gamePause = false
	arg0_114.gameEndFlag = false
	arg0_114.scoreNum = 0
	arg0_114.roundNum = 1

	arg0_114.player:Reset()
	arg0_114.curling:Reset()
	arg0_114.ofunya:Reset()
	arg0_114.manjuu:Reset()
	arg0_114.walker:Reset()
end

function var0_0.startGame(arg0_115)
	setActive(arg0_115.gameUI, true)
	arg0_115:CoordinateGrid(arg0_115.gridTF)

	arg0_115.gameStartFlag = true

	arg0_115.player:Start()
	arg0_115.curling:Start()
	arg0_115.ofunya:Start()
	arg0_115.manjuu:Start()
	arg0_115:staticObsStart()
	arg0_115:updateGameUI()
	arg0_115:timerStart()
end

function var0_0.staticObsStart(arg0_116)
	setActive(arg0_116.obsTF, true)

	arg0_116.obsCanvas.alpha = 1

	arg0_116.walker:Reset()

	local var0_116 = math.random()
	local var1_116 = var37_0.walker

	if var0_116 <= var1_116.appear then
		setActive(arg0_116.walker._tf, true)
		setLocalScale(arg0_116.walker._tf, Vector2(var38_0.walker, var38_0.walker))

		local var2_116 = var1_116.path[math.random(1, #var1_116.path)]

		arg0_116.walker:SetPath(var2_116)

		local var3_116 = {}

		if var2_116 == var26_0 then
			var3_116 = {
				8,
				11,
				12,
				14,
				15,
				18,
				17,
				21
			}
		elseif var2_116 == var24_0 then
			var3_116 = {
				5,
				9,
				10,
				14,
				15,
				19,
				20,
				24
			}
		end

		local function var4_116(arg0_117)
			for iter0_117, iter1_117 in ipairs(var3_116) do
				if arg0_117 == iter1_117 then
					return true
				end
			end

			return false
		end

		local var5_116 = {}

		for iter0_116, iter1_116 in ipairs(arg0_116.grids) do
			if not var4_116(iter0_116) then
				table.insert(var5_116, iter1_116)
			end
		end

		arg0_116.grids = var5_116

		arg0_116.walker:Start()
	end

	removeAllChildren(arg0_116.oilGroups)

	for iter2_116, iter3_116 in ipairs(var37_0.oil) do
		if math.random() <= iter3_116.appear then
			for iter4_116 = 1, iter3_116.num do
				local var6_116 = cloneTplTo(arg0_116:findTF("oil_Tpl", arg0_116.obsTpl), arg0_116.oilGroups, "oil")

				setActive(var6_116, true)

				local var7_116 = math.random(1, #arg0_116.grids)

				setLocalPosition(var6_116, Vector2(arg0_116.grids[var7_116].x, arg0_116.grids[var7_116].y))
				setLocalScale(var6_116, Vector2(var38_0.oil, var38_0.oil))
				table.remove(arg0_116.grids, var7_116)
			end
		end
	end

	removeAllChildren(arg0_116.cubeGroups)

	for iter5_116, iter6_116 in ipairs(var37_0.cube) do
		if math.random() <= iter6_116.appear then
			for iter7_116 = 1, iter6_116.num do
				local var8_116 = cloneTplTo(arg0_116:findTF("cube_Tpl", arg0_116.obsTpl), arg0_116.cubeGroups, "cube")

				setActive(var8_116, true)

				local var9_116 = math.random(1, #arg0_116.grids)

				setLocalPosition(var8_116, Vector2(arg0_116.grids[var9_116].x, arg0_116.grids[var9_116].y))
				setLocalScale(var8_116, Vector2(var38_0.cube, var38_0.cube))
				table.remove(arg0_116.grids, var9_116)
			end
		end
	end

	removeAllChildren(arg0_116.minerGroups)

	arg0_116.minerControls = {}

	for iter8_116, iter9_116 in ipairs(var37_0.miner) do
		if math.random() <= iter9_116.appear then
			for iter10_116 = 1, iter9_116.num do
				local var10_116 = cloneTplTo(arg0_116:findTF("miner_Tpl", arg0_116.obsTpl), arg0_116.minerGroups, "miner")

				setActive(var10_116, true)

				local var11_116 = var52_0(var10_116, arg0_116)

				table.insert(arg0_116.minerControls, var11_116)

				local var12_116 = math.random(1, #arg0_116.grids)

				setLocalPosition(var10_116, Vector2(arg0_116.grids[var12_116].x, arg0_116.grids[var12_116].y))
				setLocalScale(var10_116, Vector2(var38_0.miner, var38_0.miner))
				table.remove(arg0_116.grids, var12_116)
			end
		end
	end
end

function var0_0.obsFadeOut(arg0_118)
	arg0_118:managedTween(LeanTween.value, function()
		setActive(arg0_118.obsTF, false)
	end, go(arg0_118.obsTF), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_120)
		arg0_118.obsCanvas.alpha = arg0_120
	end))
end

function var0_0.Update(arg0_121)
	arg0_121:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_122)
	if arg0_122.gamePause or arg0_122.gameEndFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.changeSpeed(arg0_123, arg1_123)
	return
end

function var0_0.onTimer(arg0_124)
	arg0_124.curling:Step()
	arg0_124.walker:Step()
	arg0_124:updateGameUI()
end

function var0_0.timerStart(arg0_125)
	if not arg0_125.timer.running then
		arg0_125.timer:Start()
	end
end

function var0_0.timerStop(arg0_126)
	if arg0_126.timer.running then
		arg0_126.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_127)
	setText(arg0_127.scoreTF, arg0_127.scoreNum)
	setText(arg0_127.roundTF, "Round " .. arg0_127.roundNum)
end

function var0_0.addScore(arg0_128, arg1_128, arg2_128)
	local var0_128 = cloneTplTo(arg0_128:findTF("score_tf", arg0_128.gameUI), arg0_128.scoreGroup)

	if arg2_128 then
		setLocalPosition(var0_128, arg2_128)
	else
		setLocalPosition(var0_128, Vector2(432, 144))
	end

	setActive(var0_128, false)
	setActive(var0_128, true)
	setText(var0_128, "+" .. arg1_128)

	arg0_128.scoreNum = arg0_128.scoreNum + arg1_128
end

function var0_0.pauseGame(arg0_129)
	arg0_129.gamePause = true

	arg0_129:timerStop()
	arg0_129:changeSpeed(0)
	arg0_129:pauseManagedTween()
	arg0_129:emit(var45_0)
end

function var0_0.resumeGame(arg0_130)
	arg0_130.gamePause = false

	arg0_130:changeSpeed(1)
	arg0_130:timerStart()
	arg0_130:resumeManagedTween()
	arg0_130:emit(var46_0)
end

function var0_0.nextRoundGame(arg0_131)
	removeAllChildren(arg0_131.scoreGroup)

	if arg0_131.roundNum == 3 then
		arg0_131:endGame()
	else
		arg0_131.roundNum = arg0_131.roundNum + 1

		arg0_131:CoordinateGrid(arg0_131.gridTF)
		arg0_131:staticObsStart()
		arg0_131:emit(var44_0)
	end
end

function var0_0.endGame(arg0_132)
	if arg0_132.gameEndFlag then
		return
	end

	arg0_132:timerStop()

	arg0_132.gameEndFlag = true

	setActive(arg0_132.clickMask, true)
	arg0_132:managedTween(LeanTween.delayedCall, function()
		arg0_132.gameEndFlag = false
		arg0_132.gameStartFlag = false

		setActive(arg0_132.clickMask, false)
		arg0_132:showEndUI()
	end, 0.1, nil)
end

function var0_0.showEndUI(arg0_134)
	setActive(arg0_134.endUI, true)

	local var0_134 = arg0_134:GetMGData():GetRuntimeData("elements")
	local var1_134 = arg0_134.scoreNum
	local var2_134 = var0_134 and #var0_134 > 0 and var0_134[1] or 0

	setActive(arg0_134:findTF("ad/panel/cur_score/new", arg0_134.endUI), var2_134 < var1_134)

	if var2_134 <= var1_134 then
		var2_134 = var1_134

		arg0_134:StoreDataToServer({
			var2_134
		})
	end

	local var3_134 = arg0_134:findTF("ad/panel/highest_score", arg0_134.endUI)
	local var4_134 = arg0_134:findTF("ad/panel/cur_score", arg0_134.endUI)

	setText(var3_134, var2_134)
	setText(var4_134, var1_134)

	if arg0_134:getGameTimes() and arg0_134:getGameTimes() > 0 then
		arg0_134:SendSuccess(0)
	end
end

function var0_0.CoordinateGrid(arg0_135, arg1_135)
	local var0_135 = Vector2(150, 150)
	local var1_135 = arg1_135.rect.width
	local var2_135 = arg1_135.rect.height
	local var3_135 = Vector2(arg1_135.anchoredPosition.x - var1_135 / 2, arg1_135.anchoredPosition.y - var2_135 / 2)
	local var4_135 = math.modf(var2_135 / var0_135.y)
	local var5_135 = var2_135 % var0_135.y / (var4_135 + 1)
	local var6_135 = math.modf(var1_135 / var0_135.x)
	local var7_135 = var1_135 % var0_135.x / (var6_135 + 1)

	arg0_135.grids = {}

	for iter0_135 = 1, var6_135 do
		for iter1_135 = 1, var4_135 do
			local var8_135 = var3_135.x + iter0_135 * (var7_135 + var0_135.x) - var0_135.x / 2
			local var9_135 = var3_135.y + iter1_135 * (var5_135 + var0_135.y) - var0_135.y / 2

			table.insert(arg0_135.grids, Vector2(var8_135, var9_135))
		end
	end
end

function var0_0.getGameTimes(arg0_136)
	return arg0_136:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_137)
	return arg0_137:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_138)
	return arg0_138:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_139)
	return (arg0_139:GetMGHubData():getConfig("reward_need"))
end

function var0_0.onBackPressed(arg0_140)
	if not arg0_140.gameStartFlag then
		arg0_140:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_140.gameEndFlag then
			return
		end

		if isActive(arg0_140.pauseUI) then
			setActive(arg0_140.pauseUI, false)
		end

		arg0_140:pauseGame()
		setActive(arg0_140.returnUI, true)
	end
end

function var0_0.willExit(arg0_141)
	if arg0_141.handle then
		UpdateBeat:RemoveListener(arg0_141.handle)
	end

	arg0_141:cleanManagedTween()

	if arg0_141.timer and arg0_141.timer.running then
		arg0_141.timer:Stop()
	end

	Time.timeScale = 1
	arg0_141.timer = nil
end

return var0_0
