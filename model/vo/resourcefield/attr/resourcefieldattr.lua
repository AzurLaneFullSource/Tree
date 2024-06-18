local var0_0 = class("ResourceFieldAttr")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.name = arg2_1
	arg0_1.config = arg1_1
	arg0_1.attrName = arg3_1
	arg0_1.level = 0
	arg0_1.nextLevel = 0
	arg0_1.value = 0
	arg0_1.nextValue = 0
	arg0_1.maxValue = 0
	arg0_1.addition = 0
end

function var0_0.Update(arg0_2, arg1_2)
	if arg1_2 == arg0_2.level then
		return
	end

	arg0_2.level = arg1_2
	arg0_2.nextLevel = math.min(arg1_2 + 1, #arg0_2.config)

	arg0_2:ReCalcValue()
end

function var0_0.ReCalcValue(arg0_3)
	arg0_3.value = arg0_3.config[arg0_3.level][arg0_3.attrName]
	arg0_3.nextValue = arg0_3.config[arg0_3.nextLevel][arg0_3.attrName]
	arg0_3.maxValue = arg0_3.config[#arg0_3.config][arg0_3.attrName]
	arg0_3.addition = arg0_3.nextValue - arg0_3.value
end

function var0_0.GetName(arg0_4)
	return arg0_4.name
end

function var0_0.IsMaxLevel(arg0_5)
	return arg0_5.level == arg0_5.nextLevel
end

function var0_0.GetValue(arg0_6)
	return arg0_6.value
end

function var0_0.GetNextValue(arg0_7)
	return arg0_7.nextValue
end

function var0_0.GetMaxValue(arg0_8)
	return arg0_8.maxValue
end

function var0_0.GetAddition(arg0_9)
	return arg0_9.addition
end

function var0_0.GetAdditionDesc(arg0_10)
	return arg0_10.addition
end

function var0_0.GetProgressDesc(arg0_11)
	return arg0_11.value .. "/" .. arg0_11.maxValue
end

return var0_0
