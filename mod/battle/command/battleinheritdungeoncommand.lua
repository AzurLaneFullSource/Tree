ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleInheritDungeonCommand", var0_0.Battle.BattleSingleDungeonCommand)

var0_0.Battle.BattleInheritDungeonCommand = var3_0
var3_0.__name = "BattleInheritDungeonCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.initWaveModule(arg0_2)
	local function var0_2(arg0_3, arg1_3, arg2_3)
		arg0_2._dataProxy:SpawnMonster(arg0_3, arg1_3, arg2_3, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_2(arg0_4)
		arg0_2._dataProxy:SpawnAirFighter(arg0_4)
	end

	local function var2_2()
		if arg0_2._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_2._vertifyFail
			})

			return
		end

		arg0_2:CalcStatistic()
		arg0_2:calcDamageData()
		arg0_2._state:BattleEnd()
	end

	local function var3_2(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
		arg0_2._dataProxy:SpawnCubeArea(var0_0.Battle.BattleConst.AOEField.SURFACE, -1, arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	end

	arg0_2._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_2, var1_2, var2_2, var3_2)
end

function var3_0.onInitBattle(arg0_7)
	var3_0.super.onInitBattle(arg0_7)

	local var0_7 = arg0_7._dataProxy:GetInitData()

	arg0_7._specificEnemyList = var0_0.Battle.BattleDataFunction.GetSpecificEnemyList(var0_7.ActID, var0_7.StageTmpId)
end

function var3_0.onAddUnit(arg0_8, arg1_8)
	var3_0.super.onAddUnit(arg0_8, arg1_8)

	local var0_8 = arg1_8.Data.unit

	if table.contains(arg0_8._specificEnemyList, var0_8:GetTemplateID()) then
		arg0_8._dataProxy:InitSpecificEnemyStatistics(var0_8)
	end
end

function var3_0.onPlayerShutDown(arg0_9, arg1_9)
	if arg0_9._state:GetState() ~= arg0_9._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg1_9.Data.unit == arg0_9._userFleet:GetFlagShip() and arg0_9._dataProxy:GetInitData().battleType ~= SYSTEM_PROLOGUE and arg0_9._dataProxy:GetInitData().battleType ~= SYSTEM_PERFORM then
		arg0_9:CalcStatistic()
		arg0_9:calcDamageData()
		arg0_9._state:BattleEnd()

		return
	end

	if #arg0_9._userFleet:GetScoutList() == 0 then
		arg0_9:CalcStatistic()
		arg0_9:calcDamageData()
		arg0_9._state:BattleEnd()
	end
end

function var3_0.onUpdateCountDown(arg0_10, arg1_10)
	if arg0_10._dataProxy:GetCountDown() <= 0 then
		arg0_10._dataProxy:EnemyEscape()
		arg0_10:CalcStatistic()
		arg0_10:calcDamageData()
		arg0_10._state:BattleTimeUp()
	end
end

function var3_0.calcDamageData(arg0_11)
	local var0_11 = arg0_11._dataProxy:GetInitData()

	arg0_11._dataProxy:CalcActBossDamageInfo(var0_11.ActID)
end
