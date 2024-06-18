local var0_0 = class("SettingsAccountSpecialPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsAccountSpecial"
end

function var0_0.GetTitle(arg0_2)
	return i18n("settings_title_account_del")
end

function var0_0.GetTitleEn(arg0_3)
	return " / ACCOUNT SETTING"
end

function var0_0.OnInit(arg0_4)
	arg0_4:findUI()
	arg0_4:addListener()
end

function var0_0.OnUpdate(arg0_5)
	return
end

function var0_0.findUI(arg0_6)
	arg0_6.expandBtn = arg0_6._tf:Find("ExpandBtn")
	arg0_6.panel = arg0_6._tf:Find("Panel")
	arg0_6.deleteTitle = arg0_6.panel:Find("Notice/DelTitle")
	arg0_6.deleteDesc = arg0_6.panel:Find("Notice/Text")
	arg0_6.confirmText = arg0_6.panel:Find("Confirm/Text")
	arg0_6.comfirmToggle = arg0_6.panel:Find("Confirm/Text/Toggle")
	arg0_6.delBtnDiasble = arg0_6.panel:Find("DelBtnDisable")
	arg0_6.delBtn = arg0_6.panel:Find("DelBtn")

	local var0_6 = arg0_6.delBtnDiasble:Find("Text")
	local var1_6 = arg0_6.delBtn:Find("Text")

	setText(arg0_6.deleteTitle, i18n("settings_text_account_del"))
	setText(arg0_6.deleteDesc, i18n("settings_text_account_del_desc"))
	setText(arg0_6.confirmText, i18n("settings_text_account_del_confirm"))
	setText(var0_6, i18n("settings_text_account_del_btn"))
	setText(var1_6, i18n("settings_text_account_del_btn"))
	triggerToggle(arg0_6.comfirmToggle, false)
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.expandBtn, function()
		setSizeDelta(arg0_7._tf, {
			x = 1558,
			y = 515
		})
		scrollToBottom(arg0_7._tf.parent.parent)
		setActive(arg0_7.panel, true)
		setActive(arg0_7.expandBtn, false)
	end, SFX_PANEL)
	onToggle(arg0_7, arg0_7.comfirmToggle, function(arg0_9)
		setActive(arg0_7.delBtnDiasble, not arg0_9)
		setActive(arg0_7.delBtn, arg0_9)
	end, SFX_PANEL)
	onToggle(arg0_7, arg0_7.confirmText, function(arg0_10)
		triggerToggle(arg0_7.comfirmToggle, arg0_10)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.delBtn, function()
		arg0_7:openMsgBox()
	end, SFX_PANEL)
end

function var0_0.openMsgBox(arg0_12)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		type = MSGBOX_TYPE_ACCOUNTDELETE,
		title = pg.MsgboxMgr.TITLE_INFORMATION,
		weight = LayerWeightConst.TOP_LAYER,
		onYes = function(arg0_13)
			if arg0_13 == i18n("box_account_del_target") then
				pg.SdkMgr.GetInstance():AccountDelete()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("tip_account_del_dismatch"))
			end
		end
	})
end

return var0_0
