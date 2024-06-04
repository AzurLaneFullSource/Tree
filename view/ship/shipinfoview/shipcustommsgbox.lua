local var0 = class("ShipCustomMsgBox", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShipCustomMsgBox"
end

function var0.OnInit(arg0)
	arg0.customMsgbox = arg0._tf
	arg0.msgBoxItemPanel = arg0.customMsgbox:Find("frame/bg/item_panel")
	arg0.msgboxItemContains = arg0.customMsgbox:Find("frame/bg/item_panel/items")
	arg0.msgBoxItemTpl = arg0.msgboxItemContains:Find("equipmenttpl")
	arg0.msgBoxItemContent = arg0.customMsgbox:Find("frame/bg/item_panel/content")
	arg0.msgBoxItemContent1 = arg0.customMsgbox:Find("frame/bg/item_panel/content_num")
	arg0.msgBoxCancelBtn = arg0.customMsgbox:Find("frame/btns/cancel_btn")
	arg0.msgBoxConfirmBtn = arg0.customMsgbox:Find("frame/btns/confirm_btn")
	arg0.msgBoxContent = arg0.customMsgbox:Find("frame/bg/content")
	arg0.msgBtnBack = arg0.customMsgbox:Find("frame/top/btnBack")
	arg0.msgBoxTitle = arg0.customMsgbox:Find("frame/top/title_list/infomation/title")
	arg0.msgBoxTitleEn = arg0.customMsgbox:Find("frame/top/title_list/infomation/title_en")

	SetActive(arg0.customMsgbox, false)

	arg0.settings = {}

	onButton(arg0, arg0.msgBoxConfirmBtn, function()
		if arg0.settings.onYes then
			arg0.settings.onYes()
		else
			arg0:hideCustomMsgBox()
		end
	end, SFX_PANEL)
	SetActive(arg0.msgBoxCancelBtn, not defaultValue(arg0.settings.hideNO, false))
	onButton(arg0, arg0.msgBoxCancelBtn, function()
		if arg0.settings.onCancel then
			arg0.settings.onCancel()
		else
			arg0:hideCustomMsgBox()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.customMsgbox, function()
		arg0:hideCustomMsgBox()
	end, SFX_PANEL)
	onButton(arg0, arg0.msgBtnBack, function()
		arg0:hideCustomMsgBox()
	end, SFX_CANCEL)
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.showCustomMsgBox(arg0, arg1)
	arg0.isShowCustomMsgBox = true
	arg0.settings = arg1

	setActive(arg0.customMsgbox, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.customMsgbox, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})

	local var0 = arg1.items and #arg1.items > 0

	setActive(arg0.msgBoxItemPanel, var0)
	setActive(arg0.msgBoxContent, not var0)

	if var0 then
		local var1 = arg1.items

		for iter0 = arg0.msgboxItemContains.childCount + 1, #var1 do
			cloneTplTo(arg0.msgBoxItemTpl, arg0.msgboxItemContains)
		end

		local var2 = arg0.msgboxItemContains.childCount

		for iter1 = 1, var2 do
			local var3 = arg0.msgboxItemContains:GetChild(iter1 - 1)

			SetActive(var3, iter1 <= #var1)

			if iter1 <= #var1 then
				local var4 = var1[iter1]

				updateDrop(var3, var4)

				local var5 = 0

				if var4.type == DROP_TYPE_RESOURCE then
					var5 = arg0.shareData.player:getResById(var4.id)
				elseif var4.type == DROP_TYPE_ITEM then
					var5 = getProxy(BagProxy):getItemCountById(var4.id)
				end

				local var6 = var4.count

				var5 = var5 < var6 and "<color=#D6341DFF>" .. var5 .. "</color>" or "<color=#A9F548FF>" .. var5 .. "</color>"

				setText(var3:Find("icon_bg/count"), var5 .. "/" .. var6)
			end
		end

		setText(arg0.msgBoxItemContent, arg1.content or "")
		setText(arg0.msgBoxItemContent1, arg1.content1 or "")
	else
		setText(arg0.msgBoxContent, arg1.content or "")
	end

	if arg1.title then
		local var7 = arg1.title.title
		local var8 = arg1.title.titleEn

		setText(arg0.msgBoxTitle, var7)
		setText(arg0.msgBoxTitleEn, var8 or "")
	end
end

function var0.hideCustomMsgBox(arg0)
	arg0.isShowCustomMsgBox = nil

	SetActive(arg0.customMsgbox, false)
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.customMsgbox, arg0._tf)

	arg0.shareData = nil
end

return var0
