ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleCardPuzzleConfig
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent

var0_0.Battle.CardPuzzleHandBoard = class("CardPuzzleHandBoard")

local var4_0 = var0_0.Battle.CardPuzzleHandBoard

var4_0.__name = "CardPuzzleHandBoard"
var4_0.BASE_GAP = 166
var4_0.BASE_SIBLING = 4

function var4_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._areaGO = arg2_1

	arg0_1:init()
end

function var4_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	arg0_2._cardPuzzleInfo = arg1_2
	arg0_2._hand = arg0_2._cardPuzzleInfo:GetHand()

	arg0_2._hand:RegisterEventListener(arg0_2, var3_0.UPDATE_CARDS, arg0_2.onUpdateCards)
	arg0_2._cardPuzzleInfo:RegisterEventListener(arg0_2, var3_0.UPDATE_FLEET_ATTR, arg0_2.onUpdateFleetAttr)
	arg0_2:onUpdateCards()
end

function var4_0.Update(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3._activeCardList) do
		iter1_3:Update()
	end

	for iter2_3, iter3_3 in ipairs(arg0_3._freeCardList) do
		iter3_3:Update()
	end
end

function var4_0.onUpdateCards(arg0_4, arg1_4)
	local var0_4 = arg0_4._hand:GetCardList()
	local var1_4 = #arg0_4._activeCardList

	while var1_4 > 0 do
		local var2_4 = arg0_4._activeCardList[var1_4]
		local var3_4 = var2_4:GetCardInfo()

		if not table.contains(var0_4, var3_4) then
			if var3_4:GetCurrentPile() == arg0_4._cardPuzzleInfo.CARD_PILE_INDEX_DECK then
				arg0_4:delayRecyleCard(var2_4)
			else
				arg0_4:recyleCard(var2_4)
			end
		end

		var1_4 = var1_4 - 1
	end

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var4_4

		for iter2_4, iter3_4 in ipairs(arg0_4._activeCardList) do
			if iter3_4:GetCardInfo() == iter1_4 then
				var4_4 = iter3_4

				break
			end
		end

		if not var4_4 then
			local var5_4 = arg0_4:getCard()

			var5_4:SetCardInfo(iter1_4)
			var5_4:UpdateView()

			local var6_4 = iter1_4:GetFromPile() == arg0_4._cardPuzzleInfo.CARD_PILE_INDEX_DECK and arg0_4._drawPos or arg0_4._generatePos

			var5_4:DrawAnima(var6_4)
			var5_4:SetMoveLerp(0.1)
			var5_4:ChangeState(var5_4.STATE_FREE)
			table.insert(arg0_4._activeCardList, var5_4)
		end
	end

	arg0_4:updateCardReferenceInHand()
end

function var4_0.getCard(arg0_5)
	local var0_5

	if #arg0_5._idleCardList > 0 then
		var0_5 = table.remove(arg0_5._idleCardList, 1)
	else
		local var1_5 = arg0_5._resManager:InstCardPuzzleCard().transform

		var1_5:SetParent(arg0_5._cardContainer)

		var1_5.localScale = Vector3(0.57, 0.57, 0)
		var1_5.localPosition = Vector3.zero
		var0_5 = var0_0.Battle.CardPuzzleCombatCard.New(var1_5)
	end

	local function var2_5()
		return
	end

	local function var3_5()
		var0_5:ChangeState(var0_5.STATE_FREE)
		arg0_5._cardPuzzleInfo:LongPressCard(var0_5, false)
	end

	local function var4_5()
		if var0_5:GetState() == var0_5.STATE_LONG_PRESS then
			var3_5()
		end

		if var0_5:GetState() ~= var0_5.STATE_LOCK then
			arg0_5:LockCardInHand()
			arg0_5:UnlockCardInHand(var0_5)
			arg0_5:setDragingCard(var0_5)

			arg0_5._holdingCard = var0_5

			arg0_5:activeHighlight(true)
			arg0_5._cardPuzzleInfo:BlockComponentByCard(true)
			arg0_5:SetAllCardBlockRayCast(false)
			var0_5:SetSibling(#arg0_5._activeCardList + var4_0.BASE_SIBLING)
			var0_5:SetMoveLerp(0.5)
			var0_5:ChangeState(var0_5.STATE_DRAG)
		end
	end

	local function var5_5(arg0_9)
		var0_5:UpdateDragPosition(arg0_9)
	end

	local function var6_5()
		local var0_10 = true

		arg0_5:setDragingCard()

		if arg0_5._cardEnterDeck then
			var0_10 = arg0_5:TryPlayReturnCard(var0_5)
		else
			var0_10 = (arg0_5._cardEnterHand ~= true or false) and arg0_5:TryPlayCard(var0_5)
		end

		if not var0_10 then
			var0_5:SetMoveLerp()
			arg0_5:updateCardReferenceInHand()
		end

		arg0_5._cardEnterHand = nil
		arg0_5._cardEnterDeck = nil

		arg0_5:UnlockCardInHand()
		arg0_5:activeHighlight(false)
		arg0_5:SetAllCardBlockRayCast(true)
		onDelayTick(function()
			arg0_5._cardPuzzleInfo:BlockComponentByCard(false)
		end, 0.06)
	end

	local function var7_5()
		var0_5:ChangeState(var0_5.STATE_LONG_PRESS)
		arg0_5._cardPuzzleInfo:LongPressCard(var0_5, true)
	end

	var0_5:ConfigOP(var2_5, var4_5, var5_5, var6_5, var7_5, var3_5)

	return var0_5
end

function var4_0.recyleCard(arg0_13, arg1_13)
	for iter0_13, iter1_13 in ipairs(arg0_13._activeCardList) do
		if iter1_13 == arg1_13 then
			arg1_13:SetToObjPoolRecylePos()
			table.remove(arg0_13._activeCardList, iter0_13)

			break
		end
	end

	table.insert(arg0_13._idleCardList, arg1_13)
end

function var4_0.delayRecyleCard(arg0_14, arg1_14)
	arg1_14:ChangeState(arg1_14.STATE_LOCK)

	for iter0_14, iter1_14 in ipairs(arg0_14._activeCardList) do
		if iter1_14 == arg1_14 then
			table.remove(arg0_14._activeCardList, iter0_14)

			break
		end
	end

	table.insert(arg0_14._freeCardList, arg1_14)
	arg1_14:MoveToDeck(function()
		for iter0_15, iter1_15 in ipairs(arg0_14._freeCardList) do
			if iter1_15 == arg1_14 then
				arg1_14:SetToObjPoolRecylePos()
				table.remove(arg0_14._freeCardList, iter0_15)

				break
			end
		end

		table.insert(arg0_14._idleCardList, arg1_14)
	end, arg0_14._drawPos)
end

function var4_0.onUpdateFleetAttr(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg0_16._activeCardList) do
		iter1_16:UpdateTotalCost()
		iter1_16:UpdateBoostHint()

		local var0_16 = iter1_16:GetCardInfo()
	end
end

function var4_0.init(arg0_17)
	var0_0.EventListener.AttachEventListener(arg0_17)

	arg0_17._cardContainer = arg0_17._go.transform
	arg0_17._resManager = var0_0.Battle.BattleResourceManager.GetInstance()
	arg0_17._activeCardList = {}
	arg0_17._idleCardList = {}
	arg0_17._freeCardList = {}
	arg0_17._startPos = arg0_17._cardContainer:Find("handStart").localPosition
	arg0_17._generatePos = arg0_17._cardContainer:Find("generateStart").localPosition
	arg0_17._drawPos = arg0_17._cardContainer:Find("drawStart").localPosition
	arg0_17._cancelArea = arg0_17._cardContainer:Find("cancel_area")
	arg0_17._returnArea = arg0_17._cardContainer:Find("return_area")
	arg0_17._handDelegate = GetOrAddComponent(arg0_17._cancelArea, "EventTriggerListener")
	arg0_17._deckDelegate = GetOrAddComponent(arg0_17._returnArea, "EventTriggerListener")
	arg0_17._area = arg0_17._areaGO.transform
	arg0_17._cancelHint = arg0_17._area:Find("hand_hint")
	arg0_17._returnHint = arg0_17._area:Find("deck_hint")
	arg0_17._readyHint = arg0_17._area:Find("cast_hint")
end

function var4_0.updateCardReferenceInHand(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18._activeCardList) do
		local var0_18 = arg0_18:getcardGap()
		local var1_18 = Vector3.New(arg0_18._startPos.x + (iter0_18 - 1) * var0_18, arg0_18._startPos.y, 0)

		iter1_18:SetReferencePos(var1_18)
		iter1_18:SetSibling(iter0_18 + var4_0.BASE_SIBLING)
	end
end

function var4_0.getcardGap(arg0_19)
	local var0_19 = #arg0_19._activeCardList

	if #arg0_19._activeCardList <= var2_0.BASE_MAX_HAND then
		return var4_0.BASE_GAP
	else
		return 830 / (var0_19 - 1)
	end
end

function var4_0.setDragingCard(arg0_20, arg1_20)
	arg0_20._cardPuzzleInfo:SetDragingCard(arg1_20)
	arg0_20._cardPuzzleInfo:SendUpdateAim()
end

function var4_0.sort(arg0_21)
	return
end

function var4_0.activeHighlight(arg0_22, arg1_22)
	if arg1_22 then
		arg0_22._handDelegate:AddPointEnterFunc(function()
			arg0_22._cardEnterHand = true

			setActive(arg0_22._cancelHint, true)
			setActive(arg0_22._returnHint, false)
			setActive(arg0_22._readyHint, false)
		end)
		arg0_22._handDelegate:AddPointExitFunc(function()
			arg0_22._cardEnterHand = false

			setActive(arg0_22._cancelHint, false)
			setActive(arg0_22._readyHint, true)
		end)
		arg0_22._deckDelegate:AddPointEnterFunc(function()
			arg0_22._cardEnterDeck = true

			setActive(arg0_22._readyHint, false)

			local var0_25 = arg0_22._holdingCard:GetCardInfo():GetReturnCost() ~= nil

			setActive(arg0_22._cancelHint, not var0_25)
			setActive(arg0_22._returnHint, var0_25)
		end)
		arg0_22._deckDelegate:AddPointExitFunc(function()
			arg0_22._cardEnterDeck = false

			setActive(arg0_22._cancelHint, false)
			setActive(arg0_22._readyHint, true)
		end)
	else
		setActive(arg0_22._cancelHint, false)
		setActive(arg0_22._returnHint, false)
		setActive(arg0_22._readyHint, false)
		arg0_22._handDelegate:RemovePointEnterFunc()
		arg0_22._handDelegate:RemovePointExitFunc()
		arg0_22._deckDelegate:RemovePointEnterFunc()
		arg0_22._deckDelegate:RemovePointExitFunc()
	end

	setActive(arg0_22._cancelArea, arg1_22)
	setActive(arg0_22._returnArea, arg1_22)
end

function var4_0.LockCardInHand(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27._activeCardList) do
		iter1_27:ChangeState(iter1_27.STATE_LOCK)
	end
end

function var4_0.SetAllCardBlockRayCast(arg0_28, arg1_28)
	for iter0_28, iter1_28 in ipairs(arg0_28._activeCardList) do
		iter1_28:BlockRayCast(arg1_28)
	end
end

function var4_0.UnlockCardInHand(arg0_29, arg1_29)
	if arg1_29 then
		arg1_29:ChangeState(var0_0.Battle.CardPuzzleCombatCard.STATE_FREE)
	else
		for iter0_29, iter1_29 in ipairs(arg0_29._activeCardList) do
			iter1_29:ChangeState(var0_0.Battle.CardPuzzleCombatCard.STATE_FREE)
		end
	end
end

function var4_0.TryPlayCard(arg0_30, arg1_30)
	local var0_30 = arg1_30:GetCardInfo()

	return (arg0_30._cardPuzzleInfo:PlayCard(var0_30))
end

function var4_0.TryPlayReturnCard(arg0_31, arg1_31)
	local var0_31 = arg1_31:GetCardInfo()

	return (arg0_31._cardPuzzleInfo:ReturnCard(var0_31))
end

function var4_0.Dispose(arg0_32)
	return
end
