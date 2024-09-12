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

function var2_0.GetCombatSkinKey()
	return COMBAT_SKIN_KEY or "Standard"
end

function var2_0.IsAutoBotActive(arg0_3)
	local var0_3 = AutoBotCommand.GetAutoBotMark(arg0_3)

	return PlayerPrefs.GetInt("autoBotIsAcitve" .. var0_3, 0) == 1 and AutoBotCommand.autoBotSatisfied()
end

function var2_0.IsAutoSubActive(arg0_4)
	local var0_4 = AutoSubCommand.GetAutoSubMark(arg0_4)

	return PlayerPrefs.GetInt("autoSubIsAcitve" .. var0_4, 0) == 1
end

function var2_0.ChatUseable(arg0_5)
	local var0_5 = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)
	local var1_5 = not var0_5 or var0_5 ~= 1
	local var2_5 = arg0_5:GetBattleType()
	local var3_5 = arg0_5.IsAutoBotActive(var2_5)
	local var4_5 = var2_5 == SYSTEM_DUEL
	local var5_5 = var2_5 == SYSTEM_CARDPUZZLE

	return var1_5 and (var4_5 or var3_5) and not var5_5
end

function var2_0.GetState(arg0_6)
	return arg0_6._state
end

function var2_0.GetBattleType(arg0_7)
	return arg0_7._battleType
end

function var2_0.SetBattleUI(arg0_8, arg1_8)
	arg0_8._baseUI = arg1_8
end

function var2_0.EnterBattle(arg0_9, arg1_9, arg2_9)
	pg.TimeMgr.GetInstance():ResetCombatTime()
	arg0_9:Active()
	arg0_9:ResetTimer()

	arg0_9._dataProxy = arg0_9:AddDataProxy(var0_0.Battle.BattleDataProxy.GetInstance())
	arg0_9._uiMediator = arg0_9:AddMediator(var0_0.Battle.BattleUIMediator.New())

	if arg1_9.battleType == SYSTEM_DUEL then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleDuelArenaCommand.New())

		arg0_9._battleCommand:ConfigBattleData(arg1_9)
	elseif arg1_9.battleType == SYSTEM_CHALLENGE then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleSingleChallengeCommand.New())

		arg0_9._battleCommand:ConfigBattleData(arg1_9)
	elseif arg1_9.battleType == SYSTEM_DODGEM then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleDodgemCommand.New())
	elseif arg1_9.battleType == SYSTEM_SUBMARINE_RUN then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleSubmarineRunCommand.New())
	elseif arg1_9.battleType == SYSTEM_SUB_ROUTINE then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleSubRoutineCommand.New())
	elseif arg1_9.battleType == SYSTEM_HP_SHARE_ACT_BOSS or arg1_9.battleType == SYSTEM_BOSS_EXPERIMENT then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleInheritDungeonCommand.New())
	elseif arg1_9.battleType == SYSTEM_WORLD_BOSS then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleWorldBossCommand.New())
	elseif arg1_9.battleType == SYSTEM_DEBUG then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleDebugCommand.New())
	elseif arg1_9.battleType == SYSTEM_AIRFIGHT then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleAirFightCommand.New())
	elseif arg1_9.battleType == SYSTEM_GUILD then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleGuildBossCommand.New())
	elseif arg1_9.battleType == SYSTEM_CARDPUZZLE then
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleCardPuzzleCommand.New())
	else
		arg0_9._battleCommand = arg0_9:AddCommand(var0_0.Battle.BattleSingleDungeonCommand.New())
	end

	arg0_9._battleType = arg1_9.battleType
	arg0_9._sceneMediator = arg0_9:AddMediator(var0_0.Battle.BattleSceneMediator.New())
	arg0_9._weaponCommand = arg0_9:AddCommand(var0_0.Battle.BattleControllerWeaponCommand.New())

	arg0_9._dataProxy:InitBattle(arg1_9)

	if BATTLE_DEFAULT_UNIT_DETAIL then
		arg0_9:AddMediator(var0_0.Battle.BattleReferenceBoxMediator.New())
		arg0_9:GetMediatorByName(var0_0.Battle.BattleReferenceBoxMediator.__name):ActiveUnitDetail(true)
	end

	if arg2_9 then
		-- block empty
	else
		arg0_9:ChangeState(var2_0.BATTLE_STATE_OPENING)
		UpdateBeat:Add(arg0_9.Update, arg0_9)
	end
end

function var2_0.GetSceneMediator(arg0_10)
	return arg0_10._sceneMediator
end

function var2_0.GetUIMediator(arg0_11)
	return arg0_11._uiMediator
end

function var2_0.ActiveBot(arg0_12, arg1_12)
	arg0_12._weaponCommand:ActiveBot(arg1_12, true)
	arg0_12:EnableJoystick(not arg1_12)
end

function var2_0.EnableJoystick(arg0_13, arg1_13)
	arg0_13._uiMediator:EnableJoystick(arg1_13)
end

function var2_0.IsBotActive(arg0_14)
	return arg0_14._weaponCommand:GetWeaponBot():IsActive()
end

function var2_0.Update(arg0_15)
	if not arg0_15._isPause then
		for iter0_15, iter1_15 in pairs(arg0_15._mediatorList) do
			iter1_15:Update()
		end
	else
		for iter2_15, iter3_15 in pairs(arg0_15._mediatorList) do
			iter3_15:UpdatePause()
		end
	end
end

function var2_0.GenerateVertifyData(arg0_16)
	return
end

function var2_0.Vertify()
	return true, -1
end

function var2_0.ChangeState(arg0_18, arg1_18)
	arg0_18._state = arg1_18

	if arg1_18 == var2_0.BATTLE_STATE_OPENING then
		arg0_18._dataProxy:Start()

		local var0_18 = arg0_18._dataProxy._dungeonInfo.beginStoy

		if var0_18 then
			pg.NewStoryMgr.GetInstance():Play(var0_18, function()
				arg0_18._battleCommand:DoPrologue()
			end)
		else
			arg0_18._battleCommand:DoPrologue()
		end
	elseif arg1_18 == var2_0.BATTLE_STATE_FIGHT then
		arg0_18:ActiveAutoComponentTimer()
	elseif arg1_18 == var2_0.BATTLE_STATE_REPORT then
		-- block empty
	end
end

function var2_0.GetUI(arg0_20)
	return arg0_20._baseUI
end

function var2_0.ConfigBattleEndFunc(arg0_21, arg1_21)
	arg0_21._endFunc = arg1_21
end

function var2_0.BattleEnd(arg0_22)
	arg0_22:disableCommon()

	if arg0_22._dataProxy:GetStatistics()._battleScore >= var0_0.Battle.BattleConst.BattleScore.B then
		arg0_22._dataProxy:CelebrateVictory(arg0_22._dataProxy:GetFriendlyCode())
		arg0_22:reportDelayTimer(function()
			arg0_22:DoResult()
		end, var0_0.Battle.BattleConfig.CelebrateDuration)
	else
		arg0_22:DoResult()
	end
end

function var2_0.BattleTimeUp(arg0_24)
	arg0_24:disableCommon()
	arg0_24:ActiveEscape()
	arg0_24:reportDelayTimer(function()
		arg0_24:DeactiveEscape()
		arg0_24:DoResult()
	end, var0_0.Battle.BattleConfig.EscapeDuration)
end

function var2_0.DoResult(arg0_26)
	arg0_26._sceneMediator:PauseCharacterAction(true)
	arg0_26._dataProxy:BotPercentage(arg0_26._weaponCommand:GetBotActiveDuration())
	arg0_26._dataProxy:HPRatioStatistics()
	arg0_26._endFunc(arg0_26._dataProxy:GetStatistics())
end

function var2_0.ExitBattle(arg0_27)
	var0_0.Battle.BattleCameraUtil.GetInstance():Clear()

	for iter0_27, iter1_27 in pairs(arg0_27._mediatorList) do
		arg0_27:RemoveMediator(iter1_27)
	end

	for iter2_27, iter3_27 in pairs(arg0_27._commandList) do
		arg0_27:RemoveCommand(iter3_27)
	end

	for iter4_27, iter5_27 in pairs(arg0_27._proxyList) do
		arg0_27:RemoveProxy(iter5_27)
	end

	var0_0.Battle.BattleConfig.BASIC_TIME_SCALE = 1

	arg0_27:RemoveAllTimer()
	var0_0.Battle.BattleResourceManager.GetInstance():Clear()

	arg0_27._takeoverProcess = nil

	arg0_27:ChangeState(var2_0.BATTLE_STATE_IDLE)

	arg0_27._baseUI = nil
	arg0_27._endFunc = nil
	arg0_27._uiMediator = nil
	arg0_27._sceneMediator = nil
	arg0_27._battleCommand = nil
	arg0_27._weaponCommand = nil

	removeSingletonInstance(var0_0.Battle.BattleDataProxy)

	arg0_27._dataProxy = nil

	var0_0.Battle.BattleVariable.Clear()
	var0_0.Battle.BattleBulletFactory.DestroyFactory()
	UpdateBeat:Remove(arg0_27.Update, arg0_27)
	pg.EffectMgr.GetInstance():ClearBattleEffectMap()

	arg0_27._timeScale = nil
	arg0_27._timescalerCache = nil

	gcAll(true)
end

function var2_0.Stop(arg0_28, arg1_28)
	arg0_28:disableCommon()
	arg0_28._baseUI:exitBattle(arg1_28)
end

function var2_0.disableCommon(arg0_29)
	arg0_29._weaponCommand:ActiveBot(false)
	arg0_29:ScaleTimer()
	var0_0.Battle.BattleCameraUtil.GetInstance():ResetFocus()
	arg0_29:ChangeState(var2_0.BATTLE_STATE_REPORT)
	arg0_29._dataProxy:ClearAirFighterTimer()
	arg0_29._dataProxy:KillAllAircraft()
	arg0_29._sceneMediator:AllBulletNeutralize()
	var0_0.Battle.BattleCameraUtil.GetInstance():StopShake()
	var0_0.Battle.BattleCameraUtil.GetInstance():Deactive()
	arg0_29._uiMediator:DisableComponent()
	arg0_29:Deactive()
end

function var2_0.reportDelayTimer(arg0_30, arg1_30, arg2_30)
	local var0_30

	local function var1_30()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_30)

		var0_30 = nil

		arg1_30()
	end

	arg0_30:RemoveAllTimer()
	pg.TimeMgr.GetInstance():ResumeBattleTimer()

	var0_30 = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, arg2_30, var1_30)
end

function var2_0.SetTakeoverProcess(arg0_32, arg1_32)
	assert(arg0_32._takeoverProcess == nil, "已经有接管的战斗过程，暂时没有定义这种逻辑")
	assert(arg1_32.Pause ~= nil and type(arg1_32.Pause) == "function", "SetTakeoverProcess附加过程，必须要有Pause函数")
	assert(arg1_32.Pause ~= nil and type(arg1_32.Resume) == "function", "SetTakeoverProcess附加过程，必须要有Pause函数")

	arg0_32._takeoverProcess = arg1_32

	arg0_32:_pause()
end

function var2_0.ClearTakeoverProcess(arg0_33)
	assert(arg0_33._takeoverProcess, "没有接管的战斗过程，暂时没有定义这种逻辑")

	arg0_33._takeoverProcess = nil

	arg0_33:_resume()
end

function var2_0.IsPause(arg0_34)
	return arg0_34._isPause
end

function var2_0.Pause(arg0_35)
	local var0_35 = arg0_35._takeoverProcess

	if var0_35 then
		var0_35.Pause()
	else
		arg0_35:_pause()
	end
end

function var2_0._pause(arg0_36)
	arg0_36:Deactive()
	arg0_36._dataProxy:PausePuzzleComponent()
	arg0_36._sceneMediator:Pause()

	if arg0_36._timeScale ~= 1 then
		arg0_36:CacheTimescaler(arg0_36._timeScale)
		arg0_36:ScaleTimer(1)
	end

	var0_0.Battle.BattleCameraUtil.GetInstance():PauseCameraTween()
end

function var2_0.Resume(arg0_37)
	if arg0_37._state == var2_0.BATTLE_STATE_IDLE then
		arg0_37:ChangeState(var2_0.BATTLE_STATE_OPENING)
		UpdateBeat:Add(arg0_37.Update, arg0_37)
	elseif arg0_37._state == var2_0.BATTLE_STATE_REPORT then
		return
	end

	local var0_37 = arg0_37._takeoverProcess

	if var0_37 then
		var0_37.Resume()
	else
		arg0_37:_resume()
	end
end

function var2_0._resume(arg0_38)
	arg0_38._sceneMediator:Resume()
	arg0_38:Active()
	arg0_38._dataProxy:ResumePuzzleComponent()

	if arg0_38._timescalerCache then
		arg0_38:ScaleTimer(arg0_38._timescalerCache)
		arg0_38:CacheTimescaler()
	end

	var0_0.Battle.BattleCameraUtil.GetInstance():ResumeCameraTween()
end

function var2_0.ScaleTimer(arg0_39, arg1_39)
	arg1_39 = arg1_39 or var0_0.Battle.BattleConfig.BASIC_TIME_SCALE

	pg.TimeMgr.GetInstance():ScaleBattleTimer(arg1_39)

	arg0_39._timeScale = arg1_39
end

function var2_0.GetTimeScaleRate(arg0_40)
	return arg0_40._timeScale or 1
end

function var2_0.CacheTimescaler(arg0_41, arg1_41)
	arg0_41._timescalerCache = arg1_41
end

function var0_0.Battle.PlayBattleSFX(arg0_42)
	if arg0_42 ~= "" then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/" .. arg0_42)
	end
end

function var2_0.OpenConsole(arg0_43)
	arg0_43._uiMediator:InitDebugConsole()
	arg0_43._uiMediator:ActiveDebugConsole()
end

function var2_0.ActiveReference(arg0_44)
	arg0_44._controllerCommand = arg0_44:AddCommand(var0_0.Battle.BattleControllerCommand.New())
end
