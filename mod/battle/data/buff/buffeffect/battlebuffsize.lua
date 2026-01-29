ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffSize = class("BattleBuffSize", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffSize.__name = "BattleBuffSize"

local var1_0 = var0_0.Battle.BattleBuffSize

var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_MODEL_SCALE

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var1_0.FX_TYPE
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._group = arg0_3._tempData.arg_list.group or arg2_3:GetID()
	arg0_3._base = arg0_3._tempData.arg_list.number or 1
	arg0_3._hpScale = arg0_3._tempData.arg_list.hp_scale or 0
	arg0_3._attr = "modelScale"
end

function var1_0.onHPRatioUpdate(arg0_4, arg1_4, arg2_4)
	arg0_4:doScale(arg1_4)
	arg0_4:UpdateScale(arg1_4)
end

function var1_0.onAttach(arg0_5, arg1_5, arg2_5)
	arg0_5:doScale(arg1_5)
	arg0_5:UpdateScale(arg1_5)
end

function var1_0.onStack(arg0_6, arg1_6, arg2_6)
	arg0_6:doScale(arg1_6)

	local var0_6 = arg0_6._number

	for iter0_6 = 1, arg2_6._stack do
		var0_6 = var0_6 * arg0_6._number
	end

	arg0_6._number = var0_6

	arg0_6:UpdateScale(arg1_6)
end

function var1_0.onRemove(arg0_7, arg1_7, arg2_7)
	arg0_7._number = 1

	arg0_7:UpdateScale(arg1_7)
end

function var1_0.UpdateScale(arg0_8, arg1_8)
	local var0_8 = 1
	local var1_8 = 1
	local var2_8 = {}
	local var3_8 = {}
	local var4_8 = arg1_8:GetBuffList()

	for iter0_8, iter1_8 in pairs(var4_8) do
		for iter2_8, iter3_8 in ipairs(iter1_8._effectList) do
			if iter3_8:GetEffectType() == var1_0.FX_TYPE then
				local var5_8 = iter3_8._number
				local var6_8 = iter3_8._group
				local var7_8 = var2_8[var6_8] or 1
				local var8_8 = var3_8[var6_8] or 1

				if var7_8 < var5_8 and var5_8 > 1 then
					var0_8 = var0_8 * var5_8 / var7_8
					var7_8 = var5_8
				end

				if var5_8 < var8_8 and var5_8 < 1 then
					var1_8 = var1_8 * var5_8 / var8_8
					var8_8 = var5_8
				end

				var2_8[var6_8] = var7_8
				var3_8[var6_8] = var8_8
			end
		end
	end

	local var9_8 = var0_0.Battle.BattleAttr.GetCurrent(arg1_8, "baseScale") * var0_8 * var1_8

	var0_0.Battle.BattleAttr.SetCurrent(arg1_8, "modelScale", var9_8)
	arg1_8:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE))
end

function var1_0.doScale(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetHPRate()

	arg0_9._number = arg0_9._base + var0_9 * arg0_9._hpScale
end
