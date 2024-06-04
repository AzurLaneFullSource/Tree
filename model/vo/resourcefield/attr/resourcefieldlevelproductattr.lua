local var0 = class("ResourceFieldLevelProductAttr", import(".ResourceFieldProductAttr"))

function var0.ReCalcValue(arg0)
	arg0.multiple = arg0.config[arg0.level].hour_time

	var0.super.ReCalcValue(arg0)
end

return var0
