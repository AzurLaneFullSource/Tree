local var0 = class("LaunchBallActivityMgr")

function var0.GetRoundCount(arg0)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if not var0 then
		return 0
	end

	if var0.data1 and var0.data1 > 0 then
		return var0.data1
	end

	return 0
end

function var0.GetRoundCountMax(arg0)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if not var0 then
		return 0
	end

	return #var0:getConfig("config_data")[1]
end

function var0.GotInvitationFlag(arg0)
	return LaunchBallActivityMgr.GetActivityById(arg0).data3 == 1
end

function var0.GetActivityDay(arg0)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if var0 then
		return var0:getDayIndex()
	end

	return 0
end

function var0.GetRemainCount(arg0)
	return LaunchBallActivityMgr.GetActivityDay(arg0) - LaunchBallActivityMgr.GetRoundCount(arg0)
end

function var0.IsTip(arg0)
	return LaunchBallActivityMgr.GetRemainCount(arg0) > 0
end

function var0.GetInvitationAble(arg0)
	if LaunchBallActivityMgr.GotInvitationFlag(arg0) then
		return false
	end

	return LaunchBallActivityMgr.GetRoundCount(arg0) >= LaunchBallActivityMgr.GetRoundCountMax(arg0)
end

function var0.GetInvitation(arg0)
	if LaunchBallActivityMgr.GetInvitationAble(arg0) then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = arg0
		})
	end
end

function var0.GetInvitationDropId(arg0)
	return LaunchBallActivityMgr.GetActivityById(arg0):getConfig("config_data")[6]
end

function var0.GetActivityById(arg0)
	return getProxy(ActivityProxy):getActivityById(arg0)
end

function var0.GetZhuanShuCount(arg0)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if not var0 then
		return 0
	end

	return var0.data1_list or {}
end

function var0.GetZhuanShuItems(arg0, arg1)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if not var0 then
		return 0
	end

	return var0:getConfig("config_data")[4][1][arg1]
end

function var0.IsFinishZhuanShu(arg0, arg1)
	if not LaunchBallActivityMgr.GetActivityById(arg0) then
		return 0
	end

	local var0 = LaunchBallActivityMgr.GetZhuanShuCount(arg0)

	return var0 and table.contains(var0, arg1)
end

function var0.CheckZhuanShuAble(arg0, arg1)
	local var0 = LaunchBallActivityMgr.GetZhuanShuItems(arg0, arg1)
	local var1

	if var0 then
		var1 = getProxy(BagProxy):getItemById(var0)
	end

	return var1 ~= nil
end

function var0.GetPlayerZhuanshuIndex(arg0)
	if arg0 > 1 then
		return arg0 - 1
	end

	return nil
end

function var0.GetGameScore(arg0, arg1)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if not var0 then
		return 0
	end

	return var0.data2 or 0
end

function var0.OpenGame(arg0, arg1)
	LaunchBallGameVo.initRoundData(arg0, arg1)
	pg.m02:sendNotification(GAME.GO_MINI_GAME, 57)
end

function var0.GetGameAward(arg0, arg1, arg2, arg3)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if not var0 then
		return
	end

	local var1 = LaunchBallActivityMgr.GetRoundCount(arg0)
	local var2 = LaunchBallActivityMgr.GetActivityDay(arg0)
	local var3 = LaunchBallActivityMgr.GetRoundCountMax(arg0)
	local var4 = var0.data2
	local var5 = LaunchBallActivityMgr.GetGameScores(arg0)

	if arg1 == LaunchBallGameConst.round_type_juqing then
		if var2 <= var1 then
			print("活动天数不足")

			return
		end

		if var1 < var3 and arg2 <= var1 then
			print("已经领过剧情关奖励")

			return
		end

		if arg2 > var1 + 1 then
			print("上一关还未解锁")

			return
		end

		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0,
			arg1 = arg1,
			arg2 = arg2,
			arg3 = math.floor(LaunchBallGameVo.gameStepTime)
		})
	elseif arg1 == LaunchBallGameConst.round_type_wuxian then
		if var1 < var3 then
			print("还没有完全通关剧情关卡")

			return
		end

		if arg3 <= var4 then
			print("没有超过往期的最大分数")

			return
		end

		local var6 = false

		for iter0 = 1, #var5 do
			if not var6 and arg3 >= var5[iter0][1] and var4 < var5[iter0][1] then
				var6 = true
			end
		end

		if var6 then
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg0,
				arg1 = arg1,
				arg2 = arg3,
				arg3 = math.floor(LaunchBallGameVo.gameStepTime)
			})
		end
	else
		if not LaunchBallActivityMgr.CheckZhuanShuAble(arg0, arg2) then
			print("专属关卡没有解锁")

			return
		end

		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0,
			arg1 = arg1,
			arg2 = arg2,
			arg3 = math.floor(LaunchBallGameVo.gameStepTime)
		})
	end
end

function var0.GetGameScores(arg0)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if not var0 then
		return 0
	end

	return var0:getConfig("config_data")[5]
end

function var0.GetGamePtId(arg0)
	local var0 = LaunchBallActivityMgr.GetActivityById(arg0)

	if not var0 then
		return 0
	end

	return var0:getConfig("config_data")[2]
end

return var0
