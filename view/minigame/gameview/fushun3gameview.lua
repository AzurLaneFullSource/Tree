local var0 = class("Fushun3GameView", import("..BaseMiniGameView"))
local var1 = "event:/ui/ddldaoshu2"
local var2 = "fushun_game3_tip"
local var3 = "event:/ui/taosheng"
local var4 = "event:/ui/tiji"
local var5 = "event:/ui/baozha1"
local var6 = "event:/ui/break_out_full"

function var0.getUIName(arg0)
	return "Fushun3GameView"
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:initController()
	arg0:updateMenuUI()
	arg0:openMenuUI()
end

function var0.initEvent(arg0)
	arg0:bind(Fushun3GameEvent.create_item_call, function(arg0, arg1, arg2)
		if arg0.itemController then
			arg0.itemController:createItem(arg1.name, arg1.pos)
		end
	end)
	arg0:bind(Fushun3GameEvent.create_platform_item_call, function(arg0, arg1, arg2)
		if arg0.itemController then
			arg0.itemController:createPlatformItem(arg1.pos, arg1.id)
		end
	end)
	arg0:bind(Fushun3GameEvent.item_follow_call, function(arg0, arg1, arg2)
		if arg0.itemController then
			arg0.itemController:itemFollow(arg1.anchoredPos)
		end
	end)
	arg0:bind(Fushun3GameEvent.create_monster_call, function(arg0, arg1, arg2)
		if arg0.monsterController then
			arg0.monsterController:createMonster(arg1.pos)
		end
	end)
	arg0:bind(Fushun3GameEvent.player_attack_call, function(arg0, arg1, arg2)
		if arg0.monsterController then
			arg0.monsterController:checkMonsterDamage(arg1.collider, arg1.callback, Fushun3GameEvent.attack_damdage_monster_call)
		end
	end)
	arg0:bind(Fushun3GameEvent.char_damaged_call, function(arg0, arg1, arg2)
		local var0 = arg0.charController:getHeart()

		arg0:updateGameUI()

		if var0 == 0 then
			arg0:onGameOver()
		end
	end)
	arg0:bind(Fushun3GameEvent.check_item_damage, function(arg0, arg1, arg2)
		if arg0.monsterController then
			arg0.monsterController:checkMonsterDamage(arg1.collider, arg1.callback, Fushun3GameEvent.shot_damage_monster_call)
		end
	end)
	arg0:bind(Fushun3GameEvent.check_player_damage, function(arg0, arg1, arg2)
		if arg0.monsterController then
			arg0.monsterController:checkPlayerDamage(arg1.tf, arg1.callback)
		end
	end)
	arg0:bind(Fushun3GameEvent.power_damage_monster_call, function(arg0, arg1, arg2)
		if arg0.monsterController then
			arg0.monsterController:damageMonster(arg1.tf, Fushun3GameEvent.power_damage_monster_call)
		end
	end)
	arg0:bind(Fushun3GameEvent.shot_damage_monster_call, function(arg0, arg1, arg2)
		if arg0.monsterController then
			arg0.monsterController:damageMonster(arg1.tf, Fushun3GameEvent.shot_damage_monster_call)
		end
	end)
	arg0:bind(Fushun3GameEvent.attack_damdage_monster_call, function(arg0, arg1, arg2)
		if arg0.monsterController then
			arg0.monsterController:damageMonster(arg1.tf, Fushun3GameEvent.attack_damdage_monster_call)
		end
	end)
	arg0:bind(Fushun3GameEvent.kick_damage_monster_call, function(arg0, arg1, arg2)
		if arg0.monsterController then
			arg0.monsterController:damageMonster(arg1.tf, Fushun3GameEvent.kick_damage_monster_call, arg1.callback)
		end
	end)
	arg0:bind(Fushun3GameEvent.add_anim_effect_call, function(arg0, arg1, arg2)
		if arg0.effectController and arg1 then
			arg0.effectController:addEffectByAnim(arg1.clipName, arg1.targetTf)
		end
	end)
	arg0:bind(Fushun3GameEvent.add_effect_call, function(arg0, arg1, arg2)
		if arg0.effectController and arg1 then
			arg0.effectController:addEffectByName(arg1.effectName, arg1.targetTf)
		end
	end)
	arg0:bind(Fushun3GameEvent.power_speed_call, function(arg0, arg1, arg2)
		if arg0.platformController then
			arg0.platformController:onPlayerPower()
		end
	end)
	arg0:bind(Fushun3GameEvent.add_monster_score_call, function(arg0, arg1, arg2)
		arg0.charController:addPower(Fushun3GameConst.monster_score)
		arg0:addScore(Fushun3GameConst.monster_score)
	end)
	arg0:bind(Fushun3GameEvent.game_over_call, function(arg0, arg1, arg2)
		arg0:onGameOver()
	end)
	arg0:bind(Fushun3GameEvent.day_night_change, function(arg0, arg1, arg2)
		if arg0.platformController then
			arg0.platformController:updateDayNight()
		end
	end)
end

function var0.onEventHandle(arg0, arg1)
	return
end

function var0.initData(arg0)
	Fushun3GameVo.ChangeTimeType(math.random() < 0.5 and Fushun3GameConst.day_type or Fushun3GameConst.night_type)

	arg0.dayTimeFlag = Fushun3GameVo.GetTimeFlag()

	local var0 = Application.targetFrameRate or 60

	if var0 > 60 then
		var0 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
end

function var0.initController(arg0)
	arg0.charTf = findTF(arg0._tf, "sceneContainer/scene/char")
	arg0.rectCollider = RectCollider.New(arg0.charTf, {}, arg0)

	arg0.rectCollider:addScript(FuShunMovementScript.New())
	arg0.rectCollider:addScript(FuShunAttakeScript.New())
	arg0.rectCollider:addScript(FuShunJumpScript.New())
	arg0.rectCollider:addScript(FuShunPowerSpeedScript.New())
	arg0.rectCollider:addScript(FuShunDamageScript.New())

	local var0 = findTF(arg0._tf, "tpls/platformTpls")
	local var1 = findTF(arg0.sceneTf, "platform/content")

	arg0.platformController = Fushun3PlatformControll.New(arg0.sceneTf, var0, var1, arg0)
	arg0.sceneController = Fushun3SceneController.New(arg0.backSceneTf, arg0.sceneTf, arg0.charTf)

	local var2 = arg0.rectCollider:getCollisionInfo()

	arg0.charController = Fushun3CharController.New(arg0.rectCollider, arg0.charTf, var2, arg0.powerProgressSlider, arg0)

	local var3 = findTF(arg0._tf, "tpls/itemTpls")

	arg0.itemController = Fushun3ItemController.New(arg0.sceneTf, arg0.charTf, var3, arg0)

	arg0.itemController:setCallback(function(arg0, arg1)
		arg0:onControllerCallback(arg0, arg1)
	end)

	local var4 = findTF(arg0._tf, "tpls/bgTpls")
	local var5 = findTF(arg0._tf, "tpls/fireTpls")
	local var6 = findTF(arg0._tf, "tpls/petalTpl")

	arg0.bgController = Fushun3BgController.New(var4, var5, var6, arg0.backSceneTf, arg0)

	local var7 = findTF(arg0._tf, "tpls/monsterTpls")
	local var8 = findTF(arg0.sceneTf, "monster")

	arg0.monsterController = Fushun3MonsterController.New(var7, var8, arg0.sceneTf, arg0)

	local var9 = findTF(arg0._tf, "tpls/efTpls")
	local var10 = findTF(arg0.sceneTf, "effect")

	arg0.effectController = Fushun3EffectController.New(var9, var10, arg0)
end

function var0.initUI(arg0)
	arg0.backSceneTf = findTF(arg0._tf, "sceneContainer/scene_background")
	arg0.frontSceneTf = findTF(arg0._tf, "sceneContainer/scene_front")
	arg0.sceneTf = findTF(arg0._tf, "sceneContainer/scene")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetOrAddComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:gameStart()
	end)
	SetActive(arg0.countUI, false)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0.leaveUI, false)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0.pauseUI, false)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:openMenuUI()
	end, SFX_CANCEL)
	SetActive(arg0.settlementUI, false)

	arg0.menuUI = findTF(arg0._tf, "pop/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = arg0:getGameTotalTime()

	local var0 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.battleScrollRect, 0, 1 - var0 / (arg0.totalTimes - 4))
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var2].tip
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		setActive(arg0.menuUI, false)
		arg0:readyStart()
	end, SFX_CANCEL)

	local var1 = findTF(arg0.menuUI, "tplBattleItem")

	arg0.battleItems = {}
	arg0.dropItems = {}

	for iter0 = 1, 7 do
		local var2 = tf(instantiate(var1))

		var2.name = "battleItem_" .. iter0

		setParent(var2, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var3 = iter0

		GetSpriteFromAtlasAsync("ui/minigameui/fushun3gameui_atlas", "battleDesc" .. var3, function(arg0)
			setImageSprite(findTF(var2, "state_open/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_clear/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_current/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_closed/buttomDesc"), arg0, true)
		end)
		setActive(var2, true)
		table.insert(arg0.battleItems, var2)
	end

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.initGameUI(arg0)
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")
	arg0.powerProgress = findTF(arg0.gameUI, "top/powerProgress")
	arg0.powerProgressSlider = GetComponent(arg0.powerProgress, typeof(Slider))

	onButton(arg0, findTF(arg0.gameUI, "topRight/btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.gameTimeS = findTF(arg0.gameUI, "top/time/s")
	arg0.scoreTf = findTF(arg0.gameUI, "top/score")
	arg0.hearts = {}

	for iter0 = 1, Fushun3GameConst.heart_num do
		table.insert(arg0.hearts, findTF(arg0.gameUI, "top/heart" .. iter0 .. "/full"))
	end

	arg0.atkDelegate = GetOrAddComponent(findTF(arg0.gameUI, "btnAtk"), "EventTriggerListener")
	arg0.atkDelegate.enabled = true

	arg0.atkDelegate:AddPointDownFunc(function(arg0, arg1)
		if arg0.charController then
			arg0.charController:attack()
		end
	end)

	arg0.jumpDelegate = GetOrAddComponent(findTF(arg0.gameUI, "btnJump"), "EventTriggerListener")
	arg0.jumpDelegate.enabled = true

	arg0.jumpDelegate:AddPointDownFunc(function(arg0, arg1)
		if arg0.charController then
			arg0.charController:jump()
		end
	end)
	setText(findTF(arg0._tf, "pop/LeaveUI/ad/desc/n"), i18n(Fushun3GameConst.mini_game_leave))
	setText(findTF(arg0._tf, "pop/pauseUI/ad/desc/n"), i18n(Fushun3GameConst.mini_game_pause))
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if Application.isEditor then
		-- block empty
	end
end

function var0.updateMenuUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "bg/n"), not arg0.dayTimeFlag)
		setActive(findTF(arg0.battleItems[iter0], "bg/d"), arg0.dayTimeFlag)
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
		end
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var2 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
	arg0:CheckGet()
	arg0:updateDayNightUI()
end

function var0.CheckGet(arg0)
	setActive(findTF(arg0.menuUI, "got"), false)

	if arg0:getUltimate() and arg0:getUltimate() ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0._tf, "sceneContainer/scene_front"), false)
	setActive(findTF(arg0._tf, "sceneContainer/scene_background"), false)
	setActive(findTF(arg0._tf, "sceneContainer/scene"), false)
	setActive(findTF(arg0._tf, "bg"), true)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	arg0:updateMenuUI()
end

function var0.clearUI(arg0)
	setActive(arg0.sceneTf, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
	setActive(arg0.menuUI, false)
	setActive(arg0.gameUI, false)
end

function var0.readyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1)
end

function var0.gameStart(arg0)
	setActive(findTF(arg0._tf, "sceneContainer/scene_front"), true)
	setActive(findTF(arg0._tf, "sceneContainer/scene_background"), true)
	setActive(findTF(arg0._tf, "sceneContainer/scene"), true)
	setActive(arg0.gameUI, true)
	setActive(findTF(arg0._tf, "bg"), false)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.playerPosIndex = 2
	arg0.gameStepTime = 0
	arg0.gameOverTime = 0
	arg0.gameTime = Fushun3GameConst.game_time
	arg0.gameLevelTime = Fushun3GameConst.level_time
	arg0.rectCollider:getCollisionInfo().config.moveSpeed = Fushun3GameConst.move_speed

	arg0.rectCollider:start()
	arg0.platformController:start()
	arg0.sceneController:start()
	arg0.charController:start()
	arg0.itemController:start()
	arg0.bgController:start()
	arg0.monsterController:start()
	arg0.effectController:start()
	arg0:updateGameUI()
	arg0:timerStart()
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getGameUsedTimes(arg0)
	return arg0:GetMGHubData().usedtime
end

function var0.getUltimate(arg0)
	return arg0:GetMGHubData().ultimate
end

function var0.getGameTotalTime(arg0)
	return (arg0:GetMGHubData():getConfig("reward_need"))
end

function var0.updateDayNightUI(arg0)
	arg0.dayTimeFlag = Fushun3GameVo.GetTimeFlag()

	setActive(findTF(arg0._tf, "bg/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0._tf, "bg/d"), arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "bg/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "bg/d"), arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "btnBack/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "btnBack/d"), arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "title/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "title/d"), arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "desc/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "desc/d"), arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "got/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "got/d"), arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "btnRule/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "btnRule/d"), arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "rightPanelBg/arrowUp/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "rightPanelBg/arrowUp/d"), arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "rightPanelBg/arrowDown/n"), not arg0.dayTimeFlag)
	setActive(findTF(arg0.menuUI, "rightPanelBg/arrowDown/d"), arg0.dayTimeFlag)

	local var0 = true

	setActive(findTF(arg0.countUI, "bgCount/n"), not var0)
	setActive(findTF(arg0.countUI, "bgCount/d"), var0)
	setActive(findTF(arg0.leaveUI, "ad/img/n"), not var0)
	setActive(findTF(arg0.leaveUI, "ad/img/d"), var0)
	setActive(findTF(arg0.leaveUI, "ad/btnOk/n"), not var0)
	setActive(findTF(arg0.leaveUI, "ad/btnOk/d"), var0)
	setActive(findTF(arg0.leaveUI, "ad/desc/n"), not var0)
	setActive(findTF(arg0.leaveUI, "ad/desc/d"), var0)
	setActive(findTF(arg0.pauseUI, "ad/img/n"), not var0)
	setActive(findTF(arg0.pauseUI, "ad/img/d"), var0)
	setActive(findTF(arg0.pauseUI, "ad/btnOk/n"), not var0)
	setActive(findTF(arg0.pauseUI, "ad/btnOk/d"), var0)
	setActive(findTF(arg0.pauseUI, "ad/desc/n"), not var0)
	setActive(findTF(arg0.pauseUI, "ad/desc/d"), var0)
	setActive(findTF(arg0.settlementUI, "ad/bg/img/n"), not var0)
	setActive(findTF(arg0.settlementUI, "ad/bg/img/d"), var0)
	setActive(findTF(arg0.settlementUI, "ad/bg/imgScore/n"), not var0)
	setActive(findTF(arg0.settlementUI, "ad/bg/imgScore/d"), var0)
	setActive(findTF(arg0.settlementUI, "ad/bg/imgHigh/n"), not var0)
	setActive(findTF(arg0.settlementUI, "ad/bg/imgHigh/d"), var0)

	local var1 = var0 and Color.New(1, 0.968627450980392, 0.92156862745098, 1) or Color.New(0.854901960784314, 0.807843137254902, 1, 1)

	setTextColor(findTF(arg0.settlementUI, "ad/currentText"), var1)
	setTextColor(findTF(arg0.settlementUI, "ad/highText"), var1)
	setActive(findTF(arg0.gameUI, "top/powerProgress/content/bg/n"), not var0)
	setActive(findTF(arg0.gameUI, "top/powerProgress/content/bg/d"), var0)
	setActive(findTF(arg0.gameUI, "top/powerProgress/full/n"), not var0)
	setActive(findTF(arg0.gameUI, "top/powerProgress/full/d"), var0)
	setActive(findTF(arg0.gameUI, "top/split/n"), not var0)
	setActive(findTF(arg0.gameUI, "top/split/d"), var0)
	setActive(findTF(arg0.gameUI, "top/scoreImg/n"), not var0)
	setActive(findTF(arg0.gameUI, "top/scoreImg/d"), var0)

	local var2 = var0 and Color.New(0.92156862745098, 0.874509803921569, 0.772549019607843, 1) or Color.New(0.8, 0.737254901960784, 0.83921568627451, 1)

	setTextColor(findTF(arg0.gameUI, "top/score"), var2)
	setActive(findTF(arg0.gameUI, "topRight/btnStop/n"), not var0)
	setActive(findTF(arg0.gameUI, "topRight/btnStop/d"), var0)
	setActive(findTF(arg0.gameUI, "btnLeave/n"), not var0)
	setActive(findTF(arg0.gameUI, "btnLeave/d"), var0)

	for iter0 = 1, Fushun3GameConst.heart_num do
		local var3 = findTF(arg0.gameUI, "top/heart" .. iter0 .. "")

		setActive(findTF(var3, "img/n"), not var0)
		setActive(findTF(var3, "img/d"), var0)
		setActive(findTF(var3, "full/n"), not var0)
		setActive(findTF(var3, "full/d"), var0)
	end
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0.gameOverTime = arg0.gameOverTime + Time.deltaTime
	arg0.gameTime = arg0.gameTime - Time.deltaTime

	if arg0.gameTime < 0 then
		arg0.gameTime = 0
	end

	arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime

	if arg0.gameLevelTime > 0 then
		arg0.gameLevelTime = arg0.gameLevelTime - Time.deltaTime

		if arg0.gameLevelTime <= 0 then
			arg0.gameLevelTime = Fushun3GameConst.level_time

			arg0.platformController:levelUp()
		end
	end

	arg0.rectCollider:step()
	arg0.platformController:step()
	arg0.sceneController:step()
	arg0.charController:step()
	arg0.itemController:step()
	arg0.bgController:step()
	arg0.monsterController:step()
	arg0.effectController:step()
	arg0:updateGameUI()

	if arg0.gameTime <= 0 then
		arg0:onGameOver()

		return
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.updateGameUI(arg0)
	local var0 = arg0.charController:getHeart()

	for iter0 = 1, #arg0.hearts do
		local var1 = arg0.hearts[iter0]

		if iter0 <= var0 then
			setActive(var1, true)
		else
			setActive(var1, false)
		end
	end

	setText(arg0.scoreTf, arg0.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg0.gameTime))
end

function var0.addScore(arg0, arg1)
	arg0.scoreNum = arg0.scoreNum + arg1

	if arg0.scoreNum < 0 then
		arg0.scoreNum = 0
	end
end

function var0.onControllerCallback(arg0, arg1, arg2)
	if arg1 == Fushun3GameEvent.catch_item_call then
		local var0 = arg2.data

		if var0.type == Fushun3GameConst.item_type_score then
			arg0:addScore(var0.score)
			arg0.charController:addPower(var0.score)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6)
			arg0.charController:setBuff(var0)
		end
	end
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), 1, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showSettlement()
	end))
	pg.m02:sendNotification(GAME.MINI_GAME_TIME, {
		id = arg0:GetMGData().id,
		time = math.ceil(arg0.gameOverTime)
	})
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var2 < var1)

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

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0.sendSuccessFlag = true

		arg0:SendSuccess(0)
	end
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.charController then
		arg0.charController:dispose()
	end

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	if arg0.atkDelegate then
		ClearEventTrigger(arg0.atkDelegate)
	end

	if arg0.jumpDelegate then
		ClearEventTrigger(arg0.jumpDelegate)
	end

	Time.timeScale = 1
	arg0.timer = nil

	arg0.rectCollider:clear()
end

return var0
