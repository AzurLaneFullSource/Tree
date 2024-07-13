local var0_0 = class("FushunAdventureGame")
local var1_0 = false
local var2_0 = 0
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3
local var6_0 = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.fushunLoader = AutoLoader.New()
	arg0_1.state = var2_0
	arg0_1._go = arg1_1
	arg0_1.gameData = arg2_1
	arg0_1.highestScore = (arg3_1:GetRuntimeData("elements") or {})[1] or 0

	arg0_1:Init()
end

function var0_0.SetOnShowResult(arg0_2, arg1_2)
	arg0_2.OnShowResult = arg1_2
end

function var0_0.SetOnLevelUpdate(arg0_3, arg1_3)
	arg0_3.OnLevelUpdate = arg1_3
end

function var0_0.Init(arg0_4)
	if arg0_4.state ~= var2_0 then
		return
	end

	arg0_4.state = var4_0

	arg0_4:InitMainUI()
end

function var0_0.InitMainUI(arg0_5)
	local var0_5 = arg0_5._go

	onButton(arg0_5, findTF(var0_5, "btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fushun_adventure_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, findTF(var0_5, "btn_start"), function()
		pg.BgmMgr.GetInstance():StopPlay()
		arg0_5:StartGame()
	end, SFX_PANEL)

	arg0_5.levelList = UIItemList.New(findTF(var0_5, "levels/scrollrect/content"), findTF(var0_5, "levels/scrollrect/content/level"))
	arg0_5.arrUp = findTF(var0_5, "levels/arr_up")
	arg0_5.arrDown = findTF(var0_5, "levels/arr_bottom")

	onScroll(arg0_5, findTF(var0_5, "levels/scrollrect"), function(arg0_8)
		setActive(arg0_5.arrUp, arg0_8.y < 1)
		setActive(arg0_5.arrDown, arg0_8.y > 0)
	end)
	arg0_5:RefreshLevels()
end

function var0_0.RefreshLevels(arg0_9)
	local var0_9

	arg0_9.levelList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg2_10:Find("Text"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/FushunAdventureGame_atlas", "level_" .. arg1_10 + 1)

			local var0_10 = arg0_9.gameData.count > 0 and 1 or 0
			local var1_10 = arg1_10 >= arg0_9.gameData.usedtime + var0_10

			setActive(arg2_10:Find("lock"), var1_10)

			local var2_10 = arg1_10 < arg0_9.gameData.usedtime

			setActive(arg2_10:Find("cleared"), var2_10)
			setActive(arg2_10:Find("Text"), not var1_10)

			if not var2_10 and not var0_9 then
				var0_9 = arg1_10
			end

			arg2_10:GetComponent(typeof(Image)).enabled = not var1_10
		end
	end)
	arg0_9.levelList:align(FushunAdventureGameConst.LEVEL_CNT)
	setActive(findTF(arg0_9._go, "tip/got"), arg0_9.gameData.ultimate ~= 0)

	if var0_9 then
		local var1_9 = var0_9 * (arg0_9.levelList.item.rect.height + 50)
		local var2_9 = arg0_9.levelList.container.anchoredPosition

		setAnchoredPosition(arg0_9.levelList.container, {
			y = var2_9.y + var1_9
		})
	end

	if arg0_9.OnLevelUpdate then
		arg0_9.OnLevelUpdate()
	end
end

function var0_0.InitGameUI(arg0_11)
	local var0_11 = arg0_11.gameUI

	arg0_11.btnA = findTF(var0_11, "UI/A")
	arg0_11.btnB = findTF(var0_11, "UI/B")
	arg0_11.btnAEffect = arg0_11.btnA:Find("effect")
	arg0_11.btnBEffect = arg0_11.btnB:Find("effect")
	arg0_11.btnAExEffect = arg0_11.btnA:Find("effect_ex")
	arg0_11.btnBExEffect = arg0_11.btnB:Find("effect_ex")
	arg0_11.keys = {
		findTF(var0_11, "UI/keys/1"):GetComponent(typeof(Image)),
		findTF(var0_11, "UI/keys/2"):GetComponent(typeof(Image)),
		findTF(var0_11, "UI/keys/3"):GetComponent(typeof(Image))
	}
	arg0_11.btnSprites = {
		arg0_11.keys[1].sprite,
		arg0_11.btnA:GetComponent(typeof(Image)).sprite,
		arg0_11.btnB:GetComponent(typeof(Image)).sprite
	}
	arg0_11.hearts = {
		findTF(var0_11, "UI/heart_score/hearts/1/mark"),
		findTF(var0_11, "UI/heart_score/hearts/2/mark"),
		findTF(var0_11, "UI/heart_score/hearts/3/mark")
	}
	arg0_11.numbers = {
		findTF(var0_11, "UI/countdown_panel/timer/3"),
		findTF(var0_11, "UI/countdown_panel/timer/2"),
		findTF(var0_11, "UI/countdown_panel/timer/1")
	}
	arg0_11.scoreTxt = findTF(var0_11, "UI/heart_score/score/Text"):GetComponent(typeof(Text))
	arg0_11.energyBar = findTF(var0_11, "UI/ex/bar"):GetComponent(typeof(Image))
	arg0_11.energyIcon = findTF(var0_11, "UI/ex/icon")
	arg0_11.energyLight = findTF(var0_11, "UI/ex/light")
	arg0_11.exTipPanel = findTF(var0_11, "UI/ex_tip_panel")
	arg0_11.comboTxt = findTF(var0_11, "UI/combo/Text"):GetComponent(typeof(Text))
	arg0_11.countdownPanel = findTF(var0_11, "UI/countdown_panel")
	arg0_11.resultPanel = findTF(var0_11, "UI/result_panel")
	arg0_11.resultCloseBtn = findTF(arg0_11.resultPanel, "frame/close")
	arg0_11.resultHighestScoreTxt = findTF(arg0_11.resultPanel, "frame/highest/Text"):GetComponent(typeof(Text))
	arg0_11.resultScoreTxt = findTF(arg0_11.resultPanel, "frame/score/Text"):GetComponent(typeof(Text))
	arg0_11.msgboxPanel = findTF(var0_11, "UI/msg_panel")
	arg0_11.exitMsgboxWindow = findTF(arg0_11.msgboxPanel, "frame/exit_mode")
	arg0_11.pauseMsgboxWindow = findTF(arg0_11.msgboxPanel, "frame/pause_mode")
	arg0_11.helpWindow = findTF(var0_11, "UI/help")
	arg0_11.lightTF = findTF(var0_11, "game/range")
	arg0_11.lightMark = arg0_11.lightTF:Find("Image")
	arg0_11.pauseBtn = findTF(var0_11, "UI/pause")
	arg0_11.exitBtn = findTF(var0_11, "UI/back")
	arg0_11.energyBar.fillAmount = 0
end

function var0_0.EnterAnimation(arg0_12, arg1_12)
	setActive(arg0_12.countdownPanel, true)

	local function var0_12(arg0_13)
		for iter0_13, iter1_13 in ipairs(arg0_12.numbers) do
			setActive(iter1_13, iter0_13 == arg0_13)
		end
	end

	local var1_12 = 1

	arg0_12.countdownTimer = Timer.New(function()
		var1_12 = var1_12 + 1

		if var1_12 > 3 then
			setActive(arg0_12.countdownPanel, false)
			arg1_12()
		else
			var0_12(var1_12)
		end
	end, 1, 3)

	var0_12(var1_12)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.COUNT_DOWN_VOICE)
	arg0_12.countdownTimer:Start()
end

function var0_0.ShowHelpWindow(arg0_15, arg1_15)
	setActive(arg0_15.helpWindow, true)
	onButton(arg0_15, arg0_15.helpWindow, function()
		setActive(arg0_15.helpWindow, false)
		PlayerPrefs.SetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 1)
		arg1_15()
	end, SFX_PANEL)
end

function var0_0.DisplayKey(arg0_17)
	local function var0_17(arg0_18, arg1_18)
		local var0_18

		if not arg1_18 or arg1_18 == "" then
			var0_18 = arg0_17.btnSprites[1]
		elseif arg1_18 == "A" then
			var0_18 = arg0_17.btnSprites[2]
		elseif arg1_18 == "B" then
			var0_18 = arg0_17.btnSprites[3]
		end

		if arg0_18.sprite ~= var0_18 then
			arg0_18.sprite = var0_18
		end
	end

	for iter0_17, iter1_17 in ipairs(arg0_17.keys) do
		local var1_17 = string.sub(arg0_17.key, iter0_17, iter0_17) or ""

		var0_17(iter1_17, var1_17)
	end
end

function var0_0.DisplayeHearts(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.hearts) do
		setActive(iter1_19, iter0_19 <= arg1_19)
	end
end

function var0_0.DisplayScore(arg0_20)
	arg0_20.scoreTxt.text = arg0_20.score
end

function var0_0.DisplayeEnergy(arg0_21, arg1_21, arg2_21)
	local var0_21 = math.min(1, arg1_21 / arg2_21)

	arg0_21.energyBar.fillAmount = var0_21

	local var1_21 = arg0_21.energyIcon.parent.rect.width * var0_21
	local var2_21 = var1_21 - arg0_21.energyIcon.rect.width

	setAnchoredPosition(arg0_21.energyIcon, {
		x = math.max(0, var2_21)
	})

	local var3_21 = 0

	if var0_21 >= 1 then
		var3_21 = tf(arg0_21.energyBar.gameObject).rect.width
	elseif var1_21 > 0 then
		var3_21 = var1_21
	end

	setActive(arg0_21.energyLight, var0_21 >= 0.01)

	arg0_21.energyLight.sizeDelta = Vector2(var3_21, arg0_21.energyLight.sizeDelta.y)
end

function var0_0.StartGame(arg0_22)
	if arg0_22.state ~= var4_0 then
		return
	end

	arg0_22.enemys = {}
	arg0_22.hitList = {}
	arg0_22.missFlags = {}
	arg0_22.score = 0
	arg0_22.combo = 0
	arg0_22.pause = false
	arg0_22.schedule = FushunSchedule.New()
	arg0_22.specailSchedule = FushunSchedule.New()

	arg0_22:LoadScene(function()
		arg0_22:EnterGame()
		pg.BgmMgr.GetInstance():Push(arg0_22.__cname, FushunAdventureGameConst.GAME_BGM_NAME)
	end)

	arg0_22.state = var5_0
end

function var0_0.LoadScene(arg0_24, arg1_24)
	seriesAsync({
		function(arg0_25)
			if arg0_24.gameUI then
				setActive(arg0_24.gameUI, true)
				arg0_25()
			else
				arg0_24.fushunLoader:LoadPrefab("ui/FushunAdventureGame", "", function(arg0_26)
					arg0_24.gameUI = arg0_26

					arg0_26.transform:SetParent(arg0_24._go.transform, false)
					arg0_24:InitGameUI()
					arg0_25()
				end, "FushunAdventureGame")
			end
		end,
		function(arg0_27)
			arg0_24:DisplayeHearts(3)
			arg0_24:DisplayScore()
			arg0_24:DisplayeEnergy(0, 1)

			if not (PlayerPrefs.GetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 0) > 0) then
				arg0_24:ShowHelpWindow(arg0_27)
			else
				arg0_27()
			end
		end,
		function(arg0_28)
			parallelAsync({
				function(arg0_29)
					arg0_24:EnterAnimation(arg0_29)
				end,
				function(arg0_30)
					arg0_24.fushunLoader:LoadPrefab("FushunAdventure/fushun", "", function(arg0_31)
						arg0_24.fushun = FushunChar.New(arg0_31)

						arg0_24.fushun:SetPosition(FushunAdventureGameConst.FUSHUN_INIT_POSITION)
						arg0_31.transform:SetParent(arg0_24.gameUI.transform:Find("game"), false)
						arg0_30()
					end, "fushun")
				end
			}, arg0_28)
		end
	}, arg1_24)
end

function var0_0.EnterGame(arg0_32)
	if not arg0_32.handle then
		arg0_32.handle = UpdateBeat:CreateListener(arg0_32.UpdateGame, arg0_32)
	end

	UpdateBeat:AddListener(arg0_32.handle)

	arg0_32.lightTF.sizeDelta = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_RANGE, arg0_32.lightTF.sizeDelta.y)
	arg0_32.lightTF.localPosition = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_DISTANCE + arg0_32.fushun:GetPosition().x, arg0_32.lightTF.localPosition.y)

	arg0_32:SpawnEnemys()
	arg0_32:RegisterEventListener()

	arg0_32.key = ""

	arg0_32.fushun:SetOnAnimEnd(function()
		arg0_32.key = ""

		arg0_32:DisplayKey()
	end)
end

function var0_0.UpdateGame(arg0_34)
	if arg0_34.state == var6_0 then
		arg0_34:ExitGame(true)

		return
	end

	if not arg0_34.pause then
		arg0_34.spawner:Update()
		arg0_34:AddDebugInput()

		if arg0_34.fushun:IsDeath() then
			arg0_34.fushun:Die()

			arg0_34.state = var6_0

			return
		elseif arg0_34.fushun:ShouldInvincible() then
			arg0_34:EnterInvincibleMode()
		elseif arg0_34.fushun:ShouldVincible() then
			arg0_34:ExitInvincibleMode()
		end

		local var0_34 = false

		for iter0_34 = #arg0_34.enemys, 1, -1 do
			local var1_34 = arg0_34.enemys[iter0_34]

			if var1_34:IsFreeze() then
				-- block empty
			elseif arg0_34:CheckEnemyDeath(iter0_34) then
				-- block empty
			else
				var1_34:Move()
				arg0_34:CheckCollision(arg0_34.fushun, var1_34)

				if arg0_34:CheckAttackRange(var1_34) then
					var0_34 = true
				end
			end
		end

		arg0_34:RangeLightDisplay(var0_34)
		arg0_34:DisplayeEnergy(arg0_34.fushun:GetEnergy(), arg0_34.fushun:GetEnergyTarget())
		arg0_34.specailSchedule:Update()
	else
		for iter1_34 = #arg0_34.enemys, 1, -1 do
			arg0_34:CheckEnemyDeath(iter1_34)
		end
	end

	arg0_34.schedule:Update()
end

function var0_0.RangeLightDisplay(arg0_35, arg1_35)
	setActive(arg0_35.lightMark, arg1_35)
end

function var0_0.CheckAttackRange(arg0_36, arg1_36)
	local var0_36 = arg0_36.fushun

	return arg1_36:GetPosition().x <= var0_36:GetAttackPosition().x
end

function var0_0.CheckEnemyDeath(arg0_37, arg1_37)
	local var0_37 = false
	local var1_37 = arg0_37.enemys[arg1_37]

	if var1_37:IsDeath() then
		if arg0_37.hitList[var1_37.index] and not var1_37:IsEscape() then
			arg0_37:AddScore(var1_37:GetScore())
			arg0_37:AddEnergy(var1_37:GetEnergyScore())
		end

		var1_37:Vanish()
		table.remove(arg0_37.enemys, arg1_37)

		var0_37 = true
	end

	return var0_37
end

function var0_0.EnterInvincibleMode(arg0_38)
	local var0_38 = FushunAdventureGameConst.EX_TIP_TIME
	local var1_38 = FushunAdventureGameConst.EX_TIME

	arg0_38.fushun:Invincible()
	setActive(arg0_38.exTipPanel, true)

	arg0_38.pause = true

	blinkAni(arg0_38.energyBar.gameObject, 0.5, -1)
	arg0_38.schedule:AddSchedule(var0_38, 1, function()
		setActive(arg0_38.exTipPanel, false)
		arg0_38.spawner:CarzyMode()

		arg0_38.pause = false

		arg0_38.fushun:StartAction("EX")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.ENTER_EX_VOICE)

		local var0_39 = arg0_38.fushun:GetEnergyTarget() / var1_38

		arg0_38.specailSchedule:AddSchedule(1, var1_38, function()
			arg0_38.fushun:ReduceEnergy(var0_39)
		end)
	end)
	setActive(arg0_38.btnAExEffect, true)
	setActive(arg0_38.btnBExEffect, true)

	arg0_38.key = ""

	arg0_38:DisplayKey()
end

function var0_0.ExitInvincibleMode(arg0_41)
	arg0_41.fushun:Vincible()

	arg0_41.energyBar.color = Color.New(1, 1, 1, 1)

	LeanTween.cancel(arg0_41.energyBar.gameObject)

	for iter0_41, iter1_41 in ipairs(arg0_41.enemys) do
		arg0_41.hitList[iter1_41.index] = nil

		iter1_41:Die()
	end

	arg0_41.spawner:NormalMode()
	setActive(arg0_41.btnAExEffect, false)
	setActive(arg0_41.btnBExEffect, false)
end

function var0_0.CheckCollision(arg0_42, arg1_42, arg2_42)
	if var0_0.IsCollision(arg2_42.effectCollider2D, arg1_42.collider2D) then
		arg1_42:Hurt()
		arg2_42:OnHit()
		arg0_42:DisplayeHearts(arg0_42.fushun:GetHp())
		arg0_42:AddCombo(-arg0_42.combo)
	elseif arg0_42.fushun:InvincibleState() and not arg2_42:IsDeath() and arg2_42:GetPosition().x <= arg1_42:GetAttackPosition().x then
		arg2_42:Hurt(1)

		arg0_42.hitList[arg2_42.index] = true

		arg0_42:AddHitEffect(arg2_42)
	elseif var0_0.IsNearby(arg1_42:GetPosition(), arg2_42:GetAttackPosition()) then
		arg2_42:Attack()
	end
end

function var0_0.AddHitEffect(arg0_43, arg1_43)
	local var0_43 = arg0_43.fushun.effectCollider2D.bounds.center
	local var1_43 = arg0_43.gameUI.transform:InverseTransformPoint(var0_43)
	local var2_43 = arg1_43.collider2D.bounds:GetMin()
	local var3_43 = arg0_43.gameUI.transform:InverseTransformPoint(var2_43)
	local var4_43 = Vector3(var3_43.x, var1_43.y, 0)

	arg0_43.fushunLoader:GetPrefab("FushunAdventure/attack_effect", "", function(arg0_44)
		arg0_44.transform:SetParent(arg0_43.gameUI.transform, false)

		arg0_44.transform.localPosition = var4_43

		local var0_44 = arg0_44:GetComponent(typeof(DftAniEvent))

		var0_44:SetEndEvent(function()
			var0_44:SetEndEvent(nil)
			arg0_43.fushunLoader:ReturnPrefab(arg0_44)
		end)
	end)
	arg0_43:ShakeScreen(arg0_43.gameUI)
end

function var0_0.ShakeScreen(arg0_46, arg1_46)
	if LeanTween.isTweening(arg1_46) then
		LeanTween.cancel(arg1_46)
	end

	LeanTween.rotateAroundLocal(arg1_46, Vector3(0, 0, 1), FushunAdventureGameConst.SHAKE_RANGE, FushunAdventureGameConst.SHAKE_TIME):setLoopPingPong(FushunAdventureGameConst.SHAKE_LOOP_CNT):setFrom(-1 * FushunAdventureGameConst.SHAKE_RANGE):setOnComplete(System.Action(function()
		arg1_46.transform.localEulerAngles = Vector3(0, 0, 0)
	end))
end

function var0_0.SpawnEnemys(arg0_48)
	local var0_48 = {
		FushunBeastChar,
		FushunEliteBeastChar,
		FushunEliteBeastChar
	}

	local function var1_48(arg0_49)
		local var0_49 = FushunAdventureGameConst.SPEED_ADDITION
		local var1_49

		for iter0_49, iter1_49 in ipairs(var0_49) do
			local var2_49 = iter1_49[1][1]
			local var3_49 = iter1_49[1][2]

			if var2_49 <= arg0_49 and arg0_49 <= var3_49 then
				var1_49 = iter1_49

				break
			end
		end

		var1_49 = var1_49 or var0_49[#var0_49]

		return var1_49[2]
	end

	local function var2_48(arg0_50)
		local var0_50 = arg0_50.config
		local var1_50 = arg0_50.speed
		local var2_50 = arg0_50.index
		local var3_50 = var0_48[var0_50.id].New(arg0_50.go, var2_50, var0_50, arg0_48.fushunLoader)
		local var4_50 = var1_50 + var1_48(arg0_48.score)

		var0_0.LOG("  顺序 :", var2_50, " id :", var0_50.id, " speed :", var4_50)
		var3_50:SetSpeed(var4_50)
		var3_50:SetPosition(FushunAdventureGameConst.ENEMY_SPAWN_POSITION)
		table.insert(arg0_48.enemys, var3_50)
	end

	arg0_48.spawner = FuShunEnemySpawner.New(arg0_48.gameUI.transform:Find("game").transform, var2_48, arg0_48.fushunLoader)

	arg0_48.spawner:NormalMode()
end

function var0_0.AddScore(arg0_51, arg1_51)
	arg0_51:AddCombo(1)

	local var0_51 = arg0_51.combo >= FushunAdventureGameConst.COMBO_SCORE_TARGET and FushunAdventureGameConst.COMBO_EXTRA_SCORE or 0

	arg0_51.score = arg0_51.score + arg1_51 + var0_51

	arg0_51:DisplayScore()
	arg0_51.spawner:UpdateScore(arg0_51.score)
end

function var0_0.AddEnergy(arg0_52, arg1_52)
	arg0_52.fushun:AddEnergy(arg1_52)
end

function var0_0.AddCombo(arg0_53, arg1_53)
	if arg1_53 > 0 then
		arg0_53.fushunLoader:GetPrefab("UI/fushun_combo", "", function(arg0_54)
			if not arg0_53.fushunLoader then
				Destroy(arg0_54)

				return
			end

			arg0_54.transform:SetParent(arg0_53.gameUI.transform:Find("UI"), false)
			Timer.New(function()
				if not arg0_53.fushunLoader then
					return
				end

				arg0_53.fushunLoader:ReturnPrefab(arg0_54)
			end, 2, 1):Start()
		end)
	end

	arg0_53.combo = arg0_53.combo + arg1_53
	arg0_53.comboTxt.text = arg0_53.combo

	setActive(arg0_53.comboTxt.gameObject.transform.parent, arg0_53.combo > 0)
end

function var0_0.Action(arg0_56, arg1_56)
	if arg0_56.fushun:InvincibleState() then
		arg0_56:AddScore(FushunAdventureGameConst.EX_CLICK_SCORE)
	else
		arg0_56:OnFushunAttack(arg1_56)
	end
end

function var0_0.OnFushunAttack(arg0_57, arg1_57)
	if #arg0_57.key == 3 or arg0_57.fushun:IsMissState() or arg0_57.fushun:IsDamageState() then
		return
	end

	arg0_57.key = arg0_57.key .. arg1_57

	arg0_57:DisplayKey()

	local var0_57 = {}
	local var1_57 = arg0_57.fushun

	for iter0_57, iter1_57 in ipairs(arg0_57.enemys) do
		if not iter1_57:WillDeath() and iter1_57:GetPosition().x <= var1_57:GetAttackPosition().x then
			table.insert(var0_57, iter0_57)
		end
	end

	arg0_57.fushun:TriggerAction(arg0_57.key, function()
		if #var0_57 == 0 then
			arg0_57.fushun:Miss()
		end

		arg0_57.key = ""

		arg0_57:DisplayKey()
	end)

	if #var0_57 > 0 then
		for iter2_57, iter3_57 in ipairs(var0_57) do
			local var2_57 = arg0_57.enemys[iter3_57]

			var2_57:Hurt(1)

			arg0_57.hitList[var2_57.index] = true

			arg0_57:AddHitEffect(var2_57)
		end
	end
end

function var0_0.PauseGame(arg0_59)
	arg0_59.pause = true
end

function var0_0.ResumeGame(arg0_60)
	arg0_60.pause = false
end

function var0_0.ExitGame(arg0_61, arg1_61)
	local function var0_61()
		arg0_61:ClearGameScene()
	end

	if arg0_61.btnA then
		ClearEventTrigger(arg0_61.btnA:GetComponent("EventTriggerListener"))
	end

	if arg0_61.btnB then
		ClearEventTrigger(arg0_61.btnB:GetComponent("EventTriggerListener"))
	end

	if arg0_61.handle then
		UpdateBeat:RemoveListener(arg0_61.handle)

		arg0_61.handle = nil
	end

	if arg0_61.schedule then
		arg0_61.schedule:Dispose()

		arg0_61.schedule = nil
	end

	if arg0_61.specailSchedule then
		arg0_61.specailSchedule:Dispose()

		arg0_61.specailSchedule = nil
	end

	if arg1_61 then
		if arg0_61.OnShowResult then
			arg0_61.OnShowResult(arg0_61.score)
		end

		arg0_61:ShowResultWindow(function()
			var0_61()
		end)
	else
		var0_61()
	end
end

function var0_0.ClearGameScene(arg0_64)
	if arg0_64.fushun then
		arg0_64.fushun:Destory()

		arg0_64.fushun = nil
	end

	if arg0_64.spawner then
		arg0_64.spawner:Dispose()

		arg0_64.spawner = nil
	end

	if arg0_64.enemys then
		for iter0_64, iter1_64 in ipairs(arg0_64.enemys) do
			iter1_64:Dispose()
		end

		arg0_64.enemys = nil
	end

	arg0_64.state = var4_0

	if arg0_64.gameUI then
		arg0_64:HideExitMsgbox()
		arg0_64:HideResultWindow()
		arg0_64:HidePauseMsgbox()
		setActive(arg0_64.gameUI, false)
		pg.BgmMgr.GetInstance():Push(arg0_64.__cname, FushunAdventureGameConst.BGM_NAME)
	end
end

function var0_0.IsStarting(arg0_65)
	return arg0_65.state == var5_0
end

function var0_0.Dispose(arg0_66)
	if arg0_66.countdownTimer then
		arg0_66.countdownTimer:Stop()

		arg0_66.countdownTimer = nil
	end

	arg0_66:ExitGame()
	pg.DelegateInfo.Dispose(arg0_66)

	if arg0_66.gameUI then
		Destroy(arg0_66.gameUI)

		arg0_66.gameUI = nil
	end

	arg0_66._go = nil
	arg0_66.btnSprites = nil
	arg0_66.state = var2_0

	arg0_66.fushunLoader:Clear()

	arg0_66.fushunLoader = nil
	arg0_66.OnShowResult = nil
	arg0_66.OnLevelUpdate = nil
end

function var0_0.AddDebugInput(arg0_67)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_67:OnShowBtnEffect("A", true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_67:Action("A")
			arg0_67:OnShowBtnEffect("A", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
		end

		if Input.GetKeyDown(KeyCode.S) then
			arg0_67:OnShowBtnEffect("B", true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0_67:Action("B")
			arg0_67:OnShowBtnEffect("B", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
		end
	end
end

function var0_0.RegisterEventListener(arg0_68)
	local var0_68 = arg0_68.btnA:GetComponent("EventTriggerListener")

	var0_68:AddPointDownFunc(function()
		arg0_68:OnShowBtnEffect("A", true)
	end)
	var0_68:AddPointExitFunc(function()
		arg0_68:OnShowBtnEffect("A", false)
	end)
	var0_68:AddPointUpFunc(function()
		if arg0_68.pause then
			return
		end

		arg0_68:Action("A")
		arg0_68:OnShowBtnEffect("A", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
	end)

	local var1_68 = arg0_68.btnB:GetComponent("EventTriggerListener")

	var1_68:AddPointDownFunc(function()
		arg0_68:OnShowBtnEffect("B", true)
	end)
	var1_68:AddPointExitFunc(function()
		arg0_68:OnShowBtnEffect("B", false)
	end)
	var1_68:AddPointUpFunc(function()
		if arg0_68.pause then
			return
		end

		arg0_68:Action("B")
		arg0_68:OnShowBtnEffect("B", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
	end)
	onButton(arg0_68, arg0_68.pauseBtn, function()
		arg0_68:ShowPauseMsgbox()
	end, SFX_PANEL)
	onButton(arg0_68, arg0_68.exitBtn, function()
		arg0_68:ShowExitMsgbox()
	end, SFX_PANEL)
end

function var0_0.OnShowBtnEffect(arg0_77, arg1_77, arg2_77)
	setActive(arg0_77["btn" .. arg1_77 .. "Effect"], arg2_77)
end

function var0_0.ShowResultWindow(arg0_78, arg1_78)
	setActive(arg0_78.resultPanel, true)
	onButton(arg0_78, arg0_78.resultCloseBtn, function()
		arg0_78:HideResultWindow()

		if arg1_78 then
			arg1_78()
		end
	end, SFX_PANEL)

	arg0_78.resultHighestScoreTxt.text = arg0_78.highestScore
	arg0_78.resultScoreTxt.text = arg0_78.score

	if arg0_78.score > arg0_78.highestScore then
		arg0_78.highestScore = arg0_78.score
	end
end

function var0_0.HideResultWindow(arg0_80)
	setActive(arg0_80.resultPanel, false)
end

function var0_0.ShowPauseMsgbox(arg0_81)
	arg0_81:PauseGame()
	setActive(arg0_81.msgboxPanel, true)
	setActive(arg0_81.pauseMsgboxWindow, true)
	setActive(arg0_81.exitMsgboxWindow, false)
	onButton(arg0_81, arg0_81.pauseMsgboxWindow:Find("continue_btn"), function()
		arg0_81:ResumeGame()
		arg0_81:HidePauseMsgbox()
	end, SFX_PANEL)
end

function var0_0.HidePauseMsgbox(arg0_83)
	setActive(arg0_83.msgboxPanel, false)
	setActive(arg0_83.pauseMsgboxWindow, false)
end

function var0_0.ShowExitMsgbox(arg0_84)
	arg0_84:PauseGame()
	setActive(arg0_84.msgboxPanel, true)
	setActive(arg0_84.pauseMsgboxWindow, false)
	setActive(arg0_84.exitMsgboxWindow, true)
	onButton(arg0_84, arg0_84.exitMsgboxWindow:Find("cancel_btn"), function()
		arg0_84:ResumeGame()
		arg0_84:HideExitMsgbox()
	end, SFX_PANEL)
	onButton(arg0_84, arg0_84.exitMsgboxWindow:Find("confirm_btn"), function()
		arg0_84:HideExitMsgbox()

		if arg0_84.OnShowResult then
			arg0_84.OnShowResult(arg0_84.score)
		end

		arg0_84:ExitGame()
	end, SFX_PANEL)
end

function var0_0.HideExitMsgbox(arg0_87)
	setActive(arg0_87.msgboxPanel, false)
	setActive(arg0_87.exitMsgboxWindow, false)
end

function var0_0.IsCollision(arg0_88, arg1_88)
	return arg0_88.enabled and arg1_88.enabled and arg0_88.gameObject.activeSelf and arg0_88.bounds:Intersects(arg1_88.bounds)
end

function var0_0.IsNearby(arg0_89, arg1_89)
	return arg1_89.x - arg0_89.x <= 0
end

function var0_0.LOG(...)
	if var1_0 then
		print(...)
	end
end

return var0_0
