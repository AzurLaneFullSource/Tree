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

function var4_0.ConfigBattleData(arg0_2, arg1_2)
	arg0_2._challengeInfo = arg1_2.ChallengeInfo
end

function var4_0.onInitBattle(arg0_3)
	var4_0.super.onInitBattle(arg0_3)

	local var0_3 = arg0_3._dataProxy:GetInitData().ChallengeInfo:getRound()

	arg0_3._enhancemntP = math.max(var0_3 - arg0_3._challengeConst.K, 0)
	arg0_3._enhancemntPPercent = arg0_3._enhancemntP * 0.01

	local var1_3 = arg0_3._challengeConst.A * arg0_3._enhancemntP
	local var2_3 = arg0_3._dataProxy:GetDungeonLevel()

	arg0_3._dataProxy:SetDungeonLevel(var2_3 + var1_3)

	arg0_3._enahanceDURAttr = arg0_3._challengeConst.X1 * arg0_3._enhancemntPPercent
	arg0_3._enahanceATKAttr = arg0_3._challengeConst.X2 * arg0_3._enhancemntPPercent
	arg0_3._enahanceEVDAttr = arg0_3._challengeConst.Y1 * arg0_3._enhancemntP
	arg0_3._enahanceLUKAttr = arg0_3._challengeConst.Y2 * arg0_3._enhancemntP
end

function var4_0.initWaveModule(arg0_4)
	local function var0_4(arg0_5, arg1_5, arg2_5)
		local var0_5 = arg0_4._dataProxy:SpawnMonster(arg0_5, arg1_5, arg2_5, var0_0.Battle.BattleConfig.FOE_CODE, function(arg0_6)
			arg0_4:monsterEnhance(arg0_6)
		end)
	end

	local function var1_4(arg0_7)
		arg0_4._dataProxy:SpawnAirFighter(arg0_7)
	end

	local function var2_4()
		if arg0_4._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_4._vertifyFail
			})

			return
		end

		arg0_4._dataProxy:CalcChallengeScore(true)
		arg0_4._state:BattleEnd()
	end

	local function var3_4(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
		arg0_4._dataProxy:SpawnCubeArea(var0_0.Battle.BattleConst.AOEField.SURFACE, -1, arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	end

	arg0_4._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_4, var1_4, var2_4, var3_4)
end

function var4_0.DoPrologue(arg0_10)
	pg.UIMgr.GetInstance():Marching()

	local function var0_10()
		arg0_10._uiMediator:OpeningEffect(function()
			local var0_12 = getProxy(PlayerProxy)

			arg0_10._uiMediator:ShowAutoBtn()
			arg0_10._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_10._uiMediator:ShowTimer()
			arg0_10._state:GetCommandByName(var0_0.Battle.BattleControllerWeaponCommand.__name):TryAutoSub()
			arg0_10._waveUpdater:Start()
		end)
		arg0_10._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE):FleetWarcry()
		arg0_10._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0_10._dataProxy:TirggerBattleStartBuffs()

		arg0_10._challengeStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end

	arg0_10._uiMediator:SeaSurfaceShift(45, 0, nil, var0_10)
end

function var4_0.onPlayerShutDown(arg0_13, arg1_13)
	if arg0_13._state:GetState() ~= arg0_13._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg1_13.Data.unit == arg0_13._userFleet:GetFlagShip() then
		arg0_13._dataProxy:CalcChallengeScore(false)
		arg0_13._state:BattleEnd()

		return
	end

	if #arg0_13._userFleet:GetScoutList() == 0 then
		arg0_13._dataProxy:CalcChallengeScore(false)
		arg0_13._state:BattleEnd()
	end
end

function var4_0.onUpdateCountDown(arg0_14, arg1_14)
	if arg0_14._dataProxy:GetCountDown() <= 0 then
		arg0_14._dataProxy:CalcChallengeScore(false)
		arg0_14._state:BattleEnd()
	end
end

function var4_0.monsterEnhance(arg0_15, arg1_15)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_15, "maxHP", arg0_15._enahanceDURAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_15, "cannonPower", arg0_15._enahanceATKAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_15, "torpedoPower", arg0_15._enahanceATKAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_15, "airPower", arg0_15._enahanceATKAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_15, "dodgeRate", arg0_15._enahanceEVDAttr)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_15, "luck", arg0_15._enahanceLUKAttr)
end
