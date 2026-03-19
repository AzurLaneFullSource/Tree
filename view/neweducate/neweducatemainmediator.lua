local var0_0 = class("NewEducateMainMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.OPEN_COLLECT_LAYER = "NewEducateMainMediator.OPEN_COLLECT_LAYER"
var0_0.ON_SELECT_MIND = "NewEducateMainMediator.ON_SELECT_MIND"
var0_0.ON_UPGRADE_FAVOR = "NewEducateMainMediator.ON_UPGRADE_FAVOR"
var0_0.ON_TRIGGER_MAIN_EVENT = "NewEducateMainMediator.ON_TRIGGER_MAIN_EVENT"
var0_0.ON_REQ_TALENTS = "NewEducateMainMediator.ON_REQ_TALENTS"
var0_0.ON_REQ_CHOOSE = "NewEducateMainMediator.ON_REQ_CHOOSE"
var0_0.ON_REQ_TOPICS = "NewEducateMainMediator.ON_REQ_TOPICS"
var0_0.ON_SELECT_TOPIC = "NewEducateMainMediator.ON_SELECT_TOPIC"
var0_0.ON_ENTER_ASSESS = "NewEducateMainMediator.ON_ENTER_ASSESS"
var0_0.ON_SET_ASSESS_RANK = "NewEducateMainMediator.ON_SET_ASSESS_RANK"
var0_0.ON_STAGE_CHANGE = "NewEducateMainMediator.ON_STAGE_CHANGE"
var0_0.ON_NEXT_PLAN = "NewEducateMainMediator.ON_NEXT_PLAN"
var0_0.ON_REQ_MAP = "NewEducateMainMediator.ON_REQ_MAP"
var0_0.ON_REQ_ENDINGS = "NewEducateMainMediator.ON_REQ_ENDINGS"
var0_0.ON_RESET = "NewEducateMainMediator.ON_RESET"
var0_0.ON_SELECT_ENDING = "NewEducateMainMediator.ON_SELECT_ENDING"
var0_0.ON_START_ENDLESS = "NewEducateMainMediator.ON_START_ENDLESS"
var0_0.ON_CLEAR_NODE_CHAIN = "NewEducateMainMediator.ON_CLEAR_NODE_CHAIN"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_COLLECT_LAYER, function(arg0_2)
		arg0_1:addSubLayers(Context.New({
			mediator = NewEducateCollectEntranceMediator,
			viewComponent = NewEducateCollectEntranceLayer
		}))
	end)
	arg0_1:bind(var0_0.ON_SELECT_MIND, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_MIND, {
			id = arg0_1.contextData.char.id,
			callback = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE_FAVOR, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_FAVOR, {
			id = arg0_1.contextData.char.id,
			callback = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_TRIGGER_MAIN_EVENT, function(arg0_5)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_MAIN_EVENT, {
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_REQ_TALENTS, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_TALENTS, {
			id = arg0_1.contextData.char.id,
			callback = arg1_6
		})
	end)
	arg0_1:bind(var0_0.ON_REQ_CHOOSE, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_CHOOSE, {
			id = arg0_1.contextData.char.id,
			callback = arg1_7
		})
	end)
	arg0_1:bind(var0_0.ON_REQ_TOPICS, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_TOPICS, {
			id = arg0_1.contextData.char.id,
			callback = arg1_8
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_TOPIC, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_TOPIC, {
			id = arg0_1.contextData.char.id,
			topicId = arg1_9
		})
	end)
	arg0_1:bind(var0_0.ON_NEXT_PLAN, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_NEXT_PLAN, {
			rePlay = true,
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_ENTER_ASSESS, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_ENTER_ASSESS, {
			id = arg0_1.contextData.char.id,
			callback = arg1_11
		})
	end)
	arg0_1:bind(var0_0.ON_SET_ASSESS_RANK, function(arg0_12, arg1_12, arg2_12, arg3_12)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_ASSESS, {
			id = arg0_1.contextData.char.id,
			rank = arg1_12,
			endlessFail = arg2_12,
			callback = arg3_12
		})
	end)
	arg0_1:bind(var0_0.ON_STAGE_CHANGE, function(arg0_13)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_CHANGE_PHASE, {
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_REQ_MAP, function(arg0_14)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_MAP, {
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_REQ_ENDINGS, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_ENDINGS, {
			id = arg0_1.contextData.char.id,
			callback = arg1_15
		})
	end)
	arg0_1:bind(var0_0.ON_RESET, function(arg0_16, arg1_16)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_RESET, {
			id = arg0_1.contextData.char.id,
			difficulty = arg0_1.contextData.char.difficulty,
			callback = arg1_16
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_ENDING, function(arg0_17, arg1_17)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_ENDING, {
			isMain = true,
			id = arg0_1.contextData.char.id,
			endingId = arg1_17
		})
	end)
	arg0_1:bind(var0_0.ON_START_ENDLESS, function(arg0_18)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_CHANGE_PHASE, {
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_CLEAR_NODE_CHAIN, function(arg0_19)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_CLEAR_NODE_CHAIN, {
			id = arg0_1.contextData.char.id
		})
	end)
end

function var0_0.listNotificationInterests(arg0_20)
	return {
		NewEducateProxy.RESOURCE_UPDATED,
		NewEducateProxy.ATTR_UPDATED,
		NewEducateProxy.PERSONALITY_UPDATED,
		NewEducateProxy.TALENT_UPDATED,
		NewEducateProxy.STATUS_UPDATED,
		NewEducateProxy.TAROT_UPDATED,
		NewEducateProxy.NEXT_ROUND,
		GAME.NEW_EDUCATE_SEL_TOPIC_DONE,
		GAME.NEW_EDUCATE_NODE_START,
		GAME.NEW_EDUCATE_NEXT_NODE,
		GAME.NEW_EDUCATE_CHECK_FSM,
		GAME.NEW_EDUCATE_CHECK_PRIORITY_FSM,
		GAME.NEW_EDUCATE_GET_EXTRA_DROP_DONE,
		GAME.NEW_EDUCATE_UPGRADE_FAVOR_DONE,
		GAME.NEW_EDUCATE_REFRESH_DONE,
		GAME.NEW_EDUCATE_ENTER_ASSESS_DONE,
		GAME.NEW_EDUCATE_ASSESS_DONE,
		GAME.NEW_EDUCATE_CHANGE_PHASE_DONE,
		GAME.NEW_EDUCATE_NEXT_PLAN_DONE,
		GAME.NEW_EDUCATE_GET_MAP_DONE,
		GAME.NEW_EDUCATE_SEL_MIND_DONE,
		GAME.NEW_EDUCATE_SEL_ENDING_DONE,
		GAME.NEW_EDUCATE_SET_CALL_DONE
	}
end

function var0_0.handleNotification(arg0_21, arg1_21)
	local var0_21 = arg1_21:getName()
	local var1_21 = arg1_21:getBody()

	if var0_21 == NewEducateProxy.RESOURCE_UPDATED then
		arg0_21.viewComponent:OnResUpdate()
	elseif var0_21 == NewEducateProxy.ATTR_UPDATED then
		arg0_21.viewComponent:OnAttrUpdate()
	elseif var0_21 == NewEducateProxy.PERSONALITY_UPDATED then
		arg0_21.viewComponent:OnPersonalityUpdate(var1_21.number, var1_21.oldTag)
	elseif var0_21 == NewEducateProxy.TALENT_UPDATED then
		arg0_21.viewComponent:OnTalentUpdate()
	elseif var0_21 == NewEducateProxy.STATUS_UPDATED then
		arg0_21.viewComponent:OnStatusUpdate()
	elseif var0_21 == NewEducateProxy.TAROT_UPDATED then
		arg0_21.viewComponent:OnTarotUpdate()
	elseif var0_21 == NewEducateProxy.NEXT_ROUND then
		arg0_21.viewComponent:OnNextRound()
	elseif var0_21 == GAME.NEW_EDUCATE_NODE_START then
		arg0_21.viewComponent:OnNodeStart(var1_21.node)
	elseif var0_21 == GAME.NEW_EDUCATE_NEXT_NODE then
		arg0_21.viewComponent:OnNextNode(var1_21)
	elseif var0_21 == GAME.NEW_EDUCATE_CHECK_FSM then
		arg0_21.viewComponent:CheckFSM()
	elseif var0_21 == GAME.NEW_EDUCATE_CHECK_PRIORITY_FSM then
		arg0_21:CheckPriorityState()
	elseif var0_21 == GAME.NEW_EDUCATE_GET_EXTRA_DROP_DONE then
		if #var1_21.drops == 0 then
			arg0_21:AddResultLayer(var1_21)
		else
			arg0_21.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
				items = var1_21.drops,
				removeFunc = function()
					arg0_21:AddResultLayer(var1_21)
				end
			})
		end
	elseif var0_21 == GAME.NEW_EDUCATE_UPGRADE_FAVOR_DONE then
		arg0_21.viewComponent:UpdateFavorInfo()
		arg0_21.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
			isFavor = true,
			items = var1_21.drops,
			removeFunc = function()
				arg0_21.viewComponent:CheckFavorUpgrade(var1_21.callback)
			end
		})
	elseif var0_21 == GAME.NEW_EDUCATE_REFRESH_DONE then
		arg0_21.viewComponent:OnReset()
	elseif var0_21 == GAME.NEW_EDUCATE_SEL_TOPIC_DONE then
		arg0_21:StartNodeWithCheckDrops(var1_21)
	elseif var0_21 == GAME.NEW_EDUCATE_ENTER_ASSESS_DONE then
		if #var1_21.drops == 0 then
			existCall(var1_21.callback)
		else
			arg0_21.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
				items = var1_21.drops,
				removeFunc = var1_21.callback
			})
		end
	elseif var0_21 == GAME.NEW_EDUCATE_ASSESS_DONE then
		seriesAsync({
			function(arg0_24)
				if #var1_21.drops == 0 then
					arg0_24()
				else
					arg0_21.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
						items = var1_21.drops,
						removeFunc = arg0_24
					})
				end
			end
		}, function(arg0_25)
			if var1_21.node ~= 0 then
				arg0_21.viewComponent:OnNodeStart(var1_21.node)
			else
				arg0_21.viewComponent:SeriesCheck()
			end
		end)
	elseif var0_21 == GAME.NEW_EDUCATE_CHANGE_PHASE_DONE then
		arg0_21.viewComponent:AddNewRoundDrops(var1_21.drops)
		arg0_21:CheckFirstNodeExist(var1_21.node)
	elseif var0_21 == GAME.NEW_EDUCATE_NEXT_PLAN_DONE then
		local function var2_21()
			if var1_21.isFristNode then
				arg0_21.viewComponent:OnNodeStart(var1_21.node)
			else
				arg0_21.viewComponent:OnNextNode(var1_21)
			end
		end

		if #var1_21.drops == 0 then
			var2_21()
		else
			arg0_21.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
				items = var1_21.drops,
				removeFunc = var2_21
			})
		end
	elseif var0_21 == GAME.NEW_EDUCATE_GET_MAP_DONE then
		if #var1_21.drops == 0 then
			arg0_21.viewComponent:CheckFSM()
		else
			arg0_21.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
				items = var1_21.drops,
				removeFunc = function()
					arg0_21.viewComponent:CheckFSM()
				end
			})
		end
	elseif var0_21 == GAME.NEW_EDUCATE_SEL_MIND_DONE then
		arg0_21:StartNodeWithCheckDrops(var1_21)
	elseif var0_21 == GAME.NEW_EDUCATE_SEL_ENDING_DONE then
		if var1_21.isMain then
			arg0_21.viewComponent:OnSelDone(var1_21.id)
		end
	elseif var0_21 == GAME.NEW_EDUCATE_SET_CALL_DONE then
		arg0_21.viewComponent:UpdateCallName()
	end
end

function var0_0.CheckFirstNodeExist(arg0_28, arg1_28)
	if arg1_28 == 0 then
		arg0_28.viewComponent:SeriesCheck()
	else
		arg0_28.viewComponent:OnNodeStart(arg1_28)
	end
end

function var0_0.StartNodeWithCheckDrops(arg0_29, arg1_29)
	if #arg1_29.drops == 0 then
		arg0_29.viewComponent:OnNodeStart(arg1_29.node)
	else
		arg0_29.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
			items = arg1_29.drops,
			removeFunc = function()
				arg0_29.viewComponent:OnNodeStart(arg1_29.node)
			end
		})
	end
end

function var0_0.AddResultLayer(arg0_31, arg1_31)
	if #arg1_31.scheduleDrops > 0 then
		arg0_31:addSubLayers(Context.New({
			viewComponent = NewEducateScheduleResultLayer,
			mediator = NewEducateScheduleResultMediator,
			data = {
				drops = arg1_31.scheduleDrops,
				onExit = function()
					arg0_31.viewComponent:CheckFSM()
				end
			}
		}))
	else
		arg0_31.viewComponent:CheckFSM()
	end
end

return var0_0
