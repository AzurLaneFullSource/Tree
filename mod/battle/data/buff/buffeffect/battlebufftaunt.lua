ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleAttr
local var2 = class("BattleBuffTaunt", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffTaunt = var2
var2.__name = "BattleBuffTaunt"

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)

	arg0._tauntActive = false
end

function var2.SetArgs(arg0, arg1, arg2)
	arg0._guardTargetFilter = arg0._tempData.arg_list.guardTarget
	arg0._handleCloak = arg1:GetCloak() ~= nil
end

function var2.onTrigger(arg0, arg1, arg2, arg3)
	if not arg0._handleCloak then
		return
	end

	local var0 = arg0:getTargetList(arg1, arg0._guardTargetFilter, arg0._tempData.arg_list)
	local var1 = true

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 and var1.IsCloak(iter1)
	end

	if not var1 and not arg0._tauntActive then
		arg0:forceToExpose(arg1)
	elseif var1 and arg0._tauntActive then
		arg0:releaseExpose(arg1)
	end
end

function var2.onRemove(arg0, arg1, arg2, arg3)
	arg0:releaseExpose(arg1)
end

function var2.forceToExpose(arg0, arg1)
	if not arg0._handleCloak then
		return
	end

	arg0._tauntActive = true

	local var0 = arg1:GetCloak()

	var0:ForceToMax()
	var0:UpdateTauntExpose(true)
end

function var2.releaseExpose(arg0, arg1)
	if not arg0._handleCloak then
		return
	end

	arg0._tauntActive = false

	arg1:GetCloak():UpdateTauntExpose(false)
end
