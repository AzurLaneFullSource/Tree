local var0 = class("BackyardThemeFurniture")

function var0.Ctor(arg0, arg1)
	arg0.id = tonumber(arg1.id)
	arg0.configId = arg1.configId or tonumber(arg1.id)
	arg0.position = arg1.position
	arg0.dir = arg1.dir or 1
	arg0.parent = tonumber(arg1.parent) or 0
	arg0.child = arg1.child or {}
	arg0.date = arg1.date or 0
	arg0.floor = arg1.floor
	arg0.isNewStyle = arg1.isNewStyle
end

function var0.GetUniqueId(arg0, arg1)
	return arg0 * 100 + arg1
end

function var0.GetAllUniqueId(arg0)
	local var0 = {}
	local var1 = pg.furniture_data_template[arg0.configId]

	for iter0 = 0, var1.count - 1 do
		table.insert(var0, var0.GetUniqueId(arg0.configId, iter0))
	end

	return var0
end

function var0.SetUniqueId(arg0, arg1)
	arg0.id = arg1
end

function var0.SetParent(arg0, arg1)
	arg0.parent = arg1
end

function var0.SetChildList(arg0, arg1)
	arg0.child = arg1
end

function var0.HasParent(arg0)
	return arg0.parent ~= 0
end

function var0.AnyChild(arg0)
	return table.getCount(arg0.child) > 0
end

function var0.GetChildIdList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.child) do
		table.insert(var0, ids)
	end

	return var0
end

function var0.GetChildList(arg0)
	return arg0.child
end

function var0.GetPosition(arg0)
	return arg0.position
end

function var0.SameParent(arg0, arg1)
	return arg0.parent == arg1
end

function var0.GetDir(arg0)
	return arg0.dir
end

function var0.UpdateParent(arg0, arg1)
	arg0.parent = arg1
end

function var0.UpdateChildList(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg1) do
		var0[iter0] = iter1
	end

	arg0:SetChildList(var0)
end

function var0.UpdateFloor(arg0, arg1)
	arg0.floor = arg1
end

function var0.SameChildPosition(arg0, arg1, arg2)
	return arg0:GetPosition() == arg1 + arg2
end

function var0.isPaper(arg0)
	local var0 = arg0:getConfig("type")

	if var0 == Furniture.TYPE_WALLPAPER or var0 == Furniture.TYPE_FLOORPAPER then
		return true
	end

	return false
end

function var0.getConfig(arg0, arg1)
	local var0 = pg.furniture_data_template[arg0.configId]

	if var0[arg1] then
		return var0[arg1]
	else
		local var1 = pg.furniture_shop_template[arg0.configId]

		if var1 then
			return var1[arg1]
		end
	end
end

function var0.IsWall(arg0)
	local var0 = arg0:getConfig("type")

	return var0 == Furniture.TYPE_WALL or var0 == Furniture.TYPE_WALL_MAT
end

function var0.isSame(arg0, arg1)
	if arg0.position.x == arg1.position.x and arg0.position.y == arg1.position.y and (arg0.dir == arg1.dir or arg0:IsWall()) and arg0.parent == arg1.parent then
		return true
	end

	return false
end

function var0.IsSameConfig(arg0, arg1)
	return arg0.configId == arg1
end

function var0.UpdatePosition(arg0, arg1)
	arg0.position = arg1
end

function var0.UpdateDir(arg0, arg1)
	arg0.dir = arg1
end

function var0._GetWeight(arg0)
	local var0 = pg.furniture_data_template[arg0.configId]
	local var1 = 3

	if var0.type == Furniture.TYPE_FLOORPAPER then
		var1 = 0
	elseif var0.type == Furniture.TYPE_WALLPAPER then
		var1 = 1
	elseif arg0.parent ~= 0 and table.getCount(arg0.child) > 0 then
		var1 = 4
	elseif arg0.parent ~= 0 then
		var1 = 5
	elseif var0.type == Furniture.TYPE_STAGE then
		var1 = 2
	end

	return var1
end

function var0._LoadWeight(arg0, arg1)
	local var0 = var0._GetWeight(arg0)
	local var1 = var0._GetWeight(arg1)

	if var0 == var1 then
		return arg0.id < arg1.id
	else
		return var0 < var1
	end
end

function var0.ToSaveData(arg0)
	return {
		id = arg0.id,
		configId = arg0.configId,
		position = arg0.position,
		x = arg0.position.x,
		y = arg0.position.y,
		dir = arg0.dir,
		child = arg0.child,
		parent = arg0.parent,
		floor = arg0.floor
	}
end

return var0
