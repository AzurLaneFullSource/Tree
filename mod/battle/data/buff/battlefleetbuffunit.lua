ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBuffEvent
local var2_0 = var0_0.Battle.BattleConst.BuffEffectType
local var3_0 = class("BattleFleetBuffUnit")

var0_0.Battle.BattleFleetBuffUnit = var3_0
var3_0.__name = "BattleFleetBuffUnit"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg2_1 = arg2_1 or 1
	arg0_1._id = arg1_1
	arg0_1._tempData = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_1, arg2_1)
	arg0_1._time = arg0_1._tempData.time
	arg0_1._RemoveTime = 0
	arg0_1._effectList = {}
	arg0_1._triggerSearchTable = {}
	arg0_1._level = arg2_1

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

	arg0_1:SetActive()
end

function var3_0.SetArgs(arg0_2, arg1_2)
	arg0_2._host = arg1_2

	for iter0_2, iter1_2 in ipairs(arg0_2._effectList) do
		iter1_2:SetArgs(arg1_2, arg0_2)
	end
end

function var3_0.setRemoveTime(arg0_3)
	arg0_3._RemoveTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_3._time
	arg0_3._cancelTime = nil
end

function var3_0.Attach(arg0_4, arg1_4)
	arg0_4._stack = 1

	arg0_4:SetArgs(arg1_4)
	arg0_4:onTrigger(var2_0.ON_ATTACH, arg1_4)
	arg0_4:setRemoveTime()
end

function var3_0.Stack(arg0_5, arg1_5)
	arg0_5._stack = math.min(arg0_5._stack + 1, arg0_5._tempData.stack)

	arg0_5:onTrigger(var2_0.ON_STACK, arg1_5)
	arg0_5:setRemoveTime()
end

function var3_0.UpdateStack(arg0_6, arg1_6, arg2_6)
	return
end

function var3_0.Remove(arg0_7)
	arg0_7:onTrigger(var2_0.ON_REMOVE, arg0_7._host)

	arg0_7._host:GetFleetBuffList()[arg0_7._id] = nil

	arg0_7:Clear()
end

function var3_0.Update(arg0_8, arg1_8, arg2_8)
	if arg0_8:IsTimeToRemove(arg2_8) then
		arg0_8:Remove()
	else
		arg0_8:onTrigger(var2_0.ON_UPDATE, arg1_8, arg2_8)
	end
end

function var3_0.onTrigger(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg0_9._triggerSearchTable[arg1_9]

	if var0_9 == nil or #var0_9 == 0 then
		return
	end

	for iter0_9, iter1_9 in ipairs(var0_9) do
		assert(type(iter1_9[arg1_9]) == "function", "fleet buff效果的触发函数缺失,buff id:>>" .. arg0_9._id .. "<<, trigger:>>" .. arg1_9 .. "<<")

		if iter1_9:IsActive() then
			iter1_9:NotActive()
			iter1_9:Trigger(arg1_9, arg2_9, arg0_9, arg3_9)
			iter1_9:SetActive()
		end
	end
end

function var3_0.IsTimeToRemove(arg0_10, arg1_10)
	if arg0_10._time == 0 then
		return false
	else
		return arg1_10 >= arg0_10._RemoveTime
	end
end

function var3_0.IsActive(arg0_11)
	return arg0_11._isActive
end

function var3_0.SetActive(arg0_12)
	arg0_12._isActive = true
end

function var3_0.NotActive(arg0_13)
	arg0_13._isActive = false
end

function var3_0.GetCaster(arg0_14)
	return nil
end

function var3_0.GetID(arg0_15)
	return arg0_15._id
end

function var3_0.GetLv(arg0_16)
	return 1
end

function var3_0.Clear(arg0_17)
	arg0_17._host = nil

	for iter0_17, iter1_17 in ipairs(arg0_17._effectList) do
		iter1_17:Clear()
	end
end
