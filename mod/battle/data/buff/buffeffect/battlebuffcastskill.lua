ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffCastSkill = class("BattleBuffCastSkill", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffCastSkill.__name = "BattleBuffCastSkill"

local var1 = var0.Battle.BattleBuffCastSkill

var1.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_CASTER

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)

	arg0._castCount = 0
	arg0._fireSkillDMGSum = 0
end

function var1.GetEffectType(arg0)
	return var1.FX_TYPE
end

function var1.GetGroupData(arg0)
	return arg0._group
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._level = arg2:GetLv()

	local var0 = arg0._tempData.arg_list

	arg0._skill_id = var0.skill_id
	arg0._target = var0.target or "TargetSelf"
	arg0._check_target = var0.check_target
	arg0._check_weapon = var0.check_weapon
	arg0._check_spweapon = var0.check_spweapon
	arg0._check_target_gap = var0.check_target_gap
	arg0._time = var0.time or 0

	local var1 = pg.TimeMgr.GetInstance():GetCombatTime()

	if var0.initialCD then
		arg0._nextEffectTime = var1
	else
		arg0._nextEffectTime = var1 + arg0._time
	end

	arg0._minTargetNumber = var0.minTargetNumber or 0
	arg0._maxTargetNumber = var0.maxTargetNumber or 10000
	arg0._minWeaponNumber = var0.minWeaponNumber or 0
	arg0._maxWeaponNumber = var0.maxWeaponNumber or 10000
	arg0._rant = var0.rant or 10000
	arg0._streak = var0.streakRange
	arg0._dungeonTypeList = var0.dungeonTypeList
	arg0._effectAttachData = var0.effectAttachData
	arg0._group = var0.group
	arg0._srcBuff = arg2
end

function var1.onBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	local var0 = arg3._bullet
	local var1 = arg0._tempData.arg_list.bulletTrigger

	local function var2(arg0, arg1)
		if arg0 and arg0:IsAlive() then
			arg0:castSkill(arg0, arg1)
		end
	end

	var0:SetBuffFun(var1, var2)
end

function var1.onTrigger(arg0, arg1, arg2, arg3)
	return (arg0:castSkill(arg1, arg3, arg2))
end

function var1.castSkill(arg0, arg1, arg2, arg3)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0:IsInCD(var0) then
		return "overheat"
	end

	if not var0.Battle.BattleFormulas.IsHappen(arg0._rant) then
		return "chance"
	end

	if arg0._check_target then
		local var1 = arg0:getTargetList(arg1, arg0._check_target, arg0._tempData.arg_list)

		if not var1 then
			return "check target none"
		end

		local var2 = #var1

		if var2 < arg0._minTargetNumber then
			return "check target min"
		end

		if var2 > arg0._maxTargetNumber then
			return "check target max"
		end
	end

	if arg0._check_target_gap then
		local var3 = arg0:getTargetList(arg1, arg0._check_target_gap[1].target, arg0._check_target_gap[1].arg)
		local var4 = arg0:getTargetList(arg1, arg0._check_target_gap[2].target, arg0._check_target_gap[2].arg)
		local var5 = math.abs(#var3 - #var4)

		if var5 < arg0._minTargetNumber then
			return "check target gap min"
		end

		if var5 > arg0._maxTargetNumber then
			return "check target gap max"
		end
	end

	if arg0._check_weapon then
		local var6 = #var1.GetEquipmentList(arg1, arg0._tempData.arg_list)

		if var6 < arg0._minWeaponNumber then
			return "check weapon min"
		end

		if var6 > arg0._maxWeaponNumber then
			return "check weapon max"
		end
	end

	if arg0._check_spweapon and not var1.FilterSpWeapon(arg1, arg0._tempData.arg_list) then
		return "check spweapon"
	end

	if arg0._hpUpperBound or arg0._hpLowerBound then
		local var7

		if not arg2 or not arg2.unit then
			var7 = arg1:GetHPRate()
		else
			var7 = arg2.unit:GetHPRate()
		end

		if not arg0:hpIntervalRequire(var7) then
			return "check hp"
		end
	end

	if arg0._attrInterval then
		local var8 = var0.Battle.BattleAttr.GetBase(arg1, arg0._attrInterval)

		if not arg0:attrIntervalRequire(var8) then
			return "check interval"
		end
	end

	if arg0._streak and not var1.GetWinningStreak(arg0._streak) then
		return "check winning streak"
	end

	if arg0._dungeonTypeList and not var1.GetDungeonType(arg0._dungeonTypeList) then
		return "check dungeon"
	end

	if arg0._effectAttachData and not arg0:BuffAttachDataCondition(arg3) then
		return "check attach data"
	end

	if not arg0:fleetAttrRequire(arg1) then
		return "check fleet attr"
	end

	if arg0._fleetAttrDeltaRequire and arg2 and not arg0:fleetAttrDelatRequire(arg2.delta) then
		return "check fleet attr delta"
	end

	if not arg0:stackRequire(arg3) then
		return "check buff stack"
	end

	local var9 = arg0:getTargetList(arg1, arg0._target, arg0._tempData.arg_list)

	var1.super.onTrigger(arg0, arg1)

	for iter0, iter1 in ipairs(var9) do
		local var10 = true

		if arg0._group then
			local var11 = iter1:GetBuffList()

			for iter2, iter3 in pairs(var11) do
				for iter4, iter5 in ipairs(iter3._effectList) do
					if iter5:GetEffectType() == var1.FX_TYPE and iter5:GetGroupData() then
						local var12 = iter5:GetGroupData()

						if var12.id == arg0._group.id and var12.level > arg0._group.level then
							var10 = false

							break
						end
					end
				end
			end
		end

		if var10 then
			arg0:spell(iter1, arg2)
		end
	end

	arg0:enterCoolDown(var0)
end

function var1.IsInCD(arg0, arg1)
	return arg1 < arg0._nextEffectTime
end

function var1.spell(arg0, arg1, arg2)
	arg0._skill = arg0._skill or var0.Battle.BattleSkillUnit.GenerateSpell(arg0._skill_id, arg0._level, arg1, attData)

	if arg2 and arg2.target then
		arg0._skill:SetTarget({
			arg2.target
		})
	end

	arg0._skill:Cast(arg1, arg0._commander)

	arg0._castCount = arg0._castCount + 1
end

function var1.enterCoolDown(arg0, arg1)
	if arg0._time and arg0._time > 0 then
		arg0._nextEffectTime = arg1 + arg0._time
	end
end

function var1.Interrupt(arg0)
	var1.super.Interrupt(arg0)

	if arg0._skill then
		arg0._skill:Interrupt()
	end
end

function var1.Clear(arg0)
	var1.super.Clear(arg0)

	if arg0._skill then
		arg0._skill:Clear()

		arg0._skill = nil
	end
end

function var1.BuffAttachDataCondition(arg0, arg1)
	local var0 = true
	local var1 = arg1:GetEffectList()

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in ipairs(arg0._effectAttachData) do
			local var2 = var0.Battle.BattleFormulas.parseCompareBuffAttachData(iter3, iter1)

			var0 = var0 and var2
		end
	end

	return var0
end

function var1.GetWinningStreak(arg0)
	local var0 = var0.Battle.BattleDataProxy.GetInstance():GetWinningStreak()
	local var1 = arg0[1]
	local var2 = arg0[2]

	return var1 <= var0 and var0 < var2
end

function var1.GetDungeonType(arg0)
	local var0 = var0.Battle.BattleDataProxy.GetInstance():GetInitData().StageTmpId
	local var1 = pg.expedition_data_template[var0].type

	return table.contains(arg0, var1)
end

function var1.GetEquipmentList(arg0, arg1)
	local var0 = arg0:GetEquipment()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[iter0] = iter1
	end

	local var2 = #var1

	while var2 > 0 do
		local var3 = var1[var2].equipment
		local var4 = true

		if not var3 then
			var4 = false
		else
			local var5 = var0.Battle.BattleDataFunction.GetEquipDataTemplate(var3.id)

			if arg1.weapon_group and not table.contains(arg1.weapon_group, var5.group) then
				var4 = false
			end

			if arg1.index and not table.contains(arg1.index, var2) then
				var4 = false
			end

			if arg1.type and not table.contains(arg1.type, var5.type) then
				var4 = false
			end

			if arg1.label then
				local var6 = var0.Battle.BattleDataFunction.GetWeaponDataFromID(var3.id).label

				for iter2, iter3 in ipairs(arg1.label) do
					if not table.contains(var6, iter3) then
						var4 = false

						break
					end
				end
			end
		end

		if not var4 then
			table.remove(var1, var2)
		end

		var2 = var2 - 1
	end

	return var1
end

function var1.FilterSpWeapon(arg0, arg1)
	local var0 = arg0:GetSpWeapon()
	local var1 = true

	;(function()
		if not var0 then
			var1 = false

			return
		end

		local var0 = var0.Battle.BattleDataFunction.GetSpWeaponDataFromID(var0:GetConfigID())

		if arg1.type and not table.contains(arg1.type, var0.type) then
			var1 = false
		end

		if arg1.label then
			for iter0, iter1 in ipairs(arg1.label) do
				if not table.contains(var0.label, iter1) then
					var1 = false

					return
				end
			end
		end
	end)()

	return var1 and var0 or nil
end

function var1.GetCastCount(arg0)
	return arg0._castCount
end

function var1.GetSkillFireDamageSum(arg0)
	arg0._fireSkillDMGSum = math.max(arg0._skill and arg0._skill:GetDamageSum() or 0, arg0._fireSkillDMGSum)

	return arg0._fireSkillDMGSum
end
