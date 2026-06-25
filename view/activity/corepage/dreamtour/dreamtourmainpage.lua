local var0_0 = class("DreamTourMainPage", import("view.activity.CorePage.Helena.HelenaMainPage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.Manual, function()
		local var0_2 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = DreamTourMedalAlbumView
		})

		arg0_1:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_2)
	end)
end

return var0_0
