local var0_0 = class("ActivityExtraCommodity", import(".ActivityCommodity"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_shop_extra
end

function var0_0.ShowMaintenanceTime(arg0_2)
	return arg0_2:getConfig("end_by_maintenance") == 1
end

function var0_0.GetMaintenanceMonthAndDay(arg0_3)
	local var0_3 = arg0_3:getConfig("time")
	local var1_3 = var0_3[2][1][2]
	local var2_3 = var0_3[2][1][3]

	return var1_3, var2_3
end

return var0_0
