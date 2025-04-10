ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBuffEvent
local var2_0 = var0_0.Battle.BattleConst.BuffEffectType
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = class("BattleBuffUnit")

var0_0.Battle.BattleBuffUnit = var4_0
var4_0.__name = "BattleBuffUnit"
var4_0.DEFAULT_ANI_FX_CONFIG = {
	effect = "jineng",
	offset = {
		0,
		-2,
		0
	}
}

function var4_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg2_1 = arg2_1 or 1
	arg0_1._id = arg1_1

	arg0_1:SetTemplate(arg1_1, arg2_1)

	arg0_1._time = arg0_1._tempData.time
	arg0_1._RemoveTime = 0
	arg0_1._effectList = {}
	arg0_1._triggerSearchTable = {}
	arg0_1._level = arg2_1
	arg0_1._caster = arg3_1
	arg0_1._forceStack = arg0_1._tempData.force_stack

	for iter0_1, iter1_1 in ipairs(arg0_1._tempData.effect_list) do
		local var0_1 = var0_0.Battle[iter1_1.type].New(iter1_1)

		arg0_1._effectList[iter0_1] = var0_1

		local var1_1 = iter1_1.trigger

		for iter2_1, iter3_1 in ipairs(var1_1) do
			local var2_1 = arg0_1._triggerSearchTable[iter3_1]

			if var2_1 == nil then
				var2_1 = {}
				arg0_1._triggerSearchTable[iter3_1] = var2_1
			end

			var2_1[#var2_1 + 1] = var0_1
		end
	end
end

function var4_0.GetTriggerPriority(arg0_2, arg1_2)
	local var0_2 = var3_0.TRIGGER_PRIORITY[arg1_2]
	local var1_2 = math.huge

	for iter0_2, iter1_2 in ipairs(arg0_2._tempData.effect_list) do
		local var2_2 = var0_2[iter1_2.type] or var3_0.TRIGGER_PRIORITY_LOWEST

		var1_2 = math.min(var1_2, var2_2)
	end

	return var1_2
end

function var4_0.SetTemplate(arg0_3, arg1_3, arg2_3)
	arg0_3._tempData = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_3, arg2_3)
end

function var4_0.Attach(arg0_4, arg1_4)
	arg0_4._owner = arg1_4
	arg0_4._stack = 1

	arg0_4:SetArgs(arg1_4)
	arg0_4:onTrigger(var2_0.ON_ATTACH, arg1_4)
	arg0_4:SetRemoveTime()
end

function var4_0.Stack(arg0_5, arg1_5)
	arg0_5._stack = math.min(arg0_5._stack + 1, arg0_5._tempData.stack)

	arg0_5:onTrigger(var2_0.ON_STACK, arg1_5)
	arg0_5:SetRemoveTime()
end

function var4_0.SetOrb(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in ipairs(arg0_6._effectList) do
		iter1_6:SetOrb(arg0_6, arg1_6, arg2_6)
	end
end

function var4_0.SetOrbDuration(arg0_7, arg1_7)
	arg0_7._time = arg1_7 + arg0_7._time
end

function var4_0.SetOrbLevel(arg0_8, arg1_8)
	arg0_8._level = arg1_8
end

function var4_0.SetCommander(arg0_9, arg1_9)
	arg0_9._commander = arg1_9

	for iter0_9, iter1_9 in ipairs(arg0_9._effectList) do
		iter1_9:SetCommander(arg1_9)
	end
end

function var4_0.GetEffectList(arg0_10)
	return arg0_10._effectList
end

function var4_0.GetCommander(arg0_11)
	return arg0_11._commander
end

function var4_0.UpdateStack(arg0_12, arg1_12, arg2_12)
	if arg0_12._stack == arg2_12 then
		return
	end

	arg0_12._stack = math.min(arg2_12, arg0_12._tempData.stack)

	arg0_12:onTrigger(var2_0.ON_STACK, arg1_12)
	arg0_12:SetRemoveTime()

	local var0_12 = {
		unit_id = arg1_12:GetUniqueID(),
		buff_id = arg0_12._id,
		stack_count = arg0_12._stack
	}

	arg1_12:DispatchEvent(var0_0.Event.New(var1_0.BUFF_STACK, var0_12))
end

function var4_0.Remove(arg0_13, arg1_13)
	local var0_13 = arg0_13._owner
	local var1_13 = arg0_13._id
	local var2_13 = {
		unit_id = var0_13:GetUniqueID(),
		buff_id = var1_13
	}

	var0_13:DispatchEvent(var0_0.Event.New(var1_0.BUFF_REMOVE, var2_13))
	arg0_13:onTrigger(var2_0.ON_REMOVE, var0_13)
	arg0_13:Clear()

	var0_13:GetBuffList()[var1_13] = nil
end

function var4_0.Update(arg0_14, arg1_14, arg2_14)
	if arg0_14:IsTimeToRemove(arg2_14) then
		arg0_14:Remove(arg2_14)
	else
		arg0_14:onTrigger(var2_0.ON_UPDATE, arg1_14, {
			timeStamp = arg2_14
		})
	end
end

function var4_0.SetArgs(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg0_15._effectList) do
		iter1_15:SetCaster(arg0_15._caster)
		iter1_15:SetArgs(arg1_15, arg0_15)
	end
end

function var4_0.Trigger(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16:GetBuffList() or {}
	local var1_16 = {}

	for iter0_16, iter1_16 in pairs(var0_16) do
		local var2_16 = iter1_16._triggerSearchTable[arg1_16]

		if var2_16 ~= nil and #var2_16 > 0 then
			var1_16[#var1_16 + 1] = iter1_16
		end
	end

	var4_0.sortTriggerBuff(var1_16, arg1_16)

	for iter2_16, iter3_16 in ipairs(var1_16) do
		iter3_16:onTrigger(arg1_16, arg0_16, arg2_16)
	end
end

function var4_0.sortTriggerBuff(arg0_17, arg1_17)
	if not var3_0.TRIGGER_PRIORITY[arg1_17] then
		return arg0_17
	end

	local var0_17 = var3_0.TRIGGER_PRIORITY[arg1_17]

	table.sort(arg0_17, function(arg0_18, arg1_18)
		return arg0_18:GetTriggerPriority(arg1_17) < arg1_18:GetTriggerPriority(arg1_17)
	end)
end

function var4_0.DisptachSkillFloat(arg0_19, arg1_19, arg2_19, arg3_19)
	if arg3_19.trigger == nil or table.contains(arg3_19.trigger, arg2_19) then
		local var0_19

		if arg3_19.painting and type(arg3_19.painting) == "string" then
			var0_19 = arg3_19
		end

		local var1_19 = getSkillName(arg3_19.displayID or arg0_19._id)

		arg1_19:DispatchSkillFloat(var1_19, nil, var0_19)

		local var2_19

		if arg3_19.castCV ~= false then
			var2_19 = arg3_19.castCV or "skill"
		end

		local var3_19 = type(var2_19)

		if var3_19 == "string" then
			arg1_19:DispatchVoice(var2_19)
		elseif var3_19 == "table" then
			local var4_19, var5_19, var6_19 = ShipWordHelper.GetWordAndCV(var2_19.skinID, var2_19.key)

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_19)
		end

		local var7_19 = arg3_19.aniEffect or var4_0.DEFAULT_ANI_FX_CONFIG
		local var8_19 = {
			effect = var7_19.effect,
			offset = var7_19.offset
		}

		arg1_19:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ADD_EFFECT, var8_19))
	end
end

function var4_0.IsSubmarineSpecial(arg0_20)
	local var0_20 = arg0_20._triggerSearchTable[var0_0.Battle.BattleConst.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL] or {}

	for iter0_20, iter1_20 in ipairs(var0_20) do
		if iter1_20:HaveQuota() then
			return true
		end
	end

	return false
end

function var4_0.onTrigger(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg0_21._triggerSearchTable[arg1_21]

	if var0_21 == nil or #var0_21 == 0 then
		return
	end

	for iter0_21, iter1_21 in ipairs(var0_21) do
		assert(type(iter1_21[arg1_21]) == "function", "buff效果的触发名字和触发函数不相符,buff id:>>" .. arg0_21._id .. "<<, trigger:>>" .. arg1_21 .. "<<")

		if iter1_21:HaveQuota() and iter1_21:IsActive() then
			iter1_21:NotActive()
			iter1_21:Trigger(arg1_21, arg2_21, arg0_21, arg3_21)

			local var1_21 = iter1_21:GetPopConfig()

			if var1_21 then
				arg0_21:DisptachSkillFloat(arg2_21, arg1_21, var1_21)
			end

			iter1_21:SetActive()
		end

		if arg0_21._isCancel then
			break
		end
	end

	if arg0_21._isCancel then
		arg0_21._isCancel = nil

		arg0_21:Remove()
	end
end

function var4_0.SetRemoveTime(arg0_22)
	local var0_22 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_22._buffStartTimeStamp = var0_22
	arg0_22._RemoveTime = var0_22 + arg0_22._time
	arg0_22._cancelTime = nil
end

function var4_0.IsTimeToRemove(arg0_23, arg1_23)
	if arg0_23._isCancel then
		return true
	elseif arg0_23._cancelTime and arg1_23 >= arg0_23._cancelTime then
		return true
	elseif arg0_23._time == 0 then
		return false
	else
		return arg1_23 >= arg0_23._RemoveTime
	end
end

function var4_0.GetBuffLifeTime(arg0_24)
	return arg0_24._time
end

function var4_0.GetBuffStartTime(arg0_25)
	return arg0_25._buffStartTimeStamp
end

function var4_0.Interrupt(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26._effectList) do
		iter1_26:Interrupt()
	end
end

function var4_0.Clear(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27._effectList) do
		iter1_27:Clear()
	end
end

function var4_0.GetID(arg0_28)
	return arg0_28._id
end

function var4_0.GetCaster(arg0_29)
	return arg0_29._caster
end

function var4_0.GetLv(arg0_30)
	return arg0_30._level or 1
end

function var4_0.GetDuration(arg0_31)
	return arg0_31._time
end

function var4_0.GetStack(arg0_32)
	return arg0_32._stack or 1
end

function var4_0.IsForceStack(arg0_33)
	return arg0_33._forceStack
end

function var4_0.SetToCancel(arg0_34, arg1_34)
	if arg1_34 then
		if not arg0_34._cancelTime then
			arg0_34._cancelTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1_34
		end
	else
		arg0_34._isCancel = true
	end
end

function var4_0.Dispose(arg0_35)
	arg0_35._triggerSearchTable = nil
	arg0_35._commander = nil
end
