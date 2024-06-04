local var0 = class("IslandFlowerFieldMediator", import("..base.ContextMediator"))

var0.GET_FLOWER_AWARD = "IslandFlowerFieldMediator.GET_FLOWER_AWARD"

function var0.register(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD)

	arg0.viewComponent:setActivity(var0)
	arg0:bind(var0.GET_FLOWER_AWARD, function(arg0, arg1)
		arg0:sendNotification(GAME.ISLAND_FLOWER_GET, {
			act_id = var0.id,
			isAuto = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ISLAND_FLOWER_GET_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ISLAND_FLOWER_GET_DONE then
		if #var1.awards > 0 then
			if var1.isAuto then
				arg0:addSubLayers(Context.New({
					mediator = SixthAnniversaryIslandFlowerWindowMediator,
					viewComponent = SixthAnniversaryIslandFlowerWindowLayer,
					data = {
						awards = var1.awards,
						name = pg.ship_data_statistics[arg0.contextData.shipConfigId].name
					}
				}))
			else
				arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
			end
		end
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD then
		arg0.viewComponent:setActivity(var1)
		arg0.viewComponent:refreshDisplay()
	end
end

return var0
