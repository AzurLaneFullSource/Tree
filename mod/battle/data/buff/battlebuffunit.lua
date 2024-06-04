ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBuffEvent
local var2 = var0.Battle.BattleConst.BuffEffectType
local var3 = class("BattleBuffUnit")

var0.Battle.BattleBuffUnit = var3
var3.__name = "BattleBuffUnit"
var3.DEFAULT_ANI_FX_CONFIG = {
	effect = "jineng",
	offset = {
		0,
		-2,
		0
	}
}

function var3.Ctor(arg0, arg1, arg2, arg3)
	arg2 = arg2 or 1
	arg0._id = arg1

	arg0:SetTemplate(arg1, arg2)

	arg0._time = arg0._tempData.time
	arg0._RemoveTime = 0
	arg0._effectList = {}
	arg0._triggerSearchTable = {}
	arg0._level = arg2
	arg0._caster = arg3

	for iter0, iter1 in ipairs(arg0._tempData.effect_list) do
		local var0 = var0.Battle[iter1.type].New(iter1)

		arg0._effectList[iter0] = var0

		local var1 = iter1.trigger

		for iter2, iter3 in ipairs(var1) do
			local var2 = arg0._triggerSearchTable[iter3]

			if var2 == nil then
				var2 = {}
				arg0._triggerSearchTable[iter3] = var2
			end

			var2[#var2 + 1] = var0
		end
	end
end

function var3.SetTemplate(arg0, arg1, arg2)
	arg0._tempData = var0.Battle.BattleDataFunction.GetBuffTemplate(arg1, arg2)
end

function var3.Attach(arg0, arg1)
	arg0._owner = arg1
	arg0._stack = 1

	arg0:SetArgs(arg1)
	arg0:onTrigger(var2.ON_ATTACH, arg1)
	arg0:SetRemoveTime()
end

function var3.Stack(arg0, arg1)
	arg0._stack = math.min(arg0._stack + 1, arg0._tempData.stack)

	arg0:onTrigger(var2.ON_STACK, arg1)
	arg0:SetRemoveTime()
end

function var3.SetOrb(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:SetOrb(arg0, arg1, arg2)
	end
end

function var3.SetOrbDuration(arg0, arg1)
	arg0._time = arg1 + arg0._time
end

function var3.SetOrbLevel(arg0, arg1)
	arg0._level = arg1
end

function var3.SetCommander(arg0, arg1)
	arg0._commander = arg1

	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:SetCommander(arg1)
	end
end

function var3.GetEffectList(arg0)
	return arg0._effectList
end

function var3.GetCommander(arg0)
	return arg0._commander
end

function var3.UpdateStack(arg0, arg1, arg2)
	if arg0._stack == arg2 then
		return
	end

	arg0._stack = math.min(arg2, arg0._tempData.stack)

	arg0:onTrigger(var2.ON_STACK, arg1)
	arg0:SetRemoveTime()

	local var0 = {
		unit_id = arg1:GetUniqueID(),
		buff_id = arg0._id,
		stack_count = arg0._stack
	}

	arg1:DispatchEvent(var0.Event.New(var1.BUFF_STACK, var0))
end

function var3.Remove(arg0, arg1)
	local var0 = arg0._owner
	local var1 = arg0._id
	local var2 = {
		unit_id = var0:GetUniqueID(),
		buff_id = var1
	}

	var0:DispatchEvent(var0.Event.New(var1.BUFF_REMOVE, var2))
	arg0:onTrigger(var2.ON_REMOVE, var0)
	arg0:Clear()

	var0:GetBuffList()[var1] = nil
end

function var3.Update(arg0, arg1, arg2)
	if arg0:IsTimeToRemove(arg2) then
		arg0:Remove(arg2)
	else
		arg0:onTrigger(var2.ON_UPDATE, arg1, {
			timeStamp = arg2
		})
	end
end

function var3.SetArgs(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:SetCaster(arg0._caster)
		iter1:SetArgs(arg1, arg0)
	end
end

function var3.Trigger(arg0, arg1, arg2)
	local var0 = arg0:GetBuffList() or {}
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		local var2 = iter1._triggerSearchTable[arg1]

		if var2 ~= nil and #var2 > 0 then
			var1[#var1 + 1] = iter1
		end
	end

	for iter2, iter3 in ipairs(var1) do
		iter3:onTrigger(arg1, arg0, arg2)
	end
end

function var3.DisptachSkillFloat(arg0, arg1, arg2, arg3)
	if arg3.trigger == nil or table.contains(arg3.trigger, arg2) then
		local var0

		if arg3.painting and type(arg3.painting) == "string" then
			var0 = arg3
		end

		local var1 = getSkillName(arg3.displayID or arg0._id)

		arg1:DispatchSkillFloat(var1, nil, var0)

		local var2

		if arg3.castCV ~= false then
			var2 = arg3.castCV or "skill"
		end

		local var3 = type(var2)

		if var3 == "string" then
			arg1:DispatchVoice(var2)
		elseif var3 == "table" then
			local var4, var5, var6 = ShipWordHelper.GetWordAndCV(var2.skinID, var2.key)

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5)
		end

		local var7 = arg3.aniEffect or var3.DEFAULT_ANI_FX_CONFIG
		local var8 = {
			effect = var7.effect,
			offset = var7.offset
		}

		arg1:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.ADD_EFFECT, var8))
	end
end

function var3.IsSubmarineSpecial(arg0)
	local var0 = arg0._triggerSearchTable[var0.Battle.BattleConst.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL] or {}

	for iter0, iter1 in ipairs(var0) do
		if iter1:HaveQuota() then
			return true
		end
	end

	return false
end

function var3.onTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg0._triggerSearchTable[arg1]

	if var0 == nil or #var0 == 0 then
		return
	end

	for iter0, iter1 in ipairs(var0) do
		assert(type(iter1[arg1]) == "function", "buff效果的触发名字和触发函数不相符,buff id:>>" .. arg0._id .. "<<, trigger:>>" .. arg1 .. "<<")

		if iter1:HaveQuota() and iter1:IsActive() then
			iter1:NotActive()
			iter1:Trigger(arg1, arg2, arg0, arg3)

			local var1 = iter1:GetPopConfig()

			if var1 then
				arg0:DisptachSkillFloat(arg2, arg1, var1)
			end

			iter1:SetActive()
		end

		if arg0._isCancel then
			break
		end
	end

	if arg0._isCancel then
		arg0._isCancel = nil

		arg0:Remove()
	end
end

function var3.SetRemoveTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0._buffStartTimeStamp = var0
	arg0._RemoveTime = var0 + arg0._time
	arg0._cancelTime = nil
end

function var3.IsTimeToRemove(arg0, arg1)
	if arg0._isCancel then
		return true
	elseif arg0._cancelTime and arg1 >= arg0._cancelTime then
		return true
	elseif arg0._time == 0 then
		return false
	else
		return arg1 >= arg0._RemoveTime
	end
end

function var3.GetBuffLifeTime(arg0)
	return arg0._time
end

function var3.GetBuffStartTime(arg0)
	return arg0._buffStartTimeStamp
end

function var3.Interrupt(arg0)
	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:Interrupt()
	end
end

function var3.Clear(arg0)
	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:Clear()
	end
end

function var3.GetID(arg0)
	return arg0._id
end

function var3.GetCaster(arg0)
	return arg0._caster
end

function var3.GetLv(arg0)
	return arg0._level or 1
end

function var3.GetDuration(arg0)
	return arg0._time
end

function var3.GetStack(arg0)
	return arg0._stack or 1
end

function var3.SetToCancel(arg0, arg1)
	if arg1 then
		if not arg0._cancelTime then
			arg0._cancelTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1
		end
	else
		arg0._isCancel = true
	end
end

function var3.Dispose(arg0)
	arg0._triggerSearchTable = nil
	arg0._commander = nil
end
