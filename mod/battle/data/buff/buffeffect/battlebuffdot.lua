ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleAttr
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConfig

var0.Battle.BattleBuffDOT = class("BattleBuffDOT", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffDOT.__name = "BattleBuffDOT"

local var4 = var0.Battle.BattleBuffDOT

var4.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_DOT

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1)
end

function var4.GetEffectType(arg0)
	return var0.Battle.BattleBuffEffect.FX_TYPE_DOT
end

function var4.SetArgs(arg0, arg1, arg2)
	arg0._number = arg0._tempData.arg_list.number or 0
	arg0._numberBase = arg0._number
	arg0._time = arg0._tempData.arg_list.time or 0
	arg0._nextEffectTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._time
	arg0._maxHPRatio = arg0._tempData.arg_list.maxHPRatio or 0
	arg0._currentHPRatio = arg0._tempData.arg_list.currentHPRatio or 0
	arg0._minRestHPRatio = arg0._tempData.arg_list.minRestHPRatio or 0
	arg0._randExtraRange = arg0._tempData.arg_list.randExtraRange or 0
	arg0._cloakExpose = arg0._tempData.arg_list.cloakExpose or 0
	arg0._exposeGroup = arg0._tempData.arg_list._exposeGroup or arg2:GetID()
	arg0._level = arg0._level or 0
	arg0._metaDot = arg0._tempData.arg_list.metaDot

	local var0 = 0

	if not arg0._metaDot then
		var0 = var2.CaclulateDOTDuration(arg0._tempData, arg0._orb, arg1)
	end

	arg2:SetOrbDuration(var0)

	if arg0._tempData.arg_list.WorldBossDotDamage then
		local var1 = arg0._tempData.arg_list.WorldBossDotDamage

		arg0._igniteDMG = (var0.Battle.BattleDataProxy.GetInstance():GetInitData()[var1.useGlobalAttr] or pg.bfConsts.NUM0) * (var1.paramA or pg.bfConsts.NUM1)
	elseif arg0._orb then
		arg0._igniteAttr = arg0._tempData.arg_list.attr
		arg0._igniteCoefficient = arg0._tempData.arg_list.k
		arg0._igniteDMG = var2.CalculateIgniteDamage(arg0._orb, arg0._igniteAttr, arg0._igniteCoefficient)
	else
		arg0._igniteDMG = 0
	end

	if arg0._cloakExpose and arg0._cloakExpose > 0 then
		arg1:CloakExpose(arg0._cloakExpose)
	end
end

function var4.onStack(arg0, arg1, arg2)
	return
end

function var4.onUpdate(arg0, arg1, arg2, arg3)
	if arg3.timeStamp >= arg0._nextEffectTime then
		local var0 = arg0:CalcNumber(arg1, arg2)
		local var1 = {
			isMiss = false,
			isCri = false,
			isHeal = false
		}
		local var2 = arg1:UpdateHP(-var0, var1)

		var0.Battle.BattleDataProxy.GetInstance():DamageStatistics(nil, arg1:GetAttrByName("id"), -var2)

		if arg1:IsAlive() then
			arg0._nextEffectTime = arg0._nextEffectTime + arg0._time
		end
	end
end

function var4.onRemove(arg0, arg1, arg2)
	local var0 = arg0:CalcNumber(arg1, arg2)
	local var1 = {
		isMiss = false,
		isCri = false,
		isHeal = false
	}
	local var2 = arg1:UpdateHP(-var0, var1)

	var0.Battle.BattleDataProxy.GetInstance():DamageStatistics(nil, arg1:GetAttrByName("id"), -var2)
end

function var4.CalcNumber(arg0, arg1, arg2)
	if arg0._metaDot then
		local var0 = var0.Battle.BattleDataProxy.GetInstance():GetInitData()

		return (var2.CaclulateMetaDotaDamage(var0.bossConfigId, var0.bossLevel))
	else
		local var1 = var2.CaclulateDOTDamageEnhanceRate(arg0._tempData, arg0._orb, arg1)
		local var2, var3 = arg1:GetHP()
		local var4 = var2 * arg0._currentHPRatio + var3 * arg0._maxHPRatio + arg0._number + arg0._igniteDMG

		if arg0._randExtraRange > 0 then
			var4 = var4 + math.random(0, arg0._randExtraRange)
		end

		local var5 = var4 * (1 + var1)

		return math.max(0, math.floor(math.min(var2 - var3 * arg0._minRestHPRatio, var5 * arg2._stack * var1.GetCurrent(arg1, "repressReduce"))))
	end
end

function var4.SetOrb(arg0, arg1, arg2, arg3)
	arg0._orb = arg2
	arg0._level = arg3

	arg1:SetOrbLevel(arg0._level)
end

function var4.UpdateCloakLock(arg0)
	local var0 = arg0:GetBuffList()
	local var1 = 0
	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		for iter2, iter3 in ipairs(iter1._effectList) do
			if iter3:GetEffectType() == var4.FX_TYPE then
				local var3 = iter3._cloakExpose
				local var4 = iter3._exposeGroup
				local var5 = var2[var4] or 0

				if var5 < var3 then
					var1 = var1 + var3 - var5
					var5 = var3
				end

				var2[var4] = var5
			end
		end
	end

	arg0:CloakOnFire(var1)
end
