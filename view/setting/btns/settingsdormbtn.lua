local var0_0 = class("SettingsDormBtn", import(".SettingsDownloadableBtn"))

function var0_0.GetDownloadGroup(arg0_1)
	return "DORM"
end

function var0_0.Check(arg0_2)
	local var0_2 = arg0_2:GetDownloadGroup()
	local var1_2 = BundleWizard.Inst:GetGroupMgr(var0_2)

	arg0_2.timer = Timer.New(function()
		arg0_2:UpdateDownLoadState()
	end, 0.5, -1)

	arg0_2.timer:Start()
	arg0_2:UpdateDownLoadState()

	if var1_2.state == DownloadState.None then
		var1_2:CheckD()
	end

	onButton(arg0_2, arg0_2._tf, function()
		if DormGroupConst.IsDownloading() then
			pg.TipsMgr.GetInstance():ShowTips("now is downloading")

			return
		end

		local var0_4 = var1_2.state

		if var0_4 == DownloadState.CheckFailure then
			var1_2:CheckD()
		elseif var0_4 == DownloadState.CheckToUpdate or var0_4 == DownloadState.UpdateFailure then
			VersionMgr.Inst:RequestUIForUpdateD(var0_2, true)
		end
	end, SFX_PANEL)
end

function var0_0.GetLocaltion(arg0_5, arg1_5, arg2_5)
	local var0_5 = ""

	if arg1_5 == DownloadState.None then
		if arg2_5 == 1 then
			var0_5 = i18n("word_soundfiles_download_title")
		elseif arg2_5 == 2 then
			var0_5 = i18n("word_soundfiles_download")
		end
	elseif arg1_5 == DownloadState.Checking then
		if arg2_5 == 1 then
			var0_5 = i18n("word_soundfiles_checking_title")
		elseif arg2_5 == 2 then
			var0_5 = i18n("word_soundfiles_checking")
		end
	elseif arg1_5 == DownloadState.CheckToUpdate then
		if arg2_5 == 1 then
			var0_5 = i18n("word_soundfiles_checkend_title")
		elseif arg2_5 == 2 then
			var0_5 = i18n("word_soundfiles_checkend")
		end
	elseif arg1_5 == DownloadState.CheckOver then
		if arg2_5 == 1 then
			var0_5 = i18n("word_soundfiles_checkend_title")
		elseif arg2_5 == 2 then
			var0_5 = i18n("word_soundfiles_noneedupdate")
		end
	elseif arg1_5 == DownloadState.CheckFailure then
		if arg2_5 == 1 then
			var0_5 = i18n("word_soundfiles_checkfailed")
		elseif arg2_5 == 2 then
			var0_5 = i18n("word_soundfiles_retry")
		end
	elseif arg1_5 == DownloadState.Updating then
		if arg2_5 == 1 then
			var0_5 = i18n("word_soundfiles_update")
		end
	elseif arg1_5 == DownloadState.UpdateSuccess then
		if arg2_5 == 1 then
			var0_5 = i18n("word_soundfiles_update_end_title")
		elseif arg2_5 == 2 then
			var0_5 = i18n("word_soundfiles_update_end")
		end
	elseif arg1_5 == DownloadState.UpdateFailure then
		if arg2_5 == 1 then
			var0_5 = i18n("word_soundfiles_update_failed")
		elseif arg2_5 == 2 then
			var0_5 = i18n("word_soundfiles_update_retry")
		end
	end

	return var0_5
end

function var0_0.GetTitle(arg0_6)
	return i18n("setting_resdownload_title_dorm")
end

return var0_0
