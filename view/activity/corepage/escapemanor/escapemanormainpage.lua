local var0_0 = class("EscapeManorMainPage", import("view.activity.CorePage.Helena.HelenaMainPage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.Manual, function()
		local var0_2 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = EscapeManorMedalAlbumView
		})

		arg0_1:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_2)
	end)
end

function var0_0.updateUI(arg0_3)
	var0_0.super.updateUI(arg0_3)
	removeOnButton(arg0_3.fight)
	onButton(arg0_3, arg0_3.fight, function()
		arg0_3:emit(ActivityMediator.ON_BOSSRUSH_MAP)
	end)
end

return var0_0
