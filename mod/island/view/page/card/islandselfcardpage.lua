local var0_0 = class("IslandSelfCardPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandEmptyUI"
end

function var0_0.NeedCache(arg0_2)
	return false
end

function var0_0.OnShow(arg0_3)
	arg0_3:AddSubLayers(arg0_3:GetContext())
end

function var0_0.OnHide(arg0_4)
	arg0_4:RemoveSubLayers(arg0_4:GetContext())
end

function var0_0.AddSubLayers(arg0_5, arg1_5)
	local var0_5 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(IslandMediator)

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_5,
		context = arg1_5
	})
end

function var0_0.RemoveSubLayers(arg0_6, arg1_6)
	local var0_6 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg1_6.mediator)

	if var0_6 then
		pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_6
		})
	end
end

function var0_0.GetContext(arg0_7)
	return Context.New({
		mediator = IslandSelfCardMediator,
		viewComponent = IslandSelfCardAttach,
		data = {
			isIslandPage = true,
			container = arg0_7._tf,
			onClose = function()
				arg0_7:Hide()
			end
		}
	})
end

return var0_0
