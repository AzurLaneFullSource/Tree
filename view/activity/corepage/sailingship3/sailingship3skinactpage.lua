local var0_0 = class("SailingShip3SkinActPage", import("view.activity.CorePage.CorePreviewTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.btnList:Find("activity"), function()
		arg0_1:emit(ActivityMediator.OPEN_LAYER, Context.New({
			mediator = SailingShip3SkinMediator,
			viewComponent = SailingShip3SkinLayer
		}))
	end)
end

function var0_0.OnUpdateFlush(arg0_3)
	local var0_3 = arg0_3._tf:Find("AD/redDot")

	setActive(var0_3, SailingShip3SkinLayer.ShouldShowTip())
end

return var0_0
