local var0_0 = class("IslandAchievement", import("model.vo.BaseVO"))

var0_0.STATUS = {
	GET = "get",
	NORMAL = "noraml",
	GOT = "got"
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_achievement
end

function var0_0.SetStatus(arg0_3, arg1_3)
	arg0_3.status = arg1_3
end

function var0_0.GetStatus(arg0_4)
	return arg0_4.status
end

function var0_0.GetStage(arg0_5)
	return arg0_5:getConfig("stage")
end

function var0_0.IsHideType(arg0_6)
	return arg0_6:getConfig("show_type") == 2
end

function var0_0.GetType(arg0_7)
	return arg0_7:getConfig("target_type")
end

function var0_0.GetParam(arg0_8)
	return arg0_8:getConfig("target_value1")
end

function var0_0.GetNum(arg0_9)
	return arg0_9:getConfig("target_num")
end

function var0_0.GetAwards(arg0_10)
	local var0_10 = arg0_10:getConfig("award_display")

	if var0_10 == "" then
		return {}
	end

	return underscore.map(var0_10, function(arg0_11)
		return Drop.Create(arg0_11)
	end)
end

function var0_0.GetIcon(arg0_12)
	local var0_12 = pg.island_achievement[arg0_12].group
	local var1_12 = pg.island_achievement_group

	return var1_12[underscore.detect(var1_12.all, function(arg0_13)
		return table.contains(var1_12[arg0_13].achievement_list, var0_12)
	end)].icon
end

return var0_0
