local var0_0 = class("TowerClimbingMap")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1.gameView
	arg0_1.view = arg1_1
	arg0_1.map = arg2_1
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.blocks = {}
	arg0_2.groundContainer = arg0_2._tf:Find("game")
	arg0_2.blockPlayCon = arg0_2.groundContainer:Find("block_play_con")

	setAnchoredPosition(arg0_2.blockPlayCon, {
		x = 0,
		y = 0
	})

	arg0_2.blockContainer = arg0_2.blockPlayCon:Find("blocks")
	arg0_2.hearts = {
		arg0_2._tf:Find("prints/score/hearts/1"),
		arg0_2._tf:Find("prints/score/hearts/2"),
		arg0_2._tf:Find("prints/score/hearts/3")
	}
	arg0_2.score = arg0_2._tf:Find("prints/score/Text"):GetComponent(typeof(Text))
	arg0_2.heartProgress = arg0_2._tf:Find("prints/score/progress")
	arg0_2.heartProgressTxt = arg0_2._tf:Find("prints/score/progress/Text"):GetComponent(typeof(Text))
	arg0_2.bg = TowerClimbBgMgr.New(arg0_2._tf:Find("bgs"))

	arg0_2.bg:Init(arg0_2.map.id, arg1_2)

	arg0_2.npc = arg0_2._tf:Find("prints/npc")

	arg0_2:LoadEffect(arg0_2.map.id)

	arg0_2.tip = arg0_2._tf:Find("prints/tip")

	setActive(arg0_2.tip, false)

	arg0_2.timers = {}
end

function var0_0.LoadEffect(arg0_3, arg1_3)
	local var0_3 = TowerClimbingGameSettings.MAPID2EFFECT[arg1_3]

	if var0_3 then
		for iter0_3, iter1_3 in ipairs(var0_3) do
			local var1_3 = iter1_3[1]
			local var2_3 = iter1_3[2]

			arg0_3:LoadSingleEffect(var1_3, var2_3)
		end
	end
end

function var0_0.LoadSingleEffect(arg0_4, arg1_4, arg2_4, arg3_4)
	PoolMgr.GetInstance():GetUI(arg1_4, true, function(arg0_5)
		if not arg0_4.groundContainer then
			PoolMgr.GetInstance():ReturnUI(arg1_4, arg0_5)
		else
			arg0_5.name = arg1_4

			SetParent(arg0_5, arg0_4.groundContainer)

			arg0_5.transform.anchoredPosition3D = Vector3(arg2_4[1], arg2_4[2], -200)

			setActive(arg0_5, true)

			if arg3_4 then
				arg3_4(arg0_5)
			end
		end
	end)
end

function var0_0.ReturnEffect(arg0_6, arg1_6)
	local var0_6 = TowerClimbingGameSettings.MAPID2EFFECT[arg1_6]

	if var0_6 then
		for iter0_6, iter1_6 in ipairs(var0_6) do
			local var1_6 = iter1_6[1]
			local var2_6 = arg0_6.groundContainer:Find(var1_6)

			if var2_6 then
				PoolMgr.GetInstance():ReturnUI(var1_6, var2_6.gameObject)
			end
		end
	end
end

function var0_0.OnReachAwardScore(arg0_7)
	if LOCK_TOWERCLIMBING_AWARD then
		return
	end

	if arg0_7.tipTimer then
		arg0_7.tipTimer:Stop()

		arg0_7.tipTimer = nil
	end

	setActive(arg0_7.tip, true)

	arg0_7.tipTimer = Timer.New(function()
		setActive(arg0_7.tip, false)
		arg0_7.tipTimer:Stop()

		arg0_7.tipTimer = nil
	end, 3, 1)

	arg0_7.tipTimer:Start()

	local var0_7 = arg0_7.groundContainer:InverseTransformPoint(arg0_7.npc.position)
	local var1_7 = arg0_7.groundContainer:InverseTransformPoint(arg0_7.player._tf.position)

	local function var2_7()
		local function var0_9()
			setActive(arg0_7.awardEffect1, true)

			arg0_7.awardTimer = Timer.New(function()
				setActive(arg0_7.awardEffect1, false)
			end, 2, 1)

			arg0_7.awardTimer:Start()
		end

		if not arg0_7.awardEffect1 then
			local var1_9 = {
				var0_7.x,
				var0_7.y
			}

			arg0_7:LoadSingleEffect(TowerClimbingGameSettings.AWARDEFFECT1, var1_9, function(arg0_12)
				arg0_7.awardEffect1 = arg0_12

				var0_9()
			end)
		else
			var0_9()
		end
	end

	local function var3_7()
		local var0_13 = Vector3(var0_7.x, var1_7.y + 200, -200)
		local var1_13 = {}

		table.insert(var1_13, Vector3(var1_7.x, var1_7.y, -200))
		table.insert(var1_13, var0_13)
		table.insert(var1_13, var0_13)
		table.insert(var1_13, Vector3(var0_7.x, var0_7.y, -200))

		arg0_7.awardEffect.transform.localPosition = Vector3(var1_7.x, var1_7.y, -200)

		setActive(arg0_7.awardEffect, true)
		LeanTween.moveLocal(arg0_7.awardEffect, var1_13, 1):setOnComplete(System.Action(function()
			setActive(arg0_7.awardEffect, false)
			var2_7()
		end))
	end

	if not arg0_7.awardEffect then
		local var4_7 = {
			var1_7.x,
			var1_7.y
		}

		arg0_7:LoadSingleEffect(TowerClimbingGameSettings.AWARDEFFECT, var4_7, function(arg0_15)
			arg0_7.awardEffect = arg0_15

			var3_7()
		end)
	else
		var3_7()
	end
end

function var0_0.GetFirstBlock(arg0_16)
	return arg0_16.blocks[1]
end

function var0_0.GetHitBlock(arg0_17, arg1_17)
	local var0_17 = _.detect(arg0_17.blocks, function(arg0_18)
		return arg0_18.go == arg1_17
	end)

	if var0_17 then
		return var0_17
	end
end

function var0_0.OnCreateGround(arg0_19, arg1_19, arg2_19)
	arg0_19.ground = arg1_19

	TowerClimbingResMgr.GetGround(arg1_19.name, function(arg0_20)
		arg0_19.groundGo = arg0_20
		arg0_20.name = "manjuu"

		SetParent(arg0_20.transform, arg0_19.groundContainer)

		arg0_20.transform.anchoredPosition = arg1_19.position

		setActive(arg0_20, true)
		arg0_20:GetComponent("SpineAnimUI"):SetAction("normal", 0)
		setText(arg0_19.groundGo.transform:Find("Text"), "")
		arg2_19()
	end)
end

function var0_0.TranslateBlockPosition(arg0_21, arg1_21)
	return arg0_21.blockContainer:InverseTransformVector(arg0_21.groundContainer:TransformVector(arg1_21))
end

function var0_0.OnCreateBlock(arg0_22, arg1_22, arg2_22)
	TowerClimbingResMgr.GetBlock(arg1_22.type, function(arg0_23)
		SetParent(arg0_23, arg0_22.blockContainer)

		arg0_23.transform.anchoredPosition = arg0_22:TranslateBlockPosition(arg1_22.position)
		arg0_23.name = TowerClimbingGameSettings.BLOCK_NAME

		setActive(arg0_23, true)

		local var0_23 = arg0_23:GetComponentsInChildren(typeof(UnityEngine.Collider2D))
		local var1_23 = {}

		for iter0_23 = 1, var0_23.Length do
			table.insert(var1_23, var0_23[iter0_23 - 1])
		end

		table.insert(arg0_22.blocks, {
			go = arg0_23,
			block = arg1_22,
			colliders = var1_23
		})
		arg0_22:OnActiveBlock(arg1_22)

		local var2_23 = TowerClimbingGameSettings.FIRE_TIME[1]
		local var3_23 = TowerClimbingGameSettings.FIRE_TIME[2]
		local var4_23 = math.random(var2_23, var3_23)
		local var5_23 = arg0_23.transform:Find("firer")

		if var5_23 then
			local var6_23 = var5_23:GetComponent(typeof(Animation))

			arg0_22.timers[arg1_22.level] = Timer.New(function()
				var6_23:Play("action")
			end, var4_23, -1)

			arg0_22.timers[arg1_22.level]:Start()
		end

		arg2_22()
	end)
end

function var0_0.OnActiveBlock(arg0_25, arg1_25)
	local var0_25 = _.detect(arg0_25.blocks, function(arg0_26)
		return arg0_26.block.level == arg1_25.level
	end)

	for iter0_25, iter1_25 in ipairs(var0_25.colliders) do
		iter1_25.enabled = arg1_25.isActive
	end
end

function var0_0.SinkHandler(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.blockPlayCon.anchoredPosition.y
	local var1_27 = arg0_27.blockPlayCon.anchoredPosition.y - arg1_27

	LeanTween.value(arg0_27.blockPlayCon.gameObject, var0_27, var1_27, 0.2):setOnUpdate(System.Action_float(function(arg0_28)
		setAnchoredPosition(arg0_27.blockPlayCon, {
			y = arg0_28
		})
	end)):setEase(LeanTweenType.easeOutQuad):setOnComplete(System.Action(arg2_27))
end

function var0_0.OnBlockDestory(arg0_29, arg1_29)
	if arg0_29.timers[arg1_29] then
		arg0_29.timers[arg1_29]:Stop()

		arg0_29.timers[arg1_29] = nil
	end

	local var0_29 = _.detect(arg0_29.blocks, function(arg0_30)
		return arg0_30.block.level == arg1_29
	end)

	TowerClimbingResMgr.ReturnBlock(var0_29.block.type, var0_29.go)
end

function var0_0.OnSink(arg0_31, arg1_31, arg2_31)
	arg0_31.bg:DoMove(arg1_31, arg2_31)
	arg2_31()
end

function var0_0.OnPlayerLifeUpdate(arg0_32, arg1_32)
	triggerToggle(arg0_32.hearts[3], arg1_32 >= 3)
	triggerToggle(arg0_32.hearts[2], arg1_32 >= 2)
	triggerToggle(arg0_32.hearts[1], arg1_32 >= 1)

	arg0_32.heartProgressTxt.text = arg1_32 .. "/" .. 3

	setFillAmount(arg0_32.heartProgress, arg1_32 / 3)
end

function var0_0.OnScoreUpdate(arg0_33, arg1_33)
	arg0_33.score.text = arg1_33
end

function var0_0.OnCreatePlayer(arg0_34, arg1_34, arg2_34)
	arg0_34.player = TowerClimbingPlayer.New(arg0_34, arg1_34)

	arg0_34.player:Init(arg2_34)
end

function var0_0.OnEnableStab(arg0_35, arg1_35, arg2_35)
	local var0_35 = _.detect(arg0_35.blocks, function(arg0_36)
		return arg0_36.block.level == arg1_35.level
	end)

	assert(var0_35)

	local var1_35 = var0_35.go:GetComponent(typeof(UnityEngine.Collider2D))

	for iter0_35, iter1_35 in ipairs(var0_35.colliders) do
		if iter1_35 ~= var1_35 then
			iter1_35.enabled = arg2_35
		end
	end
end

function var0_0.OnEnableGround(arg0_37, arg1_37)
	arg0_37.groundGo:GetComponent(typeof(UnityEngine.Collider2D)).enabled = arg1_37
end

function var0_0.GetPlayer(arg0_38)
	return arg0_38.player
end

function var0_0.SendEvent(arg0_39, arg1_39, ...)
	local var0_39 = arg0_39.view.controller

	var0_39[arg1_39](var0_39, unpack({
		...
	}))
end

function var0_0.OnGroundRuning(arg0_40)
	arg0_40.groundGo:GetComponent("SpineAnimUI"):SetAction("up", 0)
end

function var0_0.OnGroundPositionChange(arg0_41, arg1_41)
	setAnchoredPosition(arg0_41.groundGo.transform, arg1_41)
end

function var0_0.OnGroundSleepTimeChange(arg0_42, arg1_42)
	local var0_42 = math.ceil(arg1_42)

	if var0_42 > 0 then
		setText(arg0_42.groundGo.transform:Find("Text"), var0_42)
	else
		setText(arg0_42.groundGo.transform:Find("Text"), "")
	end
end

function var0_0.Dispose(arg0_43)
	if arg0_43.awardTimer then
		arg0_43.awardTimer:Stop()

		arg0_43.awardTimer = nil
	end

	arg0_43.bg:Clear()
	arg0_43:ReturnEffect(arg0_43.map.id)

	if arg0_43.awardEffect then
		PoolMgr.GetInstance():ReturnUI(arg0_43.awardEffect.name, arg0_43.awardEffect)

		arg0_43.awardEffect = nil
	end

	if arg0_43.awardEffect1 then
		PoolMgr.GetInstance():ReturnUI(arg0_43.awardEffect1.name, arg0_43.awardEffect1)

		arg0_43.awardEffect1 = nil
	end

	if arg0_43.tipTimer then
		arg0_43.tipTimer:Stop()
	end

	arg0_43.tipTimer = nil

	for iter0_43, iter1_43 in pairs(arg0_43.timers or {}) do
		iter1_43:Stop()
	end

	arg0_43.timers = nil

	if arg0_43.player then
		arg0_43.player:Dispose()

		arg0_43.player = nil
	end

	if arg0_43.ground and not IsNil(arg0_43.groundGo) then
		TowerClimbingResMgr.ReturnGround(arg0_43.ground.name, arg0_43.groundGo)
	end

	if arg0_43.blocks then
		for iter2_43, iter3_43 in ipairs(arg0_43.blocks) do
			if not IsNil(iter3_43.go) then
				TowerClimbingResMgr.ReturnBlock(iter3_43.block.type, iter3_43.go)
			end
		end

		arg0_43.blocks = nil
	end
end

return var0_0
