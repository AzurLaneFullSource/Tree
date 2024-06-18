local var0_0 = class("TowerClimbingResMgr")
local var1_0 = {
	salatuojia = "TowerClimbingPlayer1"
}

local function var2_0(arg0_1)
	return var1_0[arg0_1]
end

function var0_0.GetBlock(arg0_2, arg1_2)
	PoolMgr.GetInstance():GetUI(arg0_2, true, function(arg0_3)
		arg1_2(arg0_3)
	end)
end

function var0_0.GetPlayer(arg0_4, arg1_4)
	local var0_4 = var2_0(arg0_4)

	assert(var0_4, arg0_4)
	PoolMgr.GetInstance():GetUI(var0_4, true, arg1_4)
end

function var0_0.GetGround(arg0_5, arg1_5)
	PoolMgr.GetInstance():GetUI(arg0_5, true, arg1_5)
end

function var0_0.ReturnBlock(arg0_6, arg1_6)
	PoolMgr.GetInstance():ReturnUI(arg0_6, arg1_6)
end

function var0_0.ReturnPlayer(arg0_7, arg1_7)
	local var0_7 = var2_0(arg0_7)

	assert(var0_7, arg0_7)
	PoolMgr.GetInstance():ReturnUI(var0_7, arg1_7)
end

function var0_0.ReturnGround(arg0_8, arg1_8)
	PoolMgr.GetInstance():ReturnUI(arg0_8, arg1_8)
end

return var0_0
