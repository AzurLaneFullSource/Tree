local var0_0 = class("AnniversaryIsland2023Mediator", import("..TemplateMV.BackHillMediatorTemplate"))

function var0_0.register(arg0_1)
	var0_0.super.register(arg0_1)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 2,
		activity_id = var0_1.id
	})
end

function var0_0.listNotificationInterests(arg0_2)
	local var0_2 = var0_0.super.listNotificationInterests(arg0_2)

	table.insertto(var0_2, {
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	})

	return var0_2
end

function var0_0.handleNotification(arg0_3, arg1_3)
	var0_0.super.handleNotification(arg0_3, arg1_3)

	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_3:addSubLayers(Context.New({
			mediator = AwardInfoMediator,
			viewComponent = AnniversaryIslandAwardLayer,
			data = {
				items = var1_3.awards
			},
			onRemoved = var1_3.callback
		}))
	end
end

function var0_0.CheckPreloadData(arg0_4, arg1_4)
	if getProxy(ContextProxy):getContextByMediator(AnniversaryIsland2023Mediator) then
		local var0_4 = getProxy(ContextProxy):getCurrentContext()

		arg0_4.prevContext = arg0_4.prevContext or var0_4

		getProxy(ContextProxy):CleanUntilMediator(AnniversaryIsland2023Mediator)
	else
		local var1_4 = Context.New()

		SCENE.SetSceneInfo(var1_4, SCENE.ANNIVERSARY_ISLAND_BACKHILL_2023)

		local var2_4 = getProxy(ContextProxy):getCurrentContext()

		var1_4:extendData({
			fromMediatorName = var2_4.mediator.__cname
		})
		getProxy(ContextProxy):pushContext(var1_4)

		arg0_4.prevContext = arg0_4.prevContext or var2_4
	end

	existCall(arg1_4)
end

return var0_0
