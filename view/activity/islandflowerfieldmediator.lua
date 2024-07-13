local var0_0 = class("IslandFlowerFieldMediator", import("..base.ContextMediator"))

var0_0.GET_FLOWER_AWARD = "IslandFlowerFieldMediator.GET_FLOWER_AWARD"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD)

	arg0_1.viewComponent:setActivity(var0_1)
	arg0_1:bind(var0_0.GET_FLOWER_AWARD, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ISLAND_FLOWER_GET, {
			act_id = var0_1.id,
			isAuto = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.ISLAND_FLOWER_GET_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.ISLAND_FLOWER_GET_DONE then
		if #var1_4.awards > 0 then
			if var1_4.isAuto then
				arg0_4:addSubLayers(Context.New({
					mediator = SixthAnniversaryIslandFlowerWindowMediator,
					viewComponent = SixthAnniversaryIslandFlowerWindowLayer,
					data = {
						awards = var1_4.awards,
						name = pg.ship_data_statistics[arg0_4.contextData.shipConfigId].name
					}
				}))
			else
				arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards)
			end
		end
	elseif var0_4 == ActivityProxy.ACTIVITY_UPDATED and var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD then
		arg0_4.viewComponent:setActivity(var1_4)
		arg0_4.viewComponent:refreshDisplay()
	end
end

return var0_0
