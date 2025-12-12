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
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	arg0_5.panelConfig = arg0_5.contextData.panelConfig
end

function var0_0.initUIText(arg0_6)
	local var0_6 = arg0_6._tf:Find("window/button_container/button_cancel/Image")
	local var1_6 = arg0_6._tf:Find("window/button_container/button_ok/Image")

	setText(var0_6, i18n("text_cancel"))
	setText(var1_6, i18n("text_buy"))
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7._tf:Find("back_sign")
	arg0_7.detailWindow = arg0_7._tf:Find("window")
	arg0_7.cancelBtn = arg0_7.detailWindow:Find("button_container/button_cancel")
	arg0_7.confirmBtn = arg0_7.detailWindow:Find("button_container/button_ok")
	arg0_7.detailName = arg0_7.detailWindow:Find("goods/mask/name/Text")
	arg0_7.detailIcon = arg0_7.detailWindow:Find("goods/icon")
	arg0_7.detailExtraDrop = arg0_7.detailWindow:Find("goods/extra_drop")
	arg0_7.detailRmb = arg0_7.detailWindow:Find("prince_bg/contain/icon_rmb")
	arg0_7.detailGem = arg0_7.detailWindow:Find("prince_bg/contain/icon_gem")
	arg0_7.detailGold = arg0_7.detailWindow:Find("prince_bg/contain/icon_gold")
	arg0_7.detailPrice = arg0_7.detailWindow:Find("prince_bg/contain/Text")
	arg0_7.detailTag = arg0_7.detailWindow:Find("goods/tag")
	arg0_7.detailTags = {}

	table.insert(arg0_7.detailTags, arg0_7.detailTag:Find("hot"))
	table.insert(arg0_7.detailTags, arg0_7.detailTag:Find("new"))
	table.insert(arg0_7.detailTags, arg0_7.detailTag:Find("advice"))
	table.insert(arg0_7.detailTags, arg0_7.detailTag:Find("double"))
	table.insert(arg0_7.detailTags, arg0_7.detailTag:Find("discount"))

	arg0_7.detailTagAdviceTF = arg0_7.detailTags[3]
	arg0_7.detailTagDoubleTF = arg0_7.detailTags[4]
	arg0_7.detailContain = arg0_7.detailWindow:Find("container")

	if arg0_7.detailContain then
		arg0_7.normal = arg0_7.detailContain:Find("normal_items")
		arg0_7.detailTip = arg0_7.normal:Find("Text")
		arg0_7.detailItem = arg0_7.normal:Find("item_tpl")
		arg0_7.extra = arg0_7.detailContain:Find("items")
		arg0_7.extraTip = arg0_7.extra:Find("Text")
		arg0_7.detailItemList = arg0_7.extra:Find("scrollview/list")
		arg0_7.extraDesc = arg0_7.detailContain:Find("Text")
	end

	arg0_7.detailNormalTip = arg0_7.detailWindow:Find("NormalTips")
	arg0_7.infoBtn = arg0_7.detailWindow:Find("prince_bg/info")
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.cancelBtn, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		local var0_11 = {}
		local var1_11 = arg0_8.panelConfig.limitArgs

		if var1_11 and type(var1_11) == "table" then
			local var2_11 = var1_11[1]

			if var2_11 and type(var2_11) == "table" and #var2_11 >= 2 then
				local var3_11, var4_11 = unpack(var2_11)
				local var5_11 = getProxy(PlayerProxy):getRawData()

				if var3_11 == "lv_70" and var4_11 <= var5_11.level then
					table.insert(var0_11, function(arg0_12)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("lv70_package_tip"),
							onYes = arg0_12
						})
					end)
				end
			end
		end

		for iter0_11, iter1_11 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING)) do
			if not arg0_8.panelConfig.isChargeType then
				break
			end

			if not iter1_11:isEnd() and table.contains(iter1_11:getConfig("config_data")[1], arg0_8.panelConfig.commodity.id) then
				local var6_11 = Drop.New({
					type = DROP_TYPE_VITEM,
					id = iter1_11:GetConfigClientSetting("item_id")
				})
				local var7_11 = getProxy(ActivityProxy):getActivityById(var6_11:getConfig("link_id"))

				if var7_11 and not var7_11:isEnd() then
					assert(var7_11:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SKIN_COUPON)

					if iter1_11:GetConfigClientSetting("gift_tip")[arg0_8.panelConfig.commodity.id][1] ~= "" then
						local var8_11 = iter1_11:GetConfigClientSetting("gift_tip")[arg0_8.panelConfig.commodity.id][2]
						local var9_11 = #pg.item_data_statistics[var8_11].usage_arg[3]
						local var10_11 = #underscore.filter(pg.item_data_statistics[var8_11].usage_arg[3], function(arg0_13)
							return getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_13)
						end)

						table.insert(var0_11, function(arg0_14)
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n(iter1_11:GetConfigClientSetting("gift_tip")[arg0_8.panelConfig.commodity.id][1], var10_11, var9_11),
								onYes = arg0_14
							})
						end)
					else
						table.insert(var0_11, function(arg0_15)
							arg0_15()
						end)
					end
				end
			end
		end

		seriesAsync(var0_11, function()
			existCall(arg0_8.panelConfig.onYes)
			arg0_8:closeView()
		end)
	end, SFX_PANEL)
end

function var0_0.updatePanel(arg0_17)
	local var0_17 = arg0_17.panelConfig.icon
	local var1_17 = arg0_17.panelConfig.name and arg0_17.panelConfig.name or ""
	local var2_17 = arg0_17.panelConfig.tipBonus or ""
	local var3_17 = arg0_17.panelConfig.bonusItem
	local var4_17 = arg0_17.panelConfig.tipExtra and arg0_17.panelConfig.tipExtra or ""
	local var5_17 = arg0_17.panelConfig.extraItems and arg0_17.panelConfig.extraItems or {}
	local var6_17 = arg0_17.panelConfig.price and arg0_17.panelConfig.price or 0
	local var7_17 = arg0_17.panelConfig.isChargeType
	local var8_17 = arg0_17.panelConfig.isLocalPrice
	local var9_17 = arg0_17.panelConfig.isMonthCard
	local var10_17 = arg0_17.panelConfig.tagType
	local var11_17 = arg0_17.panelConfig.normalTip
	local var12_17 = arg0_17.panelConfig.extraDrop
	local var13_17 = arg0_17.panelConfig.isForceGold
	local var14_17 = arg0_17.panelConfig.infoTip and arg0_17.panelConfig.infoTip or ""

	if arg0_17.detailNormalTip then
		setActive(arg0_17.detailNormalTip, var11_17)
	end

	if arg0_17.detailContain then
		setActive(arg0_17.detailContain, not var11_17)
	end

	if var11_17 then
		if arg0_17.detailNormalTip:GetComponent("Text") then
			setText(arg0_17.detailNormalTip, var11_17)
		else
			setButtonText(arg0_17.detailNormalTip, var11_17)
		end
	end

	setActive(arg0_17.detailTag, var10_17 > 0)

	if var10_17 > 0 then
		for iter0_17, iter1_17 in ipairs(arg0_17.detailTags) do
			setActive(iter1_17, iter0_17 == var10_17)
		end
	end

	GetImageSpriteFromAtlasAsync(var0_17, "", arg0_17.detailIcon, false)
	setScrollText(arg0_17.detailName, var1_17)

	if arg0_17.detailExtraDrop then
		setActive(arg0_17.detailExtraDrop, var12_17)

		if var12_17 then
			setText(arg0_17.detailExtraDrop:Find("Text"), i18n("battlepass_pay_acquire") .. "\n" .. var12_17.count .. "x")
			updateDrop(arg0_17.detailExtraDrop:Find("item/IconTpl"), setmetatable({
				count = 1
			}, {
				__index = var12_17
			}))
		end
	end

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0_17.detailRmb, var7_17 and not var8_17)
	else
		setActive(arg0_17.detailRmb, var7_17)
	end

	setActive(arg0_17.detailGem, not var7_17 and not var13_17)
	setActive(arg0_17.detailGold, not var7_17 and not isActive(arg0_17.detailRmb) and not isActive(arg0_17.detailGem))
	setText(arg0_17.detailPrice, var6_17)

	if arg0_17.extraDesc ~= nil then
		local var15_17 = arg0_17.panelConfig.descExtra or ""

		setActive(arg0_17.extraDesc, #var15_17 > 0)
		setText(arg0_17.extraDesc, var15_17)
	end

	if arg0_17.detailContain then
		setActive(arg0_17.normal, var9_17)

		if var9_17 then
			updateDrop(arg0_17.detailItem, var3_17)
			onButton(arg0_17, arg0_17.detailItem, function()
				return
			end, SFX_PANEL)

			local var16_17, var17_17 = contentWrap(var3_17:getConfig("name"), 10, 2)

			if var16_17 then
				var17_17 = var17_17 .. "..."
			end

			setText(arg0_17.detailItem:Find("name"), var17_17)
			setText(arg0_17.detailTip, var2_17)
		end

		setText(arg0_17.extraTip, var4_17)

		if arg0_17:ExistSkinExperienceItem(var5_17) then
			arg0_17:UpdateSkinDiscountItemItems(var5_17)
		else
			arg0_17:UpdateItems(var5_17)
		end
	end

	local var18_17 = var14_17 ~= ""

	setActive(arg0_17.infoBtn, var18_17)

	if var18_17 then
		onButton(arg0_17, arg0_17.infoBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip[var14_17].tip
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg0_17.infoBtn)
	end
end

function var0_0.UpdateItems(arg0_20, arg1_20)
	for iter0_20 = #arg1_20, arg0_20.detailItemList.childCount - 1 do
		Destroy(arg0_20.detailItemList:GetChild(iter0_20))
	end

	for iter1_20 = arg0_20.detailItemList.childCount, #arg1_20 - 1 do
		cloneTplTo(arg0_20.detailItem, arg0_20.detailItemList)
	end

	for iter2_20 = 1, #arg1_20 do
		local var0_20 = arg0_20.detailItemList:GetChild(iter2_20 - 1)

		updateDrop(var0_20, arg1_20[iter2_20])

		local var1_20, var2_20 = contentWrap(arg1_20[iter2_20]:getConfig("name"), 8, 2)

		if var1_20 then
			var2_20 = var2_20 .. "..."
		end

		setText(var0_20:Find("name"), var2_20)
		onButton(arg0_20, var0_20, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = arg1_20[iter2_20]
			})
		end, SFX_PANEL)
	end
end

function var0_0.UpdateSkinDiscountItemItems(arg0_22, arg1_22)
	local var0_22, var1_22 = arg0_22:SplitItemAndSkinExperienceItem(arg1_22)

	arg0_22:UpdateItems(var0_22)

	local var2_22 = UIItemList.New(arg0_22._tf:Find("window/container/bonus_gift/bg/scrollview/list"), arg0_22._tf:Find("window/container/normal_items/item_tpl"))

	var2_22:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			arg0_22:UpdateItem(var1_22[arg1_23 + 1], arg2_23)
		end
	end)
	var2_22:align(#var1_22)
	setText(arg0_22._tf:Find("window/container/bonus_gift/bg/Text"), i18n("skin_discount_item_return_tip"))
	setText(arg0_22._tf:Find("window/container/bonus_gift/bg/label"), i18n("skin_discount_item_extra_bounds"))
end

function var0_0.UpdateItem(arg0_24, arg1_24, arg2_24)
	local var0_24 = Drop.Create({
		DROP_TYPE_ITEM,
		arg1_24.id,
		arg1_24.count
	})

	updateDrop(arg2_24, var0_24)
	setText(arg2_24:Find("name"), shortenString(var0_24:getName(), 4))
	onButton(arg0_24, arg2_24, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = var0_24
		})
	end, SFX_PANEL)
end

function var0_0.SplitItemAndSkinExperienceItem(arg0_26, arg1_26)
	local var0_26 = {}
	local var1_26 = {}

	for iter0_26, iter1_26 in ipairs(arg1_26) do
		if var0_0.IsSkinExperienceItem(iter1_26) then
			table.insert(var1_26, iter1_26)
		else
			table.insert(var0_26, iter1_26)
		end
	end

	return var0_26, var1_26
end

function var0_0.IsSkinExperienceItem(arg0_27)
	local var0_27

	if not isa(arg0_27, Drop) then
		arg0_27 = Drop.New(arg0_27)
	end

	local var1_27 = arg0_27:getConfigTable()

	return var1_27 and var1_27.usage == ItemUsage.USAGE_SKIN_EXP
end

function var0_0.ExistSkinExperienceItem(arg0_28, arg1_28)
	return _.any(arg1_28, function(arg0_29)
		return var0_0.IsSkinExperienceItem(arg0_29)
	end)
end

return var0_0
