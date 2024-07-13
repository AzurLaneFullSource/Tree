local var0_0 = class("BackyardThemeFurniture")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = tonumber(arg1_1.id)
	arg0_1.configId = arg1_1.configId or tonumber(arg1_1.id)
	arg0_1.position = arg1_1.position
	arg0_1.dir = arg1_1.dir or 1
	arg0_1.parent = tonumber(arg1_1.parent) or 0
	arg0_1.child = arg1_1.child or {}
	arg0_1.date = arg1_1.date or 0
	arg0_1.floor = arg1_1.floor
	arg0_1.isNewStyle = arg1_1.isNewStyle
end

function var0_0.GetUniqueId(arg0_2, arg1_2)
	return arg0_2 * 100 + arg1_2
end

function var0_0.GetAllUniqueId(arg0_3)
	local var0_3 = {}
	local var1_3 = pg.furniture_data_template[arg0_3.configId]

	for iter0_3 = 0, var1_3.count - 1 do
		table.insert(var0_3, var0_0.GetUniqueId(arg0_3.configId, iter0_3))
	end

	return var0_3
end

function var0_0.SetUniqueId(arg0_4, arg1_4)
	arg0_4.id = arg1_4
end

function var0_0.SetParent(arg0_5, arg1_5)
	arg0_5.parent = arg1_5
end

function var0_0.SetChildList(arg0_6, arg1_6)
	arg0_6.child = arg1_6
end

function var0_0.HasParent(arg0_7)
	return arg0_7.parent ~= 0
end

function var0_0.AnyChild(arg0_8)
	return table.getCount(arg0_8.child) > 0
end

function var0_0.GetChildIdList(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.child) do
		table.insert(var0_9, ids)
	end

	return var0_9
end

function var0_0.GetChildList(arg0_10)
	return arg0_10.child
end

function var0_0.GetPosition(arg0_11)
	return arg0_11.position
end

function var0_0.SameParent(arg0_12, arg1_12)
	return arg0_12.parent == arg1_12
end

function var0_0.GetDir(arg0_13)
	return arg0_13.dir
end

function var0_0.UpdateParent(arg0_14, arg1_14)
	arg0_14.parent = arg1_14
end

function var0_0.UpdateChildList(arg0_15, arg1_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in pairs(arg1_15) do
		var0_15[iter0_15] = iter1_15
	end

	arg0_15:SetChildList(var0_15)
end

function var0_0.UpdateFloor(arg0_16, arg1_16)
	arg0_16.floor = arg1_16
end

function var0_0.SameChildPosition(arg0_17, arg1_17, arg2_17)
	return arg0_17:GetPosition() == arg1_17 + arg2_17
end

function var0_0.isPaper(arg0_18)
	local var0_18 = arg0_18:getConfig("type")

	if var0_18 == Furniture.TYPE_WALLPAPER or var0_18 == Furniture.TYPE_FLOORPAPER then
		return true
	end

	return false
end

function var0_0.getConfig(arg0_19, arg1_19)
	local var0_19 = pg.furniture_data_template[arg0_19.configId]

	if var0_19[arg1_19] then
		return var0_19[arg1_19]
	else
		local var1_19 = pg.furniture_shop_template[arg0_19.configId]

		if var1_19 then
			return var1_19[arg1_19]
		end
	end
end

function var0_0.IsWall(arg0_20)
	local var0_20 = arg0_20:getConfig("type")

	return var0_20 == Furniture.TYPE_WALL or var0_20 == Furniture.TYPE_WALL_MAT
end

function var0_0.isSame(arg0_21, arg1_21)
	if arg0_21.position.x == arg1_21.position.x and arg0_21.position.y == arg1_21.position.y and (arg0_21.dir == arg1_21.dir or arg0_21:IsWall()) and arg0_21.parent == arg1_21.parent then
		return true
	end

	return false
end

function var0_0.IsSameConfig(arg0_22, arg1_22)
	return arg0_22.configId == arg1_22
end

function var0_0.UpdatePosition(arg0_23, arg1_23)
	arg0_23.position = arg1_23
end

function var0_0.UpdateDir(arg0_24, arg1_24)
	arg0_24.dir = arg1_24
end

function var0_0._GetWeight(arg0_25)
	local var0_25 = pg.furniture_data_template[arg0_25.configId]
	local var1_25 = 3

	if var0_25.type == Furniture.TYPE_FLOORPAPER then
		var1_25 = 0
	elseif var0_25.type == Furniture.TYPE_WALLPAPER then
		var1_25 = 1
	elseif arg0_25.parent ~= 0 and table.getCount(arg0_25.child) > 0 then
		var1_25 = 4
	elseif arg0_25.parent ~= 0 then
		var1_25 = 5
	elseif var0_25.type == Furniture.TYPE_STAGE then
		var1_25 = 2
	end

	return var1_25
end

function var0_0._LoadWeight(arg0_26, arg1_26)
	local var0_26 = var0_0._GetWeight(arg0_26)
	local var1_26 = var0_0._GetWeight(arg1_26)

	if var0_26 == var1_26 then
		return arg0_26.id < arg1_26.id
	else
		return var0_26 < var1_26
	end
end

function var0_0.ToSaveData(arg0_27)
	return {
		id = arg0_27.id,
		configId = arg0_27.configId,
		position = arg0_27.position,
		x = arg0_27.position.x,
		y = arg0_27.position.y,
		dir = arg0_27.dir,
		child = arg0_27.child,
		parent = arg0_27.parent,
		floor = arg0_27.floor
	}
end

return var0_0
