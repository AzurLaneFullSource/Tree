local var0_0 = class("SettingsResUpdatePanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsResUpdate"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_resUpdate")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / DOWNLOAD"
end

function var0_0.OnInit(arg0_4)
	arg0_4.tpl = arg0_4._tf:Find("Tpl")
	arg0_4.containerTF = arg0_4._tf:Find("list")
	arg0_4.iconTF = arg0_4._tf:Find("Icon")

	local var0_4 = arg0_4._tf:Find("MainGroup")
	local var1_4 = not GroupMainHelper.IsVerSameWithServer()

	setActive(var0_4, var1_4)

	if var1_4 then
		arg0_4.mainGroupBtn = SettingsMainGroupBtn.New(var0_4)
	end

	arg0_4.soundBtn = SettingsSoundBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.containerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("CV"))
	})
	arg0_4.live2dBtn = SettingsLive2DBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.containerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("L2D"))
	})
	arg0_4.galleryBtn = SettingsGalleryBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.containerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("GALLERY_PIC"))
	})
	arg0_4.musicBtn = SettingsMusicBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.containerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("GALLERY_BGM"))
	})
	arg0_4.mangaBtn = SettingsMangaBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.containerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("MANGA"))
	})
	arg0_4.repairBtn = SettingsResRepairBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.containerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("REPAIR"))
	})
end

function var0_0.Dispose(arg0_5)
	var0_0.super.Dispose(arg0_5)

	if arg0_5:IsLoaded() then
		arg0_5.repairBtn:Dispose()

		arg0_5.repairBtn = nil

		arg0_5.live2dBtn:Dispose()

		arg0_5.live2dBtn = nil

		arg0_5.galleryBtn:Dispose()

		arg0_5.galleryBtn = nil

		arg0_5.soundBtn:Dispose()

		arg0_5.soundBtn = nil

		arg0_5.musicBtn:Dispose()

		arg0_5.musicBtn = nil

		arg0_5.mangaBtn:Dispose()

		arg0_5.mangaBtn = nil

		if arg0_5.mainGroupBtn then
			arg0_5.mainGroupBtn:Dispose()

			arg0_5.mainGroupBtn = nil
		end
	end
end

return var0_0
