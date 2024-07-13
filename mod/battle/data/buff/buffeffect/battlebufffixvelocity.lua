ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffFixVelocity", var0_0.Battle.BattleBuffAddAttr)

var0_0.Battle.BattleBuffFixVelocity = var1_0
var1_0.__name = "BattleBuffFixVelocity"
var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_VELOCTIY

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_VELOCTIY
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._group = arg0_3._tempData.arg_list.group or arg2_3:GetID()

	local var0_3 = arg0_3._tempData.arg_list.add or 0

	arg0_3._baseAdd = var0_0.Battle.BattleFormulas.ConvertShipSpeed(var0_3)
	arg0_3._addValue = arg0_3._baseAdd
	arg0_3._baseMul = (arg0_3._tempData.arg_list.mul or 0) * 0.0001
	arg0_3._mulValue = arg0_3._baseMul
end

function var1_0.onStack(arg0_4, arg1_4, arg2_4)
	arg0_4._addValue = arg0_4._baseAdd * arg2_4._stack
	arg0_4._mulValue = arg0_4._baseMul * arg2_4._stack

	arg0_4:UpdateAttr(arg1_4)
end

function var1_0.onRemove(arg0_5, arg1_5, arg2_5)
	arg0_5._addValue = 0
	arg0_5._mulValue = 0

	arg0_5:UpdateAttr(arg1_5)
end

function var1_0.UpdateAttr(arg0_6, arg1_6)
	local var0_6 = arg0_6:calcMulValue(arg1_6)
	local var1_6 = arg0_6:calcAddValue(arg1_6)

	var0_0.Battle.BattleAttr.FlashVelocity(arg1_6, var0_6, var1_6)
end

function var1_0.calcMulValue(arg0_7, arg1_7)
	local var0_7 = 1
	local var1_7 = 1
	local var2_7 = {}
	local var3_7 = {}
	local var4_7 = arg1_7:GetBuffList()

	for iter0_7, iter1_7 in pairs(var4_7) do
		for iter2_7, iter3_7 in ipairs(iter1_7._effectList) do
			if iter3_7:GetEffectType() == var1_0.FX_TYPE then
				local var5_7 = iter3_7._mulValue
				local var6_7 = iter3_7._group
				local var7_7 = var2_7[var6_7] or 1
				local var8_7 = var3_7[var6_7] or 1
				local var9_7 = 1 + var5_7

				if var5_7 > 0 and var7_7 < var9_7 then
					var0_7 = var0_7 / var7_7 * var9_7
					var7_7 = var9_7
				end

				if var5_7 < 0 and var9_7 < var8_7 then
					var1_7 = var1_7 / var8_7 * var9_7
					var8_7 = var9_7
				end

				var2_7[var6_7] = var7_7
				var3_7[var6_7] = var8_7
			end
		end
	end

	return var0_7 * var1_7
end

function var1_0.calcAddValue(arg0_8, arg1_8)
	local var0_8 = arg1_8:GetBuffList()
	local var1_8 = 0
	local var2_8 = 0
	local var3_8 = {}
	local var4_8 = {}

	for iter0_8, iter1_8 in pairs(var0_8) do
		for iter2_8, iter3_8 in ipairs(iter1_8._effectList) do
			if iter3_8:GetEffectType() == var1_0.FX_TYPE then
				local var5_8 = iter3_8._addValue
				local var6_8 = iter3_8._group
				local var7_8 = var3_8[var6_8] or 0
				local var8_8 = var4_8[var6_8] or 0

				if var7_8 < var5_8 and var5_8 > 0 then
					var1_8 = var1_8 + var5_8 - var7_8
					var7_8 = var5_8
				end

				if var5_8 < var8_8 and var5_8 < 0 then
					var2_8 = var2_8 + var5_8 - var8_8
					var8_8 = var5_8
				end

				var3_8[var6_8] = var7_8
				var4_8[var6_8] = var8_8
			end
		end
	end

	return var1_8 + var2_8
end
