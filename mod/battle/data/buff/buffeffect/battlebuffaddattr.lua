ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAddAttr", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAddAttr = var1_0
var1_0.__name = "BattleBuffAddAttr"
var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR

function var1_0.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffAddAttr.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var1_0.FX_TYPE
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._group = arg0_3._tempData.arg_list.group or arg2_3:GetID()

	if arg0_3._tempData.arg_list.comboDamage then
		arg0_3._attr = var0_0.Battle.BattleAttr.GetCurrent(arg0_3._caster, "comboTag")
	else
		arg0_3._attr = arg0_3._tempData.arg_list.attr
	end

	arg0_3._number = arg0_3._tempData.arg_list.number
	arg0_3._numberBase = arg0_3._number
	arg0_3._attrID = arg0_3._tempData.arg_list.attr_group_ID
end

function var1_0.onAttach(arg0_4, arg1_4, arg2_4)
	arg0_4:UpdateAttr(arg1_4)
end

function var1_0.onStack(arg0_5, arg1_5, arg2_5)
	arg0_5._number = arg0_5._numberBase * arg2_5._stack

	arg0_5:UpdateAttr(arg1_5)
end

function var1_0.onRemove(arg0_6, arg1_6, arg2_6)
	arg0_6._number = 0

	arg0_6:UpdateAttr(arg1_6)
end

function var1_0.IsSameAttr(arg0_7, arg1_7)
	return arg0_7._attr == arg1_7
end

function var1_0.UpdateAttr(arg0_8, arg1_8)
	assert(arg0_8._attr ~= "velocity", ">>BattleBuffAddAttr(Ratio)不可用于修改速度，使用BattleBuffFixVelocity!")

	if arg0_8._attr == "injureRatio" then
		arg0_8:UpdateAttrMul(arg1_8)
	else
		arg0_8:UpdateAttrAdd(arg1_8)
	end

	if arg0_8._attr == "cloakExposeExtra" or arg0_8._attr == "cloakRestore" or arg0_8._attr == "cloakRecovery" then
		arg1_8:UpdateCloakConfig()
	end

	if arg0_8._attr == "lockAimBias" then
		arg1_8:UpdateAimBiasSkillState()
	end
end

function var1_0.CheckWeapon(arg0_9)
	if arg0_9._attr == "loadSpeed" then
		return true
	else
		return false
	end
end

function var1_0.UpdateAttrMul(arg0_10, arg1_10)
	local var0_10 = 1
	local var1_10 = 1
	local var2_10 = {}
	local var3_10 = {}
	local var4_10 = arg1_10:GetBuffList()

	for iter0_10, iter1_10 in pairs(var4_10) do
		for iter2_10, iter3_10 in ipairs(iter1_10._effectList) do
			if iter3_10:GetEffectType() == var1_0.FX_TYPE and iter3_10:IsSameAttr(arg0_10._attr) then
				local var5_10 = iter3_10._number
				local var6_10 = iter3_10._group
				local var7_10 = var2_10[var6_10] or 0
				local var8_10 = var3_10[var6_10] or 0

				if var7_10 < var5_10 and var5_10 > 0 then
					var0_10 = var0_10 * (1 + var5_10) / (1 + var7_10)
					var7_10 = var5_10
				end

				if var5_10 < var8_10 and var5_10 < 0 then
					var1_10 = var1_10 * (1 + var5_10) / (1 + var8_10)
					var8_10 = var5_10
				end

				var2_10[var6_10] = var7_10
				var3_10[var6_10] = var8_10
			end
		end
	end

	var0_0.Battle.BattleAttr.FlashByBuff(arg1_10, arg0_10._attr, var0_10 * var1_10 - 1)

	if arg0_10:CheckWeapon() then
		arg1_10:FlushReloadingWeapon()
	end
end

function var1_0.UpdateAttrAdd(arg0_11, arg1_11)
	local var0_11, var1_11 = arg1_11:GetHP()
	local var2_11 = arg1_11:GetBuffList()
	local var3_11 = 0
	local var4_11 = 0
	local var5_11 = {}
	local var6_11 = {}

	for iter0_11, iter1_11 in pairs(var2_11) do
		for iter2_11, iter3_11 in ipairs(iter1_11._effectList) do
			if iter3_11:GetEffectType() == var1_0.FX_TYPE and iter3_11:IsSameAttr(arg0_11._attr) then
				local var7_11 = iter3_11._number
				local var8_11 = iter3_11._group
				local var9_11 = var5_11[var8_11] or 0
				local var10_11 = var6_11[var8_11] or 0

				if var9_11 < var7_11 and var7_11 > 0 then
					var3_11 = var3_11 + var7_11 - var9_11
					var9_11 = var7_11
				end

				if var7_11 < var10_11 and var7_11 < 0 then
					var4_11 = var4_11 + var7_11 - var10_11
					var10_11 = var7_11
				end

				var5_11[var8_11] = var9_11
				var6_11[var8_11] = var10_11
			end
		end
	end

	var0_0.Battle.BattleAttr.FlashByBuff(arg1_11, arg0_11._attr, var3_11 + var4_11)

	local var11_11 = arg1_11:GetMaxHP()
	local var12_11 = math.min(var11_11, var0_11 + math.max(0, var11_11 - var1_11))

	arg1_11:SetCurrentHP(var12_11)

	if arg0_11:CheckWeapon() then
		arg1_11:FlushReloadingWeapon()
	end

	arg1_11._move:ImmuneAreaLimit(var0_0.Battle.BattleAttr.IsImmuneAreaLimit(arg1_11))
	arg1_11._move:ImmuneMaxAreaLimit(var0_0.Battle.BattleAttr.IsImmuneMaxAreaLimit(arg1_11))
end

function var1_0.UpdateAttrHybrid(arg0_12, arg1_12)
	local var0_12 = arg1_12:GetBuffList()
	local var1_12 = {}
	local var2_12 = {}

	for iter0_12, iter1_12 in pairs(var0_12) do
		for iter2_12, iter3_12 in ipairs(iter1_12._effectList) do
			if iter3_12:GetEffectType() == var1_0.FX_TYPE and iter3_12:IsSameAttr(arg0_12._attr) then
				local var3_12 = iter3_12._number
				local var4_12 = iter3_12._group
				local var5_12 = iter3_12._attrID or 0

				if var3_12 > 0 then
					local var6_12 = var1_12[var4_12] or {
						value = 0,
						attrGroup = var5_12
					}

					var6_12.value = math.max(var6_12.value, var3_12)
					var1_12[var4_12] = var6_12
				elseif var3_12 < 0 then
					local var7_12 = var2_12[var4_12] or {
						value = 0,
						attrGroup = var5_12
					}

					var7_12.value = math.min(var7_12.value, var3_12)
					var2_12[var4_12] = var7_12
				end
			end
		end
	end

	local function var8_12(arg0_13)
		local var0_13 = {}
		local var1_13

		for iter0_13, iter1_13 in pairs(arg0_13) do
			local var2_13 = iter1_13.attrGroup

			var0_13[var2_13] = (var0_13[var2_13] or 0) + iter1_13.value
		end

		for iter2_13, iter3_13 in pairs(var0_13) do
			var1_13 = (var1_13 or 1) * iter3_13
		end

		return var1_13
	end

	local var9_12 = var8_12(var1_12) or 0
	local var10_12 = var8_12(var2_12) or 0

	var0_0.Battle.BattleAttr.FlashByBuff(arg1_12, arg0_12._attr, var9_12 + var10_12)
end
