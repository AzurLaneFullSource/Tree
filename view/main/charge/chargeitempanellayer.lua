local var0_0 = class("ChargeItemPanelLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeItemPanelUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initUIText()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updatePanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	arg0_5.panelConfig = arg0_5.contextData.panelConfig
end

function var0_0.initUIText(arg0_6)
	local var0_6 = arg0_6:findTF("window/button_container/button_cancel/Image")
	local var1_6 = arg0_6:findTF("window/button_container/button_ok/Image")

	setText(var0_6, i18n("text_cancel"))
	setText(var1_6, i18n("text_buy"))
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("back_sign")
	arg0_7.detailWindow = arg0_7:findTF("window")
	arg0_7.cancelBtn = arg0_7:findTF("button_container/button_cancel", arg0_7.detailWindow)
	arg0_7.confirmBtn = arg0_7:findTF("button_container/button_ok", arg0_7.detailWindow)
	arg0_7.detailName = arg0_7:findTF("goods/name", arg0_7.detailWindow)
	arg0_7.detailIcon = arg0_7:findTF("goods/icon", arg0_7.detailWindow)
	arg0_7.detailExtraDrop = arg0_7:findTF("goods/extra_drop", arg0_7.detailWindow)
	arg0_7.detailRmb = arg0_7:findTF("prince_bg/contain/icon_rmb", arg0_7.detailWindow)
	arg0_7.detailGem = arg0_7:findTF("prince_bg/contain/icon_gem", arg0_7.detailWindow)
	arg0_7.detailGold = arg0_7:findTF("prince_bg/contain/icon_gold", arg0_7.detailWindow)
	arg0_7.detailPrice = arg0_7:findTF("prince_bg/contain/Text", arg0_7.detailWindow)
	arg0_7.detailTag = arg0_7:findTF("goods/tag", arg0_7.detailWindow)
	arg0_7.detailTags = {}

	table.insert(arg0_7.detailTags, arg0_7:findTF("hot", arg0_7.detailTag))
	table.insert(arg0_7.detailTags, arg0_7:findTF("new", arg0_7.detailTag))
	table.insert(arg0_7.detailTags, arg0_7:findTF("advice", arg0_7.detailTag))
	table.insert(arg0_7.detailTags, arg0_7:findTF("double", arg0_7.detailTag))
	table.insert(arg0_7.detailTags, arg0_7:findTF("discount", arg0_7.detailTag))

	arg0_7.detailTagAdviceTF = arg0_7.detailTags[3]
	arg0_7.detailTagDoubleTF = arg0_7.detailTags[4]
	arg0_7.detailContain = arg0_7:findTF("container", arg0_7.detailWindow)

	if arg0_7.detailContain then
		arg0_7.normal = arg0_7:findTF("normal_items", arg0_7.detailContain)
		arg0_7.detailTip = arg0_7:findTF("Text", arg0_7.normal)
		arg0_7.detailItem = arg0_7:findTF("item_tpl", arg0_7.normal)
		arg0_7.extra = arg0_7:findTF("items", arg0_7.detailContain)
		arg0_7.extraTip = arg0_7:findTF("Text", arg0_7.extra)
		arg0_7.detailItemList = arg0_7:findTF("scrollview/list", arg0_7.extra)
		arg0_7.extraDesc = arg0_7:findTF("Text", arg0_7.detailContain)
	end

	arg0_7.detailNormalTip = arg0_7:findTF("NormalTips", arg0_7.detailWindow)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.cancelBtn, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		local function var0_11()
			if arg0_8.panelConfig.onYes then
				arg0_8.panelConfig.onYes()
				arg0_8:closeView()
			end
		end

		local var1_11 = arg0_8.panelConfig.limitArgs

		if var1_11 and type(var1_11) == "table" then
			local var2_11 = var1_11[1]

			if var2_11 and type(var2_11) == "table" and #var2_11 >= 2 then
				local var3_11 = var2_11[1]
				local var4_11 = var2_11[2]
				local var5_11 = getProxy(PlayerProxy):getRawData()

				if var3_11 == "lv_70" and var4_11 <= var5_11.level then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("lv70_package_tip"),
						onYes = function()
							var0_11()
						end
					})

					return
				end
			end
		end

		var0_11()
	end, SFX_PANEL)
end

function var0_0.updatePanel(arg0_14)
	local var0_14 = arg0_14.panelConfig.icon
	local var1_14 = arg0_14.panelConfig.name and arg0_14.panelConfig.name or ""
	local var2_14 = arg0_14.panelConfig.tipBonus or ""
	local var3_14 = arg0_14.panelConfig.bonusItem
	local var4_14 = arg0_14.panelConfig.tipExtra and arg0_14.panelConfig.tipExtra or ""
	local var5_14 = arg0_14.panelConfig.extraItems and arg0_14.panelConfig.extraItems or {}
	local var6_14 = arg0_14.panelConfig.price and arg0_14.panelConfig.price or 0
	local var7_14 = arg0_14.panelConfig.isChargeType
	local var8_14 = arg0_14.panelConfig.isLocalPrice
	local var9_14 = arg0_14.panelConfig.isMonthCard
	local var10_14 = arg0_14.panelConfig.tagType
	local var11_14 = arg0_14.panelConfig.normalTip
	local var12_14 = arg0_14.panelConfig.extraDrop
	local var13_14 = arg0_14.panelConfig.isForceGold

	if arg0_14.detailNormalTip then
		setActive(arg0_14.detailNormalTip, var11_14)
	end

	if arg0_14.detailContain then
		setActive(arg0_14.detailContain, not var11_14)
	end

	if var11_14 then
		if arg0_14.detailNormalTip:GetComponent("Text") then
			setText(arg0_14.detailNormalTip, var11_14)
		else
			setButtonText(arg0_14.detailNormalTip, var11_14)
		end
	end

	setActive(arg0_14.detailTag, var10_14 > 0)

	if var10_14 > 0 then
		for iter0_14, iter1_14 in ipairs(arg0_14.detailTags) do
			setActive(iter1_14, iter0_14 == var10_14)
		end
	end

	GetImageSpriteFromAtlasAsync(var0_14, "", arg0_14.detailIcon, false)
	setText(arg0_14.detailName, var1_14)

	if arg0_14.detailExtraDrop then
		setActive(arg0_14.detailExtraDrop, var12_14)

		if var12_14 then
			setText(arg0_14:findTF("Text", arg0_14.detailExtraDrop), i18n("battlepass_pay_acquire") .. "\n" .. var12_14.count .. "x")
			updateDrop(arg0_14:findTF("item/IconTpl", arg0_14.detailExtraDrop), setmetatable({
				count = 1
			}, {
				__index = var12_14
			}))
		end
	end

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0_14.detailRmb, var7_14 and not var8_14)
	else
		setActive(arg0_14.detailRmb, var7_14)
	end

	setActive(arg0_14.detailGem, not var7_14 and not var13_14)
	setActive(arg0_14.detailGold, not var7_14 and not isActive(arg0_14.detailRmb) and not isActive(arg0_14.detailGem))
	setText(arg0_14.detailPrice, var6_14)

	if arg0_14.extraDesc ~= nil then
		local var14_14 = arg0_14.panelConfig.descExtra or ""

		setActive(arg0_14.extraDesc, #var14_14 > 0)
		setText(arg0_14.extraDesc, var14_14)
	end

	if arg0_14.detailContain then
		setActive(arg0_14.normal, var9_14)

		if var9_14 then
			updateDrop(arg0_14.detailItem, var3_14)
			onButton(arg0_14, arg0_14.detailItem, function()
				return
			end, SFX_PANEL)

			local var15_14, var16_14 = contentWrap(var3_14:getConfig("name"), 10, 2)

			if var15_14 then
				var16_14 = var16_14 .. "..."
			end

			setText(arg0_14:findTF("name", arg0_14.detailItem), var16_14)
			setText(arg0_14.detailTip, var2_14)
		end

		setText(arg0_14.extraTip, var4_14)

		for iter2_14 = #var5_14, arg0_14.detailItemList.childCount - 1 do
			Destroy(arg0_14.detailItemList:GetChild(iter2_14))
		end

		for iter3_14 = arg0_14.detailItemList.childCount, #var5_14 - 1 do
			cloneTplTo(arg0_14.detailItem, arg0_14.detailItemList)
		end

		for iter4_14 = 1, #var5_14 do
			local var17_14 = arg0_14.detailItemList:GetChild(iter4_14 - 1)

			updateDrop(var17_14, var5_14[iter4_14])

			local var18_14, var19_14 = contentWrap(var5_14[iter4_14]:getConfig("name"), 8, 2)

			if var18_14 then
				var19_14 = var19_14 .. "..."
			end

			setText(arg0_14:findTF("name", var17_14), var19_14)
			onButton(arg0_14, var17_14, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = var5_14[iter4_14]
				})
			end, SFX_PANEL)
		end
	end
end

return var0_0
