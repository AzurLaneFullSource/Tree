local var0_0 = class("WorldEntrance", import("...BaseEntity"))

var0_0.Fields = {
	config = "table",
	marks = "table",
	transportDic = "table",
	world = "table",
	id = "number",
	becomeSairen = "boolean",
	active = "boolean"
}
var0_0.Listeners = {}
var0_0.EventUpdateMapIndex = "WorldEntrance.EventUpdateMapIndex"
var0_0.EventUpdateDisplayMarks = "WorldEntrance.EventUpdateDisplayMarks"

function var0_0.DebugPrint(arg0_1)
	return string.format("入口 [id: %s] [原始地图: %s] [所属区域: %s] [所属海域: %s]", arg0_1.id, arg0_1:GetBaseMapId(), arg0_1.config.regions, arg0_1.config.world)
end

function var0_0.Setup(arg0_2, arg1_2, arg2_2)
	arg0_2.id = arg1_2

	assert(pg.world_chapter_colormask[arg1_2], "world_chapter_colormask.csv without this id:" .. arg0_2.id)

	arg0_2.config = pg.world_chapter_colormask[arg1_2]
	arg0_2.transportDic = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.config.map_transfer) do
		arg0_2.transportDic[iter1_2] = true
	end

	arg0_2.marks = {
		task_main = 0,
		task = 0,
		treasure_sairen = 0,
		step = 0,
		task_collecktion = 0,
		task_following = 0,
		treasure = 0,
		sairen = 0,
		task_following_main = 0,
		task_following_boss = 0
	}
end

function var0_0.IsOpen(arg0_3)
	return arg0_3:GetBaseMap():IsMapOpen()
end

function var0_0.GetBaseMapId(arg0_4)
	return arg0_4.config.chapter
end

function var0_0.GetBaseMap(arg0_5)
	return nowWorld():GetMap(arg0_5:GetBaseMapId())
end

function var0_0.GetColormaskUniqueID(arg0_6)
	return arg0_6.config.color_id
end

function var0_0.GetAreaId(arg0_7)
	return arg0_7.config.regions
end

function var0_0.IsPressing(arg0_8)
	return arg0_8:GetBaseMap().isPressing
end

function var0_0.HasPort(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetPortId()

	return var0_9 > 0 and (not arg1_9 or pg.world_port_data[var0_9].port_camp == nowWorld():GetRealm())
end

function var0_0.GetPortId(arg0_10)
	return arg0_10.config.port_map_icon
end

function var0_0.UpdateActive(arg0_11, arg1_11)
	if arg0_11.active ~= arg1_11 then
		arg0_11.active = arg1_11

		if arg1_11 then
			nowWorld():GetAtlas():SetActiveEntrance(arg0_11)
		end
	end
end

function var0_0.UpdateDisplayMarks(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.marks[arg1_12] == 0 and arg2_12 or arg0_12.marks[arg1_12] == 1 and not arg2_12

	arg0_12.marks[arg1_12] = arg0_12.marks[arg1_12] + (arg2_12 and 1 or -1)

	if var0_12 then
		arg0_12:DispatchEvent(var0_0.EventUpdateDisplayMarks, arg1_12, arg0_12.marks[arg1_12] > 0)
	end
end

function var0_0.GetDisplayMarks(arg0_13)
	return arg0_13.marks
end

function var0_0.GetSairenMapId(arg0_14)
	return arg0_14.config.sairen_chapter[1]
end

function var0_0.UpdateSairenMark(arg0_15, arg1_15)
	if tobool(arg0_15.becomeSairen) ~= tobool(arg1_15) then
		arg0_15.becomeSairen = arg1_15
	end
end

function var0_0.GetAchievementAwards(arg0_16)
	return _.map(arg0_16.config.target_drop_show, function(arg0_17)
		return {
			star = arg0_17[1],
			drop = {
				type = arg0_17[2][1],
				id = arg0_17[2][2],
				count = arg0_17[2][3]
			}
		}
	end)
end

return var0_0
