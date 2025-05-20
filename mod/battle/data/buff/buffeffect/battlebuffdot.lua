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
	elseif arg0_3._infection then
		arg0_3._igniteDMG = arg0_3._infection
	else
		arg0_3._igniteDMG = 0
	end

	if arg0_3._cloakExpose and arg0_3._cloakExpose > 0 then
		arg1_3:CloakExpose(arg0_3._cloakExpose)
	end

	arg0_3._infective = arg0_3._tempData.arg_list.infective
	arg0_3._proxy = var0_0.Battle.BattleDataProxy.GetInstance()
end

function var4_0.onStack(arg0_4, arg1_4, arg2_4)
	return
end

function var4_0.onUpdate(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg3_5.timeStamp >= arg0_5._nextEffectTime then
		arg0_5:doDamage(arg1_5, arg2_5)

		if arg1_5:IsAlive() then
			arg0_5._nextEffectTime = arg0_5._nextEffectTime + arg0_5._time
		end
	end
end

function var4_0.onSink(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6:handleInfect(arg1_6, arg2_6)
end

function var4_0.onRemove(arg0_7, arg1_7, arg2_7)
	arg0_7:doDamage(arg1_7, arg2_7)
end

function var4_0.doDamage(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8:IsAlive()
	local var1_8 = arg0_8:CalcNumber(arg1_8, arg2_8)

	arg0_8._proxy:HandleDirectDamage(arg1_8, var1_8)

	if not arg1_8:IsAlive() and var0_8 then
		arg0_8:handleInfect(arg1_8, arg2_8)
	end
end

function var4_0.handleInfect(arg0_9, arg1_9, arg2_9)
	if not arg0_9._infective then
		return
	end

	local var0_9 = arg0_9._infective.target_choise
	local var1_9 = arg0_9._infective.arg_list
	local var2_9 = arg0_9:getTargetList(arg1_9, var0_9, var1_9, {})

	for iter0_9, iter1_9 in ipairs(var2_9) do
		local var3_9 = var0_0.Battle.BattleBuffUnit.New(arg2_9:GetID(), arg2_9:GetLv())

		var3_9:SetInfection(arg0_9._igniteDMG)
		iter1_9:AddBuff(var3_9)
	end
end

function var4_0.CalcNumber(arg0_10, arg1_10, arg2_10)
	if arg0_10._metaDot then
		local var0_10 = var0_0.Battle.BattleDataProxy.GetInstance():GetInitData()

		return (var2_0.CaclulateMetaDotaDamage(var0_10.bossConfigId, var0_10.bossLevel))
	else
		local var1_10 = var2_0.CaclulateDOTDamageEnhanceRate(arg0_10._tempData, arg0_10._orb, arg1_10)
		local var2_10, var3_10 = arg1_10:GetHP()
		local var4_10 = var2_10 * arg0_10._currentHPRatio + var3_10 * arg0_10._maxHPRatio + arg0_10._number + arg0_10._igniteDMG

		if arg0_10._randExtraRange > 0 then
			var4_10 = var4_10 + math.random(0, arg0_10._randExtraRange)
		end

		local var5_10 = var4_10 * (1 + var1_10)

		return math.max(0, math.floor(math.min(var2_10 - var3_10 * arg0_10._minRestHPRatio, var5_10 * arg2_10._stack * var1_0.GetCurrent(arg1_10, "repressReduce"))))
	end
end

function var4_0.SetOrb(arg0_11, arg1_11, arg2_11, arg3_11)
	arg0_11._orb = arg2_11
	arg0_11._level = arg3_11

	arg1_11:SetOrbLevel(arg0_11._level)
end

function var4_0.SetInfection(arg0_12, arg1_12)
	arg0_12._infection = arg1_12
end

function var4_0.UpdateCloakLock(arg0_13)
	local var0_13 = arg0_13:GetBuffList()
	local var1_13 = 0
	local var2_13 = {}

	for iter0_13, iter1_13 in pairs(var0_13) do
		for iter2_13, iter3_13 in ipairs(iter1_13._effectList) do
			if iter3_13:GetEffectType() == var4_0.FX_TYPE then
				local var3_13 = iter3_13._cloakExpose
				local var4_13 = iter3_13._exposeGroup
				local var5_13 = var2_13[var4_13] or 0

				if var5_13 < var3_13 then
					var1_13 = var1_13 + var3_13 - var5_13
					var5_13 = var3_13
				end

				var2_13[var4_13] = var5_13
			end
		end
	end

	arg0_13:CloakOnFire(var1_13)
end
