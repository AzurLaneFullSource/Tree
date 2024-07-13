local var0_0 = class("ChapterChampionNormal", import(".LevelCellData"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.row = arg1_1.pos.row
	arg0_1.column = arg1_1.pos.column
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.attachmentId = arg0_1.id
	arg0_1.attachment = arg1_1.attachment
	arg0_1.flag = arg1_1.flag
	arg0_1.data = arg1_1.data
end

function var0_0.bindConfigTable(arg0_2)
	return pg.expedition_data_template
end

function var0_0.getPrefab(arg0_3)
	return arg0_3:getConfig("icon")
end

function var0_0.getFleetType(arg0_4)
	return FleetType.Normal
end

function var0_0.getPoolType(arg0_5)
	return arg0_5:getConfig("icon_type") == 1 and ChapterConst.TemplateEnemy or ChapterConst.TemplateChampion
end

function var0_0.getScale(arg0_6)
	return arg0_6:getConfig("scale")
end

function var0_0.inAlertRange(arg0_7, arg1_7, arg2_7)
	return _.any(arg0_7:getConfig("alert_range"), function(arg0_8)
		return arg0_8[1] + arg0_7.row == arg1_7 and arg0_8[2] + arg0_7.column == arg2_7
	end)
end

return var0_0
