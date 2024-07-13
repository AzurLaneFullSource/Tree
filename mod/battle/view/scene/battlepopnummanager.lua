ys = ys or {}

local var0_0 = ys
local var1_0 = require("Mgr/Pool/PoolUtil")
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = singletonClass("BattlePopNumManager")

var0_0.Battle.BattlePopNumManager = var3_0
var3_0.__name = "BattlePopNumManager"
var3_0.CONTAINER_CHARACTER_HP = "HPTextCharacterContainer"
var3_0.POP_SCORE = "score"
var3_0.POP_MISS = "miss"
var3_0.POP_HEAL = "heal"
var3_0.POP_COMMON = "common"
var3_0.POP_UNBREAK = "unbreak"
var3_0.POP_NORMAL = "normal"
var3_0.POP_EXPLO = "explo"
var3_0.POP_PIERCE = "pierce"
var3_0.POP_CT_NORMAL = "critical_normal"
var3_0.POP_CT_EXPLO = "critical_explo"
var3_0.POP_CT_PIERCE = "critical_pierce"
var3_0.FontIndex = {
	var3_0.POP_NORMAL,
	var3_0.POP_PIERCE,
	var3_0.POP_EXPLO,
	var3_0.POP_UNBREAK
}
var3_0.CTFontIndex = {
	var3_0.POP_CT_NORMAL,
	var3_0.POP_CT_PIERCE,
	var3_0.POP_CT_EXPLO,
	var3_0.POP_UNBREAK
}
var3_0.AIR_UNIT_TYPE = {
	var2_0.UnitType.AIRCRAFT_UNIT,
	var2_0.UnitType.AIRFIGHTER_UNIT,
	var2_0.UnitType.FUNNEL_UNIT,
	var2_0.UnitType.UAV_UNIT
}

function var3_0.Ctor(arg0_1)
	return
end

function var3_0.Init(arg0_2, arg1_2)
	arg0_2._allBundlePool = {}
	arg0_2._activeList = {}
	arg0_2._popSkin = arg1_2
end

function var3_0.GetPopSkin(arg0_3)
	return arg0_3._popSkin
end

function var3_0.InitialBundlePool(arg0_4, arg1_4)
	arg0_4._allBundlePool[var0_0.Battle.BattlePopNumBundle.PRO] = pg.LuaObPool.New(var0_0.Battle.BattlePopNumBundle, {
		containerTpl = arg1_4,
		type = var0_0.Battle.BattlePopNumBundle.PRO
	}, 6)
	arg0_4._allBundlePool[var0_0.Battle.BattlePopNumBundle.SLIM] = pg.LuaObPool.New(var0_0.Battle.BattlePopNumBundle, {
		containerTpl = arg1_4,
		type = var0_0.Battle.BattlePopNumBundle.SLIM
	}, 4)
end

function var3_0.InitialScorePool(arg0_5, arg1_5)
	arg0_5._allBundlePool[var0_0.Battle.BattlePopNumBundle.PRO] = pg.LuaObPool.New(var0_0.Battle.BattlePopNumBundle, {
		score = true,
		containerTpl = arg1_5,
		type = var0_0.Battle.BattlePopNumBundle.PRO
	}, 1)
	arg0_5._allBundlePool[var0_0.Battle.BattlePopNumBundle.SLIM] = pg.LuaObPool.New(var0_0.Battle.BattlePopNumBundle, {
		score = true,
		containerTpl = arg1_5,
		type = var0_0.Battle.BattlePopNumBundle.SLIM
	}, 2)
end

function var3_0.Clear(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6._allBundlePool) do
		iter1_6:Dispose()
	end

	arg0_6._popSkin = nil
	arg0_6._activeList = {}
end

function var3_0.GetBundle(arg0_7, arg1_7)
	local var0_7 = var3_0.getBundleType(arg1_7)

	return (arg0_7._allBundlePool[var0_7]:GetObject())
end

function var3_0.getType(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = 1
	local var1_8

	if arg0_8 and not arg2_8 then
		var1_8 = var3_0.POP_HEAL
	elseif arg2_8 then
		var1_8 = var3_0.POP_MISS
	elseif arg3_8 then
		local var2_8 = arg3_8[1]
		local var3_8 = arg3_8[2]

		if arg1_8 then
			var1_8 = var3_0.CTFontIndex[var2_8]
		else
			var1_8 = var3_0.FontIndex[var2_8]
		end

		var0_8 = arg3_8[2]
	elseif arg1_8 then
		var1_8 = var3_0.POP_CT_EXPLO
	else
		var1_8 = var3_0.POP_COMMON
	end

	return var1_8, var0_8
end

function var3_0.getBundleType(arg0_9)
	local var0_9

	if table.contains(var3_0.AIR_UNIT_TYPE, arg0_9) then
		var0_9 = var0_0.Battle.BattlePopNumBundle.SLIM
	else
		var0_9 = var0_0.Battle.BattlePopNumBundle.PRO
	end

	return var0_9
end

function var3_0.generateTempPool(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	return pg.LuaObPool.New(var0_0.Battle.BattlePopNum, {
		template = arg3_10.transform:Find(arg1_10).gameObject,
		parentTF = arg2_10,
		mgr = arg0_10
	}, arg4_10)
end

function var3_0.resetPopParent(arg0_11, arg1_11, arg2_11)
	arg1_11:UpdateInfo("parentTF", arg2_11)

	for iter0_11, iter1_11 in ipairs(arg1_11.list) do
		iter1_11:SetParent(arg2_11)
	end
end
