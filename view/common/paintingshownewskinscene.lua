local var0_0 = class("PaintingShowNewSkinScene", import("view.common.PaintingShowScene"))

function var0_0.AddSubLayers(arg0_1, arg1_1)
	local var0_1 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(LatestSkinShopMediator)

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_1,
		context = arg1_1
	})
end

function var0_0.closeView(arg0_2)
	if arg0_2.loading then
		return
	end

	arg0_2:ClearPainting()

	if not arg0_2.skinLayerAdded then
		arg0_2.skinLayerAdded = true

		arg0_2:AddSubLayers(Context.New({
			mediator = NewSkinMediator,
			viewComponent = NewSkinLayer,
			data = {
				skinId = arg0_2.contextData.skinId,
				timeLimit = arg0_2.contextData.timeLimit
			}
		}))
	end

	seriesAsync({
		function(arg0_3)
			onDelayTick(arg0_3, 1)
		end
	}, function()
		var0_0.super.closeView(arg0_2)
	end)
end

return var0_0
