ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent
local var4_0 = var0_0.Battle.BattleFormulas
local var5_0 = var0_0.Battle.BattleConst
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = var0_0.Battle.BattleAttr
local var8_0 = var0_0.Battle.BattleDataFunction
local var9_0 = var0_0.Battle.BattleAttr
local var10_0 = class("BattleFleetCardPuzzleDiscard")

var0_0.Battle.BattleFleetCardPuzzleDiscard = var10_0
var10_0.__name = "BattleFleetCardPuzzleDiscard"

function var10_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._cardPuzzleComponent = arg1_1
	arg0_1._indexID = arg2_1

	arg0_1:init()
end

function var10_0.GetIndexID(arg0_2)
	return arg0_2._indexID
end

function var10_0.Dispose(arg0_3)
	return
end

function var10_0.GetCardList(arg0_4)
	return arg0_4._discardList
end

function var10_0.init(arg0_5)
	arg0_5._discardList = {}

	var0_0.EventDispatcher.AttachEventDispatcher(arg0_5)
	var0_0.Battle.BattleFleetCardPuzzleCardManageComponent.AttachCardManager(arg0_5)
end
