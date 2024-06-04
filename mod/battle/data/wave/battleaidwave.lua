ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.BattleAidWave = class("BattleAidWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleAidWave.__name = "BattleAidWave"

local var2 = var0.Battle.BattleAidWave

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.SetWaveData(arg0, arg1)
	var2.super.SetWaveData(arg0, arg1)

	arg0._vanguardUnitList = arg0._param.vanguard_unitList
	arg0._mainUnitList = arg0._param.main_unitList
	arg0._subUnitList = arg0._param.sub_unitList
	arg0._killList = arg0._param.kill_list
end

function var2.DoWave(arg0)
	var2.super.DoWave(arg0)

	local var0 = var0.Battle.BattleDataProxy.GetInstance()

	if arg0._killList ~= nil then
		local var1 = var0:GetFriendlyShipList()

		for iter0, iter1 in ipairs(arg0._killList) do
			for iter2, iter3 in pairs(var1) do
				if iter3:GetTemplateID() == iter1 then
					iter3:Retreat()
				end
			end
		end
	end

	if arg0._vanguardUnitList ~= nil then
		for iter4, iter5 in ipairs(arg0._vanguardUnitList) do
			local var2 = {}

			for iter6, iter7 in ipairs(iter5.equipment) do
				var2[#var2 + 1] = {
					skin = 0,
					id = iter7
				}
			end

			local var3 = Clone(iter5)

			var3.equipment = var2
			var3.baseProperties = iter5.properties

			local var4 = var0:SpawnVanguard(var3, var1.FRIENDLY_CODE)

			var0.InitUnitWeaponCD(var4)
			var0:InitAidUnitStatistics(var4)
		end
	end

	if arg0._mainUnitList ~= nil then
		for iter8, iter9 in ipairs(arg0._mainUnitList) do
			local var5 = {}

			for iter10, iter11 in ipairs(iter9.equipment) do
				var5[#var5 + 1] = {
					skin = 0,
					id = iter11
				}
			end

			local var6 = Clone(iter9)

			var6.equipment = var5
			var6.baseProperties = iter9.properties

			local var7 = var0:SpawnMain(var6, var1.FRIENDLY_CODE)

			var0.InitUnitWeaponCD(var7)
			var0:InitAidUnitStatistics(var7)
		end
	end

	if arg0._subUnitList ~= nil then
		for iter12, iter13 in ipairs(arg0._subUnitList) do
			local var8 = {}

			for iter14, iter15 in ipairs(iter13.equipment) do
				var8[#var8 + 1] = {
					skin = 0,
					id = iter15
				}
			end

			local var9 = Clone(iter13)

			var9.equipment = var8
			var9.baseProperties = iter13.properties

			local var10 = var0:SpawnSub(var9, var1.FRIENDLY_CODE)

			var0:InitAidUnitStatistics(var10)
		end
	end

	arg0:doPass()
end
