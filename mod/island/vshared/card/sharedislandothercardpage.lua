local var0_0 = class("SharedIslandOtherCardPage", import("Mod.Island.View.page.card.IslandOtherCardPage"))

function var0_0.AddSubLayers(arg0_1, arg1_1)
	local var0_1 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(SharedIslandMediator)

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_1,
		context = arg1_1
	})
end

return var0_0
