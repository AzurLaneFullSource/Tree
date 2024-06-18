ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleAttr

var0_0.Battle.BattleBuffSmokeAimBias = class("BattleBuffSmokeAimBias", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffSmokeAimBias.__name = "BattleBuffSmokeAimBias"

local var4_0 = var0_0.Battle.BattleBuffSmokeAimBias
local var5_0 = var0_0.Battle.BattleAttr

var4_0.ATTR_SMOKE = "smoke_aim_bias"

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1)
end

function var4_0.SetArgs(arg0_2, arg1_2, arg2_2)
	return
end

function var4_0.onAttach(arg0_3, arg1_3, arg2_3)
	var5_0.SetCurrent(arg1_3, var4_0.ATTR_SMOKE, 1)
	var1_0.AttachSmoke(arg1_3)

	if BATTLE_ENEMY_AIMBIAS_RANGE then
		var0_0.Battle.BattleDataProxy.GetInstance():DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleEvent.ADD_AIM_BIAS, {
			aimBias = arg1_3:GetAimBias()
		}))
	end
end

function var4_0.onUpdate(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = {
		[var2_0.FRIENDLY_CODE] = 0,
		[var2_0.FOE_CODE] = 0
	}
	local var1_4 = {
		[var2_0.FRIENDLY_CODE] = 0,
		[var2_0.FOE_CODE] = 0
	}
	local var2_4 = var0_0.Battle.BattleDataProxy.GetInstance():GetUnitList()

	for iter0_4, iter1_4 in pairs(var2_4) do
		local var3_4 = iter1_4:GetIFF()
		local var4_4 = var0_4[var3_4]
		local var5_4 = var3_0.GetCurrent(iter1_4, "attackRating")
		local var6_4 = var3_0.GetCurrent(iter1_4, "aimBiasExtraACC")

		var0_4[var3_4] = math.max(var4_4, var5_4)
		var1_4[var3_4] = var1_4[var3_4] + var6_4
	end

	local var7_4 = arg1_4:GetAimBias()

	var7_4:SetDecayFactor(var0_4[var2_0.FRIENDLY_CODE], var1_4[var2_0.FRIENDLY_CODE])

	local var8_4 = arg3_4.timeStamp

	var7_4:Update(var8_4)
end

function var4_0.onRemove(arg0_5, arg1_5, arg2_5)
	if BATTLE_ENEMY_AIMBIAS_RANGE then
		var0_0.Battle.BattleDataProxy.GetInstance():DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleEvent.REMOVE_AIM_BIAS, {
			aimBias = arg1_5:GetAimBias()
		}))
	end

	var5_0.SetCurrent(arg1_5, var4_0.ATTR_SMOKE, 0)
	arg1_5:ExitSmokeArea()
end
