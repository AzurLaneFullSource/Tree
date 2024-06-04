local var0 = class("CourtYardPoolMgr")

function var0.Init(arg0, arg1, arg2)
	arg0.pools = {}
	arg0.root = arg1

	local var0 = arg0:GenPool(arg1)

	parallelAsync(var0, arg2)
end

function var0.GenPool(arg0, arg1)
	local var0 = {
		"CourtYardFurniture",
		"CourtYardGrid",
		"CourtYardShip",
		"CourtYardWallGrid"
	}
	local var1 = {
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
	local var2 = {
		"Heart"
	}
	local var3 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var3, function(arg0)
			ResourceMgr.Inst:getAssetAsync("ui/" .. iter1, "", typeof(Object), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0.exited then
					return
				end

				local var0 = var1[iter0]

				arg0.pools[iter1] = CourtYardPool.New(arg1, arg0, unpack(var0))

				arg0()
			end), true, true)
		end)
	end

	for iter2, iter3 in ipairs(var2) do
		table.insert(var3, function(arg0)
			ResourceMgr.Inst:getAssetAsync("Effect/" .. iter3, "", typeof(Object), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0.exited then
					return
				end

				if arg0 then
					arg0.pools[iter3] = CourtYardEffectPool.New(arg1, arg0, 0, 3)
				end

				arg0()
			end), true, true)
		end)
	end

	return var3
end

function var0.LoadAsset(arg0, arg1, arg2)
	return
end

function var0.GetFurniturePool(arg0)
	return arg0.pools.CourtYardFurniture
end

function var0.GetShipPool(arg0)
	return arg0.pools.CourtYardShip
end

function var0.GetGridPool(arg0)
	return arg0.pools.CourtYardGrid
end

function var0.GetWallGridPool(arg0)
	return arg0.pools.CourtYardWallGrid
end

function var0.GetHeartPool(arg0)
	return arg0.pools.Heart
end

function var0.GetAiXinPool(arg0)
	return arg0.pools.chengbao_aixin
end

function var0.GetXinXinPool(arg0)
	return arg0.pools.chengbao_xinxin
end

function var0.GetYinFuPool(arg0)
	return arg0.pools.chengbao_yinfu
end

function var0.GetZzzPool(arg0)
	return arg0.pools.chengbao_ZZZ
end

function var0.Dispose(arg0)
	for iter0, iter1 in pairs(arg0.pools or {}) do
		iter1:Dispose()
	end

	arg0.pools = nil
	arg0.exited = true
end

return var0
