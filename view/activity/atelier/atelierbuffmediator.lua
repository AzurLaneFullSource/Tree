local var0 = class("AtelierMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(GAME.UPDATE_ATELIER_BUFF, function(arg0, arg1)
		arg0:sendNotification(GAME.UPDATE_ATELIER_BUFF, arg1)
	end)
	arg0:bind(AtelierMaterialDetailMediator.SHOW_DETAIL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = AtelierMaterialDetailMediator,
			viewComponent = AtelierMaterialDetailLayer,
			data = {
				material = arg1
			}
		}))
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	assert(var0 and not var0:isEnd())
	arg0.viewComponent:SetActivity(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.UPDATE_ATELIER_BUFF_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ATELIER_LINK then
			arg0.viewComponent:SetActivity(var1)
		end
	elseif var0 == GAME.UPDATE_ATELIER_BUFF_DONE then
		arg0.viewComponent:OnUpdateAtelierBuff()
	end
end

function var0.remove(arg0)
	return
end

return var0
