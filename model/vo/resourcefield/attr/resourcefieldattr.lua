local var0 = class("ResourceFieldAttr")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.name = arg2
	arg0.config = arg1
	arg0.attrName = arg3
	arg0.level = 0
	arg0.nextLevel = 0
	arg0.value = 0
	arg0.nextValue = 0
	arg0.maxValue = 0
	arg0.addition = 0
end

function var0.Update(arg0, arg1)
	if arg1 == arg0.level then
		return
	end

	arg0.level = arg1
	arg0.nextLevel = math.min(arg1 + 1, #arg0.config)

	arg0:ReCalcValue()
end

function var0.ReCalcValue(arg0)
	arg0.value = arg0.config[arg0.level][arg0.attrName]
	arg0.nextValue = arg0.config[arg0.nextLevel][arg0.attrName]
	arg0.maxValue = arg0.config[#arg0.config][arg0.attrName]
	arg0.addition = arg0.nextValue - arg0.value
end

function var0.GetName(arg0)
	return arg0.name
end

function var0.IsMaxLevel(arg0)
	return arg0.level == arg0.nextLevel
end

function var0.GetValue(arg0)
	return arg0.value
end

function var0.GetNextValue(arg0)
	return arg0.nextValue
end

function var0.GetMaxValue(arg0)
	return arg0.maxValue
end

function var0.GetAddition(arg0)
	return arg0.addition
end

function var0.GetAdditionDesc(arg0)
	return arg0.addition
end

function var0.GetProgressDesc(arg0)
	return arg0.value .. "/" .. arg0.maxValue
end

return var0
