local var0_0 = class("MailConfirmationWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MailConfirmationMsgboxUI"
end

function var0_0.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.closeBtn = arg0_2:findTF("adapt/window/top/btnBack")

	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.cancelButton = arg0_2:findTF("adapt/window/button_container/btn_not")
	arg0_2.confirmButton = arg0_2:findTF("adapt/window/button_container/btn_ok")
	arg0_2._window = arg0_2._tf:Find("adapt/window")
	arg0_2._window_details = arg0_2._tf:Find("adapt/window_details")
	arg0_2.titleTips = arg0_2._window:Find("top/bg/infomation/title")
	arg0_2._msgPanel = arg0_2._window:Find("msg_panel")
	arg0_2.contentText = arg0_2._window:Find("msg_panel/content")
	arg0_2._itemPanel = arg0_2._window:Find("item_panel")
	arg0_2._itemText = arg0_2._itemPanel:Find("tip/confire_text"):GetComponent(typeof(Text))
	arg0_2._itemListItemContainer = arg0_2._itemPanel:Find("scrollview/list")
	arg0_2._itemListItemTpl = arg0_2._itemListItemContainer:Find("item")
	arg0_2._deltailBtn = arg0_2._itemPanel:Find("tip/more_btn")
	arg0_2.rewardList = arg0_2._itemPanel:Find("scrollview/list"):GetComponent("LScrollRect")

	function arg0_2.rewardList.onUpdateItem(arg0_5, arg1_5)
		arg0_5 = arg0_5 + 1

		local var0_5 = arg0_2.items[arg0_5]

		updateDrop(tf(arg1_5):Find("IconTpl"), var0_5)

		local var1_5 = tf(arg1_5):Find("IconTpl/name")

		setText(var1_5, shortenString(getText(var1_5), 4))
	end

	arg0_2._deltailBtnSelectBg = arg0_2._deltailBtn:Find("selectBg")
	arg0_2._deltailBtnUnSelectBg = arg0_2._deltailBtn:Find("unselectBg")
	arg0_2._totolmailCountText = arg0_2._window_details:Find("top/mail/Text")
	arg0_2._mailGettitle = arg0_2._window_details:Find("top/bg/infomation/title")
	arg0_2.lsrMailList = arg0_2._window_details:Find("item_panel/scrollview/list"):GetComponent("LScrollRect")

	function arg0_2.lsrMailList.onUpdateItem(arg0_6, arg1_6)
		arg0_6 = arg0_6 + 1

		local var0_6 = arg0_2.filterMails[arg0_6]

		setText(tf(arg1_6):Find("Text"), shortenString(HXSet.hxLan(var0_6.title), 10))
	end

	arg0_2.mailids = {}

	onButton(arg0_2, arg0_2._deltailBtn, function()
		if arg0_2.require then
			return
		end

		arg0_2.require = true

		arg0_2:emit(MailMediator.ON_GET_MAIL_TITLE, arg0_2.mailids, function(arg0_8)
			SetActive(arg0_2._deltailBtnUnSelectBg, false)
			SetActive(arg0_2._deltailBtnSelectBg, true)
			setActive(arg0_2._window_details, true)
			setText(arg0_2._mailGettitle, i18n("mail_getbox_title"))

			arg0_2.filterMails = arg0_8

			table.sort(arg0_2.filterMails, CompareFuncs({
				function(arg0_9)
					return -arg0_9.id
				end
			}))
			setText(arg0_2._totolmailCountText, #arg0_2.filterMails)
			arg0_2.lsrMailList:SetTotalCount(#arg0_2.filterMails, 0)
		end)
	end, SFX_PANEL)
	arg0_2:commonSettings()
	setText(arg0_2.cancelButton:Find("Text"), i18n("mail_box_cancel"))
	setText(arg0_2.confirmButton:Find("Text"), i18n("mail_box_confirm"))
	setText(arg0_2.titleTips, i18n("mail_boxtitle_information"))
end

function var0_0.showTipsBox(arg0_10, arg1_10)
	SetActive(arg0_10._msgPanel, true)
	setText(arg0_10.contentText, arg1_10.content)
end

function var0_0.showItemBox(arg0_11, arg1_11)
	SetActive(arg0_11._itemPanel, true)
	SetActive(arg0_11._deltailBtnUnSelectBg, true)
	SetActive(arg0_11._deltailBtnSelectBg, false)

	arg0_11.mailids = arg1_11.mailids
	arg0_11._itemText.text = arg1_11.content or ""

	setText(arg0_11._deltailBtn:Find("Text"), i18n("mail_take_maildetail_msgbox"))

	arg0_11.items = arg1_11.items

	local var0_11 = #arg0_11.items

	arg0_11.rewardList:SetTotalCount(var0_11, 0)
end

function var0_0.commonSettings(arg0_12)
	setActive(arg0_12._msgPanel, false)
	setActive(arg0_12._itemPanel, false)
	setActive(arg0_12._window_details, false)

	arg0_12.require = false
end

function var0_0.Show(arg0_13, arg1_13)
	var0_0.super.Show(arg0_13)
	pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
	arg0_13:commonSettings()
	switch(arg1_13.type, {
		[MailProxy.MailMessageBoxType.ReceiveAward] = function()
			arg0_13:showItemBox(arg1_13)
		end,
		[MailProxy.MailMessageBoxType.ShowTips] = function()
			arg0_13:showTipsBox(arg1_13)
		end
	})
	onButton(arg0_13, arg0_13.cancelButton, function()
		arg0_13:Hide()
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.confirmButton, function()
		arg0_13:Hide()

		if arg1_13.onYes then
			arg1_13.onYes()
		end
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_18)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_18._tf, arg0_18._parentTf)
	var0_0.super.Hide(arg0_18)
end

function var0_0.OnDestroy(arg0_19)
	if arg0_19:isShowing() then
		arg0_19:Hide()
	end
end

return var0_0
