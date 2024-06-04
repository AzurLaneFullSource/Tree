local var0 = class("RawData2ThemeConvertor")

local function var1(arg0, arg1, arg2)
	if arg2 then
		return arg0
	elseif pg.furniture_data_template[arg0] then
		return BackyardThemeFurniture.GetUniqueId(arg0, 0)
	else
		local var0 = pg.furniture_data_template[arg1].count
		local var1

		if var0 > arg0 - arg1 then
			var1 = arg0 - arg1
		elseif arg0 > 10000000 then
			var1 = arg0 % 10
		end

		return BackyardThemeFurniture.GetUniqueId(arg1, var1)
	end
end

local function var2(arg0, arg1)
	local var0 = (arg0.shipId or 0) == 1
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.child or {}) do
		var1[tonumber(iter1.id)] = Vector2(iter1.x, iter1.y)
	end

	return (BackyardThemeFurniture.New({
		id = tonumber(arg0.id),
		position = Vector2(arg0.x, arg0.y),
		dir = arg0.dir,
		child = var1,
		parent = tonumber(arg0.parent),
		floor = arg1,
		isNewStyle = var0
	}))
end

local function var3(arg0, arg1, arg2)
	assert(pg.furniture_data_template[arg1], arg1)

	local var0 = (pg.furniture_data_template[arg1] or {}).count or 0

	if arg2 then
		for iter0 = 0, var0 - 1 do
			if arg0 == BackyardThemeFurniture.GetUniqueId(arg1, iter0) then
				return true
			end
		end
	elseif var0 > arg0 - arg1 then
		for iter1 = 0, var0 - 1 do
			if arg1 + iter1 == arg0 then
				return true
			end
		end
	elseif arg0 > 10000000 then
		for iter2 = 0, var0 - 1 do
			if arg1 * 10000000 + iter2 == arg0 then
				return true
			end
		end
	end

	return false
end

local function var4(arg0, arg1, arg2, arg3, arg4)
	for iter0, iter1 in ipairs(arg0) do
		if var3(iter1.parent, arg2, iter1.isNewStyle) and iter1:SameChildPosition(arg3, arg4) and var3(arg1, iter1.configId, iter1.isNewStyle) then
			return iter1
		end
	end
end

local function var5(arg0, arg1, arg2, arg3, arg4)
	for iter0, iter1 in ipairs(arg0) do
		if var3(iter1.parent, arg2, iter1.isNewStyle) and iter1:SameChildPosition(arg3, arg4) and var3(arg1, iter1.configId, true) then
			return iter1
		end
	end
end

function var0.GenFurnitures(arg0, arg1)
	local var0 = arg1.floor
	local var1 = arg1.mapSize
	local var2 = arg1.skipCheck
	local var3 = {}

	for iter0, iter1 in ipairs(arg1.furniture_put_list) do
		table.insert(var3, var2(iter1, var0))
	end

	for iter2, iter3 in ipairs(var3) do
		if iter3:AnyChild() then
			local var4 = {}

			for iter4, iter5 in pairs(iter3:GetChildList()) do
				local var5 = var4(var3, iter4, iter3.configId, iter3:GetPosition(), iter5)

				if var5 then
					var4[var1(iter4, var5.configId, var5.isNewStyle)] = iter5
				end
			end

			iter3:SetChildList(var4)
		end
	end

	local function var6(arg0)
		local var0 = {}

		for iter0, iter1 in pairs(arg0:GetChildList()) do
			local var1 = var5(var3, iter0, arg0.configId, arg0:GetPosition(), iter1)

			if var1 then
				var1:SetUniqueId(iter0)
				table.insert(var0, var1)
			end
		end

		return var0
	end

	local var7 = {}

	for iter6, iter7 in ipairs(var3) do
		if not iter7:HasParent() then
			table.insert(var7, iter7)
		end

		if iter7:AnyChild() then
			for iter8, iter9 in ipairs(var6(iter7)) do
				table.insert(var7, iter9)
			end
		end
	end

	local var8 = {}

	for iter10, iter11 in ipairs(var7) do
		if iter11:HasParent() then
			var8[iter11.id] = true
		end
	end

	for iter12, iter13 in ipairs(var7) do
		if not iter13:HasParent() then
			for iter14, iter15 in ipairs(iter13:GetAllUniqueId()) do
				if not var8[iter15] then
					iter13:SetUniqueId(iter15)

					var8[iter15] = true

					break
				end
			end
		end
	end

	local function var9(arg0, arg1, arg2)
		for iter0, iter1 in ipairs(arg0) do
			if iter1.id == arg1 then
				iter1:SetParent(arg2)

				break
			end
		end
	end

	for iter16, iter17 in ipairs(var7) do
		if iter17:AnyChild() then
			for iter18, iter19 in pairs(iter17:GetChildList()) do
				var9(var7, iter18, iter17.id)
			end
		end
	end

	local var10 = {}

	for iter20, iter21 in ipairs(var7) do
		var10[iter21.id] = iter21
	end

	if not var2 then
		arg0:CheckFurnitures(var10, var1)
	end

	return var10
end

function var0.CheckFurnitures(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in pairs(arg1) do
		local var1, var2 = CourtYardRawDataChecker.CheckFurnitrue(iter1, arg1, arg2)

		if not var1 then
			arg0:CollectionClearIdList(var0, iter1, arg1)
		end
	end

	if #var0 > 0 then
		for iter2, iter3 in ipairs(var0) do
			if arg1[iter3] then
				arg1[iter3] = nil
			end
		end

		arg0:CheckFurnitures(arg1, arg2)
	end
end

function var0.CollectionClearIdList(arg0, arg1, arg2, arg3)
	if arg2:AnyChild() then
		for iter0, iter1 in ipairs(arg2:GetChildIdList()) do
			CollectionClearIdList(arg1, arg3[iter1], arg3)
		end
	end

	table.insert(arg1, arg2.id)
end

return var0
