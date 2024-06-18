local var0_0 = class("SettingsSecondPasswordPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsSecondPassWord"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_Secpw")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / SECOND-TIER PASSWORD"
end

function var0_0.OnInit(arg0_4)
	arg0_4.helpBtn = findTF(arg0_4._tf, "btnhelp")
	arg0_4.closeBtn = findTF(arg0_4._tf, "options/close")
	arg0_4.openBtn = findTF(arg0_4._tf, "options/open")

	setText(arg0_4._tf:Find("options/close/Text"), i18n("settings_pwd_label_close"))
	setText(arg0_4._tf:Find("options/open/Text"), i18n("settings_pwd_label_open"))
	arg0_4:SetData()
	arg0_4:RegisterEvent()
end

function var0_0.SetData(arg0_5)
	arg0_5.rawdata = getProxy(SecondaryPWDProxy):getRawData()
end

function var0_0.RegisterEvent(arg0_6)
	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("secondary_password_help")
		})
	end)
	onButton(arg0_6, arg0_6.closeBtn, function()
		if arg0_6.rawdata.state > 0 then
			pg.SecondaryPWDMgr.GetInstance():ChangeSetting({}, function()
				arg0_6:UpdateBtnState()
			end)
		end
	end, SFX_UI_TAG)
	onButton(arg0_6, arg0_6.openBtn, function()
		if arg0_6.rawdata.state <= 0 then
			local function var0_10()
				pg.SecondaryPWDMgr.GetInstance():SetPassword(function()
					arg0_6:UpdateBtnState()
				end)
			end

			if PlayerPrefs.GetFloat("firstOpenSecondaryPassword") == 0 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("secondary_password_help"),
					onYes = var0_10,
					onClose = var0_10
				})
				PlayerPrefs.SetFloat("firstOpenSecondaryPassword", 1)
				PlayerPrefs.Save()
			else
				var0_10()
			end
		end
	end, SFX_UI_TAG)
end

function var0_0.UpdateBtnState(arg0_13)
	local var0_13 = arg0_13.rawdata.state > 0

	setActive(arg0_13.closeBtn:Find("on"), not var0_13)
	setActive(arg0_13.closeBtn:Find("off"), var0_13)
	setActive(arg0_13.openBtn:Find("on"), var0_13)
	setActive(arg0_13.openBtn:Find("off"), not var0_13)
	pg.m02:sendNotification(NewSettingsMediator.ON_SECON_PWD_STATE_CHANGE)
end

function var0_0.OnUpdate(arg0_14)
	arg0_14:UpdateBtnState()
end

return var0_0
