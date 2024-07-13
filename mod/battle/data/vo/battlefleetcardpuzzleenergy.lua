ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent
local var4_0 = var0_0.Battle.BattleFormulas
local var5_0 = var0_0.Battle.BattleConst
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = var0_0.Battle.BattleAttr
local var8_0 = var0_0.Battle.BattleDataFunction
local var9_0 = var0_0.Battle.BattleAttr
local var10_0 = var0_0.Battle.BattleCardPuzzleConfig
local var11_0 = class("BattleFleetCardPuzzleEnergy")

var0_0.Battle.BattleFleetCardPuzzleEnergy = var11_0
var11_0.__name = "BattleFleetCardPuzzleEnergy"

function var11_0.Ctor(arg0_1, arg1_1)
	arg0_1._client = arg1_1
	arg0_1._fleetAttr = arg0_1._client:GetAttrManager()

	arg0_1:init()
end

function var11_0.CustomConfig(arg0_2, arg1_2)
	local var0_2 = var8_0.GetPuzzleDungeonTemplate(arg1_2)

	arg0_2._currentEnergy = var0_2.init_energy
	arg0_2._generateRate = var0_2.energy_recovery
end

function var11_0.Dispose(arg0_3)
	return
end

function var11_0.GetMaxEnergy(arg0_4)
	return arg0_4._maxEnergy
end

function var11_0.GetCurrentEnergy(arg0_5)
	return arg0_5._currentEnergy
end

function var11_0.GetGeneratingProcess(arg0_6)
	if arg0_6._currentEnergy == arg0_6._maxEnergy then
		return 1
	else
		return arg0_6._energyGenerating
	end
end

function var11_0.ConsumeEnergy(arg0_7, arg1_7)
	arg0_7._currentEnergy = math.max(arg0_7._currentEnergy - arg1_7, 0)

	arg0_7._client:EnergyUpdate()

	if arg1_7 > 0 then
		arg0_7._client:FlushHandOverheat()
	end
end

function var11_0.Update(arg0_8, arg1_8)
	arg0_8:update(arg1_8)
end

function var11_0.init(arg0_9)
	arg0_9._currentEnergy = var10_0.baseEnergyInitial
	arg0_9._maxEnergy = 10
	arg0_9._generateRate = var10_0.baseEnergyGenerateSpeedPerSecond
	arg0_9._energyGenerating = 0
end

function var11_0.updateTimeStamp(arg0_10)
	arg0_10._lastUpdateTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var11_0.Start(arg0_11)
	arg0_11:updateTimeStamp()
end

function var11_0.update(arg0_12, arg1_12)
	if arg0_12._currentEnergy < arg0_12._maxEnergy then
		arg0_12._energyGenerating = (arg1_12 - arg0_12._lastUpdateTimeStamp) * arg0_12:getCurrentSpeed() + arg0_12._energyGenerating

		if arg0_12._energyGenerating >= 1 then
			arg0_12._currentEnergy = arg0_12._currentEnergy + 1

			arg0_12._client:EnergyUpdate()

			arg0_12._energyGenerating = 0
		end
	end

	arg0_12:updateTimeStamp()
end

function var11_0.getCurrentSpeed(arg0_13)
	local var0_13 = arg0_13._fleetAttr:GetCurrent("BaseEnergyBoostRate")
	local var1_13 = arg0_13._fleetAttr:GetCurrent("BaseEnergyBoostExtra")

	return (math.max(arg0_13._generateRate * (1 + var0_13) + var1_13, 0))
end

function var11_0.FillToCooldown(arg0_14, arg1_14)
	if arg1_14 <= arg0_14._currentEnergy then
		return 0
	else
		local var0_14 = arg0_14:getCurrentSpeed()
		local var1_14 = (1 - arg0_14._energyGenerating) / var0_14

		if arg1_14 - arg0_14._currentEnergy >= 2 then
			var1_14 = 1 / var0_14 * (arg1_14 - arg0_14._currentEnergy - 1) + var1_14
		end

		return var1_14
	end
end
