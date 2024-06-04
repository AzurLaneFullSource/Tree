local var0 = class("SettingsResUpdatePanel", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsResUpdate"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_resUpdate")
end

function var0.GetTitleEn(arg0)
	return "  / DOWNLOAD"
end

function var0.OnInit(arg0)
	arg0.tpl = arg0._tf:Find("Tpl")
	arg0.containerTF = arg0._tf:Find("list")
	arg0.iconTF = arg0._tf:Find("Icon")

	local var0 = arg0._tf:Find("MainGroup")
	local var1 = not GroupMainHelper.IsVerSameWithServer()

	setActive(var0, var1)

	if var1 then
		arg0.mainGroupBtn = SettingsMainGroupBtn.New(var0)
	end

	arg0.soundBtn = SettingsSoundBtn.New({
		tpl = arg0.tpl,
		container = arg0.containerTF,
		iconSP = getImageSprite(arg0.iconTF:Find("CV"))
	})
	arg0.live2dBtn = SettingsLive2DBtn.New({
		tpl = arg0.tpl,
		container = arg0.containerTF,
		iconSP = getImageSprite(arg0.iconTF:Find("L2D"))
	})
	arg0.galleryBtn = SettingsGalleryBtn.New({
		tpl = arg0.tpl,
		container = arg0.containerTF,
		iconSP = getImageSprite(arg0.iconTF:Find("GALLERY_PIC"))
	})
	arg0.musicBtn = SettingsMusicBtn.New({
		tpl = arg0.tpl,
		container = arg0.containerTF,
		iconSP = getImageSprite(arg0.iconTF:Find("GALLERY_BGM"))
	})
	arg0.mangaBtn = SettingsMangaBtn.New({
		tpl = arg0.tpl,
		container = arg0.containerTF,
		iconSP = getImageSprite(arg0.iconTF:Find("MANGA"))
	})
	arg0.repairBtn = SettingsResRepairBtn.New({
		tpl = arg0.tpl,
		container = arg0.containerTF,
		iconSP = getImageSprite(arg0.iconTF:Find("REPAIR"))
	})
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	if arg0:IsLoaded() then
		arg0.repairBtn:Dispose()

		arg0.repairBtn = nil

		arg0.live2dBtn:Dispose()

		arg0.live2dBtn = nil

		arg0.galleryBtn:Dispose()

		arg0.galleryBtn = nil

		arg0.soundBtn:Dispose()

		arg0.soundBtn = nil

		arg0.musicBtn:Dispose()

		arg0.musicBtn = nil

		arg0.mangaBtn:Dispose()

		arg0.mangaBtn = nil

		if arg0.mainGroupBtn then
			arg0.mainGroupBtn:Dispose()

			arg0.mainGroupBtn = nil
		end
	end
end

return var0
