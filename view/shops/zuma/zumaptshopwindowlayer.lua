local var0 = class("ZumaPTShopWindowLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ZumaPTShopWindowUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateGoodInfoPanel()
	arg0:updateBuyPanelWithNum(1)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0.pageUtil:Dispose()
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

function var0.initData(arg0)
	arg0.actShopVO = arg0.contextData.actShopVO
	arg0.goodVO = arg0.contextData.goodVO
	arg0.perCost = arg0.goodVO:getConfig("resource_num")
	arg0.maxBuyCount = math.floor(Drop.New({
		type = arg0.goodVO:getConfig("resource_category"),
		id = arg0.goodVO:getConfig("resource_type")
	}):getOwnedCount() / arg0.perCost)

	if arg0.goodVO:getConfig("num_limit") ~= 0 then
		arg0.maxBuyCount = math.min(arg0.maxBuyCount, math.max(arg0.goodVO:GetPurchasableCnt(), 0))
	end

	arg0.curBuyCount = 1
	arg0.costItemInfo = Drop.New({
		type = arg0.goodVO:getConfig("resource_category"),
		id = arg0.goodVO:getConfig("resource_type")
	})
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")

	local var0 = arg0:findTF("Panel")
	local var1 = arg0:findTF("Info", var0)

	arg0.nameText = arg0:findTF("Name/Text", var1)
	arg0.descText = arg0:findTF("Desc", var1)
	arg0.itemTF = arg0:findTF("CommonItemTemplate", var1)
	arg0.countTF = arg0:findTF("Count", var1)
	arg0.countText = arg0:findTF("Count/Num", var1)

	local var2 = arg0:findTF("Count/Tip", var1)

	setText(var2, i18n("word_own1"))

	arg0.titleTF = arg0:findTF("Title", var0)

	local var3 = arg0:findTF("Buy", var0)

	arg0.minusBtn = arg0:findTF("Minus", var3)
	arg0.addBtn = arg0:findTF("Add", var3)
	arg0.maxBtn = arg0:findTF("Max", var3)
	arg0.buyNumText = arg0:findTF("Num", var3)
	arg0.butCountText = arg0:findTF("BuyCount/Num", var0)
	arg0.costNumText = arg0:findTF("Cost/Num", var0)
	arg0.confirmBtn = arg0:findTF("ConfirmBtn", var0)
	arg0.cancelBtn = arg0:findTF("CancelBtn", var0)
end

function var0.addListener(arg0)
	local function var0()
		arg0:closeView()
	end

	onButton(arg0, arg0.bg, var0, SFX_CANCEL)
	onButton(arg0, arg0.cancelBtn, var0, SFX_CANCEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.curBuyCount > arg0.maxBuyCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("islandshop_tips4", arg0.costItemInfo:getName()))

			return
		end

		pg.m02:sendNotification(GAME.ISLAND_SHOPPING, {
			shop = arg0.actShopVO,
			arg1 = arg0.goodVO.id,
			arg2 = arg0.curBuyCount
		})
	end, SFX_CANCEL)

	arg0.pageUtil = PageUtil.New(arg0.minusBtn, arg0.addBtn, arg0.maxBtn, arg0.butCountText)

	arg0.pageUtil:setNumUpdate(function(arg0)
		arg0:updateBuyPanelWithNum(arg0)
	end)
	arg0.pageUtil:setAddNum(1)
	arg0.pageUtil:setMaxNum(math.max(arg0.maxBuyCount, 1))
	arg0.pageUtil:setDefaultNum(1)
end

function var0.updateGoodInfoPanel(arg0)
	local var0 = arg0.goodVO
	local var1 = Drop.New({
		type = var0:getConfig("commodity_type"),
		id = var0:getConfig("commodity_id"),
		count = var0:getConfig("num")
	})

	updateDrop(arg0.itemTF, var1)

	local var2, var3 = var1:getOwnedCount()

	setActive(arg0.countTF, var3)

	if var3 then
		setText(arg0.countText, var2)
	end

	setText(arg0.nameText, var1:getConfig("name"))
	setText(arg0.descText, string.gsub(var1.desc or var1:getConfig("desc"), "<[^>]+>", ""))
end

function var0.updateBuyPanelWithNum(arg0, arg1)
	arg0.curBuyCount = arg1 or 0

	setText(arg0.buyNumText, arg0.curBuyCount)
	setText(arg0.butCountText, arg0.curBuyCount)
	setText(arg0.costNumText, arg0.curBuyCount * arg0.perCost)
end

return var0
