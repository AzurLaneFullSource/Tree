local var0_0 = class("IslandWorldMapMediator", import("view.base.ContextMediator"))

var0_0.GO_ISLAND = "IslandWorldMapMediator:GO_ISLAND"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()
end

function var0_0.bindEvent(arg0_2)
	arg0_2:bind(var0_0.GO_ISLAND, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(ISLAND_EVT.SWITCH_SCENE, {
			mapId = arg1_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.BEGIN_STAGE_DONE then
		-- block empty
	end
end

return var0_0
