local var0 = class("ChapterCell", import(".LevelCellData"))

function var0.Ctor(arg0, arg1)
	arg0.walkable = true
	arg0.forbiddenDirections = ChapterConst.ForbiddenNone
	arg0.row = arg1.pos.row
	arg0.column = arg1.pos.column
	arg0.attachment = arg1.item_type
	arg0.attachmentId = arg1.item_id
	arg0.flag = arg1.item_flag
	arg0.data = arg1.item_data
	arg0.trait = ChapterConst.TraitNone
	arg0.item = nil
	arg0.itemOffset = nil
	arg0.flagList = {}

	if arg1.flag_list then
		for iter0, iter1 in ipairs(arg1.flag_list) do
			table.insert(arg0.flagList, iter1)
		end
	end
end

function var0.updateFlagList(arg0, arg1)
	arg0.flagList = arg0.flagList or {}

	table.clear(arg0.flagList)

	for iter0, iter1 in ipairs(arg1.flag_list) do
		table.insert(arg0.flagList, iter1)
	end
end

function var0.GetFlagList(arg0)
	return arg0.flagList
end

function var0.GetWeatherFlagList(arg0)
	return _.filter(arg0:GetFlagList(), function(arg0)
		return tobool(pg.weather_data_template[arg0])
	end)
end

function var0.checkHadFlag(arg0, arg1)
	return table.contains(arg0.flagList, arg1)
end

function var0.Line2Name(arg0, arg1)
	return "chapter_cell_" .. arg0 .. "_" .. arg1
end

function var0.Line2QuadName(arg0, arg1)
	return "chapter_cell_quad_" .. arg0 .. "_" .. arg1
end

function var0.Line2MarkName(arg0, arg1, arg2)
	return "chapter_cell_mark_" .. arg0 .. "_" .. arg1 .. "#" .. arg2
end

function var0.MinMaxLine2QuadName(arg0, arg1, arg2, arg3)
	return "chapter_cell_quad_" .. arg0 .. "_" .. arg1 .. "_" .. arg2 .. "_" .. arg3
end

function var0.Line2RivalName(arg0, arg1, arg2)
	return "rival_" .. arg1 .. "_" .. arg2
end

function var0.LineAround(arg0, arg1, arg2)
	local var0 = {}

	for iter0 = -arg2, arg2 do
		for iter1 = -arg2, arg2 do
			if arg2 >= math.abs(iter0) + math.abs(iter1) then
				table.insert(var0, {
					row = arg0 + iter0,
					column = arg1 + iter1
				})
			end
		end
	end

	return var0
end

function var0.SetWalkable(arg0, arg1)
	arg0.walkable = tobool(arg1)

	if type(arg1) == "boolean" then
		arg0.forbiddenDirections = arg1 and ChapterConst.ForbiddenNone or ChapterConst.ForbiddenAll
	elseif type(arg1) == "number" then
		arg0.forbiddenDirections = bit.band(arg1, ChapterConst.ForbiddenAll)
	end
end

function var0.IsWalkable(arg0)
	return arg0.walkable
end

return var0
