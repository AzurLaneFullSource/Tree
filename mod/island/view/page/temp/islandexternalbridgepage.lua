local var0_0 = class("IslandExternalBridgePage", import("...base.IslandBasePage"))

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

function var0_0.AddSubLayers(arg0_5, arg1_5, arg2_5)
	local var0_5 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(IslandMediator)

	arg1_5.data = {
		container = arg0_5._tf,
		onClose = function()
			arg0_5:Hide()
		end,
		params = arg2_5
	}

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_5,
		context = arg1_5
	})
end

function var0_0.RemoveSubLayers(arg0_7, arg1_7)
	local var0_7 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg1_7.mediator)

	if var0_7 then
		pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_7
		})
	end
end

function var0_0.GetContext(arg0_8)
	assert(false, "overwrite me")
end

return var0_0
