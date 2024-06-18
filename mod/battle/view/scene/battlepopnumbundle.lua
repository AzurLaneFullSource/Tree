ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattlePopNumManager

var0_0.Battle.BattlePopNumBundle = class("BattlePopNumBundle")
var0_0.Battle.BattlePopNumBundle.__name = "BattlePopNumBundle"

local var4_0 = var0_0.Battle.BattlePopNumBundle

var4_0.PRO = 0
var4_0.SLIM = 1

function var4_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.pool = arg1_1
	arg0_1._container = cloneTplTo(arg2_1.containerTpl, arg2_1.containerTpl.parent)
	arg0_1._bundleType = arg2_1.type
	arg0_1._score = arg2_1.score

	arg0_1:init()
end

function var4_0.InitPopScore(arg0_2, arg1_2)
	arg0_2._allPool[var3_0.POP_SCORE] = arg0_2:generateTempPool(var3_0.POP_SCORE, arg0_2._container, arg1_2, 1)
end

function var4_0.GetContainer(arg0_3)
	return arg0_3._container
end

function var4_0.init(arg0_4)
	arg0_4._allPool = {}

	local var0_4 = var3_0.GetInstance():GetPopSkin()

	if arg0_4._score then
		arg0_4._allPool[var3_0.POP_SCORE] = arg0_4:generateTempPool(var3_0.POP_SCORE, arg0_4._container, var0_4, 1)
	else
		arg0_4._allPool[var3_0.POP_COMMON] = arg0_4:generateTempPool(var3_0.POP_COMMON, arg0_4._container, var0_4, 1)
		arg0_4._allPool[var3_0.POP_CT_EXPLO] = arg0_4:generateTempPool(var3_0.POP_CT_EXPLO, arg0_4._container, var0_4, 0)
		arg0_4._allPool[var3_0.POP_MISS] = arg0_4:generateTempPool(var3_0.POP_MISS, arg0_4._container, var0_4, 0)
		arg0_4._allPool[var3_0.POP_NORMAL] = arg0_4:generateTempPool(var3_0.POP_NORMAL, arg0_4._container, var0_4, 0)
		arg0_4._allPool[var3_0.POP_CT_NORMAL] = arg0_4:generateTempPool(var3_0.POP_CT_NORMAL, arg0_4._container, var0_4, 0)

		if arg0_4._bundleType == var4_0.PRO then
			arg0_4._allPool[var3_0.POP_UNBREAK] = arg0_4:generateTempPool(var3_0.POP_UNBREAK, arg0_4._container, var0_4, 1)
			arg0_4._allPool[var3_0.POP_HEAL] = arg0_4:generateTempPool(var3_0.POP_HEAL, arg0_4._container, var0_4, 1)
			arg0_4._allPool[var3_0.POP_EXPLO] = arg0_4:generateTempPool(var3_0.POP_EXPLO, arg0_4._container, var0_4, 0)
			arg0_4._allPool[var3_0.POP_PIERCE] = arg0_4:generateTempPool(var3_0.POP_PIERCE, arg0_4._container, var0_4, 0)
			arg0_4._allPool[var3_0.POP_CT_PIERCE] = arg0_4:generateTempPool(var3_0.POP_CT_PIERCE, arg0_4._container, var0_4, 0)
		end
	end
end

function var4_0.Clear(arg0_5)
	arg0_5.pool:Recycle(arg0_5)
end

function var4_0.GetPop(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6, arg5_6)
	local var0_6, var1_6 = var3_0.getType(arg1_6, arg2_6, arg3_6, arg5_6)
	local var2_6 = arg0_6._allPool[var0_6]:GetObject()

	if var0_6 ~= var3_0.POP_MISS then
		var2_6:SetText(arg4_6)
	end

	var2_6:SetScale(var1_6)

	return var2_6
end

function var4_0.GetScorePop(arg0_7, arg1_7)
	local var0_7 = arg0_7._allPool[var3_0.POP_SCORE]:GetObject()

	var0_7:SetText(arg1_7)

	return var0_7
end

function var4_0.generateTempPool(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	return pg.LuaObPool.New(var0_0.Battle.BattlePopNum, {
		template = arg3_8.transform:Find(arg1_8).gameObject,
		parentTF = arg2_8,
		mgr = arg0_8
	}, arg4_8)
end

function var4_0.Init(arg0_9)
	return
end

function var4_0.Recycle(arg0_10)
	return
end

function var4_0.IsScorePop(arg0_11)
	return arg0_11._score
end

function var4_0.Dispose(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12._allPool) do
		iter1_12:Dispose()
	end

	arg0_12._allPool = nil

	Object.Destroy(arg0_12._container.gameObject)

	arg0_12._container = nil
end
