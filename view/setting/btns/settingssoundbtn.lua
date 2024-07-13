local var0_0 = class("SettingsSoundBtn", import(".SettingsDownloadableBtn"))

function var0_0.GetDownloadGroup(arg0_1)
	return "CV"
end

function var0_0.GetLocaltion(arg0_2, arg1_2, arg2_2)
	local var0_2 = ""

	if arg1_2 == DownloadState.None then
		if arg2_2 == 1 then
			var0_2 = i18n("word_soundfiles_download_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_soundfiles_download")
		end
	elseif arg1_2 == DownloadState.Checking then
		if arg2_2 == 1 then
			var0_2 = i18n("word_soundfiles_checking_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_soundfiles_checking")
		end
	elseif arg1_2 == DownloadState.CheckToUpdate then
		if arg2_2 == 1 then
			var0_2 = i18n("word_soundfiles_checkend_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_soundfiles_checkend")
		end
	elseif arg1_2 == DownloadState.CheckOver then
		if arg2_2 == 1 then
			var0_2 = i18n("word_soundfiles_checkend_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_soundfiles_noneedupdate")
		end
	elseif arg1_2 == DownloadState.CheckFailure then
		if arg2_2 == 1 then
			var0_2 = i18n("word_soundfiles_checkfailed")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_soundfiles_retry")
		end
	elseif arg1_2 == DownloadState.Updating then
		if arg2_2 == 1 then
			var0_2 = i18n("word_soundfiles_update")
		end
	elseif arg1_2 == DownloadState.UpdateSuccess then
		if arg2_2 == 1 then
			var0_2 = i18n("word_soundfiles_update_end_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_soundfiles_update_end")
		end
	elseif arg1_2 == DownloadState.UpdateFailure then
		if arg2_2 == 1 then
			var0_2 = i18n("word_soundfiles_update_failed")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_soundfiles_update_retry")
		end
	end

	return var0_2
end

function var0_0.GetTitle(arg0_3)
	return i18n("setting_resdownload_title_sound")
end

return var0_0
