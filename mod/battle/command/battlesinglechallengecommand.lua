ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleDataFunction
local var4_0 = class("BattleSingleChallengeCommand", var0_0.Battle.BattleSingleDungeonCommand)

var0_0.Battle.BattleSingleChallengeCommand = var4_0
var4_0.__name = "BattleSingleChallengeCommand"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)

	arg0_1._challengeConst = var0_0.Battle.BattleConfig.CHALLENGE_ENHANCE
end

function var4_0.onInitBattle(arg0_2)
	var4_0.super.onInitBattle(arg0_2)

	local var0_2 = arg0_2._dataProxy:GetInitData().ChallengeInfo:getRound()

	arg0_2._enhancemntP = math.max(var0_2 - arg0_2._challengeConst.K, 0)
	arg0_2._enhancemntPPercent = arg0_2._enhancemntP * 0.01

	local var1_2 = arg0_2._challengeConst.A * arg0_2._enhancemntP
	local var2_2 = arg0_2._dataProxy:GetDungeonLevel()

	arg0_2._dataProxy:SetDungeonLevel(var2_2 + var1_2)

	arg0_2._enahanceDURAttr = arg0_2._challengeConst.X1 * arg0_2._enhancemntPPercent
	arg0_2._enahanceATKAttr = arg0_2._challengeConst.X2 * arg0_2._enhancemntPPercent
	arg0_2._enahanceEVDAttr = arg0_2._challengeConst.Y1 * arg0_2._enhancemntP
	arg0_2._enahanceLUKAttr = arg0_2._challengeConst.Y2 * arg0_2._enhancemntP
end

function var4_0.initWaveModule(arg0_3)
	local function var0_3(arg0_4, arg1_4, arg2_4)
		local var0_4 = arg0_3._dataProxy:SpawnMonster(arg0_4, arg1_4, arg2_4, var0_0.Battle.BattleConfig.FOE_CODE, function(arg0_5)
			arg0_3:monsterEnhance(arg0_5)
		end)
	end

	local function var1_3(arg0_6)
		arg0_3._dataProxy:SpawnAirFighter(arg0_6)
	end

	local function var2_3()
		if arg0_3._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_3._vertifyFail
			})

			return
		end

		arg0_3._dataProxy:TriggerFinishBattle()
		arg0_3._dataProxy:CalcChallengeScore(true)
		arg0_3._state:BattleEnd()
	end

	local function var3_3(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
		arg0_3._dataProxy:SpawnCubeArea(var0_0.Battle.BattleConst.AOEField.SURFACE, -1, arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	end

	arg0_3._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_3, var1_3, var2_3, var3_3)
end

function var4_0.DoPrologue(arg0_9)
	pg.UIMgr.GetInstance():Marching()

	local function var0_9()
		arg0_9._uiMediator:OpeningEffect(function()
			local var0_11 = getProxy(PlayerProxy)

			arg0_9._uiMediator:ShowAutoBtn()
			arg0_9._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_9._uiMediator:ShowTimer()
			arg0_9._state:GetCommandByName(var0_0.Battle.BattleControllerWeaponCommand.__name):TryAutoSub()
			arg0_9._waveUpdater:Start()
		end)
		arg0_9._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE):FleetWarcry()
		arg0_9._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0_9._dataProxy:TirggerBattleStartBuffs()

		arg0_9._challengeStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end

	arg0_9._uiMediator:SeaSurfaceShift(45, 0, nil, var0_9)
end

function var4_0.onPlayerShutDown(arg0_12, arg1_12)
	if arg0_12._state:GetState() ~= arg0_12._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg1_12.Data.unit == arg0_12._userFleet:GetFlagShip() then
		arg0_12._dataProxy:TriggerFinishBattle()
		arg0_12._dataProxy:CalcChallengeScore(false)
		arg0_12._state:BattleEnd()

		return
	end

	if #arg0_12._userFleet:GetScoutList() == 0 then
		arg0_12._dataProxy:TriggerFinishBattle()
		arg0_12._dataProxy:CalcChallengeScore(false)
		arg0_12._state:BattleEnd()
	end
end

function var4_0.onUpdateCountDown(arg0_13, arg1_13)
	if arg0_13._dataProxy:GetCountDown() <= 0 then
		arg0_13._dataProxy:TriggerFinishBattle()
		arg0_13._dataProxy:CalcChallengeScore(false)
		arg0_13._state:BattleEnd()
	end
end

function var4_0.monsterEnhance(arg0_14, arg1_14)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_14, "maxHP", arg0_14._enahanceDURAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_14, "cannonPower", arg0_14._enahanceATKAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_14, "torpedoPower", arg0_14._enahanceATKAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_14, "airPower", arg0_14._enahanceATKAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_14, "dodgeRate", arg0_14._enahanceEVDAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_14, "luck", arg0_14._enahanceLUKAttr)
end
