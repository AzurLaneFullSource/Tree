local var0 = class("GetCanBePutFurnituresForThemeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.theme
	local var2 = var0.callback
	local var3 = getProxy(DormProxy).floor
	local var4 = var0.GetAllFloorFurnitures()

	if var1:IsOccupyed(var4, var3) then
		local var5 = var1:GetUsableFurnituresForFloor(var4, var3)

		var0.SortListForPut(var5)

		if var2 then
			var2(false, var5)
		end
	else
		local var6 = var1:GetAllFurniture()
		local var7 = {}

		for iter0, iter1 in pairs(Clone(var6)) do
			table.insert(var7, iter1)
		end

		var0.SortListForPut(var7)

		if var2 then
			var2(true, var7)
		end
	end
end

function var0.GetAllFloorFurnitures()
	local var0 = {}

	var0.GetCurrFloorHouse(var0)
	var0.GetOtherFloorHouse(var0)

	return var0
end

function var0.GetCurrFloorHouse(arg0)
	local var0 = _courtyard:GetController():GetStoreyData()

	for iter0, iter1 in pairs(var0) do
		arg0[iter1.id] = var0.StoreyFurniture2ThemeFurniture(iter1)
	end
end

function var0.StoreyFurniture2ThemeFurniture(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.child) do
		var0[tonumber(iter0)] = {
			x = iter1.x,
			y = iter1.y
		}
	end

	return BackyardThemeFurniture.New({
		id = tonumber(arg0.id),
		configId = arg0.configId or tonumber(arg0.id),
		position = arg0.position,
		dir = arg0.dir,
		child = var0,
		parent = tonumber(arg0.parent) or 0,
		floor = arg0.floor
	})
end

function var0.GetOtherFloorHouse(arg0)
	local var0 = var0.GetFurnitureInOtherFloor(getProxy(DormProxy).floor)

	for iter0, iter1 in pairs(var0) do
		arg0[iter1.id] = iter1
	end
end

function var0.GetFurnitureInOtherFloor(arg0)
	local var0 = getProxy(DormProxy):getRawData()
	local var1 = {}

	for iter0, iter1 in pairs(var0:GetThemeList()) do
		if arg0 ~= iter0 then
			for iter2, iter3 in pairs(iter1:GetAllFurniture()) do
				var1[iter2] = iter3
			end
		end
	end

	return var1
end

function var0.IsUsing(arg0)
	local var0 = {}
	local var1 = {}

	var0.GetCurrFloorHouse(var0)
	var0.GetOtherFloorHouse(var1)

	return arg0.id ~= "" and (arg0:IsUsing(var0) or arg0:IsUsing(var1))
end

function var0.SortListForPut(arg0)
	local var0 = pg.furniture_data_template

	table.sort(arg0, function(arg0, arg1)
		if (arg0.parent ~= 0 and 1 or 0) == (arg1.parent ~= 0 and 1 or 0) then
			local var0 = var0[arg0.id] and var0[arg0.id].type == Furniture.TYPE_STAGE and 1 or 0
			local var1 = var0[arg1.id] and var0[arg1.id].type == Furniture.TYPE_STAGE and 1 or 0

			if var0 == var1 then
				local var2 = table.getCount(arg0.child or {})
				local var3 = table.getCount(arg1.child or {})

				if var2 == var3 then
					return arg0.id < arg0.id
				else
					return var3 < var2
				end
			else
				return var1 < var0
			end
		else
			return arg0.parent < arg1.parent
		end
	end)
end

return var0
