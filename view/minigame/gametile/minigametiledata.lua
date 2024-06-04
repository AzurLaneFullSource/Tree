local var0 = class("MiniGameTileData")

local function var1(arg0)
	local var0 = {}
	local var1 = {}
	local var2 = {}
	local var3 = 1
	local var4 = "{\n"

	while true do
		local var5 = 0

		for iter0, iter1 in pairs(arg0) do
			var5 = var5 + 1
		end

		local var6 = 1

		for iter2, iter3 in pairs(arg0) do
			if var0[arg0] == nil or var6 >= var0[arg0] then
				if string.find(var4, "}", var4:len()) then
					var4 = var4 .. ",\n"
				elseif not string.find(var4, "\n", var4:len()) then
					var4 = var4 .. "\n"
				end

				table.insert(var2, var4)

				var4 = ""

				local var7

				if type(iter2) == "number" or type(iter2) == "boolean" then
					var7 = "[" .. tostring(iter2) .. "]"
				else
					var7 = "['" .. tostring(iter2) .. "']"
				end

				if type(iter3) == "number" or type(iter3) == "boolean" then
					var4 = var4 .. string.rep("\t", var3) .. var7 .. " = " .. tostring(iter3)
				elseif type(iter3) == "table" then
					var4 = var4 .. string.rep("\t", var3) .. var7 .. " = {\n"

					table.insert(var1, arg0)
					table.insert(var1, iter3)

					var0[arg0] = var6 + 1

					break
				else
					var4 = var4 .. string.rep("\t", var3) .. var7 .. " = '" .. tostring(iter3) .. "'"
				end

				if var6 == var5 then
					var4 = var4 .. "\n" .. string.rep("\t", var3 - 1) .. "}"
				else
					var4 = var4 .. ","
				end
			elseif var6 == var5 then
				var4 = var4 .. "\n" .. string.rep("\t", var3 - 1) .. "}"
			end

			var6 = var6 + 1
		end

		if var5 == 0 then
			var4 = var4 .. "\n" .. string.rep("\t", var3 - 1) .. "}"
		end

		if #var1 > 0 then
			arg0 = var1[#var1]
			var1[#var1] = nil
			var3 = var0[arg0] == nil and var3 + 1 or var3 - 1
		else
			break
		end
	end

	table.insert(var2, var4)

	local var8 = table.concat(var2)

	print(var8)
end

function var0.Ctor(arg0, arg1)
	arg0._data = arg1
	arg0._name = arg1.name
	arg0.tileMaps = arg1.tile_map
	arg0.tileDatas = arg1.tile_data
	arg0.tileMapDic = {}
	arg0.tileDataDic = {}

	arg0:initTile()
	arg0:initData()
end

function var0.loadTile(arg0, arg1, arg2)
	local var0 = "GameCfg.MiniGameTile." .. arg1 .. "." .. arg2
	local var1, var2 = pcall(function()
		return require(var0)
	end)

	if not var1 then
		errorMsg("不存在地图数据:" .. var0)
	end

	return var1 and var2
end

function var0.initTile(arg0)
	for iter0, iter1 in ipairs(arg0.tileMaps) do
		local var0 = arg0:loadTile(arg0._name, iter1)
		local var1 = var0.name
		local var2 = var0.tiles

		arg0.tileMapDic[var1] = arg0:createTile(var2)
	end
end

function var0.getTileDataLayer(arg0, arg1)
	if arg0.tileDataDic[arg1] then
		return arg0.tileDataDic[arg1].layers
	end

	return nil
end

function var0.dumpTileDataLayer(arg0, arg1, arg2)
	if arg0.tileDataDic[arg1] then
		local var0 = arg0.tileDataDic[arg1].layers

		for iter0 = 1, #var0 do
			local var1 = var0[iter0]

			if not arg2 or arg2 == var1.name then
				print(var1.name .. " = ")
				var1(var1)
			end
		end
	end
end

function var0.initData(arg0)
	for iter0, iter1 in ipairs(arg0.tileDatas) do
		local var0 = arg0:loadTile(arg0._name, iter1)

		arg0.tileDataDic[iter1] = arg0:createMapData(var0, iter1)
	end
end

function var0.createTile(arg0, arg1)
	local var0 = {}
	local var1 = {}

	for iter0 = 1, #arg1 do
		local var2 = arg1[iter0]
		local var3 = var2.id
		local var4 = var2.properties or {}
		local var5 = var2.image
		local var6

		for iter1 in string.gmatch(var2.image, "[^/]+$") do
			var6 = iter1
		end

		local var7 = string.gsub(var6, ".png", "")
		local var8 = string.gsub(var7, ".jpg", "")

		table.insert(var1, {
			id = var3,
			name = var8,
			properties = var4
		})
	end

	var0.maps = var1

	return var0
end

function var0.createMapData(arg0, arg1, arg2)
	if not arg1 then
		return {
			layer = {},
			tilesets = {}
		}
	end

	local var0 = arg1.tilesets
	local var1 = arg1.layers
	local var2 = arg1.width
	local var3 = arg1.height
	local var4 = {}

	for iter0, iter1 in ipairs(var1) do
		local var5 = iter1.name
		local var6 = iter1.data
		local var7 = arg0:createLayerData(var6, var0, arg2)

		table.insert(var4, {
			name = var5,
			layer = var7,
			width = var2,
			height = var3
		})
	end

	return {
		layers = var4,
		tilesets = var0
	}
end

function var0.createLayerData(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0 = 1, #arg1 do
		local var1 = arg1[iter0]
		local var2 = iter0
		local var3 = arg0:relationTile(var1, arg2, arg3, var2)

		if var3 and var1 ~= 0 then
			table.insert(var0, var3)
		end
	end

	return var0
end

function var0.relationTile(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}

	if arg0._name == MiniGameTile.BOOM_GAME then
		-- block empty
	elseif arg0._name == MiniGameTile.SPRING23_GAME then
		-- block empty
	else
		var0.id = arg1
	end

	var0.item = nil
	var0.drop = nil
	var0.index = arg4

	for iter0 = 1, #arg2 do
		local var1 = arg2[iter0]
		local var2 = var1.firstgid
		local var3 = var1.name
		local var4 = arg0.tileMapDic[var3]

		if var4 then
			local var5 = var4.maps

			if var2 <= arg1 then
				for iter1, iter2 in ipairs(var5) do
					if iter2.id + var2 == arg1 then
						local var6 = arg1
						local var7 = iter2.name
						local var8, var9 = arg0:createGridPropData(iter2.properties, iter2.name, arg3)

						var0.item = var7 or nil
						var0.prop = var8 or nil

						return var0
					end
				end
			end
		else
			print("警告 找不到" .. var3 .. "的贴图数据")
		end
	end

	return var0
end

function var0.createGridPropData(arg0, arg1, arg2, arg3)
	local var0 = {}
	local var1

	if arg0._name == MiniGameTile.BOOM_GAME then
		local var2 = arg1.drop_id
		local var3

		if var2 and var2 > 0 then
			var0.drop = MiniGameTile.drops[var2]
		else
			var0.drop = nil
		end

		if arg1.use_attr and arg1.use_attr ~= nil then
			local var4 = MiniGameTile.attrs[arg3][arg2]

			if var4 then
				for iter0, iter1 in pairs(var4) do
					var0[iter0] = iter1
				end
			end
		end
	elseif arg0._name == MiniGameTile.SPRING23_GAME then
		var0 = nil
	end

	return var0
end

function var0.getName(arg0)
	return arg0._name
end

return var0
