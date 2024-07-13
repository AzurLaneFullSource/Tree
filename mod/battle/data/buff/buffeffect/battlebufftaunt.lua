ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleAttr
local var2_0 = class("BattleBuffTaunt", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffTaunt = var2_0
var2_0.__name = "BattleBuffTaunt"

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._tauntActive = false
end

function var2_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._guardTargetFilter = arg0_2._tempData.arg_list.guardTarget
	arg0_2._handleCloak = arg1_2:GetCloak() ~= nil
end

function var2_0.onTrigger(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3._handleCloak then
		return
	end

	local var0_3 = arg0_3:getTargetList(arg1_3, arg0_3._guardTargetFilter, arg0_3._tempData.arg_list)
	local var1_3 = true

	for iter0_3, iter1_3 in ipairs(var0_3) do
		var1_3 = var1_3 and var1_0.IsCloak(iter1_3)
	end

	if not var1_3 and not arg0_3._tauntActive then
		arg0_3:forceToExpose(arg1_3)
	elseif var1_3 and arg0_3._tauntActive then
		arg0_3:releaseExpose(arg1_3)
	end
end

function var2_0.onRemove(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4:releaseExpose(arg1_4)
end

function var2_0.forceToExpose(arg0_5, arg1_5)
	if not arg0_5._handleCloak then
		return
	end

	arg0_5._tauntActive = true

	local var0_5 = arg1_5:GetCloak()

	var0_5:ForceToMax()
	var0_5:UpdateTauntExpose(true)
end

function var2_0.releaseExpose(arg0_6, arg1_6)
	if not arg0_6._handleCloak then
		return
	end

	arg0_6._tauntActive = false

	arg1_6:GetCloak():UpdateTauntExpose(false)
end
