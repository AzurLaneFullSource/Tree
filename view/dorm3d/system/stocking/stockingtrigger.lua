local var0_0 = class("StockingTrigger")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1

	local var0_1 = pg.dorm3d_stocking_trigger[arg1_1]

	arg0_1.triggerPos = var0_1.trigger_pos
	arg0_1.compareType = var0_1.compare_type
	arg0_1.triggerType = var0_1.trigger_type
	arg0_1.shouldExit = var0_1.exit == 1
	arg0_1.triggerParam = var0_1.trigger_param
	arg0_1.isTriggered = false
end

function var0_0.Check(arg0_2, arg1_2, arg2_2, arg3_2)
	if arg0_2.isTriggered then
		return false
	end

	if arg0_2.compareType == 0 then
		if arg1_2 >= arg0_2.triggerPos and arg3_2 < arg0_2.triggerPos then
			return true
		end
	elseif arg1_2 <= arg0_2.triggerPos and arg2_2 > arg0_2.triggerPos then
		return true
	end

	return false
end

function var0_0.Trigger(arg0_3)
	arg0_3.isTriggered = true

	return arg0_3.triggerType, arg0_3.triggerParam, arg0_3.shouldExit
end

function var0_0.GetCompareType(arg0_4)
	return arg0_4.compareType
end

function var0_0.Sort(arg0_5)
	table.sort(arg0_5, function(arg0_6, arg1_6)
		if arg0_6.compareType == 0 then
			return arg0_6.triggerPos > arg1_6.triggerPos
		else
			return arg0_6.triggerPos < arg1_6.triggerPos
		end
	end)
end

return var0_0
