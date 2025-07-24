local var0_0 = class("ALYAtelierCompositeRePage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	setText(arg0_1:findTF("bg/goBtn/Text"), i18n("yumia_atelier_tip24"))
	onButton(arg0_1, arg0_1:findTF("bg/goBtn"), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ATELIER_COMPOSITE, {
			activityID = 50043,
			versionIndex = 2
		})
	end)
end

return var0_0
