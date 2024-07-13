local var0_0 = class("ChargeScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BackChargeUI"
end

function var0_0.init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	arg0_3.diamondPanel = findTF(arg0_3._tf, "frame/viewContainer/diamondPanel")
	arg0_3.blurPanel = arg0_3:findTF("blur_panel")
	arg0_3.detail = arg0_3:findTF("detail", arg0_3.blurPanel)
	arg0_3.damondItems = {}

	setText(findTF(arg0_3._tf, "frame/viewContainer/leftPanel/desc"), i18n("Supplement_pay2"))
	setText(findTF(arg0_3._tf, "tip"), i18n("Supplement_pay5"))
	arg0_3:initDamonds()
	arg0_3:refundUpdate()
end

function var0_0.refundUpdate(arg0_4)
	arg0_4:updateDamondsData()
	arg0_4:sortDamondItems()

	if #arg0_4.tempDamondVOs <= 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("Supplement_pay3"),
			onYes = function()
				Application.Quit()
			end
		})
	end
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6
end

function var0_0.setChargedList(arg0_7, arg1_7)
	arg0_7.chargedList = arg1_7
end

function var0_0.initDamonds(arg0_8)
	arg0_8.diamondUIItemList = arg0_8:initDiamondList(arg0_8.diamondPanel)
end

function var0_0.confirm(arg0_9, arg1_9)
	if not arg1_9 then
		return
	end

	arg0_9:emit(BackChargeMediator.CHARGE, arg1_9.id)
end

function var0_0.initDiamondList(arg0_10, arg1_10)
	local var0_10 = arg0_10:findTF("content", arg1_10)
	local var1_10 = arg0_10:findTF("ItemTpl", arg1_10)

	local function var2_10(arg0_11)
		local var0_11 = BackChargeDiamondCard.New(arg0_11, arg0_10)

		onButton(arg0_10, var0_11.tr, function()
			arg0_10:confirm(var0_11.goods)
		end, SFX_PANEL)

		arg0_10.damondItems[arg0_11] = var0_11
	end

	local function var3_10(arg0_13, arg1_13)
		local var0_13 = arg0_10.damondItems[arg1_13]

		if not var0_13 then
			var2_10(arg1_13)

			var0_13 = arg0_10.damondItems[arg1_13]
		end

		local var1_13 = arg0_10.tempDamondVOs[arg0_13 + 1]

		if var1_13 then
			var0_13:update(var1_13, arg0_10.player, arg0_10.firstChargeIds)
		end
	end

	local var4_10 = UIItemList.New(var0_10, var1_10)

	var4_10:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventInit then
			var2_10(go(arg2_14))
		elseif arg0_14 == UIItemList.EventUpdate then
			var3_10(arg1_14, go(arg2_14))
		end
	end)

	return var4_10
end

function var0_0.updateDamondsData(arg0_15)
	local var0_15 = pg.pay_data_display

	arg0_15.damondItemVOs = {}

	local var1_15 = getProxy(UserProxy):getData()
	local var2_15 = getProxy(ServerProxy)
	local var3_15 = getProxy(PlayerProxy):getRefundInfo()
	local var4_15 = var2_15:getLastServer(var1_15.uid)

	var3_15 = var3_15 or {}

	for iter0_15 = 1, #var3_15 do
		local var5_15 = Goods.Create({
			shop_id = var3_15[iter0_15].shopId
		}, Goods.TYPE_CHARGE)

		var5_15.buyTime = var3_15[iter0_15].buyTime
		var5_15.refundTime = var3_15[iter0_15].refundTime

		table.insert(arg0_15.damondItemVOs, var5_15)
	end
end

function var0_0.sortDamondItems(arg0_16)
	if arg0_16.damondItemVOs == nil then
		return
	end

	arg0_16.tempDamondVOs = {}

	for iter0_16, iter1_16 in ipairs(arg0_16.damondItemVOs) do
		if iter1_16:isChargeType() then
			iter1_16:updateBuyCount(arg0_16:getBuyCount(arg0_16.chargedList, iter1_16.id))
			table.insert(arg0_16.tempDamondVOs, iter1_16)
		end
	end

	table.sort(arg0_16.tempDamondVOs, function(arg0_17, arg1_17)
		local var0_17 = not table.contains(arg0_16.firstChargeIds, arg0_17.id) and arg0_17:firstPayDouble() and 1 or 0
		local var1_17 = not table.contains(arg0_16.firstChargeIds, arg1_17.id) and arg1_17:firstPayDouble() and 1 or 0
		local var2_17 = 0
		local var3_17 = 0
		local var4_17

		if var2_17 ~= var3_17 then
			return var2_17 < var3_17
		end

		local var5_17 = arg0_17:getConfig("tag") == 2 and 1 or 0
		local var6_17 = arg1_17:getConfig("tag") == 2 and 1 or 0

		if var0_17 == var1_17 and var5_17 == var6_17 then
			return arg0_17.id < arg1_17.id
		else
			return var1_17 < var0_17 or var0_17 == var1_17 and var6_17 < var5_17
		end
	end)

	if page == var0_0.TYPE_DIAMOND then
		arg0_16.diamondUIItemList:align(#arg0_16.tempDamondVOs)
	elseif page == var0_0.TYPE_GIFT then
		arg0_16.giftRect:SetTotalCount(#arg0_16.tempDamondVOs, arg0_16.giftRect.value)
	end
end

function var0_0.getBuyCount(arg0_18, arg1_18, arg2_18)
	if not arg1_18 then
		return 0
	end

	local var0_18 = arg1_18[arg2_18]

	return var0_18 and var0_18.buyCount or 0
end

function var0_0.showItemDetail(arg0_19, arg1_19)
	local var0_19 = arg1_19.icon
	local var1_19 = arg1_19.name and arg1_19.name or ""
	local var2_19 = arg1_19.tipBonus or ""
	local var3_19 = arg1_19.bonusItem
	local var4_19 = arg1_19.tipExtra and arg1_19.tipExtra or ""
	local var5_19 = arg1_19.extraItems and arg1_19.extraItems or {}
	local var6_19 = arg1_19.price and arg1_19.price or 0
	local var7_19 = arg1_19.isChargeType
	local var8_19 = arg1_19.isMonthCard
	local var9_19 = arg1_19.tagType
	local var10_19 = arg1_19.normalTip

	setActive(arg0_19:findTF("window2", arg0_19.detail), var10_19)
	setActive(arg0_19:findTF("window", arg0_19.detail), not var10_19)
	arg0_19:bindDetailTF(var10_19 and arg0_19:findTF("window2", arg0_19.detail) or arg0_19:findTF("window", arg0_19.detail))

	if arg0_19.detailNormalTip then
		setActive(arg0_19.detailNormalTip, var10_19)
	end

	if arg0_19.detailContain then
		setActive(arg0_19.detailContain, not var10_19)
	end

	if var10_19 then
		if arg0_19.detailNormalTip:GetComponent("Text") then
			setText(arg0_19.detailNormalTip, var10_19)
		else
			setButtonText(arg0_19.detailNormalTip, var10_19)
		end
	end

	setActive(arg0_19.detailTag, var9_19 > 0)

	if var9_19 > 0 then
		for iter0_19, iter1_19 in ipairs(arg0_19.detailTags) do
			setActive(iter1_19, iter0_19 == var9_19)
		end
	end

	arg0_19.detailIconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

	LoadSpriteAsync(var0_19, function(arg0_20)
		if arg0_20 then
			arg0_19.detailIconTF.sprite = arg0_20
		end
	end)
	setText(arg0_19.detailName, var1_19)
	setActive(arg0_19.detailRmb, var7_19)
	setActive(arg0_19.detailGem, not var7_19)
	setText(arg0_19.detailPrice, var6_19)

	if arg0_19.detailDescExtra ~= nil then
		setActive(arg0_19.detailDescExtra, arg1_19.descExtra and arg1_19.descExtra ~= "")
		setText(arg0_19.detailDescExtra, arg1_19.descExtra or "")
	end

	if arg0_19.detailContain then
		SetActive(arg0_19.normal, var8_19)

		if var8_19 then
			updateDrop(arg0_19.detailItem, var3_19)
			onButton(arg0_19, arg0_19.detailItem, function()
				arg0_19:emit(var0_0.ON_DROP, var3_19)
			end, SFX_PANEL)

			local var11_19, var12_19 = contentWrap(var3_19:getConfig("name"), 10, 2)

			if var11_19 then
				var12_19 = var12_19 .. "..."
			end

			setText(arg0_19.detailItem:Find("name"), var12_19)
			setText(arg0_19.detailTip, var2_19)
		end

		setText(arg0_19.detailTip2, var4_19)

		for iter2_19 = #var5_19, arg0_19.detailItemList.childCount - 1 do
			Destroy(arg0_19.detailItemList:GetChild(iter2_19))
		end

		for iter3_19 = arg0_19.detailItemList.childCount, #var5_19 - 1 do
			cloneTplTo(arg0_19.detailItem, arg0_19.detailItemList)
		end

		for iter4_19 = 1, #var5_19 do
			local var13_19 = arg0_19.detailItemList:GetChild(iter4_19 - 1)

			updateDrop(var13_19, var5_19[iter4_19])

			local var14_19, var15_19 = contentWrap(var5_19[iter4_19]:getConfig("name"), 8, 2)

			if var14_19 then
				var15_19 = var15_19 .. "..."
			end

			setText(var13_19:Find("name"), var15_19)
			onButton(arg0_19, var13_19, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = var5_19[iter4_19]
				})
			end, SFX_PANEL)
		end
	end

	onButton(arg0_19, arg0_19:findTF("back_sign", arg0_19.detail), function()
		SetActive(arg0_19.detail, false)
		arg0_19:revertDetailBlur()
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19:findTF("button_container/button_cancel", arg0_19.detailWindow), function()
		SetActive(arg0_19.detail, false)
		arg0_19:revertDetailBlur()
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19:findTF("button_container/button_ok", arg0_19.detailWindow), arg1_19.onYes or function()
		return
	end, SFX_PANEL)
	setActive(arg0_19.detail, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_19.blurPanel)
end

function var0_0.bindDetailTF(arg0_26, arg1_26)
	arg0_26.detailWindow = arg1_26
	arg0_26.detailName = arg0_26:findTF("goods/name", arg0_26.detailWindow)
	arg0_26.detailIcon = arg0_26:findTF("goods/icon", arg0_26.detailWindow)
	arg0_26.detailIconTF = arg0_26.detailIcon:GetComponent(typeof(Image))
	arg0_26.detailRmb = arg0_26:findTF("prince_bg/contain/icon_rmb", arg0_26.detailWindow)
	arg0_26.detailGem = arg0_26:findTF("prince_bg/contain/icon_gem", arg0_26.detailWindow)
	arg0_26.detailPrice = arg0_26:findTF("prince_bg/contain/Text", arg0_26.detailWindow)
	arg0_26.detailTag = arg0_26:findTF("goods/tag", arg0_26.detailWindow)
	arg0_26.detailTags = {}

	table.insert(arg0_26.detailTags, arg0_26:findTF("hot", arg0_26.detailTag))
	table.insert(arg0_26.detailTags, arg0_26:findTF("new", arg0_26.detailTag))
	table.insert(arg0_26.detailTags, arg0_26:findTF("advice", arg0_26.detailTag))
	table.insert(arg0_26.detailTags, arg0_26:findTF("double", arg0_26.detailTag))
	table.insert(arg0_26.detailTags, arg0_26:findTF("discount", arg0_26.detailTag))

	arg0_26.detailTagDoubleTF = arg0_26:findTF("double", arg0_26.detailTag)
	arg0_26.detailTagAdviceTF = arg0_26:findTF("advice", arg0_26.detailTag)
	arg0_26.detailContain = arg0_26:findTF("container", arg0_26.detailWindow)

	if arg0_26.detailContain then
		arg0_26.extra = arg0_26:findTF("container/items", arg0_26.detailWindow)
		arg0_26.detailTip2 = arg0_26:findTF("Text", arg0_26.extra)
		arg0_26.detailItemList = arg0_26:findTF("scrollview/list", arg0_26.extra)
		arg0_26.normal = arg0_26:findTF("container/normal_items", arg0_26.detailWindow)
		arg0_26.detailTip = arg0_26:findTF("Text", arg0_26.normal)
		arg0_26.detailItem = arg0_26:findTF("item_tpl", arg0_26.normal)
		arg0_26.detailDescExtra = arg0_26:findTF("container/Text", arg0_26.detailWindow)
	end

	arg0_26.detailNormalTip = arg0_26:findTF("NormalTips", arg0_26.detailWindow)
end

function var0_0.revertDetailBlur(arg0_27)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_27.blurPanel, arg0_27._tf)
end

function var0_0.willExit(arg0_28)
	arg0_28:revertDetailBlur()
end

function var0_0.onBackPressed(arg0_29)
	return
end

return var0_0
