ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAddAttr", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAddAttr = var1
var1.__name = "BattleBuffAddAttr"
var1.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR

function var1.Ctor(arg0, arg1)
	var0.Battle.BattleBuffAddAttr.super.Ctor(arg0, arg1)
end

function var1.GetEffectType(arg0)
	return var1.FX_TYPE
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._group = arg0._tempData.arg_list.group or arg2:GetID()

	if arg0._tempData.arg_list.comboDamage then
		arg0._attr = var0.Battle.BattleAttr.GetCurrent(arg0._caster, "comboTag")
	else
		arg0._attr = arg0._tempData.arg_list.attr
	end

	arg0._number = arg0._tempData.arg_list.number
	arg0._numberBase = arg0._number
	arg0._attrID = arg0._tempData.arg_list.attr_group_ID
end

function var1.onAttach(arg0, arg1, arg2)
	arg0:UpdateAttr(arg1)
end

function var1.onStack(arg0, arg1, arg2)
	arg0._number = arg0._numberBase * arg2._stack

	arg0:UpdateAttr(arg1)
end

function var1.onRemove(arg0, arg1, arg2)
	arg0._number = 0

	arg0:UpdateAttr(arg1)
end

function var1.IsSameAttr(arg0, arg1)
	return arg0._attr == arg1
end

function var1.UpdateAttr(arg0, arg1)
	assert(arg0._attr ~= "velocity", ">>BattleBuffAddAttr(Ratio)不可用于修改速度，使用BattleBuffFixVelocity!")

	if arg0._attr == "injureRatio" then
		arg0:UpdateAttrMul(arg1)
	else
		arg0:UpdateAttrAdd(arg1)
	end

	if arg0._attr == "cloakExposeExtra" or arg0._attr == "cloakRestore" or arg0._attr == "cloakRecovery" then
		arg1:UpdateCloakConfig()
	end

	if arg0._attr == "lockAimBias" then
		arg1:UpdateAimBiasSkillState()
	end
end

function var1.CheckWeapon(arg0)
	if arg0._attr == "loadSpeed" then
		return true
	else
		return false
	end
end

function var1.UpdateAttrMul(arg0, arg1)
	local var0 = 1
	local var1 = 1
	local var2 = {}
	local var3 = {}
	local var4 = arg1:GetBuffList()

	for iter0, iter1 in pairs(var4) do
		for iter2, iter3 in ipairs(iter1._effectList) do
			if iter3:GetEffectType() == var1.FX_TYPE and iter3:IsSameAttr(arg0._attr) then
				local var5 = iter3._number
				local var6 = iter3._group
				local var7 = var2[var6] or 0
				local var8 = var3[var6] or 0

				if var7 < var5 and var5 > 0 then
					var0 = var0 * (1 + var5) / (1 + var7)
					var7 = var5
				end

				if var5 < var8 and var5 < 0 then
					var1 = var1 * (1 + var5) / (1 + var8)
					var8 = var5
				end

				var2[var6] = var7
				var3[var6] = var8
			end
		end
	end

	var0.Battle.BattleAttr.FlashByBuff(arg1, arg0._attr, var0 * var1 - 1)

	if arg0:CheckWeapon() then
		arg1:FlushReloadingWeapon()
	end
end

function var1.UpdateAttrAdd(arg0, arg1)
	local var0, var1 = arg1:GetHP()
	local var2 = arg1:GetBuffList()
	local var3 = 0
	local var4 = 0
	local var5 = {}
	local var6 = {}

	for iter0, iter1 in pairs(var2) do
		for iter2, iter3 in ipairs(iter1._effectList) do
			if iter3:GetEffectType() == var1.FX_TYPE and iter3:IsSameAttr(arg0._attr) then
				local var7 = iter3._number
				local var8 = iter3._group
				local var9 = var5[var8] or 0
				local var10 = var6[var8] or 0

				if var9 < var7 and var7 > 0 then
					var3 = var3 + var7 - var9
					var9 = var7
				end

				if var7 < var10 and var7 < 0 then
					var4 = var4 + var7 - var10
					var10 = var7
				end

				var5[var8] = var9
				var6[var8] = var10
			end
		end
	end

	var0.Battle.BattleAttr.FlashByBuff(arg1, arg0._attr, var3 + var4)

	local var11 = arg1:GetMaxHP()
	local var12 = math.min(var11, var0 + math.max(0, var11 - var1))

	arg1:SetCurrentHP(var12)

	if arg0:CheckWeapon() then
		arg1:FlushReloadingWeapon()
	end

	arg1._move:ImmuneAreaLimit(var0.Battle.BattleAttr.IsImmuneAreaLimit(arg1))
	arg1._move:ImmuneMaxAreaLimit(var0.Battle.BattleAttr.IsImmuneMaxAreaLimit(arg1))
end

function var1.UpdateAttrHybrid(arg0, arg1)
	local var0 = arg1:GetBuffList()
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		for iter2, iter3 in ipairs(iter1._effectList) do
			if iter3:GetEffectType() == var1.FX_TYPE and iter3:IsSameAttr(arg0._attr) then
				local var3 = iter3._number
				local var4 = iter3._group
				local var5 = iter3._attrID or 0

				if var3 > 0 then
					local var6 = var1[var4] or {
						value = 0,
						attrGroup = var5
					}

					var6.value = math.max(var6.value, var3)
					var1[var4] = var6
				elseif var3 < 0 then
					local var7 = var2[var4] or {
						value = 0,
						attrGroup = var5
					}

					var7.value = math.min(var7.value, var3)
					var2[var4] = var7
				end
			end
		end
	end

	local function var8(arg0)
		local var0 = {}
		local var1

		for iter0, iter1 in pairs(arg0) do
			local var2 = iter1.attrGroup

			var0[var2] = (var0[var2] or 0) + iter1.value
		end

		for iter2, iter3 in pairs(var0) do
			var1 = (var1 or 1) * iter3
		end

		return var1
	end

	local var9 = var8(var1) or 0
	local var10 = var8(var2) or 0

	var0.Battle.BattleAttr.FlashByBuff(arg1, arg0._attr, var9 + var10)
end
