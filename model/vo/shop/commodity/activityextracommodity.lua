local var0 = class("ActivityExtraCommodity", import(".ActivityCommodity"))

function var0.bindConfigTable(arg0)
	return pg.activity_shop_extra
end

function var0.ShowMaintenanceTime(arg0)
	return arg0:getConfig("end_by_maintenance") == 1
end

function var0.GetMaintenanceMonthAndDay(arg0)
	local var0 = arg0:getConfig("time")
	local var1 = var0[2][1][2]
	local var2 = var0[2][1][3]

	return var1, var2
end

return var0
