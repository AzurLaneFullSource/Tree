ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleFleetBuffEffect = class("BattleFleetBuffEffect")
var0_0.Battle.BattleFleetBuffEffect.__name = "BattleFleetBuffEffect"

local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleFleetBuffEffect

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._tempData = Clone(arg1_1)
	arg0_1._type = arg0_1._tempData.type

	arg0_1:SetActive()
end

function var2_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._fleetVO = arg1_2
	arg0_2._fleetBuff = arg2_2
end

function var2_0.Trigger(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3[arg1_3](arg0_3, arg2_3, arg3_3, arg4_3)
end

function var2_0.onAttach(arg0_4, arg1_4, arg2_4)
	arg0_4:onTrigger(arg1_4, arg2_4)
end

function var2_0.onRemove(arg0_5, arg1_5, arg2_5)
	arg0_5:onTrigger(arg1_5, arg2_5)
end

function var2_0.onUpdate(arg0_6, arg1_6, arg2_6)
	arg0_6:onTrigger(arg1_6, arg2_6)
end

function var2_0.onStack(arg0_7, arg1_7, arg2_7)
	arg0_7:onTrigger(arg1_7, arg2_7)
end

function var2_0.getTargetList(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8
	local var1_8 = arg1_8:GetUnitList()[1]

	for iter0_8, iter1_8 in ipairs(arg2_8) do
		var0_8 = var0_0.Battle.BattleTargetChoise[iter1_8](var1_8, arg3_8, var0_8)
	end

	return var0_8
end

function var2_0.IsActive(arg0_9)
	return arg0_9._isActive
end

function var2_0.SetActive(arg0_10)
	arg0_10._isActive = true
end

function var2_0.NotActive(arg0_11)
	arg0_11._isActive = false
end

function var2_0.Clear(arg0_12)
	return
end

function var2_0.Dispose(arg0_13)
	return
end
