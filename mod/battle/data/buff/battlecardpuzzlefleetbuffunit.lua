ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBuffEvent
local var2_0 = var0_0.Battle.BattleConst.BuffEffectType
local var3_0 = var0_0.Battle.BattleCardPuzzleFormulas
local var4_0 = class("BattleCardPuzzleFleetBuffUnit")

var0_0.Battle.BattleCardPuzzleFleetBuffUnit = var4_0
var4_0.__name = "BattleCardPuzzleFleetBuffUnit"

function var4_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg2_1 = arg2_1 or 1
	arg0_1._id = arg1_1
	arg0_1._tempData = var0_0.Battle.BattleDataFunction.GetBuffTemplate(arg1_1, arg2_1)
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

function var4_0.IsResponTo(arg0_2, arg1_2)
	local var0_2 = arg0_2._triggerSearchTable[arg1_2]

	if var0_2 ~= nil and #var0_2 > 0 then
		return true
	end

	return false
end

function var4_0.SetArgs(arg0_3, arg1_3)
	arg0_3._host = arg1_3

	for iter0_3, iter1_3 in ipairs(arg0_3._effectList) do
		iter1_3:SetArgs(arg1_3, arg0_3)
	end
end

function var4_0.setRemoveTime(arg0_4)
	if arg0_4._tempData.time == nil then
		return
	end

	local var0_4 = arg0_4._tempData.time

	if type(var0_4) == "string" then
		arg0_4._duration = math.max(0, var3_0.parseFormula(var0_4, arg0_4._host:GetAttrManager()))
	else
		arg0_4._duration = var0_4
	end

	arg0_4._expireTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_4._duration
end

function var4_0.Attach(arg0_5, arg1_5)
	arg0_5._stack = 1

	arg0_5:SetArgs(arg1_5)
	arg0_5:onTrigger(var2_0.ON_ATTACH)
	arg0_5:setRemoveTime()
end

function var4_0.Stack(arg0_6)
	if arg0_6._tempData.stack == 0 then
		arg0_6._stack = arg0_6._stack + 1
	else
		arg0_6._stack = math.min(arg0_6._stack + 1, arg0_6._tempData.stack)
	end

	arg0_6:onTrigger(var2_0.ON_STACK)
	arg0_6:setRemoveTime()
end

function var4_0.InitStack(arg0_7)
	return
end

function var4_0.UpdateStack(arg0_8, arg1_8)
	return
end

function var4_0.Remove(arg0_9)
	arg0_9:onTrigger(var2_0.ON_REMOVE)

	arg0_9._host:GetBuffManager():GetCardPuzzleBuffList()[arg0_9._id] = nil

	arg0_9:Clear()
end

function var4_0.Update(arg0_10, arg1_10)
	if arg0_10:IsExpire(arg1_10) then
		arg0_10:Remove()
	else
		arg0_10:onTrigger(var2_0.ON_UPDATE, arg1_10)
	end
end

function var4_0.onTrigger(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11._triggerSearchTable[arg1_11]

	if var0_11 == nil or #var0_11 == 0 then
		return
	end

	for iter0_11, iter1_11 in ipairs(var0_11) do
		assert(type(iter1_11[arg1_11]) == "function", "fleet buff效果的触发函数缺失,buff id:>>" .. arg0_11._id .. "<<, trigger:>>" .. arg1_11 .. "<<")

		if iter1_11:IsActive() then
			iter1_11:NotActive()
			iter1_11:Trigger(arg1_11, arg2_11)
			iter1_11:SetActive()
		end
	end
end

function var4_0.IsExpire(arg0_12, arg1_12)
	if arg0_12._expireTimeStamp == nil then
		return false
	else
		return arg1_12 >= arg0_12._expireTimeStamp
	end
end

function var4_0.IsActive(arg0_13)
	return arg0_13._isActive
end

function var4_0.SetActive(arg0_14)
	arg0_14._isActive = true
end

function var4_0.NotActive(arg0_15)
	arg0_15._isActive = false
end

function var4_0.GetCaster(arg0_16)
	return nil
end

function var4_0.GetID(arg0_17)
	return arg0_17._id
end

function var4_0.GetStack(arg0_18)
	return arg0_18._stack
end

function var4_0.GetLv(arg0_19)
	return 1
end

function var4_0.GetDurationRate(arg0_20)
	if arg0_20._expireTimeStamp == nil then
		return 1
	else
		local var0_20 = pg.TimeMgr.GetInstance():GetCombatTime()

		return (arg0_20._expireTimeStamp - var0_20) / arg0_20._duration
	end
end

function var4_0.Clear(arg0_21)
	arg0_21._host = nil

	for iter0_21, iter1_21 in ipairs(arg0_21._effectList) do
		iter1_21:Clear()
	end
end
