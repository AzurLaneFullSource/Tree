ys = ys or {}

local var0 = ys

var0.Battle.BattleFleetBuffEffect = class("BattleFleetBuffEffect")
var0.Battle.BattleFleetBuffEffect.__name = "BattleFleetBuffEffect"

local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleFleetBuffEffect

function var2.Ctor(arg0, arg1)
	arg0._tempData = Clone(arg1)
	arg0._type = arg0._tempData.type

	arg0:SetActive()
end

function var2.SetArgs(arg0, arg1, arg2)
	arg0._fleetVO = arg1
	arg0._fleetBuff = arg2
end

function var2.Trigger(arg0, arg1, arg2, arg3, arg4)
	arg0[arg1](arg0, arg2, arg3, arg4)
end

function var2.onAttach(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var2.onRemove(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var2.onUpdate(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var2.onStack(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var2.getTargetList(arg0, arg1, arg2, arg3)
	local var0
	local var1 = arg1:GetUnitList()[1]

	for iter0, iter1 in ipairs(arg2) do
		var0 = var0.Battle.BattleTargetChoise[iter1](var1, arg3, var0)
	end

	return var0
end

function var2.IsActive(arg0)
	return arg0._isActive
end

function var2.SetActive(arg0)
	arg0._isActive = true
end

function var2.NotActive(arg0)
	arg0._isActive = false
end

function var2.Clear(arg0)
	return
end

function var2.Dispose(arg0)
	return
end
