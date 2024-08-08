local var0_0 = class("FushunAdventureGame")
local var1_0 = false
local var2_0 = 0
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3
local var6_0 = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)

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

function var0_0.setRoomTip(arg0_4, arg1_4)
	arg0_4.helpTip = arg1_4
end

function var0_0.Init(arg0_5)
	if arg0_5.state ~= var2_0 then
		return
	end

	arg0_5.state = var4_0

	arg0_5:InitMainUI()

	arg0_5.helpTip = pg.gametip.fushun_adventure_help.tip
end

function var0_0.loadPrefab(arg0_6, arg1_6, arg2_6)
	ResourceMgr.Inst:getAssetAsync(arg1_6, "", function(arg0_7)
		arg2_6(instantiate(arg0_7))
	end, true, true)
end

function var0_0.InitMainUI(arg0_8)
	local var0_8 = arg0_8._go

	onButton(arg0_8, findTF(var0_8, "btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_8.helpTip
		})
	end, SFX_PANEL)
	onButton(arg0_8, findTF(var0_8, "btn_start"), function()
		pg.BgmMgr.GetInstance():StopPlay()
		arg0_8:StartGame()
	end, SFX_PANEL)

	arg0_8.levelList = UIItemList.New(findTF(var0_8, "levels/scrollrect/content"), findTF(var0_8, "levels/scrollrect/content/level"))
	arg0_8.arrUp = findTF(var0_8, "levels/arr_up")
	arg0_8.arrDown = findTF(var0_8, "levels/arr_bottom")

	onScroll(arg0_8, findTF(var0_8, "levels/scrollrect"), function(arg0_11)
		setActive(arg0_8.arrUp, arg0_11.y < 1)
		setActive(arg0_8.arrDown, arg0_11.y > 0)
	end)
	arg0_8:RefreshLevels()
end

function var0_0.RefreshLevels(arg0_12)
	local var0_12

	arg0_12.levelList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg2_13:Find("Text"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/FushunAdventureGame_atlas", "level_" .. arg1_13 + 1)

			local var0_13 = arg0_12.gameData.count > 0 and 1 or 0
			local var1_13 = arg1_13 >= arg0_12.gameData.usedtime + var0_13

			setActive(arg2_13:Find("lock"), var1_13)

			local var2_13 = arg1_13 < arg0_12.gameData.usedtime

			setActive(arg2_13:Find("cleared"), var2_13)
			setActive(arg2_13:Find("Text"), not var1_13)

			if not var2_13 and not var0_12 then
				var0_12 = arg1_13
			end

			arg2_13:GetComponent(typeof(Image)).enabled = not var1_13
		end
	end)
	arg0_12.levelList:align(FushunAdventureGameConst.LEVEL_CNT)
	setActive(findTF(arg0_12._go, "tip/got"), arg0_12.gameData.ultimate ~= 0)

	if var0_12 then
		local var1_12 = var0_12 * (arg0_12.levelList.item.rect.height + 50)
		local var2_12 = arg0_12.levelList.container.anchoredPosition

		setAnchoredPosition(arg0_12.levelList.container, {
			y = var2_12.y + var1_12
		})
	end

	if arg0_12.OnLevelUpdate then
		arg0_12.OnLevelUpdate()
	end
end

function var0_0.InitGameUI(arg0_14)
	local var0_14 = arg0_14.gameUI

	arg0_14.btnA = findTF(var0_14, "UI/A")
	arg0_14.btnB = findTF(var0_14, "UI/B")
	arg0_14.btnAEffect = arg0_14.btnA:Find("effect")
	arg0_14.btnBEffect = arg0_14.btnB:Find("effect")
	arg0_14.btnAExEffect = arg0_14.btnA:Find("effect_ex")
	arg0_14.btnBExEffect = arg0_14.btnB:Find("effect_ex")
	arg0_14.keys = {
		findTF(var0_14, "UI/keys/1"):GetComponent(typeof(Image)),
		findTF(var0_14, "UI/keys/2"):GetComponent(typeof(Image)),
		findTF(var0_14, "UI/keys/3"):GetComponent(typeof(Image))
	}
	arg0_14.btnSprites = {
		arg0_14.keys[1].sprite,
		arg0_14.btnA:GetComponent(typeof(Image)).sprite,
		arg0_14.btnB:GetComponent(typeof(Image)).sprite
	}
	arg0_14.hearts = {
		findTF(var0_14, "UI/heart_score/hearts/1/mark"),
		findTF(var0_14, "UI/heart_score/hearts/2/mark"),
		findTF(var0_14, "UI/heart_score/hearts/3/mark")
	}
	arg0_14.numbers = {
		findTF(var0_14, "UI/countdown_panel/timer/3"),
		findTF(var0_14, "UI/countdown_panel/timer/2"),
		findTF(var0_14, "UI/countdown_panel/timer/1")
	}
	arg0_14.scoreTxt = findTF(var0_14, "UI/heart_score/score/Text"):GetComponent(typeof(Text))
	arg0_14.energyBar = findTF(var0_14, "UI/ex/bar"):GetComponent(typeof(Image))
	arg0_14.energyIcon = findTF(var0_14, "UI/ex/icon")
	arg0_14.energyLight = findTF(var0_14, "UI/ex/light")
	arg0_14.exTipPanel = findTF(var0_14, "UI/ex_tip_panel")
	arg0_14.comboTxt = findTF(var0_14, "UI/combo/Text"):GetComponent(typeof(Text))
	arg0_14.countdownPanel = findTF(var0_14, "UI/countdown_panel")
	arg0_14.resultPanel = findTF(var0_14, "UI/result_panel")
	arg0_14.resultCloseBtn = findTF(arg0_14.resultPanel, "frame/close")
	arg0_14.resultHighestScoreTxt = findTF(arg0_14.resultPanel, "frame/highest/Text"):GetComponent(typeof(Text))
	arg0_14.resultScoreTxt = findTF(arg0_14.resultPanel, "frame/score/Text"):GetComponent(typeof(Text))
	arg0_14.msgboxPanel = findTF(var0_14, "UI/msg_panel")
	arg0_14.exitMsgboxWindow = findTF(arg0_14.msgboxPanel, "frame/exit_mode")
	arg0_14.pauseMsgboxWindow = findTF(arg0_14.msgboxPanel, "frame/pause_mode")
	arg0_14.helpWindow = findTF(var0_14, "UI/help")
	arg0_14.lightTF = findTF(var0_14, "game/range")
	arg0_14.lightMark = arg0_14.lightTF:Find("Image")
	arg0_14.pauseBtn = findTF(var0_14, "UI/pause")
	arg0_14.exitBtn = findTF(var0_14, "UI/back")
	arg0_14.energyBar.fillAmount = 0
end

function var0_0.EnterAnimation(arg0_15, arg1_15)
	setActive(arg0_15.countdownPanel, true)

	local function var0_15(arg0_16)
		for iter0_16, iter1_16 in ipairs(arg0_15.numbers) do
			setActive(iter1_16, iter0_16 == arg0_16)
		end
	end

	local var1_15 = 1

	arg0_15.countdownTimer = Timer.New(function()
		var1_15 = var1_15 + 1

		if var1_15 > 3 then
			setActive(arg0_15.countdownPanel, false)
			arg1_15()
		else
			var0_15(var1_15)
		end
	end, 1, 3)

	var0_15(var1_15)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.COUNT_DOWN_VOICE)
	arg0_15.countdownTimer:Start()
end

function var0_0.ShowHelpWindow(arg0_18, arg1_18)
	setActive(arg0_18.helpWindow, true)
	onButton(arg0_18, arg0_18.helpWindow, function()
		setActive(arg0_18.helpWindow, false)
		PlayerPrefs.SetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 1)
		arg1_18()
	end, SFX_PANEL)
end

function var0_0.DisplayKey(arg0_20)
	local function var0_20(arg0_21, arg1_21)
		local var0_21

		if not arg1_21 or arg1_21 == "" then
			var0_21 = arg0_20.btnSprites[1]
		elseif arg1_21 == "A" then
			var0_21 = arg0_20.btnSprites[2]
		elseif arg1_21 == "B" then
			var0_21 = arg0_20.btnSprites[3]
		end

		if arg0_21.sprite ~= var0_21 then
			arg0_21.sprite = var0_21
		end
	end

	for iter0_20, iter1_20 in ipairs(arg0_20.keys) do
		local var1_20 = string.sub(arg0_20.key, iter0_20, iter0_20) or ""

		var0_20(iter1_20, var1_20)
	end
end

function var0_0.DisplayeHearts(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.hearts) do
		setActive(iter1_22, iter0_22 <= arg1_22)
	end
end

function var0_0.DisplayScore(arg0_23)
	arg0_23.scoreTxt.text = arg0_23.score
end

function var0_0.DisplayeEnergy(arg0_24, arg1_24, arg2_24)
	local var0_24 = math.min(1, arg1_24 / arg2_24)

	arg0_24.energyBar.fillAmount = var0_24

	local var1_24 = arg0_24.energyIcon.parent.rect.width * var0_24
	local var2_24 = var1_24 - arg0_24.energyIcon.rect.width

	setAnchoredPosition(arg0_24.energyIcon, {
		x = math.max(0, var2_24)
	})

	local var3_24 = 0

	if var0_24 >= 1 then
		var3_24 = tf(arg0_24.energyBar.gameObject).rect.width
	elseif var1_24 > 0 then
		var3_24 = var1_24
	end

	setActive(arg0_24.energyLight, var0_24 >= 0.01)

	arg0_24.energyLight.sizeDelta = Vector2(var3_24, arg0_24.energyLight.sizeDelta.y)
end

function var0_0.SetGameStateCallback(arg0_25, arg1_25, arg2_25)
	arg0_25._startCallback = arg1_25
	arg0_25._endCallback = arg2_25
end

function var0_0.StartGame(arg0_26)
	if arg0_26.state ~= var4_0 then
		return
	end

	if arg0_26._startCallback then
		arg0_26._startCallback()
	end

	arg0_26.enemys = {}
	arg0_26.hitList = {}
	arg0_26.missFlags = {}
	arg0_26.score = 0
	arg0_26.combo = 0
	arg0_26.pause = false
	arg0_26.schedule = FushunSchedule.New()
	arg0_26.specailSchedule = FushunSchedule.New()

	arg0_26:LoadScene(function()
		arg0_26:EnterGame()
		pg.BgmMgr.GetInstance():Push(arg0_26.__cname, FushunAdventureGameConst.GAME_BGM_NAME)
	end)

	arg0_26.state = var5_0
end

function var0_0.LoadScene(arg0_28, arg1_28)
	seriesAsync({
		function(arg0_29)
			if arg0_28.gameUI then
				setActive(arg0_28.gameUI, true)
				arg0_29()
			else
				arg0_28:loadPrefab("ui/FushunAdventureGame", function(arg0_30)
					arg0_28.gameUI = arg0_30

					arg0_30.transform:SetParent(arg0_28._go.transform, false)
					arg0_28:InitGameUI()
					arg0_29()
				end)
			end
		end,
		function(arg0_31)
			arg0_28:DisplayeHearts(3)
			arg0_28:DisplayScore()
			arg0_28:DisplayeEnergy(0, 1)

			if not (PlayerPrefs.GetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 0) > 0) then
				arg0_28:ShowHelpWindow(arg0_31)
			else
				arg0_31()
			end
		end,
		function(arg0_32)
			parallelAsync({
				function(arg0_33)
					arg0_28:EnterAnimation(arg0_33)
				end,
				function(arg0_34)
					arg0_28:loadPrefab("FushunAdventure/fushun", function(arg0_35)
						arg0_28.fushun = FushunChar.New(arg0_35)

						arg0_28.fushun:SetPosition(FushunAdventureGameConst.FUSHUN_INIT_POSITION)
						arg0_35.transform:SetParent(arg0_28.gameUI.transform:Find("game"), false)
						arg0_34()
					end)
				end
			}, arg0_32)
		end
	}, arg1_28)
end

function var0_0.EnterGame(arg0_36)
	if not arg0_36.handle then
		arg0_36.handle = UpdateBeat:CreateListener(arg0_36.UpdateGame, arg0_36)
	end

	UpdateBeat:AddListener(arg0_36.handle)

	arg0_36.lightTF.sizeDelta = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_RANGE, arg0_36.lightTF.sizeDelta.y)
	arg0_36.lightTF.localPosition = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_DISTANCE + arg0_36.fushun:GetPosition().x, arg0_36.lightTF.localPosition.y)

	arg0_36:SpawnEnemys()
	arg0_36:RegisterEventListener()

	arg0_36.key = ""

	arg0_36.fushun:SetOnAnimEnd(function()
		arg0_36.key = ""

		arg0_36:DisplayKey()
	end)
end

function var0_0.UpdateGame(arg0_38)
	if arg0_38.state == var6_0 then
		arg0_38:ExitGame(true)

		return
	end

	if not arg0_38.pause then
		arg0_38.spawner:Update()
		arg0_38:AddDebugInput()

		if arg0_38.fushun:IsDeath() then
			arg0_38.fushun:Die()

			arg0_38.state = var6_0

			return
		elseif arg0_38.fushun:ShouldInvincible() then
			arg0_38:EnterInvincibleMode()
		elseif arg0_38.fushun:ShouldVincible() then
			arg0_38:ExitInvincibleMode()
		end

		local var0_38 = false

		for iter0_38 = #arg0_38.enemys, 1, -1 do
			local var1_38 = arg0_38.enemys[iter0_38]

			if var1_38:IsFreeze() then
				-- block empty
			elseif arg0_38:CheckEnemyDeath(iter0_38) then
				-- block empty
			else
				var1_38:Move()
				arg0_38:CheckCollision(arg0_38.fushun, var1_38)

				if arg0_38:CheckAttackRange(var1_38) then
					var0_38 = true
				end
			end
		end

		arg0_38:RangeLightDisplay(var0_38)
		arg0_38:DisplayeEnergy(arg0_38.fushun:GetEnergy(), arg0_38.fushun:GetEnergyTarget())
		arg0_38.specailSchedule:Update()
	else
		for iter1_38 = #arg0_38.enemys, 1, -1 do
			arg0_38:CheckEnemyDeath(iter1_38)
		end
	end

	arg0_38.schedule:Update()
end

function var0_0.RangeLightDisplay(arg0_39, arg1_39)
	setActive(arg0_39.lightMark, arg1_39)
end

function var0_0.CheckAttackRange(arg0_40, arg1_40)
	local var0_40 = arg0_40.fushun

	return arg1_40:GetPosition().x <= var0_40:GetAttackPosition().x
end

function var0_0.CheckEnemyDeath(arg0_41, arg1_41)
	local var0_41 = false
	local var1_41 = arg0_41.enemys[arg1_41]

	if var1_41:IsDeath() then
		if arg0_41.hitList[var1_41.index] and not var1_41:IsEscape() then
			arg0_41:AddScore(var1_41:GetScore())
			arg0_41:AddEnergy(var1_41:GetEnergyScore())
		end

		var1_41:Vanish()
		table.remove(arg0_41.enemys, arg1_41)

		var0_41 = true
	end

	return var0_41
end

function var0_0.EnterInvincibleMode(arg0_42)
	local var0_42 = FushunAdventureGameConst.EX_TIP_TIME
	local var1_42 = FushunAdventureGameConst.EX_TIME

	arg0_42.fushun:Invincible()
	setActive(arg0_42.exTipPanel, true)

	arg0_42.pause = true

	blinkAni(arg0_42.energyBar.gameObject, 0.5, -1)
	arg0_42.schedule:AddSchedule(var0_42, 1, function()
		setActive(arg0_42.exTipPanel, false)
		arg0_42.spawner:CarzyMode()

		arg0_42.pause = false

		arg0_42.fushun:StartAction("EX")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.ENTER_EX_VOICE)

		local var0_43 = arg0_42.fushun:GetEnergyTarget() / var1_42

		arg0_42.specailSchedule:AddSchedule(1, var1_42, function()
			arg0_42.fushun:ReduceEnergy(var0_43)
		end)
	end)
	setActive(arg0_42.btnAExEffect, true)
	setActive(arg0_42.btnBExEffect, true)

	arg0_42.key = ""

	arg0_42:DisplayKey()
end

function var0_0.ExitInvincibleMode(arg0_45)
	arg0_45.fushun:Vincible()

	arg0_45.energyBar.color = Color.New(1, 1, 1, 1)

	LeanTween.cancel(arg0_45.energyBar.gameObject)

	for iter0_45, iter1_45 in ipairs(arg0_45.enemys) do
		arg0_45.hitList[iter1_45.index] = nil

		iter1_45:Die()
	end

	arg0_45.spawner:NormalMode()
	setActive(arg0_45.btnAExEffect, false)
	setActive(arg0_45.btnBExEffect, false)
end

function var0_0.CheckCollision(arg0_46, arg1_46, arg2_46)
	if var0_0.IsCollision(arg2_46.effectCollider2D, arg1_46.collider2D) then
		arg1_46:Hurt()
		arg2_46:OnHit()
		arg0_46:DisplayeHearts(arg0_46.fushun:GetHp())
		arg0_46:AddCombo(-arg0_46.combo)
	elseif arg0_46.fushun:InvincibleState() and not arg2_46:IsDeath() and arg2_46:GetPosition().x <= arg1_46:GetAttackPosition().x then
		arg2_46:Hurt(1)

		arg0_46.hitList[arg2_46.index] = true

		arg0_46:AddHitEffect(arg2_46)
	elseif var0_0.IsNearby(arg1_46:GetPosition(), arg2_46:GetAttackPosition()) then
		arg2_46:Attack()
	end
end

function var0_0.AddHitEffect(arg0_47, arg1_47)
	local var0_47 = arg0_47.fushun.effectCollider2D.bounds.center
	local var1_47 = arg0_47.gameUI.transform:InverseTransformPoint(var0_47)
	local var2_47 = arg1_47.collider2D.bounds:GetMin()
	local var3_47 = arg0_47.gameUI.transform:InverseTransformPoint(var2_47)
	local var4_47 = Vector3(var3_47.x, var1_47.y, 0)

	arg0_47:loadPrefab("FushunAdventure/attack_effect", function(arg0_48)
		arg0_48.transform:SetParent(arg0_47.gameUI.transform, false)

		arg0_48.transform.localPosition = var4_47

		local var0_48 = arg0_48:GetComponent(typeof(DftAniEvent))

		var0_48:SetEndEvent(function()
			var0_48:SetEndEvent(nil)

			if arg0_48 then
				Destroy(arg0_48)
			end
		end)
	end)
	arg0_47:ShakeScreen(arg0_47.gameUI)
end

function var0_0.ShakeScreen(arg0_50, arg1_50)
	if LeanTween.isTweening(arg1_50) then
		LeanTween.cancel(arg1_50)
	end

	LeanTween.rotateAroundLocal(arg1_50, Vector3(0, 0, 1), FushunAdventureGameConst.SHAKE_RANGE, FushunAdventureGameConst.SHAKE_TIME):setLoopPingPong(FushunAdventureGameConst.SHAKE_LOOP_CNT):setFrom(-1 * FushunAdventureGameConst.SHAKE_RANGE):setOnComplete(System.Action(function()
		arg1_50.transform.localEulerAngles = Vector3(0, 0, 0)
	end))
end

function var0_0.SpawnEnemys(arg0_52)
	local var0_52 = {
		FushunBeastChar,
		FushunEliteBeastChar,
		FushunEliteBeastChar
	}

	local function var1_52(arg0_53)
		local var0_53 = FushunAdventureGameConst.SPEED_ADDITION
		local var1_53

		for iter0_53, iter1_53 in ipairs(var0_53) do
			local var2_53 = iter1_53[1][1]
			local var3_53 = iter1_53[1][2]

			if var2_53 <= arg0_53 and arg0_53 <= var3_53 then
				var1_53 = iter1_53

				break
			end
		end

		var1_53 = var1_53 or var0_53[#var0_53]

		return var1_53[2]
	end

	local function var2_52(arg0_54)
		local var0_54 = arg0_54.config
		local var1_54 = arg0_54.speed
		local var2_54 = arg0_54.index
		local var3_54 = var0_52[var0_54.id].New(arg0_54.go, var2_54, var0_54)
		local var4_54 = var1_54 + var1_52(arg0_52.score)

		var0_0.LOG("  顺序 :", var2_54, " id :", var0_54.id, " speed :", var4_54)
		var3_54:SetSpeed(var4_54)
		var3_54:SetPosition(FushunAdventureGameConst.ENEMY_SPAWN_POSITION)
		table.insert(arg0_52.enemys, var3_54)
	end

	arg0_52.spawner = FuShunEnemySpawner.New(arg0_52.gameUI.transform:Find("game").transform, var2_52)

	arg0_52.spawner:NormalMode()
end

function var0_0.AddScore(arg0_55, arg1_55)
	arg0_55:AddCombo(1)

	local var0_55 = arg0_55.combo >= FushunAdventureGameConst.COMBO_SCORE_TARGET and FushunAdventureGameConst.COMBO_EXTRA_SCORE or 0

	arg0_55.score = arg0_55.score + arg1_55 + var0_55

	arg0_55:DisplayScore()
	arg0_55.spawner:UpdateScore(arg0_55.score)
end

function var0_0.AddEnergy(arg0_56, arg1_56)
	arg0_56.fushun:AddEnergy(arg1_56)
end

function var0_0.AddCombo(arg0_57, arg1_57)
	if arg1_57 > 0 then
		arg0_57:loadPrefab("UI/fushun_combo", function(arg0_58)
			arg0_58.transform:SetParent(arg0_57.gameUI.transform:Find("UI"), false)

			local var0_58

			var0_58 = Timer.New(function()
				if arg0_58 then
					Destroy(arg0_58)
				end

				if var0_58 then
					var0_58:Stop()

					var0_58 = nil
				end
			end, 1, 1)

			var0_58:Start()
		end)
	end

	arg0_57.combo = arg0_57.combo + arg1_57
	arg0_57.comboTxt.text = arg0_57.combo

	setActive(arg0_57.comboTxt.gameObject.transform.parent, arg0_57.combo > 0)
end

function var0_0.Action(arg0_60, arg1_60)
	if arg0_60.fushun:InvincibleState() then
		arg0_60:AddScore(FushunAdventureGameConst.EX_CLICK_SCORE)
	else
		arg0_60:OnFushunAttack(arg1_60)
	end
end

function var0_0.OnFushunAttack(arg0_61, arg1_61)
	if #arg0_61.key == 3 or arg0_61.fushun:IsMissState() or arg0_61.fushun:IsDamageState() then
		return
	end

	arg0_61.key = arg0_61.key .. arg1_61

	arg0_61:DisplayKey()

	local var0_61 = {}
	local var1_61 = arg0_61.fushun

	for iter0_61, iter1_61 in ipairs(arg0_61.enemys) do
		if not iter1_61:WillDeath() and iter1_61:GetPosition().x <= var1_61:GetAttackPosition().x then
			table.insert(var0_61, iter0_61)
		end
	end

	arg0_61.fushun:TriggerAction(arg0_61.key, function()
		if #var0_61 == 0 then
			arg0_61.fushun:Miss()
		end

		arg0_61.key = ""

		arg0_61:DisplayKey()
	end)

	if #var0_61 > 0 then
		for iter2_61, iter3_61 in ipairs(var0_61) do
			local var2_61 = arg0_61.enemys[iter3_61]

			var2_61:Hurt(1)

			arg0_61.hitList[var2_61.index] = true

			arg0_61:AddHitEffect(var2_61)
		end
	end
end

function var0_0.PauseGame(arg0_63)
	arg0_63.pause = true
end

function var0_0.ResumeGame(arg0_64)
	arg0_64.pause = false
end

function var0_0.ExitGame(arg0_65, arg1_65)
	local function var0_65()
		arg0_65:ClearGameScene()
	end

	if arg0_65.btnA then
		ClearEventTrigger(arg0_65.btnA:GetComponent("EventTriggerListener"))
	end

	if arg0_65.btnB then
		ClearEventTrigger(arg0_65.btnB:GetComponent("EventTriggerListener"))
	end

	if arg0_65.handle then
		UpdateBeat:RemoveListener(arg0_65.handle)

		arg0_65.handle = nil
	end

	if arg0_65.schedule then
		arg0_65.schedule:Dispose()

		arg0_65.schedule = nil
	end

	if arg0_65.specailSchedule then
		arg0_65.specailSchedule:Dispose()

		arg0_65.specailSchedule = nil
	end

	if arg1_65 then
		if arg0_65.OnShowResult then
			arg0_65.OnShowResult(arg0_65.score)
		end

		arg0_65:ShowResultWindow(function()
			var0_65()
		end)
	else
		var0_65()
	end
end

function var0_0.ClearGameScene(arg0_68)
	if arg0_68.fushun then
		arg0_68.fushun:Destory()

		arg0_68.fushun = nil
	end

	if arg0_68.spawner then
		arg0_68.spawner:Dispose()

		arg0_68.spawner = nil
	end

	if arg0_68.enemys then
		for iter0_68, iter1_68 in ipairs(arg0_68.enemys) do
			iter1_68:Dispose()
		end

		arg0_68.enemys = nil
	end

	arg0_68.state = var4_0

	if arg0_68.gameUI then
		arg0_68:HideExitMsgbox()
		arg0_68:HideResultWindow()
		arg0_68:HidePauseMsgbox()
		setActive(arg0_68.gameUI, false)
		pg.BgmMgr.GetInstance():Push(arg0_68.__cname, FushunAdventureGameConst.BGM_NAME)
	end

	if arg0_68._endCallback then
		arg0_68._endCallback()
	end
end

function var0_0.IsStarting(arg0_69)
	return arg0_69.state == var5_0
end

function var0_0.Dispose(arg0_70)
	if arg0_70.countdownTimer then
		arg0_70.countdownTimer:Stop()

		arg0_70.countdownTimer = nil
	end

	arg0_70._startCallback = nil
	arg0_70._endCallback = nil

	arg0_70:ExitGame()
	pg.DelegateInfo.Dispose(arg0_70)

	if arg0_70.gameUI then
		Destroy(arg0_70.gameUI)

		arg0_70.gameUI = nil
	end

	arg0_70._go = nil
	arg0_70.btnSprites = nil
	arg0_70.state = var2_0
	arg0_70.OnShowResult = nil
	arg0_70.OnLevelUpdate = nil
end

function var0_0.AddDebugInput(arg0_71)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_71:OnShowBtnEffect("A", true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_71:Action("A")
			arg0_71:OnShowBtnEffect("A", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
		end

		if Input.GetKeyDown(KeyCode.S) then
			arg0_71:OnShowBtnEffect("B", true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0_71:Action("B")
			arg0_71:OnShowBtnEffect("B", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
		end
	end
end

function var0_0.RegisterEventListener(arg0_72)
	local var0_72 = arg0_72.btnA:GetComponent("EventTriggerListener")

	var0_72:AddPointDownFunc(function()
		arg0_72:OnShowBtnEffect("A", true)
	end)
	var0_72:AddPointExitFunc(function()
		arg0_72:OnShowBtnEffect("A", false)
	end)
	var0_72:AddPointUpFunc(function()
		if arg0_72.pause then
			return
		end

		arg0_72:Action("A")
		arg0_72:OnShowBtnEffect("A", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
	end)

	local var1_72 = arg0_72.btnB:GetComponent("EventTriggerListener")

	var1_72:AddPointDownFunc(function()
		arg0_72:OnShowBtnEffect("B", true)
	end)
	var1_72:AddPointExitFunc(function()
		arg0_72:OnShowBtnEffect("B", false)
	end)
	var1_72:AddPointUpFunc(function()
		if arg0_72.pause then
			return
		end

		arg0_72:Action("B")
		arg0_72:OnShowBtnEffect("B", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
	end)
	onButton(arg0_72, arg0_72.pauseBtn, function()
		arg0_72:ShowPauseMsgbox()
	end, SFX_PANEL)
	onButton(arg0_72, arg0_72.exitBtn, function()
		arg0_72:ShowExitMsgbox()
	end, SFX_PANEL)
end

function var0_0.OnShowBtnEffect(arg0_81, arg1_81, arg2_81)
	setActive(arg0_81["btn" .. arg1_81 .. "Effect"], arg2_81)
end

function var0_0.ShowResultWindow(arg0_82, arg1_82)
	setActive(arg0_82.resultPanel, true)
	onButton(arg0_82, arg0_82.resultCloseBtn, function()
		arg0_82:HideResultWindow()

		if arg1_82 then
			arg1_82()
		end
	end, SFX_PANEL)

	arg0_82.resultHighestScoreTxt.text = arg0_82.highestScore
	arg0_82.resultScoreTxt.text = arg0_82.score

	if arg0_82.score > arg0_82.highestScore then
		arg0_82.highestScore = arg0_82.score
	end
end

function var0_0.HideResultWindow(arg0_84)
	setActive(arg0_84.resultPanel, false)
end

function var0_0.ShowPauseMsgbox(arg0_85)
	arg0_85:PauseGame()
	setActive(arg0_85.msgboxPanel, true)
	setActive(arg0_85.pauseMsgboxWindow, true)
	setActive(arg0_85.exitMsgboxWindow, false)
	onButton(arg0_85, arg0_85.pauseMsgboxWindow:Find("continue_btn"), function()
		arg0_85:ResumeGame()
		arg0_85:HidePauseMsgbox()
	end, SFX_PANEL)
end

function var0_0.HidePauseMsgbox(arg0_87)
	setActive(arg0_87.msgboxPanel, false)
	setActive(arg0_87.pauseMsgboxWindow, false)
end

function var0_0.ShowExitMsgbox(arg0_88)
	arg0_88:PauseGame()
	setActive(arg0_88.msgboxPanel, true)
	setActive(arg0_88.pauseMsgboxWindow, false)
	setActive(arg0_88.exitMsgboxWindow, true)
	onButton(arg0_88, arg0_88.exitMsgboxWindow:Find("cancel_btn"), function()
		arg0_88:ResumeGame()
		arg0_88:HideExitMsgbox()
	end, SFX_PANEL)
	onButton(arg0_88, arg0_88.exitMsgboxWindow:Find("confirm_btn"), function()
		arg0_88:HideExitMsgbox()

		if arg0_88.OnShowResult then
			arg0_88.OnShowResult(arg0_88.score)
		end

		arg0_88:ExitGame()
	end, SFX_PANEL)
end

function var0_0.HideExitMsgbox(arg0_91)
	setActive(arg0_91.msgboxPanel, false)
	setActive(arg0_91.exitMsgboxWindow, false)
end

function var0_0.IsCollision(arg0_92, arg1_92)
	return arg0_92.enabled and arg1_92.enabled and arg0_92.gameObject.activeSelf and arg0_92.bounds:Intersects(arg1_92.bounds)
end

function var0_0.IsNearby(arg0_93, arg1_93)
	return arg1_93.x - arg0_93.x <= 0
end

function var0_0.LOG(...)
	if var1_0 then
		print(...)
	end
end

return var0_0
