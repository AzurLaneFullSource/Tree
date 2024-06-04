local var0 = class("VoteScheduleMediator", import("view.base.ContextMediator"))

var0.GO_RANK = "VoteScheduleMediator:GO_RANK"
var0.FETCH_RANK = "VoteScheduleMediator:FETCH_RANK"
var0.ON_VOTE = "VoteScheduleMediator:ON_VOTE"

function var0.register(arg0)
	arg0:bind(var0.ON_VOTE, function()
		local var0 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup() or getProxy(VoteProxy):GetOpeningFunVoteGroup()

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))

			return
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.VOTE, {
			voteGroup = var0
		})
	end)
	arg0:bind(var0.FETCH_RANK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.FETCH_VOTE_RANK, {
			voteId = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.GO_RANK, function(arg0, arg1)
		seriesAsync({
			function(arg0)
				arg0:CheckPaintingRes(arg1, arg0)
			end
		}, function()
			arg0:addSubLayers(Context.New({
				mediator = ContextMediator,
				viewComponent = VoteRankScene,
				data = {
					voteGroup = arg1
				}
			}))
		end)
	end)
end

function var0.CheckPaintingRes(arg0, arg1, arg2)
	if arg1 and arg1:isFinalsRace() or arg1:IsFunRace() then
		local var0 = arg1:GetRankList()
		local var1 = var0[1]
		local var2 = var0[2]
		local var3 = var0[3]
		local var4 = var1:getPainting()
		local var5 = var2:getPainting()
		local var6 = var3:getPainting()
		local var7 = {
			var4,
			var5,
			var6
		}
		local var8 = {}

		for iter0, iter1 in ipairs(var7) do
			PaintingGroupConst.AddPaintingNameWithFilteMap(var8, iter1)
		end

		PaintingGroupConst.PaintingDownload({
			isShowBox = true,
			paintingNameList = var8,
			finishFunc = arg2
		})
	else
		arg2()
	end
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
