local var0 = class("RawFurnitureData")

function var0.Ctor(arg0, arg1)
	arg0.config = pg.furniture_data_template[arg1.configId]
	arg0.name = arg0.config.name
	arg0.id = arg1.id
	arg0.floor = arg1.floor
	arg0.parent = arg1.parent
	arg0.dir = arg1.dir
	arg0.child = arg1.child
	arg0.position = arg1.position
	arg0.x = arg0.position and arg0.position.x or arg1.x
	arg0.y = arg0.position and arg0.position.y or arg1.y

	if arg0.dir == 1 then
		arg0.sizeX = arg0.config.size[1]
		arg0.sizeY = arg0.config.size[2]
	else
		arg0.sizeX = arg0.config.size[2]
		arg0.sizeY = arg0.config.size[1]
	end
end

function var0.IsCompletion(arg0)
	if not arg0.floor then
		return false
	end

	if not arg0.parent then
		return false
	end

	if not arg0.dir or arg0.dir < 0 or arg0.dir > 2 then
		return false
	end

	if not arg0.child then
		return false
	end

	if not arg0.x or not arg0.y then
		return false
	end

	return true
end

function var0.ExistParnet(arg0)
	return arg0.parent and arg0.parent ~= 0
end

function var0.LegalParent(arg0, arg1)
	if not arg1 then
		return false
	end

	if not arg1:LegalChild(arg0) then
		return false
	end

	return true
end

function var0.LegalChild(arg0, arg1)
	if not arg1 then
		return false
	end

	if arg1.parent ~= arg0.id then
		return false
	end

	local var0 = {}

	for iter0, iter1 in pairs(arg0.child or {}) do
		table.insert(var0, iter0)
	end

	if not table.contains(var0, arg1.id) then
		return false
	end

	return true
end

function var0.InSide(arg0, arg1, arg2, arg3, arg4)
	if arg0.config.belong == 1 and arg0.config.type ~= 1 and arg0.config.type ~= 4 and not arg0:ExistParnet() then
		local var0 = arg0:GetAreaByPosition()

		return _.all(var0, function(arg0)
			return arg0.x >= arg1 and arg0.y >= arg2 and arg0.x <= arg3 and arg0.y <= arg4
		end)
	end

	if arg0.config.belong == 3 and arg0.x >= arg3 + 1 then
		return false
	end

	if arg0.config.belong == 4 and arg0.y >= arg4 + 1 then
		return false
	end

	return true
end

function var0.GetAreaByPosition(arg0)
	local var0 = {}

	for iter0 = arg0.x, arg0.x + arg0.sizeX - 1 do
		for iter1 = arg0.y, arg0.y + arg0.sizeY - 1 do
			table.insert(var0, Vector2(iter0, iter1))
		end
	end

	return var0
end

function var0.MatOrPaper(arg0)
	return arg0.config.type == 5 or arg0.config.type == 10 or arg0.config.type == 1 or arg0.config.type == 4
end

return var0
