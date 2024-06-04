local var0 = class("BillboardMediator", import("..base.ContextMediator"))

var0.FETCH_RANKS = "BillboardMediator:FETCH_RANKS"
var0.OPEN_RIVAL_INFO = "BillboardMediator:OPEN_RIVAL_INFO"

function var0.register(arg0)
	local var0 = getProxy(BillboardProxy)
	local var1 = arg0.contextData.page or PowerRank.TYPE_POWER
	local var2 = arg0.contextData.act_id or checkExist(PowerRank:getActivityByRankType(var1), {
		"id"
	})
	local var3 = var0:getRankList(var1, var2)
	local var4 = var0:getPlayerRankData(var1, var2)

	arg0.viewComponent:updateRankList(var1, var3, var4, var2)
	arg0:bind(var0.FETCH_RANKS, function(arg0, arg1, arg2)
		if var0:canFetch(arg1, arg2) then
			arg0:sendNotification(GAME.GET_POWERRANK, {
				type = arg1,
				activityId = arg2
			})
		else
			local var0 = var0:getRankList(arg1, arg2)
			local var1 = var0:getPlayerRankData(arg1, arg2)

			arg0.viewComponent:updateRankList(arg1, var0, var1, arg2)
			arg0.viewComponent:filter(arg1, arg2)
		end
	end)
	arg0:bind(var0.OPEN_RIVAL_INFO, function(arg0, arg1)
		arg0:sendNotification(GAME.GET_RIVAL_INFO, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.GET_POWERRANK_DONE,
		GAME.GET_RIVAL_INFO_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.GET_POWERRANK_DONE then
		arg0.viewComponent:updateRankList(var1.type, var1.list, var1.playerRankinfo, var1.activityId)
		arg0.viewComponent:filter(var1.type, var1.activityId)
	elseif var0 == GAME.GET_RIVAL_INFO_DONE then
		arg0:addSubLayers(Context.New({
			viewComponent = RivalInfoLayer,
			mediator = RivalInfoMediator,
			data = {
				rival = var1.rival,
				type = RivalInfoLayer.TYPE_DISPLAY
			}
		}))
	end
end

return var0
