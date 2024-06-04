local var0 = class("TowerClimbingResMgr")
local var1 = {
	salatuojia = "TowerClimbingPlayer1"
}

local function var2(arg0)
	return var1[arg0]
end

function var0.GetBlock(arg0, arg1)
	PoolMgr.GetInstance():GetUI(arg0, true, function(arg0)
		arg1(arg0)
	end)
end

function var0.GetPlayer(arg0, arg1)
	local var0 = var2(arg0)

	assert(var0, arg0)
	PoolMgr.GetInstance():GetUI(var0, true, arg1)
end

function var0.GetGround(arg0, arg1)
	PoolMgr.GetInstance():GetUI(arg0, true, arg1)
end

function var0.ReturnBlock(arg0, arg1)
	PoolMgr.GetInstance():ReturnUI(arg0, arg1)
end

function var0.ReturnPlayer(arg0, arg1)
	local var0 = var2(arg0)

	assert(var0, arg0)
	PoolMgr.GetInstance():ReturnUI(var0, arg1)
end

function var0.ReturnGround(arg0, arg1)
	PoolMgr.GetInstance():ReturnUI(arg0, arg1)
end

return var0
