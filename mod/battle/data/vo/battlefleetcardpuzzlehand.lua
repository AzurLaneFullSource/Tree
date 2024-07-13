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
local var11_0 = var0_0.Battle.BattleFleetCardPuzzleCardManageComponent
local var12_0 = class("BattleFleetCardPuzzleHand")

var0_0.Battle.BattleFleetCardPuzzleHand = var12_0
var12_0.__name = "BattleFleetCardPuzzleHand"

function var12_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._cardPuzzleComponent = arg1_1
	arg0_1._indexID = arg2_1

	arg0_1:init()
end

function var12_0.GetIndexID(arg0_2)
	return arg0_2._indexID
end

function var12_0.EnterCoolDownByType(arg0_3, arg1_3, arg2_3)
	if arg2_3 > 0 then
		local var0_3 = pg.TimeMgr.GetInstance():GetCombatTime()

		arg0_3._typeCDTimeStampList[arg1_3] = var0_3 + arg2_3

		local var1_3 = {
			total = true,
			value = arg1_3,
			type = var11_0.SEARCH_BY_TYPE
		}
		local var2_3 = arg0_3:Search(var1_3)

		for iter0_3, iter1_3 in ipairs(var2_3) do
			iter1_3:SetOverHeatDuration(arg2_3)
		end
	end
end

function var12_0.Add(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetCardType()
	local var1_4 = arg0_4._typeCDTimeStampList[var0_4]

	if var1_4 ~= -1 then
		local var2_4 = var1_4 - pg.TimeMgr.GetInstance():GetCombatTime()

		arg1_4:SetOverHeatDuration(var2_4)
	end
end

function var12_0.Update(arg0_5, arg1_5)
	for iter0_5, iter1_5 in pairs(arg0_5._typeCDTimeStampList) do
		if iter1_5 < arg1_5 then
			arg0_5._typeCDTimeStampList[iter0_5] = -1
		end
	end
end

function var12_0.Dispose(arg0_6)
	return
end

function var12_0.GetCardList(arg0_7)
	return arg0_7._handCardList
end

function var12_0.IsFull(arg0_8)
	return arg0_8:GetLength() >= var7_0.BASE_MAX_HAND + arg0_8._attrManager:GetCurrent("HandExtra")
end

function var12_0.init(arg0_9)
	arg0_9._handCardList = {}

	var0_0.EventDispatcher.AttachEventDispatcher(arg0_9)
	var0_0.Battle.BattleFleetCardPuzzleCardManageComponent.AttachCardManager(arg0_9)

	arg0_9._attrManager = arg0_9._cardPuzzleComponent:GetAttrManager()
	arg0_9._typeCDTimeStampList = {}

	for iter0_9, iter1_9 in pairs(CardPuzzleCard.CARD_TYPE) do
		arg0_9._typeCDTimeStampList[iter1_9] = -1
	end
end
