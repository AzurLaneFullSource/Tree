local var0_0 = class("ZumaPTShopScene", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ZumaPTShopUI"
end

function var0_0.getBGM(arg0_2)
	return "cw-story"
end

function var0_0.init(arg0_3)
	arg0_3:initData()
	arg0_3:findUI()
	arg0_3:addListener()
end

function var0_0.didEnter(arg0_4)
	arg0_4:updatePTPanel()
	arg0_4:updateGoodPanel()
end

function var0_0.onBackPressed(arg0_5)
	arg0_5:closeView()
end

function var0_0.willExit(arg0_6)
	return
end

function var0_0.initData(arg0_7)
	arg0_7.actID = ActivityConst.MINIGAME_ZUMA_PT_SHOP_ID
	arg0_7.ptID = LaunchBallActivityMgr.GetGamePtId(ActivityConst.MINIGAME_ZUMA)
	arg0_7.ptItemID = id2ItemId(arg0_7.ptID)
	arg0_7.actShopVO = nil
	arg0_7.goodVOListForShow = nil
	arg0_7.goodIDList = pg.activity_template[arg0_7.actID].config_data
	arg0_7.goodTFList = {}

	arg0_7:updateData()
end

function var0_0.findUI(arg0_8)
	arg0_8.tpl = arg0_8:findTF("Tpl")
	arg0_8.containerTF = arg0_8:findTF("Shop/Panel/ScrollView/Viewport/Content")
	arg0_8.backBtn = arg0_8:findTF("Adapt/Back")
	arg0_8.helpBtn = arg0_8:findTF("Adapt/Help")
	arg0_8.ptInfoIcon = arg0_8:findTF("Shop/PTInfo/Icon")
	arg0_8.ptInfoCountText = arg0_8:findTF("Shop/PTInfo/Count")

	setText(arg0_8:findTF("Tip", arg0_8.tpl), i18n("islandshop_tips2"))
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		arg0_9:closeView()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("card_pairs_help_tip")
		})
	end, SFX_PANEL)

	arg0_9.goodUIItemList = UIItemList.New(arg0_9.containerTF, arg0_9.tpl)

	arg0_9.goodUIItemList:make(function(arg0_12, arg1_12, arg2_12)
		arg1_12 = arg1_12 + 1

		if arg0_12 == UIItemList.EventInit then
			arg0_9.goodTFList[arg1_12] = arg2_12

			onButton(arg0_9, arg2_12, function()
				if not isActive(arg0_9:findTF("Mask", arg2_12)) then
					arg0_9:emit(ZumaPTShopMediator.OPEN_ZUMA_PT_SHOP_BUY_WINDOW, arg0_9:getGoodVOByIndex(arg1_12))
				else
					pg.TipsMgr:GetInstance():ShowTips(i18n("launchball_minigame_shop"))
				end
			end, SFX_PANEL)
		elseif arg0_12 == UIItemList.EventUpdate then
			arg0_9:updateTpl(arg1_12, arg2_12)
		end
	end)
end

function var0_0.updateData(arg0_14)
	local var0_14 = getProxy(ActivityProxy):getActivityById(arg0_14.actID)

	arg0_14.actShopVO = ActivityShop.New(var0_14)
	arg0_14.goodVOListForShow = arg0_14.actShopVO:getSortGoods()
end

function var0_0.getGoodVOByIndex(arg0_15, arg1_15)
	return arg0_15.goodVOListForShow[arg1_15]
end

function var0_0.updatePTPanel(arg0_16)
	local var0_16 = Drop.New({
		type = 1,
		id = arg0_16.ptID
	}):getOwnedCount()

	setText(arg0_16.ptInfoCountText, var0_16)
end

function var0_0.updateGoodPanel(arg0_17)
	arg0_17.goodUIItemList:align(#arg0_17.goodVOListForShow)
end

function var0_0.updateTpl(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18:findTF("Item", arg2_18)
	local var1_18 = arg0_18:findTF("Name/Name", arg2_18)
	local var2_18 = arg0_18:findTF("PTCount", arg2_18)
	local var3_18 = arg0_18:findTF("BuyCount", arg2_18)
	local var4_18 = arg0_18.goodVOListForShow[arg1_18]
	local var5_18 = Drop.New({
		type = var4_18:getConfig("commodity_type"),
		id = var4_18:getConfig("commodity_id"),
		count = var4_18:getConfig("num")
	})

	updateDrop(var0_18, var5_18)
	setScrollText(var1_18, var5_18:getName())

	local var6_18 = var4_18:getConfig("resource_num")

	setText(var2_18, var6_18)

	local var7_18 = var4_18:getConfig("num_limit")

	if var7_18 == 0 then
		setText(var3_18, i18n("common_no_limit"))
	else
		setText(var3_18, math.max(var4_18:GetPurchasableCnt(), 0) .. "/" .. var7_18)
	end

	local var8_18 = arg0_18:findTF("Mask", arg2_18)
	local var9_18 = arg0_18:findTF("Lock", var8_18)
	local var10_18 = arg0_18:findTF("SellOut", var8_18)
	local var11_18 = var7_18 > 0 and var4_18:GetPurchasableCnt() <= 0

	setActive(var8_18, var11_18)
	setActive(var10_18, var11_18)
	setActive(var9_18, false)
end

function var0_0.updateTplByGoodID(arg0_19, arg1_19)
	local var0_19 = 0

	for iter0_19, iter1_19 in ipairs(arg0_19.goodVOListForShow) do
		if iter1_19.id == arg1_19 then
			var0_19 = iter0_19
		end
	end

	local var1_19 = arg0_19.goodTFList[var0_19]

	arg0_19:updateTpl(var0_19, var1_19)
end

return var0_0
