local var0 = class("SettingsSecondPasswordPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsSecondPassWord"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_Secpw")
end

function var0.GetTitleEn(arg0)
	return "  / SECOND-TIER PASSWORD"
end

function var0.OnInit(arg0)
	arg0.helpBtn = findTF(arg0._tf, "btnhelp")
	arg0.closeBtn = findTF(arg0._tf, "options/close")
	arg0.openBtn = findTF(arg0._tf, "options/open")

	setText(arg0._tf:Find("options/close/Text"), i18n("settings_pwd_label_close"))
	setText(arg0._tf:Find("options/open/Text"), i18n("settings_pwd_label_open"))
	arg0:SetData()
	arg0:RegisterEvent()
end

function var0.SetData(arg0)
	arg0.rawdata = getProxy(SecondaryPWDProxy):getRawData()
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("secondary_password_help")
		})
	end)
	onButton(arg0, arg0.closeBtn, function()
		if arg0.rawdata.state > 0 then
			pg.SecondaryPWDMgr.GetInstance():ChangeSetting({}, function()
				arg0:UpdateBtnState()
			end)
		end
	end, SFX_UI_TAG)
	onButton(arg0, arg0.openBtn, function()
		if arg0.rawdata.state <= 0 then
			local function var0()
				pg.SecondaryPWDMgr.GetInstance():SetPassword(function()
					arg0:UpdateBtnState()
				end)
			end

			if PlayerPrefs.GetFloat("firstOpenSecondaryPassword") == 0 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("secondary_password_help"),
					onYes = var0,
					onClose = var0
				})
				PlayerPrefs.SetFloat("firstOpenSecondaryPassword", 1)
				PlayerPrefs.Save()
			else
				var0()
			end
		end
	end, SFX_UI_TAG)
end

function var0.UpdateBtnState(arg0)
	local var0 = arg0.rawdata.state > 0

	setActive(arg0.closeBtn:Find("on"), not var0)
	setActive(arg0.closeBtn:Find("off"), var0)
	setActive(arg0.openBtn:Find("on"), var0)
	setActive(arg0.openBtn:Find("off"), not var0)
	pg.m02:sendNotification(NewSettingsMediator.ON_SECON_PWD_STATE_CHANGE)
end

function var0.OnUpdate(arg0)
	arg0:UpdateBtnState()
end

return var0
