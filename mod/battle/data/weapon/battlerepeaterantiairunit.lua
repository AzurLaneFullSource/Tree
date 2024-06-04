ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleConfig
local var5 = var0.Battle.BattleDataFunction
local var6 = var0.Battle.BattleAttr
local var7 = var0.Battle.BattleVariable
local var8 = class("BattleRepeaterAntiAirUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleRepeaterAntiAirUnit = var8
var8.__name = "BattleRepeaterAntiAirUnit"

function var8.Ctor(arg0)
	var8.super.Ctor(arg0)

	arg0._dataProxy = var0.Battle.BattleDataProxy.GetInstance()
end

function var8.FilterTarget(arg0)
	local var0 = arg0._dataProxy:GetAircraftList()
	local var1 = {}
	local var2 = arg0._host:GetIFF()
	local var3 = 1

	for iter0, iter1 in pairs(var0) do
		if iter1:GetIFF() ~= var2 and iter1:IsVisitable() then
			var1[var3] = iter1
			var3 = var3 + 1
		end
	end

	return var1
end

function var8.Fire(arg0)
	local function var0(arg0)
		if not arg0._dataProxy then
			return
		end

		local var0 = {}
		local var1 = arg0._dataProxy:GetAircraftList()

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var2 = var1[iter1.UID]

				if var2 and var2:IsVisitable() then
					var0[#var0 + 1] = var2
				end
			end
		end

		local var3 = var2.CalculateRepaterAnitiAirTotalDamage(arg0)

		while var3 > 0 and #var0 > 0 do
			local var4 = math.random(#var0)
			local var5 = var0[var4]
			local var6 = var5:GetMaxHP()

			var3 = var3 - (var6 + math.random(var4.AnitAirRepeaterConfig.lower_range, var4.AnitAirRepeaterConfig.upper_range))

			if var3 < 0 then
				var6 = var6 + var3
			end

			if not var2.RollRepeaterHitDice(arg0, var5) then
				table.remove(var0, var4)
				arg0._dataProxy:HandleDirectDamage(var5, var6, arg0:GetHost())
			end
		end
	end

	arg0._dataProxy:SpawnColumnArea(var3.AOEField.AIR, arg0._host:GetIFF(), arg0._host:GetPosition(), arg0._tmpData.range * 2, -1, var0)
	arg0:EnterCoolDown()
	arg0._host:PlayFX(arg0._tmpData.fire_fx, true)
	var0.Battle.PlayBattleSFX(arg0._tmpData.fire_sfx)
end
