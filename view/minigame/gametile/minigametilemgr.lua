pg = pg or {}

local var0 = pg

var0.MiniGameTileMgr = singletonClass("MiniGameTileMgr")

local var1 = var0.MiniGameTileMgr

function var1.Ctor(arg0)
	arg0.tileDatas = {}
	arg0.tileDataDic = {}

	local var0 = MiniGameTile.tiles

	for iter0, iter1 in pairs(var0) do
		local var1 = MiniGameTileData.New(iter1)

		table.insert(arg0.tileDatas, var1)

		arg0.tileDataDic[iter0] = var1
	end
end

function var1.getData(arg0, arg1)
	return arg0.tileDataDic[arg1]
end

function var1.getDataLayers(arg0, arg1, arg2)
	local var0 = arg0:getData(arg1)

	if var0 then
		return var0:getTileDataLayer(arg2)
	end

	return nil
end

function var1.dumpDataLayers(arg0, arg1, arg2, arg3)
	local var0 = arg0:getData(arg1)

	if var0 then
		var0:dumpTileDataLayer(arg2, arg3)
	end
end
