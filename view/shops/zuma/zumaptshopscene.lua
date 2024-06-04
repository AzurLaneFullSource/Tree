local var0 = class("ZumaPTShopScene", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ZumaPTShopUI"
end

function var0.getBGM(arg0)
	return "cw-story"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updatePTPanel()
	arg0:updateGoodPanel()
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

function var0.willExit(arg0)
	return
end

function var0.initData(arg0)
	arg0.actID = ActivityConst.MINIGAME_ZUMA_PT_SHOP_ID
	arg0.ptID = LaunchBallActivityMgr.GetGamePtId(ActivityConst.MINIGAME_ZUMA)
	arg0.ptItemID = id2ItemId(arg0.ptID)
	arg0.actShopVO = nil
	arg0.goodVOListForShow = nil
	arg0.goodIDList = pg.activity_template[arg0.actID].config_data
	arg0.goodTFList = {}

	arg0:updateData()
end

function var0.findUI(arg0)
	arg0.tpl = arg0:findTF("Tpl")
	arg0.containerTF = arg0:findTF("Shop/Panel/ScrollView/Viewport/Content")
	arg0.backBtn = arg0:findTF("Adapt/Back")
	arg0.helpBtn = arg0:findTF("Adapt/Help")
	arg0.ptInfoIcon = arg0:findTF("Shop/PTInfo/Icon")
	arg0.ptInfoCountText = arg0:findTF("Shop/PTInfo/Count")

	setText(arg0:findTF("Tip", arg0.tpl), i18n("islandshop_tips2"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("card_pairs_help_tip")
		})
	end, SFX_PANEL)

	arg0.goodUIItemList = UIItemList.New(arg0.containerTF, arg0.tpl)

	arg0.goodUIItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventInit then
			arg0.goodTFList[arg1] = arg2

			onButton(arg0, arg2, function()
				if not isActive(arg0:findTF("Mask", arg2)) then
					arg0:emit(ZumaPTShopMediator.OPEN_ZUMA_PT_SHOP_BUY_WINDOW, arg0:getGoodVOByIndex(arg1))
				else
					pg.TipsMgr:GetInstance():ShowTips(i18n("launchball_minigame_shop"))
				end
			end, SFX_PANEL)
		elseif arg0 == UIItemList.EventUpdate then
			arg0:updateTpl(arg1, arg2)
		end
	end)
end

function var0.updateData(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.actID)

	arg0.actShopVO = ActivityShop.New(var0)
	arg0.goodVOListForShow = arg0.actShopVO:getSortGoods()
end

function var0.getGoodVOByIndex(arg0, arg1)
	return arg0.goodVOListForShow[arg1]
end

function var0.updatePTPanel(arg0)
	local var0 = Drop.New({
		type = 1,
		id = arg0.ptID
	}):getOwnedCount()

	setText(arg0.ptInfoCountText, var0)
end

function var0.updateGoodPanel(arg0)
	arg0.goodUIItemList:align(#arg0.goodVOListForShow)
end

function var0.updateTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF("Item", arg2)
	local var1 = arg0:findTF("Name/Name", arg2)
	local var2 = arg0:findTF("PTCount", arg2)
	local var3 = arg0:findTF("BuyCount", arg2)
	local var4 = arg0.goodVOListForShow[arg1]
	local var5 = Drop.New({
		type = var4:getConfig("commodity_type"),
		id = var4:getConfig("commodity_id"),
		count = var4:getConfig("num")
	})

	updateDrop(var0, var5)
	setScrollText(var1, var5:getName())

	local var6 = var4:getConfig("resource_num")

	setText(var2, var6)

	local var7 = var4:getConfig("num_limit")

	if var7 == 0 then
		setText(var3, i18n("common_no_limit"))
	else
		setText(var3, math.max(var4:GetPurchasableCnt(), 0) .. "/" .. var7)
	end

	local var8 = arg0:findTF("Mask", arg2)
	local var9 = arg0:findTF("Lock", var8)
	local var10 = arg0:findTF("SellOut", var8)
	local var11 = var7 > 0 and var4:GetPurchasableCnt() <= 0

	setActive(var8, var11)
	setActive(var10, var11)
	setActive(var9, false)
end

function var0.updateTplByGoodID(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.goodVOListForShow) do
		if iter1.id == arg1 then
			var0 = iter0
		end
	end

	local var1 = arg0.goodTFList[var0]

	arg0:updateTpl(var0, var1)
end

return var0
