local var0 = class("MainSublayerSequence")

function var0.Execute(arg0, arg1)
	local var0 = arg0:GetContextData()

	if var0 and var0.subContext then
		var0.subContext.onRemoved = arg1

		arg0:AddSubLayers(var0.subContext)

		var0.subContext = nil
	else
		arg1()
	end
end

function var0.GetContextData(arg0)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewMainMediator)

	return var0 and var0.data
end

function var0.AddSubLayers(arg0, arg1)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewMainMediator)

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0,
		context = arg1
	})
end

return var0
