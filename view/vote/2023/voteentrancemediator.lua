local var0 = class("VoteEntranceMediator", import("view.base.ContextMediator"))

var0.ON_VOTE = "VoteEntranceMediator:ON_VOTE"
var0.ON_FUN_VOTE = "VoteEntranceMediator:ON_FUN_VOTE"
var0.ON_EXCHANGE = "VoteEntranceMediator:ON_EXCHANGE"
var0.ON_SCHEDULE = "VoteEntranceMediator:ON_SCHEDULE"
var0.GO_HALL = "VoteEntranceMediator:GO_HALL"
var0.SUBMIT_TASK = "VoteEntranceMediator:SUBMIT_TASK"

function var0.register(arg0)
	arg0:bind(var0.SUBMIT_TASK, function()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))

			return
		end

		local var1 = var0:getConfig("config_client")[2]

		arg0:sendNotification(GAME.SUBMIT_TASK, var1)
	end)
	arg0:bind(var0.ON_VOTE, function()
		local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_tip_area_closed"))

			return
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.VOTE, {
			voteGroup = var0
		})
	end)
	arg0:bind(var0.ON_FUN_VOTE, function()
		local var0 = getProxy(VoteProxy):GetOpeningFunVoteGroup()

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_tip_area_closed"))

			return
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.VOTE, {
			voteGroup = var0
		})
	end)
	arg0:bind(var0.ON_EXCHANGE, function()
		local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))

			return
		end

		arg0:addSubLayers(Context.New({
			mediator = VoteExchangeMediator,
			viewComponent = VoteExchangeScene,
			data = {
				voteGroup = var0
			}
		}))
	end)
	arg0:bind(var0.ON_SCHEDULE, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.VOTESCHEDULE)
	end)
	arg0:bind(var0.GO_HALL, function()
		arg0:addSubLayers(Context.New({
			mediator = VoteFameHallMediator,
			viewComponent = VoteFameHallLayer
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_TASK_DONE,
		GAME.ON_NEW_VOTE_DONE,
		GAME.STORY_END
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:UpdateHonorTip()
		arg0.viewComponent:UpdateMainAward()
		arg0.viewComponent:UpdateMainStageTip()
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, nil)
	elseif var0 == GAME.ON_NEW_VOTE_DONE then
		arg0.viewComponent:UpdateVotes()
		arg0.viewComponent:UpdateMainStageTip()
		arg0.viewComponent:UpdateSubStageTip()
	elseif var0 == GAME.STORY_END then
		arg0.viewComponent:FlushAll()
	end
end

return var0
