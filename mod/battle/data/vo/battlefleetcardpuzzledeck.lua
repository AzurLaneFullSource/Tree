ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleCardPuzzleEvent
local var4 = var0.Battle.BattleFormulas
local var5 = var0.Battle.BattleConst
local var6 = var0.Battle.BattleConfig
local var7 = var0.Battle.BattleAttr
local var8 = var0.Battle.BattleDataFunction
local var9 = var0.Battle.BattleAttr
local var10 = class("BattleFleetCardPuzzleDeck")

var0.Battle.BattleFleetCardPuzzleDeck = var10
var10.__name = "BattleFleetCardPuzzleDeck"
var10.OP_ADD_TO = "add"
var10.OP_SHUFFLE_TO = "shuffle"
var10.NOT_INIT_SHUFFLE = 0

function var10.Ctor(arg0, arg1, arg2)
	arg0._cardPuzzleComponent = arg1
	arg0._indexID = arg2

	arg0:init()
end

function var10.GetIndexID(arg0)
	return arg0._indexID
end

function var10.Dispose(arg0)
	return
end

function var10.GetCardList(arg0)
	return arg0._cardList
end

function var10.init(arg0)
	arg0._cardList = {}

	var0.EventDispatcher.AttachEventDispatcher(arg0)
	var0.Battle.BattleFleetCardPuzzleCardManageComponent.AttachCardManager(arg0)
end
