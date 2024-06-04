local var0 = class("CourtYardPaper")

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg2.id
	arg0.configId = arg2.configId or arg0.id
	arg0.config = pg.furniture_data_template[arg0.configId]
end

function var0.IsDirty(arg0)
	return true
end

function var0.UnDirty(arg0)
	return
end

function var0.GetObjType(arg0)
	if arg0.config.spine ~= nil then
		return CourtYardConst.OBJ_TYPE_SPINE
	else
		return CourtYardConst.OBJ_TYPE_COMMOM
	end
end

function var0.GetPicture(arg0)
	return arg0.config.picture
end

function var0.GetSpineNameAndAction(arg0)
	local var0 = arg0.config.spine[1]

	return var0[1], var0[2]
end

function var0.GetType(arg0)
	return arg0.config.type
end

function var0.ToTable(arg0)
	return {
		dir = 1,
		parent = 0,
		x = 0,
		y = 0,
		id = arg0.id,
		configId = arg0.configId,
		position = Vector2(0, 0),
		child = {}
	}
end

return var0
