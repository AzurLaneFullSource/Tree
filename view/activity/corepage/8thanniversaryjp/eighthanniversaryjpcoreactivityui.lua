local var0_0 = class("EighthAnniversaryJpCoreActivityUI", import("view.activity.CorePage.CoreAdaptActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryEightCoreActivityUI"
end

var0_0.optionsPath = {
	"adapt/TopPage/top/btn_home"
}

function var0_0.CustomInit(arg0_2)
	quickPlayAnimation(arg0_2:findTF("adapt/TopPage/top"), "Anim_SecretsAbyssCoreActivityUI_top_In")
	setText(arg0_2:findTF("adapt/TopPage/top/deco/Text"), i18n("activity_ninjia_main_title"))
	setText(arg0_2:findTF("adapt/TopPage/top/deco/Text/Text_1"), i18n("activity_ninjia_main_title_en"))
end

function var0_0.GetButtonNameText(arg0_3, arg1_3)
	return i18n(string.format("activity_ninjia_main_sheet%s", arg1_3:getConfig("is_show")))
end

function var0_0.OnClickBtn(arg0_4, arg1_4, arg2_4)
	quickPlayAnimation(arg1_4, "Anim_SecretsAbyssCoreActivityUI_tabs_on_In")
end

return var0_0
