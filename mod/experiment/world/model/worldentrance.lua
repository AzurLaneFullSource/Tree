local var0 = class("WorldEntrance", import("...BaseEntity"))

var0.Fields = {
	config = "table",
	marks = "table",
	transportDic = "table",
	world = "table",
	id = "number",
	becomeSairen = "boolean",
	active = "boolean"
}
var0.Listeners = {}
var0.EventUpdateMapIndex = "WorldEntrance.EventUpdateMapIndex"
var0.EventUpdateDisplayMarks = "WorldEntrance.EventUpdateDisplayMarks"

function var0.DebugPrint(arg0)
	return string.format("入口 [id: %s] [原始地图: %s] [所属区域: %s] [所属海域: %s]", arg0.id, arg0:GetBaseMapId(), arg0.config.regions, arg0.config.world)
end

function var0.Setup(arg0, arg1, arg2)
	arg0.id = arg1

	assert(pg.world_chapter_colormask[arg1], "world_chapter_colormask.csv without this id:" .. arg0.id)

	arg0.config = pg.world_chapter_colormask[arg1]
	arg0.transportDic = {}

	for iter0, iter1 in ipairs(arg0.config.map_transfer) do
		arg0.transportDic[iter1] = true
	end

	arg0.marks = {
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

function var0.IsOpen(arg0)
	return arg0:GetBaseMap():IsMapOpen()
end

function var0.GetBaseMapId(arg0)
	return arg0.config.chapter
end

function var0.GetBaseMap(arg0)
	return nowWorld():GetMap(arg0:GetBaseMapId())
end

function var0.GetColormaskUniqueID(arg0)
	return arg0.config.color_id
end

function var0.GetAreaId(arg0)
	return arg0.config.regions
end

function var0.IsPressing(arg0)
	return arg0:GetBaseMap().isPressing
end

function var0.HasPort(arg0, arg1)
	local var0 = arg0:GetPortId()

	return var0 > 0 and (not arg1 or pg.world_port_data[var0].port_camp == nowWorld():GetRealm())
end

function var0.GetPortId(arg0)
	return arg0.config.port_map_icon
end

function var0.UpdateActive(arg0, arg1)
	if arg0.active ~= arg1 then
		arg0.active = arg1

		if arg1 then
			nowWorld():GetAtlas():SetActiveEntrance(arg0)
		end
	end
end

function var0.UpdateDisplayMarks(arg0, arg1, arg2)
	local var0 = arg0.marks[arg1] == 0 and arg2 or arg0.marks[arg1] == 1 and not arg2

	arg0.marks[arg1] = arg0.marks[arg1] + (arg2 and 1 or -1)

	if var0 then
		arg0:DispatchEvent(var0.EventUpdateDisplayMarks, arg1, arg0.marks[arg1] > 0)
	end
end

function var0.GetDisplayMarks(arg0)
	return arg0.marks
end

function var0.GetSairenMapId(arg0)
	return arg0.config.sairen_chapter[1]
end

function var0.UpdateSairenMark(arg0, arg1)
	if tobool(arg0.becomeSairen) ~= tobool(arg1) then
		arg0.becomeSairen = arg1
	end
end

function var0.GetAchievementAwards(arg0)
	return _.map(arg0.config.target_drop_show, function(arg0)
		return {
			star = arg0[1],
			drop = {
				type = arg0[2][1],
				id = arg0[2][2],
				count = arg0[2][3]
			}
		}
	end)
end

return var0
