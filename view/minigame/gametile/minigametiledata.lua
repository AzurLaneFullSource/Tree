local var0_0 = class("MiniGameTileData")

local function var1_0(arg0_1)
	local var0_1 = {}
	local var1_1 = {}
	local var2_1 = {}
	local var3_1 = 1
	local var4_1 = "{\n"

	while true do
		local var5_1 = 0

		for iter0_1, iter1_1 in pairs(arg0_1) do
			var5_1 = var5_1 + 1
		end

		local var6_1 = 1

		for iter2_1, iter3_1 in pairs(arg0_1) do
			if var0_1[arg0_1] == nil or var6_1 >= var0_1[arg0_1] then
				if string.find(var4_1, "}", var4_1:len()) then
					var4_1 = var4_1 .. ",\n"
				elseif not string.find(var4_1, "\n", var4_1:len()) then
					var4_1 = var4_1 .. "\n"
				end

				table.insert(var2_1, var4_1)

				var4_1 = ""

				local var7_1

				if type(iter2_1) == "number" or type(iter2_1) == "boolean" then
					var7_1 = "[" .. tostring(iter2_1) .. "]"
				else
					var7_1 = "['" .. tostring(iter2_1) .. "']"
				end

				if type(iter3_1) == "number" or type(iter3_1) == "boolean" then
					var4_1 = var4_1 .. string.rep("\t", var3_1) .. var7_1 .. " = " .. tostring(iter3_1)
				elseif type(iter3_1) == "table" then
					var4_1 = var4_1 .. string.rep("\t", var3_1) .. var7_1 .. " = {\n"

					table.insert(var1_1, arg0_1)
					table.insert(var1_1, iter3_1)

					var0_1[arg0_1] = var6_1 + 1

					break
				else
					var4_1 = var4_1 .. string.rep("\t", var3_1) .. var7_1 .. " = '" .. tostring(iter3_1) .. "'"
				end

				if var6_1 == var5_1 then
					var4_1 = var4_1 .. "\n" .. string.rep("\t", var3_1 - 1) .. "}"
				else
					var4_1 = var4_1 .. ","
				end
			elseif var6_1 == var5_1 then
				var4_1 = var4_1 .. "\n" .. string.rep("\t", var3_1 - 1) .. "}"
			end

			var6_1 = var6_1 + 1
		end

		if var5_1 == 0 then
			var4_1 = var4_1 .. "\n" .. string.rep("\t", var3_1 - 1) .. "}"
		end

		if #var1_1 > 0 then
			arg0_1 = var1_1[#var1_1]
			var1_1[#var1_1] = nil
			var3_1 = var0_1[arg0_1] == nil and var3_1 + 1 or var3_1 - 1
		else
			break
		end
	end

	table.insert(var2_1, var4_1)

	local var8_1 = table.concat(var2_1)

	print(var8_1)
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2._data = arg1_2
	arg0_2._name = arg1_2.name
	arg0_2.tileMaps = arg1_2.tile_map
	arg0_2.tileDatas = arg1_2.tile_data
	arg0_2.tileMapDic = {}
	arg0_2.tileDataDic = {}

	arg0_2:initTile()
	arg0_2:initData()
end

function var0_0.loadTile(arg0_3, arg1_3, arg2_3)
	local var0_3 = "GameCfg.MiniGameTile." .. arg1_3 .. "." .. arg2_3
	local var1_3, var2_3 = pcall(function()
		return require(var0_3)
	end)

	if not var1_3 then
		errorMsg("不存在地图数据:" .. var0_3)
	end

	return var1_3 and var2_3
end

function var0_0.initTile(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.tileMaps) do
		local var0_5 = arg0_5:loadTile(arg0_5._name, iter1_5)
		local var1_5 = var0_5.name
		local var2_5 = var0_5.tiles

		arg0_5.tileMapDic[var1_5] = arg0_5:createTile(var2_5)
	end
end

function var0_0.getTileDataLayer(arg0_6, arg1_6)
	if arg0_6.tileDataDic[arg1_6] then
		return arg0_6.tileDataDic[arg1_6].layers
	end

	return nil
end

function var0_0.dumpTileDataLayer(arg0_7, arg1_7, arg2_7)
	if arg0_7.tileDataDic[arg1_7] then
		local var0_7 = arg0_7.tileDataDic[arg1_7].layers

		for iter0_7 = 1, #var0_7 do
			local var1_7 = var0_7[iter0_7]

			if not arg2_7 or arg2_7 == var1_7.name then
				print(var1_7.name .. " = ")
				var1_0(var1_7)
			end
		end
	end
end

function var0_0.initData(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.tileDatas) do
		local var0_8 = arg0_8:loadTile(arg0_8._name, iter1_8)

		arg0_8.tileDataDic[iter1_8] = arg0_8:createMapData(var0_8, iter1_8)
	end
end

function var0_0.createTile(arg0_9, arg1_9)
	local var0_9 = {}
	local var1_9 = {}

	for iter0_9 = 1, #arg1_9 do
		local var2_9 = arg1_9[iter0_9]
		local var3_9 = var2_9.id
		local var4_9 = var2_9.properties or {}
		local var5_9 = var2_9.image
		local var6_9

		for iter1_9 in string.gmatch(var2_9.image, "[^/]+$") do
			var6_9 = iter1_9
		end

		local var7_9 = string.gsub(var6_9, ".png", "")
		local var8_9 = string.gsub(var7_9, ".jpg", "")

		table.insert(var1_9, {
			id = var3_9,
			name = var8_9,
			properties = var4_9
		})
	end

	var0_9.maps = var1_9

	return var0_9
end

function var0_0.createMapData(arg0_10, arg1_10, arg2_10)
	if not arg1_10 then
		return {
			layer = {},
			tilesets = {}
		}
	end

	local var0_10 = arg1_10.tilesets
	local var1_10 = arg1_10.layers
	local var2_10 = arg1_10.width
	local var3_10 = arg1_10.height
	local var4_10 = {}

	for iter0_10, iter1_10 in ipairs(var1_10) do
		local var5_10 = iter1_10.name
		local var6_10 = iter1_10.data
		local var7_10 = arg0_10:createLayerData(var6_10, var0_10, arg2_10)

		table.insert(var4_10, {
			name = var5_10,
			layer = var7_10,
			width = var2_10,
			height = var3_10
		})
	end

	return {
		layers = var4_10,
		tilesets = var0_10
	}
end

function var0_0.createLayerData(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = {}

	for iter0_11 = 1, #arg1_11 do
		local var1_11 = arg1_11[iter0_11]
		local var2_11 = iter0_11
		local var3_11 = arg0_11:relationTile(var1_11, arg2_11, arg3_11, var2_11)

		if var3_11 and var1_11 ~= 0 then
			table.insert(var0_11, var3_11)
		end
	end

	return var0_11
end

function var0_0.relationTile(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	local var0_12 = {}

	if arg0_12._name == MiniGameTile.BOOM_GAME then
		-- block empty
	elseif arg0_12._name == MiniGameTile.SPRING23_GAME then
		-- block empty
	else
		var0_12.id = arg1_12
	end

	var0_12.item = nil
	var0_12.drop = nil
	var0_12.index = arg4_12

	for iter0_12 = 1, #arg2_12 do
		local var1_12 = arg2_12[iter0_12]
		local var2_12 = var1_12.firstgid
		local var3_12 = var1_12.name
		local var4_12 = arg0_12.tileMapDic[var3_12]

		if var4_12 then
			local var5_12 = var4_12.maps

			if var2_12 <= arg1_12 then
				for iter1_12, iter2_12 in ipairs(var5_12) do
					if iter2_12.id + var2_12 == arg1_12 then
						local var6_12 = arg1_12
						local var7_12 = iter2_12.name
						local var8_12, var9_12 = arg0_12:createGridPropData(iter2_12.properties, iter2_12.name, arg3_12)

						var0_12.item = var7_12 or nil
						var0_12.prop = var8_12 or nil

						return var0_12
					end
				end
			end
		else
			print("警告 找不到" .. var3_12 .. "的贴图数据")
		end
	end

	return var0_12
end

function var0_0.createGridPropData(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = {}
	local var1_13

	if arg0_13._name == MiniGameTile.BOOM_GAME then
		local var2_13 = arg1_13.drop_id
		local var3_13

		if var2_13 and var2_13 > 0 then
			var0_13.drop = MiniGameTile.drops[var2_13]
		else
			var0_13.drop = nil
		end

		if arg1_13.use_attr and arg1_13.use_attr ~= nil then
			local var4_13 = MiniGameTile.attrs[arg3_13][arg2_13]

			if var4_13 then
				for iter0_13, iter1_13 in pairs(var4_13) do
					var0_13[iter0_13] = iter1_13
				end
			end
		end
	elseif arg0_13._name == MiniGameTile.SPRING23_GAME then
		var0_13 = nil
	end

	return var0_13
end

function var0_0.getName(arg0_14)
	return arg0_14._name
end

return var0_0
