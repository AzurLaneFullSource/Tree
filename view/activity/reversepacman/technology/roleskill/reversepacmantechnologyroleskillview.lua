local var0_0 = class("ReversePacmanTechnologyRoleSkillView", import("view.base.BasePanel"))

var0_0.BUY_SHOP_ITEM_SUCCESS = "ReversePacmanTechnologyRoleSkillView::BUY_SHOP_ITEM_SUCCESS"
var0_0.REFRESH_ITEM_CNT = "ReversePacmanTechnologyRoleSkillView::REFRESH_ITEM_CNT"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
	arg0_1:didEnter()
end

function var0_0.Init(arg0_2)
	arg0_2.itemList = {}

	local var0_2 = ReversePacmanTools.GetActivity()

	for iter0_2, iter1_2 in ipairs(var0_2:getConfig("config_client").technologyShopIDList) do
		arg0_2.itemList[iter0_2] = arg0_2:GetItemClass().New(Object.Instantiate(arg0_2.uiSkillItem, arg0_2.uiSkillParent), arg0_2, iter1_2)
	end

	setText(arg0_2.uiFrontText, i18n("reverse_pacman_owned"))
	setImageSprite(arg0_2.uiIconImage, GetSpriteFromAtlas(ReversePacmanTools.GetTechnologyPTDrop():getIcon(), ""))
	onButton(arg0_2, arg0_2.uiCurrencyBtn, function()
		local var0_3 = ReversePacmanTools.GetTechnologyPTDrop()

		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanItemPopScene,
			mediator = ReversePacmanItemPopMediator,
			data = {
				dropType = var0_3.type,
				dropID = var0_3.id,
				count = var0_3:getOwnedCount(),
				limitItemGuideID = ReversePacmanTools.GetActivity():getConfig("config_client").pt_link or 240
			}
		}))
	end, SFX_PANEL)
end

function var0_0.GetItemClass(arg0_4)
	return ReversePacmanTechnologyRoleSkillItem
end

function var0_0.didEnter(arg0_5)
	arg0_5.eventIDList = {
		arg0_5:bind(var0_0.BUY_SHOP_ITEM_SUCCESS, handler(arg0_5, arg0_5.OnBuyShopItemSuccess)),
		arg0_5:bind(var0_0.REFRESH_ITEM_CNT, handler(arg0_5, arg0_5.RefreshCurrency))
	}

	arg0_5:RefreshCurrency()
end

function var0_0.RefreshCurrency(arg0_6)
	local var0_6 = ReversePacmanTools.GetTechnologyPTDrop():getOwnedCount()

	setText(arg0_6.uiPtCntText, i18n("reverse_pacman_count", var0_6))
end

function var0_0.OnBuyShopItemSuccess(arg0_7, arg1_7, arg2_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.itemList) do
		iter1_7:RefreshUI()
	end
end

function var0_0.willExit(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.eventIDList) do
		arg0_8:disconnect(iter1_8)
	end

	arg0_8.eventIDList = nil

	for iter2_8, iter3_8 in ipairs(arg0_8.itemList) do
		iter3_8:willExit()
	end

	arg0_8.itemList = nil

	arg0_8:detach()
end

return var0_0
