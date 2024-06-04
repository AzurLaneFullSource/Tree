ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleCardPuzzleConfig
local var3 = var0.Battle.BattleCardPuzzleEvent

var0.Battle.CardPuzzleHandBoard = class("CardPuzzleHandBoard")

local var4 = var0.Battle.CardPuzzleHandBoard

var4.__name = "CardPuzzleHandBoard"
var4.BASE_GAP = 166
var4.BASE_SIBLING = 4

function var4.Ctor(arg0, arg1, arg2)
	arg0._go = arg1
	arg0._areaGO = arg2

	arg0:init()
end

function var4.SetCardPuzzleComponent(arg0, arg1)
	arg0._cardPuzzleInfo = arg1
	arg0._hand = arg0._cardPuzzleInfo:GetHand()

	arg0._hand:RegisterEventListener(arg0, var3.UPDATE_CARDS, arg0.onUpdateCards)
	arg0._cardPuzzleInfo:RegisterEventListener(arg0, var3.UPDATE_FLEET_ATTR, arg0.onUpdateFleetAttr)
	arg0:onUpdateCards()
end

function var4.Update(arg0)
	for iter0, iter1 in ipairs(arg0._activeCardList) do
		iter1:Update()
	end

	for iter2, iter3 in ipairs(arg0._freeCardList) do
		iter3:Update()
	end
end

function var4.onUpdateCards(arg0, arg1)
	local var0 = arg0._hand:GetCardList()
	local var1 = #arg0._activeCardList

	while var1 > 0 do
		local var2 = arg0._activeCardList[var1]
		local var3 = var2:GetCardInfo()

		if not table.contains(var0, var3) then
			if var3:GetCurrentPile() == arg0._cardPuzzleInfo.CARD_PILE_INDEX_DECK then
				arg0:delayRecyleCard(var2)
			else
				arg0:recyleCard(var2)
			end
		end

		var1 = var1 - 1
	end

	for iter0, iter1 in ipairs(var0) do
		local var4

		for iter2, iter3 in ipairs(arg0._activeCardList) do
			if iter3:GetCardInfo() == iter1 then
				var4 = iter3

				break
			end
		end

		if not var4 then
			local var5 = arg0:getCard()

			var5:SetCardInfo(iter1)
			var5:UpdateView()

			local var6 = iter1:GetFromPile() == arg0._cardPuzzleInfo.CARD_PILE_INDEX_DECK and arg0._drawPos or arg0._generatePos

			var5:DrawAnima(var6)
			var5:SetMoveLerp(0.1)
			var5:ChangeState(var5.STATE_FREE)
			table.insert(arg0._activeCardList, var5)
		end
	end

	arg0:updateCardReferenceInHand()
end

function var4.getCard(arg0)
	local var0

	if #arg0._idleCardList > 0 then
		var0 = table.remove(arg0._idleCardList, 1)
	else
		local var1 = arg0._resManager:InstCardPuzzleCard().transform

		var1:SetParent(arg0._cardContainer)

		var1.localScale = Vector3(0.57, 0.57, 0)
		var1.localPosition = Vector3.zero
		var0 = var0.Battle.CardPuzzleCombatCard.New(var1)
	end

	local function var2()
		return
	end

	local function var3()
		var0:ChangeState(var0.STATE_FREE)
		arg0._cardPuzzleInfo:LongPressCard(var0, false)
	end

	local var4 = function()
		if var0:GetState() == var0.STATE_LONG_PRESS then
			var3()
		end

		if var0:GetState() ~= var0.STATE_LOCK then
			arg0:LockCardInHand()
			arg0:UnlockCardInHand(var0)
			arg0:setDragingCard(var0)

			arg0._holdingCard = var0

			arg0:activeHighlight(true)
			arg0._cardPuzzleInfo:BlockComponentByCard(true)
			arg0:SetAllCardBlockRayCast(false)
			var0:SetSibling(#arg0._activeCardList + var4.BASE_SIBLING)
			var0:SetMoveLerp(0.5)
			var0:ChangeState(var0.STATE_DRAG)
		end
	end

	local function var5(arg0)
		var0:UpdateDragPosition(arg0)
	end

	local function var6()
		local var0 = true

		arg0:setDragingCard()

		if arg0._cardEnterDeck then
			var0 = arg0:TryPlayReturnCard(var0)
		else
			var0 = (arg0._cardEnterHand ~= true or false) and arg0:TryPlayCard(var0)
		end

		if not var0 then
			var0:SetMoveLerp()
			arg0:updateCardReferenceInHand()
		end

		arg0._cardEnterHand = nil
		arg0._cardEnterDeck = nil

		arg0:UnlockCardInHand()
		arg0:activeHighlight(false)
		arg0:SetAllCardBlockRayCast(true)
		onDelayTick(function()
			arg0._cardPuzzleInfo:BlockComponentByCard(false)
		end, 0.06)
	end

	local function var7()
		var0:ChangeState(var0.STATE_LONG_PRESS)
		arg0._cardPuzzleInfo:LongPressCard(var0, true)
	end

	var0:ConfigOP(var2, var4, var5, var6, var7, var3)

	return var0
end

function var4.recyleCard(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._activeCardList) do
		if iter1 == arg1 then
			arg1:SetToObjPoolRecylePos()
			table.remove(arg0._activeCardList, iter0)

			break
		end
	end

	table.insert(arg0._idleCardList, arg1)
end

function var4.delayRecyleCard(arg0, arg1)
	arg1:ChangeState(arg1.STATE_LOCK)

	for iter0, iter1 in ipairs(arg0._activeCardList) do
		if iter1 == arg1 then
			table.remove(arg0._activeCardList, iter0)

			break
		end
	end

	table.insert(arg0._freeCardList, arg1)
	arg1:MoveToDeck(function()
		for iter0, iter1 in ipairs(arg0._freeCardList) do
			if iter1 == arg1 then
				arg1:SetToObjPoolRecylePos()
				table.remove(arg0._freeCardList, iter0)

				break
			end
		end

		table.insert(arg0._idleCardList, arg1)
	end, arg0._drawPos)
end

function var4.onUpdateFleetAttr(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._activeCardList) do
		iter1:UpdateTotalCost()
		iter1:UpdateBoostHint()

		local var0 = iter1:GetCardInfo()
	end
end

function var4.init(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0._cardContainer = arg0._go.transform
	arg0._resManager = var0.Battle.BattleResourceManager.GetInstance()
	arg0._activeCardList = {}
	arg0._idleCardList = {}
	arg0._freeCardList = {}
	arg0._startPos = arg0._cardContainer:Find("handStart").localPosition
	arg0._generatePos = arg0._cardContainer:Find("generateStart").localPosition
	arg0._drawPos = arg0._cardContainer:Find("drawStart").localPosition
	arg0._cancelArea = arg0._cardContainer:Find("cancel_area")
	arg0._returnArea = arg0._cardContainer:Find("return_area")
	arg0._handDelegate = GetOrAddComponent(arg0._cancelArea, "EventTriggerListener")
	arg0._deckDelegate = GetOrAddComponent(arg0._returnArea, "EventTriggerListener")
	arg0._area = arg0._areaGO.transform
	arg0._cancelHint = arg0._area:Find("hand_hint")
	arg0._returnHint = arg0._area:Find("deck_hint")
	arg0._readyHint = arg0._area:Find("cast_hint")
end

function var4.updateCardReferenceInHand(arg0)
	for iter0, iter1 in ipairs(arg0._activeCardList) do
		local var0 = arg0:getcardGap()
		local var1 = Vector3.New(arg0._startPos.x + (iter0 - 1) * var0, arg0._startPos.y, 0)

		iter1:SetReferencePos(var1)
		iter1:SetSibling(iter0 + var4.BASE_SIBLING)
	end
end

function var4.getcardGap(arg0)
	local var0 = #arg0._activeCardList

	if #arg0._activeCardList <= var2.BASE_MAX_HAND then
		return var4.BASE_GAP
	else
		return 830 / (var0 - 1)
	end
end

function var4.setDragingCard(arg0, arg1)
	arg0._cardPuzzleInfo:SetDragingCard(arg1)
	arg0._cardPuzzleInfo:SendUpdateAim()
end

function var4.sort(arg0)
	return
end

function var4.activeHighlight(arg0, arg1)
	if arg1 then
		arg0._handDelegate:AddPointEnterFunc(function()
			arg0._cardEnterHand = true

			setActive(arg0._cancelHint, true)
			setActive(arg0._returnHint, false)
			setActive(arg0._readyHint, false)
		end)
		arg0._handDelegate:AddPointExitFunc(function()
			arg0._cardEnterHand = false

			setActive(arg0._cancelHint, false)
			setActive(arg0._readyHint, true)
		end)
		arg0._deckDelegate:AddPointEnterFunc(function()
			arg0._cardEnterDeck = true

			setActive(arg0._readyHint, false)

			local var0 = arg0._holdingCard:GetCardInfo():GetReturnCost() ~= nil

			setActive(arg0._cancelHint, not var0)
			setActive(arg0._returnHint, var0)
		end)
		arg0._deckDelegate:AddPointExitFunc(function()
			arg0._cardEnterDeck = false

			setActive(arg0._cancelHint, false)
			setActive(arg0._readyHint, true)
		end)
	else
		setActive(arg0._cancelHint, false)
		setActive(arg0._returnHint, false)
		setActive(arg0._readyHint, false)
		arg0._handDelegate:RemovePointEnterFunc()
		arg0._handDelegate:RemovePointExitFunc()
		arg0._deckDelegate:RemovePointEnterFunc()
		arg0._deckDelegate:RemovePointExitFunc()
	end

	setActive(arg0._cancelArea, arg1)
	setActive(arg0._returnArea, arg1)
end

function var4.LockCardInHand(arg0)
	for iter0, iter1 in ipairs(arg0._activeCardList) do
		iter1:ChangeState(iter1.STATE_LOCK)
	end
end

function var4.SetAllCardBlockRayCast(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._activeCardList) do
		iter1:BlockRayCast(arg1)
	end
end

function var4.UnlockCardInHand(arg0, arg1)
	if arg1 then
		arg1:ChangeState(var0.Battle.CardPuzzleCombatCard.STATE_FREE)
	else
		for iter0, iter1 in ipairs(arg0._activeCardList) do
			iter1:ChangeState(var0.Battle.CardPuzzleCombatCard.STATE_FREE)
		end
	end
end

function var4.TryPlayCard(arg0, arg1)
	local var0 = arg1:GetCardInfo()

	return (arg0._cardPuzzleInfo:PlayCard(var0))
end

function var4.TryPlayReturnCard(arg0, arg1)
	local var0 = arg1:GetCardInfo()

	return (arg0._cardPuzzleInfo:ReturnCard(var0))
end

function var4.Dispose(arg0)
	return
end
