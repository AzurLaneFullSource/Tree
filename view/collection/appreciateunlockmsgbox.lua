local var0 = class("AppreciateUnlockMsgBox", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "AppreciateUnlockMsgBox"
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

	local var1 = getProxy(PlayerProxy):getData()

	if var0 then
		local var2 = arg1.items

		for iter0 = arg0.msgboxItemContains.childCount + 1, #var2 do
			cloneTplTo(arg0.msgBoxItemTpl, arg0.msgboxItemContains)
		end

		local var3 = arg0.msgboxItemContains.childCount

		for iter1 = 1, var3 do
			local var4 = arg0.msgboxItemContains:GetChild(iter1 - 1)

			SetActive(var4, iter1 <= #var2)

			if iter1 <= #var2 then
				local var5 = var2[iter1]

				updateDrop(var4, var5)

				local var6 = 0

				if var5.type == DROP_TYPE_RESOURCE then
					var6 = var1:getResById(var5.id)
				elseif var5.type == DROP_TYPE_ITEM then
					var6 = getProxy(BagProxy):getItemCountById(var5.id)
				end

				local var7 = var6 < var5.count and "<color=#D6341DFF>" .. var5.count .. "</color>" or "<color=#A9F548FF>" .. var5.count .. "</color>"

				setText(var4:Find("icon_bg/count"), var6 .. "/" .. var7)
			end
		end

		setText(arg0.msgBoxItemContent, arg1.content or "")
		setText(arg0.msgBoxItemContent1, arg1.content1 or "")
	else
		setText(arg0.msgBoxContent, arg1.content or "")
	end
end

function var0.hideCustomMsgBox(arg0)
	arg0.isShowCustomMsgBox = nil

	SetActive(arg0.customMsgbox, false)
	arg0:Destroy()
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.customMsgbox, arg0._tf)
end

return var0
