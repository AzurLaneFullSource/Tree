local var0_0 = class("EducateMediator", import(".base.EducateContextMediator"))

var0_0.ON_DEFAULT_TARGET_SET = "EducateMediator:ON_DEFAULT_TARGET_SET"
var0_0.ON_UPGRADE_FAVOR = "EducateMediator:ON_UPGRADE_FAVOR"
var0_0.ON_SPECIAL_EVENT_TRIGGER = "EducateMediator:ON_SPECIAL_EVENT_TRIGGER"
var0_0.ON_EVENT_TRIGGER = "EducateMediator:ON_EVENT_TRIGGER"
var0_0.ON_GET_EVENT = "EducateMediator:ON_GET_EVENT"
var0_0.ON_EXECTUE_PLANS = "EducateMediator:ON_EXECTUE_PLANS"
var0_0.ON_ENDING_TRIGGER = "EducateMediator:ON_ENDING_TRIGGER"
var0_0.ON_GAME_RESET = "EducateMediator:ON_GAME_RESET"
var0_0.ENTER_VIRTUAL_STAGE = "EducateMediator.ENTER_VIRTUAL_STAGE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_DEFAULT_TARGET_SET, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.EDUCATE_SET_TARGET, {
			id = arg1_2.id,
			callback = arg1_2.callback
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE_FAVOR, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.EDUCATE_UPGRADE_FAVOR, {
			callback = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_SPECIAL_EVENT_TRIGGER, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.EDUCATE_TRIGGER_SPEC_EVENT, {
			eventId = arg1_4.id,
			callback = arg1_4.callback
		})
	end)
	arg0_1:bind(var0_0.ON_EVENT_TRIGGER, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.EDUCATE_TRIGGER_EVENT, {
			eventId = arg1_5.id,
			callback = arg1_5.callback
		})
	end)
	arg0_1:bind(var0_0.ON_GET_EVENT, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.EDUCATE_GET_EVENTS, {
			callback = arg1_6
		})
	end)
	arg0_1:bind(var0_0.ON_EXECTUE_PLANS, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.EDUCATE_EXECUTE_PLANS, {
			callback = arg1_7
		})
	end)
	arg0_1:bind(var0_0.ON_ENDING_TRIGGER, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.EDUCATE_TRIGGER_END, {
			id = getProxy(EducateProxy):GetEndingResult()
		})
	end)
	arg0_1:bind(var0_0.ON_GAME_RESET, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.EDUCATE_RESET)
	end)
	arg0_1:bind(var0_0.ENTER_VIRTUAL_STAGE, function(arg0_10, arg1_10)
		arg0_1.viewComponent:updateResPanel()
		arg0_1.viewComponent:updatePaintingUI()
		arg0_1.viewComponent:updateArchivePanel()
		arg0_1.viewComponent:PlayBGM()
	end)
end

function var0_0.listNotificationInterests(arg0_11)
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

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()

	if var0_12 == EducateProxy.RESOURCE_UPDATED then
		arg0_12.viewComponent:updateResPanel()
		arg0_12.viewComponent:updateTargetPanel()
	elseif var0_12 == EducateProxy.ATTR_UPDATED then
		arg0_12.viewComponent:updateArchivePanel()
		arg0_12.viewComponent:updateTargetPanel()
	elseif var0_12 == EducateProxy.TIEM_UPDATED then
		arg0_12.viewComponent:updateDatePanel()
		arg0_12.viewComponent:updateTargetPanel()
		arg0_12.viewComponent:updatePaintingData()
	elseif var0_12 == EducateProxy.TIME_WEEKDAY_UPDATED then
		arg0_12.viewComponent:updateWeekDay(var1_12.weekDay)
	elseif var0_12 == EducateProxy.BUFF_ADDED then
		arg0_12.viewComponent:updateArchivePanel()

		if not pg.NewStoryMgr.GetInstance():IsPlayed("tb_10") then
			arg0_12.viewComponent:showArchivePanel()
		end

		arg0_12.viewComponent:OnCheckGuide()
	elseif var0_12 == EducateTaskProxy.TASK_UPDATED then
		arg0_12.viewComponent:updateTargetPanel()
	elseif var0_12 == GAME.EDUCATE_UPGRADE_FAVOR_DONE then
		arg0_12.viewComponent:ShowFavorUpgrade(var1_12.drops, var1_12.performs, var1_12.cb)
	elseif var0_12 == GAME.EDUCATE_TRIGGER_SPEC_EVENT_DONE then
		if var1_12.type == EducateSpecialEvent.TYPE_BUBBLE_MIND or var1_12.type == EducateSpecialEvent.TYPE_BUBBLE_DISCOUNT then
			arg0_12.viewComponent:ShowSpecialEvent(var1_12.id, var1_12.drops, var1_12.cb)
		end
	elseif var0_12 == GAME.EDUCATE_TRIGGER_EVENT_DONE then
		if pg.child_event[var1_12.id].type == EducateEvent.TYPE_BUBBLE then
			arg0_12.viewComponent:ShowEvent(var1_12.id, var1_12.drops, var1_12.cb)
		end
	elseif var0_12 == GAME.EDUCATE_SET_TARGET_DONE then
		arg0_12:addSubLayers(Context.New({
			mediator = EducateTargetMediator,
			viewComponent = EducateTargetLayer
		}))
		arg0_12.viewComponent:updateBottomPanel()
		arg0_12.viewComponent:updateDatePanel()
		arg0_12.viewComponent:updateTargetPanel()
		arg0_12.viewComponent:updateMindTip()
		arg0_12.viewComponent:OnCheckGuide()
	elseif var0_12 == GAME.EDUCATE_TRIGGER_END_DONE then
		arg0_12.viewComponent:updateBottomPanel()
		arg0_12.viewComponent:updateDatePanel()
		arg0_12.viewComponent:updateTargetPanel()
		arg0_12.viewComponent:updateMindTip()
		arg0_12.viewComponent:OnCheckGuide()
	elseif var0_12 == GAME.EDUCATE_RESET_DONE or var0_12 == GAME.EDUCATE_REFRESH_DONE then
		arg0_12.viewComponent:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	elseif var0_12 == GAME.EDUCATE_EXECUTE_PLANS_DONE then
		local var2_12 = var1_12.isSkip

		arg0_12:playPlansPerform(var2_12, var1_12)
	elseif var0_12 == GAME.EDUCATE_SUBMIT_TASK_DONE then
		arg0_12.viewComponent:updateTargetPanel()
		arg0_12.viewComponent:updateMindTip()
	elseif var0_12 == GAME.EDUCATE_GET_TARGET_AWARD_DONE then
		arg0_12.viewComponent:updateTargetPanel()
	elseif var0_12 == EducateProxy.GUIDE_CHECK then
		if var1_12.view == arg0_12.viewComponent.__cname then
			arg0_12.viewComponent:OnCheckGuide()
		end
	elseif var0_12 == EducateProxy.MAIN_SCENE_ADD_LAYER then
		arg0_12:addSubLayers(var1_12)
	elseif var0_12 == EducateProxy.POLAROID_ADDED or var0_12 == EducateProxy.MEMORY_ADDED then
		arg0_12.viewComponent:updateBookNewTip()
	elseif var0_12 == EducateTaskProxy.TASK_ADDED or var0_12 == EducateTaskProxy.TASK_REMOVED then
		arg0_12.viewComponent:updateMindNewTip()
		arg0_12.viewComponent:updateTargetPanel()
	elseif var0_12 == EducateProxy.CLEAR_NEW_TIP then
		if var1_12.index == EducateTipHelper.NEW_MEMORY or var1_12.index == EducateTipHelper.NEW_POLAROID then
			arg0_12.viewComponent:updateBookNewTip()
		elseif var1_12.index == EducateTipHelper.NEW_MIND_TASK then
			arg0_12.viewComponent:updateMindNewTip()
		end
	end
end

function var0_0.playPlansPerform(arg0_13, arg1_13, arg2_13)
	local var0_13 = {}

	table.insert(var0_13, function(arg0_14)
		arg0_13:addSubLayers(Context.New({
			viewComponent = EducateCalendarLayer,
			mediator = EducateCalendarMediator,
			data = {
				onExit = arg0_14
			}
		}))
	end)

	if not EducateConst.FORCE_SKIP_PLAN_PERFORM then
		table.insert(var0_13, function(arg0_15)
			arg0_13:addSubLayers(Context.New({
				viewComponent = EducateSchedulePerformLayer,
				mediator = EducateSchedulePerformMediator,
				data = {
					gridData = arg2_13.gridData,
					plan_results = arg2_13.plan_results,
					events = arg2_13.events,
					skip = arg1_13,
					onExit = arg0_15
				}
			}))
		end)
	end

	table.insert(var0_13, function(arg0_16)
		arg0_13:addSubLayers(Context.New({
			viewComponent = EducateScheduleResultLayer,
			mediator = EducateScheduleResultMediator,
			data = {
				plan_results = arg2_13.plan_results,
				onExit = arg0_16
			}
		}))
	end)
	seriesAsync(var0_13, function()
		arg0_13.viewComponent:FlushView()
	end)
end

return var0_0
