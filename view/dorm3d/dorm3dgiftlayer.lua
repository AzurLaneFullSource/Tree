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
	onToggle(arg0_19, arg1_19, function(arg0_24)
		if arg0_24 then
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

function var0_0.SingleUpdateGift(arg0_25, arg1_25)
	local var0_25 = table.indexof(arg0_25.filterGiftIds, arg1_25)

	if var0_25 > 0 then
		arg0_25:UpdateGift(arg0_25.giftItemList.container:GetChild(var0_25 - 1), arg1_25, true)
	end
end

function var0_0.OnGiftListScroll(arg0_26, arg1_26)
	local var0_26 = arg0_26.rtGiftPanel:Find("content/view/container")
	local var1_26 = GetComponent(var0_26, typeof(VerticalLayoutGroup))
	local var2_26 = var0_26.rect.height
	local var3_26 = var0_26:GetChild(0).rect.height + var1_26.spacing
	local var4_26 = var0_26.anchoredPosition.y
	local var5_26 = var4_26 + var2_26
	local var6_26 = math.floor((var4_26 - var1_26.padding.top) / var3_26)
	local var7_26 = math.ceil((var5_26 - var1_26.padding.top) / var3_26)

	for iter0_26 = math.max(1, var6_26), math.min(#arg0_26.filterGiftIds, var7_26) do
		local var8_26 = arg0_26.filterGiftIds[iter0_26]

		if not arg0_26.showedGiftRecords[var8_26] then
			arg0_26.showedGiftRecords[var8_26] = true

			local var9_26 = Dorm3dGift.SetViewedFlag(var8_26)
		end
	end
end

function var0_0.UpdateConfirmBtn(arg0_27)
	setButtonEnabled(arg0_27.btnConfirm, tobool(arg0_27.selectGiftId))
end

function var0_0.ConfirmGiveGifts(arg0_28)
	if arg0_28.proxy:getGiftCount(arg0_28.selectGiftId) == 0 then
		if pg.dorm3d_gift[arg0_28.selectGiftId].ship_group_id > 0 and arg0_28.proxy:isGiveGiftDone(arg0_28.selectGiftId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_already_given"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_not_owned"))
		end

		return
	end

	local var0_28 = {}

	if arg0_28.apartment:isMaxFavor() then
		table.insert(var0_28, function(arg0_29)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
				contentText = "apartment level is max, are you continue ?",
				onConfirm = arg0_29
			})
		end)
	end

	seriesAsync(var0_28, function()
		arg0_28:emit(Dorm3dGiftMediator.GIVE_GIFT, arg0_28.selectGiftId)
	end)
end

function var0_0.AfterGiveGift(arg0_31, arg1_31)
	local var0_31 = arg1_31.giftId
	local var1_31 = table.indexof(arg0_31.filterGiftIds, var0_31)

	if var1_31 > 0 then
		local var2_31 = arg0_31.giftItemList.container:GetChild(var1_31 - 1)

		quickPlayAnimation(var2_31, "anim_dorm3d_giftui_Select")
	end

	local var3_31 = pg.dorm3d_gift[var0_31]
	local var4_31 = {}

	if var3_31.reply_dialogue_id ~= 0 and ApartmentProxy.CheckUnlockConfig(pg.dorm3d_dialogue_group[var3_31.reply_dialogue_id].unlock) then
		table.insert(var4_31, function(arg0_32)
			arg0_31:emit(Dorm3dGiftMediator.DO_TALK, var3_31.reply_dialogue_id, arg0_32)
		end)
	end

	if var3_31.unlock_dialogue_id > 0 then
		table.insert(var4_31, function(arg0_33)
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_gift_story_unlock"))
			arg0_33()
		end)
	end

	seriesAsync(var4_31, function()
		arg0_31:CheckLevelUp()
	end)
end

function var0_0.CheckLevelUp(arg0_35)
	if arg0_35.apartment:canLevelUp() then
		arg0_35:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_35.apartment.configId)
	end
end

function var0_0.OpenInfoWindow(arg0_36, arg1_36)
	local var0_36 = arg0_36.rtInfoWindow:Find("panel")

	setText(var0_36:Find("title/Text"), i18n("words_information"))
	updateDorm3dIcon(var0_36:Find("middle/Dorm3dIconTpl"), arg1_36)

	local var1_36 = arg1_36:getConfig("ship_group_id") ~= 0

	setActive(var0_36:Find("middle/Dorm3dIconTpl/mark"), var1_36)
	setText(var0_36:Find("middle/Text"), "???")
	onButton(arg0_36, var0_36:Find("bottom/btn_buy"), function()
		pg.TipsMgr.GetInstance():ShowTips("without shop config")
	end, SFX_CONFIRM)
	setActive(arg0_36.rtInfoWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_36.rtInfoWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.HideInfoWindow(arg0_38)
	setActive(arg0_38.rtInfoWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_38.rtInfoWindow, arg0_38._tf)
end

function var0_0.OpenLackWindow(arg0_39, arg1_39)
	local var0_39 = arg0_39.rtLackWindow:Find("panel")

	setText(var0_39:Find("title/Text"), i18n("child_msg_title_detail"))
	updateDorm3dIcon(var0_39:Find("middle/Dorm3dIconTpl"), arg1_39)

	local var1_39 = arg1_39:getConfig("ship_group_id") ~= 0

	setActive(var0_39:Find("middle/Dorm3dIconTpl/mark"), var1_39)
	setText(var0_39:Find("middle/info/name"), arg1_39:getName())
	setText(var0_39:Find("middle/info/count"), string.format("count:<color=#39bfff>%d</color>", arg1_39.count))
	setText(var0_39:Find("middle/info/desc"), arg1_39:getConfig("display"))
	setText(var0_39:Find("line/lack/Text"), "lack")

	local var2_39 = ItemTipPanel.GetDropLackConfig(arg1_39)
	local var3_39 = var2_39 and var2_39.description or {}
	local var4_39 = var0_39:Find("bottom/container")

	UIItemList.StaticAlign(var4_39, var4_39:Find("tpl"), #var3_39, function(arg0_40, arg1_40, arg2_40)
		arg1_40 = arg1_40 + 1

		if arg0_40 == UIItemList.EventUpdate then
			local var0_40 = var3_39[arg1_40]
			local var1_40, var2_40, var3_40 = unpack(var0_40)

			setText(arg2_40:Find("Text"), var1_40)
			setText(arg2_40:Find("btn_go/Text"), i18n("feast_res_window_go_label"))

			local var4_40, var5_40, var6_40 = unpack(var2_39)
			local var7_40, var8_40 = unpack(var5_40)
			local var9_40 = #var7_40 > 0

			if var6_40 and var6_40 ~= 0 then
				var9_40 = var9_40 and getProxy(ActivityProxy):IsActivityNotEnd(var6_40)
			end

			setActive(arg2_40:Find("btn_go"), var9_40)
			onButton(arg0_39, arg2_40:Find("btn_go"), function()
				ItemTipPanel.ConfigGoScene(var7_40, var8_40, function()
					arg0_39:closeView()
				end)
			end, SFX_PANEL)
		end
	end)
	setActive(arg0_39.rtLackWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_39.rtLackWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.HideLackWindow(arg0_43)
	setActive(arg0_43.rtLackWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_43.rtLackWindow, arg0_43._tf)
end

function var0_0.onBackPressed(arg0_44)
	if isActive(arg0_44.rtInfoWindow) then
		arg0_44:HideInfoWindow()

		return
	end

	if isActive(arg0_44.rtLackWindow) then
		arg0_44:HideLackWindow()

		return
	end

	var0_0.super.onBackPressed(arg0_44)
end

function var0_0.willExit(arg0_45)
	if isActive(arg0_45.rtInfoWindow) then
		arg0_45:HideInfoWindow()
	end

	if isActive(arg0_45.rtLackWindow) then
		arg0_45:HideLackWindow()
	end

	pg.UIMgr.GetInstance():TempUnblurPanel(arg0_45.rtGiftPanel, arg0_45._tf)
end

return var0_0
