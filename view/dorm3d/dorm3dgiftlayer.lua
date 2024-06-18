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

	eachChild(arg0_2.rtGiftPanel:Find("content/toggles"), function(arg0_4)
		onToggle(arg0_2, arg0_4, function(arg0_5)
			if arg0_5 then
				arg0_2:UpdateSelectToggle(arg0_4.name)
			end
		end, SFX_PANEL)
	end)

	local var1_2 = arg0_2.rtGiftPanel:Find("content/view/container")

	arg0_2.giftItemList = UIItemList.New(var1_2, var1_2:Find("tpl"))

	arg0_2.giftItemList:make(function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			arg0_2:UpdateGift(arg2_6, arg0_2.filterGiftIds[arg1_6])
		end
	end)

	arg0_2.btnConfirm = arg0_2.rtGiftPanel:Find("bottom/btn_confirm")

	onButton(arg0_2, arg0_2.btnConfirm, function()
		arg0_2:ConfirmGiveGifts()
	end, SFX_CONFIRM)

	arg0_2.rtFavorPanel = arg0_2._tf:Find("favor_panel")
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
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2._tf, {
		pbList = {
			arg0_2.rtGiftPanel
		},
		weight = LayerWeightConst.SECOND_LAYER,
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
	arg0_13:UpdateFavorPanel()
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

function var0_0.UpdateGift(arg0_19, arg1_19, arg2_19)
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
		arg0_19:OpenInfoWindow(var1_19)
	end, SFX_PANEL)

	local var5_19 = var2_19 and arg0_19.proxy:isGiveGiftDone(arg2_19)
	local var6_19 = var1_19.count == 0 and not var5_19

	setActive(var0_19:Find("info/lack"), var6_19)
	onButton(arg0_19, var0_19:Find("info/lack"), function()
		arg0_19:OpenLackWindow(var1_19)
	end, SFX_PANEL)
	setActive(arg1_19:Find("mask"), var5_19)
	setText(arg1_19:Find("mask/Image/Text"), "is Done")
	onToggle(arg0_19, arg1_19, function(arg0_22)
		if arg0_22 then
			arg0_19.selectGiftId = arg2_19

			arg0_19:UpdateConfirmBtn()
		elseif arg0_19.selectGiftId == arg2_19 then
			arg0_19.selectGiftId = nil

			arg0_19:UpdateConfirmBtn()
		end
	end, SFX_PANEL)
	setToggleEnabled(arg1_19, not var5_19)
	triggerToggle(arg1_19, false)
end

function var0_0.SingleUpdateGift(arg0_23, arg1_23)
	local var0_23 = table.indexof(arg0_23.filterGiftIds, arg1_23)

	if var0_23 > 0 then
		arg0_23:UpdateGift(arg0_23.giftItemList.container:GetChild(var0_23 - 1), arg1_23)
	end
end

function var0_0.UpdateConfirmBtn(arg0_24)
	setButtonEnabled(arg0_24.btnConfirm, tobool(arg0_24.selectGiftId))
end

function var0_0.ConfirmGiveGifts(arg0_25)
	if arg0_25.proxy:getGiftCount(arg0_25.selectGiftId) == 0 then
		if pg.dorm3d_gift[arg0_25.selectGiftId].ship_group_id > 0 and arg0_25.proxy:isGiveGiftDone(arg0_25.selectGiftId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("该礼物已赠送"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("当前未拥有该礼物"))
		end

		return
	end

	arg0_25:emit(Dorm3dGiftMediator.GIVE_GIFT, arg0_25.selectGiftId)
end

function var0_0.AfterGiveGift(arg0_26, arg1_26)
	local var0_26 = pg.dorm3d_gift[arg1_26]
	local var1_26 = {}

	if var0_26.reply_dialogue_id ~= 0 then
		table.insert(var1_26, function(arg0_27)
			arg0_26:emit(Dorm3dGiftMediator.DO_TALK, var0_26.reply_dialogue_id, arg0_27)
		end)
	end

	local var2_26 = arg0_26.proxy:getGiftUnlockTalk(arg0_26.apartment.configId, arg1_26)

	if var2_26 then
		table.insert(var1_26, function(arg0_28)
			pg.TipsMgr.GetInstance():ShowTips(string.format("talk %d is unlocked", var2_26))
			arg0_28()
		end)
	end

	seriesAsync(var1_26, function()
		arg0_26:emit(Dorm3dGiftMediator.CHECK_LEVEL_UP)
	end)
end

function var0_0.UpdateFavorPanel(arg0_30)
	local var0_30 = arg0_30.apartment.favor
	local var1_30 = arg0_30.apartment:getNextExp()

	setText(arg0_30.rtFavorPanel:Find("info/Text"), string.format("Lv.%d", arg0_30.apartment.level))
	setText(arg0_30.rtFavorPanel:Find("info/Text_1"), string.format("<color=#FFFFFF>%d</color>/%d", var0_30, var1_30))
	setSlider(arg0_30.rtFavorPanel:Find("slider"), 0, var1_30, var0_30)
end

function var0_0.OpenInfoWindow(arg0_31, arg1_31)
	local var0_31 = arg0_31.rtInfoWindow:Find("panel")

	setText(var0_31:Find("title/Text"), i18n("words_information"))
	updateDorm3dIcon(var0_31:Find("middle/Dorm3dIconTpl"), arg1_31)

	local var1_31 = arg1_31:getConfig("ship_group_id") ~= 0

	setActive(var0_31:Find("middle/Dorm3dIconTpl/mark"), var1_31)
	setText(var0_31:Find("middle/Text"), "???")
	onButton(arg0_31, var0_31:Find("bottom/btn_buy"), function()
		pg.TipsMgr.GetInstance():ShowTips("without shop config")
	end, SFX_CONFIRM)
	setActive(arg0_31.rtInfoWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_31.rtInfoWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.HideInfoWindow(arg0_33)
	setActive(arg0_33.rtInfoWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_33.rtInfoWindow, arg0_33._tf)
end

function var0_0.OpenLackWindow(arg0_34, arg1_34)
	local var0_34 = arg0_34.rtLackWindow:Find("panel")

	setText(var0_34:Find("title/Text"), i18n("child_msg_title_detail"))
	updateDorm3dIcon(var0_34:Find("middle/Dorm3dIconTpl"), arg1_34)

	local var1_34 = arg1_34:getConfig("ship_group_id") ~= 0

	setActive(var0_34:Find("middle/Dorm3dIconTpl/mark"), var1_34)
	setText(var0_34:Find("middle/info/name"), arg1_34:getName())
	setText(var0_34:Find("middle/info/count"), string.format("count:<color=#39bfff>%d</color>", arg1_34.count))
	setText(var0_34:Find("middle/info/desc"), arg1_34:getConfig("display"))
	setText(var0_34:Find("line/lack/Text"), "lack")

	local var2_34 = ItemTipPanel.GetDropLackConfig(arg1_34)
	local var3_34 = var2_34 and var2_34.description or {}
	local var4_34 = var0_34:Find("bottom/container")

	UIItemList.StaticAlign(var4_34, var4_34:Find("tpl"), #var3_34, function(arg0_35, arg1_35, arg2_35)
		arg1_35 = arg1_35 + 1

		if arg0_35 == UIItemList.EventUpdate then
			local var0_35 = var3_34[arg1_35]
			local var1_35, var2_35, var3_35 = unpack(var0_35)

			setText(arg2_35:Find("Text"), var1_35)
			setText(arg2_35:Find("btn_go/Text"), i18n("feast_res_window_go_label"))

			local var4_35, var5_35, var6_35 = unpack(var2_34)
			local var7_35, var8_35 = unpack(var5_35)
			local var9_35 = #var7_35 > 0

			if var6_35 and var6_35 ~= 0 then
				var9_35 = var9_35 and getProxy(ActivityProxy):IsActivityNotEnd(var6_35)
			end

			setActive(arg2_35:Find("btn_go"), var9_35)
			onButton(arg0_34, arg2_35:Find("btn_go"), function()
				ItemTipPanel.ConfigGoScene(var7_35, var8_35, function()
					arg0_34:closeView()
				end)
			end, SFX_PANEL)
		end
	end)
	setActive(arg0_34.rtLackWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_34.rtLackWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0_0.HideLackWindow(arg0_38)
	setActive(arg0_38.rtLackWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_38.rtLackWindow, arg0_38._tf)
end

function var0_0.onBackPressed(arg0_39)
	if isActive(arg0_39.rtInfoWindow) then
		arg0_39:HideInfoWindow()

		return
	end

	if isActive(arg0_39.rtLackWindow) then
		arg0_39:HideLackWindow()

		return
	end

	var0_0.super.onBackPressed(arg0_39)
end

function var0_0.willExit(arg0_40)
	if isActive(arg0_40.rtInfoWindow) then
		arg0_40:HideInfoWindow()
	end

	if isActive(arg0_40.rtLackWindow) then
		arg0_40:HideLackWindow()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_40._tf)
end

return var0_0
