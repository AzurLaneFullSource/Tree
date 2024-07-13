local var0_0 = class("MailOverflowWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MailOverflowMsgboxUI"
end

function var0_0.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.closeBtn = arg0_2:findTF("adapt/window_overflow/top/btnBack")

	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2._window_overflow = arg0_2._tf:Find("adapt/window_overflow")
	arg0_2.titleTips = arg0_2._window_overflow:Find("top/bg/infomation/title")
	arg0_2._itemConfireText = arg0_2._window_overflow:Find("content")
	arg0_2._confireLabel = arg0_2._window_overflow:Find("desc/label1")
	arg0_2._confireInput = arg0_2._window_overflow:Find("desc/InputField")
	arg0_2._overflowtitleTips = arg0_2._window_overflow:Find("top/bg/infomation/title")
	arg0_2.PlaceholderText = arg0_2._confireInput:Find("Placeholder")
	arg0_2._overflowcancelButton = arg0_2._window_overflow:Find("button_container/btn_not")
	arg0_2._overflowconfirmButton = arg0_2._window_overflow:Find("button_container/btn_ok")
	arg0_2.item = arg0_2._window_overflow:Find("item")
	arg0_2.items = arg0_2._window_overflow:Find("items")
	arg0_2.itemList = UIItemList.New(arg0_2.items, arg0_2.item)

	setText(arg0_2._overflowcancelButton:Find("Text"), i18n("mail_box_cancel"))
	setText(arg0_2._overflowconfirmButton:Find("Text"), i18n("mail_box_confirm"))
	setText(arg0_2.titleTips, i18n("mail_boxtitle_information"))
	setText(arg0_2.PlaceholderText, i18n("mail_search"))
end

function var0_0.Updatelayout(arg0_5)
	if not arg0_5.key then
		arg0_5.key = math.random(100000, 999999)

		setText(arg0_5._confireLabel, i18n("mail_storeroom_max_2", arg0_5.key))
	else
		setText(arg0_5._confireLabel, "")
	end
end

function var0_0.showConformMsgBox(arg0_6, arg1_6)
	setText(arg0_6._itemConfireText, arg1_6.content)

	arg0_6.key = nil

	arg0_6:Updatelayout()
	onButton(arg0_6, arg0_6._overflowcancelButton, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._overflowconfirmButton, function()
		if arg0_6.key then
			local var0_8 = getInputText(arg0_6._confireInput)

			if arg0_6.key ~= tonumber(var0_8) then
				pg.TipsMgr:GetInstance():ShowTips(i18n("mail_input_erro"))

				return
			end
		end

		arg0_6:Hide()

		if arg1_6.onYes then
			arg1_6.onYes()
		end
	end, SFX_PANEL)
	setActive(arg0_6.item, false)
	arg0_6.itemList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg2_9:Find("IconTpl")
			local var1_9 = arg1_6.dropList[arg1_9 + 1]
			local var2_9 = {
				type = var1_9.type,
				id = var1_9.id,
				count = var1_9.count
			}

			updateDrop(var0_9, var2_9)
		end
	end)
	arg0_6.itemList:align(#arg1_6.dropList)
end

function var0_0.Show(arg0_10, arg1_10)
	var0_0.super.Show(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
	arg0_10:showConformMsgBox(arg1_10)
end

function var0_0.Hide(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, arg0_11._parentTf)
	var0_0.super.Hide(arg0_11)
	setInputText(arg0_11._confireInput, "")
end

function var0_0.OnDestroy(arg0_12)
	if arg0_12:isShowing() then
		arg0_12:Hide()
	end
end

return var0_0
