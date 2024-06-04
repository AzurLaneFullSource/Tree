local var0 = class("ChapterChampionOni", import(".LevelCellData"))

function var0.Ctor(arg0, arg1)
	arg0.row = arg1.pos.row
	arg0.column = arg1.pos.column
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.attachmentId = arg0.id
	arg0.attachment = arg1.attachment
	arg0.flag = arg1.flag
	arg0.data = arg1.data
end

function var0.bindConfigTable(arg0)
	return pg.specialunit_template
end

function var0.getPrefab(arg0)
	return arg0:getConfig("prefab")
end

function var0.getFleetType(arg0)
	return FleetType.Normal
end

function var0.getPoolType(arg0)
	return ChapterConst.TemplateOni
end

function var0.getScale(arg0)
	return 200
end

function var0.inAlertRange(arg0, arg1, arg2)
	return _.any(arg0:getConfig("alert_range"), function(arg0)
		return arg0[1] + arg0.row == arg1 and arg0[2] + arg0.column == arg2
	end)
end

return var0
