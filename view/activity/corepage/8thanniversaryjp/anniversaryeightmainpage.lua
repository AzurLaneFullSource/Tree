local var0_0 = class("AnniversaryEightMainPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	return
end

function var0_0.OnDataSetting(arg0_2)
	return
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, findTF(arg0_3._tf, "AD/btn_act"), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CITY_REBUILD_MAP)
	end, SFX_PANEL)
	onButton(arg0_3, findTF(arg0_3._tf, "AD/btn_hotspring"), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EIGHTH_HOTSPRING)
	end, SFX_PANEL)
	setText(findTF(arg0_3._tf, "AD/desc"), i18n("anniversary_eight_main_page_desc"))

	if CityRebuildBookLayer.ShouldShowTip() or CityRebuildTasksLayer.ShouldShowTip() then
		setActive(findTF(arg0_3._tf, "AD/btn_act/red"), true)
	else
		setActive(findTF(arg0_3._tf, "AD/btn_act/red"), false)
	end
end

function var0_0.OnUpdateFlush(arg0_6)
	return
end

return var0_0
