local var0_0 = class("ShadowCityMainPage", import("view.activity.CorePage.Helena.HelenaMainPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.rpManual = arg0_1.Manual:Find("tip")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.Manual, function()
		local var0_3 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = ShadowCityMedalAlbumView
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_3)
	end)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)
	arg0_4:updateTip()
end

function var0_0.updateTip(arg0_5)
	local var0_5 = arg0_5.activity:getConfig("config_client").medalGroupId
	local var1_5 = getProxy(ActivityProxy):getActivityById(var0_5):readyToAchieve()

	setActive(arg0_5.rpManual, var1_5)
end

return var0_0
