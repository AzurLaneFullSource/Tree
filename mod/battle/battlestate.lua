ys = ys or {}

local var0_0 = ys

var0_0.Battle = var0_0.Battle or {}

local var1_0 = {}

pg.bfConsts = var1_0
var1_0.DFT_CRIT_EFFECT = 1.5
var1_0.DFT_CRIT_RATE = 0.05
var1_0.SECONDs = 60
var1_0.PERCENT = 0.01
var1_0.PERCENT1 = 0.001
var1_0.PERCENT2 = 0.0001
var1_0.HUNDRED = 100
var1_0.SCORE_RATE = {
	0.7,
	0.8,
	0.3
}
var1_0.CRASH_RATE = {
	0.05,
	0.025
}
var1_0.SUBMARINE_KAMIKAZE = {
	80,
	3.5,
	1.5,
	1,
	0.5,
	0.5,
	1,
	0.005
}
var1_0.LEAK_RATE = {
	10,
	2.2,
	0.7,
	0.3,
	1,
	0.005,
	0.5
}
var1_0.PLANE_LEAK_RATE = {
	1,
	1,
	0.01,
	0.5,
	0.7,
	0.3,
	1,
	0.005,
	150,
	150,
	1,
	1
}
var1_0.METEO_RATE = {
	0.05,
	20,
	0.6,
	0.4
}
var1_0.NUM1 = 1
var1_0.NUM0 = 0
var1_0.NUM10000 = 10000
var1_0.ACCURACY = {
	0.1,
	2
}
var1_0.DRATE = {
	25,
	0.02,
	0.0002,
	2000,
	0.1,
	0.8,
	150
}
var1_0.SPEED_CONST = 0.02
var1_0.HP_CONST = 1.5

local var2_0 = singletonClass("BattleState", var0_0.MVC.Facade)

var0_0.Battle.BattleState = var2_0
var2_0.__name = "BattleState"
var2_0.BATTLE_STATE_IDLE = "BATTLE_IDLE"
var2_0.BATTLE_STATE_OPENING = "BATTLE_OPENING"
var2_0.BATTLE_STATE_FIGHT = "BATTLE_FIGHT"
var2_0.BATTLE_STATE_REPORT = "BATTLE_REPORT"

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
	arg0_1:ChangeState(var2_0.BATTLE_STATE_IDLE)
end

function var2_0.IsAutoBotActive(arg0_2)
	local var0_2 = AutoBotCommand.GetAutoBotMark(arg0_2)

	return PlayerPrefs.GetInt("autoBotIsAcitve" .. var0_2, 0) == 1 and AutoBotCommand.autoBotSatisfied()
end

function var2_0.IsAutoSubActive(arg0_3)
	local var0_3 = AutoSubCommand.GetAutoSubMark(arg0_3)

	return PlayerPrefs.GetInt("autoSubIsAcitve" .. var0_3, 0) == 1
end

function var2_0.ChatUseable(arg0_4)
	local var0_4 = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)
	local var1_4 = not var0_4 or var0_4 ~= 1
	local var2_4 = arg0_4:GetBattleType()
	local var3_4 = arg0_4.IsAutoBotActive(var2_4)
	local var4_4 = var2_4 == SYSTEM_DUEL
	local var5_4 = var2_4 == SYSTEM_CARDPUZZLE

	return var1_4 and (var4_4 or var3_4) and not var5_4
end

function var2_0.GetState(arg0_5)
	return arg0_5._state
end

function var2_0.GetBattleType(arg0_6)
	return arg0_6._battleType
end

function var2_0.SetBattleUI(arg0_7, arg1_7)
	arg0_7._baseUI = arg1_7
end

function var2_0.EnterBattle(arg0_8, arg1_8, arg2_8)
	pg.TimeMgr.GetInstance():ResetCombatTime()
	arg0_8:Active()
	arg0_8:ResetTimer()

	arg0_8._dataProxy = arg0_8:AddDataProxy(var0_0.Battle.BattleDataProxy.GetInstance())
	arg0_8._uiMediator = arg0_8:AddMediator(var0_0.Battle.BattleUIMediator.New())

	if arg1_8.battleType == SYSTEM_DUEL then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleDuelArenaCommand.New())

		arg0_8._battleCommand:ConfigBattleData(arg1_8)
	elseif arg1_8.battleType == SYSTEM_CHALLENGE then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleSingleChallengeCommand.New())

		arg0_8._battleCommand:ConfigBattleData(arg1_8)
	elseif arg1_8.battleType == SYSTEM_DODGEM then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleDodgemCommand.New())
	elseif arg1_8.battleType == SYSTEM_SUBMARINE_RUN then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleSubmarineRunCommand.New())
	elseif arg1_8.battleType == SYSTEM_SUB_ROUTINE then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleSubRoutineCommand.New())
	elseif arg1_8.battleType == SYSTEM_HP_SHARE_ACT_BOSS or arg1_8.battleType == SYSTEM_BOSS_EXPERIMENT then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleInheritDungeonCommand.New())
	elseif arg1_8.battleType == SYSTEM_WORLD_BOSS then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleWorldBossCommand.New())
	elseif arg1_8.battleType == SYSTEM_DEBUG then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleDebugCommand.New())
	elseif arg1_8.battleType == SYSTEM_AIRFIGHT then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleAirFightCommand.New())
	elseif arg1_8.battleType == SYSTEM_GUILD then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleGuildBossCommand.New())
	elseif arg1_8.battleType == SYSTEM_CARDPUZZLE then
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleCardPuzzleCommand.New())
	else
		arg0_8._battleCommand = arg0_8:AddCommand(var0_0.Battle.BattleSingleDungeonCommand.New())
	end

	arg0_8._battleType = arg1_8.battleType
	arg0_8._sceneMediator = arg0_8:AddMediator(var0_0.Battle.BattleSceneMediator.New())
	arg0_8._weaponCommand = arg0_8:AddCommand(var0_0.Battle.BattleControllerWeaponCommand.New())

	arg0_8._dataProxy:InitBattle(arg1_8)

	if BATTLE_DEFAULT_UNIT_DETAIL then
		arg0_8:AddMediator(var0_0.Battle.BattleReferenceBoxMediator.New())
		arg0_8:GetMediatorByName(var0_0.Battle.BattleReferenceBoxMediator.__name):ActiveUnitDetail(true)
	end

	if arg2_8 then
		-- block empty
	else
		arg0_8:ChangeState(var2_0.BATTLE_STATE_OPENING)
		UpdateBeat:Add(arg0_8.Update, arg0_8)
	end
end

function var2_0.GetSceneMediator(arg0_9)
	return arg0_9._sceneMediator
end

function var2_0.GetUIMediator(arg0_10)
	return arg0_10._uiMediator
end

function var2_0.ActiveBot(arg0_11, arg1_11)
	arg0_11._weaponCommand:ActiveBot(arg1_11, true)
	arg0_11:EnableJoystick(not arg1_11)
end

function var2_0.EnableJoystick(arg0_12, arg1_12)
	arg0_12._uiMediator:EnableJoystick(arg1_12)
end

function var2_0.IsBotActive(arg0_13)
	return arg0_13._weaponCommand:GetWeaponBot():IsActive()
end

function var2_0.Update(arg0_14)
	if not arg0_14._isPause then
		for iter0_14, iter1_14 in pairs(arg0_14._mediatorList) do
			iter1_14:Update()
		end
	else
		for iter2_14, iter3_14 in pairs(arg0_14._mediatorList) do
			iter3_14:UpdatePause()
		end
	end
end

function var2_0.GenerateVertifyData(arg0_15)
	return
end

function var2_0.Vertify()
	return true, -1
end

function var2_0.ChangeState(arg0_17, arg1_17)
	arg0_17._state = arg1_17

	if arg1_17 == var2_0.BATTLE_STATE_OPENING then
		arg0_17._dataProxy:Start()

		local var0_17 = arg0_17._dataProxy._dungeonInfo.beginStoy

		if var0_17 then
			pg.NewStoryMgr.GetInstance():Play(var0_17, function()
				arg0_17._battleCommand:DoPrologue()
			end)
		else
			arg0_17._battleCommand:DoPrologue()
		end
	elseif arg1_17 == var2_0.BATTLE_STATE_FIGHT then
		arg0_17:ActiveAutoComponentTimer()
	elseif arg1_17 == var2_0.BATTLE_STATE_REPORT then
		-- block empty
	end
end

function var2_0.GetUI(arg0_19)
	return arg0_19._baseUI
end

function var2_0.ConfigBattleEndFunc(arg0_20, arg1_20)
	arg0_20._endFunc = arg1_20
end

function var2_0.BattleEnd(arg0_21)
	arg0_21:disableCommon()

	if arg0_21._dataProxy:GetStatistics()._battleScore >= var0_0.Battle.BattleConst.BattleScore.B then
		arg0_21._dataProxy:CelebrateVictory(arg0_21._dataProxy:GetFriendlyCode())
		arg0_21:reportDelayTimer(function()
			arg0_21:DoResult()
		end, var0_0.Battle.BattleConfig.CelebrateDuration)
	else
		arg0_21:DoResult()
	end
end

function var2_0.BattleTimeUp(arg0_23)
	arg0_23:disableCommon()
	arg0_23:ActiveEscape()
	arg0_23:reportDelayTimer(function()
		arg0_23:DeactiveEscape()
		arg0_23:DoResult()
	end, var0_0.Battle.BattleConfig.EscapeDuration)
end

function var2_0.DoResult(arg0_25)
	arg0_25._sceneMediator:PauseCharacterAction(true)
	arg0_25._dataProxy:BotPercentage(arg0_25._weaponCommand:GetBotActiveDuration())
	arg0_25._dataProxy:HPRatioStatistics()
	arg0_25._endFunc(arg0_25._dataProxy:GetStatistics())
end

function var2_0.ExitBattle(arg0_26)
	var0_0.Battle.BattleCameraUtil.GetInstance():Clear()

	for iter0_26, iter1_26 in pairs(arg0_26._mediatorList) do
		arg0_26:RemoveMediator(iter1_26)
	end

	for iter2_26, iter3_26 in pairs(arg0_26._commandList) do
		arg0_26:RemoveCommand(iter3_26)
	end

	for iter4_26, iter5_26 in pairs(arg0_26._proxyList) do
		arg0_26:RemoveProxy(iter5_26)
	end

	var0_0.Battle.BattleConfig.BASIC_TIME_SCALE = 1

	arg0_26:RemoveAllTimer()
	var0_0.Battle.BattleResourceManager.GetInstance():Clear()

	arg0_26._takeoverProcess = nil

	arg0_26:ChangeState(var2_0.BATTLE_STATE_IDLE)

	arg0_26._baseUI = nil
	arg0_26._endFunc = nil
	arg0_26._uiMediator = nil
	arg0_26._sceneMediator = nil
	arg0_26._battleCommand = nil
	arg0_26._weaponCommand = nil

	removeSingletonInstance(var0_0.Battle.BattleDataProxy)

	arg0_26._dataProxy = nil

	var0_0.Battle.BattleVariable.Clear()
	var0_0.Battle.BattleBulletFactory.DestroyFactory()
	UpdateBeat:Remove(arg0_26.Update, arg0_26)
	pg.EffectMgr.GetInstance():ClearBattleEffectMap()

	arg0_26._timeScale = nil
	arg0_26._timescalerCache = nil

	gcAll(true)
end

function var2_0.Stop(arg0_27, arg1_27)
	arg0_27:disableCommon()
	arg0_27._baseUI:exitBattle(arg1_27)
end

function var2_0.disableCommon(arg0_28)
	arg0_28._weaponCommand:ActiveBot(false)
	arg0_28:ScaleTimer()
	var0_0.Battle.BattleCameraUtil.GetInstance():ResetFocus()
	arg0_28:ChangeState(var2_0.BATTLE_STATE_REPORT)
	arg0_28._dataProxy:ClearAirFighterTimer()
	arg0_28._dataProxy:KillAllAircraft()
	arg0_28._sceneMediator:AllBulletNeutralize()
	var0_0.Battle.BattleCameraUtil.GetInstance():StopShake()
	var0_0.Battle.BattleCameraUtil.GetInstance():Deactive()
	arg0_28._uiMediator:DisableComponent()
	arg0_28:Deactive()
end

function var2_0.reportDelayTimer(arg0_29, arg1_29, arg2_29)
	local var0_29

	local function var1_29()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_29)

		var0_29 = nil

		arg1_29()
	end

	arg0_29:RemoveAllTimer()
	pg.TimeMgr.GetInstance():ResumeBattleTimer()

	var0_29 = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, arg2_29, var1_29)
end

function var2_0.SetTakeoverProcess(arg0_31, arg1_31)
	assert(arg0_31._takeoverProcess == nil, "已经有接管的战斗过程，暂时没有定义这种逻辑")
	assert(arg1_31.Pause ~= nil and type(arg1_31.Pause) == "function", "SetTakeoverProcess附加过程，必须要有Pause函数")
	assert(arg1_31.Pause ~= nil and type(arg1_31.Resume) == "function", "SetTakeoverProcess附加过程，必须要有Pause函数")

	arg0_31._takeoverProcess = arg1_31

	arg0_31:_pause()
end

function var2_0.ClearTakeoverProcess(arg0_32)
	assert(arg0_32._takeoverProcess, "没有接管的战斗过程，暂时没有定义这种逻辑")

	arg0_32._takeoverProcess = nil

	arg0_32:_resume()
end

function var2_0.IsPause(arg0_33)
	return arg0_33._isPause
end

function var2_0.Pause(arg0_34)
	local var0_34 = arg0_34._takeoverProcess

	if var0_34 then
		var0_34.Pause()
	else
		arg0_34:_pause()
	end
end

function var2_0._pause(arg0_35)
	arg0_35:Deactive()
	arg0_35._dataProxy:PausePuzzleComponent()
	arg0_35._sceneMediator:Pause()

	if arg0_35._timeScale ~= 1 then
		arg0_35:CacheTimescaler(arg0_35._timeScale)
		arg0_35:ScaleTimer(1)
	end

	var0_0.Battle.BattleCameraUtil.GetInstance():PauseCameraTween()
end

function var2_0.Resume(arg0_36)
	if arg0_36._state == var2_0.BATTLE_STATE_IDLE then
		arg0_36:ChangeState(var2_0.BATTLE_STATE_OPENING)
		UpdateBeat:Add(arg0_36.Update, arg0_36)
	elseif arg0_36._state == var2_0.BATTLE_STATE_REPORT then
		return
	end

	local var0_36 = arg0_36._takeoverProcess

	if var0_36 then
		var0_36.Resume()
	else
		arg0_36:_resume()
	end
end

function var2_0._resume(arg0_37)
	arg0_37._sceneMediator:Resume()
	arg0_37:Active()
	arg0_37._dataProxy:ResumePuzzleComponent()

	if arg0_37._timescalerCache then
		arg0_37:ScaleTimer(arg0_37._timescalerCache)
		arg0_37:CacheTimescaler()
	end

	var0_0.Battle.BattleCameraUtil.GetInstance():ResumeCameraTween()
end

function var2_0.ScaleTimer(arg0_38, arg1_38)
	arg1_38 = arg1_38 or var0_0.Battle.BattleConfig.BASIC_TIME_SCALE

	pg.TimeMgr.GetInstance():ScaleBattleTimer(arg1_38)

	arg0_38._timeScale = arg1_38
end

function var2_0.GetTimeScaleRate(arg0_39)
	return arg0_39._timeScale or 1
end

function var2_0.CacheTimescaler(arg0_40, arg1_40)
	arg0_40._timescalerCache = arg1_40
end

function var0_0.Battle.PlayBattleSFX(arg0_41)
	if arg0_41 ~= "" then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/" .. arg0_41)
	end
end

function var2_0.OpenConsole(arg0_42)
	arg0_42._uiMediator:InitDebugConsole()
	arg0_42._uiMediator:ActiveDebugConsole()
end

function var2_0.ActiveReference(arg0_43)
	arg0_43._controllerCommand = arg0_43:AddCommand(var0_0.Battle.BattleControllerCommand.New())
end
