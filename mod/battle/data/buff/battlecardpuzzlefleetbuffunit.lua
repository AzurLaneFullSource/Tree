ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBuffEvent
local var2 = var0.Battle.BattleConst.BuffEffectType
local var3 = var0.Battle.BattleCardPuzzleFormulas
local var4 = class("BattleCardPuzzleFleetBuffUnit")

var0.Battle.BattleCardPuzzleFleetBuffUnit = var4
var4.__name = "BattleCardPuzzleFleetBuffUnit"

function var4.Ctor(arg0, arg1, arg2)
	arg2 = arg2 or 1
	arg0._id = arg1
	arg0._tempData = var0.Battle.BattleDataFunction.GetBuffTemplate(arg1, arg2)
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

function var4.IsResponTo(arg0, arg1)
	local var0 = arg0._triggerSearchTable[arg1]

	if var0 ~= nil and #var0 > 0 then
		return true
	end

	return false
end

function var4.SetArgs(arg0, arg1)
	arg0._host = arg1

	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:SetArgs(arg1, arg0)
	end
end

function var4.setRemoveTime(arg0)
	if arg0._tempData.time == nil then
		return
	end

	local var0 = arg0._tempData.time

	if type(var0) == "string" then
		arg0._duration = math.max(0, var3.parseFormula(var0, arg0._host:GetAttrManager()))
	else
		arg0._duration = var0
	end

	arg0._expireTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._duration
end

function var4.Attach(arg0, arg1)
	arg0._stack = 1

	arg0:SetArgs(arg1)
	arg0:onTrigger(var2.ON_ATTACH)
	arg0:setRemoveTime()
end

function var4.Stack(arg0)
	if arg0._tempData.stack == 0 then
		arg0._stack = arg0._stack + 1
	else
		arg0._stack = math.min(arg0._stack + 1, arg0._tempData.stack)
	end

	arg0:onTrigger(var2.ON_STACK)
	arg0:setRemoveTime()
end

function var4.InitStack(arg0)
	return
end

function var4.UpdateStack(arg0, arg1)
	return
end

function var4.Remove(arg0)
	arg0:onTrigger(var2.ON_REMOVE)

	arg0._host:GetBuffManager():GetCardPuzzleBuffList()[arg0._id] = nil

	arg0:Clear()
end

function var4.Update(arg0, arg1)
	if arg0:IsExpire(arg1) then
		arg0:Remove()
	else
		arg0:onTrigger(var2.ON_UPDATE, arg1)
	end
end

function var4.onTrigger(arg0, arg1, arg2)
	local var0 = arg0._triggerSearchTable[arg1]

	if var0 == nil or #var0 == 0 then
		return
	end

	for iter0, iter1 in ipairs(var0) do
		assert(type(iter1[arg1]) == "function", "fleet buff效果的触发函数缺失,buff id:>>" .. arg0._id .. "<<, trigger:>>" .. arg1 .. "<<")

		if iter1:IsActive() then
			iter1:NotActive()
			iter1:Trigger(arg1, arg2)
			iter1:SetActive()
		end
	end
end

function var4.IsExpire(arg0, arg1)
	if arg0._expireTimeStamp == nil then
		return false
	else
		return arg1 >= arg0._expireTimeStamp
	end
end

function var4.IsActive(arg0)
	return arg0._isActive
end

function var4.SetActive(arg0)
	arg0._isActive = true
end

function var4.NotActive(arg0)
	arg0._isActive = false
end

function var4.GetCaster(arg0)
	return nil
end

function var4.GetID(arg0)
	return arg0._id
end

function var4.GetStack(arg0)
	return arg0._stack
end

function var4.GetLv(arg0)
	return 1
end

function var4.GetDurationRate(arg0)
	if arg0._expireTimeStamp == nil then
		return 1
	else
		local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

		return (arg0._expireTimeStamp - var0) / arg0._duration
	end
end

function var4.Clear(arg0)
	arg0._host = nil

	for iter0, iter1 in ipairs(arg0._effectList) do
		iter1:Clear()
	end
end
