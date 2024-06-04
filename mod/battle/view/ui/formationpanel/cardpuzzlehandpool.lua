ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleCardPuzzleEvent

var0.Battle.CardPuzzleHandPool = class("CardPuzzleHandPool")

local var3 = var0.Battle.CardPuzzleHandPool

var3.__name = "CardPuzzleHandPool"

function var3.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:init()
	pg.DelegateInfo.New(arg0)
end

function var3.SetCardPuzzleComponent(arg0, arg1)
	arg0._cardPuzzleInfo = arg1
	arg0._hand = arg0._cardPuzzleInfo:GetHand()

	for iter0 = 1, var0.Battle.BattleFleetCardPuzzleHand.MAX_HAND do
		arg0:instCardView()
	end

	arg0._hand:RegisterEventListener(arg0, var2.UPDATE_CARDS, arg0.onUpdateCards)
	arg0._cardPuzzleInfo:RegisterEventListener(arg0, var2.UPDATE_FLEET_ATTR, arg0.onUpdateFleetAttr)
	arg0:onUpdateCards()
end

function var3.onUpdateCards(arg0, arg1)
	local var0 = arg0._hand:GetCardList()

	for iter0 = 1, arg0._hand.MAX_HAND do
		arg0._cardList[iter0]:SetCardInfo(var0[iter0])
	end
end

function var3.onUpdateFleetAttr(arg0, arg1)
	for iter0 = 1, arg0._hand.MAX_HAND do
		arg0._cardList[iter0]:UpdateTotalCost()
	end
end

function var3.init(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0._cardList = {}
	arg0._cardContainer = arg0._go.transform:Find("card_container")
	arg0._cardTpl = arg0._go.transform:Find("card_tpl")
end

function var3.updateHandCard(arg0)
	for iter0, iter1 in ipairs(arg0._cardList) do
		iter1:updateCardView()
	end
end

function var3.sort(arg0)
	return
end

function var3.instCardView(arg0)
	local var0 = cloneTplTo(arg0._cardTpl, arg0._cardContainer)
	local var1 = var0.Battle.CardPuzzleHandCardButton.New(go(var0))

	table.insert(arg0._cardList, var1)
	var1:ConfigCallback(function(arg0)
		arg0._cardPuzzleInfo:PlayCard(arg0)
	end)

	return var1
end

function var3.test(arg0, arg1)
	arg0._testContainer = arg1

	LoadAndInstantiateAsync("UI", "CardTowerCardCombat", function(arg0)
		arg0._cardPool = pg.Pool.New(arg0._testContainer, arg0, 7, 20, false, false):InitSize()

		local var0 = arg0._hand:GetCardList()

		for iter0, iter1 in ipairs(var0) do
			local var1 = arg0._cardPool:GetObject()
			local var2 = var1.transform

			var2.localScale = Vector3(0.57, 0.57, 0)

			local var3 = var0.Battle.CardPuzzleCombatCard.New(var2)

			var3:SetCardInfo(iter1)
			var3:UpdateView()

			arg0._modelClick = GetOrAddComponent(var1, "ModelDrag")
			arg0._modelPress = GetOrAddComponent(var1, "UILongPressTrigger")
			arg0._dragDelegate = GetOrAddComponent(var1, "EventTriggerListener")

			pg.DelegateInfo.Add(arg0, arg0._modelClick.onModelClick)
			arg0._modelClick.onModelClick:AddListener(function()
				return
			end)
			pg.DelegateInfo.Add(arg0, arg0._modelPress.onLongPressed)

			arg0._modelPress.longPressThreshold = 1

			arg0._modelPress.onLongPressed:RemoveAllListeners()
			arg0._modelPress.onLongPressed:AddListener(function()
				return
			end)
		end
	end, true, true)
end

function var3.Dispose(arg0)
	arg0._cardTpl = nil
	arg0._cardContainer = nil
	arg0._cardList = nil

	pg.DelegateInfo.Dispose(arg0)
end
