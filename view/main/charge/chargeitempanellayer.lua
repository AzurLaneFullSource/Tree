local var0_0 = class("ChargeItemPanelLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	local var0_1 = arg0_1.contextData.panelConfig
	local var1_1 = var0_1.extraItems and var0_1.extraItems or {}

	if arg0_1:ExistSkinExperienceItem(var1_1) then
		return "ChargeItem4SkinDiscountItemUI"
	else
		return "ChargeItemPanelUI"
	end
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
	arg0_7.detailName = arg0_7:findTF("goods/mask/name/Text", arg0_7.detailWindow)
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
	setScrollText(arg0_14.detailName, var1_14)

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

		if arg0_14:ExistSkinExperienceItem(var5_14) then
			arg0_14:UpdateSkinDiscountItemItems(var5_14)
		else
			arg0_14:UpdateItems(var5_14)
		end
	end
end

function var0_0.UpdateItems(arg0_16, arg1_16)
	for iter0_16 = #arg1_16, arg0_16.detailItemList.childCount - 1 do
		Destroy(arg0_16.detailItemList:GetChild(iter0_16))
	end

	for iter1_16 = arg0_16.detailItemList.childCount, #arg1_16 - 1 do
		cloneTplTo(arg0_16.detailItem, arg0_16.detailItemList)
	end

	for iter2_16 = 1, #arg1_16 do
		local var0_16 = arg0_16.detailItemList:GetChild(iter2_16 - 1)

		updateDrop(var0_16, arg1_16[iter2_16])

		local var1_16, var2_16 = contentWrap(arg1_16[iter2_16]:getConfig("name"), 8, 2)

		if var1_16 then
			var2_16 = var2_16 .. "..."
		end

		setText(arg0_16:findTF("name", var0_16), var2_16)
		onButton(arg0_16, var0_16, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = arg1_16[iter2_16]
			})
		end, SFX_PANEL)
	end
end

function var0_0.UpdateSkinDiscountItemItems(arg0_18, arg1_18)
	local var0_18, var1_18 = arg0_18:SplitItemAndSkinExperienceItem(arg1_18)

	arg0_18:UpdateItems(var0_18)

	local var2_18 = UIItemList.New(arg0_18:findTF("window/container/bonus_gift/bg/scrollview/list"), arg0_18:findTF("window/container/normal_items/item_tpl"))

	var2_18:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			arg0_18:UpdateItem(var1_18[arg1_19 + 1], arg2_19)
		end
	end)
	var2_18:align(#var1_18)
	setText(arg0_18:findTF("window/container/bonus_gift/bg/Text"), i18n("skin_discount_item_return_tip"))
	setText(arg0_18:findTF("window/container/bonus_gift/bg/label"), i18n("skin_discount_item_extra_bounds"))
end

function var0_0.UpdateItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = Drop.Create({
		DROP_TYPE_ITEM,
		arg1_20.id,
		arg1_20.count
	})

	updateDrop(arg2_20, var0_20)
	setText(arg0_20:findTF("name", arg2_20), shortenString(var0_20:getName(), 4))
	onButton(arg0_20, arg2_20, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = var0_20
		})
	end, SFX_PANEL)
end

function var0_0.SplitItemAndSkinExperienceItem(arg0_22, arg1_22)
	local var0_22 = {}
	local var1_22 = {}

	for iter0_22, iter1_22 in ipairs(arg1_22) do
		if var0_0.IsSkinExperienceItem(iter1_22) then
			table.insert(var1_22, iter1_22)
		else
			table.insert(var0_22, iter1_22)
		end
	end

	return var0_22, var1_22
end

function var0_0.IsSkinExperienceItem(arg0_23)
	local var0_23

	if not isa(arg0_23, Drop) then
		arg0_23 = Drop.New(arg0_23)
	end

	local var1_23 = arg0_23:getConfigTable()

	return var1_23 and var1_23.usage == ItemUsage.USAGE_SKIN_EXP
end

function var0_0.ExistSkinExperienceItem(arg0_24, arg1_24)
	return _.any(arg1_24, function(arg0_25)
		return var0_0.IsSkinExperienceItem(arg0_25)
	end)
end

return var0_0
