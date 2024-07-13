local var0_0 = class("AtelierMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(GAME.UPDATE_ATELIER_BUFF, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.UPDATE_ATELIER_BUFF, arg1_2)
	end)
	arg0_1:bind(AtelierMaterialDetailMediator.SHOW_DETAIL, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = AtelierMaterialDetailMediator,
			viewComponent = AtelierMaterialDetailLayer,
			data = {
				material = arg1_3
			}
		}))
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	assert(var0_1 and not var0_1:isEnd())
	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.UPDATE_ATELIER_BUFF_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == nil then
		-- block empty
	elseif var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ATELIER_LINK then
			arg0_5.viewComponent:SetActivity(var1_5)
		end
	elseif var0_5 == GAME.UPDATE_ATELIER_BUFF_DONE then
		arg0_5.viewComponent:OnUpdateAtelierBuff()
	end
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
