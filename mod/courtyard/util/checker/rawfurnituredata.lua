local var0_0 = class("RawFurnitureData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.config = pg.furniture_data_template[arg1_1.configId]
	arg0_1.name = arg0_1.config.name
	arg0_1.id = arg1_1.id
	arg0_1.floor = arg1_1.floor
	arg0_1.parent = arg1_1.parent
	arg0_1.dir = arg1_1.dir
	arg0_1.child = arg1_1.child
	arg0_1.position = arg1_1.position
	arg0_1.x = arg0_1.position and arg0_1.position.x or arg1_1.x
	arg0_1.y = arg0_1.position and arg0_1.position.y or arg1_1.y

	if arg0_1.dir == 1 then
		arg0_1.sizeX = arg0_1.config.size[1]
		arg0_1.sizeY = arg0_1.config.size[2]
	else
		arg0_1.sizeX = arg0_1.config.size[2]
		arg0_1.sizeY = arg0_1.config.size[1]
	end
end

function var0_0.IsCompletion(arg0_2)
	if not arg0_2.floor then
		return false
	end

	if not arg0_2.parent then
		return false
	end

	if not arg0_2.dir or arg0_2.dir < 0 or arg0_2.dir > 2 then
		return false
	end

	if not arg0_2.child then
		return false
	end

	if not arg0_2.x or not arg0_2.y then
		return false
	end

	return true
end

function var0_0.ExistParnet(arg0_3)
	return arg0_3.parent and arg0_3.parent ~= 0
end

function var0_0.LegalParent(arg0_4, arg1_4)
	if not arg1_4 then
		return false
	end

	if not arg1_4:LegalChild(arg0_4) then
		return false
	end

	return true
end

function var0_0.LegalChild(arg0_5, arg1_5)
	if not arg1_5 then
		return false
	end

	if arg1_5.parent ~= arg0_5.id then
		return false
	end

	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.child or {}) do
		table.insert(var0_5, iter0_5)
	end

	if not table.contains(var0_5, arg1_5.id) then
		return false
	end

	return true
end

function var0_0.InSide(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	if arg0_6.config.belong == 1 and arg0_6.config.type ~= 1 and arg0_6.config.type ~= 4 and not arg0_6:ExistParnet() then
		local var0_6 = arg0_6:GetAreaByPosition()

		return _.all(var0_6, function(arg0_7)
			return arg0_7.x >= arg1_6 and arg0_7.y >= arg2_6 and arg0_7.x <= arg3_6 and arg0_7.y <= arg4_6
		end)
	end

	if arg0_6.config.belong == 3 and arg0_6.x >= arg3_6 + 1 then
		return false
	end

	if arg0_6.config.belong == 4 and arg0_6.y >= arg4_6 + 1 then
		return false
	end

	return true
end

function var0_0.GetAreaByPosition(arg0_8)
	local var0_8 = {}

	for iter0_8 = arg0_8.x, arg0_8.x + arg0_8.sizeX - 1 do
		for iter1_8 = arg0_8.y, arg0_8.y + arg0_8.sizeY - 1 do
			table.insert(var0_8, Vector2(iter0_8, iter1_8))
		end
	end

	return var0_8
end

function var0_0.MatOrPaper(arg0_9)
	return arg0_9.config.type == 5 or arg0_9.config.type == 10 or arg0_9.config.type == 1 or arg0_9.config.type == 4
end

return var0_0
