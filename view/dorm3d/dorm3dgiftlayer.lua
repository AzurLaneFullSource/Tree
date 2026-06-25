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
	arg0_2:TempOverlayPanelPB(arg0_2.rtGiftPanel, {
		pbList = {
			arg0_2.rtGiftPanel
		},
		baseCamera = arg0_2.contextData.baseCamera
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

	arg0_14:UpdateFilterGiftIds()
	arg0_14.giftItemList:align(#arg0_14.filterGiftIds)
end

function var0_0.UpdateFilterGiftIds(arg0_15)
	arg0_15.filterGiftIds = underscore.filter(arg0_15.giftIds, function(arg0_16)
		local var0_16 = pg.dorm3d_gift[arg0_16]

		if var0_16.hide_if_not_owned == 1 and arg0_15.proxy:getGiftCount(arg0_16) <= 0 then
			return false
		end

		return arg0_15.toggleState == "all" or arg0_15.toggleState == "normal" == (var0_16.ship_group_id == 0)
	end)

	table.sort(arg0_15.filterGiftIds, CompareFuncs({
		function(arg0_17)
			return (arg0_15.proxy:getGiftCount(arg0_17) > 0 and -1 or 1) * (pg.dorm3d_gift[arg0_17].ship_group_id == 0 and 1 or 2)
		end,
		function(arg0_18)
			return Dorm3dGift.IsSingleGiveGift(arg0_18) and arg0_15.proxy:isGiveGiftDone(arg0_18) and 1 or 0
		end,
		function(arg0_19)
			return arg0_19
		end
	}))

	if arg0_15.selectGiftId and not table.indexof(arg0_15.filterGiftIds, arg0_15.selectGiftId) then
		arg0_15.selectGiftId = nil
		arg0_15.selectGiftCount = nil

		arg0_15:UpdateConfirmBtn()
	end
end

function var0_0.UpdateGift(arg0_20, arg1_20, arg2_20, arg3_20)
	arg1_20.name = arg2_20

	local var0_20 = arg1_20:Find("base")
	local var1_20 = Drop.New({
		type = DROP_TYPE_DORM3D_GIFT,
		id = arg2_20,
		count = arg0_20.proxy:getGiftCount(arg2_20)
	})

	updateCustomDrop(var0_20:Find("Dorm3dIconTpl"), var1_20)
	setText(var0_20:Find("info/name"), var1_20:getName())

	local var2_20 = var1_20:getConfig("ship_group_id") ~= 0

	setActive(var0_20:Find("mark"), var2_20)
	setActive(var0_20:Find("bg/normal"), not var2_20)
	setActive(var0_20:Find("bg/pro"), var2_20)
	setText(var0_20:Find("info/Text"), i18n("dorm3d_gift_owner_num") .. string.format("%d", var1_20.count))
	setActive(var0_20:Find("info/overtime"), Dorm3dGift.IsExpireSoon(arg2_20))

	local var3_20 = var0_20:Find("info/effect")

	setActive(var3_20:Find("favor"), true)

	local var4_20 = pg.dorm3d_favor_trigger[var1_20.cfg.favor_trigger_id].num

	setText(var3_20:Find("favor/number"), "+" .. var4_20)
	setActive(var3_20:Find("story"), pg.dorm3d_gift[arg2_20].unlock_dialogue_id ~= 0)
	onButton(arg0_20, var0_20:Find("info/btn_info"), function()
		arg0_20:OpenLackWindow(var1_20)
	end, SFX_PANEL)

	local var5_20 = Dorm3dGift.New({
		configId = arg2_20
	})
	local var6_20 = Dorm3dGift.IsSingleGiveGift(arg2_20) and arg0_20.proxy:isGiveGiftDone(arg2_20)
	local var7_20 = var5_20:GetShopID()

	setActive(var0_20:Find("info/lack"), var7_20 ~= 0)

	if var7_20 ~= 0 then
		local var8_20 = CommonCommodity.New({
			id = var7_20
		}, Goods.TYPE_SHOPSTREET)
		local var9_20, var10_20, var11_20 = var8_20:GetPrice()
		local var12_20 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var8_20:GetResType(),
			count = var9_20
		})

		setActive(var0_20:Find("info/lack/tip"), var2_20 and not var6_20 and Dorm3dGift.GetViewedFlag(arg2_20) == 0)

		local var13_20
		local var14_20 = 0

		_.each(var5_20:getConfig("shop_id"), function(arg0_22)
			local var0_22 = pg.shop_template[arg0_22]

			if var0_22.group_type == 2 then
				var14_20 = math.max(var0_22.group_limit, var14_20)
			end
		end)

		if var14_20 > 0 then
			var13_20 = {
				getProxy(ApartmentProxy):GetGiftShopCount(var5_20:GetConfigID()),
				var14_20
			}
		end

		onButton(arg0_20, var0_20:Find("info/lack"), function()
			Dorm3dGift.SetViewedFlag(arg2_20)
			setActive(var0_20:Find("info/lack/tip"), false)

			if not var5_20:CheckBuyLimit() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_owned"))

				return
			end

			arg0_20:emit(Dorm3dGiftMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var8_20:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var10_20,
					cost = var12_20.count,
					old = var11_20,
					name = var1_20:getConfig("name"),
					weekLimit = var13_20
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var5_20,
				groupId = arg0_20.apartment:GetConfigID(),
				onYes = function()
					arg0_20:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var7_20
					})
				end
			})
		end, SFX_PANEL)
	end

	setActive(arg1_20:Find("mask"), var6_20)
	setText(arg1_20:Find("mask/Image/Text"), i18n("dorm3d_already_gifted"))

	local function var15_20(arg0_25)
		arg0_20.selectGiftCount = arg0_25

		setText(arg1_20:Find("base/PageUtil/Text"), arg0_25)
		setGray(arg1_20:Find("base/PageUtil/Add"), arg0_25 >= math.min(20, var1_20.count))
		setGray(arg1_20:Find("base/PageUtil/Minus"), arg0_25 <= 1)
	end

	;(function()
		local var0_26 = math.min(20, var1_20.count)

		pressPersistTrigger(arg1_20:Find("base/PageUtil/Minus"), 0.5, function()
			local var0_27 = arg0_20.selectGiftCount - 1

			var0_27 = var0_27 <= 0 and arg0_20.selectGiftCount or var0_27

			var15_20(var0_27)
		end, nil, true, true, 0.1, SFX_PANEL)
		pressPersistTrigger(arg1_20:Find("base/PageUtil/Add"), 0.5, function()
			local var0_28 = arg0_20.selectGiftCount + 1

			var0_28 = var0_28 > var0_26 and var0_26 or var0_28

			var15_20(var0_28)
		end, nil, true, true, 0.1, SFX_PANEL)
	end)()
	onToggle(arg0_20, arg1_20, function(arg0_29)
		if arg0_29 then
			arg0_20.selectGiftId = arg2_20

			arg0_20:UpdateConfirmBtn()
			var15_20(math.min(1, var1_20.count))
		elseif arg0_20.selectGiftId == arg2_20 then
			arg0_20.selectGiftId = nil

			arg0_20:UpdateConfirmBtn()
		end

		setActive(arg1_20:Find("base/PageUtil"), arg0_29)
	end, SFX_PANEL)
	setToggleEnabled(arg1_20, not var6_20)
	triggerToggle(arg1_20, arg3_20)
end

function var0_0.SingleUpdateGift(arg0_30, arg1_30)
	arg0_30:UpdateFilterGiftIds()
	arg0_30.giftItemList:align(#arg0_30.filterGiftIds)

	local var0_30 = table.indexof(arg0_30.filterGiftIds, arg1_30)

	if var0_30 then
		arg0_30:UpdateGift(arg0_30.giftItemList.container:GetChild(var0_30 - 1), arg1_30, true)
	end
end

function var0_0.OnGiftListScroll(arg0_31, arg1_31)
	local var0_31 = arg0_31.rtGiftPanel:Find("content/view/container")
	local var1_31 = GetComponent(var0_31, typeof(VerticalLayoutGroup))
	local var2_31 = var0_31.rect.height
	local var3_31 = var0_31:GetChild(0).rect.height + var1_31.spacing
	local var4_31 = var0_31.anchoredPosition.y
	local var5_31 = var4_31 + var2_31
	local var6_31 = math.floor((var4_31 - var1_31.padding.top) / var3_31)
	local var7_31 = math.ceil((var5_31 - var1_31.padding.top) / var3_31)

	for iter0_31 = math.max(1, var6_31), math.min(#arg0_31.filterGiftIds, var7_31) do
		local var8_31 = arg0_31.filterGiftIds[iter0_31]

		if not arg0_31.showedGiftRecords[var8_31] then
			arg0_31.showedGiftRecords[var8_31] = true

			local var9_31 = Dorm3dGift.SetViewedFlag(var8_31)
		end
	end
end

function var0_0.UpdateConfirmBtn(arg0_32)
	setButtonEnabled(arg0_32.btnConfirm, tobool(arg0_32.selectGiftId))
end

function var0_0.ConfirmGiveGifts(arg0_33)
	if arg0_33.proxy:getGiftCount(arg0_33.selectGiftId) == 0 then
		if Dorm3dGift.IsSingleGiveGift(arg0_33.selectGiftId) and arg0_33.proxy:isGiveGiftDone(arg0_33.selectGiftId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_already_given"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_shop_gift_not_owned"))
		end

		return
	end

	local var0_33 = {}

	if arg0_33.apartment:isMaxFavor() then
		table.insert(var0_33, function(arg0_34)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
				contentText = i18n("dorm3d_gift_favor_max"),
				onConfirm = arg0_34
			})
		end)
	else
		local var1_33 = pg.dorm3d_gift[arg0_33.selectGiftId].favor_trigger_id
		local var2_33 = pg.dorm3d_favor_trigger[var1_33]
		local var3_33 = arg0_33.apartment.favor + var2_33.num * arg0_33.selectGiftCount - arg0_33.apartment:getMaxFavor()

		if var3_33 > 0 then
			table.insert(var0_33, function(arg0_35)
				pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
					contentText = i18n("dorm3d_gift_favor_exceed", var3_33),
					onConfirm = arg0_35
				})
			end)
		end
	end

	seriesAsync(var0_33, function()
		arg0_33:emit(Dorm3dGiftMediator.GIVE_GIFT, arg0_33.selectGiftId, arg0_33.selectGiftCount)
	end)
end

function var0_0.AfterGiveGift(arg0_37, arg1_37)
	local var0_37 = arg1_37.giftId
	local var1_37 = table.indexof(arg0_37.filterGiftIds, var0_37)

	if var1_37 then
		local var2_37 = arg0_37.giftItemList.container:GetChild(var1_37 - 1)

		quickPlayAnimation(var2_37, "anim_dorm3d_giftui_Select")
	end

	local var3_37 = pg.dorm3d_gift[var0_37]
	local var4_37 = {}
	local var5_37 = Apartment.getGroupConfig(arg0_37.apartment.configId, var3_37.reply_dialogue_id)

	if var5_37 and ApartmentProxy.CheckUnlockConfig(pg.dorm3d_dialogue_group[var5_37].unlock) then
		table.insert(var4_37, function(arg0_38)
			arg0_37:emit(Dorm3dGiftMediator.DO_TALK, var5_37, arg0_38)
		end)
	end

	if var3_37.unlock_dialogue_id > 0 then
		table.insert(var4_37, function(arg0_39)
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_gift_story_unlock"))
			arg0_39()
		end)
	end

	seriesAsync(var4_37, function()
		arg0_37:CheckLevelUp()
	end)
end

function var0_0.CheckLevelUp(arg0_41)
	if arg0_41.apartment:canLevelUp() then
		arg0_41:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_41.apartment.configId)
	end
end

function var0_0.OpenInfoWindow(arg0_42, arg1_42)
	local var0_42 = arg0_42.rtInfoWindow:Find("panel")

	setText(var0_42:Find("title/Text"), i18n("words_information"))
	updateCustomDrop(var0_42:Find("middle/Dorm3dIconTpl"), arg1_42)

	local var1_42 = arg1_42:getConfig("ship_group_id") ~= 0

	setActive(var0_42:Find("middle/Dorm3dIconTpl/mark"), var1_42)
	setText(var0_42:Find("middle/Text"), "???")
	onButton(arg0_42, var0_42:Find("bottom/btn_buy"), function()
		pg.TipsMgr.GetInstance():ShowTips("without shop config")
	end, SFX_CONFIRM)
	setActive(arg0_42.rtInfoWindow, true)
	arg0_42:OverlayPanel(arg0_42.rtInfoWindow)
end

function var0_0.HideInfoWindow(arg0_44)
	setActive(arg0_44.rtInfoWindow, false)
	arg0_44:UnOverlayPanel(arg0_44.rtInfoWindow, arg0_44._tf)
end

function var0_0.OpenLackWindow(arg0_45, arg1_45)
	local var0_45 = arg0_45.rtLackWindow:Find("panel")

	setText(var0_45:Find("title/Text"), i18n("child_msg_title_detail"))
	updateCustomDrop(var0_45:Find("middle/Dorm3dIconTpl"), arg1_45)

	local var1_45 = arg1_45:getConfig("ship_group_id") ~= 0

	setActive(var0_45:Find("middle/Dorm3dIconTpl/mark"), var1_45)
	setText(var0_45:Find("middle/info/name"), arg1_45:getName())
	setText(var0_45:Find("middle/info/count"), string.format("count:<color=#39bfff>%d</color>", arg1_45.count))
	setText(var0_45:Find("middle/info/desc"), arg1_45:getConfig("display"))
	setText(var0_45:Find("line/lack/Text"), "lack")

	local var2_45 = ItemTipPanel.GetDropLackConfig(arg1_45)
	local var3_45 = var2_45 and var2_45.description or {}
	local var4_45 = var0_45:Find("bottom/container")

	UIItemList.StaticAlign(var4_45, var4_45:Find("tpl"), #var3_45, function(arg0_46, arg1_46, arg2_46)
		arg1_46 = arg1_46 + 1

		if arg0_46 == UIItemList.EventUpdate then
			local var0_46 = var3_45[arg1_46]
			local var1_46, var2_46, var3_46 = unpack(var0_46)

			setText(arg2_46:Find("Text"), var1_46)
			setText(arg2_46:Find("btn_go/Text"), i18n("feast_res_window_go_label"))

			local var4_46, var5_46, var6_46 = unpack(var2_45)
			local var7_46, var8_46 = unpack(var5_46)
			local var9_46 = #var7_46 > 0

			if var6_46 and var6_46 ~= 0 then
				var9_46 = var9_46 and getProxy(ActivityProxy):IsActivityNotEnd(var6_46)
			end

			setActive(arg2_46:Find("btn_go"), var9_46)
			onButton(arg0_45, arg2_46:Find("btn_go"), function()
				ItemTipPanel.ConfigGoScene(var7_46, var8_46, function()
					arg0_45:closeView()
				end)
			end, SFX_PANEL)
		end
	end)
	setActive(arg0_45.rtLackWindow, true)
	arg0_45:OverlayPanel(arg0_45.rtLackWindow)
end

function var0_0.HideLackWindow(arg0_49)
	setActive(arg0_49.rtLackWindow, false)
	arg0_49:UnOverlayPanel(arg0_49.rtLackWindow, arg0_49._tf)
end

function var0_0.onBackPressed(arg0_50)
	if isActive(arg0_50.rtInfoWindow) then
		arg0_50:HideInfoWindow()

		return
	end

	if isActive(arg0_50.rtLackWindow) then
		arg0_50:HideLackWindow()

		return
	end

	var0_0.super.onBackPressed(arg0_50)
end

function var0_0.willExit(arg0_51)
	if isActive(arg0_51.rtInfoWindow) then
		arg0_51:HideInfoWindow()
	end

	if isActive(arg0_51.rtLackWindow) then
		arg0_51:HideLackWindow()
	end

	arg0_51:TempUnOverlayPanelPB(arg0_51.rtGiftPanel, arg0_51._tf)
end

return var0_0
