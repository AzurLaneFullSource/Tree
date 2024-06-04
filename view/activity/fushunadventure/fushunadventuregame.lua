local var0 = class("FushunAdventureGame")
local var1 = false
local var2 = 0
local var3 = 1
local var4 = 2
local var5 = 3
local var6 = 4

function var0.Ctor(arg0, arg1, arg2, arg3)
	pg.DelegateInfo.New(arg0)

	arg0.fushunLoader = AutoLoader.New()
	arg0.state = var2
	arg0._go = arg1
	arg0.gameData = arg2
	arg0.highestScore = (arg3:GetRuntimeData("elements") or {})[1] or 0

	arg0:Init()
end

function var0.SetOnShowResult(arg0, arg1)
	arg0.OnShowResult = arg1
end

function var0.SetOnLevelUpdate(arg0, arg1)
	arg0.OnLevelUpdate = arg1
end

function var0.Init(arg0)
	if arg0.state ~= var2 then
		return
	end

	arg0.state = var4

	arg0:InitMainUI()
end

function var0.InitMainUI(arg0)
	local var0 = arg0._go

	onButton(arg0, findTF(var0, "btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fushun_adventure_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, findTF(var0, "btn_start"), function()
		pg.BgmMgr.GetInstance():StopPlay()
		arg0:StartGame()
	end, SFX_PANEL)

	arg0.levelList = UIItemList.New(findTF(var0, "levels/scrollrect/content"), findTF(var0, "levels/scrollrect/content/level"))
	arg0.arrUp = findTF(var0, "levels/arr_up")
	arg0.arrDown = findTF(var0, "levels/arr_bottom")

	onScroll(arg0, findTF(var0, "levels/scrollrect"), function(arg0)
		setActive(arg0.arrUp, arg0.y < 1)
		setActive(arg0.arrDown, arg0.y > 0)
	end)
	arg0:RefreshLevels()
end

function var0.RefreshLevels(arg0)
	local var0

	arg0.levelList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg2:Find("Text"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/FushunAdventureGame_atlas", "level_" .. arg1 + 1)

			local var0 = arg0.gameData.count > 0 and 1 or 0
			local var1 = arg1 >= arg0.gameData.usedtime + var0

			setActive(arg2:Find("lock"), var1)

			local var2 = arg1 < arg0.gameData.usedtime

			setActive(arg2:Find("cleared"), var2)
			setActive(arg2:Find("Text"), not var1)

			if not var2 and not var0 then
				var0 = arg1
			end

			arg2:GetComponent(typeof(Image)).enabled = not var1
		end
	end)
	arg0.levelList:align(FushunAdventureGameConst.LEVEL_CNT)
	setActive(findTF(arg0._go, "tip/got"), arg0.gameData.ultimate ~= 0)

	if var0 then
		local var1 = var0 * (arg0.levelList.item.rect.height + 50)
		local var2 = arg0.levelList.container.anchoredPosition

		setAnchoredPosition(arg0.levelList.container, {
			y = var2.y + var1
		})
	end

	if arg0.OnLevelUpdate then
		arg0.OnLevelUpdate()
	end
end

function var0.InitGameUI(arg0)
	local var0 = arg0.gameUI

	arg0.btnA = findTF(var0, "UI/A")
	arg0.btnB = findTF(var0, "UI/B")
	arg0.btnAEffect = arg0.btnA:Find("effect")
	arg0.btnBEffect = arg0.btnB:Find("effect")
	arg0.btnAExEffect = arg0.btnA:Find("effect_ex")
	arg0.btnBExEffect = arg0.btnB:Find("effect_ex")
	arg0.keys = {
		findTF(var0, "UI/keys/1"):GetComponent(typeof(Image)),
		findTF(var0, "UI/keys/2"):GetComponent(typeof(Image)),
		findTF(var0, "UI/keys/3"):GetComponent(typeof(Image))
	}
	arg0.btnSprites = {
		arg0.keys[1].sprite,
		arg0.btnA:GetComponent(typeof(Image)).sprite,
		arg0.btnB:GetComponent(typeof(Image)).sprite
	}
	arg0.hearts = {
		findTF(var0, "UI/heart_score/hearts/1/mark"),
		findTF(var0, "UI/heart_score/hearts/2/mark"),
		findTF(var0, "UI/heart_score/hearts/3/mark")
	}
	arg0.numbers = {
		findTF(var0, "UI/countdown_panel/timer/3"),
		findTF(var0, "UI/countdown_panel/timer/2"),
		findTF(var0, "UI/countdown_panel/timer/1")
	}
	arg0.scoreTxt = findTF(var0, "UI/heart_score/score/Text"):GetComponent(typeof(Text))
	arg0.energyBar = findTF(var0, "UI/ex/bar"):GetComponent(typeof(Image))
	arg0.energyIcon = findTF(var0, "UI/ex/icon")
	arg0.energyLight = findTF(var0, "UI/ex/light")
	arg0.exTipPanel = findTF(var0, "UI/ex_tip_panel")
	arg0.comboTxt = findTF(var0, "UI/combo/Text"):GetComponent(typeof(Text))
	arg0.countdownPanel = findTF(var0, "UI/countdown_panel")
	arg0.resultPanel = findTF(var0, "UI/result_panel")
	arg0.resultCloseBtn = findTF(arg0.resultPanel, "frame/close")
	arg0.resultHighestScoreTxt = findTF(arg0.resultPanel, "frame/highest/Text"):GetComponent(typeof(Text))
	arg0.resultScoreTxt = findTF(arg0.resultPanel, "frame/score/Text"):GetComponent(typeof(Text))
	arg0.msgboxPanel = findTF(var0, "UI/msg_panel")
	arg0.exitMsgboxWindow = findTF(arg0.msgboxPanel, "frame/exit_mode")
	arg0.pauseMsgboxWindow = findTF(arg0.msgboxPanel, "frame/pause_mode")
	arg0.helpWindow = findTF(var0, "UI/help")
	arg0.lightTF = findTF(var0, "game/range")
	arg0.lightMark = arg0.lightTF:Find("Image")
	arg0.pauseBtn = findTF(var0, "UI/pause")
	arg0.exitBtn = findTF(var0, "UI/back")
	arg0.energyBar.fillAmount = 0
end

function var0.EnterAnimation(arg0, arg1)
	setActive(arg0.countdownPanel, true)

	local function var0(arg0)
		for iter0, iter1 in ipairs(arg0.numbers) do
			setActive(iter1, iter0 == arg0)
		end
	end

	local var1 = 1

	arg0.countdownTimer = Timer.New(function()
		var1 = var1 + 1

		if var1 > 3 then
			setActive(arg0.countdownPanel, false)
			arg1()
		else
			var0(var1)
		end
	end, 1, 3)

	var0(var1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.COUNT_DOWN_VOICE)
	arg0.countdownTimer:Start()
end

function var0.ShowHelpWindow(arg0, arg1)
	setActive(arg0.helpWindow, true)
	onButton(arg0, arg0.helpWindow, function()
		setActive(arg0.helpWindow, false)
		PlayerPrefs.SetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 1)
		arg1()
	end, SFX_PANEL)
end

function var0.DisplayKey(arg0)
	local function var0(arg0, arg1)
		local var0

		if not arg1 or arg1 == "" then
			var0 = arg0.btnSprites[1]
		elseif arg1 == "A" then
			var0 = arg0.btnSprites[2]
		elseif arg1 == "B" then
			var0 = arg0.btnSprites[3]
		end

		if arg0.sprite ~= var0 then
			arg0.sprite = var0
		end
	end

	for iter0, iter1 in ipairs(arg0.keys) do
		local var1 = string.sub(arg0.key, iter0, iter0) or ""

		var0(iter1, var1)
	end
end

function var0.DisplayeHearts(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.hearts) do
		setActive(iter1, iter0 <= arg1)
	end
end

function var0.DisplayScore(arg0)
	arg0.scoreTxt.text = arg0.score
end

function var0.DisplayeEnergy(arg0, arg1, arg2)
	local var0 = math.min(1, arg1 / arg2)

	arg0.energyBar.fillAmount = var0

	local var1 = arg0.energyIcon.parent.rect.width * var0
	local var2 = var1 - arg0.energyIcon.rect.width

	setAnchoredPosition(arg0.energyIcon, {
		x = math.max(0, var2)
	})

	local var3 = 0

	if var0 >= 1 then
		var3 = tf(arg0.energyBar.gameObject).rect.width
	elseif var1 > 0 then
		var3 = var1
	end

	setActive(arg0.energyLight, var0 >= 0.01)

	arg0.energyLight.sizeDelta = Vector2(var3, arg0.energyLight.sizeDelta.y)
end

function var0.StartGame(arg0)
	if arg0.state ~= var4 then
		return
	end

	arg0.enemys = {}
	arg0.hitList = {}
	arg0.missFlags = {}
	arg0.score = 0
	arg0.combo = 0
	arg0.pause = false
	arg0.schedule = FushunSchedule.New()
	arg0.specailSchedule = FushunSchedule.New()

	arg0:LoadScene(function()
		arg0:EnterGame()
		pg.BgmMgr.GetInstance():Push(arg0.__cname, FushunAdventureGameConst.GAME_BGM_NAME)
	end)

	arg0.state = var5
end

function var0.LoadScene(arg0, arg1)
	seriesAsync({
		function(arg0)
			if arg0.gameUI then
				setActive(arg0.gameUI, true)
				arg0()
			else
				arg0.fushunLoader:LoadPrefab("ui/FushunAdventureGame", "", function(arg0)
					arg0.gameUI = arg0

					arg0.transform:SetParent(arg0._go.transform, false)
					arg0:InitGameUI()
					arg0()
				end, "FushunAdventureGame")
			end
		end,
		function(arg0)
			arg0:DisplayeHearts(3)
			arg0:DisplayScore()
			arg0:DisplayeEnergy(0, 1)

			if not (PlayerPrefs.GetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 0) > 0) then
				arg0:ShowHelpWindow(arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			parallelAsync({
				function(arg0)
					arg0:EnterAnimation(arg0)
				end,
				function(arg0)
					arg0.fushunLoader:LoadPrefab("FushunAdventure/fushun", "", function(arg0)
						arg0.fushun = FushunChar.New(arg0)

						arg0.fushun:SetPosition(FushunAdventureGameConst.FUSHUN_INIT_POSITION)
						arg0.transform:SetParent(arg0.gameUI.transform:Find("game"), false)
						arg0()
					end, "fushun")
				end
			}, arg0)
		end
	}, arg1)
end

function var0.EnterGame(arg0)
	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.UpdateGame, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)

	arg0.lightTF.sizeDelta = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_RANGE, arg0.lightTF.sizeDelta.y)
	arg0.lightTF.localPosition = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_DISTANCE + arg0.fushun:GetPosition().x, arg0.lightTF.localPosition.y)

	arg0:SpawnEnemys()
	arg0:RegisterEventListener()

	arg0.key = ""

	arg0.fushun:SetOnAnimEnd(function()
		arg0.key = ""

		arg0:DisplayKey()
	end)
end

function var0.UpdateGame(arg0)
	if arg0.state == var6 then
		arg0:ExitGame(true)

		return
	end

	if not arg0.pause then
		arg0.spawner:Update()
		arg0:AddDebugInput()

		if arg0.fushun:IsDeath() then
			arg0.fushun:Die()

			arg0.state = var6

			return
		elseif arg0.fushun:ShouldInvincible() then
			arg0:EnterInvincibleMode()
		elseif arg0.fushun:ShouldVincible() then
			arg0:ExitInvincibleMode()
		end

		local var0 = false

		for iter0 = #arg0.enemys, 1, -1 do
			local var1 = arg0.enemys[iter0]

			if var1:IsFreeze() then
				-- block empty
			elseif arg0:CheckEnemyDeath(iter0) then
				-- block empty
			else
				var1:Move()
				arg0:CheckCollision(arg0.fushun, var1)

				if arg0:CheckAttackRange(var1) then
					var0 = true
				end
			end
		end

		arg0:RangeLightDisplay(var0)
		arg0:DisplayeEnergy(arg0.fushun:GetEnergy(), arg0.fushun:GetEnergyTarget())
		arg0.specailSchedule:Update()
	else
		for iter1 = #arg0.enemys, 1, -1 do
			arg0:CheckEnemyDeath(iter1)
		end
	end

	arg0.schedule:Update()
end

function var0.RangeLightDisplay(arg0, arg1)
	setActive(arg0.lightMark, arg1)
end

function var0.CheckAttackRange(arg0, arg1)
	local var0 = arg0.fushun

	return arg1:GetPosition().x <= var0:GetAttackPosition().x
end

function var0.CheckEnemyDeath(arg0, arg1)
	local var0 = false
	local var1 = arg0.enemys[arg1]

	if var1:IsDeath() then
		if arg0.hitList[var1.index] and not var1:IsEscape() then
			arg0:AddScore(var1:GetScore())
			arg0:AddEnergy(var1:GetEnergyScore())
		end

		var1:Vanish()
		table.remove(arg0.enemys, arg1)

		var0 = true
	end

	return var0
end

function var0.EnterInvincibleMode(arg0)
	local var0 = FushunAdventureGameConst.EX_TIP_TIME
	local var1 = FushunAdventureGameConst.EX_TIME

	arg0.fushun:Invincible()
	setActive(arg0.exTipPanel, true)

	arg0.pause = true

	blinkAni(arg0.energyBar.gameObject, 0.5, -1)
	arg0.schedule:AddSchedule(var0, 1, function()
		setActive(arg0.exTipPanel, false)
		arg0.spawner:CarzyMode()

		arg0.pause = false

		arg0.fushun:StartAction("EX")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.ENTER_EX_VOICE)

		local var0 = arg0.fushun:GetEnergyTarget() / var1

		arg0.specailSchedule:AddSchedule(1, var1, function()
			arg0.fushun:ReduceEnergy(var0)
		end)
	end)
	setActive(arg0.btnAExEffect, true)
	setActive(arg0.btnBExEffect, true)

	arg0.key = ""

	arg0:DisplayKey()
end

function var0.ExitInvincibleMode(arg0)
	arg0.fushun:Vincible()

	arg0.energyBar.color = Color.New(1, 1, 1, 1)

	LeanTween.cancel(arg0.energyBar.gameObject)

	for iter0, iter1 in ipairs(arg0.enemys) do
		arg0.hitList[iter1.index] = nil

		iter1:Die()
	end

	arg0.spawner:NormalMode()
	setActive(arg0.btnAExEffect, false)
	setActive(arg0.btnBExEffect, false)
end

function var0.CheckCollision(arg0, arg1, arg2)
	if var0.IsCollision(arg2.effectCollider2D, arg1.collider2D) then
		arg1:Hurt()
		arg2:OnHit()
		arg0:DisplayeHearts(arg0.fushun:GetHp())
		arg0:AddCombo(-arg0.combo)
	elseif arg0.fushun:InvincibleState() and not arg2:IsDeath() and arg2:GetPosition().x <= arg1:GetAttackPosition().x then
		arg2:Hurt(1)

		arg0.hitList[arg2.index] = true

		arg0:AddHitEffect(arg2)
	elseif var0.IsNearby(arg1:GetPosition(), arg2:GetAttackPosition()) then
		arg2:Attack()
	end
end

function var0.AddHitEffect(arg0, arg1)
	local var0 = arg0.fushun.effectCollider2D.bounds.center
	local var1 = arg0.gameUI.transform:InverseTransformPoint(var0)
	local var2 = arg1.collider2D.bounds:GetMin()
	local var3 = arg0.gameUI.transform:InverseTransformPoint(var2)
	local var4 = Vector3(var3.x, var1.y, 0)

	arg0.fushunLoader:GetPrefab("FushunAdventure/attack_effect", "", function(arg0)
		arg0.transform:SetParent(arg0.gameUI.transform, false)

		arg0.transform.localPosition = var4

		local var0 = arg0:GetComponent(typeof(DftAniEvent))

		var0:SetEndEvent(function()
			var0:SetEndEvent(nil)
			arg0.fushunLoader:ReturnPrefab(arg0)
		end)
	end)
	arg0:ShakeScreen(arg0.gameUI)
end

function var0.ShakeScreen(arg0, arg1)
	if LeanTween.isTweening(arg1) then
		LeanTween.cancel(arg1)
	end

	LeanTween.rotateAroundLocal(arg1, Vector3(0, 0, 1), FushunAdventureGameConst.SHAKE_RANGE, FushunAdventureGameConst.SHAKE_TIME):setLoopPingPong(FushunAdventureGameConst.SHAKE_LOOP_CNT):setFrom(-1 * FushunAdventureGameConst.SHAKE_RANGE):setOnComplete(System.Action(function()
		arg1.transform.localEulerAngles = Vector3(0, 0, 0)
	end))
end

function var0.SpawnEnemys(arg0)
	local var0 = {
		FushunBeastChar,
		FushunEliteBeastChar,
		FushunEliteBeastChar
	}

	local function var1(arg0)
		local var0 = FushunAdventureGameConst.SPEED_ADDITION
		local var1

		for iter0, iter1 in ipairs(var0) do
			local var2 = iter1[1][1]
			local var3 = iter1[1][2]

			if var2 <= arg0 and arg0 <= var3 then
				var1 = iter1

				break
			end
		end

		var1 = var1 or var0[#var0]

		return var1[2]
	end

	local function var2(arg0)
		local var0 = arg0.config
		local var1 = arg0.speed
		local var2 = arg0.index
		local var3 = var0[var0.id].New(arg0.go, var2, var0, arg0.fushunLoader)
		local var4 = var1 + var1(arg0.score)

		var0.LOG("  顺序 :", var2, " id :", var0.id, " speed :", var4)
		var3:SetSpeed(var4)
		var3:SetPosition(FushunAdventureGameConst.ENEMY_SPAWN_POSITION)
		table.insert(arg0.enemys, var3)
	end

	arg0.spawner = FuShunEnemySpawner.New(arg0.gameUI.transform:Find("game").transform, var2, arg0.fushunLoader)

	arg0.spawner:NormalMode()
end

function var0.AddScore(arg0, arg1)
	arg0:AddCombo(1)

	local var0 = arg0.combo >= FushunAdventureGameConst.COMBO_SCORE_TARGET and FushunAdventureGameConst.COMBO_EXTRA_SCORE or 0

	arg0.score = arg0.score + arg1 + var0

	arg0:DisplayScore()
	arg0.spawner:UpdateScore(arg0.score)
end

function var0.AddEnergy(arg0, arg1)
	arg0.fushun:AddEnergy(arg1)
end

function var0.AddCombo(arg0, arg1)
	if arg1 > 0 then
		arg0.fushunLoader:GetPrefab("UI/fushun_combo", "", function(arg0)
			if not arg0.fushunLoader then
				Destroy(arg0)

				return
			end

			arg0.transform:SetParent(arg0.gameUI.transform:Find("UI"), false)
			Timer.New(function()
				if not arg0.fushunLoader then
					return
				end

				arg0.fushunLoader:ReturnPrefab(arg0)
			end, 2, 1):Start()
		end)
	end

	arg0.combo = arg0.combo + arg1
	arg0.comboTxt.text = arg0.combo

	setActive(arg0.comboTxt.gameObject.transform.parent, arg0.combo > 0)
end

function var0.Action(arg0, arg1)
	if arg0.fushun:InvincibleState() then
		arg0:AddScore(FushunAdventureGameConst.EX_CLICK_SCORE)
	else
		arg0:OnFushunAttack(arg1)
	end
end

function var0.OnFushunAttack(arg0, arg1)
	if #arg0.key == 3 or arg0.fushun:IsMissState() or arg0.fushun:IsDamageState() then
		return
	end

	arg0.key = arg0.key .. arg1

	arg0:DisplayKey()

	local var0 = {}
	local var1 = arg0.fushun

	for iter0, iter1 in ipairs(arg0.enemys) do
		if not iter1:WillDeath() and iter1:GetPosition().x <= var1:GetAttackPosition().x then
			table.insert(var0, iter0)
		end
	end

	arg0.fushun:TriggerAction(arg0.key, function()
		if #var0 == 0 then
			arg0.fushun:Miss()
		end

		arg0.key = ""

		arg0:DisplayKey()
	end)

	if #var0 > 0 then
		for iter2, iter3 in ipairs(var0) do
			local var2 = arg0.enemys[iter3]

			var2:Hurt(1)

			arg0.hitList[var2.index] = true

			arg0:AddHitEffect(var2)
		end
	end
end

function var0.PauseGame(arg0)
	arg0.pause = true
end

function var0.ResumeGame(arg0)
	arg0.pause = false
end

function var0.ExitGame(arg0, arg1)
	local function var0()
		arg0:ClearGameScene()
	end

	if arg0.btnA then
		ClearEventTrigger(arg0.btnA:GetComponent("EventTriggerListener"))
	end

	if arg0.btnB then
		ClearEventTrigger(arg0.btnB:GetComponent("EventTriggerListener"))
	end

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)

		arg0.handle = nil
	end

	if arg0.schedule then
		arg0.schedule:Dispose()

		arg0.schedule = nil
	end

	if arg0.specailSchedule then
		arg0.specailSchedule:Dispose()

		arg0.specailSchedule = nil
	end

	if arg1 then
		if arg0.OnShowResult then
			arg0.OnShowResult(arg0.score)
		end

		arg0:ShowResultWindow(function()
			var0()
		end)
	else
		var0()
	end
end

function var0.ClearGameScene(arg0)
	if arg0.fushun then
		arg0.fushun:Destory()

		arg0.fushun = nil
	end

	if arg0.spawner then
		arg0.spawner:Dispose()

		arg0.spawner = nil
	end

	if arg0.enemys then
		for iter0, iter1 in ipairs(arg0.enemys) do
			iter1:Dispose()
		end

		arg0.enemys = nil
	end

	arg0.state = var4

	if arg0.gameUI then
		arg0:HideExitMsgbox()
		arg0:HideResultWindow()
		arg0:HidePauseMsgbox()
		setActive(arg0.gameUI, false)
		pg.BgmMgr.GetInstance():Push(arg0.__cname, FushunAdventureGameConst.BGM_NAME)
	end
end

function var0.IsStarting(arg0)
	return arg0.state == var5
end

function var0.Dispose(arg0)
	if arg0.countdownTimer then
		arg0.countdownTimer:Stop()

		arg0.countdownTimer = nil
	end

	arg0:ExitGame()
	pg.DelegateInfo.Dispose(arg0)

	if arg0.gameUI then
		Destroy(arg0.gameUI)

		arg0.gameUI = nil
	end

	arg0._go = nil
	arg0.btnSprites = nil
	arg0.state = var2

	arg0.fushunLoader:Clear()

	arg0.fushunLoader = nil
	arg0.OnShowResult = nil
	arg0.OnLevelUpdate = nil
end

function var0.AddDebugInput(arg0)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0:OnShowBtnEffect("A", true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0:Action("A")
			arg0:OnShowBtnEffect("A", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
		end

		if Input.GetKeyDown(KeyCode.S) then
			arg0:OnShowBtnEffect("B", true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0:Action("B")
			arg0:OnShowBtnEffect("B", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
		end
	end
end

function var0.RegisterEventListener(arg0)
	local var0 = arg0.btnA:GetComponent("EventTriggerListener")

	var0:AddPointDownFunc(function()
		arg0:OnShowBtnEffect("A", true)
	end)
	var0:AddPointExitFunc(function()
		arg0:OnShowBtnEffect("A", false)
	end)
	var0:AddPointUpFunc(function()
		if arg0.pause then
			return
		end

		arg0:Action("A")
		arg0:OnShowBtnEffect("A", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
	end)

	local var1 = arg0.btnB:GetComponent("EventTriggerListener")

	var1:AddPointDownFunc(function()
		arg0:OnShowBtnEffect("B", true)
	end)
	var1:AddPointExitFunc(function()
		arg0:OnShowBtnEffect("B", false)
	end)
	var1:AddPointUpFunc(function()
		if arg0.pause then
			return
		end

		arg0:Action("B")
		arg0:OnShowBtnEffect("B", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
	end)
	onButton(arg0, arg0.pauseBtn, function()
		arg0:ShowPauseMsgbox()
	end, SFX_PANEL)
	onButton(arg0, arg0.exitBtn, function()
		arg0:ShowExitMsgbox()
	end, SFX_PANEL)
end

function var0.OnShowBtnEffect(arg0, arg1, arg2)
	setActive(arg0["btn" .. arg1 .. "Effect"], arg2)
end

function var0.ShowResultWindow(arg0, arg1)
	setActive(arg0.resultPanel, true)
	onButton(arg0, arg0.resultCloseBtn, function()
		arg0:HideResultWindow()

		if arg1 then
			arg1()
		end
	end, SFX_PANEL)

	arg0.resultHighestScoreTxt.text = arg0.highestScore
	arg0.resultScoreTxt.text = arg0.score

	if arg0.score > arg0.highestScore then
		arg0.highestScore = arg0.score
	end
end

function var0.HideResultWindow(arg0)
	setActive(arg0.resultPanel, false)
end

function var0.ShowPauseMsgbox(arg0)
	arg0:PauseGame()
	setActive(arg0.msgboxPanel, true)
	setActive(arg0.pauseMsgboxWindow, true)
	setActive(arg0.exitMsgboxWindow, false)
	onButton(arg0, arg0.pauseMsgboxWindow:Find("continue_btn"), function()
		arg0:ResumeGame()
		arg0:HidePauseMsgbox()
	end, SFX_PANEL)
end

function var0.HidePauseMsgbox(arg0)
	setActive(arg0.msgboxPanel, false)
	setActive(arg0.pauseMsgboxWindow, false)
end

function var0.ShowExitMsgbox(arg0)
	arg0:PauseGame()
	setActive(arg0.msgboxPanel, true)
	setActive(arg0.pauseMsgboxWindow, false)
	setActive(arg0.exitMsgboxWindow, true)
	onButton(arg0, arg0.exitMsgboxWindow:Find("cancel_btn"), function()
		arg0:ResumeGame()
		arg0:HideExitMsgbox()
	end, SFX_PANEL)
	onButton(arg0, arg0.exitMsgboxWindow:Find("confirm_btn"), function()
		arg0:HideExitMsgbox()

		if arg0.OnShowResult then
			arg0.OnShowResult(arg0.score)
		end

		arg0:ExitGame()
	end, SFX_PANEL)
end

function var0.HideExitMsgbox(arg0)
	setActive(arg0.msgboxPanel, false)
	setActive(arg0.exitMsgboxWindow, false)
end

function var0.IsCollision(arg0, arg1)
	return arg0.enabled and arg1.enabled and arg0.gameObject.activeSelf and arg0.bounds:Intersects(arg1.bounds)
end

function var0.IsNearby(arg0, arg1)
	return arg1.x - arg0.x <= 0
end

function var0.LOG(...)
	if var1 then
		print(...)
	end
end

return var0
