local var0 = class("ChargeItemPanelLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ChargeItemPanelUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initUIText()
end

function var0.didEnter(arg0)
	arg0:updatePanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.panelConfig = arg0.contextData.panelConfig
end

function var0.initUIText(arg0)
	local var0 = arg0:findTF("window/button_container/button_cancel/Image")
	local var1 = arg0:findTF("window/button_container/button_ok/Image")

	setText(var0, i18n("text_cancel"))
	setText(var1, i18n("text_buy"))
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("back_sign")
	arg0.detailWindow = arg0:findTF("window")
	arg0.cancelBtn = arg0:findTF("button_container/button_cancel", arg0.detailWindow)
	arg0.confirmBtn = arg0:findTF("button_container/button_ok", arg0.detailWindow)
	arg0.detailName = arg0:findTF("goods/name", arg0.detailWindow)
	arg0.detailIcon = arg0:findTF("goods/icon", arg0.detailWindow)
	arg0.detailExtraDrop = arg0:findTF("goods/extra_drop", arg0.detailWindow)
	arg0.detailRmb = arg0:findTF("prince_bg/contain/icon_rmb", arg0.detailWindow)
	arg0.detailGem = arg0:findTF("prince_bg/contain/icon_gem", arg0.detailWindow)
	arg0.detailGold = arg0:findTF("prince_bg/contain/icon_gold", arg0.detailWindow)
	arg0.detailPrice = arg0:findTF("prince_bg/contain/Text", arg0.detailWindow)
	arg0.detailTag = arg0:findTF("goods/tag", arg0.detailWindow)
	arg0.detailTags = {}

	table.insert(arg0.detailTags, arg0:findTF("hot", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("new", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("advice", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("double", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("discount", arg0.detailTag))

	arg0.detailTagAdviceTF = arg0.detailTags[3]
	arg0.detailTagDoubleTF = arg0.detailTags[4]
	arg0.detailContain = arg0:findTF("container", arg0.detailWindow)

	if arg0.detailContain then
		arg0.normal = arg0:findTF("normal_items", arg0.detailContain)
		arg0.detailTip = arg0:findTF("Text", arg0.normal)
		arg0.detailItem = arg0:findTF("item_tpl", arg0.normal)
		arg0.extra = arg0:findTF("items", arg0.detailContain)
		arg0.extraTip = arg0:findTF("Text", arg0.extra)
		arg0.detailItemList = arg0:findTF("scrollview/list", arg0.extra)
		arg0.extraDesc = arg0:findTF("Text", arg0.detailContain)
	end

	arg0.detailNormalTip = arg0:findTF("NormalTips", arg0.detailWindow)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		local function var0()
			if arg0.panelConfig.onYes then
				arg0.panelConfig.onYes()
				arg0:closeView()
			end
		end

		local var1 = arg0.panelConfig.limitArgs

		if var1 and type(var1) == "table" then
			local var2 = var1[1]

			if var2 and type(var2) == "table" and #var2 >= 2 then
				local var3 = var2[1]
				local var4 = var2[2]
				local var5 = getProxy(PlayerProxy):getRawData()

				if var3 == "lv_70" and var4 <= var5.level then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("lv70_package_tip"),
						onYes = function()
							var0()
						end
					})

					return
				end
			end
		end

		var0()
	end, SFX_PANEL)
end

function var0.updatePanel(arg0)
	local var0 = arg0.panelConfig.icon
	local var1 = arg0.panelConfig.name and arg0.panelConfig.name or ""
	local var2 = arg0.panelConfig.tipBonus or ""
	local var3 = arg0.panelConfig.bonusItem
	local var4 = arg0.panelConfig.tipExtra and arg0.panelConfig.tipExtra or ""
	local var5 = arg0.panelConfig.extraItems and arg0.panelConfig.extraItems or {}
	local var6 = arg0.panelConfig.price and arg0.panelConfig.price or 0
	local var7 = arg0.panelConfig.isChargeType
	local var8 = arg0.panelConfig.isLocalPrice
	local var9 = arg0.panelConfig.isMonthCard
	local var10 = arg0.panelConfig.tagType
	local var11 = arg0.panelConfig.normalTip
	local var12 = arg0.panelConfig.extraDrop
	local var13 = arg0.panelConfig.isForceGold

	if arg0.detailNormalTip then
		setActive(arg0.detailNormalTip, var11)
	end

	if arg0.detailContain then
		setActive(arg0.detailContain, not var11)
	end

	if var11 then
		if arg0.detailNormalTip:GetComponent("Text") then
			setText(arg0.detailNormalTip, var11)
		else
			setButtonText(arg0.detailNormalTip, var11)
		end
	end

	setActive(arg0.detailTag, var10 > 0)

	if var10 > 0 then
		for iter0, iter1 in ipairs(arg0.detailTags) do
			setActive(iter1, iter0 == var10)
		end
	end

	GetImageSpriteFromAtlasAsync(var0, "", arg0.detailIcon, false)
	setText(arg0.detailName, var1)

	if arg0.detailExtraDrop then
		setActive(arg0.detailExtraDrop, var12)

		if var12 then
			setText(arg0:findTF("Text", arg0.detailExtraDrop), i18n("battlepass_pay_acquire") .. "\n" .. var12.count .. "x")
			updateDrop(arg0:findTF("item/IconTpl", arg0.detailExtraDrop), setmetatable({
				count = 1
			}, {
				__index = var12
			}))
		end
	end

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0.detailRmb, var7 and not var8)
	else
		setActive(arg0.detailRmb, var7)
	end

	setActive(arg0.detailGem, not var7 and not var13)
	setActive(arg0.detailGold, not var7 and not isActive(arg0.detailRmb) and not isActive(arg0.detailGem))
	setText(arg0.detailPrice, var6)

	if arg0.extraDesc ~= nil then
		local var14 = arg0.panelConfig.descExtra or ""

		setActive(arg0.extraDesc, #var14 > 0)
		setText(arg0.extraDesc, var14)
	end

	if arg0.detailContain then
		setActive(arg0.normal, var9)

		if var9 then
			updateDrop(arg0.detailItem, var3)
			onButton(arg0, arg0.detailItem, function()
				return
			end, SFX_PANEL)

			local var15, var16 = contentWrap(var3:getConfig("name"), 10, 2)

			if var15 then
				var16 = var16 .. "..."
			end

			setText(arg0:findTF("name", arg0.detailItem), var16)
			setText(arg0.detailTip, var2)
		end

		setText(arg0.extraTip, var4)

		for iter2 = #var5, arg0.detailItemList.childCount - 1 do
			Destroy(arg0.detailItemList:GetChild(iter2))
		end

		for iter3 = arg0.detailItemList.childCount, #var5 - 1 do
			cloneTplTo(arg0.detailItem, arg0.detailItemList)
		end

		for iter4 = 1, #var5 do
			local var17 = arg0.detailItemList:GetChild(iter4 - 1)

			updateDrop(var17, var5[iter4])

			local var18, var19 = contentWrap(var5[iter4]:getConfig("name"), 8, 2)

			if var18 then
				var19 = var19 .. "..."
			end

			setText(arg0:findTF("name", var17), var19)
			onButton(arg0, var17, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = var5[iter4]
				})
			end, SFX_PANEL)
		end
	end
end

return var0
