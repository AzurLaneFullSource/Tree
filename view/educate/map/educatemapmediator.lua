local var0_0 = class("EducateMapMediator", import("..base.EducateContextMediator"))

var0_0.ON_SPECIAL_EVENT_TRIGGER = "EducateMapMediator.ON_SPECIAL_EVENT_TRIGGER"
var0_0.ON_MAP_SITE_OPERATE = "EducateMapMediator.ON_MAP_SITE_OPERATE"
var0_0.ON_OPEN_SHOP = "EducateMapMediator.ON_OPEN_SHOP"
var0_0.ON_ADD_TASK_PROGRESS = "EducateMapMediator.ON_ADD_TASK_PROGRESS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SPECIAL_EVENT_TRIGGER, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.EDUCATE_TRIGGER_SPEC_EVENT, {
			siteId = arg1_2.siteId,
			eventId = arg1_2.id,
			callback = arg1_2.callback
		})
	end)
	arg0_1:bind(var0_0.ON_MAP_SITE_OPERATE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.EDUCATE_MAP_SITE, {
			siteId = arg1_3.siteId,
			optionVO = arg1_3.optionVO
		})
	end)
	arg0_1:bind(var0_0.ON_OPEN_SHOP, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = EducateShopMediator,
			viewComponent = EducateShopLayer,
			data = {
				shopId = arg1_4
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_ADD_TASK_PROGRESS, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.EDUCATE_ADD_TASK_PROGRESS, {
			system = arg1_5.system,
			progresses = arg1_5.progresses
		})
	end)
end

function var0_0.listNotificationInterests(arg0_6)
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

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == EducateProxy.RESOURCE_UPDATED then
		arg0_7.viewComponent:updateRes()
	elseif var0_7 == EducateProxy.ATTR_UPDATED then
		arg0_7.viewComponent:updateAttrs()
	elseif var0_7 == EducateProxy.BUFF_ADDED then
		arg0_7.viewComponent:updateAttrs()
	elseif var0_7 == EducateProxy.TIME_UPDATED then
		arg0_7.viewComponent:updateTime()
		arg0_7.viewComponent:updateRes()
		arg0_7.viewComponent:updateTarget()
	elseif var0_7 == EducateProxy.TIME_WEEKDAY_UPDATED then
		arg0_7.viewComponent:updateTimeWeekDay(var1_7.weekDay)
	elseif var0_7 == EducateTaskProxy.TASK_UPDATED or var0_7 == EducateTaskProxy.TASK_ADDED or var0_7 == EducateTaskProxy.TASK_REMOVED or var0_7 == GAME.EDUCATE_SUBMIT_TASK_DONE then
		arg0_7.viewComponent:updateTarget()
	elseif var0_7 == EducateProxy.CLEAR_NEW_TIP then
		if var1_7.index == EducateTipHelper.NEW_SITE then
			arg0_7.viewComponent:clearNewTip(var1_7.id)
		end
	elseif var0_7 == GAME.EDUCATE_REFRESH_DONE then
		arg0_7.viewComponent:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	elseif var0_7 == GAME.EDUCATE_TRIGGER_SPEC_EVENT_DONE then
		if var1_7.type == EducateSpecialEvent.TYPE_SITE then
			arg0_7.viewComponent:ShowSpecEvent(var1_7.siteId, var1_7.id, var1_7.drops, var1_7.cb)
		end
	elseif var0_7 == GAME.EDUCATE_MAP_SITE_DONE then
		assert(var1_7.branchId ~= 0, "请检查配置, 无返回结果分支, optionId: " .. var1_7.optionId)
		arg0_7.viewComponent:ShowSitePerform(var1_7.optionId, var1_7.branchId, var1_7.events, var1_7.drops, var1_7.eventDrops)
	end
end

return var0_0
