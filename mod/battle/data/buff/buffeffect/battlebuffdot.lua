ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleAttr
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleBuffDOT = class("BattleBuffDOT", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffDOT.__name = "BattleBuffDOT"

local var4_0 = var0_0.Battle.BattleBuffDOT

var4_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_DOT

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1)
end

function var4_0.GetEffectType(arg0_2)
	return var0_0.Battle.BattleBuffEffect.FX_TYPE_DOT
end

function var4_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._number = arg0_3._tempData.arg_list.number or 0
	arg0_3._numberBase = arg0_3._number
	arg0_3._time = arg0_3._tempData.arg_list.time or 0
	arg0_3._nextEffectTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_3._time
	arg0_3._maxHPRatio = arg0_3._tempData.arg_list.maxHPRatio or 0
	arg0_3._currentHPRatio = arg0_3._tempData.arg_list.currentHPRatio or 0
	arg0_3._minRestHPRatio = arg0_3._tempData.arg_list.minRestHPRatio or 0
	arg0_3._randExtraRange = arg0_3._tempData.arg_list.randExtraRange or 0
	arg0_3._cloakExpose = arg0_3._tempData.arg_list.cloakExpose or 0
	arg0_3._exposeGroup = arg0_3._tempData.arg_list._exposeGroup or arg2_3:GetID()
	arg0_3._level = arg0_3._level or 0
	arg0_3._metaDot = arg0_3._tempData.arg_list.metaDot

	local var0_3 = 0

	if not arg0_3._metaDot then
		var0_3 = var2_0.CaclulateDOTDuration(arg0_3._tempData, arg0_3._orb, arg1_3)
	end

	arg2_3:SetOrbDuration(var0_3)

	if arg0_3._tempData.arg_list.WorldBossDotDamage then
		local var1_3 = arg0_3._tempData.arg_list.WorldBossDotDamage

		arg0_3._igniteDMG = (var0_0.Battle.BattleDataProxy.GetInstance():GetInitData()[var1_3.useGlobalAttr] or pg.bfConsts.NUM0) * (var1_3.paramA or pg.bfConsts.NUM1)
	elseif arg0_3._orb then
		arg0_3._igniteAttr = arg0_3._tempData.arg_list.attr
		arg0_3._igniteCoefficient = arg0_3._tempData.arg_list.k
		arg0_3._igniteDMG = var2_0.CalculateIgniteDamage(arg0_3._orb, arg0_3._igniteAttr, arg0_3._igniteCoefficient)
	else
		arg0_3._igniteDMG = 0
	end

	if arg0_3._cloakExpose and arg0_3._cloakExpose > 0 then
		arg1_3:CloakExpose(arg0_3._cloakExpose)
	end
end

function var4_0.onStack(arg0_4, arg1_4, arg2_4)
	return
end

function var4_0.onUpdate(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg3_5.timeStamp >= arg0_5._nextEffectTime then
		local var0_5 = arg0_5:CalcNumber(arg1_5, arg2_5)
		local var1_5 = {
			isMiss = false,
			isCri = false,
			isHeal = false
		}
		local var2_5 = arg1_5:UpdateHP(-var0_5, var1_5)

		var0_0.Battle.BattleDataProxy.GetInstance():DamageStatistics(nil, arg1_5:GetAttrByName("id"), -var2_5)

		if arg1_5:IsAlive() then
			arg0_5._nextEffectTime = arg0_5._nextEffectTime + arg0_5._time
		end
	end
end

function var4_0.onRemove(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:CalcNumber(arg1_6, arg2_6)
	local var1_6 = {
		isMiss = false,
		isCri = false,
		isHeal = false
	}
	local var2_6 = arg1_6:UpdateHP(-var0_6, var1_6)

	var0_0.Battle.BattleDataProxy.GetInstance():DamageStatistics(nil, arg1_6:GetAttrByName("id"), -var2_6)
end

function var4_0.CalcNumber(arg0_7, arg1_7, arg2_7)
	if arg0_7._metaDot then
		local var0_7 = var0_0.Battle.BattleDataProxy.GetInstance():GetInitData()

		return (var2_0.CaclulateMetaDotaDamage(var0_7.bossConfigId, var0_7.bossLevel))
	else
		local var1_7 = var2_0.CaclulateDOTDamageEnhanceRate(arg0_7._tempData, arg0_7._orb, arg1_7)
		local var2_7, var3_7 = arg1_7:GetHP()
		local var4_7 = var2_7 * arg0_7._currentHPRatio + var3_7 * arg0_7._maxHPRatio + arg0_7._number + arg0_7._igniteDMG

		if arg0_7._randExtraRange > 0 then
			var4_7 = var4_7 + math.random(0, arg0_7._randExtraRange)
		end

		local var5_7 = var4_7 * (1 + var1_7)

		return math.max(0, math.floor(math.min(var2_7 - var3_7 * arg0_7._minRestHPRatio, var5_7 * arg2_7._stack * var1_0.GetCurrent(arg1_7, "repressReduce"))))
	end
end

function var4_0.SetOrb(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8._orb = arg2_8
	arg0_8._level = arg3_8

	arg1_8:SetOrbLevel(arg0_8._level)
end

function var4_0.UpdateCloakLock(arg0_9)
	local var0_9 = arg0_9:GetBuffList()
	local var1_9 = 0
	local var2_9 = {}

	for iter0_9, iter1_9 in pairs(var0_9) do
		for iter2_9, iter3_9 in ipairs(iter1_9._effectList) do
			if iter3_9:GetEffectType() == var4_0.FX_TYPE then
				local var3_9 = iter3_9._cloakExpose
				local var4_9 = iter3_9._exposeGroup
				local var5_9 = var2_9[var4_9] or 0

				if var5_9 < var3_9 then
					var1_9 = var1_9 + var3_9 - var5_9
					var5_9 = var3_9
				end

				var2_9[var4_9] = var5_9
			end
		end
	end

	arg0_9:CloakOnFire(var1_9)
end
