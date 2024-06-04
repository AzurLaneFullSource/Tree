local var0 = class("ResourceFieldProductAttr", import(".ResourceFieldAttr"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.super.Ctor(arg0, arg1, arg2, arg3)

	arg0.multiple = arg4
end

function var0.ReCalcValue(arg0)
	arg0.value = arg0.config[arg0.level][arg0.attrName] * arg0.multiple
	arg0.nextValue = arg0.config[arg0.nextLevel][arg0.attrName] * arg0.multiple
	arg0.maxValue = arg0.config[#arg0.config][arg0.attrName] * arg0.multiple
	arg0.addition = arg0.nextValue - arg0.value
end

function var0.GetAdditionDesc(arg0)
	return arg0.addition .. "/h"
end

function var0.GetProgressDesc(arg0)
	return arg0.value .. "/h" .. "/" .. arg0.maxValue .. "/h"
end

return var0
