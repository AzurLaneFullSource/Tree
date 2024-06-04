local var0 = class("MailOverflowWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "MailOverflowMsgboxUI"
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.closeBtn = arg0:findTF("adapt/window_overflow/top/btnBack")

	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0._window_overflow = arg0._tf:Find("adapt/window_overflow")
	arg0.titleTips = arg0._window_overflow:Find("top/bg/infomation/title")
	arg0._itemConfireText = arg0._window_overflow:Find("content")
	arg0._confireLabel = arg0._window_overflow:Find("desc/label1")
	arg0._confireInput = arg0._window_overflow:Find("desc/InputField")
	arg0._overflowtitleTips = arg0._window_overflow:Find("top/bg/infomation/title")
	arg0.PlaceholderText = arg0._confireInput:Find("Placeholder")
	arg0._overflowcancelButton = arg0._window_overflow:Find("button_container/btn_not")
	arg0._overflowconfirmButton = arg0._window_overflow:Find("button_container/btn_ok")
	arg0.item = arg0._window_overflow:Find("item")
	arg0.items = arg0._window_overflow:Find("items")
	arg0.itemList = UIItemList.New(arg0.items, arg0.item)

	setText(arg0._overflowcancelButton:Find("Text"), i18n("mail_box_cancel"))
	setText(arg0._overflowconfirmButton:Find("Text"), i18n("mail_box_confirm"))
	setText(arg0.titleTips, i18n("mail_boxtitle_information"))
	setText(arg0.PlaceholderText, i18n("mail_search"))
end

function var0.Updatelayout(arg0)
	if not arg0.key then
		arg0.key = math.random(100000, 999999)

		setText(arg0._confireLabel, i18n("mail_storeroom_max_2", arg0.key))
	else
		setText(arg0._confireLabel, "")
	end
end

function var0.showConformMsgBox(arg0, arg1)
	setText(arg0._itemConfireText, arg1.content)

	arg0.key = nil

	arg0:Updatelayout()
	onButton(arg0, arg0._overflowcancelButton, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._overflowconfirmButton, function()
		if arg0.key then
			local var0 = getInputText(arg0._confireInput)

			if arg0.key ~= tonumber(var0) then
				pg.TipsMgr:GetInstance():ShowTips(i18n("mail_input_erro"))

				return
			end
		end

		arg0:Hide()

		if arg1.onYes then
			arg1.onYes()
		end
	end, SFX_PANEL)
	setActive(arg0.item, false)
	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2:Find("IconTpl")
			local var1 = arg1.dropList[arg1 + 1]
			local var2 = {
				type = var1.type,
				id = var1.id,
				count = var1.count
			}

			updateDrop(var0, var2)
		end
	end)
	arg0.itemList:align(#arg1.dropList)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:showConformMsgBox(arg1)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	var0.super.Hide(arg0)
	setInputText(arg0._confireInput, "")
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
