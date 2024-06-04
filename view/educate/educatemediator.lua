local var0 = class("EducateMediator", import(".base.EducateContextMediator"))

var0.ON_DEFAULT_TARGET_SET = "EducateMediator:ON_DEFAULT_TARGET_SET"
var0.ON_UPGRADE_FAVOR = "EducateMediator:ON_UPGRADE_FAVOR"
var0.ON_SPECIAL_EVENT_TRIGGER = "EducateMediator:ON_SPECIAL_EVENT_TRIGGER"
var0.ON_EVENT_TRIGGER = "EducateMediator:ON_EVENT_TRIGGER"
var0.ON_GET_EVENT = "EducateMediator:ON_GET_EVENT"
var0.ON_EXECTUE_PLANS = "EducateMediator:ON_EXECTUE_PLANS"
var0.ON_ENDING_TRIGGER = "EducateMediator:ON_ENDING_TRIGGER"
var0.ON_GAME_RESET = "EducateMediator:ON_GAME_RESET"
var0.ENTER_VIRTUAL_STAGE = "EducateMediator.ENTER_VIRTUAL_STAGE"

function var0.register(arg0)
	arg0:bind(var0.ON_DEFAULT_TARGET_SET, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_SET_TARGET, {
			id = arg1.id,
			callback = arg1.callback
		})
	end)
	arg0:bind(var0.ON_UPGRADE_FAVOR, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_UPGRADE_FAVOR, {
			callback = arg1
		})
	end)
	arg0:bind(var0.ON_SPECIAL_EVENT_TRIGGER, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_TRIGGER_SPEC_EVENT, {
			eventId = arg1.id,
			callback = arg1.callback
		})
	end)
	arg0:bind(var0.ON_EVENT_TRIGGER, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_TRIGGER_EVENT, {
			eventId = arg1.id,
			callback = arg1.callback
		})
	end)
	arg0:bind(var0.ON_GET_EVENT, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_GET_EVENTS, {
			callback = arg1
		})
	end)
	arg0:bind(var0.ON_EXECTUE_PLANS, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_EXECUTE_PLANS, {
			callback = arg1
		})
	end)
	arg0:bind(var0.ON_ENDING_TRIGGER, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_TRIGGER_END, {
			id = getProxy(EducateProxy):GetEndingResult()
		})
	end)
	arg0:bind(var0.ON_GAME_RESET, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_RESET)
	end)
	arg0:bind(var0.ENTER_VIRTUAL_STAGE, function(arg0, arg1)
		arg0.viewComponent:updateResPanel()
		arg0.viewComponent:updatePaintingUI()
		arg0.viewComponent:updateArchivePanel()
		arg0.viewComponent:PlayBGM()
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		EducateProxy.RESOURCE_UPDATED,
		EducateProxy.ATTR_UPDATED,
		EducateProxy.TIEM_UPDATED,
		EducateProxy.TIME_WEEKDAY_UPDATED,
		EducateProxy.BUFF_ADDED,
		EducateTaskProxy.TASK_UPDATED,
		GAME.EDUCATE_UPGRADE_FAVOR_DONE,
		GAME.EDUCATE_TRIGGER_SPEC_EVENT_DONE,
		GAME.EDUCATE_TRIGGER_EVENT_DONE,
		GAME.EDUCATE_SET_TARGET_DONE,
		GAME.EDUCATE_TRIGGER_END_DONE,
		GAME.EDUCATE_RESET_DONE,
		GAME.EDUCATE_REFRESH_DONE,
		GAME.EDUCATE_EXECUTE_PLANS_DONE,
		GAME.EDUCATE_SUBMIT_TASK_DONE,
		GAME.EDUCATE_GET_TARGET_AWARD_DONE,
		EducateProxy.GUIDE_CHECK,
		EducateProxy.MAIN_SCENE_ADD_LAYER,
		EducateProxy.POLAROID_ADDED,
		EducateProxy.MEMORY_ADDED,
		EducateTaskProxy.TASK_ADDED,
		EducateTaskProxy.TASK_REMOVED,
		EducateProxy.CLEAR_NEW_TIP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == EducateProxy.RESOURCE_UPDATED then
		arg0.viewComponent:updateResPanel()
		arg0.viewComponent:updateTargetPanel()
	elseif var0 == EducateProxy.ATTR_UPDATED then
		arg0.viewComponent:updateArchivePanel()
		arg0.viewComponent:updateTargetPanel()
	elseif var0 == EducateProxy.TIEM_UPDATED then
		arg0.viewComponent:updateDatePanel()
		arg0.viewComponent:updateTargetPanel()
		arg0.viewComponent:updatePaintingData()
	elseif var0 == EducateProxy.TIME_WEEKDAY_UPDATED then
		arg0.viewComponent:updateWeekDay(var1.weekDay)
	elseif var0 == EducateProxy.BUFF_ADDED then
		arg0.viewComponent:updateArchivePanel()

		if not pg.NewStoryMgr.GetInstance():IsPlayed("tb_10") then
			arg0.viewComponent:showArchivePanel()
		end

		arg0.viewComponent:OnCheckGuide()
	elseif var0 == EducateTaskProxy.TASK_UPDATED then
		arg0.viewComponent:updateTargetPanel()
	elseif var0 == GAME.EDUCATE_UPGRADE_FAVOR_DONE then
		arg0.viewComponent:ShowFavorUpgrade(var1.drops, var1.performs, var1.cb)
	elseif var0 == GAME.EDUCATE_TRIGGER_SPEC_EVENT_DONE then
		if var1.type == EducateSpecialEvent.TYPE_BUBBLE_MIND or var1.type == EducateSpecialEvent.TYPE_BUBBLE_DISCOUNT then
			arg0.viewComponent:ShowSpecialEvent(var1.id, var1.drops, var1.cb)
		end
	elseif var0 == GAME.EDUCATE_TRIGGER_EVENT_DONE then
		if pg.child_event[var1.id].type == EducateEvent.TYPE_BUBBLE then
			arg0.viewComponent:ShowEvent(var1.id, var1.drops, var1.cb)
		end
	elseif var0 == GAME.EDUCATE_SET_TARGET_DONE then
		arg0:addSubLayers(Context.New({
			mediator = EducateTargetMediator,
			viewComponent = EducateTargetLayer
		}))
		arg0.viewComponent:updateBottomPanel()
		arg0.viewComponent:updateDatePanel()
		arg0.viewComponent:updateTargetPanel()
		arg0.viewComponent:updateMindTip()
		arg0.viewComponent:OnCheckGuide()
	elseif var0 == GAME.EDUCATE_TRIGGER_END_DONE then
		arg0.viewComponent:updateBottomPanel()
		arg0.viewComponent:updateDatePanel()
		arg0.viewComponent:updateTargetPanel()
		arg0.viewComponent:updateMindTip()
		arg0.viewComponent:OnCheckGuide()
	elseif var0 == GAME.EDUCATE_RESET_DONE or var0 == GAME.EDUCATE_REFRESH_DONE then
		arg0.viewComponent:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	elseif var0 == GAME.EDUCATE_EXECUTE_PLANS_DONE then
		local var2 = var1.isSkip

		arg0:playPlansPerform(var2, var1)
	elseif var0 == GAME.EDUCATE_SUBMIT_TASK_DONE then
		arg0.viewComponent:updateTargetPanel()
		arg0.viewComponent:updateMindTip()
	elseif var0 == GAME.EDUCATE_GET_TARGET_AWARD_DONE then
		arg0.viewComponent:updateTargetPanel()
	elseif var0 == EducateProxy.GUIDE_CHECK then
		if var1.view == arg0.viewComponent.__cname then
			arg0.viewComponent:OnCheckGuide()
		end
	elseif var0 == EducateProxy.MAIN_SCENE_ADD_LAYER then
		arg0:addSubLayers(var1)
	elseif var0 == EducateProxy.POLAROID_ADDED or var0 == EducateProxy.MEMORY_ADDED then
		arg0.viewComponent:updateBookNewTip()
	elseif var0 == EducateTaskProxy.TASK_ADDED or var0 == EducateTaskProxy.TASK_REMOVED then
		arg0.viewComponent:updateMindNewTip()
		arg0.viewComponent:updateTargetPanel()
	elseif var0 == EducateProxy.CLEAR_NEW_TIP then
		if var1.index == EducateTipHelper.NEW_MEMORY or var1.index == EducateTipHelper.NEW_POLAROID then
			arg0.viewComponent:updateBookNewTip()
		elseif var1.index == EducateTipHelper.NEW_MIND_TASK then
			arg0.viewComponent:updateMindNewTip()
		end
	end
end

function var0.playPlansPerform(arg0, arg1, arg2)
	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = EducateCalendarLayer,
			mediator = EducateCalendarMediator,
			data = {
				onExit = arg0
			}
		}))
	end)

	if not EducateConst.FORCE_SKIP_PLAN_PERFORM then
		table.insert(var0, function(arg0)
			arg0:addSubLayers(Context.New({
				viewComponent = EducateSchedulePerformLayer,
				mediator = EducateSchedulePerformMediator,
				data = {
					gridData = arg2.gridData,
					plan_results = arg2.plan_results,
					events = arg2.events,
					skip = arg1,
					onExit = arg0
				}
			}))
		end)
	end

	table.insert(var0, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = EducateScheduleResultLayer,
			mediator = EducateScheduleResultMediator,
			data = {
				plan_results = arg2.plan_results,
				onExit = arg0
			}
		}))
	end)
	seriesAsync(var0, function()
		arg0.viewComponent:FlushView()
	end)
end

return var0
