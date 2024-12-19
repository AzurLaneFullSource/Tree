local var0_0 = class("ActiveStarlightHomepage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("bg")
	arg0_1.Build = arg0_1:findTF("bg/Build"):GetComponent("Button")
	arg0_1.Level = arg0_1:findTF("bg/Level"):GetComponent("Button")
	arg0_1.Shop = arg0_1:findTF("bg/Shop"):GetComponent("Button")
	arg0_1.Manual = arg0_1:findTF("bg/Manual"):GetComponent("Button")
	arg0_1.image = arg0_1:findTF("bg/Manual/image")
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("time")
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.Build, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_NEWSERVER
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.Level, function()
		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.Shop, function()
		arg0_3:emit(ActivityMediator.GO_CHANGE_SHOP)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.Manual, function()
		local var0_7 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = StarLightMedalAlbumView
		})

		arg0_3:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_7)
	end, SFX_PANEL)
end

return var0_0
