pg = pg or {}

local var0_0 = pg

var0_0.MiniGameTileMgr = singletonClass("MiniGameTileMgr")

local var1_0 = var0_0.MiniGameTileMgr

function var1_0.Ctor(arg0_1)
	arg0_1.tileDatas = {}
	arg0_1.tileDataDic = {}

	local var0_1 = MiniGameTile.tiles

	for iter0_1, iter1_1 in pairs(var0_1) do
		local var1_1 = MiniGameTileData.New(iter1_1)

		table.insert(arg0_1.tileDatas, var1_1)

		arg0_1.tileDataDic[iter0_1] = var1_1
	end
end

function var1_0.getData(arg0_2, arg1_2)
	return arg0_2.tileDataDic[arg1_2]
end

function var1_0.getDataLayers(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:getData(arg1_3)

	if var0_3 then
		return var0_3:getTileDataLayer(arg2_3)
	end

	return nil
end

function var1_0.dumpDataLayers(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg0_4:getData(arg1_4)

	if var0_4 then
		var0_4:dumpTileDataLayer(arg2_4, arg3_4)
	end
end
