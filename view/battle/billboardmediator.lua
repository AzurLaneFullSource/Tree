local var0_0 = class("BillboardMediator", import("..base.ContextMediator"))

var0_0.FETCH_RANKS = "BillboardMediator:FETCH_RANKS"
var0_0.OPEN_RIVAL_INFO = "BillboardMediator:OPEN_RIVAL_INFO"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(BillboardProxy)
	local var1_1 = arg0_1.contextData.page or PowerRank.TYPE_POWER
	local var2_1 = arg0_1.contextData.act_id or checkExist(PowerRank:getActivityByRankType(var1_1), {
		"id"
	})
	local var3_1 = var0_1:getRankList(var1_1, var2_1)
	local var4_1 = var0_1:getPlayerRankData(var1_1, var2_1)

	arg0_1.viewComponent:updateRankList(var1_1, var3_1, var4_1, var2_1)
	arg0_1:bind(var0_0.FETCH_RANKS, function(arg0_2, arg1_2, arg2_2)
		if var0_1:canFetch(arg1_2, arg2_2) then
			arg0_1:sendNotification(GAME.GET_POWERRANK, {
				type = arg1_2,
				activityId = arg2_2
			})
		else
			local var0_2 = var0_1:getRankList(arg1_2, arg2_2)
			local var1_2 = var0_1:getPlayerRankData(arg1_2, arg2_2)

			arg0_1.viewComponent:updateRankList(arg1_2, var0_2, var1_2, arg2_2)
			arg0_1.viewComponent:filter(arg1_2, arg2_2)
		end
	end)
	arg0_1:bind(var0_0.OPEN_RIVAL_INFO, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.GET_RIVAL_INFO, arg1_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.GET_POWERRANK_DONE,
		GAME.GET_RIVAL_INFO_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.GET_POWERRANK_DONE then
		arg0_5.viewComponent:updateRankList(var1_5.type, var1_5.list, var1_5.playerRankinfo, var1_5.activityId)
		arg0_5.viewComponent:filter(var1_5.type, var1_5.activityId)
	elseif var0_5 == GAME.GET_RIVAL_INFO_DONE then
		arg0_5:addSubLayers(Context.New({
			viewComponent = RivalInfoLayer,
			mediator = RivalInfoMediator,
			data = {
				rival = var1_5.rival,
				type = RivalInfoLayer.TYPE_DISPLAY
			}
		}))
	end
end

return var0_0
