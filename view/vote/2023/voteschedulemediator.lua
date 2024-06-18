local var0_0 = class("VoteScheduleMediator", import("view.base.ContextMediator"))

var0_0.GO_RANK = "VoteScheduleMediator:GO_RANK"
var0_0.FETCH_RANK = "VoteScheduleMediator:FETCH_RANK"
var0_0.ON_VOTE = "VoteScheduleMediator:ON_VOTE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_VOTE, function()
		local var0_2 = getProxy(VoteProxy):GetOpeningNonFunVoteGroup() or getProxy(VoteProxy):GetOpeningFunVoteGroup()

		if not var0_2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))

			return
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.VOTE, {
			voteGroup = var0_2
		})
	end)
	arg0_1:bind(var0_0.FETCH_RANK, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.FETCH_VOTE_RANK, {
			voteId = arg1_3,
			callback = arg2_3
		})
	end)
	arg0_1:bind(var0_0.GO_RANK, function(arg0_4, arg1_4)
		seriesAsync({
			function(arg0_5)
				arg0_1:CheckPaintingRes(arg1_4, arg0_5)
			end
		}, function()
			arg0_1:addSubLayers(Context.New({
				mediator = ContextMediator,
				viewComponent = VoteRankScene,
				data = {
					voteGroup = arg1_4
				}
			}))
		end)
	end)
end

function var0_0.CheckPaintingRes(arg0_7, arg1_7, arg2_7)
	if arg1_7 and arg1_7:isFinalsRace() or arg1_7:IsFunRace() then
		local var0_7 = arg1_7:GetRankList()
		local var1_7 = var0_7[1]
		local var2_7 = var0_7[2]
		local var3_7 = var0_7[3]
		local var4_7 = var1_7:getPainting()
		local var5_7 = var2_7:getPainting()
		local var6_7 = var3_7:getPainting()
		local var7_7 = {
			var4_7,
			var5_7,
			var6_7
		}
		local var8_7 = {}

		for iter0_7, iter1_7 in ipairs(var7_7) do
			PaintingGroupConst.AddPaintingNameWithFilteMap(var8_7, iter1_7)
		end

		PaintingGroupConst.PaintingDownload({
			isShowBox = true,
			paintingNameList = var8_7,
			finishFunc = arg2_7
		})
	else
		arg2_7()
	end
end

function var0_0.listNotificationInterests(arg0_8)
	return {}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()
end

return var0_0
