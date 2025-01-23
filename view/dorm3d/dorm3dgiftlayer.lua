local var0_0 = class("Dorm3dGiftLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dGiftUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2._tf:Find("btn_back")

	onButton(arg0_2, var0_2, function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.rtGiftPanel = arg0_2._tf:Find("gift_panel")

	for iter0_2, iter1_2 in ipairs({
		"all",
		"normal",
		"pro"
	}) do
		onToggle(arg0_2, arg0_2.rtGiftPanel:Find("content/toggles/" .. iter1_2), function(arg0_4)
			if arg0_4 then
				if arg0_2.afterFirst then
					quickPlayAnimation(arg0_2.rtGiftPanel, "anim_dorm3d_giftui_change")
				else
					arg0_2.afterFirst = true
				end

				arg0_2:UpdateSelectToggle(iter1_2)
			end
		end, SFX_PANEL)
	end

	local var1_2 = arg0_2.rtGiftPanel:Find("content/view/container")

	arg0_2.giftItemList = UIItemList.New(var1_2, var1_2:Find("tpl"))

	arg0_2.giftItemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			arg0_2:UpdateGift(arg2_5, arg0_2.filterGiftIds[arg1_5])
		end
	end)

	arg0_2.showedGiftRecords = {}

	onScroll(arg0_2, var1_2, function(arg0_6)
		arg0_2:OnGiftListScroll(arg0_6)
	end)

	arg0_2.btnConfirm = arg0_2.rtGiftPanel:Find("bottom/btn_confirm")

	onButton(arg0_2, arg0_2.btnConfirm, function()
		arg0_2:ConfirmGiveGifts()
	end, SFX_CONFIRM)

	arg0_2.rtInfoWindow = arg0_2._tf:Find("info_window")

	onButton(arg0_2, arg0_2.rtInfoWindow:Find("bg"), function()
		arg0_2:HideInfoWindow()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.rtInfoWindow:Find("panel/title/btn_close"), function()
		arg0_2:HideInfoWindow()
	end, SFX_CANCEL)

	arg0_2.rtLackWindow = arg0_2._tf:Find("lack_window")

	onButton(arg0_2, arg0_2.rtLackWindow:Find("bg"), function()
		arg0_2:HideLackWindow()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.rtLackWindow:Find("panel/title/btn_close"), function()
		arg0_2:HideLackWindow()
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():TempOverlayPanelPB(arg0_2.rtGiftPanel, {
		pbList = {
			arg0_2.rtGiftPanel
		},
		baseCamera = arg0_2.contextData.baseCamera,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.SetApartment(arg0_12, arg1_12)
	arg0_12.apartment = arg1_12
	arg0_12.giftIds = arg0_12.apartment:getGiftIds()
	arg0_12.proxy = getProxy(ApartmentProxy)
end

function var0_0.didEnter(arg0_13)
	triggerToggle(arg0_13.rtGiftPanel:Find("content/toggles/all"), true)
	arg0_13:UpdateConfirmBtn()
end

function var0_0.UpdateSelectToggle(arg0_14, arg1_14)
	if arg0_14.toggleState == arg1_14 then
		return
	end

	arg0_14.toggleState = arg1_14
	arg0_14.filterGiftIds = underscore.filter(arg0_14.giftIds, function(arg0_15)
		return arg1_14 == "all" or arg1_14 == "normal" == (pg.dorm3d_gift[arg0_15].ship_group_id == 0)
	end)

	table.sort(arg0_14.filterGiftIds, CompareFuncs({
		function(arg0_16)
			return (arg0_14.proxy:getGiftCount(arg0_16) > 0 and -1 or 1) * (pg.dorm3d_gift[arg0_16].ship_group_id == 0 and 1 or 2)
		end,
		function(arg0_17)
			return pg.dorm3d_gift[arg0_17].ship_group_id > 0 and arg0_14.proxy:isGiveGiftDone(arg0_17) and 1 or 0
		end,
		function(arg0_18)
			return arg0_18
		end
	}))
	arg0_14.giftItemList:align(#arg0_14.filterGiftIds)
end

function var0_0.UpdateGift(arg0_19, arg1_19, arg2_19, arg3_19)
	arg1_19.name = arg2_19

	local var0_19 = arg1_19:Find("base")
	local var1_19 = Drop.New({
		type = DROP_TYPE_DORM3D_GIFT,
		id = arg2_19,
		count = arg0_19.proxy:getGiftCount(arg2_19)
	})

	updateDorm3dIcon(var0_19:Find("Dorm3dIconTpl"), var1_19)
	setText(var0_19:Find("info/name"), var1_19:getName())

	local var2_19 = var1_19:getConfig("ship_group_id") ~= 0

	setActive(var0_19:Find("mark"), var2_19)
	setActive(var0_19:Find("bg/normal"), not var2_19)
	setActive(var0_19:Find("bg/pro"), var2_19)
	setText(var0_19:Find("info/Text"), i18n("dorm3d_gift_owner_num") .. string.format("%d", var1_19.count))

	local var3_19 = var0_19:Find("info/effect")

	setActive(var3_19:Find("favor"), true)

	local var4_19 = pg.dorm3d_favor_trigger[var1_19.cfg.favor_trigger_id].num

	setText(var3_19:Find("favor/number"), "+" .. var4_19)
	setActive(var3_19:Find("story"), var2_19)
	onButton(arg0_19, var0_19:Find("info/btn_info"), function()
		arg0_19:OpenLackWindow(var1_19)
	end, SFX_PANEL)

	local var5_19 = var2_19 and arg0_19.proxy:isGiveGiftDone(arg2_19)
	local var6_19 = Dorm3dGift.New({
		configId = arg2_19
	})
	local var7_19 = var6_19:GetShopID()

	setActive(var0_19:Find("info/lack"), var7_19 ~= 0)

	if var7_19 ~= 0 then
		local var8_19 = CommonCommodity.New({
			id = var7_19
		}, Goods.TYPE_SHOPSTREET)
		local var9_19, var10_19, var11_19 = var8_19:GetPrice()
		local var12_19 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var8_19:GetResType(),
			count = var9_19
		})

		setActive(var0_19:Find("info/lack/tip"), var2_19 and not var5_19 and Dorm3dGift.GetViewedFlag(arg2_19) == 0)

		local var13_19
		local var14_19 = 0

		_.each(var6_19:getConfig("shop_id"), function(arg0_21)
			local var0_21 = pg.shop_template[arg0_21]

			if var0_21.group_type == 2 then
				var14_19 = math.max(var0_21.group_limit, var14_19)
			end
		end)

		if var14_19 > 0 then
			var13_19 = {
				getProxy(ApartmentProxy):GetGiftShopCount(var6_19:GetConfigID()),
				var14_19
			}
		end

		onButton(arg0_19, var0_19:Find("info/lack"), function()
			Dorm3dGift.SetViewedFlag(arg2_19)
			setActive(var0_19:Find("info/lack/tip"), false)

			if not var6_19:CheckBuyLimit() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_owned"))

				return
			end

			arg0_19:emit(Dorm3dGiftMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var8_19:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var10_19,
					cost = "x" .. var12_19.count,
					old = var11_19,
					name = var1_19:getConfig("name"),
					weekLimit = var13_19
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var6_19,
				groupId = arg0_19.apartment:GetConfigID(),
				onYes = function()
					arg0_19:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var7_19
					})
				end
			})
		end, SFX_PANEL)
	end

	setActive(arg1_19:Find("mask"), var5_19)
	setText(arg1_19:Find("mask/Image/Text"), i18n("dorm3d_already_gifted"))

	local function var15_19(arg0_24)
		arg0_19.selectGiftCount = arg0_24

		setText(arg1_19:Find("base/PageUtil/Text"), arg0_24)
		setGray(arg1_19:Find("base/PageUtil/Add"), arg0_24 >= math.min(20, var1_19.count))
		setGray(arg1_19:Find("base/PageUtil/Minus"), arg0_24 <= 1)
	end

	;(function()
		local var0_25 = math.min(20, var1_19.count)

		pressPersistTrigger(arg1_19:Find("base/PageUtil/Minus"), 0.5, function()
			local var0_26 = arg0_19.selectGiftCount - 1

			var0_26 = var0_26 <= 0 and arg0_19.selectGiftCount or var0_26

			var15_19(var0_26)
		end, nil, true, true, 0.1, SFX_PANEL)
		pressPersistTrigger(arg1_19:Find("base/PageUtil/Add"), 0.5, function()
			local var0_27 = arg0_19.selectGiftCount + 1

			var0_27 = var0_27 > var0_25 and var0_25 or var0_27

			var15_19(var0_27)
		end, nil, true, true, 0.1, SFX_PANEL)
	end)()
	onToggle(arg0_19, arg1_19, function(arg0_28)
		if arg0_28 then
			arg0_19.selectGiftId = arg2_19

			arg0_19:UpdateConfirmBtn()
			var15_19(math.min(1, var1_19.count))
		elseif arg0_19.selectGiftId == arg2_19 then
			arg0_19.selectGiftId = nil

			arg0_19:UpdateConfirmBtn()
		end

		setActive(arg1_19:Find("base/PageUtil"), arg0_28)
	end, SFX_PANEL)
	setToggleEnabled(arg1_19, not var5_19)
	triggerToggle(arg1_19, arg3_19)
end

function var0_0.SingleUpdateGift(arg0_29, arg1_29)
	local var0_29 = table.indexof(arg0_29.filterGiftIds, arg1_29)

	if var0_29 > 0 then
		arg0_29:UpdateGift(arg0_29.giftItemList.container:GetChild(var0_29 - 1), arg1_29, true)
	end
end

function var0_0.OnGiftListScroll(arg0_30, arg1_30)
	local var0_30 = arg0_30.rtGiftPanel:Find("content/view/container")
	local var1_30 = GetComponent(var0_30, typeof(VerticalLayoutGroup))
	local var2_30 = var0_30.rect.height
	local var3_30 = var0_30:GetChild(0).rect.height + var1_30.spacing
	local var4_30 = var0_30.anchoredPosition.y
	local var5_30 = var4_30 + var2_30
	local var6_30 = math.floor((var4_30 - var1_30.padding.top) / var3_30)
	local var7_30 = math.ceil((var5_30 - var1_30.padding.top) / var3_30)

	for iter0_30 = math.max(1, var6_30), math.min(#arg0_30.filterGiftIds, var7_30) do
		local var8_30 = arg0_30.filterGiftIds[iter0_30]

		if not arg0_30.showedGiftRecords[var8_30] then
			arg0_30.showedGiftRecords[var8_30] = true

			local var9_30 = Dorm3dGift.SetViewedFlag(var8_30)
		end
	end
end

function var0_0.UpdateConfirmBtn(arg0_31)
	setButtonEnabled(arg0_31.btnConfirm, tobool(arg0_31.selectGiftId))
end

function var0_0.ConfirmGiveGifts(arg0_32)
	if arg0_32.proxy:getGiftCount(arg0_32.selectGiftId) == 0 then
		if pg.dorm3d_gift[arg0_32.selectGiftId].ship_group_id > 0 and arg0_32.proxy:isGiveGiftDone(arg0_32.selectGiftId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_already_given"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_not_owned"))
		end

		return
	end

	local var0_32 = {}

	if arg0_32.apartment:isMaxFavor() then
		table.insert(var0_32, function(arg0_33)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
				contentText = i18n("dorm3d_gift_favor_max"),
				onConfirm = arg0_33
			})
		end)
	else
		local var1_32 = pg.dorm3d_gift[arg0_32.selectGiftId].favor_trigger_id
		local var2_32 = pg.dorm3d_favor_trigger[var1_32]
		local var3_32 = arg0_32.apartment.favor + var2_32.num * arg0_32.selectGiftCount - arg0_32.apartment:getMaxFavor()

		if var3_32 > 0 then
			table.insert(var0_32, function(arg0_34)
				pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
					contentText = i18n("dorm3d_gift_favor_exceed", var3_32),
					onConfirm = arg0_34
				})
			end)
		end
	end

	seriesAsync(var0_32, function()
		arg0_32:emit(Dorm3dGiftMediator.GIVE_GIFT, arg0_32.selectGiftId, arg0_32.selectGiftCount)
	end)
end

function var0_0.AfterGiveGift(arg0_36, arg1_36)
	local var0_36 = arg1_36.giftId
	local var1_36 = table.indexof(arg0_36.filterGiftIds, var0_36)

	if var1_36 > 0 then
		local var2_36 = arg0_36.giftItemList.container:GetChild(var1_36 - 1)

		quickPlayAnimation(var2_36, "anim_dorm3d_giftui_Select")
	end

	local var3_36 = pg.dorm3d_gift[var0_36]
	local var4_36 = {}
	local var5_36 = Apartment.getGroupConfig(arg0_36.apartment.configId, var3_36.reply_dialogue_id)

	if var5_36 and ApartmentProxy.CheckUnlockConfig(pg.dorm3d_dialogue_group[var5_36].unlock) then
		table.insert(var4_36, function(arg0_37)
			arg0_36:emit(Dorm3dGiftMediator.DO_TALK, var5_36, arg0_37)
		end)
	end

	if var3_36.unlock_dialogue_id > 0 then
		table.insert(var4_36, function(arg0_38)
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_gift_story_unlock"))
			arg0_38()
		end)
	end

	seriesAsync(var4_36, function()
		arg0_36:CheckLevelUp()
	end)
end

function var0_0.CheckLevelUp(arg0_40)
	if arg0_40.apartment:canLevelUp() then
		arg0_40:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_40.apartment.configId)
	end
end

function var0_0.OpenInfoWindow(arg0_41, arg1_41)
	local var0_41 = arg0_41.rtInfoWindow:Find("panel")

	setText(var0_41:Find("title/Text"), i18n("words_information"))
	updateDorm3dIcon(var0_41:Find("middle/Dorm3dIconTpl"), arg1_41)

	local var1_41 = arg1_41:getConfig("ship_group_id") ~= 0

	setActive(var0_41:Find("middle/Dorm3dIconTpl/mark"), var1_41)
	setText(var0_41:Find("middle/Text"), "???")
	onButton(arg0_41, var0_41:Find("bottom/btn_buy"), function()
		pg.TipsMgr.GetInstance():ShowTips("without shop config")
	end, SFX_CONFIRM)
	setActive(arg0_41.rtInfoWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_41.rtInfoWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.HideInfoWindow(arg0_43)
	setActive(arg0_43.rtInfoWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_43.rtInfoWindow, arg0_43._tf)
end

function var0_0.OpenLackWindow(arg0_44, arg1_44)
	local var0_44 = arg0_44.rtLackWindow:Find("panel")

	setText(var0_44:Find("title/Text"), i18n("child_msg_title_detail"))
	updateDorm3dIcon(var0_44:Find("middle/Dorm3dIconTpl"), arg1_44)

	local var1_44 = arg1_44:getConfig("ship_group_id") ~= 0

	setActive(var0_44:Find("middle/Dorm3dIconTpl/mark"), var1_44)
	setText(var0_44:Find("middle/info/name"), arg1_44:getName())
	setText(var0_44:Find("middle/info/count"), string.format("count:<color=#39bfff>%d</color>", arg1_44.count))
	setText(var0_44:Find("middle/info/desc"), arg1_44:getConfig("display"))
	setText(var0_44:Find("line/lack/Text"), "lack")

	local var2_44 = ItemTipPanel.GetDropLackConfig(arg1_44)
	local var3_44 = var2_44 and var2_44.description or {}
	local var4_44 = var0_44:Find("bottom/container")

	UIItemList.StaticAlign(var4_44, var4_44:Find("tpl"), #var3_44, function(arg0_45, arg1_45, arg2_45)
		arg1_45 = arg1_45 + 1

		if arg0_45 == UIItemList.EventUpdate then
			local var0_45 = var3_44[arg1_45]
			local var1_45, var2_45, var3_45 = unpack(var0_45)

			setText(arg2_45:Find("Text"), var1_45)
			setText(arg2_45:Find("btn_go/Text"), i18n("feast_res_window_go_label"))

			local var4_45, var5_45, var6_45 = unpack(var2_44)
			local var7_45, var8_45 = unpack(var5_45)
			local var9_45 = #var7_45 > 0

			if var6_45 and var6_45 ~= 0 then
				var9_45 = var9_45 and getProxy(ActivityProxy):IsActivityNotEnd(var6_45)
			end

			setActive(arg2_45:Find("btn_go"), var9_45)
			onButton(arg0_44, arg2_45:Find("btn_go"), function()
				ItemTipPanel.ConfigGoScene(var7_45, var8_45, function()
					arg0_44:closeView()
				end)
			end, SFX_PANEL)
		end
	end)
	setActive(arg0_44.rtLackWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_44.rtLackWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.HideLackWindow(arg0_48)
	setActive(arg0_48.rtLackWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_48.rtLackWindow, arg0_48._tf)
end

function var0_0.onBackPressed(arg0_49)
	if isActive(arg0_49.rtInfoWindow) then
		arg0_49:HideInfoWindow()

		return
	end

	if isActive(arg0_49.rtLackWindow) then
		arg0_49:HideLackWindow()

		return
	end

	var0_0.super.onBackPressed(arg0_49)
end

function var0_0.willExit(arg0_50)
	if isActive(arg0_50.rtInfoWindow) then
		arg0_50:HideInfoWindow()
	end

	if isActive(arg0_50.rtLackWindow) then
		arg0_50:HideLackWindow()
	end

	pg.UIMgr.GetInstance():TempUnblurPanel(arg0_50.rtGiftPanel, arg0_50._tf)
end

return var0_0
