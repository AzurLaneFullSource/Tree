local var0_0 = class("SettingsResUpdatePanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsResUpdate"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_resManage")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / RESOURCES"
end

function var0_0.OnInit(arg0_4)
	arg0_4.tpl = arg0_4._tf:Find("Tpl")
	arg0_4.iconTF = arg0_4._tf:Find("Icon")
	arg0_4.fullTF = arg0_4._tf:Find("options_full")
	arg0_4.mainTF = arg0_4._tf:Find("options_main")
	arg0_4.fullTitleText = arg0_4._tf:Find("options_full/Title/Text")
	arg0_4.mainTitleText = arg0_4._tf:Find("options_main/Title/Text")
	arg0_4.specialTitleText = arg0_4._tf:Find("options_special/Title/Text")

	setText(arg0_4.fullTitleText, i18n("Settings_title_resManage_All"))
	setText(arg0_4.mainTitleText, i18n("Settings_title_resManage_Main"))
	setText(arg0_4.specialTitleText, i18n("Settings_title_resManage_Sub"))

	arg0_4.fullGroupTF = arg0_4._tf:Find("options_full/MainGroup")
	arg0_4.mainContainerTF = arg0_4._tf:Find("options_main/list")
	arg0_4.specialContainerTF = arg0_4._tf:Find("options_special/list")

	local var0_4 = not GroupMainHelper.IsVerSameWithServer()

	setActive(arg0_4.fullTF, var0_4)

	if var0_4 then
		arg0_4.mainGroupBtn = SettingsMainGroupBtn.New(arg0_4.fullGroupTF)
		GetComponent(arg0_4.mainTF, typeof(VerticalLayoutGroup)).padding.top = 0
	else
		local var1_4 = GetComponent(arg0_4.fullTF, typeof(VerticalLayoutGroup)).padding.top

		GetComponent(arg0_4.mainTF, typeof(VerticalLayoutGroup)).padding.top = var1_4
	end

	arg0_4.galleryBtn = SettingsGalleryBtn.New({
		isDel = true,
		tpl = arg0_4.tpl,
		container = arg0_4.specialContainerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("GALLERY_PIC"))
	})
	arg0_4.mangaBtn = SettingsMangaBtn.New({
		isDel = true,
		tpl = arg0_4.tpl,
		container = arg0_4.specialContainerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("MANGA"))
	})
	arg0_4.dormBtn = SettingsDormBtn.New({
		isDel = true,
		tpl = arg0_4.tpl,
		container = arg0_4.specialContainerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("DORM"))
	})
	arg0_4.mapBtn = SettingsMapBtn.New({
		isDel = true,
		tpl = arg0_4.tpl,
		container = arg0_4.specialContainerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("MAP"))
	})
	arg0_4.repairBtn = SettingsResRepairBtn.New({
		isDel = false,
		tpl = arg0_4.tpl,
		container = arg0_4.specialContainerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("REPAIR"))
	})
	arg0_4.soundBtn = SettingsSoundBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.mainContainerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("CV"))
	})
	arg0_4.live2dBtn = SettingsLive2DBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.mainContainerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("L2D"))
	})
	arg0_4.musicBtn = SettingsMusicBtn.New({
		tpl = arg0_4.tpl,
		container = arg0_4.mainContainerTF,
		iconSP = getImageSprite(arg0_4.iconTF:Find("GALLERY_BGM"))
	})

	if LOCK_ISLAND_DISPLAY then
		setActive(arg0_4.mapBtn._tf, false)
	end
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

		arg0_5.dormBtn:Dispose()

		arg0_5.dormBtn = nil

		arg0_5.mapBtn:Dispose()

		arg0_5.mapBtn = nil

		if arg0_5.mainGroupBtn then
			arg0_5.mainGroupBtn:Dispose()

			arg0_5.mainGroupBtn = nil
		end
	end
end

return var0_0
