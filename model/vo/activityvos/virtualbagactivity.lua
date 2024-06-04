local var0 = class("VirtualBagActivity", import("model.vo.Activity"))

function var0.getVitemNumber(arg0, arg1)
	return arg0.data1KeyValueList[1][arg1] or 0
end

function var0.addVitemNumber(arg0, arg1, arg2)
	local var0 = arg0:getVitemNumber(arg1)

	arg0.data1KeyValueList[1][arg1] = var0 + arg2
end

function var0.subVitemNumber(arg0, arg1, arg2)
	local var0 = arg0:getVitemNumber(arg1)

	arg0.data1KeyValueList[1][arg1] = math.max(0, var0 - arg2)
end

function var0.GetAllVitems(arg0)
	return arg0.data1KeyValueList[1]
end

function var0.GetDropCfgByType(arg0)
	local var0 = arg0 and AcessWithinNull(pg.activity_drop_type[arg0], "activity_id")
	local var1 = var0 and AcessWithinNull(pg.activity_template[var0], "type")
	local var2 = {
		[ActivityConst.ACTIVITY_TYPE_ATELIER_LINK] = AtelierMaterial,
		[ActivityConst.ACTIVITY_TYPE_WORKBENCH] = WorkBenchItem
	}
	local var3

	var3 = var1 and var2[var1]
end

return var0
