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
	arg0_1._stackCap = arg0_1._tempData.stack_cap or arg0_1._tempData.stack

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

function var4_0.SetGroupLevel(arg0_9, arg1_9)
	arg0_9._groupLevel = arg1_9
end

function var4_0.GetGroupLevel(arg0_10)
	return arg0_10._groupLevel or 1
end

function var4_0.SetInfection(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11._effectList) do
		if iter1_11.SetInfection then
			iter1_11:SetInfection(arg1_11)
		end
	end
end

function var4_0.SetCommander(arg0_12, arg1_12)
	arg0_12._commander = arg1_12

	for iter0_12, iter1_12 in ipairs(arg0_12._effectList) do
		iter1_12:SetCommander(arg1_12)
	end
end

function var4_0.GetEffectList(arg0_13)
	return arg0_13._effectList
end

function var4_0.GetCommander(arg0_14)
	return arg0_14._commander
end

function var4_0.UpdateStack(arg0_15, arg1_15, arg2_15)
	if arg0_15._stack == arg2_15 then
		return
	end

	arg0_15._stack = math.min(arg2_15, arg0_15._tempData.stack)

	arg0_15:onTrigger(var2_0.ON_STACK, arg1_15)
	arg0_15:SetRemoveTime()

	local var0_15 = {
		unit_id = arg1_15:GetUniqueID(),
		buff_id = arg0_15._id,
		stack_count = arg0_15._stack
	}

	arg1_15:DispatchEvent(var0_0.Event.New(var1_0.BUFF_STACK, var0_15))
end

function var4_0.Remove(arg0_16, arg1_16)
	local var0_16 = arg0_16._owner
	local var1_16 = arg0_16._id
	local var2_16 = {
		unit_id = var0_16:GetUniqueID(),
		buff_id = var1_16
	}

	var0_16:DispatchEvent(var0_0.Event.New(var1_0.BUFF_REMOVE, var2_16))
	arg0_16:onTrigger(var2_0.ON_REMOVE, var0_16)
	arg0_16:Clear()

	var0_16:GetBuffList()[var1_16] = nil
end

function var4_0.Update(arg0_17, arg1_17, arg2_17)
	if arg0_17:IsTimeToRemove(arg2_17) then
		arg0_17:Remove(arg2_17)
	else
		arg0_17:onTrigger(var2_0.ON_UPDATE, arg1_17, {
			timeStamp = arg2_17
		})
	end
end

function var4_0.SetArgs(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18._effectList) do
		iter1_18:SetCaster(arg0_18._caster)
		iter1_18:SetArgs(arg1_18, arg0_18)
	end
end

function var4_0.Trigger(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19:GetBuffList() or {}
	local var1_19 = {}

	for iter0_19, iter1_19 in pairs(var0_19) do
		local var2_19 = iter1_19._triggerSearchTable[arg1_19]

		if var2_19 ~= nil and #var2_19 > 0 then
			var1_19[#var1_19 + 1] = iter1_19
		end
	end

	var4_0.sortTriggerBuff(var1_19, arg1_19)

	for iter2_19, iter3_19 in ipairs(var1_19) do
		iter3_19:onTrigger(arg1_19, arg0_19, arg2_19)
	end
end

function var4_0.sortTriggerBuff(arg0_20, arg1_20)
	if not var3_0.TRIGGER_PRIORITY[arg1_20] then
		return arg0_20
	end

	local var0_20 = var3_0.TRIGGER_PRIORITY[arg1_20]

	table.sort(arg0_20, function(arg0_21, arg1_21)
		return arg0_21:GetTriggerPriority(arg1_20) < arg1_21:GetTriggerPriority(arg1_20)
	end)
end

function var4_0.DisptachSkillFloat(arg0_22, arg1_22, arg2_22, arg3_22)
	if arg3_22.trigger == nil or table.contains(arg3_22.trigger, arg2_22) then
		local var0_22

		if arg3_22.painting and type(arg3_22.painting) == "string" then
			var0_22 = arg3_22
		end

		local var1_22 = getSkillName(arg3_22.displayID or arg0_22._id)

		arg1_22:DispatchSkillFloat(var1_22, nil, var0_22)

		local var2_22

		if arg3_22.castCV ~= false then
			var2_22 = arg3_22.castCV or "skill"
		end

		local var3_22 = type(var2_22)

		if var3_22 == "string" then
			arg1_22:DispatchVoice(var2_22)
		elseif var3_22 == "table" then
			local var4_22, var5_22, var6_22 = ShipWordHelper.GetWordAndCV(var2_22.skinID, var2_22.key)

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_22)
		end

		local var7_22 = arg3_22.aniEffect or var4_0.DEFAULT_ANI_FX_CONFIG
		local var8_22 = {
			effect = var7_22.effect,
			offset = var7_22.offset
		}

		arg1_22:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ADD_EFFECT, var8_22))
	end
end

function var4_0.IsSubmarineSpecial(arg0_23)
	local var0_23 = arg0_23._triggerSearchTable[var0_0.Battle.BattleConst.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL] or {}

	for iter0_23, iter1_23 in ipairs(var0_23) do
		if iter1_23:HaveQuota() then
			return true
		end
	end

	return false
end

function var4_0.onTrigger(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg0_24._triggerSearchTable[arg1_24]

	if var0_24 == nil or #var0_24 == 0 then
		return
	end

	for iter0_24, iter1_24 in ipairs(var0_24) do
		assert(type(iter1_24[arg1_24]) == "function", "buff效果的触发名字和触发函数不相符,buff id:>>" .. arg0_24._id .. "<<, trigger:>>" .. arg1_24 .. "<<")

		if iter1_24:HaveQuota() and iter1_24:IsActive() then
			iter1_24:NotActive()
			iter1_24:Trigger(arg1_24, arg2_24, arg0_24, arg3_24)

			local var1_24 = iter1_24:GetPopConfig()

			if var1_24 then
				arg0_24:DisptachSkillFloat(arg2_24, arg1_24, var1_24)
			end

			iter1_24:SetActive()
		end

		if arg0_24._isCancel then
			break
		end
	end

	if arg0_24._isCancel then
		arg0_24._isCancel = nil

		arg0_24:Remove()
	end
end

function var4_0.SetRemoveTime(arg0_25)
	local var0_25 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_25._buffStartTimeStamp = var0_25
	arg0_25._RemoveTime = var0_25 + arg0_25._time
	arg0_25._cancelTime = nil
end

function var4_0.IsTimeToRemove(arg0_26, arg1_26)
	if arg0_26._isCancel then
		return true
	elseif arg0_26._cancelTime and arg1_26 >= arg0_26._cancelTime then
		return true
	elseif arg0_26._time == 0 then
		return false
	else
		return arg1_26 >= arg0_26._RemoveTime
	end
end

function var4_0.GetBuffLifeTime(arg0_27)
	return arg0_27._time
end

function var4_0.GetBuffStartTime(arg0_28)
	return arg0_28._buffStartTimeStamp
end

function var4_0.Interrupt(arg0_29)
	for iter0_29, iter1_29 in ipairs(arg0_29._effectList) do
		iter1_29:Interrupt()
	end
end

function var4_0.Clear(arg0_30)
	for iter0_30, iter1_30 in ipairs(arg0_30._effectList) do
		iter1_30:Clear()
	end
end

function var4_0.GetID(arg0_31)
	return arg0_31._id
end

function var4_0.GetCaster(arg0_32)
	return arg0_32._caster
end

function var4_0.GetLv(arg0_33)
	return arg0_33._level or 1
end

function var4_0.GetDuration(arg0_34)
	return arg0_34._time
end

function var4_0.GetStack(arg0_35)
	return arg0_35._stack or 1
end

function var4_0.IsForceStack(arg0_36)
	return arg0_36._forceStack
end

function var4_0.SetToCancel(arg0_37, arg1_37)
	if arg1_37 then
		if not arg0_37._cancelTime then
			arg0_37._cancelTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1_37
		end
	else
		arg0_37._isCancel = true
	end
end

function var4_0.Dispose(arg0_38)
	arg0_38._triggerSearchTable = nil
	arg0_38._commander = nil
end
