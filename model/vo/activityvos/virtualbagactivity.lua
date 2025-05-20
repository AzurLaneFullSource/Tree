local var0_0 = class("VirtualBagActivity", import("model.vo.Activity"))

function var0_0.getVitemNumber(arg0_1, arg1_1)
	return arg0_1.data1KeyValueList[1][arg1_1] or 0
end

function var0_0.setVitemNumber(arg0_2, arg1_2, arg2_2)
	if arg0_2.data1KeyValueList[1][arg1_2] then
		arg0_2.data1KeyValueList[1][arg1_2] = arg2_2
	end
end

function var0_0.addVitemNumber(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:getVitemNumber(arg1_3)

	arg0_3.data1KeyValueList[1][arg1_3] = var0_3 + arg2_3
end

function var0_0.subVitemNumber(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4:getVitemNumber(arg1_4)

	arg0_4.data1KeyValueList[1][arg1_4] = math.max(0, var0_4 - arg2_4)
end

function var0_0.GetAllVitems(arg0_5)
	return arg0_5.data1KeyValueList[1]
end

function var0_0.GetDropCfgByType(arg0_6)
	local var0_6 = arg0_6 and AcessWithinNull(pg.activity_drop_type[arg0_6], "activity_id")
	local var1_6 = var0_6 and AcessWithinNull(pg.activity_template[var0_6], "type")
	local var2_6 = {
		[ActivityConst.ACTIVITY_TYPE_ATELIER_LINK] = AtelierMaterial,
		[ActivityConst.ACTIVITY_TYPE_WORKBENCH] = WorkBenchItem
	}
	local var3_6

	var3_6 = var1_6 and var2_6[var1_6]
end

return var0_0
