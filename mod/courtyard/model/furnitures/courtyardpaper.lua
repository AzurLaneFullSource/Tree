local var0_0 = class("CourtYardPaper")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg2_1.id
	arg0_1.configId = arg2_1.configId or arg0_1.id
	arg0_1.config = pg.furniture_data_template[arg0_1.configId]
end

function var0_0.IsDirty(arg0_2)
	return true
end

function var0_0.UnDirty(arg0_3)
	return
end

function var0_0.GetObjType(arg0_4)
	if arg0_4.config.spine ~= nil then
		return CourtYardConst.OBJ_TYPE_SPINE
	else
		return CourtYardConst.OBJ_TYPE_COMMOM
	end
end

function var0_0.GetPicture(arg0_5)
	return arg0_5.config.picture
end

function var0_0.GetSpineNameAndAction(arg0_6)
	local var0_6 = arg0_6.config.spine[1]

	return var0_6[1], var0_6[2]
end

function var0_0.GetType(arg0_7)
	return arg0_7.config.type
end

function var0_0.ToTable(arg0_8)
	return {
		dir = 1,
		parent = 0,
		x = 0,
		y = 0,
		id = arg0_8.id,
		configId = arg0_8.configId,
		position = Vector2(0, 0),
		child = {}
	}
end

return var0_0
