local var0_0 = class("MainSublayerSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = arg0_1:GetContextData()

	if var0_1 and var0_1.subContext then
		var0_1.subContext.onRemoved = arg1_1

		arg0_1:AddSubLayers(var0_1.subContext)

		var0_1.subContext = nil
	else
		arg1_1()
	end
end

function var0_0.GetContextData(arg0_2)
	local var0_2 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewMainMediator)

	return var0_2 and var0_2.data
end

function var0_0.AddSubLayers(arg0_3, arg1_3)
	local var0_3 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewMainMediator)

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_3,
		context = arg1_3
	})
end

return var0_0
