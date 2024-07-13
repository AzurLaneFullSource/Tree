local var0_0 = class("ChapterCell", import(".LevelCellData"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.walkable = true
	arg0_1.forbiddenDirections = ChapterConst.ForbiddenNone
	arg0_1.row = arg1_1.pos.row
	arg0_1.column = arg1_1.pos.column
	arg0_1.attachment = arg1_1.item_type
	arg0_1.attachmentId = arg1_1.item_id
	arg0_1.flag = arg1_1.item_flag
	arg0_1.data = arg1_1.item_data
	arg0_1.trait = ChapterConst.TraitNone
	arg0_1.item = nil
	arg0_1.itemOffset = nil
	arg0_1.flagList = {}

	if arg1_1.flag_list then
		for iter0_1, iter1_1 in ipairs(arg1_1.flag_list) do
			table.insert(arg0_1.flagList, iter1_1)
		end
	end
end

function var0_0.updateFlagList(arg0_2, arg1_2)
	arg0_2.flagList = arg0_2.flagList or {}

	table.clear(arg0_2.flagList)

	for iter0_2, iter1_2 in ipairs(arg1_2.flag_list) do
		table.insert(arg0_2.flagList, iter1_2)
	end
end

function var0_0.GetFlagList(arg0_3)
	return arg0_3.flagList
end

function var0_0.GetWeatherFlagList(arg0_4)
	return _.filter(arg0_4:GetFlagList(), function(arg0_5)
		return tobool(pg.weather_data_template[arg0_5])
	end)
end

function var0_0.checkHadFlag(arg0_6, arg1_6)
	return table.contains(arg0_6.flagList, arg1_6)
end

function var0_0.Line2Name(arg0_7, arg1_7)
	return "chapter_cell_" .. arg0_7 .. "_" .. arg1_7
end

function var0_0.Line2QuadName(arg0_8, arg1_8)
	return "chapter_cell_quad_" .. arg0_8 .. "_" .. arg1_8
end

function var0_0.Line2MarkName(arg0_9, arg1_9, arg2_9)
	return "chapter_cell_mark_" .. arg0_9 .. "_" .. arg1_9 .. "#" .. arg2_9
end

function var0_0.MinMaxLine2QuadName(arg0_10, arg1_10, arg2_10, arg3_10)
	return "chapter_cell_quad_" .. arg0_10 .. "_" .. arg1_10 .. "_" .. arg2_10 .. "_" .. arg3_10
end

function var0_0.Line2RivalName(arg0_11, arg1_11, arg2_11)
	return "rival_" .. arg1_11 .. "_" .. arg2_11
end

function var0_0.LineAround(arg0_12, arg1_12, arg2_12)
	local var0_12 = {}

	for iter0_12 = -arg2_12, arg2_12 do
		for iter1_12 = -arg2_12, arg2_12 do
			if arg2_12 >= math.abs(iter0_12) + math.abs(iter1_12) then
				table.insert(var0_12, {
					row = arg0_12 + iter0_12,
					column = arg1_12 + iter1_12
				})
			end
		end
	end

	return var0_12
end

function var0_0.SetWalkable(arg0_13, arg1_13)
	arg0_13.walkable = tobool(arg1_13)

	if type(arg1_13) == "boolean" then
		arg0_13.forbiddenDirections = arg1_13 and ChapterConst.ForbiddenNone or ChapterConst.ForbiddenAll
	elseif type(arg1_13) == "number" then
		arg0_13.forbiddenDirections = bit.band(arg1_13, ChapterConst.ForbiddenAll)
	end
end

function var0_0.IsWalkable(arg0_14)
	return arg0_14.walkable
end

return var0_0
