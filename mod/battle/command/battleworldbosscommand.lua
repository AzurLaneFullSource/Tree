ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = class("BattleWorldBossCommand", var0.Battle.BattleSingleDungeonCommand)

var0.Battle.BattleWorldBossCommand = var3
var3.__name = "BattleWorldBossCommand"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.initWaveModule(arg0)
	local var0 = function(arg0, arg1, arg2)
		arg0._dataProxy:SpawnMonster(arg0, arg1, arg2, var0.Battle.BattleConfig.FOE_CODE)
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

		arg0:CalcStatistic()
		arg0:calcDamageData()
		arg0._state:BattleEnd()
	end

	local function var3(arg0, arg1, arg2, arg3, arg4)
		arg0._dataProxy:SpawnCubeArea(var0.Battle.BattleConst.AOEField.SURFACE, -1, arg0, arg1, arg2, arg3, arg4)
	end

	arg0._waveUpdater = var0.Battle.BattleWaveUpdater.New(var0, var1, var2, var3)
end

function var3.onInitBattle(arg0)
	var3.super.onInitBattle(arg0)

	local var0 = arg0._dataProxy:GetInitData()

	arg0._specificEnemyList = var0.Battle.BattleDataFunction.GetSpecificWorldJointEnemyList(var0.ActID, var0.bossConfigId, var0.bossLevel)
end

function var3.onAddUnit(arg0, arg1)
	var3.super.onAddUnit(arg0, arg1)

	local var0 = arg1.Data.unit

	if table.contains(arg0._specificEnemyList, var0:GetTemplateID()) then
		arg0._dataProxy:InitSpecificEnemyStatistics(var0)
	end
end

function var3.onPlayerShutDown(arg0, arg1)
	if arg0._state:GetState() ~= arg0._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg1.Data.unit == arg0._userFleet:GetFlagShip() and arg0._dataProxy:GetInitData().battleType ~= SYSTEM_PROLOGUE and arg0._dataProxy:GetInitData().battleType ~= SYSTEM_PERFORM then
		arg0:CalcStatistic()
		arg0:calcDamageData()
		arg0._state:BattleEnd()

		return
	end

	if #arg0._userFleet:GetScoutList() == 0 then
		arg0:CalcStatistic()
		arg0:calcDamageData()
		arg0._state:BattleEnd()
	end
end

function var3.onUpdateCountDown(arg0, arg1)
	if arg0._dataProxy:GetCountDown() <= 0 then
		arg0._dataProxy:EnemyEscape()
		arg0:CalcStatistic()
		arg0:calcDamageData()
		arg0._state:BattleTimeUp()
	end
end

function var3.calcDamageData(arg0)
	local var0 = arg0._dataProxy:GetInitData()

	arg0._dataProxy:CalcWorldBossDamageInfo(var0.ActID, var0.bossConfigId, var0.bossLevel)
end
