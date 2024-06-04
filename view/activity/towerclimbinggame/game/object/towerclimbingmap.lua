local var0 = class("TowerClimbingMap")

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1.gameView
	arg0.view = arg1
	arg0.map = arg2
end

function var0.Init(arg0, arg1)
	arg0.blocks = {}
	arg0.groundContainer = arg0._tf:Find("game")
	arg0.blockPlayCon = arg0.groundContainer:Find("block_play_con")

	setAnchoredPosition(arg0.blockPlayCon, {
		x = 0,
		y = 0
	})

	arg0.blockContainer = arg0.blockPlayCon:Find("blocks")
	arg0.hearts = {
		arg0._tf:Find("prints/score/hearts/1"),
		arg0._tf:Find("prints/score/hearts/2"),
		arg0._tf:Find("prints/score/hearts/3")
	}
	arg0.score = arg0._tf:Find("prints/score/Text"):GetComponent(typeof(Text))
	arg0.heartProgress = arg0._tf:Find("prints/score/progress")
	arg0.heartProgressTxt = arg0._tf:Find("prints/score/progress/Text"):GetComponent(typeof(Text))
	arg0.bg = TowerClimbBgMgr.New(arg0._tf:Find("bgs"))

	arg0.bg:Init(arg0.map.id, arg1)

	arg0.npc = arg0._tf:Find("prints/npc")

	arg0:LoadEffect(arg0.map.id)

	arg0.tip = arg0._tf:Find("prints/tip")

	setActive(arg0.tip, false)

	arg0.timers = {}
end

function var0.LoadEffect(arg0, arg1)
	local var0 = TowerClimbingGameSettings.MAPID2EFFECT[arg1]

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			local var1 = iter1[1]
			local var2 = iter1[2]

			arg0:LoadSingleEffect(var1, var2)
		end
	end
end

function var0.LoadSingleEffect(arg0, arg1, arg2, arg3)
	PoolMgr.GetInstance():GetUI(arg1, true, function(arg0)
		if not arg0.groundContainer then
			PoolMgr.GetInstance():ReturnUI(arg1, arg0)
		else
			arg0.name = arg1

			SetParent(arg0, arg0.groundContainer)

			arg0.transform.anchoredPosition3D = Vector3(arg2[1], arg2[2], -200)

			setActive(arg0, true)

			if arg3 then
				arg3(arg0)
			end
		end
	end)
end

function var0.ReturnEffect(arg0, arg1)
	local var0 = TowerClimbingGameSettings.MAPID2EFFECT[arg1]

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			local var1 = iter1[1]
			local var2 = arg0.groundContainer:Find(var1)

			if var2 then
				PoolMgr.GetInstance():ReturnUI(var1, var2.gameObject)
			end
		end
	end
end

function var0.OnReachAwardScore(arg0)
	if LOCK_TOWERCLIMBING_AWARD then
		return
	end

	if arg0.tipTimer then
		arg0.tipTimer:Stop()

		arg0.tipTimer = nil
	end

	setActive(arg0.tip, true)

	arg0.tipTimer = Timer.New(function()
		setActive(arg0.tip, false)
		arg0.tipTimer:Stop()

		arg0.tipTimer = nil
	end, 3, 1)

	arg0.tipTimer:Start()

	local var0 = arg0.groundContainer:InverseTransformPoint(arg0.npc.position)
	local var1 = arg0.groundContainer:InverseTransformPoint(arg0.player._tf.position)

	local function var2()
		local function var0()
			setActive(arg0.awardEffect1, true)

			arg0.awardTimer = Timer.New(function()
				setActive(arg0.awardEffect1, false)
			end, 2, 1)

			arg0.awardTimer:Start()
		end

		if not arg0.awardEffect1 then
			local var1 = {
				var0.x,
				var0.y
			}

			arg0:LoadSingleEffect(TowerClimbingGameSettings.AWARDEFFECT1, var1, function(arg0)
				arg0.awardEffect1 = arg0

				var0()
			end)
		else
			var0()
		end
	end

	local function var3()
		local var0 = Vector3(var0.x, var1.y + 200, -200)
		local var1 = {}

		table.insert(var1, Vector3(var1.x, var1.y, -200))
		table.insert(var1, var0)
		table.insert(var1, var0)
		table.insert(var1, Vector3(var0.x, var0.y, -200))

		arg0.awardEffect.transform.localPosition = Vector3(var1.x, var1.y, -200)

		setActive(arg0.awardEffect, true)
		LeanTween.moveLocal(arg0.awardEffect, var1, 1):setOnComplete(System.Action(function()
			setActive(arg0.awardEffect, false)
			var2()
		end))
	end

	if not arg0.awardEffect then
		local var4 = {
			var1.x,
			var1.y
		}

		arg0:LoadSingleEffect(TowerClimbingGameSettings.AWARDEFFECT, var4, function(arg0)
			arg0.awardEffect = arg0

			var3()
		end)
	else
		var3()
	end
end

function var0.GetFirstBlock(arg0)
	return arg0.blocks[1]
end

function var0.GetHitBlock(arg0, arg1)
	local var0 = _.detect(arg0.blocks, function(arg0)
		return arg0.go == arg1
	end)

	if var0 then
		return var0
	end
end

function var0.OnCreateGround(arg0, arg1, arg2)
	arg0.ground = arg1

	TowerClimbingResMgr.GetGround(arg1.name, function(arg0)
		arg0.groundGo = arg0
		arg0.name = "manjuu"

		SetParent(arg0.transform, arg0.groundContainer)

		arg0.transform.anchoredPosition = arg1.position

		setActive(arg0, true)
		arg0:GetComponent("SpineAnimUI"):SetAction("normal", 0)
		setText(arg0.groundGo.transform:Find("Text"), "")
		arg2()
	end)
end

function var0.TranslateBlockPosition(arg0, arg1)
	return arg0.blockContainer:InverseTransformVector(arg0.groundContainer:TransformVector(arg1))
end

function var0.OnCreateBlock(arg0, arg1, arg2)
	TowerClimbingResMgr.GetBlock(arg1.type, function(arg0)
		SetParent(arg0, arg0.blockContainer)

		arg0.transform.anchoredPosition = arg0:TranslateBlockPosition(arg1.position)
		arg0.name = TowerClimbingGameSettings.BLOCK_NAME

		setActive(arg0, true)

		local var0 = arg0:GetComponentsInChildren(typeof(UnityEngine.Collider2D))
		local var1 = {}

		for iter0 = 1, var0.Length do
			table.insert(var1, var0[iter0 - 1])
		end

		table.insert(arg0.blocks, {
			go = arg0,
			block = arg1,
			colliders = var1
		})
		arg0:OnActiveBlock(arg1)

		local var2 = TowerClimbingGameSettings.FIRE_TIME[1]
		local var3 = TowerClimbingGameSettings.FIRE_TIME[2]
		local var4 = math.random(var2, var3)
		local var5 = arg0.transform:Find("firer")

		if var5 then
			local var6 = var5:GetComponent(typeof(Animation))

			arg0.timers[arg1.level] = Timer.New(function()
				var6:Play("action")
			end, var4, -1)

			arg0.timers[arg1.level]:Start()
		end

		arg2()
	end)
end

function var0.OnActiveBlock(arg0, arg1)
	local var0 = _.detect(arg0.blocks, function(arg0)
		return arg0.block.level == arg1.level
	end)

	for iter0, iter1 in ipairs(var0.colliders) do
		iter1.enabled = arg1.isActive
	end
end

function var0.SinkHandler(arg0, arg1, arg2)
	local var0 = arg0.blockPlayCon.anchoredPosition.y
	local var1 = arg0.blockPlayCon.anchoredPosition.y - arg1

	LeanTween.value(arg0.blockPlayCon.gameObject, var0, var1, 0.2):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.blockPlayCon, {
			y = arg0
		})
	end)):setEase(LeanTweenType.easeOutQuad):setOnComplete(System.Action(arg2))
end

function var0.OnBlockDestory(arg0, arg1)
	if arg0.timers[arg1] then
		arg0.timers[arg1]:Stop()

		arg0.timers[arg1] = nil
	end

	local var0 = _.detect(arg0.blocks, function(arg0)
		return arg0.block.level == arg1
	end)

	TowerClimbingResMgr.ReturnBlock(var0.block.type, var0.go)
end

function var0.OnSink(arg0, arg1, arg2)
	arg0.bg:DoMove(arg1, arg2)
	arg2()
end

function var0.OnPlayerLifeUpdate(arg0, arg1)
	triggerToggle(arg0.hearts[3], arg1 >= 3)
	triggerToggle(arg0.hearts[2], arg1 >= 2)
	triggerToggle(arg0.hearts[1], arg1 >= 1)

	arg0.heartProgressTxt.text = arg1 .. "/" .. 3

	setFillAmount(arg0.heartProgress, arg1 / 3)
end

function var0.OnScoreUpdate(arg0, arg1)
	arg0.score.text = arg1
end

function var0.OnCreatePlayer(arg0, arg1, arg2)
	arg0.player = TowerClimbingPlayer.New(arg0, arg1)

	arg0.player:Init(arg2)
end

function var0.OnEnableStab(arg0, arg1, arg2)
	local var0 = _.detect(arg0.blocks, function(arg0)
		return arg0.block.level == arg1.level
	end)

	assert(var0)

	local var1 = var0.go:GetComponent(typeof(UnityEngine.Collider2D))

	for iter0, iter1 in ipairs(var0.colliders) do
		if iter1 ~= var1 then
			iter1.enabled = arg2
		end
	end
end

function var0.OnEnableGround(arg0, arg1)
	arg0.groundGo:GetComponent(typeof(UnityEngine.Collider2D)).enabled = arg1
end

function var0.GetPlayer(arg0)
	return arg0.player
end

function var0.SendEvent(arg0, arg1, ...)
	local var0 = arg0.view.controller

	var0[arg1](var0, unpack({
		...
	}))
end

function var0.OnGroundRuning(arg0)
	arg0.groundGo:GetComponent("SpineAnimUI"):SetAction("up", 0)
end

function var0.OnGroundPositionChange(arg0, arg1)
	setAnchoredPosition(arg0.groundGo.transform, arg1)
end

function var0.OnGroundSleepTimeChange(arg0, arg1)
	local var0 = math.ceil(arg1)

	if var0 > 0 then
		setText(arg0.groundGo.transform:Find("Text"), var0)
	else
		setText(arg0.groundGo.transform:Find("Text"), "")
	end
end

function var0.Dispose(arg0)
	if arg0.awardTimer then
		arg0.awardTimer:Stop()

		arg0.awardTimer = nil
	end

	arg0.bg:Clear()
	arg0:ReturnEffect(arg0.map.id)

	if arg0.awardEffect then
		PoolMgr.GetInstance():ReturnUI(arg0.awardEffect.name, arg0.awardEffect)

		arg0.awardEffect = nil
	end

	if arg0.awardEffect1 then
		PoolMgr.GetInstance():ReturnUI(arg0.awardEffect1.name, arg0.awardEffect1)

		arg0.awardEffect1 = nil
	end

	if arg0.tipTimer then
		arg0.tipTimer:Stop()
	end

	arg0.tipTimer = nil

	for iter0, iter1 in pairs(arg0.timers or {}) do
		iter1:Stop()
	end

	arg0.timers = nil

	if arg0.player then
		arg0.player:Dispose()

		arg0.player = nil
	end

	if arg0.ground and not IsNil(arg0.groundGo) then
		TowerClimbingResMgr.ReturnGround(arg0.ground.name, arg0.groundGo)
	end

	if arg0.blocks then
		for iter2, iter3 in ipairs(arg0.blocks) do
			if not IsNil(iter3.go) then
				TowerClimbingResMgr.ReturnBlock(iter3.block.type, iter3.go)
			end
		end

		arg0.blocks = nil
	end
end

return var0
