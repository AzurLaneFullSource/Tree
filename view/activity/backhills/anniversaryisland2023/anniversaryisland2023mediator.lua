local var0 = class("AnniversaryIsland2023Mediator", import("..TemplateMV.BackHillMediatorTemplate"))

function var0.register(arg0)
	var0.super.register(arg0)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 2,
		activity_id = var0.id
	})
end

function var0.listNotificationInterests(arg0)
	local var0 = var0.super.listNotificationInterests(arg0)

	table.insertto(var0, {
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	})

	return var0
end

function var0.handleNotification(arg0, arg1)
	var0.super.handleNotification(arg0, arg1)

	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0:addSubLayers(Context.New({
			mediator = AwardInfoMediator,
			viewComponent = AnniversaryIslandAwardLayer,
			data = {
				items = var1.awards
			},
			onRemoved = var1.callback
		}))
	end
end

function var0.CheckPreloadData(arg0, arg1)
	if getProxy(ContextProxy):getContextByMediator(AnniversaryIsland2023Mediator) then
		local var0 = getProxy(ContextProxy):getCurrentContext()

		arg0.prevContext = arg0.prevContext or var0

		getProxy(ContextProxy):CleanUntilMediator(AnniversaryIsland2023Mediator)
	else
		local var1 = Context.New()

		SCENE.SetSceneInfo(var1, SCENE.ANNIVERSARY_ISLAND_BACKHILL_2023)

		local var2 = getProxy(ContextProxy):getCurrentContext()

		var1:extendData({
			fromMediatorName = var2.mediator.__cname
		})
		getProxy(ContextProxy):pushContext(var1)

		arg0.prevContext = arg0.prevContext or var2
	end

	existCall(arg1)
end

return var0
