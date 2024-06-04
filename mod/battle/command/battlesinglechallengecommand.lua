ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleDataFunction
local var4 = class("BattleSingleChallengeCommand", var0.Battle.BattleSingleDungeonCommand)

var0.Battle.BattleSingleChallengeCommand = var4
var4.__name = "BattleSingleChallengeCommand"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)

	arg0._challengeConst = var0.Battle.BattleConfig.CHALLENGE_ENHANCE
end

function var4.ConfigBattleData(arg0, arg1)
	arg0._challengeInfo = arg1.ChallengeInfo
end

function var4.onInitBattle(arg0)
	var4.super.onInitBattle(arg0)

	local var0 = arg0._dataProxy:GetInitData().ChallengeInfo:getRound()

	arg0._enhancemntP = math.max(var0 - arg0._challengeConst.K, 0)
	arg0._enhancemntPPercent = arg0._enhancemntP * 0.01

	local var1 = arg0._challengeConst.A * arg0._enhancemntP
	local var2 = arg0._dataProxy:GetDungeonLevel()

	arg0._dataProxy:SetDungeonLevel(var2 + var1)

	arg0._enahanceDURAttr = arg0._challengeConst.X1 * arg0._enhancemntPPercent
	arg0._enahanceATKAttr = arg0._challengeConst.X2 * arg0._enhancemntPPercent
	arg0._enahanceEVDAttr = arg0._challengeConst.Y1 * arg0._enhancemntP
	arg0._enahanceLUKAttr = arg0._challengeConst.Y2 * arg0._enhancemntP
end

function var4.initWaveModule(arg0)
	local var0 = function(arg0, arg1, arg2)
		local var0 = arg0._dataProxy:SpawnMonster(arg0, arg1, arg2, var0.Battle.BattleConfig.FOE_CODE, function(arg0)
			arg0:monsterEnhance(arg0)
		end)
	end

	local function var1(arg0)
		arg0._dataProxy:SpawnAirFighter(arg0)
	end

	local function var2()
		if arg0._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0._vertifyFail
			})

			return
		end

		arg0._dataProxy:CalcChallengeScore(true)
		arg0._state:BattleEnd()
	end

	local function var3(arg0, arg1, arg2, arg3, arg4)
		arg0._dataProxy:SpawnCubeArea(var0.Battle.BattleConst.AOEField.SURFACE, -1, arg0, arg1, arg2, arg3, arg4)
	end

	arg0._waveUpdater = var0.Battle.BattleWaveUpdater.New(var0, var1, var2, var3)
end

function var4.DoPrologue(arg0)
	pg.UIMgr.GetInstance():Marching()

	local var0 = function()
		arg0._uiMediator:OpeningEffect(function()
			local var0 = getProxy(PlayerProxy)

			arg0._uiMediator:ShowAutoBtn()
			arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0._uiMediator:ShowTimer()
			arg0._state:GetCommandByName(var0.Battle.BattleControllerWeaponCommand.__name):TryAutoSub()
			arg0._waveUpdater:Start()
		end)
		arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE):FleetWarcry()
		arg0._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0._dataProxy:TirggerBattleStartBuffs()

		arg0._challengeStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end

	arg0._uiMediator:SeaSurfaceShift(45, 0, nil, var0)
end

function var4.onPlayerShutDown(arg0, arg1)
	if arg0._state:GetState() ~= arg0._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg1.Data.unit == arg0._userFleet:GetFlagShip() then
		arg0._dataProxy:CalcChallengeScore(false)
		arg0._state:BattleEnd()

		return
	end

	if #arg0._userFleet:GetScoutList() == 0 then
		arg0._dataProxy:CalcChallengeScore(false)
		arg0._state:BattleEnd()
	end
end

function var4.onUpdateCountDown(arg0, arg1)
	if arg0._dataProxy:GetCountDown() <= 0 then
		arg0._dataProxy:CalcChallengeScore(false)
		arg0._state:BattleEnd()
	end
end

function var4.monsterEnhance(arg0, arg1)
	var0.Battle.BattleAttr.FlashByBuff(arg1, "maxHP", arg0._enahanceDURAttr)
	var0.Battle.BattleAttr.FlashByBuff(arg1, "cannonPower", arg0._enahanceATKAttr)
	var0.Battle.BattleAttr.FlashByBuff(arg1, "torpedoPower", arg0._enahanceATKAttr)
	var0.Battle.BattleAttr.FlashByBuff(arg1, "airPower", arg0._enahanceATKAttr)
	var0.Battle.BattleAttr.FlashByBuff(arg1, "dodgeRate", arg0._enahanceEVDAttr)
	var0.Battle.BattleAttr.FlashByBuff(arg1, "luck", arg0._enahanceLUKAttr)
end
