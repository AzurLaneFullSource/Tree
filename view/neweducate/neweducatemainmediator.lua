local var0_0 = class("NewEducateMainMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.OPEN_COLLECT_LAYER = "NewEducateMainMediator.OPEN_COLLECT_LAYER"
var0_0.ON_SELECT_MIND = "NewEducateMainMediator.ON_SELECT_MIND"
var0_0.ON_UPGRADE_FAVOR = "NewEducateMainMediator.ON_UPGRADE_FAVOR"
var0_0.ON_TRIGGER_MAIN_EVENT = "NewEducateMainMediator.ON_TRIGGER_MAIN_EVENT"
var0_0.ON_REQ_TALENTS = "NewEducateMainMediator.ON_REQ_TALENTS"
var0_0.ON_REQ_TOPICS = "NewEducateMainMediator.ON_REQ_TOPICS"
var0_0.ON_SELECT_TOPIC = "NewEducateMainMediator.ON_SELECT_TOPIC"
var0_0.ON_SET_ASSESS_RANK = "NewEducateMainMediator.ON_SET_ASSESS_RANK"
var0_0.ON_STAGE_CHANGE = "NewEducateMainMediator.ON_STAGE_CHANGE"
var0_0.ON_NEXT_PLAN = "NewEducateMainMediator.ON_NEXT_PLAN"
var0_0.ON_REQ_MAP = "NewEducateMainMediator.ON_REQ_MAP"
var0_0.ON_REQ_ENDINGS = "NewEducateMainMediator.ON_REQ_ENDINGS"
var0_0.ON_RESET = "NewEducateMainMediator.ON_RESET"
var0_0.ON_SELECT_ENDING = "NewEducateMainMediator.ON_SELECT_ENDING"
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
	arg0_1:bind(var0_0.ON_REQ_TOPICS, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_TOPICS, {
			id = arg0_1.contextData.char.id,
			callback = arg1_7
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_TOPIC, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_TOPIC, {
			id = arg0_1.contextData.char.id,
			topicId = arg1_8
		})
	end)
	arg0_1:bind(var0_0.ON_NEXT_PLAN, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_NEXT_PLAN, {
			rePlay = true,
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_SET_ASSESS_RANK, function(arg0_10, arg1_10, arg2_10)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_ASSESS, {
			id = arg0_1.contextData.char.id,
			rank = arg1_10,
			callback = arg2_10
		})
	end)
	arg0_1:bind(var0_0.ON_STAGE_CHANGE, function(arg0_11)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_CHANGE_PHASE, {
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_REQ_MAP, function(arg0_12)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_MAP, {
			id = arg0_1.contextData.char.id
		})
	end)
	arg0_1:bind(var0_0.ON_REQ_ENDINGS, function(arg0_13, arg1_13)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_ENDINGS, {
			id = arg0_1.contextData.char.id,
			callback = arg1_13
		})
	end)
	arg0_1:bind(var0_0.ON_RESET, function(arg0_14, arg1_14)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_RESET, {
			id = arg0_1.contextData.char.id,
			callback = arg1_14
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_ENDING, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_ENDING, {
			isMain = true,
			id = arg0_1.contextData.char.id,
			endingId = arg1_15
		})
	end)
	arg0_1:bind(var0_0.ON_CLEAR_NODE_CHAIN, function(arg0_16)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_CLEAR_NODE_CHAIN, {
			id = arg0_1.contextData.char.id
		})
	end)
end

function var0_0.listNotificationInterests(arg0_17)
	return {
		NewEducateProxy.RESOURCE_UPDATED,
		NewEducateProxy.ATTR_UPDATED,
		NewEducateProxy.PERSONALITY_UPDATED,
		NewEducateProxy.TALENT_UPDATED,
		NewEducateProxy.STATUS_UPDATED,
		NewEducateProxy.NEXT_ROUND,
		GAME.NEW_EDUCATE_SEL_TOPIC_DONE,
		GAME.NEW_EDUCATE_NODE_START,
		GAME.NEW_EDUCATE_NEXT_NODE,
		GAME.NEW_EDUCATE_CHECK_FSM,
		GAME.NEW_EDUCATE_GET_EXTRA_DROP_DONE,
		GAME.NEW_EDUCATE_UPGRADE_FAVOR_DONE,
		GAME.NEW_EDUCATE_REFRESH_DONE,
		GAME.NEW_EDUCATE_CHANGE_PHASE_DONE,
		GAME.NEW_EDUCATE_NEXT_PLAN_DONE,
		GAME.NEW_EDUCATE_GET_MAP_DONE,
		GAME.NEW_EDUCATE_SEL_MIND_DONE,
		GAME.NEW_EDUCATE_SEL_ENDING_DONE,
		GAME.NEW_EDUCATE_SET_CALL_DONE
	}
end

function var0_0.handleNotification(arg0_18, arg1_18)
	local var0_18 = arg1_18:getName()
	local var1_18 = arg1_18:getBody()

	if var0_18 == NewEducateProxy.RESOURCE_UPDATED then
		arg0_18.viewComponent:OnResUpdate()
	elseif var0_18 == NewEducateProxy.ATTR_UPDATED then
		arg0_18.viewComponent:OnAttrUpdate()
	elseif var0_18 == NewEducateProxy.PERSONALITY_UPDATED then
		arg0_18.viewComponent:OnPersonalityUpdate(var1_18.number, var1_18.oldTag)
	elseif var0_18 == NewEducateProxy.TALENT_UPDATED then
		arg0_18.viewComponent:OnTalentUpdate()
	elseif var0_18 == NewEducateProxy.STATUS_UPDATED then
		arg0_18.viewComponent:OnStatusUpdate()
	elseif var0_18 == NewEducateProxy.NEXT_ROUND then
		arg0_18.viewComponent:OnNextRound()
	elseif var0_18 == GAME.NEW_EDUCATE_NODE_START then
		arg0_18.viewComponent:OnNodeStart(var1_18.node)
	elseif var0_18 == GAME.NEW_EDUCATE_NEXT_NODE then
		arg0_18.viewComponent:OnNextNode(var1_18)
	elseif var0_18 == GAME.NEW_EDUCATE_CHECK_FSM then
		arg0_18.viewComponent:CheckFSM()
	elseif var0_18 == GAME.NEW_EDUCATE_GET_EXTRA_DROP_DONE then
		if #var1_18.drops == 0 then
			arg0_18:AddResultLayer(var1_18)
		else
			arg0_18.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
				items = var1_18.drops,
				removeFunc = function()
					arg0_18:AddResultLayer(var1_18)
				end
			})
		end
	elseif var0_18 == GAME.NEW_EDUCATE_UPGRADE_FAVOR_DONE then
		arg0_18.viewComponent:UpdateFavorInfo()
		arg0_18.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
			isFavor = true,
			items = var1_18.drops,
			removeFunc = function()
				arg0_18.viewComponent:CheckFavorUpgrade(var1_18.callback)
			end
		})
	elseif var0_18 == GAME.NEW_EDUCATE_REFRESH_DONE then
		arg0_18.viewComponent:OnReset()
	elseif var0_18 == GAME.NEW_EDUCATE_SEL_TOPIC_DONE then
		arg0_18:StartNodeWithCheckDrops(var1_18)
	elseif var0_18 == GAME.NEW_EDUCATE_CHANGE_PHASE_DONE then
		arg0_18.viewComponent:AddNewRoundDrops(var1_18.drops)
		arg0_18:CheckFirstNodeExist(var1_18.node)
	elseif var0_18 == GAME.NEW_EDUCATE_NEXT_PLAN_DONE then
		local function var2_18()
			if var1_18.isFristNode then
				arg0_18.viewComponent:OnNodeStart(var1_18.node)
			else
				arg0_18.viewComponent:OnNextNode(var1_18)
			end
		end

		if #var1_18.drops == 0 then
			var2_18()
		else
			arg0_18.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
				items = var1_18.drops,
				removeFunc = var2_18
			})
		end
	elseif var0_18 == GAME.NEW_EDUCATE_GET_MAP_DONE then
		if #var1_18.drops == 0 then
			arg0_18.viewComponent:CheckFSM()
		else
			arg0_18.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
				items = var1_18.drops,
				removeFunc = function()
					arg0_18.viewComponent:CheckFSM()
				end
			})
		end
	elseif var0_18 == GAME.NEW_EDUCATE_SEL_MIND_DONE then
		arg0_18:StartNodeWithCheckDrops(var1_18)
	elseif var0_18 == GAME.NEW_EDUCATE_SEL_ENDING_DONE then
		if var1_18.isMain then
			arg0_18.viewComponent:OnSelDone(var1_18.id)
		end
	elseif var0_18 == GAME.NEW_EDUCATE_SET_CALL_DONE then
		arg0_18.viewComponent:UpdateCallName()
	end
end

function var0_0.CheckFirstNodeExist(arg0_23, arg1_23)
	if arg1_23 == 0 then
		arg0_23.viewComponent:SeriesCheck()
	else
		arg0_23.viewComponent:OnNodeStart(arg1_23)
	end
end

function var0_0.StartNodeWithCheckDrops(arg0_24, arg1_24)
	if #arg1_24.drops == 0 then
		arg0_24.viewComponent:OnNodeStart(arg1_24.node)
	else
		arg0_24.viewComponent:emit(NewEducateBaseUI.ON_DROP, {
			items = arg1_24.drops,
			removeFunc = function()
				arg0_24.viewComponent:OnNodeStart(arg1_24.node)
			end
		})
	end
end

function var0_0.AddResultLayer(arg0_26, arg1_26)
	if #arg1_26.scheduleDrops > 0 then
		arg0_26:addSubLayers(Context.New({
			viewComponent = NewEducateScheduleResultLayer,
			mediator = NewEducateScheduleResultMediator,
			data = {
				drops = arg1_26.scheduleDrops,
				onExit = function()
					arg0_26.viewComponent:CheckFSM()
				end
			}
		}))
	else
		arg0_26.viewComponent:CheckFSM()
	end
end

return var0_0
