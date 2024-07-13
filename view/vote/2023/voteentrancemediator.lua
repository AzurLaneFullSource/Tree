local var0_0 = class("VoteEntranceMediator", import("view.base.ContextMediator"))

var0_0.ON_VOTE = "VoteEntranceMediator:ON_VOTE"
var0_0.ON_FUN_VOTE = "VoteEntranceMediator:ON_FUN_VOTE"
var0_0.ON_EXCHANGE = "VoteEntranceMediator:ON_EXCHANGE"
var0_0.ON_SCHEDULE = "VoteEntranceMediator:ON_SCHEDULE"
var0_0.GO_HALL = "VoteEntranceMediator:GO_HALL"
var0_0.SUBMIT_TASK = "VoteEntranceMediator:SUBMIT_TASK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SUBMIT_TASK, function()
		local var0_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

		if not var0_2 or var0_2:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))

			return
		end

		local var1_2 = var0_2:getConfig("config_client")[2]

		arg0_1:sendNotification(GAME.SUBMIT_TASK, var1_2)
	end)
	arg0_1:bind(var0_0.ON_VOTE, function()
		local var0_3 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

		if not var0_3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_tip_area_closed"))

			return
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.VOTE, {
			voteGroup = var0_3
		})
	end)
	arg0_1:bind(var0_0.ON_FUN_VOTE, function()
		local var0_4 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

		if not var0_4 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_tip_area_closed"))

			return
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.VOTE, {
			voteGroup = var0_4
		})
	end)
	arg0_1:bind(var0_0.ON_EXCHANGE, function()
		local var0_5 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

		if not var0_5 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))

			return
		end

		arg0_1:addSubLayers(Context.New({
			mediator = VoteExchangeMediator,
			viewComponent = VoteExchangeScene,
			data = {
				voteGroup = var0_5
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_SCHEDULE, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.VOTESCHEDULE)
	end)
	arg0_1:bind(var0_0.GO_HALL, function()
		arg0_1:addSubLayers(Context.New({
			mediator = VoteFameHallMediator,
			viewComponent = VoteFameHallLayer
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.SUBMIT_TASK_DONE,
		GAME.ON_NEW_VOTE_DONE,
		GAME.STORY_END
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.SUBMIT_TASK_DONE then
		arg0_9.viewComponent:UpdateHonorTip()
		arg0_9.viewComponent:UpdateMainAward()
		arg0_9.viewComponent:UpdateMainStageTip()
		arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9, nil)
	elseif var0_9 == GAME.ON_NEW_VOTE_DONE then
		arg0_9.viewComponent:UpdateVotes()
		arg0_9.viewComponent:UpdateMainStageTip()
		arg0_9.viewComponent:UpdateSubStageTip()
	elseif var0_9 == GAME.STORY_END then
		arg0_9.viewComponent:FlushAll()
	end
end

return var0_0
