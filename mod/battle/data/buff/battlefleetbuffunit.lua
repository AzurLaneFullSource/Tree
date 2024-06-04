ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBuffEvent
local var2 = var0.Battle.BattleConst.BuffEffectType
local var3 = class("BattleFleetBuffUnit")

var0.Battle.BattleFleetBuffUnit = var3
var3.__name = "BattleFleetBuffUnit"

function var3.Ctor(arg0, arg1, arg2)
	arg2 = arg2 or 1
	arg0._id = arg1
	arg0._tempData = var0.Battle.BattleDataFunction.GetBuffTemplate(arg1, arg2)
	arg0._time = arg0._tempData.time
	arg0._RemoveTime = 0
	arg0._effectList = {}
	arg0._triggerSearchTable = {}
	arg0._level = arg2

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

	arg0:SetActive()
end

function var3.SetArgs(arg0, arg1)
	arg0._host = arg1

	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:SetArgs(arg1, arg0)
	end
end

function var3.setRemoveTime(arg0)
	arg0._RemoveTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._time
	arg0._cancelTime = nil
end

function var3.Attach(arg0, arg1)
	arg0._stack = 1

	arg0:SetArgs(arg1)
	arg0:onTrigger(var2.ON_ATTACH, arg1)
	arg0:setRemoveTime()
end

function var3.Stack(arg0, arg1)
	arg0._stack = math.min(arg0._stack + 1, arg0._tempData.stack)

	arg0:onTrigger(var2.ON_STACK, arg1)
	arg0:setRemoveTime()
end

function var3.UpdateStack(arg0, arg1, arg2)
	return
end

function var3.Remove(arg0)
	arg0:onTrigger(var2.ON_REMOVE, arg0._host)

	arg0._host:GetFleetBuffList()[arg0._id] = nil

	arg0:Clear()
end

function var3.Update(arg0, arg1, arg2)
	if arg0:IsTimeToRemove(arg2) then
		arg0:Remove()
	else
		arg0:onTrigger(var2.ON_UPDATE, arg1, arg2)
	end
end

function var3.onTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg0._triggerSearchTable[arg1]

	if var0 == nil or #var0 == 0 then
		return
	end

	for iter0, iter1 in ipairs(var0) do
		assert(type(iter1[arg1]) == "function", "fleet buff效果的触发函数缺失,buff id:>>" .. arg0._id .. "<<, trigger:>>" .. arg1 .. "<<")

		if iter1:IsActive() then
			iter1:NotActive()
			iter1:Trigger(arg1, arg2, arg0, arg3)
			iter1:SetActive()
		end
	end
end

function var3.IsTimeToRemove(arg0, arg1)
	if arg0._time == 0 then
		return false
	else
		return arg1 >= arg0._RemoveTime
	end
end

function var3.IsActive(arg0)
	return arg0._isActive
end

function var3.SetActive(arg0)
	arg0._isActive = true
end

function var3.NotActive(arg0)
	arg0._isActive = false
end

function var3.GetCaster(arg0)
	return nil
end

function var3.GetID(arg0)
	return arg0._id
end

function var3.GetLv(arg0)
	return 1
end

function var3.Clear(arg0)
	arg0._host = nil

	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:Clear()
	end
end
