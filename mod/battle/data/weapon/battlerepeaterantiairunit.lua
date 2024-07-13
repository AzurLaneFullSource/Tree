ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = var0_0.Battle.BattleDataFunction
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleVariable
local var8_0 = class("BattleRepeaterAntiAirUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleRepeaterAntiAirUnit = var8_0
var8_0.__name = "BattleRepeaterAntiAirUnit"

function var8_0.Ctor(arg0_1)
	var8_0.super.Ctor(arg0_1)

	arg0_1._dataProxy = var0_0.Battle.BattleDataProxy.GetInstance()
end

function var8_0.FilterTarget(arg0_2)
	local var0_2 = arg0_2._dataProxy:GetAircraftList()
	local var1_2 = {}
	local var2_2 = arg0_2._host:GetIFF()
	local var3_2 = 1

	for iter0_2, iter1_2 in pairs(var0_2) do
		if iter1_2:GetIFF() ~= var2_2 and iter1_2:IsVisitable() then
			var1_2[var3_2] = iter1_2
			var3_2 = var3_2 + 1
		end
	end

	return var1_2
end

function var8_0.Fire(arg0_3)
	local function var0_3(arg0_4)
		if not arg0_3._dataProxy then
			return
		end

		local var0_4 = {}
		local var1_4 = arg0_3._dataProxy:GetAircraftList()

		for iter0_4, iter1_4 in ipairs(arg0_4) do
			if iter1_4.Active then
				local var2_4 = var1_4[iter1_4.UID]

				if var2_4 and var2_4:IsVisitable() then
					var0_4[#var0_4 + 1] = var2_4
				end
			end
		end

		local var3_4 = var2_0.CalculateRepaterAnitiAirTotalDamage(arg0_3)

		while var3_4 > 0 and #var0_4 > 0 do
			local var4_4 = math.random(#var0_4)
			local var5_4 = var0_4[var4_4]
			local var6_4 = var5_4:GetMaxHP()

			var3_4 = var3_4 - (var6_4 + math.random(var4_0.AnitAirRepeaterConfig.lower_range, var4_0.AnitAirRepeaterConfig.upper_range))

			if var3_4 < 0 then
				var6_4 = var6_4 + var3_4
			end

			if not var2_0.RollRepeaterHitDice(arg0_3, var5_4) then
				table.remove(var0_4, var4_4)
				arg0_3._dataProxy:HandleDirectDamage(var5_4, var6_4, arg0_3:GetHost())
			end
		end
	end

	arg0_3._dataProxy:SpawnColumnArea(var3_0.AOEField.AIR, arg0_3._host:GetIFF(), arg0_3._host:GetPosition(), arg0_3._tmpData.range * 2, -1, var0_3)
	arg0_3:EnterCoolDown()
	arg0_3._host:PlayFX(arg0_3._tmpData.fire_fx, true)
	var0_0.Battle.PlayBattleSFX(arg0_3._tmpData.fire_sfx)
end
