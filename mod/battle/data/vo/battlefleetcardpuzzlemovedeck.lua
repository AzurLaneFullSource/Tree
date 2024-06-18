ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent
local var4_0 = var0_0.Battle.BattleFormulas
local var5_0 = var0_0.Battle.BattleConst
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = var0_0.Battle.BattleCardPuzzleConfig
local var8_0 = var0_0.Battle.BattleAttr
local var9_0 = var0_0.Battle.BattleDataFunction
local var10_0 = var0_0.Battle.BattleAttr
local var11_0 = class("BattleFleetCardPuzzleMoveDeck")

var0_0.Battle.BattleFleetCardPuzzleMoveDeck = var11_0
var11_0.__name = "BattleFleetCardPuzzleMoveDeck"

function var11_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._cardPuzzleComponent = arg1_1
	arg0_1._indexID = arg2_1

	arg0_1:init()
end

function var11_0.CustomConfig(arg0_2, arg1_2)
	arg0_2._generateRate = var9_0.GetPuzzleDungeonTemplate(arg1_2).move_recovery
end

function var11_0.GetIndexID(arg0_3)
	return arg0_3._indexID
end

function var11_0.Dispose(arg0_4)
	return
end

function var11_0.GetCardList(arg0_5)
	return arg0_5._moveCardList
end

function var11_0.Update(arg0_6, arg1_6)
	arg0_6:update(arg1_6)
end

function var11_0.init(arg0_7)
	arg0_7._moveCardList = {}

	var0_0.EventDispatcher.AttachEventDispatcher(arg0_7)
	var0_0.Battle.BattleFleetCardPuzzleCardManageComponent.AttachCardManager(arg0_7)

	arg0_7._attrManager = arg0_7._cardPuzzleComponent:GetAttrManager()
	arg0_7._generateRate = var7_0.moveCardGenerateSpeedPerSecond
	arg0_7._maxMoveCard = var7_0.BASE_MAX_MOVE
	arg0_7._generating = 0

	arg0_7:updateTimeStamp()
end

function var11_0.updateTimeStamp(arg0_8)
	arg0_8._lastUpdateTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var11_0.update(arg0_9, arg1_9)
	if arg0_9:GetLength() < arg0_9._maxMoveCard + arg0_9._attrManager:GetCurrent("MoveExtra") then
		arg0_9._generating = (arg1_9 - arg0_9._lastUpdateTimeStamp) * arg0_9._generateRate + arg0_9._generating
	end

	arg0_9:updateTimeStamp()
end

function var11_0.GetGeneratePorcess(arg0_10)
	return arg0_10._generating
end

function var11_0.TryPlayTopMoveCard(arg0_11)
	local var0_11 = arg0_11:GetLength()

	if var0_11 > 0 then
		return arg0_11:GetCardList()[var0_11]
	end
end

function var11_0.RestartGenrate(arg0_12)
	arg0_12._generating = 0
end
