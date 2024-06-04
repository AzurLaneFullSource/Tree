ys = ys or {}

local var0 = ys
local var1 = require("Mgr/Pool/PoolUtil")
local var2 = var0.Battle.BattleConst
local var3 = singletonClass("BattlePopNumManager")

var0.Battle.BattlePopNumManager = var3
var3.__name = "BattlePopNumManager"
var3.CONTAINER_CHARACTER_HP = "HPTextCharacterContainer"
var3.POP_SCORE = "score"
var3.POP_MISS = "miss"
var3.POP_HEAL = "heal"
var3.POP_COMMON = "common"
var3.POP_UNBREAK = "unbreak"
var3.POP_NORMAL = "normal"
var3.POP_EXPLO = "explo"
var3.POP_PIERCE = "pierce"
var3.POP_CT_NORMAL = "critical_normal"
var3.POP_CT_EXPLO = "critical_explo"
var3.POP_CT_PIERCE = "critical_pierce"
var3.FontIndex = {
	var3.POP_NORMAL,
	var3.POP_PIERCE,
	var3.POP_EXPLO,
	var3.POP_UNBREAK
}
var3.CTFontIndex = {
	var3.POP_CT_NORMAL,
	var3.POP_CT_PIERCE,
	var3.POP_CT_EXPLO,
	var3.POP_UNBREAK
}
var3.AIR_UNIT_TYPE = {
	var2.UnitType.AIRCRAFT_UNIT,
	var2.UnitType.AIRFIGHTER_UNIT,
	var2.UnitType.FUNNEL_UNIT,
	var2.UnitType.UAV_UNIT
}

function var3.Ctor(arg0)
	return
end

function var3.Init(arg0, arg1)
	arg0._allBundlePool = {}
	arg0._activeList = {}
	arg0._popSkin = arg1
end

function var3.GetPopSkin(arg0)
	return arg0._popSkin
end

function var3.InitialBundlePool(arg0, arg1)
	arg0._allBundlePool[var0.Battle.BattlePopNumBundle.PRO] = pg.LuaObPool.New(var0.Battle.BattlePopNumBundle, {
		containerTpl = arg1,
		type = var0.Battle.BattlePopNumBundle.PRO
	}, 6)
	arg0._allBundlePool[var0.Battle.BattlePopNumBundle.SLIM] = pg.LuaObPool.New(var0.Battle.BattlePopNumBundle, {
		containerTpl = arg1,
		type = var0.Battle.BattlePopNumBundle.SLIM
	}, 4)
end

function var3.InitialScorePool(arg0, arg1)
	arg0._allBundlePool[var0.Battle.BattlePopNumBundle.PRO] = pg.LuaObPool.New(var0.Battle.BattlePopNumBundle, {
		score = true,
		containerTpl = arg1,
		type = var0.Battle.BattlePopNumBundle.PRO
	}, 1)
	arg0._allBundlePool[var0.Battle.BattlePopNumBundle.SLIM] = pg.LuaObPool.New(var0.Battle.BattlePopNumBundle, {
		score = true,
		containerTpl = arg1,
		type = var0.Battle.BattlePopNumBundle.SLIM
	}, 2)
end

function var3.Clear(arg0)
	for iter0, iter1 in pairs(arg0._allBundlePool) do
		iter1:Dispose()
	end

	arg0._popSkin = nil
	arg0._activeList = {}
end

function var3.GetBundle(arg0, arg1)
	local var0 = var3.getBundleType(arg1)

	return (arg0._allBundlePool[var0]:GetObject())
end

function var3.getType(arg0, arg1, arg2, arg3)
	local var0 = 1
	local var1

	if arg0 and not arg2 then
		var1 = var3.POP_HEAL
	elseif arg2 then
		var1 = var3.POP_MISS
	elseif arg3 then
		local var2 = arg3[1]
		local var3 = arg3[2]

		if arg1 then
			var1 = var3.CTFontIndex[var2]
		else
			var1 = var3.FontIndex[var2]
		end

		var0 = arg3[2]
	elseif arg1 then
		var1 = var3.POP_CT_EXPLO
	else
		var1 = var3.POP_COMMON
	end

	return var1, var0
end

function var3.getBundleType(arg0)
	local var0

	if table.contains(var3.AIR_UNIT_TYPE, arg0) then
		var0 = var0.Battle.BattlePopNumBundle.SLIM
	else
		var0 = var0.Battle.BattlePopNumBundle.PRO
	end

	return var0
end

function var3.generateTempPool(arg0, arg1, arg2, arg3, arg4)
	return pg.LuaObPool.New(var0.Battle.BattlePopNum, {
		template = arg3.transform:Find(arg1).gameObject,
		parentTF = arg2,
		mgr = arg0
	}, arg4)
end

function var3.resetPopParent(arg0, arg1, arg2)
	arg1:UpdateInfo("parentTF", arg2)

	for iter0, iter1 in ipairs(arg1.list) do
		iter1:SetParent(arg2)
	end
end
