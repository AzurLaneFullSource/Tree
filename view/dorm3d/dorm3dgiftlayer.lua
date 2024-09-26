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

	setActive(var0_19:Find("info/lack"), tobool(var7_19))

	if var7_19 then
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
		onButton(arg0_19, var0_19:Find("info/lack"), function()
			Dorm3dGift.SetViewedFlag(arg2_19)
			setActive(var0_19:Find("info/lack/tip"), false)
			arg0_19:emit(Dorm3dGiftMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var8_19:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var10_19,
					cost = "x" .. var12_19.count,
					old = var11_19,
					name = var1_19:getConfig("name")
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var6_19,
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
	onToggle(arg0_19, arg1_19, function(arg0_23)
		if arg0_23 then
			arg0_19.selectGiftId = arg2_19

			arg0_19:UpdateConfirmBtn()
		elseif arg0_19.selectGiftId == arg2_19 then
			arg0_19.selectGiftId = nil

			arg0_19:UpdateConfirmBtn()
		end
	end, SFX_PANEL)
	setToggleEnabled(arg1_19, not var5_19)
	triggerToggle(arg1_19, arg3_19)
end

function var0_0.SingleUpdateGift(arg0_24, arg1_24)
	local var0_24 = table.indexof(arg0_24.filterGiftIds, arg1_24)

	if var0_24 > 0 then
		arg0_24:UpdateGift(arg0_24.giftItemList.container:GetChild(var0_24 - 1), arg1_24, true)
	end
end

function var0_0.OnGiftListScroll(arg0_25, arg1_25)
	local var0_25 = arg0_25.rtGiftPanel:Find("content/view/container")
	local var1_25 = GetComponent(var0_25, typeof(VerticalLayoutGroup))
	local var2_25 = var0_25.rect.height
	local var3_25 = var0_25:GetChild(0).rect.height + var1_25.spacing
	local var4_25 = var0_25.anchoredPosition.y
	local var5_25 = var4_25 + var2_25
	local var6_25 = math.floor((var4_25 - var1_25.padding.top) / var3_25)
	local var7_25 = math.ceil((var5_25 - var1_25.padding.top) / var3_25)

	for iter0_25 = math.max(1, var6_25), math.min(#arg0_25.filterGiftIds, var7_25) do
		local var8_25 = arg0_25.filterGiftIds[iter0_25]

		if not arg0_25.showedGiftRecords[var8_25] then
			arg0_25.showedGiftRecords[var8_25] = true

			local var9_25 = Dorm3dGift.SetViewedFlag(var8_25)
		end
	end
end

function var0_0.UpdateConfirmBtn(arg0_26)
	setButtonEnabled(arg0_26.btnConfirm, tobool(arg0_26.selectGiftId))
end

function var0_0.ConfirmGiveGifts(arg0_27)
	if arg0_27.proxy:getGiftCount(arg0_27.selectGiftId) == 0 then
		if pg.dorm3d_gift[arg0_27.selectGiftId].ship_group_id > 0 and arg0_27.proxy:isGiveGiftDone(arg0_27.selectGiftId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_already_given"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_not_owned"))
		end

		return
	end

	local var0_27 = {}

	if arg0_27.apartment:isMaxFavor() then
		table.insert(var0_27, function(arg0_28)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
				contentText = "apartment level is max, are you continue ?",
				onConfirm = arg0_28
			})
		end)
	end

	seriesAsync(var0_27, function()
		arg0_27:emit(Dorm3dGiftMediator.GIVE_GIFT, arg0_27.selectGiftId)
	end)
end

function var0_0.AfterGiveGift(arg0_30, arg1_30)
	local var0_30 = arg1_30.giftId
	local var1_30 = table.indexof(arg0_30.filterGiftIds, var0_30)

	if var1_30 > 0 then
		local var2_30 = arg0_30.giftItemList.container:GetChild(var1_30 - 1)

		quickPlayAnimation(var2_30, "anim_dorm3d_giftui_Select")
	end

	local var3_30 = pg.dorm3d_gift[var0_30]
	local var4_30 = {}

	if var3_30.reply_dialogue_id ~= 0 and ApartmentProxy.CheckUnlockConfig(pg.dorm3d_dialogue_group[var3_30.reply_dialogue_id].unlock) then
		table.insert(var4_30, function(arg0_31)
			arg0_30:emit(Dorm3dGiftMediator.DO_TALK, var3_30.reply_dialogue_id, arg0_31)
		end)
	end

	if var3_30.unlock_dialogue_id > 0 then
		table.insert(var4_30, function(arg0_32)
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_gift_story_unlock"))
			arg0_32()
		end)
	end

	seriesAsync(var4_30, function()
		arg0_30:CheckLevelUp()
	end)
end

function var0_0.CheckLevelUp(arg0_34)
	if arg0_34.apartment:canLevelUp() then
		arg0_34:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_34.apartment.configId)
	end
end

function var0_0.OpenInfoWindow(arg0_35, arg1_35)
	local var0_35 = arg0_35.rtInfoWindow:Find("panel")

	setText(var0_35:Find("title/Text"), i18n("words_information"))
	updateDorm3dIcon(var0_35:Find("middle/Dorm3dIconTpl"), arg1_35)

	local var1_35 = arg1_35:getConfig("ship_group_id") ~= 0

	setActive(var0_35:Find("middle/Dorm3dIconTpl/mark"), var1_35)
	setText(var0_35:Find("middle/Text"), "???")
	onButton(arg0_35, var0_35:Find("bottom/btn_buy"), function()
		pg.TipsMgr.GetInstance():ShowTips("without shop config")
	end, SFX_CONFIRM)
	setActive(arg0_35.rtInfoWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_35.rtInfoWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.HideInfoWindow(arg0_37)
	setActive(arg0_37.rtInfoWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_37.rtInfoWindow, arg0_37._tf)
end

function var0_0.OpenLackWindow(arg0_38, arg1_38)
	local var0_38 = arg0_38.rtLackWindow:Find("panel")

	setText(var0_38:Find("title/Text"), i18n("child_msg_title_detail"))
	updateDorm3dIcon(var0_38:Find("middle/Dorm3dIconTpl"), arg1_38)

	local var1_38 = arg1_38:getConfig("ship_group_id") ~= 0

	setActive(var0_38:Find("middle/Dorm3dIconTpl/mark"), var1_38)
	setText(var0_38:Find("middle/info/name"), arg1_38:getName())
	setText(var0_38:Find("middle/info/count"), string.format("count:<color=#39bfff>%d</color>", arg1_38.count))
	setText(var0_38:Find("middle/info/desc"), arg1_38:getConfig("display"))
	setText(var0_38:Find("line/lack/Text"), "lack")

	local var2_38 = ItemTipPanel.GetDropLackConfig(arg1_38)
	local var3_38 = var2_38 and var2_38.description or {}
	local var4_38 = var0_38:Find("bottom/container")

	UIItemList.StaticAlign(var4_38, var4_38:Find("tpl"), #var3_38, function(arg0_39, arg1_39, arg2_39)
		arg1_39 = arg1_39 + 1

		if arg0_39 == UIItemList.EventUpdate then
			local var0_39 = var3_38[arg1_39]
			local var1_39, var2_39, var3_39 = unpack(var0_39)

			setText(arg2_39:Find("Text"), var1_39)
			setText(arg2_39:Find("btn_go/Text"), i18n("feast_res_window_go_label"))

			local var4_39, var5_39, var6_39 = unpack(var2_38)
			local var7_39, var8_39 = unpack(var5_39)
			local var9_39 = #var7_39 > 0

			if var6_39 and var6_39 ~= 0 then
				var9_39 = var9_39 and getProxy(ActivityProxy):IsActivityNotEnd(var6_39)
			end

			setActive(arg2_39:Find("btn_go"), var9_39)
			onButton(arg0_38, arg2_39:Find("btn_go"), function()
				ItemTipPanel.ConfigGoScene(var7_39, var8_39, function()
					arg0_38:closeView()
				end)
			end, SFX_PANEL)
		end
	end)
	setActive(arg0_38.rtLackWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_38.rtLackWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.HideLackWindow(arg0_42)
	setActive(arg0_42.rtLackWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_42.rtLackWindow, arg0_42._tf)
end

function var0_0.onBackPressed(arg0_43)
	if isActive(arg0_43.rtInfoWindow) then
		arg0_43:HideInfoWindow()

		return
	end

	if isActive(arg0_43.rtLackWindow) then
		arg0_43:HideLackWindow()

		return
	end

	var0_0.super.onBackPressed(arg0_43)
end

function var0_0.willExit(arg0_44)
	if isActive(arg0_44.rtInfoWindow) then
		arg0_44:HideInfoWindow()
	end

	if isActive(arg0_44.rtLackWindow) then
		arg0_44:HideLackWindow()
	end

	pg.UIMgr.GetInstance():TempUnblurPanel(arg0_44.rtGiftPanel, arg0_44._tf)
end

return var0_0
