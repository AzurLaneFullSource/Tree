local var0_0 = class("ResourceFieldProductAttr", import(".ResourceFieldAttr"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.multiple = arg4_1
end

function var0_0.ReCalcValue(arg0_2)
	arg0_2.value = arg0_2.config[arg0_2.level][arg0_2.attrName] * arg0_2.multiple
	arg0_2.nextValue = arg0_2.config[arg0_2.nextLevel][arg0_2.attrName] * arg0_2.multiple
	arg0_2.maxValue = arg0_2.config[#arg0_2.config][arg0_2.attrName] * arg0_2.multiple
	arg0_2.addition = arg0_2.nextValue - arg0_2.value
end

function var0_0.GetAdditionDesc(arg0_3)
	return arg0_3.addition .. "/h"
end

function var0_0.GetProgressDesc(arg0_4)
	return arg0_4.value .. "/h" .. "/" .. arg0_4.maxValue .. "/h"
end

return var0_0
