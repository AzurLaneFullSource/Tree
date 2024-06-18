local var0_0 = class("VoteMediator", import("..base.ContextMediator"))

var0_0.ON_VOTE = "VoteMediator:ON_VOTE"
var0_0.ON_FILTER = "VoteMediator:ON_FILTER"
var0_0.ON_SCHEDULE = "VoteMediator:ON_SCHEDULE"
var0_0.OPEN_EXCHANGE = "VoteMediator:OPEN_EXCHANGE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_VOTE, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.ON_NEW_VOTE, {
			voteId = arg1_2,
			gid = arg2_2,
			count = arg3_2
		})
	end)
	arg0_1:bind(var0_0.ON_FILTER, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_3
		}))
	end)
	arg0_1:bind(var0_0.ON_SCHEDULE, function()
		arg0_1:addSubLayers(Context.New({
			mediator = VoteScheduleMediator,
			viewComponent = VoteScheduleScene
		}))
	end)
	arg0_1:bind(var0_0.OPEN_EXCHANGE, function()
		local var0_5 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

		if not var0_5 then
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
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.ON_NEW_VOTE_DONE,
		GAME.ACT_NEW_PT_DONE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.ON_NEW_VOTE_DONE then
		arg0_7.viewComponent:updateMainview(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("vote_success"))
		arg0_7:DisplayAwards(var1_7.awards)
	elseif var0_7 == GAME.ACT_NEW_PT_DONE then
		arg0_7:DisplayAwards(var1_7.awards)
	end
end

function var0_0.DisplayAwards(arg0_8, arg1_8)
	local var0_8

	local function var1_8()
		if #arg0_8.cache <= 0 then
			return
		end

		local var0_9 = arg0_8.cache[1]

		arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_9, function()
			table.remove(arg0_8.cache, 1)
			var1_8()
		end)
	end

	if not arg0_8.cache then
		arg0_8.cache = {}
	end

	table.insert(arg0_8.cache, arg1_8)

	if #arg0_8.cache == 1 then
		var1_8()
	end
end

return var0_0
