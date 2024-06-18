local var0_0 = class("AppreciateUnlockMsgBox", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "AppreciateUnlockMsgBox"
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

function var0_0.showCustomMsgBox(arg0_7, arg1_7)
	arg0_7.isShowCustomMsgBox = true
	arg0_7.settings = arg1_7

	setActive(arg0_7.customMsgbox, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7.customMsgbox, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})

	local var0_7 = arg1_7.items and #arg1_7.items > 0

	setActive(arg0_7.msgBoxItemPanel, var0_7)
	setActive(arg0_7.msgBoxContent, not var0_7)

	local var1_7 = getProxy(PlayerProxy):getData()

	if var0_7 then
		local var2_7 = arg1_7.items

		for iter0_7 = arg0_7.msgboxItemContains.childCount + 1, #var2_7 do
			cloneTplTo(arg0_7.msgBoxItemTpl, arg0_7.msgboxItemContains)
		end

		local var3_7 = arg0_7.msgboxItemContains.childCount

		for iter1_7 = 1, var3_7 do
			local var4_7 = arg0_7.msgboxItemContains:GetChild(iter1_7 - 1)

			SetActive(var4_7, iter1_7 <= #var2_7)

			if iter1_7 <= #var2_7 then
				local var5_7 = var2_7[iter1_7]

				updateDrop(var4_7, var5_7)

				local var6_7 = 0

				if var5_7.type == DROP_TYPE_RESOURCE then
					var6_7 = var1_7:getResById(var5_7.id)
				elseif var5_7.type == DROP_TYPE_ITEM then
					var6_7 = getProxy(BagProxy):getItemCountById(var5_7.id)
				end

				local var7_7 = var6_7 < var5_7.count and "<color=#D6341DFF>" .. var5_7.count .. "</color>" or "<color=#A9F548FF>" .. var5_7.count .. "</color>"

				setText(var4_7:Find("icon_bg/count"), var6_7 .. "/" .. var7_7)
			end
		end

		setText(arg0_7.msgBoxItemContent, arg1_7.content or "")
		setText(arg0_7.msgBoxItemContent1, arg1_7.content1 or "")
	else
		setText(arg0_7.msgBoxContent, arg1_7.content or "")
	end
end

function var0_0.hideCustomMsgBox(arg0_8)
	arg0_8.isShowCustomMsgBox = nil

	SetActive(arg0_8.customMsgbox, false)
	arg0_8:Destroy()
end

function var0_0.OnDestroy(arg0_9)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9.customMsgbox, arg0_9._tf)
end

return var0_0
