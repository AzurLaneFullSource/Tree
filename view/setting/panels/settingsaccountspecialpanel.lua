local var0 = class("SettingsAccountSpecialPanel", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsAccountSpecial"
end

function var0.GetTitle(arg0)
	return i18n("settings_title_account_del")
end

function var0.GetTitleEn(arg0)
	return " / ACCOUNT SETTING"
end

function var0.OnInit(arg0)
	arg0:findUI()
	arg0:addListener()
end

function var0.OnUpdate(arg0)
	return
end

function var0.findUI(arg0)
	arg0.expandBtn = arg0._tf:Find("ExpandBtn")
	arg0.panel = arg0._tf:Find("Panel")
	arg0.deleteTitle = arg0.panel:Find("Notice/DelTitle")
	arg0.deleteDesc = arg0.panel:Find("Notice/Text")
	arg0.confirmText = arg0.panel:Find("Confirm/Text")
	arg0.comfirmToggle = arg0.panel:Find("Confirm/Text/Toggle")
	arg0.delBtnDiasble = arg0.panel:Find("DelBtnDisable")
	arg0.delBtn = arg0.panel:Find("DelBtn")

	local var0 = arg0.delBtnDiasble:Find("Text")
	local var1 = arg0.delBtn:Find("Text")

	setText(arg0.deleteTitle, i18n("settings_text_account_del"))
	setText(arg0.deleteDesc, i18n("settings_text_account_del_desc"))
	setText(arg0.confirmText, i18n("settings_text_account_del_confirm"))
	setText(var0, i18n("settings_text_account_del_btn"))
	setText(var1, i18n("settings_text_account_del_btn"))
	triggerToggle(arg0.comfirmToggle, false)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.expandBtn, function()
		setSizeDelta(arg0._tf, {
			x = 1558,
			y = 515
		})
		scrollToBottom(arg0._tf.parent.parent)
		setActive(arg0.panel, true)
		setActive(arg0.expandBtn, false)
	end, SFX_PANEL)
	onToggle(arg0, arg0.comfirmToggle, function(arg0)
		setActive(arg0.delBtnDiasble, not arg0)
		setActive(arg0.delBtn, arg0)
	end, SFX_PANEL)
	onToggle(arg0, arg0.confirmText, function(arg0)
		triggerToggle(arg0.comfirmToggle, arg0)
	end, SFX_PANEL)
	onButton(arg0, arg0.delBtn, function()
		arg0:openMsgBox()
	end, SFX_PANEL)
end

function var0.openMsgBox(arg0)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		type = MSGBOX_TYPE_ACCOUNTDELETE,
		title = pg.MsgboxMgr.TITLE_INFORMATION,
		weight = LayerWeightConst.TOP_LAYER,
		onYes = function(arg0)
			if arg0 == i18n("box_account_del_target") then
				pg.SdkMgr.GetInstance():AccountDelete()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("tip_account_del_dismatch"))
			end
		end
	})
end

return var0
