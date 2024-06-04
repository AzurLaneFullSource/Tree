ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattlePopNumManager

var0.Battle.BattlePopNumBundle = class("BattlePopNumBundle")
var0.Battle.BattlePopNumBundle.__name = "BattlePopNumBundle"

local var4 = var0.Battle.BattlePopNumBundle

var4.PRO = 0
var4.SLIM = 1

function var4.Ctor(arg0, arg1, arg2)
	arg0.pool = arg1
	arg0._container = cloneTplTo(arg2.containerTpl, arg2.containerTpl.parent)
	arg0._bundleType = arg2.type
	arg0._score = arg2.score

	arg0:init()
end

function var4.InitPopScore(arg0, arg1)
	arg0._allPool[var3.POP_SCORE] = arg0:generateTempPool(var3.POP_SCORE, arg0._container, arg1, 1)
end

function var4.GetContainer(arg0)
	return arg0._container
end

function var4.init(arg0)
	arg0._allPool = {}

	local var0 = var3.GetInstance():GetPopSkin()

	if arg0._score then
		arg0._allPool[var3.POP_SCORE] = arg0:generateTempPool(var3.POP_SCORE, arg0._container, var0, 1)
	else
		arg0._allPool[var3.POP_COMMON] = arg0:generateTempPool(var3.POP_COMMON, arg0._container, var0, 1)
		arg0._allPool[var3.POP_CT_EXPLO] = arg0:generateTempPool(var3.POP_CT_EXPLO, arg0._container, var0, 0)
		arg0._allPool[var3.POP_MISS] = arg0:generateTempPool(var3.POP_MISS, arg0._container, var0, 0)
		arg0._allPool[var3.POP_NORMAL] = arg0:generateTempPool(var3.POP_NORMAL, arg0._container, var0, 0)
		arg0._allPool[var3.POP_CT_NORMAL] = arg0:generateTempPool(var3.POP_CT_NORMAL, arg0._container, var0, 0)

		if arg0._bundleType == var4.PRO then
			arg0._allPool[var3.POP_UNBREAK] = arg0:generateTempPool(var3.POP_UNBREAK, arg0._container, var0, 1)
			arg0._allPool[var3.POP_HEAL] = arg0:generateTempPool(var3.POP_HEAL, arg0._container, var0, 1)
			arg0._allPool[var3.POP_EXPLO] = arg0:generateTempPool(var3.POP_EXPLO, arg0._container, var0, 0)
			arg0._allPool[var3.POP_PIERCE] = arg0:generateTempPool(var3.POP_PIERCE, arg0._container, var0, 0)
			arg0._allPool[var3.POP_CT_PIERCE] = arg0:generateTempPool(var3.POP_CT_PIERCE, arg0._container, var0, 0)
		end
	end
end

function var4.Clear(arg0)
	arg0.pool:Recycle(arg0)
end

function var4.GetPop(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0, var1 = var3.getType(arg1, arg2, arg3, arg5)
	local var2 = arg0._allPool[var0]:GetObject()

	if var0 ~= var3.POP_MISS then
		var2:SetText(arg4)
	end

	var2:SetScale(var1)

	return var2
end

function var4.GetScorePop(arg0, arg1)
	local var0 = arg0._allPool[var3.POP_SCORE]:GetObject()

	var0:SetText(arg1)

	return var0
end

function var4.generateTempPool(arg0, arg1, arg2, arg3, arg4)
	return pg.LuaObPool.New(var0.Battle.BattlePopNum, {
		template = arg3.transform:Find(arg1).gameObject,
		parentTF = arg2,
		mgr = arg0
	}, arg4)
end

function var4.Init(arg0)
	return
end

function var4.Recycle(arg0)
	return
end

function var4.IsScorePop(arg0)
	return arg0._score
end

function var4.Dispose(arg0)
	for iter0, iter1 in pairs(arg0._allPool) do
		iter1:Dispose()
	end

	arg0._allPool = nil

	Object.Destroy(arg0._container.gameObject)

	arg0._container = nil
end
