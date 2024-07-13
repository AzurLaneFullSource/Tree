local var0_0 = class("ZumaPTShopWindowLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ZumaPTShopWindowUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateGoodInfoPanel()
	arg0_3:updateBuyPanelWithNum(1)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
	arg0_4.pageUtil:Dispose()
end

function var0_0.onBackPressed(arg0_5)
	arg0_5:closeView()
end

function var0_0.initData(arg0_6)
	arg0_6.actShopVO = arg0_6.contextData.actShopVO
	arg0_6.goodVO = arg0_6.contextData.goodVO
	arg0_6.perCost = arg0_6.goodVO:getConfig("resource_num")
	arg0_6.maxBuyCount = math.floor(Drop.New({
		type = arg0_6.goodVO:getConfig("resource_category"),
		id = arg0_6.goodVO:getConfig("resource_type")
	}):getOwnedCount() / arg0_6.perCost)

	if arg0_6.goodVO:getConfig("num_limit") ~= 0 then
		arg0_6.maxBuyCount = math.min(arg0_6.maxBuyCount, math.max(arg0_6.goodVO:GetPurchasableCnt(), 0))
	end

	arg0_6.curBuyCount = 1
	arg0_6.costItemInfo = Drop.New({
		type = arg0_6.goodVO:getConfig("resource_category"),
		id = arg0_6.goodVO:getConfig("resource_type")
	})
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")

	local var0_7 = arg0_7:findTF("Panel")
	local var1_7 = arg0_7:findTF("Info", var0_7)

	arg0_7.nameText = arg0_7:findTF("Name/Text", var1_7)
	arg0_7.descText = arg0_7:findTF("Desc", var1_7)
	arg0_7.itemTF = arg0_7:findTF("CommonItemTemplate", var1_7)
	arg0_7.countTF = arg0_7:findTF("Count", var1_7)
	arg0_7.countText = arg0_7:findTF("Count/Num", var1_7)

	local var2_7 = arg0_7:findTF("Count/Tip", var1_7)

	setText(var2_7, i18n("word_own1"))

	arg0_7.titleTF = arg0_7:findTF("Title", var0_7)

	local var3_7 = arg0_7:findTF("Buy", var0_7)

	arg0_7.minusBtn = arg0_7:findTF("Minus", var3_7)
	arg0_7.addBtn = arg0_7:findTF("Add", var3_7)
	arg0_7.maxBtn = arg0_7:findTF("Max", var3_7)
	arg0_7.buyNumText = arg0_7:findTF("Num", var3_7)
	arg0_7.butCountText = arg0_7:findTF("BuyCount/Num", var0_7)
	arg0_7.costNumText = arg0_7:findTF("Cost/Num", var0_7)
	arg0_7.confirmBtn = arg0_7:findTF("ConfirmBtn", var0_7)
	arg0_7.cancelBtn = arg0_7:findTF("CancelBtn", var0_7)
end

function var0_0.addListener(arg0_8)
	local function var0_8()
		arg0_8:closeView()
	end

	onButton(arg0_8, arg0_8.bg, var0_8, SFX_CANCEL)
	onButton(arg0_8, arg0_8.cancelBtn, var0_8, SFX_CANCEL)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		if arg0_8.curBuyCount > arg0_8.maxBuyCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("islandshop_tips4", arg0_8.costItemInfo:getName()))

			return
		end

		pg.m02:sendNotification(GAME.ISLAND_SHOPPING, {
			shop = arg0_8.actShopVO,
			arg1 = arg0_8.goodVO.id,
			arg2 = arg0_8.curBuyCount
		})
	end, SFX_CANCEL)

	arg0_8.pageUtil = PageUtil.New(arg0_8.minusBtn, arg0_8.addBtn, arg0_8.maxBtn, arg0_8.butCountText)

	arg0_8.pageUtil:setNumUpdate(function(arg0_11)
		arg0_8:updateBuyPanelWithNum(arg0_11)
	end)
	arg0_8.pageUtil:setAddNum(1)
	arg0_8.pageUtil:setMaxNum(math.max(arg0_8.maxBuyCount, 1))
	arg0_8.pageUtil:setDefaultNum(1)
end

function var0_0.updateGoodInfoPanel(arg0_12)
	local var0_12 = arg0_12.goodVO
	local var1_12 = Drop.New({
		type = var0_12:getConfig("commodity_type"),
		id = var0_12:getConfig("commodity_id"),
		count = var0_12:getConfig("num")
	})

	updateDrop(arg0_12.itemTF, var1_12)

	local var2_12, var3_12 = var1_12:getOwnedCount()

	setActive(arg0_12.countTF, var3_12)

	if var3_12 then
		setText(arg0_12.countText, var2_12)
	end

	setText(arg0_12.nameText, var1_12:getConfig("name"))
	setText(arg0_12.descText, string.gsub(var1_12.desc or var1_12:getConfig("desc"), "<[^>]+>", ""))
end

function var0_0.updateBuyPanelWithNum(arg0_13, arg1_13)
	arg0_13.curBuyCount = arg1_13 or 0

	setText(arg0_13.buyNumText, arg0_13.curBuyCount)
	setText(arg0_13.butCountText, arg0_13.curBuyCount)
	setText(arg0_13.costNumText, arg0_13.curBuyCount * arg0_13.perCost)
end

return var0_0
