local var0 = class("ChapterChampionSubmarine", import(".ChapterChampionNormal"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg1)
end

function var0.bindConfigTable(arg0)
	return pg.expedition_data_template
end

function var0.getPrefab(arg0)
	return arg0:getConfig("icon")
end

function var0.getFleetType(arg0)
	return FleetType.Submarine
end

function var0.getPoolType(arg0)
	return "tpl_enemy"
end

function var0.getScale(arg0)
	return arg0:getConfig("scale")
end

function var0.inAlertRange(arg0, arg1, arg2)
	return _.any(arg0:getConfig("alert_range"), function(arg0)
		return arg0[1] + arg0.row == arg1 and arg0[2] + arg0.column == arg2
	end)
end

return var0
