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
	arg0_9._battleType = arg1_9.battleType

	local var0_9 = var0_0.Battle.BattleFacadeGate.CommandGates[arg0_9._battleType] or var0_0.Battle.BattleSingleDungeonCommand

	arg0_9._battleCommand = arg0_9:AddCommand(var0_9.New())
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
		local var1_18 = getProxy(ChapterProxy)
		local var2_18 = var1_18 and var1_18:GetContinuousData(SYSTEM_SCENARIO)

		if var0_18 then
			if var2_18 then
				pg.NewStoryMgr.GetInstance():ForceAutoPlay(var0_18, function()
					arg0_18._battleCommand:DoPrologue()
				end)
			else
				pg.NewStoryMgr.GetInstance():Play(var0_18, function()
					arg0_18._battleCommand:DoPrologue()
				end)
			end
		else
			arg0_18._battleCommand:DoPrologue()
		end
	elseif arg1_18 == var2_0.BATTLE_STATE_FIGHT then
		arg0_18:ActiveAutoComponentTimer()

		if not arg0_18._dataProxy:GetFleetLegal(var0_0.Battle.BattleConfig.FRIENDLY_CODE, arg0_18:GetBattleType()) then
			arg0_18._battleCommand:CalcStatistic()
			arg0_18:BattleEnd()
		end
	elseif arg1_18 == var2_0.BATTLE_STATE_REPORT then
		-- block empty
	end
end

function var2_0.GetUI(arg0_21)
	return arg0_21._baseUI
end

function var2_0.ConfigBattleEndFunc(arg0_22, arg1_22)
	arg0_22._endFunc = arg1_22
end

function var2_0.BattleEnd(arg0_23)
	arg0_23:disableCommon()

	if arg0_23._dataProxy:GetStatistics()._battleScore >= var0_0.Battle.BattleConst.BattleScore.B then
		arg0_23._dataProxy:CelebrateVictory(arg0_23._dataProxy:GetFriendlyCode())
		arg0_23:reportDelayTimer(function()
			arg0_23:DoResult()
		end, var0_0.Battle.BattleConfig.CelebrateDuration)
	else
		arg0_23:DoResult()
	end
end

function var2_0.BattleTimeUp(arg0_25)
	arg0_25:disableCommon()
	arg0_25:ActiveEscape()
	arg0_25:reportDelayTimer(function()
		arg0_25:DeactiveEscape()
		arg0_25:DoResult()
	end, var0_0.Battle.BattleConfig.EscapeDuration)
end

function var2_0.DoResult(arg0_27)
	arg0_27._sceneMediator:PauseCharacterAction(true)
	arg0_27._dataProxy:BotPercentage(arg0_27._weaponCommand:GetBotActiveDuration())
	arg0_27._dataProxy:HPRatioStatistics()
	arg0_27._endFunc(arg0_27._dataProxy:GetStatistics())
end

function var2_0.ExitBattle(arg0_28)
	var0_0.Battle.BattleCameraUtil.GetInstance():Clear()

	for iter0_28, iter1_28 in pairs(arg0_28._mediatorList) do
		arg0_28:RemoveMediator(iter1_28)
	end

	for iter2_28, iter3_28 in pairs(arg0_28._commandList) do
		arg0_28:RemoveCommand(iter3_28)
	end

	for iter4_28, iter5_28 in pairs(arg0_28._proxyList) do
		arg0_28:RemoveProxy(iter5_28)
	end

	var0_0.Battle.BattleConfig.BASIC_TIME_SCALE = 1

	arg0_28:RemoveAllTimer()
	var0_0.Battle.BattleResourceManager.GetInstance():Clear()

	arg0_28._takeoverProcess = nil

	arg0_28:ChangeState(var2_0.BATTLE_STATE_IDLE)

	arg0_28._baseUI = nil
	arg0_28._endFunc = nil
	arg0_28._uiMediator = nil
	arg0_28._sceneMediator = nil
	arg0_28._battleCommand = nil
	arg0_28._weaponCommand = nil

	removeSingletonInstance(var0_0.Battle.BattleDataProxy)

	arg0_28._dataProxy = nil

	var0_0.Battle.BattleVariable.Clear()
	var0_0.Battle.BattleBulletFactory.DestroyFactory()
	UpdateBeat:Remove(arg0_28.Update, arg0_28)
	pg.EffectMgr.GetInstance():ClearBattleEffectMap()

	arg0_28._timeScale = nil
	arg0_28._timescalerCache = nil

	gcAll(true)
end

function var2_0.Stop(arg0_29, arg1_29)
	if arg0_29:GetBattleType() == SYSTEM_TEST then
		InDebugBattleLoop = nil

		pg.TipsMgr.GetInstance():ShowTips("interrupt")
	end

	arg0_29:disableCommon()
	arg0_29._baseUI:exitBattle(arg1_29)
end

function var2_0.disableCommon(arg0_30)
	arg0_30._weaponCommand:ActiveBot(false)
	arg0_30:ScaleTimer()
	var0_0.Battle.BattleCameraUtil.GetInstance():ResetFocus()
	arg0_30:ChangeState(var2_0.BATTLE_STATE_REPORT)
	arg0_30._dataProxy:ClearAirFighterTimer()
	arg0_30._dataProxy:KillAllAircraft()
	arg0_30._sceneMediator:AllBulletNeutralize()
	var0_0.Battle.BattleCameraUtil.GetInstance():StopShake()
	var0_0.Battle.BattleCameraUtil.GetInstance():Deactive()
	arg0_30._uiMediator:DisableComponent()
	arg0_30:Deactive()
end

function var2_0.reportDelayTimer(arg0_31, arg1_31, arg2_31)
	local var0_31

	local function var1_31()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_31)

		var0_31 = nil

		arg1_31()
	end

	arg0_31:RemoveAllTimer()
	pg.TimeMgr.GetInstance():ResumeBattleTimer()

	var0_31 = pg.TimeMgr.GetInstance():AddBattleTimer("reportDelay", -1, arg2_31, var1_31)
end

function var2_0.SetTakeoverProcess(arg0_33, arg1_33)
	assert(arg0_33._takeoverProcess == nil, "已经有接管的战斗过程，暂时没有定义这种逻辑")
	assert(arg1_33.Pause ~= nil and type(arg1_33.Pause) == "function", "SetTakeoverProcess附加过程，必须要有Pause函数")
	assert(arg1_33.Pause ~= nil and type(arg1_33.Resume) == "function", "SetTakeoverProcess附加过程，必须要有Pause函数")

	arg0_33._takeoverProcess = arg1_33

	arg0_33:_pause()
end

function var2_0.ClearTakeoverProcess(arg0_34)
	assert(arg0_34._takeoverProcess, "没有接管的战斗过程，暂时没有定义这种逻辑")

	arg0_34._takeoverProcess = nil

	arg0_34:_resume()
end

function var2_0.IsPause(arg0_35)
	return arg0_35._isPause
end

function var2_0.Pause(arg0_36)
	local var0_36 = arg0_36._takeoverProcess

	if var0_36 then
		var0_36.Pause()
	else
		arg0_36:_pause()
	end
end

function var2_0._pause(arg0_37)
	arg0_37:Deactive()
	arg0_37._dataProxy:PausePuzzleComponent()
	arg0_37._sceneMediator:Pause()

	if arg0_37._timeScale ~= 1 then
		arg0_37:CacheTimescaler(arg0_37._timeScale)
		arg0_37:ScaleTimer(1)
	end

	var0_0.Battle.BattleCameraUtil.GetInstance():PauseCameraTween()
end

function var2_0.Resume(arg0_38)
	if arg0_38._state == var2_0.BATTLE_STATE_IDLE then
		arg0_38:ChangeState(var2_0.BATTLE_STATE_OPENING)
		UpdateBeat:Add(arg0_38.Update, arg0_38)
	elseif arg0_38._state == var2_0.BATTLE_STATE_REPORT then
		return
	end

	local var0_38 = arg0_38._takeoverProcess

	if var0_38 then
		var0_38.Resume()
	else
		arg0_38:_resume()
	end
end

function var2_0._resume(arg0_39)
	arg0_39._sceneMediator:Resume()
	arg0_39:Active()
	arg0_39._dataProxy:ResumePuzzleComponent()

	if arg0_39._timescalerCache then
		arg0_39:ScaleTimer(arg0_39._timescalerCache)
		arg0_39:CacheTimescaler()
	end

	var0_0.Battle.BattleCameraUtil.GetInstance():ResumeCameraTween()
end

function var2_0.ScaleTimer(arg0_40, arg1_40)
	arg1_40 = arg1_40 or var0_0.Battle.BattleConfig.BASIC_TIME_SCALE

	pg.TimeMgr.GetInstance():ScaleBattleTimer(arg1_40)

	arg0_40._timeScale = arg1_40
end

function var2_0.GetTimeScaleRate(arg0_41)
	return arg0_41._timeScale or 1
end

function var2_0.CacheTimescaler(arg0_42, arg1_42)
	arg0_42._timescalerCache = arg1_42
end

function var0_0.Battle.PlayBattleSFX(arg0_43)
	if arg0_43 ~= "" then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/" .. arg0_43)
	end
end

function var2_0.OpenConsole(arg0_44)
	arg0_44._uiMediator:InitDebugConsole()
	arg0_44._uiMediator:ActiveDebugConsole()
end

function var2_0.ActiveReference(arg0_45)
	arg0_45._controllerCommand = arg0_45:AddCommand(var0_0.Battle.BattleControllerCommand.New())
end
