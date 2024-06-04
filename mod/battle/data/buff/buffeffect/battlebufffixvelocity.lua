ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffFixVelocity", var0.Battle.BattleBuffAddAttr)

var0.Battle.BattleBuffFixVelocity = var1
var1.__name = "BattleBuffFixVelocity"
var1.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_MOD_VELOCTIY

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectType(arg0)
	return var0.Battle.BattleBuffEffect.FX_TYPE_MOD_VELOCTIY
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._group = arg0._tempData.arg_list.group or arg2:GetID()

	local var0 = arg0._tempData.arg_list.add or 0

	arg0._baseAdd = var0.Battle.BattleFormulas.ConvertShipSpeed(var0)
	arg0._addValue = arg0._baseAdd
	arg0._baseMul = (arg0._tempData.arg_list.mul or 0) * 0.0001
	arg0._mulValue = arg0._baseMul
end

function var1.onStack(arg0, arg1, arg2)
	arg0._addValue = arg0._baseAdd * arg2._stack
	arg0._mulValue = arg0._baseMul * arg2._stack

	arg0:UpdateAttr(arg1)
end

function var1.onRemove(arg0, arg1, arg2)
	arg0._addValue = 0
	arg0._mulValue = 0

	arg0:UpdateAttr(arg1)
end

function var1.UpdateAttr(arg0, arg1)
	local var0 = arg0:calcMulValue(arg1)
	local var1 = arg0:calcAddValue(arg1)

	var0.Battle.BattleAttr.FlashVelocity(arg1, var0, var1)
end

function var1.calcMulValue(arg0, arg1)
	local var0 = 1
	local var1 = 1
	local var2 = {}
	local var3 = {}
	local var4 = arg1:GetBuffList()

	for iter0, iter1 in pairs(var4) do
		for iter2, iter3 in ipairs(iter1._effectList) do
			if iter3:GetEffectType() == var1.FX_TYPE then
				local var5 = iter3._mulValue
				local var6 = iter3._group
				local var7 = var2[var6] or 1
				local var8 = var3[var6] or 1
				local var9 = 1 + var5

				if var5 > 0 and var7 < var9 then
					var0 = var0 / var7 * var9
					var7 = var9
				end

				if var5 < 0 and var9 < var8 then
					var1 = var1 / var8 * var9
					var8 = var9
				end

				var2[var6] = var7
				var3[var6] = var8
			end
		end
	end

	return var0 * var1
end

function var1.calcAddValue(arg0, arg1)
	local var0 = arg1:GetBuffList()
	local var1 = 0
	local var2 = 0
	local var3 = {}
	local var4 = {}

	for iter0, iter1 in pairs(var0) do
		for iter2, iter3 in ipairs(iter1._effectList) do
			if iter3:GetEffectType() == var1.FX_TYPE then
				local var5 = iter3._addValue
				local var6 = iter3._group
				local var7 = var3[var6] or 0
				local var8 = var4[var6] or 0

				if var7 < var5 and var5 > 0 then
					var1 = var1 + var5 - var7
					var7 = var5
				end

				if var5 < var8 and var5 < 0 then
					var2 = var2 + var5 - var8
					var8 = var5
				end

				var3[var6] = var7
				var4[var6] = var8
			end
		end
	end

	return var1 + var2
end
