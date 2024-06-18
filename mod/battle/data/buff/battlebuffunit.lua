ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBuffEvent
local var2_0 = var0_0.Battle.BattleConst.BuffEffectType
local var3_0 = class("BattleBuffUnit")

var0_0.Battle.BattleBuffUnit = var3_0
var3_0.__name = "BattleBuffUnit"
var3_0.DEFAULT_ANI_FX_CONFIG = {
	effect = "jineng",
	offset = {
		0,
		-2,
		0
	}
}

function var3_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg2_1 = arg2_1 or 1
	arg0_1._id = arg1_1

	arg0_1:SetTemplate(arg1_1, arg2_1)

	arg0_1._time = arg0_1._tempData.time
	arg0_1._RemoveTime = 0
	arg0_1._effectList = {}
	arg0_1._triggerSearchTable = {}
	arg0_1._level = arg2_1
	arg0_1._caster = arg3_1

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

function var3_0.SetTemplate(arg0_2, arg1_2, arg2_2)
	arg0_2._tempData = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_2, arg2_2)
end

function var3_0.Attach(arg0_3, arg1_3)
	arg0_3._owner = arg1_3
	arg0_3._stack = 1

	arg0_3:SetArgs(arg1_3)
	arg0_3:onTrigger(var2_0.ON_ATTACH, arg1_3)
	arg0_3:SetRemoveTime()
end

function var3_0.Stack(arg0_4, arg1_4)
	arg0_4._stack = math.min(arg0_4._stack + 1, arg0_4._tempData.stack)

	arg0_4:onTrigger(var2_0.ON_STACK, arg1_4)
	arg0_4:SetRemoveTime()
end

function var3_0.SetOrb(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in ipairs(arg0_5._effectList) do
		iter1_5:SetOrb(arg0_5, arg1_5, arg2_5)
	end
end

function var3_0.SetOrbDuration(arg0_6, arg1_6)
	arg0_6._time = arg1_6 + arg0_6._time
end

function var3_0.SetOrbLevel(arg0_7, arg1_7)
	arg0_7._level = arg1_7
end

function var3_0.SetCommander(arg0_8, arg1_8)
	arg0_8._commander = arg1_8

	for iter0_8, iter1_8 in ipairs(arg0_8._effectList) do
		iter1_8:SetCommander(arg1_8)
	end
end

function var3_0.GetEffectList(arg0_9)
	return arg0_9._effectList
end

function var3_0.GetCommander(arg0_10)
	return arg0_10._commander
end

function var3_0.UpdateStack(arg0_11, arg1_11, arg2_11)
	if arg0_11._stack == arg2_11 then
		return
	end

	arg0_11._stack = math.min(arg2_11, arg0_11._tempData.stack)

	arg0_11:onTrigger(var2_0.ON_STACK, arg1_11)
	arg0_11:SetRemoveTime()

	local var0_11 = {
		unit_id = arg1_11:GetUniqueID(),
		buff_id = arg0_11._id,
		stack_count = arg0_11._stack
	}

	arg1_11:DispatchEvent(var0_0.Event.New(var1_0.BUFF_STACK, var0_11))
end

function var3_0.Remove(arg0_12, arg1_12)
	local var0_12 = arg0_12._owner
	local var1_12 = arg0_12._id
	local var2_12 = {
		unit_id = var0_12:GetUniqueID(),
		buff_id = var1_12
	}

	var0_12:DispatchEvent(var0_0.Event.New(var1_0.BUFF_REMOVE, var2_12))
	arg0_12:onTrigger(var2_0.ON_REMOVE, var0_12)
	arg0_12:Clear()

	var0_12:GetBuffList()[var1_12] = nil
end

function var3_0.Update(arg0_13, arg1_13, arg2_13)
	if arg0_13:IsTimeToRemove(arg2_13) then
		arg0_13:Remove(arg2_13)
	else
		arg0_13:onTrigger(var2_0.ON_UPDATE, arg1_13, {
			timeStamp = arg2_13
		})
	end
end

function var3_0.SetArgs(arg0_14, arg1_14)
	for iter0_14, iter1_14 in ipairs(arg0_14._effectList) do
		iter1_14:SetCaster(arg0_14._caster)
		iter1_14:SetArgs(arg1_14, arg0_14)
	end
end

function var3_0.Trigger(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15:GetBuffList() or {}
	local var1_15 = {}

	for iter0_15, iter1_15 in pairs(var0_15) do
		local var2_15 = iter1_15._triggerSearchTable[arg1_15]

		if var2_15 ~= nil and #var2_15 > 0 then
			var1_15[#var1_15 + 1] = iter1_15
		end
	end

	for iter2_15, iter3_15 in ipairs(var1_15) do
		iter3_15:onTrigger(arg1_15, arg0_15, arg2_15)
	end
end

function var3_0.DisptachSkillFloat(arg0_16, arg1_16, arg2_16, arg3_16)
	if arg3_16.trigger == nil or table.contains(arg3_16.trigger, arg2_16) then
		local var0_16

		if arg3_16.painting and type(arg3_16.painting) == "string" then
			var0_16 = arg3_16
		end

		local var1_16 = getSkillName(arg3_16.displayID or arg0_16._id)

		arg1_16:DispatchSkillFloat(var1_16, nil, var0_16)

		local var2_16

		if arg3_16.castCV ~= false then
			var2_16 = arg3_16.castCV or "skill"
		end

		local var3_16 = type(var2_16)

		if var3_16 == "string" then
			arg1_16:DispatchVoice(var2_16)
		elseif var3_16 == "table" then
			local var4_16, var5_16, var6_16 = ShipWordHelper.GetWordAndCV(var2_16.skinID, var2_16.key)

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_16)
		end

		local var7_16 = arg3_16.aniEffect or var3_0.DEFAULT_ANI_FX_CONFIG
		local var8_16 = {
			effect = var7_16.effect,
			offset = var7_16.offset
		}

		arg1_16:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ADD_EFFECT, var8_16))
	end
end

function var3_0.IsSubmarineSpecial(arg0_17)
	local var0_17 = arg0_17._triggerSearchTable[var0_0.Battle.BattleConst.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL] or {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if iter1_17:HaveQuota() then
			return true
		end
	end

	return false
end

function var3_0.onTrigger(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18._triggerSearchTable[arg1_18]

	if var0_18 == nil or #var0_18 == 0 then
		return
	end

	for iter0_18, iter1_18 in ipairs(var0_18) do
		assert(type(iter1_18[arg1_18]) == "function", "buff效果的触发名字和触发函数不相符,buff id:>>" .. arg0_18._id .. "<<, trigger:>>" .. arg1_18 .. "<<")

		if iter1_18:HaveQuota() and iter1_18:IsActive() then
			iter1_18:NotActive()
			iter1_18:Trigger(arg1_18, arg2_18, arg0_18, arg3_18)

			local var1_18 = iter1_18:GetPopConfig()

			if var1_18 then
				arg0_18:DisptachSkillFloat(arg2_18, arg1_18, var1_18)
			end

			iter1_18:SetActive()
		end

		if arg0_18._isCancel then
			break
		end
	end

	if arg0_18._isCancel then
		arg0_18._isCancel = nil

		arg0_18:Remove()
	end
end

function var3_0.SetRemoveTime(arg0_19)
	local var0_19 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_19._buffStartTimeStamp = var0_19
	arg0_19._RemoveTime = var0_19 + arg0_19._time
	arg0_19._cancelTime = nil
end

function var3_0.IsTimeToRemove(arg0_20, arg1_20)
	if arg0_20._isCancel then
		return true
	elseif arg0_20._cancelTime and arg1_20 >= arg0_20._cancelTime then
		return true
	elseif arg0_20._time == 0 then
		return false
	else
		return arg1_20 >= arg0_20._RemoveTime
	end
end

function var3_0.GetBuffLifeTime(arg0_21)
	return arg0_21._time
end

function var3_0.GetBuffStartTime(arg0_22)
	return arg0_22._buffStartTimeStamp
end

function var3_0.Interrupt(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23._effectList) do
		iter1_23:Interrupt()
	end
end

function var3_0.Clear(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24._effectList) do
		iter1_24:Clear()
	end
end

function var3_0.GetID(arg0_25)
	return arg0_25._id
end

function var3_0.GetCaster(arg0_26)
	return arg0_26._caster
end

function var3_0.GetLv(arg0_27)
	return arg0_27._level or 1
end

function var3_0.GetDuration(arg0_28)
	return arg0_28._time
end

function var3_0.GetStack(arg0_29)
	return arg0_29._stack or 1
end

function var3_0.SetToCancel(arg0_30, arg1_30)
	if arg1_30 then
		if not arg0_30._cancelTime then
			arg0_30._cancelTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1_30
		end
	else
		arg0_30._isCancel = true
	end
end

function var3_0.Dispose(arg0_31)
	arg0_31._triggerSearchTable = nil
	arg0_31._commander = nil
end
