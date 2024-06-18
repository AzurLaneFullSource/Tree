local var0_0 = class("RawData2ThemeConvertor")

local function var1_0(arg0_1, arg1_1, arg2_1)
	if arg2_1 then
		return arg0_1
	elseif pg.furniture_data_template[arg0_1] then
		return BackyardThemeFurniture.GetUniqueId(arg0_1, 0)
	else
		local var0_1 = pg.furniture_data_template[arg1_1].count
		local var1_1

		if var0_1 > arg0_1 - arg1_1 then
			var1_1 = arg0_1 - arg1_1
		elseif arg0_1 > 10000000 then
			var1_1 = arg0_1 % 10
		end

		return BackyardThemeFurniture.GetUniqueId(arg1_1, var1_1)
	end
end

local function var2_0(arg0_2, arg1_2)
	local var0_2 = (arg0_2.shipId or 0) == 1
	local var1_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.child or {}) do
		var1_2[tonumber(iter1_2.id)] = Vector2(iter1_2.x, iter1_2.y)
	end

	return (BackyardThemeFurniture.New({
		id = tonumber(arg0_2.id),
		position = Vector2(arg0_2.x, arg0_2.y),
		dir = arg0_2.dir,
		child = var1_2,
		parent = tonumber(arg0_2.parent),
		floor = arg1_2,
		isNewStyle = var0_2
	}))
end

local function var3_0(arg0_3, arg1_3, arg2_3)
	assert(pg.furniture_data_template[arg1_3], arg1_3)

	local var0_3 = (pg.furniture_data_template[arg1_3] or {}).count or 0

	if arg2_3 then
		for iter0_3 = 0, var0_3 - 1 do
			if arg0_3 == BackyardThemeFurniture.GetUniqueId(arg1_3, iter0_3) then
				return true
			end
		end
	elseif var0_3 > arg0_3 - arg1_3 then
		for iter1_3 = 0, var0_3 - 1 do
			if arg1_3 + iter1_3 == arg0_3 then
				return true
			end
		end
	elseif arg0_3 > 10000000 then
		for iter2_3 = 0, var0_3 - 1 do
			if arg1_3 * 10000000 + iter2_3 == arg0_3 then
				return true
			end
		end
	end

	return false
end

local function var4_0(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	for iter0_4, iter1_4 in ipairs(arg0_4) do
		if var3_0(iter1_4.parent, arg2_4, iter1_4.isNewStyle) and iter1_4:SameChildPosition(arg3_4, arg4_4) and var3_0(arg1_4, iter1_4.configId, iter1_4.isNewStyle) then
			return iter1_4
		end
	end
end

local function var5_0(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	for iter0_5, iter1_5 in ipairs(arg0_5) do
		if var3_0(iter1_5.parent, arg2_5, iter1_5.isNewStyle) and iter1_5:SameChildPosition(arg3_5, arg4_5) and var3_0(arg1_5, iter1_5.configId, true) then
			return iter1_5
		end
	end
end

function var0_0.GenFurnitures(arg0_6, arg1_6)
	local var0_6 = arg1_6.floor
	local var1_6 = arg1_6.mapSize
	local var2_6 = arg1_6.skipCheck
	local var3_6 = {}

	for iter0_6, iter1_6 in ipairs(arg1_6.furniture_put_list) do
		table.insert(var3_6, var2_0(iter1_6, var0_6))
	end

	for iter2_6, iter3_6 in ipairs(var3_6) do
		if iter3_6:AnyChild() then
			local var4_6 = {}

			for iter4_6, iter5_6 in pairs(iter3_6:GetChildList()) do
				local var5_6 = var4_0(var3_6, iter4_6, iter3_6.configId, iter3_6:GetPosition(), iter5_6)

				if var5_6 then
					var4_6[var1_0(iter4_6, var5_6.configId, var5_6.isNewStyle)] = iter5_6
				end
			end

			iter3_6:SetChildList(var4_6)
		end
	end

	local function var6_6(arg0_7)
		local var0_7 = {}

		for iter0_7, iter1_7 in pairs(arg0_7:GetChildList()) do
			local var1_7 = var5_0(var3_6, iter0_7, arg0_7.configId, arg0_7:GetPosition(), iter1_7)

			if var1_7 then
				var1_7:SetUniqueId(iter0_7)
				table.insert(var0_7, var1_7)
			end
		end

		return var0_7
	end

	local var7_6 = {}

	for iter6_6, iter7_6 in ipairs(var3_6) do
		if not iter7_6:HasParent() then
			table.insert(var7_6, iter7_6)
		end

		if iter7_6:AnyChild() then
			for iter8_6, iter9_6 in ipairs(var6_6(iter7_6)) do
				table.insert(var7_6, iter9_6)
			end
		end
	end

	local var8_6 = {}

	for iter10_6, iter11_6 in ipairs(var7_6) do
		if iter11_6:HasParent() then
			var8_6[iter11_6.id] = true
		end
	end

	for iter12_6, iter13_6 in ipairs(var7_6) do
		if not iter13_6:HasParent() then
			for iter14_6, iter15_6 in ipairs(iter13_6:GetAllUniqueId()) do
				if not var8_6[iter15_6] then
					iter13_6:SetUniqueId(iter15_6)

					var8_6[iter15_6] = true

					break
				end
			end
		end
	end

	local function var9_6(arg0_8, arg1_8, arg2_8)
		for iter0_8, iter1_8 in ipairs(arg0_8) do
			if iter1_8.id == arg1_8 then
				iter1_8:SetParent(arg2_8)

				break
			end
		end
	end

	for iter16_6, iter17_6 in ipairs(var7_6) do
		if iter17_6:AnyChild() then
			for iter18_6, iter19_6 in pairs(iter17_6:GetChildList()) do
				var9_6(var7_6, iter18_6, iter17_6.id)
			end
		end
	end

	local var10_6 = {}

	for iter20_6, iter21_6 in ipairs(var7_6) do
		var10_6[iter21_6.id] = iter21_6
	end

	if not var2_6 then
		arg0_6:CheckFurnitures(var10_6, var1_6)
	end

	return var10_6
end

function var0_0.CheckFurnitures(arg0_9, arg1_9, arg2_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg1_9) do
		local var1_9, var2_9 = CourtYardRawDataChecker.CheckFurnitrue(iter1_9, arg1_9, arg2_9)

		if not var1_9 then
			arg0_9:CollectionClearIdList(var0_9, iter1_9, arg1_9)
		end
	end

	if #var0_9 > 0 then
		for iter2_9, iter3_9 in ipairs(var0_9) do
			if arg1_9[iter3_9] then
				arg1_9[iter3_9] = nil
			end
		end

		arg0_9:CheckFurnitures(arg1_9, arg2_9)
	end
end

function var0_0.CollectionClearIdList(arg0_10, arg1_10, arg2_10, arg3_10)
	if arg2_10:AnyChild() then
		for iter0_10, iter1_10 in ipairs(arg2_10:GetChildIdList()) do
			CollectionClearIdList(arg1_10, arg3_10[iter1_10], arg3_10)
		end
	end

	table.insert(arg1_10, arg2_10.id)
end

return var0_0
