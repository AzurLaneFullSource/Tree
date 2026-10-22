local var0_0 = class("WindFogCorridorSkinStoryMainPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.btnGo = arg0_1.AD:Find("go")
	arg0_1.redPoint = arg0_1.btnGo:Find("red")
	arg0_1.btnShop = arg0_1.AD:Find("shop")
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.btnGo, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.WINDFOGSKINPAGE)
	end)
	onButton(arg0_2, arg0_2.btnShop, function()
		arg0_2:emit(ActivityMediator.GO_CHANGE_SHOP)
	end)
	arg0_2:refreshRed()
end

function var0_0.OnUpdateFlush(arg0_5)
	arg0_5:refreshRed()
end

function var0_0.refreshRed(arg0_6)
	setActive(arg0_6.redPoint, arg0_6.activity:readyToAchieve())
end

return var0_0
