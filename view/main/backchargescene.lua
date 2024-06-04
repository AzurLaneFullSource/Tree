local var0 = class("ChargeScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "BackChargeUI"
end

function var0.init(arg0)
	return
end

function var0.didEnter(arg0)
	arg0.diamondPanel = findTF(arg0._tf, "frame/viewContainer/diamondPanel")
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.detail = arg0:findTF("detail", arg0.blurPanel)
	arg0.damondItems = {}

	setText(findTF(arg0._tf, "frame/viewContainer/leftPanel/desc"), i18n("Supplement_pay2"))
	setText(findTF(arg0._tf, "tip"), i18n("Supplement_pay5"))
	arg0:initDamonds()
	arg0:refundUpdate()
end

function var0.refundUpdate(arg0)
	arg0:updateDamondsData()
	arg0:sortDamondItems()

	if #arg0.tempDamondVOs <= 0 then
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

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.setChargedList(arg0, arg1)
	arg0.chargedList = arg1
end

function var0.initDamonds(arg0)
	arg0.diamondUIItemList = arg0:initDiamondList(arg0.diamondPanel)
end

function var0.confirm(arg0, arg1)
	if not arg1 then
		return
	end

	arg0:emit(BackChargeMediator.CHARGE, arg1.id)
end

function var0.initDiamondList(arg0, arg1)
	local var0 = arg0:findTF("content", arg1)
	local var1 = arg0:findTF("ItemTpl", arg1)

	local function var2(arg0)
		local var0 = BackChargeDiamondCard.New(arg0, arg0)

		onButton(arg0, var0.tr, function()
			arg0:confirm(var0.goods)
		end, SFX_PANEL)

		arg0.damondItems[arg0] = var0
	end

	local function var3(arg0, arg1)
		local var0 = arg0.damondItems[arg1]

		if not var0 then
			var2(arg1)

			var0 = arg0.damondItems[arg1]
		end

		local var1 = arg0.tempDamondVOs[arg0 + 1]

		if var1 then
			var0:update(var1, arg0.player, arg0.firstChargeIds)
		end
	end

	local var4 = UIItemList.New(var0, var1)

	var4:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			var2(go(arg2))
		elseif arg0 == UIItemList.EventUpdate then
			var3(arg1, go(arg2))
		end
	end)

	return var4
end

function var0.updateDamondsData(arg0)
	local var0 = pg.pay_data_display

	arg0.damondItemVOs = {}

	local var1 = getProxy(UserProxy):getData()
	local var2 = getProxy(ServerProxy)
	local var3 = getProxy(PlayerProxy):getRefundInfo()
	local var4 = var2:getLastServer(var1.uid)

	var3 = var3 or {}

	for iter0 = 1, #var3 do
		local var5 = Goods.Create({
			shop_id = var3[iter0].shopId
		}, Goods.TYPE_CHARGE)

		var5.buyTime = var3[iter0].buyTime
		var5.refundTime = var3[iter0].refundTime

		table.insert(arg0.damondItemVOs, var5)
	end
end

function var0.sortDamondItems(arg0)
	if arg0.damondItemVOs == nil then
		return
	end

	arg0.tempDamondVOs = {}

	for iter0, iter1 in ipairs(arg0.damondItemVOs) do
		if iter1:isChargeType() then
			iter1:updateBuyCount(arg0:getBuyCount(arg0.chargedList, iter1.id))
			table.insert(arg0.tempDamondVOs, iter1)
		end
	end

	table.sort(arg0.tempDamondVOs, function(arg0, arg1)
		local var0 = not table.contains(arg0.firstChargeIds, arg0.id) and arg0:firstPayDouble() and 1 or 0
		local var1 = not table.contains(arg0.firstChargeIds, arg1.id) and arg1:firstPayDouble() and 1 or 0
		local var2 = 0
		local var3 = 0
		local var4

		if var2 ~= var3 then
			return var2 < var3
		end

		local var5 = arg0:getConfig("tag") == 2 and 1 or 0
		local var6 = arg1:getConfig("tag") == 2 and 1 or 0

		if var0 == var1 and var5 == var6 then
			return arg0.id < arg1.id
		else
			return var1 < var0 or var0 == var1 and var6 < var5
		end
	end)

	if page == var0.TYPE_DIAMOND then
		arg0.diamondUIItemList:align(#arg0.tempDamondVOs)
	elseif page == var0.TYPE_GIFT then
		arg0.giftRect:SetTotalCount(#arg0.tempDamondVOs, arg0.giftRect.value)
	end
end

function var0.getBuyCount(arg0, arg1, arg2)
	if not arg1 then
		return 0
	end

	local var0 = arg1[arg2]

	return var0 and var0.buyCount or 0
end

function var0.showItemDetail(arg0, arg1)
	local var0 = arg1.icon
	local var1 = arg1.name and arg1.name or ""
	local var2 = arg1.tipBonus or ""
	local var3 = arg1.bonusItem
	local var4 = arg1.tipExtra and arg1.tipExtra or ""
	local var5 = arg1.extraItems and arg1.extraItems or {}
	local var6 = arg1.price and arg1.price or 0
	local var7 = arg1.isChargeType
	local var8 = arg1.isMonthCard
	local var9 = arg1.tagType
	local var10 = arg1.normalTip

	setActive(arg0:findTF("window2", arg0.detail), var10)
	setActive(arg0:findTF("window", arg0.detail), not var10)
	arg0:bindDetailTF(var10 and arg0:findTF("window2", arg0.detail) or arg0:findTF("window", arg0.detail))

	if arg0.detailNormalTip then
		setActive(arg0.detailNormalTip, var10)
	end

	if arg0.detailContain then
		setActive(arg0.detailContain, not var10)
	end

	if var10 then
		if arg0.detailNormalTip:GetComponent("Text") then
			setText(arg0.detailNormalTip, var10)
		else
			setButtonText(arg0.detailNormalTip, var10)
		end
	end

	setActive(arg0.detailTag, var9 > 0)

	if var9 > 0 then
		for iter0, iter1 in ipairs(arg0.detailTags) do
			setActive(iter1, iter0 == var9)
		end
	end

	arg0.detailIconTF.sprite = GetSpriteFromAtlas("chargeicon/1", "")

	LoadSpriteAsync(var0, function(arg0)
		if arg0 then
			arg0.detailIconTF.sprite = arg0
		end
	end)
	setText(arg0.detailName, var1)
	setActive(arg0.detailRmb, var7)
	setActive(arg0.detailGem, not var7)
	setText(arg0.detailPrice, var6)

	if arg0.detailDescExtra ~= nil then
		setActive(arg0.detailDescExtra, arg1.descExtra and arg1.descExtra ~= "")
		setText(arg0.detailDescExtra, arg1.descExtra or "")
	end

	if arg0.detailContain then
		SetActive(arg0.normal, var8)

		if var8 then
			updateDrop(arg0.detailItem, var3)
			onButton(arg0, arg0.detailItem, function()
				arg0:emit(var0.ON_DROP, var3)
			end, SFX_PANEL)

			local var11, var12 = contentWrap(var3:getConfig("name"), 10, 2)

			if var11 then
				var12 = var12 .. "..."
			end

			setText(arg0.detailItem:Find("name"), var12)
			setText(arg0.detailTip, var2)
		end

		setText(arg0.detailTip2, var4)

		for iter2 = #var5, arg0.detailItemList.childCount - 1 do
			Destroy(arg0.detailItemList:GetChild(iter2))
		end

		for iter3 = arg0.detailItemList.childCount, #var5 - 1 do
			cloneTplTo(arg0.detailItem, arg0.detailItemList)
		end

		for iter4 = 1, #var5 do
			local var13 = arg0.detailItemList:GetChild(iter4 - 1)

			updateDrop(var13, var5[iter4])

			local var14, var15 = contentWrap(var5[iter4]:getConfig("name"), 8, 2)

			if var14 then
				var15 = var15 .. "..."
			end

			setText(var13:Find("name"), var15)
			onButton(arg0, var13, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = var5[iter4]
				})
			end, SFX_PANEL)
		end
	end

	onButton(arg0, arg0:findTF("back_sign", arg0.detail), function()
		SetActive(arg0.detail, false)
		arg0:revertDetailBlur()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("button_container/button_cancel", arg0.detailWindow), function()
		SetActive(arg0.detail, false)
		arg0:revertDetailBlur()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("button_container/button_ok", arg0.detailWindow), arg1.onYes or function()
		return
	end, SFX_PANEL)
	setActive(arg0.detail, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.blurPanel)
end

function var0.bindDetailTF(arg0, arg1)
	arg0.detailWindow = arg1
	arg0.detailName = arg0:findTF("goods/name", arg0.detailWindow)
	arg0.detailIcon = arg0:findTF("goods/icon", arg0.detailWindow)
	arg0.detailIconTF = arg0.detailIcon:GetComponent(typeof(Image))
	arg0.detailRmb = arg0:findTF("prince_bg/contain/icon_rmb", arg0.detailWindow)
	arg0.detailGem = arg0:findTF("prince_bg/contain/icon_gem", arg0.detailWindow)
	arg0.detailPrice = arg0:findTF("prince_bg/contain/Text", arg0.detailWindow)
	arg0.detailTag = arg0:findTF("goods/tag", arg0.detailWindow)
	arg0.detailTags = {}

	table.insert(arg0.detailTags, arg0:findTF("hot", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("new", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("advice", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("double", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("discount", arg0.detailTag))

	arg0.detailTagDoubleTF = arg0:findTF("double", arg0.detailTag)
	arg0.detailTagAdviceTF = arg0:findTF("advice", arg0.detailTag)
	arg0.detailContain = arg0:findTF("container", arg0.detailWindow)

	if arg0.detailContain then
		arg0.extra = arg0:findTF("container/items", arg0.detailWindow)
		arg0.detailTip2 = arg0:findTF("Text", arg0.extra)
		arg0.detailItemList = arg0:findTF("scrollview/list", arg0.extra)
		arg0.normal = arg0:findTF("container/normal_items", arg0.detailWindow)
		arg0.detailTip = arg0:findTF("Text", arg0.normal)
		arg0.detailItem = arg0:findTF("item_tpl", arg0.normal)
		arg0.detailDescExtra = arg0:findTF("container/Text", arg0.detailWindow)
	end

	arg0.detailNormalTip = arg0:findTF("NormalTips", arg0.detailWindow)
end

function var0.revertDetailBlur(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.blurPanel, arg0._tf)
end

function var0.willExit(arg0)
	arg0:revertDetailBlur()
end

function var0.onBackPressed(arg0)
	return
end

return var0
