local var0 = class("VoteMediator", import("..base.ContextMediator"))

var0.ON_VOTE = "VoteMediator:ON_VOTE"
var0.ON_FILTER = "VoteMediator:ON_FILTER"
var0.ON_SCHEDULE = "VoteMediator:ON_SCHEDULE"
var0.OPEN_EXCHANGE = "VoteMediator:OPEN_EXCHANGE"

function var0.register(arg0)
	arg0:bind(var0.ON_VOTE, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.ON_NEW_VOTE, {
			voteId = arg1,
			gid = arg2,
			count = arg3
		})
	end)
	arg0:bind(var0.ON_FILTER, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(var0.ON_SCHEDULE, function()
		arg0:addSubLayers(Context.New({
			mediator = VoteScheduleMediator,
			viewComponent = VoteScheduleScene
		}))
	end)
	arg0:bind(var0.OPEN_EXCHANGE, function()
		local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup()

		if not var0 then
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
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ON_NEW_VOTE_DONE,
		GAME.ACT_NEW_PT_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ON_NEW_VOTE_DONE then
		arg0.viewComponent:updateMainview(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("vote_success"))
		arg0:DisplayAwards(var1.awards)
	elseif var0 == GAME.ACT_NEW_PT_DONE then
		arg0:DisplayAwards(var1.awards)
	end
end

function var0.DisplayAwards(arg0, arg1)
	local var0

	local function var1()
		if #arg0.cache <= 0 then
			return
		end

		local var0 = arg0.cache[1]

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, function()
			table.remove(arg0.cache, 1)
			var1()
		end)
	end

	if not arg0.cache then
		arg0.cache = {}
	end

	table.insert(arg0.cache, arg1)

	if #arg0.cache == 1 then
		var1()
	end
end

return var0
