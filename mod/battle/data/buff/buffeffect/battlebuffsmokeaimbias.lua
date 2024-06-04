ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleAttr

var0.Battle.BattleBuffSmokeAimBias = class("BattleBuffSmokeAimBias", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffSmokeAimBias.__name = "BattleBuffSmokeAimBias"

local var4 = var0.Battle.BattleBuffSmokeAimBias
local var5 = var0.Battle.BattleAttr

var4.ATTR_SMOKE = "smoke_aim_bias"

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1)
end

function var4.SetArgs(arg0, arg1, arg2)
	return
end

function var4.onAttach(arg0, arg1, arg2)
	var5.SetCurrent(arg1, var4.ATTR_SMOKE, 1)
	var1.AttachSmoke(arg1)

	if BATTLE_ENEMY_AIMBIAS_RANGE then
		var0.Battle.BattleDataProxy.GetInstance():DispatchEvent(var0.Event.New(var0.Battle.BattleEvent.ADD_AIM_BIAS, {
			aimBias = arg1:GetAimBias()
		}))
	end
end

function var4.onUpdate(arg0, arg1, arg2, arg3)
	local var0 = {
		[var2.FRIENDLY_CODE] = 0,
		[var2.FOE_CODE] = 0
	}
	local var1 = {
		[var2.FRIENDLY_CODE] = 0,
		[var2.FOE_CODE] = 0
	}
	local var2 = var0.Battle.BattleDataProxy.GetInstance():GetUnitList()

	for iter0, iter1 in pairs(var2) do
		local var3 = iter1:GetIFF()
		local var4 = var0[var3]
		local var5 = var3.GetCurrent(iter1, "attackRating")
		local var6 = var3.GetCurrent(iter1, "aimBiasExtraACC")

		var0[var3] = math.max(var4, var5)
		var1[var3] = var1[var3] + var6
	end

	local var7 = arg1:GetAimBias()

	var7:SetDecayFactor(var0[var2.FRIENDLY_CODE], var1[var2.FRIENDLY_CODE])

	local var8 = arg3.timeStamp

	var7:Update(var8)
end

function var4.onRemove(arg0, arg1, arg2)
	if BATTLE_ENEMY_AIMBIAS_RANGE then
		var0.Battle.BattleDataProxy.GetInstance():DispatchEvent(var0.Event.New(var0.Battle.BattleEvent.REMOVE_AIM_BIAS, {
			aimBias = arg1:GetAimBias()
		}))
	end

	var5.SetCurrent(arg1, var4.ATTR_SMOKE, 0)
	arg1:ExitSmokeArea()
end
