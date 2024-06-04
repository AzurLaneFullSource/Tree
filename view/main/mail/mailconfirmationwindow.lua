local var0 = class("MailConfirmationWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "MailConfirmationMsgboxUI"
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.closeBtn = arg0:findTF("adapt/window/top/btnBack")

	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.cancelButton = arg0:findTF("adapt/window/button_container/btn_not")
	arg0.confirmButton = arg0:findTF("adapt/window/button_container/btn_ok")
	arg0._window = arg0._tf:Find("adapt/window")
	arg0._window_details = arg0._tf:Find("adapt/window_details")
	arg0.titleTips = arg0._window:Find("top/bg/infomation/title")
	arg0._msgPanel = arg0._window:Find("msg_panel")
	arg0.contentText = arg0._window:Find("msg_panel/content")
	arg0._itemPanel = arg0._window:Find("item_panel")
	arg0._itemText = arg0._itemPanel:Find("tip/confire_text"):GetComponent(typeof(Text))
	arg0._itemListItemContainer = arg0._itemPanel:Find("scrollview/list")
	arg0._itemListItemTpl = arg0._itemListItemContainer:Find("item")
	arg0._deltailBtn = arg0._itemPanel:Find("tip/more_btn")
	arg0.rewardList = arg0._itemPanel:Find("scrollview/list"):GetComponent("LScrollRect")

	function arg0.rewardList.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1

		local var0 = arg0.items[arg0]

		updateDrop(tf(arg1):Find("IconTpl"), var0)

		local var1 = tf(arg1):Find("IconTpl/name")

		setText(var1, shortenString(getText(var1), 4))
	end

	arg0._deltailBtnSelectBg = arg0._deltailBtn:Find("selectBg")
	arg0._deltailBtnUnSelectBg = arg0._deltailBtn:Find("unselectBg")
	arg0._totolmailCountText = arg0._window_details:Find("top/mail/Text")
	arg0._mailGettitle = arg0._window_details:Find("top/bg/infomation/title")
	arg0.lsrMailList = arg0._window_details:Find("item_panel/scrollview/list"):GetComponent("LScrollRect")

	function arg0.lsrMailList.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1

		local var0 = arg0.filterMails[arg0]

		setText(tf(arg1):Find("Text"), shortenString(HXSet.hxLan(var0.title), 10))
	end

	arg0.mailids = {}

	onButton(arg0, arg0._deltailBtn, function()
		if arg0.require then
			return
		end

		arg0.require = true

		arg0:emit(MailMediator.ON_GET_MAIL_TITLE, arg0.mailids, function(arg0)
			SetActive(arg0._deltailBtnUnSelectBg, false)
			SetActive(arg0._deltailBtnSelectBg, true)
			setActive(arg0._window_details, true)
			setText(arg0._mailGettitle, i18n("mail_getbox_title"))

			arg0.filterMails = arg0

			table.sort(arg0.filterMails, CompareFuncs({
				function(arg0)
					return -arg0.id
				end
			}))
			setText(arg0._totolmailCountText, #arg0.filterMails)
			arg0.lsrMailList:SetTotalCount(#arg0.filterMails, 0)
		end)
	end, SFX_PANEL)
	arg0:commonSettings()
	setText(arg0.cancelButton:Find("Text"), i18n("mail_box_cancel"))
	setText(arg0.confirmButton:Find("Text"), i18n("mail_box_confirm"))
	setText(arg0.titleTips, i18n("mail_boxtitle_information"))
end

function var0.showTipsBox(arg0, arg1)
	SetActive(arg0._msgPanel, true)
	setText(arg0.contentText, arg1.content)
end

function var0.showItemBox(arg0, arg1)
	SetActive(arg0._itemPanel, true)
	SetActive(arg0._deltailBtnUnSelectBg, true)
	SetActive(arg0._deltailBtnSelectBg, false)

	arg0.mailids = arg1.mailids
	arg0._itemText.text = arg1.content or ""

	setText(arg0._deltailBtn:Find("Text"), i18n("mail_take_maildetail_msgbox"))

	arg0.items = arg1.items

	local var0 = #arg0.items

	arg0.rewardList:SetTotalCount(var0, 0)
end

function var0.commonSettings(arg0)
	setActive(arg0._msgPanel, false)
	setActive(arg0._itemPanel, false)
	setActive(arg0._window_details, false)

	arg0.require = false
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:commonSettings()
	switch(arg1.type, {
		[MailProxy.MailMessageBoxType.ReceiveAward] = function()
			arg0:showItemBox(arg1)
		end,
		[MailProxy.MailMessageBoxType.ShowTips] = function()
			arg0:showTipsBox(arg1)
		end
	})
	onButton(arg0, arg0.cancelButton, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmButton, function()
		arg0:Hide()

		if arg1.onYes then
			arg1.onYes()
		end
	end, SFX_PANEL)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
