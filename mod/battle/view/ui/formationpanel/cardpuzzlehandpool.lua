ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleCardPuzzleEvent

var0_0.Battle.CardPuzzleHandPool = class("CardPuzzleHandPool")

local var3_0 = var0_0.Battle.CardPuzzleHandPool

var3_0.__name = "CardPuzzleHandPool"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:init()
	pg.DelegateInfo.New(arg0_1)
end

function var3_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	arg0_2._cardPuzzleInfo = arg1_2
	arg0_2._hand = arg0_2._cardPuzzleInfo:GetHand()

	for iter0_2 = 1, var0_0.Battle.BattleFleetCardPuzzleHand.MAX_HAND do
		arg0_2:instCardView()
	end

	arg0_2._hand:RegisterEventListener(arg0_2, var2_0.UPDATE_CARDS, arg0_2.onUpdateCards)
	arg0_2._cardPuzzleInfo:RegisterEventListener(arg0_2, var2_0.UPDATE_FLEET_ATTR, arg0_2.onUpdateFleetAttr)
	arg0_2:onUpdateCards()
end

function var3_0.onUpdateCards(arg0_3, arg1_3)
	local var0_3 = arg0_3._hand:GetCardList()

	for iter0_3 = 1, arg0_3._hand.MAX_HAND do
		arg0_3._cardList[iter0_3]:SetCardInfo(var0_3[iter0_3])
	end
end

function var3_0.onUpdateFleetAttr(arg0_4, arg1_4)
	for iter0_4 = 1, arg0_4._hand.MAX_HAND do
		arg0_4._cardList[iter0_4]:UpdateTotalCost()
	end
end

function var3_0.init(arg0_5)
	var0_0.EventListener.AttachEventListener(arg0_5)

	arg0_5._cardList = {}
	arg0_5._cardContainer = arg0_5._go.transform:Find("card_container")
	arg0_5._cardTpl = arg0_5._go.transform:Find("card_tpl")
end

function var3_0.updateHandCard(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6._cardList) do
		iter1_6:updateCardView()
	end
end

function var3_0.sort(arg0_7)
	return
end

function var3_0.instCardView(arg0_8)
	local var0_8 = cloneTplTo(arg0_8._cardTpl, arg0_8._cardContainer)
	local var1_8 = var0_0.Battle.CardPuzzleHandCardButton.New(go(var0_8))

	table.insert(arg0_8._cardList, var1_8)
	var1_8:ConfigCallback(function(arg0_9)
		arg0_8._cardPuzzleInfo:PlayCard(arg0_9)
	end)

	return var1_8
end

function var3_0.test(arg0_10, arg1_10)
	arg0_10._testContainer = arg1_10

	LoadAndInstantiateAsync("UI", "CardTowerCardCombat", function(arg0_11)
		arg0_10._cardPool = pg.Pool.New(arg0_10._testContainer, arg0_11, 7, 20, false, false):InitSize()

		local var0_11 = arg0_10._hand:GetCardList()

		for iter0_11, iter1_11 in ipairs(var0_11) do
			local var1_11 = arg0_10._cardPool:GetObject()
			local var2_11 = var1_11.transform

			var2_11.localScale = Vector3(0.57, 0.57, 0)

			local var3_11 = var0_0.Battle.CardPuzzleCombatCard.New(var2_11)

			var3_11:SetCardInfo(iter1_11)
			var3_11:UpdateView()

			arg0_10._modelClick = GetOrAddComponent(var1_11, "ModelDrag")
			arg0_10._modelPress = GetOrAddComponent(var1_11, "UILongPressTrigger")
			arg0_10._dragDelegate = GetOrAddComponent(var1_11, "EventTriggerListener")

			pg.DelegateInfo.Add(arg0_10, arg0_10._modelClick.onModelClick)
			arg0_10._modelClick.onModelClick:AddListener(function()
				return
			end)
			pg.DelegateInfo.Add(arg0_10, arg0_10._modelPress.onLongPressed)

			arg0_10._modelPress.longPressThreshold = 1

			arg0_10._modelPress.onLongPressed:RemoveAllListeners()
			arg0_10._modelPress.onLongPressed:AddListener(function()
				return
			end)
		end
	end, true, true)
end

function var3_0.Dispose(arg0_14)
	arg0_14._cardTpl = nil
	arg0_14._cardContainer = nil
	arg0_14._cardList = nil

	pg.DelegateInfo.Dispose(arg0_14)
end
