ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleCardPuzzleEvent
local var4 = var0.Battle.BattleFormulas
local var5 = var0.Battle.BattleConst
local var6 = var0.Battle.BattleConfig
local var7 = var0.Battle.BattleAttr
local var8 = var0.Battle.BattleDataFunction
local var9 = var0.Battle.BattleAttr
local var10 = var0.Battle.BattleCardPuzzleConfig
local var11 = class("BattleFleetCardPuzzleEnergy")

var0.Battle.BattleFleetCardPuzzleEnergy = var11
var11.__name = "BattleFleetCardPuzzleEnergy"

function var11.Ctor(arg0, arg1)
	arg0._client = arg1
	arg0._fleetAttr = arg0._client:GetAttrManager()

	arg0:init()
end

function var11.CustomConfig(arg0, arg1)
	local var0 = var8.GetPuzzleDungeonTemplate(arg1)

	arg0._currentEnergy = var0.init_energy
	arg0._generateRate = var0.energy_recovery
end

function var11.Dispose(arg0)
	return
end

function var11.GetMaxEnergy(arg0)
	return arg0._maxEnergy
end

function var11.GetCurrentEnergy(arg0)
	return arg0._currentEnergy
end

function var11.GetGeneratingProcess(arg0)
	if arg0._currentEnergy == arg0._maxEnergy then
		return 1
	else
		return arg0._energyGenerating
	end
end

function var11.ConsumeEnergy(arg0, arg1)
	arg0._currentEnergy = math.max(arg0._currentEnergy - arg1, 0)

	arg0._client:EnergyUpdate()

	if arg1 > 0 then
		arg0._client:FlushHandOverheat()
	end
end

function var11.Update(arg0, arg1)
	arg0:update(arg1)
end

function var11.init(arg0)
	arg0._currentEnergy = var10.baseEnergyInitial
	arg0._maxEnergy = 10
	arg0._generateRate = var10.baseEnergyGenerateSpeedPerSecond
	arg0._energyGenerating = 0
end

function var11.updateTimeStamp(arg0)
	arg0._lastUpdateTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var11.Start(arg0)
	arg0:updateTimeStamp()
end

function var11.update(arg0, arg1)
	if arg0._currentEnergy < arg0._maxEnergy then
		arg0._energyGenerating = (arg1 - arg0._lastUpdateTimeStamp) * arg0:getCurrentSpeed() + arg0._energyGenerating

		if arg0._energyGenerating >= 1 then
			arg0._currentEnergy = arg0._currentEnergy + 1

			arg0._client:EnergyUpdate()

			arg0._energyGenerating = 0
		end
	end

	arg0:updateTimeStamp()
end

function var11.getCurrentSpeed(arg0)
	local var0 = arg0._fleetAttr:GetCurrent("BaseEnergyBoostRate")
	local var1 = arg0._fleetAttr:GetCurrent("BaseEnergyBoostExtra")

	return (math.max(arg0._generateRate * (1 + var0) + var1, 0))
end

function var11.FillToCooldown(arg0, arg1)
	if arg1 <= arg0._currentEnergy then
		return 0
	else
		local var0 = arg0:getCurrentSpeed()
		local var1 = (1 - arg0._energyGenerating) / var0

		if arg1 - arg0._currentEnergy >= 2 then
			var1 = 1 / var0 * (arg1 - arg0._currentEnergy - 1) + var1
		end

		return var1
	end
end
