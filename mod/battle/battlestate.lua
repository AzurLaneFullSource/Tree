ys = ys or {}

local var0 = ys

var0.Battle = var0.Battle or {}

local var1 = {}

pg.bfConsts = var1
var1.DFT_CRIT_EFFECT = 1.5
var1.DFT_CRIT_RATE = 0.05
var1.SECONDs = 60
var1.PERCENT = 0.01
var1.PERCENT1 = 0.001
var1.PERCENT2 = 0.0001
var1.HUNDRED = 100
var1.SCORE_RATE = {
	0.7,
	0.8,
	0.3
}
var1.CRASH_RATE = {
	0.05,
	0.025
}
var1.SUBMARINE_KAMIKAZE = {
	80,
	3.5,
	1.5,
	1,
	0.5,
	0.5,
	1,
	0.005
}
var1.LEAK_RATE = {
	10,
	2.2,
	0.7,
	0.3,
	1,
	0.005,
	0.5
}
var1.PLANE_LEAK_RATE = {
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
var1.METEO_RATE = {
	0.05,
	20,
	0.6,
	0.4
}
var1.NUM1 = 1
var1.NUM0 = 0
var1.NUM10000 = 10000
var1.ACCURACY = {
	0.1,
	2
}
var1.DRATE = {
	25,
	0.02,
	0.0002,
	2000,
	0.1,
	0.8,
	150
}
var1.SPEED_CONST = 0.02
var1.HP_CONST = 1.5

local var2 = singletonClass("BattleState", var0.MVC.Facade)

var0.Battle.BattleState = var2
var2.__name = "BattleState"
var2.BATTLE_STATE_IDLE = "BATTLE_IDLE"
var2.BATTLE_STATE_OPENING = "BATTLE_OPENING"
var2.BATTLE_STATE_FIGHT = "BATTLE_FIGHT"
var2.BATTLE_STATE_REPORT = "BATTLE_REPORT"

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
	arg0:ChangeState(var2.BATTLE_STATE_IDLE)
end

function var2.IsAutoBotActive(arg0)
	local var0 = AutoBotCommand.GetAutoBotMark(arg0)

	return PlayerPrefs.GetInt("autoBotIsAcitve" .. var0, 0) == 1 and AutoBotCommand.autoBotSatisfied()
end

function var2.IsAutoSubActive(arg0)
	local var0 = AutoSubCommand.GetAutoSubMark(arg0)

	return PlayerPrefs.GetInt("autoSubIsAcitve" .. var0, 0) == 1
end

function var2.ChatUseable(arg0)
	local var0 = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)
	local var1 = not var0 or var0 ~= 1
	local var2 = arg0:GetBattleType()
	local var3 = arg0.IsAutoBotActive(var2)
	local var4 = var2 == SYSTEM_DUEL
	local var5 = var2 == SYSTEM_CARDPUZZLE

	return var1 and (var4 or var3) and not var5
end

function var2.GetState(arg0)
	return arg0._state
end

function var2.GetBattleType(arg0)
	return arg0._battleType
end

function var2.SetBattleUI(arg0, arg1)
	arg0._baseUI = arg1
end

function var2.EnterBattle(arg0, arg1, arg2)
	pg.TimeMgr.GetInstance():ResetCombatTime()
	arg0:Active()
	arg0:ResetTimer()

	arg0._dataProxy = arg0:AddDataProxy(var0.Battle.BattleDataProxy.GetInstance())
	arg0._uiMediator = arg0:AddMediator(var0.Battle.BattleUIMediator.New())

	if arg1.battleType == SYSTEM_DUEL then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleDuelArenaCommand.New())

		arg0._battleCommand:ConfigBattleData(arg1)
	elseif arg1.battleType == SYSTEM_CHALLENGE then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleSingleChallengeCommand.New())

		arg0._battleCommand:ConfigBattleData(arg1)
	elseif arg1.battleType == SYSTEM_DODGEM then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleDodgemCommand.New())
	elseif arg1.battleType == SYSTEM_SUBMARINE_RUN then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleSubmarineRunCommand.New())
	elseif arg1.battleType == SYSTEM_SUB_ROUTINE then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleSubRoutineCommand.New())
	elseif arg1.battleType == SYSTEM_HP_SHARE_ACT_BOSS or arg1.battleType == SYSTEM_BOSS_EXPERIMENT then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleInheritDungeonCommand.New())
	elseif arg1.battleType == SYSTEM_WORLD_BOSS then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleWorldBossCommand.New())
	elseif arg1.battleType == SYSTEM_DEBUG then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleDebugCommand.New())
	elseif arg1.battleType == SYSTEM_AIRFIGHT then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleAirFightCommand.New())
	elseif arg1.battleType == SYSTEM_GUILD then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleGuildBossCommand.New())
	elseif arg1.battleType == SYSTEM_CARDPUZZLE then
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleCardPuzzleCommand.New())
	else
		arg0._battleCommand = arg0:AddCommand(var0.Battle.BattleSingleDungeonCommand.New())
	end

	arg0._battleType = arg1.battleType
	arg0._sceneMediator = arg0:AddMediator(var0.Battle.BattleSceneMediator.New())
	arg0._weaponCommand = arg0:AddCommand(var0.Battle.BattleControllerWeaponCommand.New())

	arg0._dataProxy:InitBattle(arg1)

	if BATTLE_DEFAULT_UNIT_DETAIL then
		arg0:AddMediator(var0.Battle.BattleReferenceBoxMediator.New())
		arg0:GetMediatorByName(var0.Battle.BattleReferenceBoxMediator.__name):ActiveUnitDetail(true)
	end

	if arg2 then
		-- block empty
	else
		arg0:ChangeState(var2.BATTLE_STATE_OPENING)
		UpdateBeat:Add(arg0.Update, arg0)
	end
end

function var2.GetSceneMediator(arg0)
	return arg0._sceneMediator
end

function var2.GetUIMediator(arg0)
	return arg0._uiMediator
end

function var2.ActiveBot(arg0, arg1)
	arg0._weaponCommand:ActiveBot(arg1, true)
	arg0:EnableJoystick(not arg1)
end

function var2.EnableJoystick(arg0, arg1)
	arg0._uiMediator:EnableJoystick(arg1)
end

function var2.IsBotActive(arg0)
	return arg0._weaponCommand:GetWeaponBot():IsActive()
end

function var2.Update(arg0)
	if not arg0._isPause then
		for iter0, iter1 in pairs(arg0._mediatorList) do
			iter1:Update()
		end
	else
		for iter2, iter3 in pairs(arg0._mediatorList) do
			iter3:UpdatePause()
		end
	end
end

function var2.GenerateVertifyData(arg0)
	return
end

function var2.Vertify()
	return true, -1
end

function var2.ChangeState(arg0, arg1)
	arg0._state = arg1

	if arg1 == var2.BATTLE_STATE_OPENING then
		arg0._dataProxy:Start()

		local var0 = arg0._dataProxy._dungeonInfo.beginStoy

		if var0 then
			pg.NewStoryMgr.GetInstance():Play(var0, function()
				arg0._battleCommand:DoPrologue()
			end)
		else
			arg0._battleCommand:DoPrologue()
		end
	elseif arg1 == var2.BATTLE_STATE_FIGHT then
		arg0:ActiveAutoComponentTimer()
	elseif arg1 == var2.BATTLE_STATE_REPORT then
		-- block empty
	end
end

function var2.GetUI(arg0)
	return arg0._baseUI
end

function var2.ConfigBattleEndFunc(arg0, arg1)
	arg0._endFunc = arg1
end

function var2.BattleEnd(arg0)
	arg0:disableCommon()

	if arg0._dataProxy:GetStatistics()._battleScore >= var0.Battle.BattleConst.BattleScore.B then
		arg0._dataProxy:CelebrateVictory(arg0._dataProxy:GetFriendlyCode())
		arg0:reportDelayTimer(function()
			arg0:DoResult()
		end, var0.Battle.BattleConfig.CelebrateDuration)
	else
		arg0:DoResult()
	end
end

function var2.BattleTimeUp(arg0)
	arg0:disableCommon()
	arg0:ActiveEscape()
	arg0:reportDelayTimer(function()
		arg0:DeactiveEscape()
		arg0:DoResult()
	end, var0.Battle.BattleConfig.EscapeDuration)
end

function var2.DoResult(arg0)
	arg0._sceneMediator:PauseCharacterAction(true)
	arg0._dataProxy:BotPercentage(arg0._weaponCommand:GetBotActiveDuration())
	arg0._dataProxy:HPRatioStatistics()
	arg0._endFunc(arg0._dataProxy:GetStatistics())
end

function var2.ExitBattle(arg0)
	var0.Battle.BattleCameraUtil.GetInstance():Clear()

	for iter0, iter1 in pairs(arg0._mediatorList) do
		arg0:RemoveMediator(iter1)
	end

	for iter2, iter3 in pairs(arg0._commandList) do
		arg0:RemoveCommand(iter3)
	end

	for iter4, iter5 in pairs(arg0._proxyList) do
		arg0:RemoveProxy(iter5)
	end

	var0.Battle.BattleConfig.BASIC_TIME_SCALE = 1

	arg0:RemoveAllTimer()
	var0.Battle.BattleResourceManager.GetInstance():Clear()

	arg0._takeoverProcess = nil

	arg0:ChangeState(var2.BATTLE_STATE_IDLE)

	arg0._baseUI = nil
	arg0._endFunc = nil
	arg0._uiMediator = nil
	arg0._sceneMediator = nil
	arg0._battleCommand = nil
	arg0._weaponCommand = nil

	removeSingletonInstance(var0.Battle.BattleDataProxy)

	arg0._dataProxy = nil

	var0.Battle.BattleVariable.Clear()
	var0.Battle.BattleBulletFactory.DestroyFactory()
	UpdateBeat:Remove(arg0.Update, arg0)
	pg.EffectMgr.GetInstance():ClearBattleEffectMap()

	arg0._timeScale = nil
	arg0._timescalerCache = nil

	gcAll(true)
end

function var2.Stop(arg0, arg1)
	arg0:disableCommon()
	arg0._baseUI:exitBattle(arg1)
end

function var2.disableCommon(arg0)
	arg0._weaponCommand:ActiveBot(false)
	arg0:ScaleTimer()
	var0.Battle.BattleCameraUtil.GetInstance():ResetFocus()
	arg0:ChangeState(var2.BATTLE_STATE_REPORT)
	arg0._dataProxy:ClearAirFighterTimer()
	arg0._dataProxy:KillAllAircraft()
	arg0._sceneMediator:AllBulletNeutralize()
	var0.Battle.BattleCameraUtil.GetInstance():StopShake()
	var0.Battle.BattleCameraUtil.GetInstance():Deactive()
	arg0._uiMediator:DisableComponent()
	arg0:Deactive()
end

function var2.reportDelayTimer(arg0, arg1, arg2)
	local var0

	local function var1()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0)

		var0 = nil

		arg1()
	end

	arg0:RemoveAllTimer()
	pg.TimeMgr.GetInstance():ResumeBattleTimer()

	var0 = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, arg2, var1)
end

function var2.SetTakeoverProcess(arg0, arg1)
	assert(arg0._takeoverProcess == nil, "已经有接管的战斗过程，暂时没有定义这种逻辑")
	assert(arg1.Pause ~= nil and type(arg1.Pause) == "function", "SetTakeoverProcess附加过程，必须要有Pause函数")
	assert(arg1.Pause ~= nil and type(arg1.Resume) == "function", "SetTakeoverProcess附加过程，必须要有Pause函数")

	arg0._takeoverProcess = arg1

	arg0:_pause()
end

function var2.ClearTakeoverProcess(arg0)
	assert(arg0._takeoverProcess, "没有接管的战斗过程，暂时没有定义这种逻辑")

	arg0._takeoverProcess = nil

	arg0:_resume()
end

function var2.IsPause(arg0)
	return arg0._isPause
end

function var2.Pause(arg0)
	local var0 = arg0._takeoverProcess

	if var0 then
		var0.Pause()
	else
		arg0:_pause()
	end
end

function var2._pause(arg0)
	arg0:Deactive()
	arg0._dataProxy:PausePuzzleComponent()
	arg0._sceneMediator:Pause()

	if arg0._timeScale ~= 1 then
		arg0:CacheTimescaler(arg0._timeScale)
		arg0:ScaleTimer(1)
	end

	var0.Battle.BattleCameraUtil.GetInstance():PauseCameraTween()
end

function var2.Resume(arg0)
	if arg0._state == var2.BATTLE_STATE_IDLE then
		arg0:ChangeState(var2.BATTLE_STATE_OPENING)
		UpdateBeat:Add(arg0.Update, arg0)
	elseif arg0._state == var2.BATTLE_STATE_REPORT then
		return
	end

	local var0 = arg0._takeoverProcess

	if var0 then
		var0.Resume()
	else
		arg0:_resume()
	end
end

function var2._resume(arg0)
	arg0._sceneMediator:Resume()
	arg0:Active()
	arg0._dataProxy:ResumePuzzleComponent()

	if arg0._timescalerCache then
		arg0:ScaleTimer(arg0._timescalerCache)
		arg0:CacheTimescaler()
	end

	var0.Battle.BattleCameraUtil.GetInstance():ResumeCameraTween()
end

function var2.ScaleTimer(arg0, arg1)
	arg1 = arg1 or var0.Battle.BattleConfig.BASIC_TIME_SCALE

	pg.TimeMgr.GetInstance():ScaleBattleTimer(arg1)

	arg0._timeScale = arg1
end

function var2.GetTimeScaleRate(arg0)
	return arg0._timeScale or 1
end

function var2.CacheTimescaler(arg0, arg1)
	arg0._timescalerCache = arg1
end

function var0.Battle.PlayBattleSFX(arg0)
	if arg0 ~= "" then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/" .. arg0)
	end
end

function var2.OpenConsole(arg0)
	arg0._uiMediator:InitDebugConsole()
	arg0._uiMediator:ActiveDebugConsole()
end

function var2.ActiveReference(arg0)
	arg0._controllerCommand = arg0:AddCommand(var0.Battle.BattleControllerCommand.New())
end
