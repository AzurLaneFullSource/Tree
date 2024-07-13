ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleAidWave = class("BattleAidWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleAidWave.__name = "BattleAidWave"

local var2_0 = var0_0.Battle.BattleAidWave

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.SetWaveData(arg0_2, arg1_2)
	var2_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._vanguardUnitList = arg0_2._param.vanguard_unitList
	arg0_2._mainUnitList = arg0_2._param.main_unitList
	arg0_2._subUnitList = arg0_2._param.sub_unitList
	arg0_2._killList = arg0_2._param.kill_list
end

function var2_0.DoWave(arg0_3)
	var2_0.super.DoWave(arg0_3)

	local var0_3 = var0_0.Battle.BattleDataProxy.GetInstance()

	if arg0_3._killList ~= nil then
		local var1_3 = var0_3:GetFriendlyShipList()

		for iter0_3, iter1_3 in ipairs(arg0_3._killList) do
			for iter2_3, iter3_3 in pairs(var1_3) do
				if iter3_3:GetTemplateID() == iter1_3 then
					iter3_3:Retreat()
				end
			end
		end
	end

	if arg0_3._vanguardUnitList ~= nil then
		for iter4_3, iter5_3 in ipairs(arg0_3._vanguardUnitList) do
			local var2_3 = {}

			for iter6_3, iter7_3 in ipairs(iter5_3.equipment) do
				var2_3[#var2_3 + 1] = {
					skin = 0,
					id = iter7_3
				}
			end

			local var3_3 = Clone(iter5_3)

			var3_3.equipment = var2_3
			var3_3.baseProperties = iter5_3.properties

			local var4_3 = var0_3:SpawnVanguard(var3_3, var1_0.FRIENDLY_CODE)

			var0_3.InitUnitWeaponCD(var4_3)
			var0_3:InitAidUnitStatistics(var4_3)
		end
	end

	if arg0_3._mainUnitList ~= nil then
		for iter8_3, iter9_3 in ipairs(arg0_3._mainUnitList) do
			local var5_3 = {}

			for iter10_3, iter11_3 in ipairs(iter9_3.equipment) do
				var5_3[#var5_3 + 1] = {
					skin = 0,
					id = iter11_3
				}
			end

			local var6_3 = Clone(iter9_3)

			var6_3.equipment = var5_3
			var6_3.baseProperties = iter9_3.properties

			local var7_3 = var0_3:SpawnMain(var6_3, var1_0.FRIENDLY_CODE)

			var0_3.InitUnitWeaponCD(var7_3)
			var0_3:InitAidUnitStatistics(var7_3)
		end
	end

	if arg0_3._subUnitList ~= nil then
		for iter12_3, iter13_3 in ipairs(arg0_3._subUnitList) do
			local var8_3 = {}

			for iter14_3, iter15_3 in ipairs(iter13_3.equipment) do
				var8_3[#var8_3 + 1] = {
					skin = 0,
					id = iter15_3
				}
			end

			local var9_3 = Clone(iter13_3)

			var9_3.equipment = var8_3
			var9_3.baseProperties = iter13_3.properties

			local var10_3 = var0_3:SpawnSub(var9_3, var1_0.FRIENDLY_CODE)

			var0_3:InitAidUnitStatistics(var10_3)
		end
	end

	arg0_3:doPass()
end
