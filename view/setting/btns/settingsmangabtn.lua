local var0 = class("SettingsMangaBtn", import(".SettingsDownloadableBtn"))

function var0.GetDownloadGroup(arg0)
	return "MANGA"
end

function var0.GetLocaltion(arg0, arg1, arg2)
	local var0 = ""

	if arg1 == DownloadState.None then
		if arg2 == 1 then
			var0 = i18n("word_soundfiles_download_title")
		elseif arg2 == 2 then
			var0 = i18n("word_soundfiles_download")
		end
	elseif arg1 == DownloadState.Checking then
		if arg2 == 1 then
			var0 = i18n("word_soundfiles_checking_title")
		elseif arg2 == 2 then
			var0 = i18n("word_soundfiles_checking")
		end
	elseif arg1 == DownloadState.CheckToUpdate then
		if arg2 == 1 then
			var0 = i18n("word_soundfiles_checkend_title")
		elseif arg2 == 2 then
			var0 = i18n("word_soundfiles_checkend")
		end
	elseif arg1 == DownloadState.CheckOver then
		if arg2 == 1 then
			var0 = i18n("word_soundfiles_checkend_title")
		elseif arg2 == 2 then
			var0 = i18n("word_soundfiles_noneedupdate")
		end
	elseif arg1 == DownloadState.CheckFailure then
		if arg2 == 1 then
			var0 = i18n("word_soundfiles_checkfailed")
		elseif arg2 == 2 then
			var0 = i18n("word_soundfiles_retry")
		end
	elseif arg1 == DownloadState.Updating then
		if arg2 == 1 then
			var0 = i18n("word_soundfiles_update")
		end
	elseif arg1 == DownloadState.UpdateSuccess then
		if arg2 == 1 then
			var0 = i18n("word_soundfiles_update_end_title")
		elseif arg2 == 2 then
			var0 = i18n("word_soundfiles_update_end")
		end
	elseif arg1 == DownloadState.UpdateFailure then
		if arg2 == 1 then
			var0 = i18n("word_soundfiles_update_failed")
		elseif arg2 == 2 then
			var0 = i18n("word_soundfiles_update_retry")
		end
	end

	return var0
end

function var0.GetTitle(arg0)
	return i18n("setting_resdownload_title_manga")
end

return var0
