local var0_0 = class("ChapterChampionSubmarine", import(".ChapterChampionNormal"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg1_1)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.expedition_data_template
end

function var0_0.getPrefab(arg0_3)
	return arg0_3:getConfig("icon")
end

function var0_0.getFleetType(arg0_4)
	return FleetType.Submarine
end

function var0_0.getPoolType(arg0_5)
	return "tpl_enemy"
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
