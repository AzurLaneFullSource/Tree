local var0 = class("Dorm3dGiftLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dGiftUI"
end

function var0.init(arg0)
	local var0 = arg0._tf:Find("btn_back")

	onButton(arg0, var0, function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.rtGiftPanel = arg0._tf:Find("gift_panel")

	eachChild(arg0.rtGiftPanel:Find("content/toggles"), function(arg0)
		onToggle(arg0, arg0, function(arg0)
			if arg0 then
				arg0:UpdateSelectToggle(arg0.name)
			end
		end, SFX_PANEL)
	end)

	local var1 = arg0.rtGiftPanel:Find("content/view/container")

	arg0.giftItemList = UIItemList.New(var1, var1:Find("tpl"))

	arg0.giftItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateGift(arg2, arg0.filterGiftIds[arg1])
		end
	end)

	arg0.btnConfirm = arg0.rtGiftPanel:Find("bottom/btn_confirm")

	onButton(arg0, arg0.btnConfirm, function()
		arg0:ConfirmGiveGifts()
	end, SFX_CONFIRM)

	arg0.rtFavorPanel = arg0._tf:Find("favor_panel")
	arg0.rtInfoWindow = arg0._tf:Find("info_window")

	onButton(arg0, arg0.rtInfoWindow:Find("bg"), function()
		arg0:HideInfoWindow()
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtInfoWindow:Find("panel/title/btn_close"), function()
		arg0:HideInfoWindow()
	end, SFX_CANCEL)

	arg0.rtLackWindow = arg0._tf:Find("lack_window")

	onButton(arg0, arg0.rtLackWindow:Find("bg"), function()
		arg0:HideLackWindow()
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtLackWindow:Find("panel/title/btn_close"), function()
		arg0:HideLackWindow()
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0._tf, {
		pbList = {
			arg0.rtGiftPanel
		},
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0.SetApartment(arg0, arg1)
	arg0.apartment = arg1
	arg0.giftIds = arg0.apartment:getGiftIds()
	arg0.proxy = getProxy(ApartmentProxy)
end

function var0.didEnter(arg0)
	triggerToggle(arg0.rtGiftPanel:Find("content/toggles/all"), true)
	arg0:UpdateFavorPanel()
	arg0:UpdateConfirmBtn()
end

function var0.UpdateSelectToggle(arg0, arg1)
	if arg0.toggleState == arg1 then
		return
	end

	arg0.toggleState = arg1
	arg0.filterGiftIds = underscore.filter(arg0.giftIds, function(arg0)
		return arg1 == "all" or arg1 == "normal" == (pg.dorm3d_gift[arg0].ship_group_id == 0)
	end)

	table.sort(arg0.filterGiftIds, CompareFuncs({
		function(arg0)
			return (arg0.proxy:getGiftCount(arg0) > 0 and -1 or 1) * (pg.dorm3d_gift[arg0].ship_group_id == 0 and 1 or 2)
		end,
		function(arg0)
			return pg.dorm3d_gift[arg0].ship_group_id > 0 and arg0.proxy:isGiveGiftDone(arg0) and 1 or 0
		end,
		function(arg0)
			return arg0
		end
	}))
	arg0.giftItemList:align(#arg0.filterGiftIds)
end

function var0.UpdateGift(arg0, arg1, arg2)
	local var0 = arg1:Find("base")
	local var1 = Drop.New({
		type = DROP_TYPE_DORM3D_GIFT,
		id = arg2,
		count = arg0.proxy:getGiftCount(arg2)
	})

	updateDorm3dIcon(var0:Find("Dorm3dIconTpl"), var1)
	setText(var0:Find("info/name"), var1:getName())

	local var2 = var1:getConfig("ship_group_id") ~= 0

	setActive(var0:Find("mark"), var2)
	setActive(var0:Find("bg/normal"), not var2)
	setActive(var0:Find("bg/pro"), var2)
	setText(var0:Find("info/Text"), i18n("dorm3d_gift_owner_num") .. string.format("%d", var1.count))

	local var3 = var0:Find("info/effect")

	setActive(var3:Find("favor"), true)

	local var4 = pg.dorm3d_favor_trigger[var1.cfg.favor_trigger_id].num

	setText(var3:Find("favor/number"), "+" .. var4)
	setActive(var3:Find("story"), var2)
	onButton(arg0, var0:Find("info/btn_info"), function()
		arg0:OpenInfoWindow(var1)
	end, SFX_PANEL)

	local var5 = var2 and arg0.proxy:isGiveGiftDone(arg2)
	local var6 = var1.count == 0 and not var5

	setActive(var0:Find("info/lack"), var6)
	onButton(arg0, var0:Find("info/lack"), function()
		arg0:OpenLackWindow(var1)
	end, SFX_PANEL)
	setActive(arg1:Find("mask"), var5)
	setText(arg1:Find("mask/Image/Text"), "is Done")
	onToggle(arg0, arg1, function(arg0)
		if arg0 then
			arg0.selectGiftId = arg2

			arg0:UpdateConfirmBtn()
		elseif arg0.selectGiftId == arg2 then
			arg0.selectGiftId = nil

			arg0:UpdateConfirmBtn()
		end
	end, SFX_PANEL)
	setToggleEnabled(arg1, not var5)
	triggerToggle(arg1, false)
end

function var0.SingleUpdateGift(arg0, arg1)
	local var0 = table.indexof(arg0.filterGiftIds, arg1)

	if var0 > 0 then
		arg0:UpdateGift(arg0.giftItemList.container:GetChild(var0 - 1), arg1)
	end
end

function var0.UpdateConfirmBtn(arg0)
	setButtonEnabled(arg0.btnConfirm, tobool(arg0.selectGiftId))
end

function var0.ConfirmGiveGifts(arg0)
	if arg0.proxy:getGiftCount(arg0.selectGiftId) == 0 then
		if pg.dorm3d_gift[arg0.selectGiftId].ship_group_id > 0 and arg0.proxy:isGiveGiftDone(arg0.selectGiftId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("该礼物已赠送"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("当前未拥有该礼物"))
		end

		return
	end

	arg0:emit(Dorm3dGiftMediator.GIVE_GIFT, arg0.selectGiftId)
end

function var0.AfterGiveGift(arg0, arg1)
	local var0 = pg.dorm3d_gift[arg1]
	local var1 = {}

	if var0.reply_dialogue_id ~= 0 then
		table.insert(var1, function(arg0)
			arg0:emit(Dorm3dGiftMediator.DO_TALK, var0.reply_dialogue_id, arg0)
		end)
	end

	local var2 = arg0.proxy:getGiftUnlockTalk(arg0.apartment.configId, arg1)

	if var2 then
		table.insert(var1, function(arg0)
			pg.TipsMgr.GetInstance():ShowTips(string.format("talk %d is unlocked", var2))
			arg0()
		end)
	end

	seriesAsync(var1, function()
		arg0:emit(Dorm3dGiftMediator.CHECK_LEVEL_UP)
	end)
end

function var0.UpdateFavorPanel(arg0)
	local var0 = arg0.apartment.favor
	local var1 = arg0.apartment:getNextExp()

	setText(arg0.rtFavorPanel:Find("info/Text"), string.format("Lv.%d", arg0.apartment.level))
	setText(arg0.rtFavorPanel:Find("info/Text_1"), string.format("<color=#FFFFFF>%d</color>/%d", var0, var1))
	setSlider(arg0.rtFavorPanel:Find("slider"), 0, var1, var0)
end

function var0.OpenInfoWindow(arg0, arg1)
	local var0 = arg0.rtInfoWindow:Find("panel")

	setText(var0:Find("title/Text"), i18n("words_information"))
	updateDorm3dIcon(var0:Find("middle/Dorm3dIconTpl"), arg1)

	local var1 = arg1:getConfig("ship_group_id") ~= 0

	setActive(var0:Find("middle/Dorm3dIconTpl/mark"), var1)
	setText(var0:Find("middle/Text"), "???")
	onButton(arg0, var0:Find("bottom/btn_buy"), function()
		pg.TipsMgr.GetInstance():ShowTips("without shop config")
	end, SFX_CONFIRM)
	setActive(arg0.rtInfoWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.rtInfoWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0.HideInfoWindow(arg0)
	setActive(arg0.rtInfoWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.rtInfoWindow, arg0._tf)
end

function var0.OpenLackWindow(arg0, arg1)
	local var0 = arg0.rtLackWindow:Find("panel")

	setText(var0:Find("title/Text"), i18n("child_msg_title_detail"))
	updateDorm3dIcon(var0:Find("middle/Dorm3dIconTpl"), arg1)

	local var1 = arg1:getConfig("ship_group_id") ~= 0

	setActive(var0:Find("middle/Dorm3dIconTpl/mark"), var1)
	setText(var0:Find("middle/info/name"), arg1:getName())
	setText(var0:Find("middle/info/count"), string.format("count:<color=#39bfff>%d</color>", arg1.count))
	setText(var0:Find("middle/info/desc"), arg1:getConfig("display"))
	setText(var0:Find("line/lack/Text"), "lack")

	local var2 = ItemTipPanel.GetDropLackConfig(arg1)
	local var3 = var2 and var2.description or {}
	local var4 = var0:Find("bottom/container")

	UIItemList.StaticAlign(var4, var4:Find("tpl"), #var3, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var3[arg1]
			local var1, var2, var3 = unpack(var0)

			setText(arg2:Find("Text"), var1)
			setText(arg2:Find("btn_go/Text"), i18n("feast_res_window_go_label"))

			local var4, var5, var6 = unpack(var2)
			local var7, var8 = unpack(var5)
			local var9 = #var7 > 0

			if var6 and var6 ~= 0 then
				var9 = var9 and getProxy(ActivityProxy):IsActivityNotEnd(var6)
			end

			setActive(arg2:Find("btn_go"), var9)
			onButton(arg0, arg2:Find("btn_go"), function()
				ItemTipPanel.ConfigGoScene(var7, var8, function()
					arg0:closeView()
				end)
			end, SFX_PANEL)
		end
	end)
	setActive(arg0.rtLackWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.rtLackWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
end

function var0.HideLackWindow(arg0)
	setActive(arg0.rtLackWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.rtLackWindow, arg0._tf)
end

function var0.onBackPressed(arg0)
	if isActive(arg0.rtInfoWindow) then
		arg0:HideInfoWindow()

		return
	end

	if isActive(arg0.rtLackWindow) then
		arg0:HideLackWindow()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	if isActive(arg0.rtInfoWindow) then
		arg0:HideInfoWindow()
	end

	if isActive(arg0.rtLackWindow) then
		arg0:HideLackWindow()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
