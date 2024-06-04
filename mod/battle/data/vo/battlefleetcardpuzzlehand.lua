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
local var11 = var0.Battle.BattleFleetCardPuzzleCardManageComponent
local var12 = class("BattleFleetCardPuzzleHand")

var0.Battle.BattleFleetCardPuzzleHand = var12
var12.__name = "BattleFleetCardPuzzleHand"

function var12.Ctor(arg0, arg1, arg2)
	arg0._cardPuzzleComponent = arg1
	arg0._indexID = arg2

	arg0:init()
end

function var12.GetIndexID(arg0)
	return arg0._indexID
end

function var12.EnterCoolDownByType(arg0, arg1, arg2)
	if arg2 > 0 then
		local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

		arg0._typeCDTimeStampList[arg1] = var0 + arg2

		local var1 = {
			total = true,
			value = arg1,
			type = var11.SEARCH_BY_TYPE
		}
		local var2 = arg0:Search(var1)

		for iter0, iter1 in ipairs(var2) do
			iter1:SetOverHeatDuration(arg2)
		end
	end
end

function var12.Add(arg0, arg1)
	local var0 = arg1:GetCardType()
	local var1 = arg0._typeCDTimeStampList[var0]

	if var1 ~= -1 then
		local var2 = var1 - pg.TimeMgr.GetInstance():GetCombatTime()

		arg1:SetOverHeatDuration(var2)
	end
end

function var12.Update(arg0, arg1)
	for iter0, iter1 in pairs(arg0._typeCDTimeStampList) do
		if iter1 < arg1 then
			arg0._typeCDTimeStampList[iter0] = -1
		end
	end
end

function var12.Dispose(arg0)
	return
end

function var12.GetCardList(arg0)
	return arg0._handCardList
end

function var12.IsFull(arg0)
	return arg0:GetLength() >= var7.BASE_MAX_HAND + arg0._attrManager:GetCurrent("HandExtra")
end

function var12.init(arg0)
	arg0._handCardList = {}

	var0.EventDispatcher.AttachEventDispatcher(arg0)
	var0.Battle.BattleFleetCardPuzzleCardManageComponent.AttachCardManager(arg0)

	arg0._attrManager = arg0._cardPuzzleComponent:GetAttrManager()
	arg0._typeCDTimeStampList = {}

	for iter0, iter1 in pairs(CardPuzzleCard.CARD_TYPE) do
		arg0._typeCDTimeStampList[iter1] = -1
	end
end
