local var0_0 = class("GetCanBePutFurnituresForThemeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.theme
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(DormProxy).floor
	local var4_1 = var0_0.GetAllFloorFurnitures()

	if var1_1:IsOccupyed(var4_1, var3_1) then
		local var5_1 = var1_1:GetUsableFurnituresForFloor(var4_1, var3_1)

		var0_0.SortListForPut(var5_1)

		if var2_1 then
			var2_1(false, var5_1)
		end
	else
		local var6_1 = var1_1:GetAllFurniture()
		local var7_1 = {}

		for iter0_1, iter1_1 in pairs(Clone(var6_1)) do
			table.insert(var7_1, iter1_1)
		end

		var0_0.SortListForPut(var7_1)

		if var2_1 then
			var2_1(true, var7_1)
		end
	end
end

function var0_0.GetAllFloorFurnitures()
	local var0_2 = {}

	var0_0.GetCurrFloorHouse(var0_2)
	var0_0.GetOtherFloorHouse(var0_2)

	return var0_2
end

function var0_0.GetCurrFloorHouse(arg0_3)
	local var0_3 = _courtyard:GetController():GetStoreyData()

	for iter0_3, iter1_3 in pairs(var0_3) do
		arg0_3[iter1_3.id] = var0_0.StoreyFurniture2ThemeFurniture(iter1_3)
	end
end

function var0_0.StoreyFurniture2ThemeFurniture(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(arg0_4.child) do
		var0_4[tonumber(iter0_4)] = {
			x = iter1_4.x,
			y = iter1_4.y
		}
	end

	return BackyardThemeFurniture.New({
		id = tonumber(arg0_4.id),
		configId = arg0_4.configId or tonumber(arg0_4.id),
		position = arg0_4.position,
		dir = arg0_4.dir,
		child = var0_4,
		parent = tonumber(arg0_4.parent) or 0,
		floor = arg0_4.floor
	})
end

function var0_0.GetOtherFloorHouse(arg0_5)
	local var0_5 = var0_0.GetFurnitureInOtherFloor(getProxy(DormProxy).floor)

	for iter0_5, iter1_5 in pairs(var0_5) do
		arg0_5[iter1_5.id] = iter1_5
	end
end

function var0_0.GetFurnitureInOtherFloor(arg0_6)
	local var0_6 = getProxy(DormProxy):getRawData()
	local var1_6 = {}

	for iter0_6, iter1_6 in pairs(var0_6:GetThemeList()) do
		if arg0_6 ~= iter0_6 then
			for iter2_6, iter3_6 in pairs(iter1_6:GetAllFurniture()) do
				var1_6[iter2_6] = iter3_6
			end
		end
	end

	return var1_6
end

function var0_0.IsUsing(arg0_7)
	local var0_7 = {}
	local var1_7 = {}

	var0_0.GetCurrFloorHouse(var0_7)
	var0_0.GetOtherFloorHouse(var1_7)

	return arg0_7.id ~= "" and (arg0_7:IsUsing(var0_7) or arg0_7:IsUsing(var1_7))
end

function var0_0.SortListForPut(arg0_8)
	local var0_8 = pg.furniture_data_template

	table.sort(arg0_8, function(arg0_9, arg1_9)
		if (arg0_9.parent ~= 0 and 1 or 0) == (arg1_9.parent ~= 0 and 1 or 0) then
			local var0_9 = var0_8[arg0_9.id] and var0_8[arg0_9.id].type == Furniture.TYPE_STAGE and 1 or 0
			local var1_9 = var0_8[arg1_9.id] and var0_8[arg1_9.id].type == Furniture.TYPE_STAGE and 1 or 0

			if var0_9 == var1_9 then
				local var2_9 = table.getCount(arg0_9.child or {})
				local var3_9 = table.getCount(arg1_9.child or {})

				if var2_9 == var3_9 then
					return arg0_9.id < arg0_9.id
				else
					return var3_9 < var2_9
				end
			else
				return var1_9 < var0_9
			end
		else
			return arg0_9.parent < arg1_9.parent
		end
	end)
end

return var0_0
