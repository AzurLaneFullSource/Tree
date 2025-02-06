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

function var0_0.setRoomId(arg0_5, arg1_5)
	arg0_5.roomId = arg1_5
end

function var0_0.Init(arg0_6)
	if arg0_6.state ~= var2_0 then
		return
	end

	arg0_6.state = var4_0

	arg0_6:InitMainUI()

	arg0_6.helpTip = pg.gametip.fushun_adventure_help.tip
end

function var0_0.loadPrefab(arg0_7, arg1_7, arg2_7)
	ResourceMgr.Inst:getAssetAsync(arg1_7, "", function(arg0_8)
		arg2_7(instantiate(arg0_8))
	end, true, true)
end

function var0_0.InitMainUI(arg0_9)
	local var0_9 = arg0_9._go

	onButton(arg0_9, findTF(var0_9, "btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_9.helpTip
		})
	end, SFX_PANEL)
	onButton(arg0_9, findTF(var0_9, "btn_start"), function()
		pg.BgmMgr.GetInstance():StopPlay()
		arg0_9:StartGame()
	end, SFX_PANEL)

	arg0_9.levelList = UIItemList.New(findTF(var0_9, "levels/scrollrect/content"), findTF(var0_9, "levels/scrollrect/content/level"))
	arg0_9.arrUp = findTF(var0_9, "levels/arr_up")
	arg0_9.arrDown = findTF(var0_9, "levels/arr_bottom")

	onScroll(arg0_9, findTF(var0_9, "levels/scrollrect"), function(arg0_12)
		setActive(arg0_9.arrUp, arg0_12.y < 1)
		setActive(arg0_9.arrDown, arg0_12.y > 0)
	end)
	arg0_9:RefreshLevels()
end

function var0_0.RefreshLevels(arg0_13)
	local var0_13

	arg0_13.levelList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			arg2_14:Find("Text"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/minigameui/FushunAdventureGame_atlas", "level_" .. arg1_14 + 1)

			local var0_14 = arg0_13.gameData.count > 0 and 1 or 0
			local var1_14 = arg1_14 >= arg0_13.gameData.usedtime + var0_14

			setActive(arg2_14:Find("lock"), var1_14)

			local var2_14 = arg1_14 < arg0_13.gameData.usedtime

			setActive(arg2_14:Find("cleared"), var2_14)
			setActive(arg2_14:Find("Text"), not var1_14)

			if not var2_14 and not var0_13 then
				var0_13 = arg1_14
			end

			arg2_14:GetComponent(typeof(Image)).enabled = not var1_14
		end
	end)
	arg0_13.levelList:align(FushunAdventureGameConst.LEVEL_CNT)
	setActive(findTF(arg0_13._go, "tip/got"), arg0_13.gameData.ultimate ~= 0)

	if var0_13 then
		local var1_13 = var0_13 * (arg0_13.levelList.item.rect.height + 50)
		local var2_13 = arg0_13.levelList.container.anchoredPosition

		setAnchoredPosition(arg0_13.levelList.container, {
			y = var2_13.y + var1_13
		})
	end

	if arg0_13.OnLevelUpdate then
		arg0_13.OnLevelUpdate()
	end
end

function var0_0.InitGameUI(arg0_15)
	local var0_15 = arg0_15.gameUI

	arg0_15.btnA = findTF(var0_15, "UI/A")
	arg0_15.btnB = findTF(var0_15, "UI/B")
	arg0_15.btnAEffect = arg0_15.btnA:Find("effect")
	arg0_15.btnBEffect = arg0_15.btnB:Find("effect")
	arg0_15.btnAExEffect = arg0_15.btnA:Find("effect_ex")
	arg0_15.btnBExEffect = arg0_15.btnB:Find("effect_ex")
	arg0_15.keys = {
		findTF(var0_15, "UI/keys/1"):GetComponent(typeof(Image)),
		findTF(var0_15, "UI/keys/2"):GetComponent(typeof(Image)),
		findTF(var0_15, "UI/keys/3"):GetComponent(typeof(Image))
	}
	arg0_15.btnSprites = {
		arg0_15.keys[1].sprite,
		arg0_15.btnA:GetComponent(typeof(Image)).sprite,
		arg0_15.btnB:GetComponent(typeof(Image)).sprite
	}
	arg0_15.hearts = {
		findTF(var0_15, "UI/heart_score/hearts/1/mark"),
		findTF(var0_15, "UI/heart_score/hearts/2/mark"),
		findTF(var0_15, "UI/heart_score/hearts/3/mark")
	}
	arg0_15.numbers = {
		findTF(var0_15, "UI/countdown_panel/timer/3"),
		findTF(var0_15, "UI/countdown_panel/timer/2"),
		findTF(var0_15, "UI/countdown_panel/timer/1")
	}
	arg0_15.scoreTxt = findTF(var0_15, "UI/heart_score/score/Text"):GetComponent(typeof(Text))
	arg0_15.energyBar = findTF(var0_15, "UI/ex/bar"):GetComponent(typeof(Image))
	arg0_15.energyIcon = findTF(var0_15, "UI/ex/icon")
	arg0_15.energyLight = findTF(var0_15, "UI/ex/light")
	arg0_15.exTipPanel = findTF(var0_15, "UI/ex_tip_panel")
	arg0_15.comboTxt = findTF(var0_15, "UI/combo/Text"):GetComponent(typeof(Text))
	arg0_15.countdownPanel = findTF(var0_15, "UI/countdown_panel")
	arg0_15.resultPanel = findTF(var0_15, "UI/result_panel")
	arg0_15.resultCloseBtn = findTF(arg0_15.resultPanel, "frame/close")
	arg0_15.resultHighestScoreTxt = findTF(arg0_15.resultPanel, "frame/highest/Text"):GetComponent(typeof(Text))
	arg0_15.resultScoreTxt = findTF(arg0_15.resultPanel, "frame/score/Text"):GetComponent(typeof(Text))
	arg0_15.msgboxPanel = findTF(var0_15, "UI/msg_panel")
	arg0_15.exitMsgboxWindow = findTF(arg0_15.msgboxPanel, "frame/exit_mode")
	arg0_15.pauseMsgboxWindow = findTF(arg0_15.msgboxPanel, "frame/pause_mode")
	arg0_15.helpWindow = findTF(var0_15, "UI/help")
	arg0_15.lightTF = findTF(var0_15, "game/range")
	arg0_15.lightMark = arg0_15.lightTF:Find("Image")
	arg0_15.pauseBtn = findTF(var0_15, "UI/pause")
	arg0_15.exitBtn = findTF(var0_15, "UI/back")
	arg0_15.energyBar.fillAmount = 0
end

function var0_0.EnterAnimation(arg0_16, arg1_16)
	setActive(arg0_16.countdownPanel, true)

	local function var0_16(arg0_17)
		for iter0_17, iter1_17 in ipairs(arg0_16.numbers) do
			setActive(iter1_17, iter0_17 == arg0_17)
		end
	end

	local var1_16 = 1

	arg0_16.countdownTimer = Timer.New(function()
		var1_16 = var1_16 + 1

		if var1_16 > 3 then
			setActive(arg0_16.countdownPanel, false)
			arg1_16()
		else
			var0_16(var1_16)
		end
	end, 1, 3)

	var0_16(var1_16)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.COUNT_DOWN_VOICE)
	arg0_16.countdownTimer:Start()
end

function var0_0.ShowHelpWindow(arg0_19, arg1_19)
	setActive(arg0_19.helpWindow, true)
	onButton(arg0_19, arg0_19.helpWindow, function()
		setActive(arg0_19.helpWindow, false)
		PlayerPrefs.SetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 1)
		arg1_19()
	end, SFX_PANEL)
end

function var0_0.DisplayKey(arg0_21)
	local function var0_21(arg0_22, arg1_22)
		local var0_22

		if not arg1_22 or arg1_22 == "" then
			var0_22 = arg0_21.btnSprites[1]
		elseif arg1_22 == "A" then
			var0_22 = arg0_21.btnSprites[2]
		elseif arg1_22 == "B" then
			var0_22 = arg0_21.btnSprites[3]
		end

		if arg0_22.sprite ~= var0_22 then
			arg0_22.sprite = var0_22
		end
	end

	for iter0_21, iter1_21 in ipairs(arg0_21.keys) do
		local var1_21 = string.sub(arg0_21.key, iter0_21, iter0_21) or ""

		var0_21(iter1_21, var1_21)
	end
end

function var0_0.DisplayeHearts(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.hearts) do
		setActive(iter1_23, iter0_23 <= arg1_23)
	end
end

function var0_0.DisplayScore(arg0_24)
	arg0_24.scoreTxt.text = arg0_24.score
end

function var0_0.DisplayeEnergy(arg0_25, arg1_25, arg2_25)
	local var0_25 = math.min(1, arg1_25 / arg2_25)

	arg0_25.energyBar.fillAmount = var0_25

	local var1_25 = arg0_25.energyIcon.parent.rect.width * var0_25
	local var2_25 = var1_25 - arg0_25.energyIcon.rect.width

	setAnchoredPosition(arg0_25.energyIcon, {
		x = math.max(0, var2_25)
	})

	local var3_25 = 0

	if var0_25 >= 1 then
		var3_25 = tf(arg0_25.energyBar.gameObject).rect.width
	elseif var1_25 > 0 then
		var3_25 = var1_25
	end

	setActive(arg0_25.energyLight, var0_25 >= 0.01)

	arg0_25.energyLight.sizeDelta = Vector2(var3_25, arg0_25.energyLight.sizeDelta.y)
end

function var0_0.SetGameStateCallback(arg0_26, arg1_26, arg2_26)
	arg0_26._startCallback = arg1_26
	arg0_26._endCallback = arg2_26
end

function var0_0.StartGame(arg0_27)
	if arg0_27.state ~= var4_0 then
		return
	end

	if arg0_27._startCallback then
		arg0_27._startCallback()
	end

	arg0_27.enemys = {}
	arg0_27.hitList = {}
	arg0_27.missFlags = {}
	arg0_27.score = 0
	arg0_27.combo = 0
	arg0_27.pause = false
	arg0_27.schedule = FushunSchedule.New()
	arg0_27.specailSchedule = FushunSchedule.New()

	arg0_27:LoadScene(function()
		arg0_27:EnterGame()
		pg.BgmMgr.GetInstance():Push(arg0_27.__cname, FushunAdventureGameConst.GAME_BGM_NAME)
	end)

	arg0_27.state = var5_0
end

function var0_0.LoadScene(arg0_29, arg1_29)
	seriesAsync({
		function(arg0_30)
			if arg0_29.gameUI then
				setActive(arg0_29.gameUI, true)
				arg0_30()
			else
				arg0_29:loadPrefab("ui/FushunAdventureGame", function(arg0_31)
					arg0_29.gameUI = arg0_31

					arg0_31.transform:SetParent(arg0_29._go.transform, false)
					arg0_29:InitGameUI()
					arg0_30()
				end)
			end
		end,
		function(arg0_32)
			arg0_29:DisplayeHearts(3)
			arg0_29:DisplayScore()
			arg0_29:DisplayeEnergy(0, 1)

			if not (PlayerPrefs.GetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 0) > 0) then
				arg0_29:ShowHelpWindow(arg0_32)
			else
				arg0_32()
			end
		end,
		function(arg0_33)
			parallelAsync({
				function(arg0_34)
					arg0_29:EnterAnimation(arg0_34)
				end,
				function(arg0_35)
					arg0_29:loadPrefab("ui/fa_fushun", function(arg0_36)
						arg0_29.fushun = FushunChar.New(arg0_36)

						arg0_29.fushun:SetPosition(FushunAdventureGameConst.FUSHUN_INIT_POSITION)
						arg0_36.transform:SetParent(arg0_29.gameUI.transform:Find("game"), false)
						arg0_35()
					end)
				end
			}, arg0_33)
		end
	}, arg1_29)
end

function var0_0.EnterGame(arg0_37)
	if not arg0_37.handle then
		arg0_37.handle = UpdateBeat:CreateListener(arg0_37.UpdateGame, arg0_37)
	end

	UpdateBeat:AddListener(arg0_37.handle)

	arg0_37.lightTF.sizeDelta = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_RANGE, arg0_37.lightTF.sizeDelta.y)
	arg0_37.lightTF.localPosition = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_DISTANCE + arg0_37.fushun:GetPosition().x, arg0_37.lightTF.localPosition.y)

	arg0_37:SpawnEnemys()
	arg0_37:RegisterEventListener()

	arg0_37.key = ""

	arg0_37.fushun:SetOnAnimEnd(function()
		arg0_37.key = ""

		arg0_37:DisplayKey()
	end)
end

function var0_0.UpdateGame(arg0_39)
	if arg0_39.state == var6_0 then
		arg0_39:ExitGame(true)

		return
	end

	if not arg0_39.pause then
		arg0_39.spawner:Update()
		arg0_39:AddDebugInput()

		if arg0_39.fushun:IsDeath() then
			arg0_39.fushun:Die()

			arg0_39.state = var6_0

			return
		elseif arg0_39.fushun:ShouldInvincible() then
			arg0_39:EnterInvincibleMode()
		elseif arg0_39.fushun:ShouldVincible() then
			arg0_39:ExitInvincibleMode()
		end

		local var0_39 = false

		for iter0_39 = #arg0_39.enemys, 1, -1 do
			local var1_39 = arg0_39.enemys[iter0_39]

			if var1_39:IsFreeze() then
				-- block empty
			elseif arg0_39:CheckEnemyDeath(iter0_39) then
				-- block empty
			else
				var1_39:Move()
				arg0_39:CheckCollision(arg0_39.fushun, var1_39)

				if arg0_39:CheckAttackRange(var1_39) then
					var0_39 = true
				end
			end
		end

		arg0_39:RangeLightDisplay(var0_39)
		arg0_39:DisplayeEnergy(arg0_39.fushun:GetEnergy(), arg0_39.fushun:GetEnergyTarget())
		arg0_39.specailSchedule:Update()
	else
		for iter1_39 = #arg0_39.enemys, 1, -1 do
			arg0_39:CheckEnemyDeath(iter1_39)
		end
	end

	arg0_39.schedule:Update()
end

function var0_0.RangeLightDisplay(arg0_40, arg1_40)
	setActive(arg0_40.lightMark, arg1_40)
end

function var0_0.CheckAttackRange(arg0_41, arg1_41)
	local var0_41 = arg0_41.fushun

	return arg1_41:GetPosition().x <= var0_41:GetAttackPosition().x
end

function var0_0.CheckEnemyDeath(arg0_42, arg1_42)
	local var0_42 = false
	local var1_42 = arg0_42.enemys[arg1_42]

	if var1_42:IsDeath() then
		if arg0_42.hitList[var1_42.index] and not var1_42:IsEscape() then
			arg0_42:AddScore(var1_42:GetScore())
			arg0_42:AddEnergy(var1_42:GetEnergyScore())
		end

		var1_42:Vanish()
		table.remove(arg0_42.enemys, arg1_42)

		var0_42 = true
	end

	return var0_42
end

function var0_0.EnterInvincibleMode(arg0_43)
	local var0_43 = FushunAdventureGameConst.EX_TIP_TIME
	local var1_43 = FushunAdventureGameConst.EX_TIME

	arg0_43.fushun:Invincible()
	setActive(arg0_43.exTipPanel, true)

	arg0_43.pause = true

	blinkAni(arg0_43.energyBar.gameObject, 0.5, -1)
	arg0_43.schedule:AddSchedule(var0_43, 1, function()
		setActive(arg0_43.exTipPanel, false)
		arg0_43.spawner:CarzyMode()

		arg0_43.pause = false

		arg0_43.fushun:StartAction("EX")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.ENTER_EX_VOICE)

		local var0_44 = arg0_43.fushun:GetEnergyTarget() / var1_43

		arg0_43.specailSchedule:AddSchedule(1, var1_43, function()
			arg0_43.fushun:ReduceEnergy(var0_44)
		end)
	end)
	setActive(arg0_43.btnAExEffect, true)
	setActive(arg0_43.btnBExEffect, true)

	arg0_43.key = ""

	arg0_43:DisplayKey()
end

function var0_0.ExitInvincibleMode(arg0_46)
	arg0_46.fushun:Vincible()

	arg0_46.energyBar.color = Color.New(1, 1, 1, 1)

	LeanTween.cancel(arg0_46.energyBar.gameObject)

	for iter0_46, iter1_46 in ipairs(arg0_46.enemys) do
		arg0_46.hitList[iter1_46.index] = nil

		iter1_46:Die()
	end

	arg0_46.spawner:NormalMode()
	setActive(arg0_46.btnAExEffect, false)
	setActive(arg0_46.btnBExEffect, false)
end

function var0_0.CheckCollision(arg0_47, arg1_47, arg2_47)
	if var0_0.IsCollision(arg2_47.effectCollider2D, arg1_47.collider2D) then
		arg1_47:Hurt()
		arg2_47:OnHit()
		arg0_47:DisplayeHearts(arg0_47.fushun:GetHp())
		arg0_47:AddCombo(-arg0_47.combo)
	elseif arg0_47.fushun:InvincibleState() and not arg2_47:IsDeath() and arg2_47:GetPosition().x <= arg1_47:GetAttackPosition().x then
		arg2_47:Hurt(1)

		arg0_47.hitList[arg2_47.index] = true

		arg0_47:AddHitEffect(arg2_47)
	elseif var0_0.IsNearby(arg1_47:GetPosition(), arg2_47:GetAttackPosition()) then
		arg2_47:Attack()
	end
end

function var0_0.AddHitEffect(arg0_48, arg1_48)
	local var0_48 = arg0_48.fushun.effectCollider2D.bounds.center
	local var1_48 = arg0_48.gameUI.transform:InverseTransformPoint(var0_48)
	local var2_48 = arg1_48.collider2D.bounds:GetMin()
	local var3_48 = arg0_48.gameUI.transform:InverseTransformPoint(var2_48)
	local var4_48 = Vector3(var3_48.x, var1_48.y, 0)

	arg0_48:loadPrefab("ui/fa_attack_effect", function(arg0_49)
		arg0_49.transform:SetParent(arg0_48.gameUI.transform, false)

		arg0_49.transform.localPosition = var4_48

		local var0_49 = arg0_49:GetComponent(typeof(DftAniEvent))

		var0_49:SetEndEvent(function()
			var0_49:SetEndEvent(nil)

			if arg0_49 then
				Destroy(arg0_49)
			end
		end)
	end)
	arg0_48:ShakeScreen(arg0_48.gameUI)
end

function var0_0.ShakeScreen(arg0_51, arg1_51)
	if LeanTween.isTweening(arg1_51) then
		LeanTween.cancel(arg1_51)
	end

	LeanTween.rotateAroundLocal(arg1_51, Vector3(0, 0, 1), FushunAdventureGameConst.SHAKE_RANGE, FushunAdventureGameConst.SHAKE_TIME):setLoopPingPong(FushunAdventureGameConst.SHAKE_LOOP_CNT):setFrom(-1 * FushunAdventureGameConst.SHAKE_RANGE):setOnComplete(System.Action(function()
		arg1_51.transform.localEulerAngles = Vector3(0, 0, 0)
	end))
end

function var0_0.SpawnEnemys(arg0_53)
	local var0_53 = {
		FushunBeastChar,
		FushunEliteBeastChar,
		FushunEliteBeastChar
	}

	local function var1_53(arg0_54)
		local var0_54 = FushunAdventureGameConst.SPEED_ADDITION
		local var1_54

		for iter0_54, iter1_54 in ipairs(var0_54) do
			local var2_54 = iter1_54[1][1]
			local var3_54 = iter1_54[1][2]

			if var2_54 <= arg0_54 and arg0_54 <= var3_54 then
				var1_54 = iter1_54

				break
			end
		end

		var1_54 = var1_54 or var0_54[#var0_54]

		return var1_54[2]
	end

	local function var2_53(arg0_55)
		local var0_55 = arg0_55.config
		local var1_55 = arg0_55.speed
		local var2_55 = arg0_55.index
		local var3_55 = var0_53[var0_55.id].New(arg0_55.go, var2_55, var0_55)
		local var4_55 = var1_55 + var1_53(arg0_53.score)

		var0_0.LOG("  顺序 :", var2_55, " id :", var0_55.id, " speed :", var4_55)
		var3_55:SetSpeed(var4_55)
		var3_55:SetPosition(FushunAdventureGameConst.ENEMY_SPAWN_POSITION)
		table.insert(arg0_53.enemys, var3_55)
	end

	arg0_53.spawner = FuShunEnemySpawner.New(arg0_53.gameUI.transform:Find("game").transform, var2_53)

	arg0_53.spawner:NormalMode()
end

function var0_0.AddScore(arg0_56, arg1_56)
	arg0_56:AddCombo(1)

	local var0_56 = arg0_56.combo >= FushunAdventureGameConst.COMBO_SCORE_TARGET and FushunAdventureGameConst.COMBO_EXTRA_SCORE or 0

	arg0_56.score = arg0_56.score + arg1_56 + var0_56

	arg0_56:DisplayScore()
	arg0_56.spawner:UpdateScore(arg0_56.score)
end

function var0_0.AddEnergy(arg0_57, arg1_57)
	arg0_57.fushun:AddEnergy(arg1_57)
end

function var0_0.AddCombo(arg0_58, arg1_58)
	if arg1_58 > 0 then
		arg0_58:loadPrefab("UI/fushun_combo", function(arg0_59)
			arg0_59.transform:SetParent(arg0_58.gameUI.transform:Find("UI"), false)

			local var0_59

			var0_59 = Timer.New(function()
				if arg0_59 then
					Destroy(arg0_59)
				end

				if var0_59 then
					var0_59:Stop()

					var0_59 = nil
				end
			end, 1, 1)

			var0_59:Start()
		end)
	end

	arg0_58.combo = arg0_58.combo + arg1_58
	arg0_58.comboTxt.text = arg0_58.combo

	setActive(arg0_58.comboTxt.gameObject.transform.parent, arg0_58.combo > 0)
end

function var0_0.Action(arg0_61, arg1_61)
	if arg0_61.fushun:InvincibleState() then
		arg0_61:AddScore(FushunAdventureGameConst.EX_CLICK_SCORE)
	else
		arg0_61:OnFushunAttack(arg1_61)
	end
end

function var0_0.OnFushunAttack(arg0_62, arg1_62)
	if #arg0_62.key == 3 or arg0_62.fushun:IsMissState() or arg0_62.fushun:IsDamageState() then
		return
	end

	arg0_62.key = arg0_62.key .. arg1_62

	arg0_62:DisplayKey()

	local var0_62 = {}
	local var1_62 = arg0_62.fushun

	for iter0_62, iter1_62 in ipairs(arg0_62.enemys) do
		if not iter1_62:WillDeath() and iter1_62:GetPosition().x <= var1_62:GetAttackPosition().x then
			table.insert(var0_62, iter0_62)
		end
	end

	arg0_62.fushun:TriggerAction(arg0_62.key, function()
		if #var0_62 == 0 then
			arg0_62.fushun:Miss()
		end

		arg0_62.key = ""

		arg0_62:DisplayKey()
	end)

	if #var0_62 > 0 then
		for iter2_62, iter3_62 in ipairs(var0_62) do
			local var2_62 = arg0_62.enemys[iter3_62]

			var2_62:Hurt(1)

			arg0_62.hitList[var2_62.index] = true

			arg0_62:AddHitEffect(var2_62)
		end
	end
end

function var0_0.PauseGame(arg0_64)
	arg0_64.pause = true
end

function var0_0.ResumeGame(arg0_65)
	arg0_65.pause = false
end

function var0_0.ExitGame(arg0_66, arg1_66)
	local function var0_66()
		arg0_66:ClearGameScene()
	end

	if arg0_66.btnA then
		ClearEventTrigger(arg0_66.btnA:GetComponent("EventTriggerListener"))
	end

	if arg0_66.btnB then
		ClearEventTrigger(arg0_66.btnB:GetComponent("EventTriggerListener"))
	end

	if arg0_66.handle then
		UpdateBeat:RemoveListener(arg0_66.handle)

		arg0_66.handle = nil
	end

	if arg0_66.schedule then
		arg0_66.schedule:Dispose()

		arg0_66.schedule = nil
	end

	if arg0_66.specailSchedule then
		arg0_66.specailSchedule:Dispose()

		arg0_66.specailSchedule = nil
	end

	if arg1_66 then
		if arg0_66.OnShowResult then
			arg0_66.OnShowResult(arg0_66.score)
		end

		arg0_66:ShowResultWindow(function()
			var0_66()
		end)
	else
		var0_66()
	end
end

function var0_0.ClearGameScene(arg0_69)
	if arg0_69.fushun then
		arg0_69.fushun:Destory()

		arg0_69.fushun = nil
	end

	if arg0_69.spawner then
		arg0_69.spawner:Dispose()

		arg0_69.spawner = nil
	end

	if arg0_69.enemys then
		for iter0_69, iter1_69 in ipairs(arg0_69.enemys) do
			iter1_69:Dispose()
		end

		arg0_69.enemys = nil
	end

	arg0_69.state = var4_0

	if arg0_69.gameUI then
		arg0_69:HideExitMsgbox()
		arg0_69:HideResultWindow()
		arg0_69:HidePauseMsgbox()
		setActive(arg0_69.gameUI, false)
		pg.BgmMgr.GetInstance():Push(arg0_69.__cname, FushunAdventureGameConst.BGM_NAME)
	end

	if arg0_69._endCallback then
		arg0_69._endCallback()
	end
end

function var0_0.IsStarting(arg0_70)
	return arg0_70.state == var5_0
end

function var0_0.Dispose(arg0_71)
	if arg0_71.countdownTimer then
		arg0_71.countdownTimer:Stop()

		arg0_71.countdownTimer = nil
	end

	arg0_71._startCallback = nil
	arg0_71._endCallback = nil

	arg0_71:ExitGame()
	pg.DelegateInfo.Dispose(arg0_71)

	if arg0_71.gameUI then
		Destroy(arg0_71.gameUI)

		arg0_71.gameUI = nil
	end

	arg0_71._go = nil
	arg0_71.btnSprites = nil
	arg0_71.state = var2_0
	arg0_71.OnShowResult = nil
	arg0_71.OnLevelUpdate = nil
end

function var0_0.AddDebugInput(arg0_72)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_72:OnShowBtnEffect("A", true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_72:Action("A")
			arg0_72:OnShowBtnEffect("A", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
		end

		if Input.GetKeyDown(KeyCode.S) then
			arg0_72:OnShowBtnEffect("B", true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			arg0_72:Action("B")
			arg0_72:OnShowBtnEffect("B", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
		end
	end
end

function var0_0.RegisterEventListener(arg0_73)
	local var0_73 = arg0_73.btnA:GetComponent("EventTriggerListener")

	var0_73:AddPointDownFunc(function()
		arg0_73:OnShowBtnEffect("A", true)
	end)
	var0_73:AddPointExitFunc(function()
		arg0_73:OnShowBtnEffect("A", false)
	end)
	var0_73:AddPointUpFunc(function()
		if arg0_73.pause then
			return
		end

		arg0_73:Action("A")
		arg0_73:OnShowBtnEffect("A", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
	end)

	local var1_73 = arg0_73.btnB:GetComponent("EventTriggerListener")

	var1_73:AddPointDownFunc(function()
		arg0_73:OnShowBtnEffect("B", true)
	end)
	var1_73:AddPointExitFunc(function()
		arg0_73:OnShowBtnEffect("B", false)
	end)
	var1_73:AddPointUpFunc(function()
		if arg0_73.pause then
			return
		end

		arg0_73:Action("B")
		arg0_73:OnShowBtnEffect("B", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
	end)
	onButton(arg0_73, arg0_73.pauseBtn, function()
		arg0_73:ShowPauseMsgbox()
	end, SFX_PANEL)
	onButton(arg0_73, arg0_73.exitBtn, function()
		arg0_73:ShowExitMsgbox()
	end, SFX_PANEL)
end

function var0_0.OnShowBtnEffect(arg0_82, arg1_82, arg2_82)
	setActive(arg0_82["btn" .. arg1_82 .. "Effect"], arg2_82)
end

function var0_0.ShowResultWindow(arg0_83, arg1_83)
	setActive(arg0_83.resultPanel, true)
	onButton(arg0_83, arg0_83.resultCloseBtn, function()
		arg0_83:HideResultWindow()

		if arg1_83 then
			arg1_83()
		end
	end, SFX_PANEL)

	if arg0_83.roomId then
		arg0_83.highestScore = getProxy(GameRoomProxy):getRoomScore(arg0_83.roomId)
	end

	arg0_83.resultHighestScoreTxt.text = arg0_83.highestScore
	arg0_83.resultScoreTxt.text = arg0_83.score

	if arg0_83.score > arg0_83.highestScore then
		arg0_83.highestScore = arg0_83.score
	end
end

function var0_0.HideResultWindow(arg0_85)
	setActive(arg0_85.resultPanel, false)
end

function var0_0.ShowPauseMsgbox(arg0_86)
	arg0_86:PauseGame()
	setActive(arg0_86.msgboxPanel, true)
	setActive(arg0_86.pauseMsgboxWindow, true)
	setActive(arg0_86.exitMsgboxWindow, false)
	onButton(arg0_86, arg0_86.pauseMsgboxWindow:Find("continue_btn"), function()
		arg0_86:ResumeGame()
		arg0_86:HidePauseMsgbox()
	end, SFX_PANEL)
end

function var0_0.HidePauseMsgbox(arg0_88)
	setActive(arg0_88.msgboxPanel, false)
	setActive(arg0_88.pauseMsgboxWindow, false)
end

function var0_0.ShowExitMsgbox(arg0_89)
	arg0_89:PauseGame()
	setActive(arg0_89.msgboxPanel, true)
	setActive(arg0_89.pauseMsgboxWindow, false)
	setActive(arg0_89.exitMsgboxWindow, true)
	onButton(arg0_89, arg0_89.exitMsgboxWindow:Find("cancel_btn"), function()
		arg0_89:ResumeGame()
		arg0_89:HideExitMsgbox()
	end, SFX_PANEL)
	onButton(arg0_89, arg0_89.exitMsgboxWindow:Find("confirm_btn"), function()
		arg0_89:HideExitMsgbox()

		if arg0_89.OnShowResult then
			arg0_89.OnShowResult(arg0_89.score)
		end

		arg0_89:ExitGame()
	end, SFX_PANEL)
end

function var0_0.HideExitMsgbox(arg0_92)
	setActive(arg0_92.msgboxPanel, false)
	setActive(arg0_92.exitMsgboxWindow, false)
end

function var0_0.IsCollision(arg0_93, arg1_93)
	return arg0_93.enabled and arg1_93.enabled and arg0_93.gameObject.activeSelf and arg0_93.bounds:Intersects(arg1_93.bounds)
end

function var0_0.IsNearby(arg0_94, arg1_94)
	return arg1_94.x - arg0_94.x <= 0
end

function var0_0.LOG(...)
	if var1_0 then
		print(...)
	end
end

return var0_0
