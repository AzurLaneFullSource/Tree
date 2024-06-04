local var0 = class("EducateMapMediator", import("..base.EducateContextMediator"))

var0.ON_SPECIAL_EVENT_TRIGGER = "EducateMapMediator.ON_SPECIAL_EVENT_TRIGGER"
var0.ON_MAP_SITE_OPERATE = "EducateMapMediator.ON_MAP_SITE_OPERATE"
var0.ON_OPEN_SHOP = "EducateMapMediator.ON_OPEN_SHOP"
var0.ON_ADD_TASK_PROGRESS = "EducateMapMediator.ON_ADD_TASK_PROGRESS"

function var0.register(arg0)
	arg0:bind(var0.ON_SPECIAL_EVENT_TRIGGER, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_TRIGGER_SPEC_EVENT, {
			siteId = arg1.siteId,
			eventId = arg1.id,
			callback = arg1.callback
		})
	end)
	arg0:bind(var0.ON_MAP_SITE_OPERATE, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_MAP_SITE, {
			siteId = arg1.siteId,
			optionVO = arg1.optionVO
		})
	end)
	arg0:bind(var0.ON_OPEN_SHOP, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = EducateShopMediator,
			viewComponent = EducateShopLayer,
			data = {
				shopId = arg1
			}
		}))
	end)
	arg0:bind(var0.ON_ADD_TASK_PROGRESS, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_ADD_TASK_PROGRESS, {
			system = arg1.system,
			progresses = arg1.progresses
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		EducateProxy.RESOURCE_UPDATED,
		EducateProxy.ATTR_UPDATED,
		EducateProxy.BUFF_ADDED,
		EducateProxy.TIME_UPDATED,
		EducateProxy.TIME_WEEKDAY_UPDATED,
		EducateTaskProxy.TASK_UPDATED,
		EducateTaskProxy.TASK_ADDED,
		EducateTaskProxy.TASK_REMOVED,
		EducateProxy.CLEAR_NEW_TIP,
		GAME.EDUCATE_REFRESH_DONE,
		GAME.EDUCATE_SUBMIT_TASK_DONE,
		GAME.EDUCATE_TRIGGER_SPEC_EVENT_DONE,
		GAME.EDUCATE_MAP_SITE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == EducateProxy.RESOURCE_UPDATED then
		arg0.viewComponent:updateRes()
	elseif var0 == EducateProxy.ATTR_UPDATED then
		arg0.viewComponent:updateAttrs()
	elseif var0 == EducateProxy.BUFF_ADDED then
		arg0.viewComponent:updateAttrs()
	elseif var0 == EducateProxy.TIME_UPDATED then
		arg0.viewComponent:updateTime()
		arg0.viewComponent:updateRes()
		arg0.viewComponent:updateTarget()
	elseif var0 == EducateProxy.TIME_WEEKDAY_UPDATED then
		arg0.viewComponent:updateTimeWeekDay(var1.weekDay)
	elseif var0 == EducateTaskProxy.TASK_UPDATED or var0 == EducateTaskProxy.TASK_ADDED or var0 == EducateTaskProxy.TASK_REMOVED or var0 == GAME.EDUCATE_SUBMIT_TASK_DONE then
		arg0.viewComponent:updateTarget()
	elseif var0 == EducateProxy.CLEAR_NEW_TIP then
		if var1.index == EducateTipHelper.NEW_SITE then
			arg0.viewComponent:clearNewTip(var1.id)
		end
	elseif var0 == GAME.EDUCATE_REFRESH_DONE then
		arg0.viewComponent:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	elseif var0 == GAME.EDUCATE_TRIGGER_SPEC_EVENT_DONE then
		if var1.type == EducateSpecialEvent.TYPE_SITE then
			arg0.viewComponent:ShowSpecEvent(var1.siteId, var1.id, var1.drops, var1.cb)
		end
	elseif var0 == GAME.EDUCATE_MAP_SITE_DONE then
		assert(var1.branchId ~= 0, "请检查配置, 无返回结果分支, optionId: " .. var1.optionId)
		arg0.viewComponent:ShowSitePerform(var1.optionId, var1.branchId, var1.events, var1.drops, var1.eventDrops)
	end
end

return var0
