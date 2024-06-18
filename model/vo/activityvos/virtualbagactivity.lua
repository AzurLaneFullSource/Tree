local var0_0 = class("VirtualBagActivity", import("model.vo.Activity"))

function var0_0.getVitemNumber(arg0_1, arg1_1)
	return arg0_1.data1KeyValueList[1][arg1_1] or 0
end

function var0_0.addVitemNumber(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:getVitemNumber(arg1_2)

	arg0_2.data1KeyValueList[1][arg1_2] = var0_2 + arg2_2
end

function var0_0.subVitemNumber(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:getVitemNumber(arg1_3)

	arg0_3.data1KeyValueList[1][arg1_3] = math.max(0, var0_3 - arg2_3)
end

function var0_0.GetAllVitems(arg0_4)
	return arg0_4.data1KeyValueList[1]
end

function var0_0.GetDropCfgByType(arg0_5)
	local var0_5 = arg0_5 and AcessWithinNull(pg.activity_drop_type[arg0_5], "activity_id")
	local var1_5 = var0_5 and AcessWithinNull(pg.activity_template[var0_5], "type")
	local var2_5 = {
		[ActivityConst.ACTIVITY_TYPE_ATELIER_LINK] = AtelierMaterial,
		[ActivityConst.ACTIVITY_TYPE_WORKBENCH] = WorkBenchItem
	}
	local var3_5

	var3_5 = var1_5 and var2_5[var1_5]
end

return var0_0
