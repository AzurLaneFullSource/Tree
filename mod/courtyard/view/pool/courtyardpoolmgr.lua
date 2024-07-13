local var0_0 = class("CourtYardPoolMgr")

function var0_0.Init(arg0_1, arg1_1, arg2_1)
	arg0_1.pools = {}
	arg0_1.root = arg1_1

	local var0_1 = arg0_1:GenPool(arg1_1)

	parallelAsync(var0_1, arg2_1)
end

function var0_0.GenPool(arg0_2, arg1_2)
	local var0_2 = {
		"CourtYardFurniture",
		"CourtYardGrid",
		"CourtYardShip",
		"CourtYardWallGrid"
	}
	local var1_2 = {
		{
			10,
			15
		},
		{
			4,
			8
		},
		{
			1,
			3
		},
		{
			2,
			8
		}
	}
	local var2_2 = {
		"Heart"
	}
	local var3_2 = {}

	for iter0_2, iter1_2 in ipairs(var0_2) do
		table.insert(var3_2, function(arg0_3)
			ResourceMgr.Inst:getAssetAsync("ui/" .. iter1_2, "", typeof(Object), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_4)
				if arg0_2.exited then
					return
				end

				local var0_4 = var1_2[iter0_2]

				arg0_2.pools[iter1_2] = CourtYardPool.New(arg1_2, arg0_4, unpack(var0_4))

				arg0_3()
			end), true, true)
		end)
	end

	for iter2_2, iter3_2 in ipairs(var2_2) do
		table.insert(var3_2, function(arg0_5)
			ResourceMgr.Inst:getAssetAsync("Effect/" .. iter3_2, "", typeof(Object), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_6)
				if arg0_2.exited then
					return
				end

				if arg0_6 then
					arg0_2.pools[iter3_2] = CourtYardEffectPool.New(arg1_2, arg0_6, 0, 3)
				end

				arg0_5()
			end), true, true)
		end)
	end

	return var3_2
end

function var0_0.LoadAsset(arg0_7, arg1_7, arg2_7)
	return
end

function var0_0.GetFurniturePool(arg0_8)
	return arg0_8.pools.CourtYardFurniture
end

function var0_0.GetShipPool(arg0_9)
	return arg0_9.pools.CourtYardShip
end

function var0_0.GetGridPool(arg0_10)
	return arg0_10.pools.CourtYardGrid
end

function var0_0.GetWallGridPool(arg0_11)
	return arg0_11.pools.CourtYardWallGrid
end

function var0_0.GetHeartPool(arg0_12)
	return arg0_12.pools.Heart
end

function var0_0.GetAiXinPool(arg0_13)
	return arg0_13.pools.chengbao_aixin
end

function var0_0.GetXinXinPool(arg0_14)
	return arg0_14.pools.chengbao_xinxin
end

function var0_0.GetYinFuPool(arg0_15)
	return arg0_15.pools.chengbao_yinfu
end

function var0_0.GetZzzPool(arg0_16)
	return arg0_16.pools.chengbao_ZZZ
end

function var0_0.Dispose(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.pools or {}) do
		iter1_17:Dispose()
	end

	arg0_17.pools = nil
	arg0_17.exited = true
end

return var0_0
