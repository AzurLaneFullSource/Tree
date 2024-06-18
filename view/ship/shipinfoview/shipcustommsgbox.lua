local var0_0 = class("ShipCustomMsgBox", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipCustomMsgBox"
end

function var0_0.OnInit(arg0_2)
	arg0_2.customMsgbox = arg0_2._tf
	arg0_2.msgBoxItemPanel = arg0_2.customMsgbox:Find("frame/bg/item_panel")
	arg0_2.msgboxItemContains = arg0_2.customMsgbox:Find("frame/bg/item_panel/items")
	arg0_2.msgBoxItemTpl = arg0_2.msgboxItemContains:Find("equipmenttpl")
	arg0_2.msgBoxItemContent = arg0_2.customMsgbox:Find("frame/bg/item_panel/content")
	arg0_2.msgBoxItemContent1 = arg0_2.customMsgbox:Find("frame/bg/item_panel/content_num")
	arg0_2.msgBoxCancelBtn = arg0_2.customMsgbox:Find("frame/btns/cancel_btn")
	arg0_2.msgBoxConfirmBtn = arg0_2.customMsgbox:Find("frame/btns/confirm_btn")
	arg0_2.msgBoxContent = arg0_2.customMsgbox:Find("frame/bg/content")
	arg0_2.msgBtnBack = arg0_2.customMsgbox:Find("frame/top/btnBack")
	arg0_2.msgBoxTitle = arg0_2.customMsgbox:Find("frame/top/title_list/infomation/title")
	arg0_2.msgBoxTitleEn = arg0_2.customMsgbox:Find("frame/top/title_list/infomation/title_en")

	SetActive(arg0_2.customMsgbox, false)

	arg0_2.settings = {}

	onButton(arg0_2, arg0_2.msgBoxConfirmBtn, function()
		if arg0_2.settings.onYes then
			arg0_2.settings.onYes()
		else
			arg0_2:hideCustomMsgBox()
		end
	end, SFX_PANEL)
	SetActive(arg0_2.msgBoxCancelBtn, not defaultValue(arg0_2.settings.hideNO, false))
	onButton(arg0_2, arg0_2.msgBoxCancelBtn, function()
		if arg0_2.settings.onCancel then
			arg0_2.settings.onCancel()
		else
			arg0_2:hideCustomMsgBox()
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.customMsgbox, function()
		arg0_2:hideCustomMsgBox()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.msgBtnBack, function()
		arg0_2:hideCustomMsgBox()
	end, SFX_CANCEL)
end

function var0_0.SetShareData(arg0_7, arg1_7)
	arg0_7.shareData = arg1_7
end

function var0_0.showCustomMsgBox(arg0_8, arg1_8)
	arg0_8.isShowCustomMsgBox = true
	arg0_8.settings = arg1_8

	setActive(arg0_8.customMsgbox, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8.customMsgbox, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})

	local var0_8 = arg1_8.items and #arg1_8.items > 0

	setActive(arg0_8.msgBoxItemPanel, var0_8)
	setActive(arg0_8.msgBoxContent, not var0_8)

	if var0_8 then
		local var1_8 = arg1_8.items

		for iter0_8 = arg0_8.msgboxItemContains.childCount + 1, #var1_8 do
			cloneTplTo(arg0_8.msgBoxItemTpl, arg0_8.msgboxItemContains)
		end

		local var2_8 = arg0_8.msgboxItemContains.childCount

		for iter1_8 = 1, var2_8 do
			local var3_8 = arg0_8.msgboxItemContains:GetChild(iter1_8 - 1)

			SetActive(var3_8, iter1_8 <= #var1_8)

			if iter1_8 <= #var1_8 then
				local var4_8 = var1_8[iter1_8]

				updateDrop(var3_8, var4_8)

				local var5_8 = 0

				if var4_8.type == DROP_TYPE_RESOURCE then
					var5_8 = arg0_8.shareData.player:getResById(var4_8.id)
				elseif var4_8.type == DROP_TYPE_ITEM then
					var5_8 = getProxy(BagProxy):getItemCountById(var4_8.id)
				end

				local var6_8 = var4_8.count

				var5_8 = var5_8 < var6_8 and "<color=#D6341DFF>" .. var5_8 .. "</color>" or "<color=#A9F548FF>" .. var5_8 .. "</color>"

				setText(var3_8:Find("icon_bg/count"), var5_8 .. "/" .. var6_8)
			end
		end

		setText(arg0_8.msgBoxItemContent, arg1_8.content or "")
		setText(arg0_8.msgBoxItemContent1, arg1_8.content1 or "")
	else
		setText(arg0_8.msgBoxContent, arg1_8.content or "")
	end

	if arg1_8.title then
		local var7_8 = arg1_8.title.title
		local var8_8 = arg1_8.title.titleEn

		setText(arg0_8.msgBoxTitle, var7_8)
		setText(arg0_8.msgBoxTitleEn, var8_8 or "")
	end
end

function var0_0.hideCustomMsgBox(arg0_9)
	arg0_9.isShowCustomMsgBox = nil

	SetActive(arg0_9.customMsgbox, false)
end

function var0_0.OnDestroy(arg0_10)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10.customMsgbox, arg0_10._tf)

	arg0_10.shareData = nil
end

return var0_0
