local var0_0 = class("Fushun3GameView", import("..BaseMiniGameView"))
local var1_0 = "event:/ui/ddldaoshu2"
local var2_0 = "fushun_game3_tip"
local var3_0 = "event:/ui/taosheng"
local var4_0 = "event:/ui/tiji"
local var5_0 = "event:/ui/baozha1"
local var6_0 = "event:/ui/break_out_full"

function var0_0.getUIName(arg0_1)
	return "Fushun3GameView"
end

function var0_0.didEnter(arg0_2)
	arg0_2:initEvent()
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:initGameUI()
	arg0_2:initController()
	arg0_2:updateMenuUI()
	arg0_2:openMenuUI()
end

function var0_0.initEvent(arg0_3)
	arg0_3:bind(Fushun3GameEvent.create_item_call, function(arg0_4, arg1_4, arg2_4)
		if arg0_3.itemController then
			arg0_3.itemController:createItem(arg1_4.name, arg1_4.pos)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.create_platform_item_call, function(arg0_5, arg1_5, arg2_5)
		if arg0_3.itemController then
			arg0_3.itemController:createPlatformItem(arg1_5.pos, arg1_5.id)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.item_follow_call, function(arg0_6, arg1_6, arg2_6)
		if arg0_3.itemController then
			arg0_3.itemController:itemFollow(arg1_6.anchoredPos)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.create_monster_call, function(arg0_7, arg1_7, arg2_7)
		if arg0_3.monsterController then
			arg0_3.monsterController:createMonster(arg1_7.pos)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.player_attack_call, function(arg0_8, arg1_8, arg2_8)
		if arg0_3.monsterController then
			arg0_3.monsterController:checkMonsterDamage(arg1_8.collider, arg1_8.callback, Fushun3GameEvent.attack_damdage_monster_call)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.char_damaged_call, function(arg0_9, arg1_9, arg2_9)
		local var0_9 = arg0_3.charController:getHeart()

		arg0_3:updateGameUI()

		if var0_9 == 0 then
			arg0_3:onGameOver()
		end
	end)
	arg0_3:bind(Fushun3GameEvent.check_item_damage, function(arg0_10, arg1_10, arg2_10)
		if arg0_3.monsterController then
			arg0_3.monsterController:checkMonsterDamage(arg1_10.collider, arg1_10.callback, Fushun3GameEvent.shot_damage_monster_call)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.check_player_damage, function(arg0_11, arg1_11, arg2_11)
		if arg0_3.monsterController then
			arg0_3.monsterController:checkPlayerDamage(arg1_11.tf, arg1_11.callback)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.power_damage_monster_call, function(arg0_12, arg1_12, arg2_12)
		if arg0_3.monsterController then
			arg0_3.monsterController:damageMonster(arg1_12.tf, Fushun3GameEvent.power_damage_monster_call)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.shot_damage_monster_call, function(arg0_13, arg1_13, arg2_13)
		if arg0_3.monsterController then
			arg0_3.monsterController:damageMonster(arg1_13.tf, Fushun3GameEvent.shot_damage_monster_call)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.attack_damdage_monster_call, function(arg0_14, arg1_14, arg2_14)
		if arg0_3.monsterController then
			arg0_3.monsterController:damageMonster(arg1_14.tf, Fushun3GameEvent.attack_damdage_monster_call)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.kick_damage_monster_call, function(arg0_15, arg1_15, arg2_15)
		if arg0_3.monsterController then
			arg0_3.monsterController:damageMonster(arg1_15.tf, Fushun3GameEvent.kick_damage_monster_call, arg1_15.callback)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.add_anim_effect_call, function(arg0_16, arg1_16, arg2_16)
		if arg0_3.effectController and arg1_16 then
			arg0_3.effectController:addEffectByAnim(arg1_16.clipName, arg1_16.targetTf)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.add_effect_call, function(arg0_17, arg1_17, arg2_17)
		if arg0_3.effectController and arg1_17 then
			arg0_3.effectController:addEffectByName(arg1_17.effectName, arg1_17.targetTf)
		end
	end)
	arg0_3:bind(Fushun3GameEvent.power_speed_call, function(arg0_18, arg1_18, arg2_18)
		if arg0_3.platformController then
			arg0_3.platformController:onPlayerPower()
		end
	end)
	arg0_3:bind(Fushun3GameEvent.add_monster_score_call, function(arg0_19, arg1_19, arg2_19)
		arg0_3.charController:addPower(Fushun3GameConst.monster_score)
		arg0_3:addScore(Fushun3GameConst.monster_score)
	end)
	arg0_3:bind(Fushun3GameEvent.game_over_call, function(arg0_20, arg1_20, arg2_20)
		arg0_3:onGameOver()
	end)
	arg0_3:bind(Fushun3GameEvent.day_night_change, function(arg0_21, arg1_21, arg2_21)
		if arg0_3.platformController then
			arg0_3.platformController:updateDayNight()
		end
	end)
end

function var0_0.onEventHandle(arg0_22, arg1_22)
	return
end

function var0_0.initData(arg0_23)
	Fushun3GameVo.ChangeTimeType(math.random() < 0.5 and Fushun3GameConst.day_type or Fushun3GameConst.night_type)

	arg0_23.dayTimeFlag = Fushun3GameVo.GetTimeFlag()

	local var0_23 = Application.targetFrameRate or 60

	if var0_23 > 60 then
		var0_23 = 60
	end

	arg0_23.timer = Timer.New(function()
		arg0_23:onTimer()
	end, 1 / var0_23, -1)
end

function var0_0.initController(arg0_25)
	arg0_25.charTf = findTF(arg0_25._tf, "sceneContainer/scene/char")
	arg0_25.rectCollider = RectCollider.New(arg0_25.charTf, {}, arg0_25)

	arg0_25.rectCollider:addScript(FuShunMovementScript.New())
	arg0_25.rectCollider:addScript(FuShunAttakeScript.New())
	arg0_25.rectCollider:addScript(FuShunJumpScript.New())
	arg0_25.rectCollider:addScript(FuShunPowerSpeedScript.New())
	arg0_25.rectCollider:addScript(FuShunDamageScript.New())

	local var0_25 = findTF(arg0_25._tf, "tpls/platformTpls")
	local var1_25 = findTF(arg0_25.sceneTf, "platform/content")

	arg0_25.platformController = Fushun3PlatformControll.New(arg0_25.sceneTf, var0_25, var1_25, arg0_25)
	arg0_25.sceneController = Fushun3SceneController.New(arg0_25.backSceneTf, arg0_25.sceneTf, arg0_25.charTf)

	local var2_25 = arg0_25.rectCollider:getCollisionInfo()

	arg0_25.charController = Fushun3CharController.New(arg0_25.rectCollider, arg0_25.charTf, var2_25, arg0_25.powerProgressSlider, arg0_25)

	local var3_25 = findTF(arg0_25._tf, "tpls/itemTpls")

	arg0_25.itemController = Fushun3ItemController.New(arg0_25.sceneTf, arg0_25.charTf, var3_25, arg0_25)

	arg0_25.itemController:setCallback(function(arg0_26, arg1_26)
		arg0_25:onControllerCallback(arg0_26, arg1_26)
	end)

	local var4_25 = findTF(arg0_25._tf, "tpls/bgTpls")
	local var5_25 = findTF(arg0_25._tf, "tpls/fireTpls")
	local var6_25 = findTF(arg0_25._tf, "tpls/petalTpl")

	arg0_25.bgController = Fushun3BgController.New(var4_25, var5_25, var6_25, arg0_25.backSceneTf, arg0_25)

	local var7_25 = findTF(arg0_25._tf, "tpls/monsterTpls")
	local var8_25 = findTF(arg0_25.sceneTf, "monster")

	arg0_25.monsterController = Fushun3MonsterController.New(var7_25, var8_25, arg0_25.sceneTf, arg0_25)

	local var9_25 = findTF(arg0_25._tf, "tpls/efTpls")
	local var10_25 = findTF(arg0_25.sceneTf, "effect")

	arg0_25.effectController = Fushun3EffectController.New(var9_25, var10_25, arg0_25)
end

function var0_0.initUI(arg0_27)
	arg0_27.backSceneTf = findTF(arg0_27._tf, "sceneContainer/scene_background")
	arg0_27.frontSceneTf = findTF(arg0_27._tf, "sceneContainer/scene_front")
	arg0_27.sceneTf = findTF(arg0_27._tf, "sceneContainer/scene")
	arg0_27.clickMask = findTF(arg0_27._tf, "clickMask")
	arg0_27.countUI = findTF(arg0_27._tf, "pop/CountUI")
	arg0_27.countAnimator = GetComponent(findTF(arg0_27.countUI, "count"), typeof(Animator))
	arg0_27.countDft = GetOrAddComponent(findTF(arg0_27.countUI, "count"), typeof(DftAniEvent))

	arg0_27.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_27.countDft:SetEndEvent(function()
		setActive(arg0_27.countUI, false)
		arg0_27:gameStart()
	end)
	SetActive(arg0_27.countUI, false)

	arg0_27.leaveUI = findTF(arg0_27._tf, "pop/LeaveUI")

	onButton(arg0_27, findTF(arg0_27.leaveUI, "ad/btnOk"), function()
		arg0_27:resumeGame()
		arg0_27:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_27, findTF(arg0_27.leaveUI, "ad/btnCancel"), function()
		arg0_27:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0_27.leaveUI, false)

	arg0_27.pauseUI = findTF(arg0_27._tf, "pop/pauseUI")

	onButton(arg0_27, findTF(arg0_27.pauseUI, "ad/btnOk"), function()
		setActive(arg0_27.pauseUI, false)
		arg0_27:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0_27.pauseUI, false)

	arg0_27.settlementUI = findTF(arg0_27._tf, "pop/SettleMentUI")

	onButton(arg0_27, findTF(arg0_27.settlementUI, "ad/btnOver"), function()
		setActive(arg0_27.settlementUI, false)
		arg0_27:openMenuUI()
	end, SFX_CANCEL)
	SetActive(arg0_27.settlementUI, false)

	arg0_27.menuUI = findTF(arg0_27._tf, "pop/menuUI")
	arg0_27.battleScrollRect = GetComponent(findTF(arg0_27.menuUI, "battList"), typeof(ScrollRect))
	arg0_27.totalTimes = arg0_27:getGameTotalTime()

	local var0_27 = arg0_27:getGameUsedTimes() - 4 < 0 and 0 or arg0_27:getGameUsedTimes() - 4

	scrollTo(arg0_27.battleScrollRect, 0, 1 - var0_27 / (arg0_27.totalTimes - 4))
	onButton(arg0_27, findTF(arg0_27.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_34 = arg0_27.battleScrollRect.normalizedPosition.y + 1 / (arg0_27.totalTimes - 4)

		if var0_34 > 1 then
			var0_34 = 1
		end

		scrollTo(arg0_27.battleScrollRect, 0, var0_34)
	end, SFX_CANCEL)
	onButton(arg0_27, findTF(arg0_27.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_35 = arg0_27.battleScrollRect.normalizedPosition.y - 1 / (arg0_27.totalTimes - 4)

		if var0_35 < 0 then
			var0_35 = 0
		end

		scrollTo(arg0_27.battleScrollRect, 0, var0_35)
	end, SFX_CANCEL)
	onButton(arg0_27, findTF(arg0_27.menuUI, "btnBack"), function()
		arg0_27:closeView()
	end, SFX_CANCEL)
	onButton(arg0_27, findTF(arg0_27.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var2_0].tip
		})
	end, SFX_CANCEL)
	onButton(arg0_27, findTF(arg0_27.menuUI, "btnStart"), function()
		setActive(arg0_27.menuUI, false)
		arg0_27:readyStart()
	end, SFX_CANCEL)

	local var1_27 = findTF(arg0_27.menuUI, "tplBattleItem")

	arg0_27.battleItems = {}
	arg0_27.dropItems = {}

	for iter0_27 = 1, 7 do
		local var2_27 = tf(instantiate(var1_27))

		var2_27.name = "battleItem_" .. iter0_27

		setParent(var2_27, findTF(arg0_27.menuUI, "battList/Viewport/Content"))

		local var3_27 = iter0_27

		GetSpriteFromAtlasAsync("ui/minigameui/fushun3gameui_atlas", "battleDesc" .. var3_27, function(arg0_39)
			setImageSprite(findTF(var2_27, "state_open/buttomDesc"), arg0_39, true)
			setImageSprite(findTF(var2_27, "state_clear/buttomDesc"), arg0_39, true)
			setImageSprite(findTF(var2_27, "state_current/buttomDesc"), arg0_39, true)
			setImageSprite(findTF(var2_27, "state_closed/buttomDesc"), arg0_39, true)
		end)
		setActive(var2_27, true)
		table.insert(arg0_27.battleItems, var2_27)
	end

	if not arg0_27.handle then
		arg0_27.handle = UpdateBeat:CreateListener(arg0_27.Update, arg0_27)
	end

	UpdateBeat:AddListener(arg0_27.handle)
end

function var0_0.initGameUI(arg0_40)
	arg0_40.gameUI = findTF(arg0_40._tf, "ui/gameUI")
	arg0_40.powerProgress = findTF(arg0_40.gameUI, "top/powerProgress")
	arg0_40.powerProgressSlider = GetComponent(arg0_40.powerProgress, typeof(Slider))

	onButton(arg0_40, findTF(arg0_40.gameUI, "topRight/btnStop"), function()
		arg0_40:stopGame()
		setActive(arg0_40.pauseUI, true)
	end)
	onButton(arg0_40, findTF(arg0_40.gameUI, "btnLeave"), function()
		arg0_40:stopGame()
		setActive(arg0_40.leaveUI, true)
	end)

	arg0_40.gameTimeS = findTF(arg0_40.gameUI, "top/time/s")
	arg0_40.scoreTf = findTF(arg0_40.gameUI, "top/score")
	arg0_40.hearts = {}

	for iter0_40 = 1, Fushun3GameConst.heart_num do
		table.insert(arg0_40.hearts, findTF(arg0_40.gameUI, "top/heart" .. iter0_40 .. "/full"))
	end

	arg0_40.atkDelegate = GetOrAddComponent(findTF(arg0_40.gameUI, "btnAtk"), "EventTriggerListener")
	arg0_40.atkDelegate.enabled = true

	arg0_40.atkDelegate:AddPointDownFunc(function(arg0_43, arg1_43)
		if arg0_40.charController then
			arg0_40.charController:attack()
		end
	end)

	arg0_40.jumpDelegate = GetOrAddComponent(findTF(arg0_40.gameUI, "btnJump"), "EventTriggerListener")
	arg0_40.jumpDelegate.enabled = true

	arg0_40.jumpDelegate:AddPointDownFunc(function(arg0_44, arg1_44)
		if arg0_40.charController then
			arg0_40.charController:jump()
		end
	end)
	setText(findTF(arg0_40._tf, "pop/LeaveUI/ad/desc/n"), i18n(Fushun3GameConst.mini_game_leave))
	setText(findTF(arg0_40._tf, "pop/pauseUI/ad/desc/n"), i18n(Fushun3GameConst.mini_game_pause))
end

function var0_0.Update(arg0_45)
	arg0_45:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_46)
	if arg0_46.gameStop or arg0_46.settlementFlag then
		return
	end

	if Application.isEditor then
		-- block empty
	end
end

function var0_0.updateMenuUI(arg0_47)
	local var0_47 = arg0_47:getGameUsedTimes()
	local var1_47 = arg0_47:getGameTimes()

	for iter0_47 = 1, #arg0_47.battleItems do
		setActive(findTF(arg0_47.battleItems[iter0_47], "bg/n"), not arg0_47.dayTimeFlag)
		setActive(findTF(arg0_47.battleItems[iter0_47], "bg/d"), arg0_47.dayTimeFlag)
		setActive(findTF(arg0_47.battleItems[iter0_47], "state_open"), false)
		setActive(findTF(arg0_47.battleItems[iter0_47], "state_closed"), false)
		setActive(findTF(arg0_47.battleItems[iter0_47], "state_clear"), false)
		setActive(findTF(arg0_47.battleItems[iter0_47], "state_current"), false)

		if iter0_47 <= var0_47 then
			setActive(findTF(arg0_47.battleItems[iter0_47], "state_clear"), true)
		elseif iter0_47 == var0_47 + 1 and var1_47 >= 1 then
			setActive(findTF(arg0_47.battleItems[iter0_47], "state_current"), true)
		elseif var0_47 < iter0_47 and iter0_47 <= var0_47 + var1_47 then
			setActive(findTF(arg0_47.battleItems[iter0_47], "state_open"), true)
		else
			setActive(findTF(arg0_47.battleItems[iter0_47], "state_closed"), true)
		end
	end

	arg0_47.totalTimes = arg0_47:getGameTotalTime()

	local var2_47 = 1 - (arg0_47:getGameUsedTimes() - 3 < 0 and 0 or arg0_47:getGameUsedTimes() - 3) / (arg0_47.totalTimes - 4)

	if var2_47 > 1 then
		var2_47 = 1
	end

	scrollTo(arg0_47.battleScrollRect, 0, var2_47)
	setActive(findTF(arg0_47.menuUI, "btnStart/tip"), var1_47 > 0)
	arg0_47:CheckGet()
	arg0_47:updateDayNightUI()
end

function var0_0.CheckGet(arg0_48)
	setActive(findTF(arg0_48.menuUI, "got"), false)

	if arg0_48:getUltimate() and arg0_48:getUltimate() ~= 0 then
		setActive(findTF(arg0_48.menuUI, "got"), true)
	end

	if arg0_48:getUltimate() == 0 then
		if arg0_48:getGameTotalTime() > arg0_48:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_48:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_48.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_49)
	setActive(findTF(arg0_49._tf, "sceneContainer/scene_front"), false)
	setActive(findTF(arg0_49._tf, "sceneContainer/scene_background"), false)
	setActive(findTF(arg0_49._tf, "sceneContainer/scene"), false)
	setActive(findTF(arg0_49._tf, "bg"), true)
	setActive(arg0_49.gameUI, false)
	setActive(arg0_49.menuUI, true)
	arg0_49:updateMenuUI()
end

function var0_0.clearUI(arg0_50)
	setActive(arg0_50.sceneTf, false)
	setActive(arg0_50.settlementUI, false)
	setActive(arg0_50.countUI, false)
	setActive(arg0_50.menuUI, false)
	setActive(arg0_50.gameUI, false)
end

function var0_0.readyStart(arg0_51)
	setActive(arg0_51.countUI, true)
	arg0_51.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0)
end

function var0_0.gameStart(arg0_52)
	setActive(findTF(arg0_52._tf, "sceneContainer/scene_front"), true)
	setActive(findTF(arg0_52._tf, "sceneContainer/scene_background"), true)
	setActive(findTF(arg0_52._tf, "sceneContainer/scene"), true)
	setActive(arg0_52.gameUI, true)
	setActive(findTF(arg0_52._tf, "bg"), false)

	arg0_52.gameStartFlag = true
	arg0_52.scoreNum = 0
	arg0_52.playerPosIndex = 2
	arg0_52.gameStepTime = 0
	arg0_52.gameOverTime = 0
	arg0_52.gameTime = Fushun3GameConst.game_time
	arg0_52.gameLevelTime = Fushun3GameConst.level_time
	arg0_52.rectCollider:getCollisionInfo().config.moveSpeed = Fushun3GameConst.move_speed

	arg0_52.rectCollider:start()
	arg0_52.platformController:start()
	arg0_52.sceneController:start()
	arg0_52.charController:start()
	arg0_52.itemController:start()
	arg0_52.bgController:start()
	arg0_52.monsterController:start()
	arg0_52.effectController:start()
	arg0_52:updateGameUI()
	arg0_52:timerStart()
end

function var0_0.getGameTimes(arg0_53)
	return arg0_53:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_54)
	return arg0_54:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_55)
	return arg0_55:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_56)
	return (arg0_56:GetMGHubData():getConfig("reward_need"))
end

function var0_0.updateDayNightUI(arg0_57)
	arg0_57.dayTimeFlag = Fushun3GameVo.GetTimeFlag()

	setActive(findTF(arg0_57._tf, "bg/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57._tf, "bg/d"), arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "bg/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "bg/d"), arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "btnBack/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "btnBack/d"), arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "title/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "title/d"), arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "desc/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "desc/d"), arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "got/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "got/d"), arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "btnRule/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "btnRule/d"), arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "rightPanelBg/arrowUp/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "rightPanelBg/arrowUp/d"), arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "rightPanelBg/arrowDown/n"), not arg0_57.dayTimeFlag)
	setActive(findTF(arg0_57.menuUI, "rightPanelBg/arrowDown/d"), arg0_57.dayTimeFlag)

	local var0_57 = true

	setActive(findTF(arg0_57.countUI, "bgCount/n"), not var0_57)
	setActive(findTF(arg0_57.countUI, "bgCount/d"), var0_57)
	setActive(findTF(arg0_57.leaveUI, "ad/img/n"), not var0_57)
	setActive(findTF(arg0_57.leaveUI, "ad/img/d"), var0_57)
	setActive(findTF(arg0_57.leaveUI, "ad/btnOk/n"), not var0_57)
	setActive(findTF(arg0_57.leaveUI, "ad/btnOk/d"), var0_57)
	setActive(findTF(arg0_57.leaveUI, "ad/desc/n"), not var0_57)
	setActive(findTF(arg0_57.leaveUI, "ad/desc/d"), var0_57)
	setActive(findTF(arg0_57.pauseUI, "ad/img/n"), not var0_57)
	setActive(findTF(arg0_57.pauseUI, "ad/img/d"), var0_57)
	setActive(findTF(arg0_57.pauseUI, "ad/btnOk/n"), not var0_57)
	setActive(findTF(arg0_57.pauseUI, "ad/btnOk/d"), var0_57)
	setActive(findTF(arg0_57.pauseUI, "ad/desc/n"), not var0_57)
	setActive(findTF(arg0_57.pauseUI, "ad/desc/d"), var0_57)
	setActive(findTF(arg0_57.settlementUI, "ad/bg/img/n"), not var0_57)
	setActive(findTF(arg0_57.settlementUI, "ad/bg/img/d"), var0_57)
	setActive(findTF(arg0_57.settlementUI, "ad/bg/imgScore/n"), not var0_57)
	setActive(findTF(arg0_57.settlementUI, "ad/bg/imgScore/d"), var0_57)
	setActive(findTF(arg0_57.settlementUI, "ad/bg/imgHigh/n"), not var0_57)
	setActive(findTF(arg0_57.settlementUI, "ad/bg/imgHigh/d"), var0_57)

	local var1_57 = var0_57 and Color.New(1, 0.968627450980392, 0.92156862745098, 1) or Color.New(0.854901960784314, 0.807843137254902, 1, 1)

	setTextColor(findTF(arg0_57.settlementUI, "ad/currentText"), var1_57)
	setTextColor(findTF(arg0_57.settlementUI, "ad/highText"), var1_57)
	setActive(findTF(arg0_57.gameUI, "top/powerProgress/content/bg/n"), not var0_57)
	setActive(findTF(arg0_57.gameUI, "top/powerProgress/content/bg/d"), var0_57)
	setActive(findTF(arg0_57.gameUI, "top/powerProgress/full/n"), not var0_57)
	setActive(findTF(arg0_57.gameUI, "top/powerProgress/full/d"), var0_57)
	setActive(findTF(arg0_57.gameUI, "top/split/n"), not var0_57)
	setActive(findTF(arg0_57.gameUI, "top/split/d"), var0_57)
	setActive(findTF(arg0_57.gameUI, "top/scoreImg/n"), not var0_57)
	setActive(findTF(arg0_57.gameUI, "top/scoreImg/d"), var0_57)

	local var2_57 = var0_57 and Color.New(0.92156862745098, 0.874509803921569, 0.772549019607843, 1) or Color.New(0.8, 0.737254901960784, 0.83921568627451, 1)

	setTextColor(findTF(arg0_57.gameUI, "top/score"), var2_57)
	setActive(findTF(arg0_57.gameUI, "topRight/btnStop/n"), not var0_57)
	setActive(findTF(arg0_57.gameUI, "topRight/btnStop/d"), var0_57)
	setActive(findTF(arg0_57.gameUI, "btnLeave/n"), not var0_57)
	setActive(findTF(arg0_57.gameUI, "btnLeave/d"), var0_57)

	for iter0_57 = 1, Fushun3GameConst.heart_num do
		local var3_57 = findTF(arg0_57.gameUI, "top/heart" .. iter0_57 .. "")

		setActive(findTF(var3_57, "img/n"), not var0_57)
		setActive(findTF(var3_57, "img/d"), var0_57)
		setActive(findTF(var3_57, "full/n"), not var0_57)
		setActive(findTF(var3_57, "full/d"), var0_57)
	end
end

function var0_0.onTimer(arg0_58)
	arg0_58:gameStep()
end

function var0_0.gameStep(arg0_59)
	arg0_59.gameOverTime = arg0_59.gameOverTime + Time.deltaTime
	arg0_59.gameTime = arg0_59.gameTime - Time.deltaTime

	if arg0_59.gameTime < 0 then
		arg0_59.gameTime = 0
	end

	arg0_59.gameStepTime = arg0_59.gameStepTime + Time.deltaTime

	if arg0_59.gameLevelTime > 0 then
		arg0_59.gameLevelTime = arg0_59.gameLevelTime - Time.deltaTime

		if arg0_59.gameLevelTime <= 0 then
			arg0_59.gameLevelTime = Fushun3GameConst.level_time

			arg0_59.platformController:levelUp()
		end
	end

	arg0_59.rectCollider:step()
	arg0_59.platformController:step()
	arg0_59.sceneController:step()
	arg0_59.charController:step()
	arg0_59.itemController:step()
	arg0_59.bgController:step()
	arg0_59.monsterController:step()
	arg0_59.effectController:step()
	arg0_59:updateGameUI()

	if arg0_59.gameTime <= 0 then
		arg0_59:onGameOver()

		return
	end
end

function var0_0.timerStart(arg0_60)
	if not arg0_60.timer.running then
		arg0_60.timer:Start()
	end
end

function var0_0.timerStop(arg0_61)
	if arg0_61.timer.running then
		arg0_61.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_62)
	local var0_62 = arg0_62.charController:getHeart()

	for iter0_62 = 1, #arg0_62.hearts do
		local var1_62 = arg0_62.hearts[iter0_62]

		if iter0_62 <= var0_62 then
			setActive(var1_62, true)
		else
			setActive(var1_62, false)
		end
	end

	setText(arg0_62.scoreTf, arg0_62.scoreNum)
	setText(arg0_62.gameTimeS, math.ceil(arg0_62.gameTime))
end

function var0_0.addScore(arg0_63, arg1_63)
	arg0_63.scoreNum = arg0_63.scoreNum + arg1_63

	if arg0_63.scoreNum < 0 then
		arg0_63.scoreNum = 0
	end
end

function var0_0.onControllerCallback(arg0_64, arg1_64, arg2_64)
	if arg1_64 == Fushun3GameEvent.catch_item_call then
		local var0_64 = arg2_64.data

		if var0_64.type == Fushun3GameConst.item_type_score then
			arg0_64:addScore(var0_64.score)
			arg0_64.charController:addPower(var0_64.score)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6_0)
			arg0_64.charController:setBuff(var0_64)
		end
	end
end

function var0_0.onGameOver(arg0_65)
	if arg0_65.settlementFlag then
		return
	end

	arg0_65:timerStop()

	arg0_65.settlementFlag = true

	setActive(arg0_65.clickMask, true)
	LeanTween.delayedCall(go(arg0_65._tf), 1, System.Action(function()
		arg0_65.settlementFlag = false
		arg0_65.gameStartFlag = false

		setActive(arg0_65.clickMask, false)
		arg0_65:showSettlement()
	end))
	pg.m02:sendNotification(GAME.MINI_GAME_TIME, {
		id = arg0_65:GetMGData().id,
		time = math.ceil(arg0_65.gameOverTime)
	})
end

function var0_0.showSettlement(arg0_67)
	setActive(arg0_67.settlementUI, true)
	GetComponent(findTF(arg0_67.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_67 = arg0_67:GetMGData():GetRuntimeData("elements")
	local var1_67 = arg0_67.scoreNum
	local var2_67 = var0_67 and #var0_67 > 0 and var0_67[1] or 0

	setActive(findTF(arg0_67.settlementUI, "ad/new"), var2_67 < var1_67)

	if var2_67 <= var1_67 then
		var2_67 = var1_67

		arg0_67:StoreDataToServer({
			var2_67
		})
	end

	local var3_67 = findTF(arg0_67.settlementUI, "ad/highText")
	local var4_67 = findTF(arg0_67.settlementUI, "ad/currentText")

	setText(var3_67, var2_67)
	setText(var4_67, var1_67)

	if arg0_67:getGameTimes() and arg0_67:getGameTimes() > 0 then
		arg0_67.sendSuccessFlag = true

		arg0_67:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_68)
	arg0_68.gameStop = false

	setActive(arg0_68.leaveUI, false)
	arg0_68:timerStart()
end

function var0_0.stopGame(arg0_69)
	arg0_69.gameStop = true

	arg0_69:timerStop()
end

function var0_0.onBackPressed(arg0_70)
	if not arg0_70.gameStartFlag then
		arg0_70:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_70.settlementFlag then
			return
		end

		if isActive(arg0_70.pauseUI) then
			setActive(arg0_70.pauseUI, false)
		end

		arg0_70:stopGame()
		setActive(arg0_70.leaveUI, true)
	end
end

function var0_0.willExit(arg0_71)
	if arg0_71.charController then
		arg0_71.charController:dispose()
	end

	if arg0_71.handle then
		UpdateBeat:RemoveListener(arg0_71.handle)
	end

	if arg0_71._tf and LeanTween.isTweening(go(arg0_71._tf)) then
		LeanTween.cancel(go(arg0_71._tf))
	end

	if arg0_71.timer and arg0_71.timer.running then
		arg0_71.timer:Stop()
	end

	if arg0_71.atkDelegate then
		ClearEventTrigger(arg0_71.atkDelegate)
	end

	if arg0_71.jumpDelegate then
		ClearEventTrigger(arg0_71.jumpDelegate)
	end

	Time.timeScale = 1
	arg0_71.timer = nil

	arg0_71.rectCollider:clear()
end

return var0_0
