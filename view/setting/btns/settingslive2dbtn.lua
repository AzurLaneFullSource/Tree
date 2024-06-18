local var0_0 = class("SettingsLive2DBtn", import(".SettingsDownloadableBtn"))

function var0_0.GetDownloadGroup(arg0_1)
	return "L2D"
end

function var0_0.GetLocaltion(arg0_2, arg1_2, arg2_2)
	local var0_2 = ""

	if arg1_2 == DownloadState.None then
		if arg2_2 == 1 then
			var0_2 = i18n("word_live2dfiles_download_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_live2dfiles_download")
		end
	elseif arg1_2 == DownloadState.Checking then
		if arg2_2 == 1 then
			var0_2 = i18n("word_live2dfiles_checking_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_live2dfiles_checking")
		end
	elseif arg1_2 == DownloadState.CheckToUpdate then
		if arg2_2 == 1 then
			var0_2 = i18n("word_live2dfiles_checkend_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_live2dfiles_checkend")
		end
	elseif arg1_2 == DownloadState.CheckOver then
		if arg2_2 == 1 then
			var0_2 = i18n("word_live2dfiles_checkend_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_live2dfiles_noneedupdate")
		end
	elseif arg1_2 == DownloadState.CheckFailure then
		if arg2_2 == 1 then
			var0_2 = i18n("word_live2dfiles_checkfailed")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_live2dfiles_retry")
		end
	elseif arg1_2 == DownloadState.Updating then
		if arg2_2 == 1 then
			var0_2 = i18n("word_live2dfiles_update")
		end
	elseif arg1_2 == DownloadState.UpdateSuccess then
		if arg2_2 == 1 then
			var0_2 = i18n("word_live2dfiles_update_end_title")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_live2dfiles_update_end")
		end
	elseif arg1_2 == DownloadState.UpdateFailure then
		if arg2_2 == 1 then
			var0_2 = i18n("word_live2dfiles_update_failed")
		elseif arg2_2 == 2 then
			var0_2 = i18n("word_live2dfiles_update_retry")
		end
	end

	return var0_2
end

function var0_0.GetTitle(arg0_3)
	return i18n("setting_resdownload_title_live2d")
end

return var0_0
