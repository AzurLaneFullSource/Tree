ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffCastSkill = class("BattleBuffCastSkill", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffCastSkill.__name = "BattleBuffCastSkill"

local var1_0 = var0_0.Battle.BattleBuffCastSkill

var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_CASTER

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._castCount = 0
	arg0_1._fireSkillDMGSum = 0
end

function var1_0.GetEffectType(arg0_2)
	return var1_0.FX_TYPE
end

function var1_0.GetGroupData(arg0_3)
	return arg0_3._group
end

function var1_0.SetArgs(arg0_4, arg1_4, arg2_4)
	arg0_4._level = arg2_4:GetLv()

	local var0_4 = arg0_4._tempData.arg_list

	arg0_4._skill_id = var0_4.skill_id
	arg0_4._target = var0_4.target or "TargetSelf"
	arg0_4._check_target = var0_4.check_target
	arg0_4._check_weapon = var0_4.check_weapon
	arg0_4._check_spweapon = var0_4.check_spweapon
	arg0_4._check_target_gap = var0_4.check_target_gap
	arg0_4._time = var0_4.time or 0

	local var1_4 = pg.TimeMgr.GetInstance():GetCombatTime()

	if var0_4.initialCD then
		arg0_4._nextEffectTime = var1_4
	else
		arg0_4._nextEffectTime = var1_4 + arg0_4._time
	end

	arg0_4._minTargetNumber = var0_4.minTargetNumber or 0
	arg0_4._maxTargetNumber = var0_4.maxTargetNumber or 10000
	arg0_4._minWeaponNumber = var0_4.minWeaponNumber or 0
	arg0_4._maxWeaponNumber = var0_4.maxWeaponNumber or 10000
	arg0_4._rant = var0_4.rant or 10000
	arg0_4._streak = var0_4.streakRange
	arg0_4._dungeonTypeList = var0_4.dungeonTypeList
	arg0_4._effectAttachData = var0_4.effectAttachData
	arg0_4._group = var0_4.group
	arg0_4._srcBuff = arg2_4
end

function var1_0.onBulletCreate(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg0_5:equipIndexRequire(arg3_5.equipIndex) then
		return
	end

	local var0_5 = arg3_5._bullet
	local var1_5 = arg0_5._tempData.arg_list.bulletTrigger

	local function var2_5(arg0_6, arg1_6)
		if arg0_6 and arg0_6:IsAlive() then
			arg0_5:castSkill(arg0_6, arg1_6)
		end
	end

	var0_5:SetBuffFun(var1_5, var2_5)
end

function var1_0.onTrigger(arg0_7, arg1_7, arg2_7, arg3_7)
	return (arg0_7:castSkill(arg1_7, arg3_7, arg2_7))
end

function var1_0.castSkill(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0_8:IsInCD(var0_8) then
		return "overheat"
	end

	if not var0_0.Battle.BattleFormulas.IsHappen(arg0_8._rant) then
		return "chance"
	end

	if arg0_8._check_target then
		local var1_8 = arg0_8:getTargetList(arg1_8, arg0_8._check_target, arg0_8._tempData.arg_list)

		if not var1_8 then
			return "check target none"
		end

		local var2_8 = #var1_8

		if var2_8 < arg0_8._minTargetNumber then
			return "check target min"
		end

		if var2_8 > arg0_8._maxTargetNumber then
			return "check target max"
		end
	end

	if arg0_8._check_target_gap then
		local var3_8 = arg0_8:getTargetList(arg1_8, arg0_8._check_target_gap[1].target, arg0_8._check_target_gap[1].arg)
		local var4_8 = arg0_8:getTargetList(arg1_8, arg0_8._check_target_gap[2].target, arg0_8._check_target_gap[2].arg)
		local var5_8 = math.abs(#var3_8 - #var4_8)

		if var5_8 < arg0_8._minTargetNumber then
			return "check target gap min"
		end

		if var5_8 > arg0_8._maxTargetNumber then
			return "check target gap max"
		end
	end

	if arg0_8._check_weapon then
		local var6_8 = #var1_0.GetEquipmentList(arg1_8, arg0_8._tempData.arg_list)

		if var6_8 < arg0_8._minWeaponNumber then
			return "check weapon min"
		end

		if var6_8 > arg0_8._maxWeaponNumber then
			return "check weapon max"
		end
	end

	if arg0_8._check_spweapon and not var1_0.FilterSpWeapon(arg1_8, arg0_8._tempData.arg_list) then
		return "check spweapon"
	end

	if arg0_8._hpUpperBound or arg0_8._hpLowerBound then
		local var7_8

		if not arg2_8 or not arg2_8.unit then
			var7_8 = arg1_8:GetHPRate()
		else
			var7_8 = arg2_8.unit:GetHPRate()
		end

		if not arg0_8:hpIntervalRequire(var7_8) then
			return "check hp"
		end
	end

	if arg0_8._attrInterval then
		local var8_8 = var0_0.Battle.BattleAttr.GetBase(arg1_8, arg0_8._attrInterval)

		if not arg0_8:attrIntervalRequire(var8_8) then
			return "check interval"
		end
	end

	if arg0_8._streak and not var1_0.GetWinningStreak(arg0_8._streak) then
		return "check winning streak"
	end

	if arg0_8._dungeonTypeList and not var1_0.GetDungeonType(arg0_8._dungeonTypeList) then
		return "check dungeon"
	end

	if arg0_8._effectAttachData and not arg0_8:BuffAttachDataCondition(arg3_8) then
		return "check attach data"
	end

	if arg0_8._fleetAttrRequire and arg2_8 and not arg0_8:fleetAttrRequire(arg1_8, arg2_8.attr) then
		return "check fleet attr"
	end

	if arg0_8._fleetAttrRequire then
		if arg2_8 then
			if not arg0_8:fleetAttrRequire(arg1_8, arg2_8.attr) then
				return
			end
		elseif not arg0_8:fleetAttrRequire(arg1_8) then
			return "check fleet attr"
		end
	end

	if arg0_8._fleetAttrDeltaRequire and arg2_8 and not arg0_8:fleetAttrDelatRequire(arg2_8.delta) then
		return "check fleet attr delta"
	end

	if not arg0_8:stackRequire(arg3_8) then
		return "check buff stack"
	end

	local var9_8 = arg0_8:getTargetList(arg1_8, arg0_8._target, arg0_8._tempData.arg_list)

	var1_0.super.onTrigger(arg0_8, arg1_8)

	for iter0_8, iter1_8 in ipairs(var9_8) do
		local var10_8 = true

		if arg0_8._group then
			local var11_8 = iter1_8:GetBuffList()

			for iter2_8, iter3_8 in pairs(var11_8) do
				for iter4_8, iter5_8 in ipairs(iter3_8._effectList) do
					if iter5_8:GetEffectType() == var1_0.FX_TYPE and iter5_8:GetGroupData() then
						local var12_8 = iter5_8:GetGroupData()

						if var12_8.id == arg0_8._group.id and var12_8.level > arg0_8._group.level then
							var10_8 = false

							break
						end
					end
				end
			end
		end

		if var10_8 then
			arg0_8:spell(iter1_8, arg2_8)
		end
	end

	arg0_8:enterCoolDown(var0_8)
end

function var1_0.IsInCD(arg0_9, arg1_9)
	return arg1_9 < arg0_9._nextEffectTime
end

function var1_0.spell(arg0_10, arg1_10, arg2_10)
	arg0_10._skill = arg0_10._skill or var0_0.Battle.BattleSkillUnit.GenerateSpell(arg0_10._skill_id, arg0_10._level, arg1_10, attData)

	if arg2_10 and arg2_10.target then
		arg0_10._skill:SetTarget({
			arg2_10.target
		})
	end

	arg0_10._skill:Cast(arg1_10, arg0_10._commander)

	arg0_10._castCount = arg0_10._castCount + 1
end

function var1_0.enterCoolDown(arg0_11, arg1_11)
	if arg0_11._time and arg0_11._time > 0 then
		arg0_11._nextEffectTime = arg1_11 + arg0_11._time
	end
end

function var1_0.Interrupt(arg0_12)
	var1_0.super.Interrupt(arg0_12)

	if arg0_12._skill then
		arg0_12._skill:Interrupt()
	end
end

function var1_0.Clear(arg0_13)
	var1_0.super.Clear(arg0_13)

	if arg0_13._skill then
		arg0_13._skill:Clear()

		arg0_13._skill = nil
	end
end

function var1_0.BuffAttachDataCondition(arg0_14, arg1_14)
	local var0_14 = true
	local var1_14 = arg1_14:GetEffectList()

	for iter0_14, iter1_14 in ipairs(var1_14) do
		for iter2_14, iter3_14 in ipairs(arg0_14._effectAttachData) do
			local var2_14 = var0_0.Battle.BattleFormulas.parseCompareBuffAttachData(iter3_14, iter1_14)

			var0_14 = var0_14 and var2_14
		end
	end

	return var0_14
end

function var1_0.GetWinningStreak(arg0_15)
	local var0_15 = var0_0.Battle.BattleDataProxy.GetInstance():GetWinningStreak()
	local var1_15 = arg0_15[1]
	local var2_15 = arg0_15[2]

	return var1_15 <= var0_15 and var0_15 < var2_15
end

function var1_0.GetDungeonType(arg0_16)
	local var0_16 = var0_0.Battle.BattleDataProxy.GetInstance():GetInitData().StageTmpId
	local var1_16 = pg.expedition_data_template[var0_16].type

	return table.contains(arg0_16, var1_16)
end

function var1_0.GetEquipmentList(arg0_17, arg1_17)
	local var0_17 = arg0_17:GetEquipment()
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		var1_17[iter0_17] = iter1_17
	end

	local var2_17 = #var1_17

	while var2_17 > 0 do
		local var3_17 = var1_17[var2_17].equipment
		local var4_17 = true

		if not var3_17 then
			var4_17 = false
		else
			local var5_17 = var0_0.Battle.BattleDataFunction.GetEquipDataTemplate(var3_17.id)

			if arg1_17.weapon_group and not table.contains(arg1_17.weapon_group, var5_17.group) then
				var4_17 = false
			end

			if arg1_17.index and not table.contains(arg1_17.index, var2_17) then
				var4_17 = false
			end

			if arg1_17.type and not table.contains(arg1_17.type, var5_17.type) then
				var4_17 = false
			end

			if arg1_17.label then
				local var6_17 = var0_0.Battle.BattleDataFunction.GetWeaponDataFromID(var3_17.id).label

				for iter2_17, iter3_17 in ipairs(arg1_17.label) do
					if not table.contains(var6_17, iter3_17) then
						var4_17 = false

						break
					end
				end
			end
		end

		if not var4_17 then
			table.remove(var1_17, var2_17)
		end

		var2_17 = var2_17 - 1
	end

	return var1_17
end

function var1_0.FilterSpWeapon(arg0_18, arg1_18)
	local var0_18 = arg0_18:GetSpWeapon()
	local var1_18 = true

	;(function()
		if not var0_18 then
			var1_18 = false

			return
		end

		local var0_19 = var0_0.Battle.BattleDataFunction.GetSpWeaponDataFromID(var0_18:GetConfigID())

		if arg1_18.type and not table.contains(arg1_18.type, var0_19.type) then
			var1_18 = false
		end

		if arg1_18.label then
			for iter0_19, iter1_19 in ipairs(arg1_18.label) do
				if not table.contains(var0_19.label, iter1_19) then
					var1_18 = false

					return
				end
			end
		end
	end)()

	return var1_18 and var0_18 or nil
end

function var1_0.GetCastCount(arg0_20)
	return arg0_20._castCount
end

function var1_0.GetSkillFireDamageSum(arg0_21)
	arg0_21._fireSkillDMGSum = math.max(arg0_21._skill and arg0_21._skill:GetDamageSum() or 0, arg0_21._fireSkillDMGSum)

	return arg0_21._fireSkillDMGSum
end
