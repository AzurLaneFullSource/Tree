local var0_0 = class("ResourceFieldLevelProductAttr", import(".ResourceFieldProductAttr"))

function var0_0.ReCalcValue(arg0_1)
	arg0_1.multiple = arg0_1.config[arg0_1.level].hour_time

	var0_0.super.ReCalcValue(arg0_1)
end

return var0_0
