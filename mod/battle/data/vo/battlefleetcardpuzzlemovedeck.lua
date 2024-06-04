ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleCardPuzzleEvent
local var4 = var0.Battle.BattleFormulas
local var5 = var0.Battle.BattleConst
local var6 = var0.Battle.BattleConfig
local var7 = var0.Battle.BattleCardPuzzleConfig
local var8 = var0.Battle.BattleAttr
local var9 = var0.Battle.BattleDataFunction
local var10 = var0.Battle.BattleAttr
local var11 = class("BattleFleetCardPuzzleMoveDeck")

var0.Battle.BattleFleetCardPuzzleMoveDeck = var11
var11.__name = "BattleFleetCardPuzzleMoveDeck"

function var11.Ctor(arg0, arg1, arg2)
	arg0._cardPuzzleComponent = arg1
	arg0._indexID = arg2

	arg0:init()
end

function var11.CustomConfig(arg0, arg1)
	arg0._generateRate = var9.GetPuzzleDungeonTemplate(arg1).move_recovery
end

function var11.GetIndexID(arg0)
	return arg0._indexID
end

function var11.Dispose(arg0)
	return
end

function var11.GetCardList(arg0)
	return arg0._moveCardList
end

function var11.Update(arg0, arg1)
	arg0:update(arg1)
end

function var11.init(arg0)
	arg0._moveCardList = {}

	var0.EventDispatcher.AttachEventDispatcher(arg0)
	var0.Battle.BattleFleetCardPuzzleCardManageComponent.AttachCardManager(arg0)

	arg0._attrManager = arg0._cardPuzzleComponent:GetAttrManager()
	arg0._generateRate = var7.moveCardGenerateSpeedPerSecond
	arg0._maxMoveCard = var7.BASE_MAX_MOVE
	arg0._generating = 0

	arg0:updateTimeStamp()
end

function var11.updateTimeStamp(arg0)
	arg0._lastUpdateTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var11.update(arg0, arg1)
	if arg0:GetLength() < arg0._maxMoveCard + arg0._attrManager:GetCurrent("MoveExtra") then
		arg0._generating = (arg1 - arg0._lastUpdateTimeStamp) * arg0._generateRate + arg0._generating
	end

	arg0:updateTimeStamp()
end

function var11.GetGeneratePorcess(arg0)
	return arg0._generating
end

function var11.TryPlayTopMoveCard(arg0)
	local var0 = arg0:GetLength()

	if var0 > 0 then
		return arg0:GetCardList()[var0]
	end
end

function var11.RestartGenrate(arg0)
	arg0._generating = 0
end
