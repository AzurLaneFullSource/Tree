local var0_0 = class("IslandOtherCardPage", import(".IslandSelfCardPage"))

function var0_0.OnShow(arg0_1, arg1_1)
	arg0_1.userId = arg1_1

	var0_0.super.OnShow(arg0_1)
end

function var0_0.GetContext(arg0_2)
	return Context.New({
		mediator = IslandOtherCardMediator,
		viewComponent = IslandOtherCardAttach,
		data = {
			isIslandPage = true,
			container = arg0_2._tf,
			onClose = function()
				arg0_2:Hide()
			end,
			userId = arg0_2.userId
		}
	})
end

return var0_0
