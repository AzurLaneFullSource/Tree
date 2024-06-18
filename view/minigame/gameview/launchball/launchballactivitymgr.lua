local var0_0 = class("LaunchBallActivityMgr")

function var0_0.GetRoundCount(arg0_1)
	local var0_1 = LaunchBallActivityMgr.GetActivityById(arg0_1)

	if not var0_1 then
		return 0
	end

	if var0_1.data1 and var0_1.data1 > 0 then
		return var0_1.data1
	end

	return 0
end

function var0_0.GetRoundCountMax(arg0_2)
	local var0_2 = LaunchBallActivityMgr.GetActivityById(arg0_2)

	if not var0_2 then
		return 0
	end

	return #var0_2:getConfig("config_data")[1]
end

function var0_0.GotInvitationFlag(arg0_3)
	return LaunchBallActivityMgr.GetActivityById(arg0_3).data3 == 1
end

function var0_0.GetActivityDay(arg0_4)
	local var0_4 = LaunchBallActivityMgr.GetActivityById(arg0_4)

	if var0_4 then
		return var0_4:getDayIndex()
	end

	return 0
end

function var0_0.GetRemainCount(arg0_5)
	return LaunchBallActivityMgr.GetActivityDay(arg0_5) - LaunchBallActivityMgr.GetRoundCount(arg0_5)
end

function var0_0.IsTip(arg0_6)
	return LaunchBallActivityMgr.GetRemainCount(arg0_6) > 0
end

function var0_0.GetInvitationAble(arg0_7)
	if LaunchBallActivityMgr.GotInvitationFlag(arg0_7) then
		return false
	end

	return LaunchBallActivityMgr.GetRoundCount(arg0_7) >= LaunchBallActivityMgr.GetRoundCountMax(arg0_7)
end

function var0_0.GetInvitation(arg0_8)
	if LaunchBallActivityMgr.GetInvitationAble(arg0_8) then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = arg0_8
		})
	end
end

function var0_0.GetInvitationDropId(arg0_9)
	return LaunchBallActivityMgr.GetActivityById(arg0_9):getConfig("config_data")[6]
end

function var0_0.GetActivityById(arg0_10)
	return getProxy(ActivityProxy):getActivityById(arg0_10)
end

function var0_0.GetZhuanShuCount(arg0_11)
	local var0_11 = LaunchBallActivityMgr.GetActivityById(arg0_11)

	if not var0_11 then
		return 0
	end

	return var0_11.data1_list or {}
end

function var0_0.GetZhuanShuItems(arg0_12, arg1_12)
	local var0_12 = LaunchBallActivityMgr.GetActivityById(arg0_12)

	if not var0_12 then
		return 0
	end

	return var0_12:getConfig("config_data")[4][1][arg1_12]
end

function var0_0.IsFinishZhuanShu(arg0_13, arg1_13)
	if not LaunchBallActivityMgr.GetActivityById(arg0_13) then
		return 0
	end

	local var0_13 = LaunchBallActivityMgr.GetZhuanShuCount(arg0_13)

	return var0_13 and table.contains(var0_13, arg1_13)
end

function var0_0.CheckZhuanShuAble(arg0_14, arg1_14)
	local var0_14 = LaunchBallActivityMgr.GetZhuanShuItems(arg0_14, arg1_14)
	local var1_14

	if var0_14 then
		var1_14 = getProxy(BagProxy):getItemById(var0_14)
	end

	return var1_14 ~= nil
end

function var0_0.GetPlayerZhuanshuIndex(arg0_15)
	if arg0_15 > 1 then
		return arg0_15 - 1
	end

	return nil
end

function var0_0.GetGameScore(arg0_16, arg1_16)
	local var0_16 = LaunchBallActivityMgr.GetActivityById(arg0_16)

	if not var0_16 then
		return 0
	end

	return var0_16.data2 or 0
end

function var0_0.OpenGame(arg0_17, arg1_17)
	LaunchBallGameVo.initRoundData(arg0_17, arg1_17)
	pg.m02:sendNotification(GAME.GO_MINI_GAME, 57)
end

function var0_0.GetGameAward(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = LaunchBallActivityMgr.GetActivityById(arg0_18)

	if not var0_18 then
		return
	end

	local var1_18 = LaunchBallActivityMgr.GetRoundCount(arg0_18)
	local var2_18 = LaunchBallActivityMgr.GetActivityDay(arg0_18)
	local var3_18 = LaunchBallActivityMgr.GetRoundCountMax(arg0_18)
	local var4_18 = var0_18.data2
	local var5_18 = LaunchBallActivityMgr.GetGameScores(arg0_18)

	if arg1_18 == LaunchBallGameConst.round_type_juqing then
		if var2_18 <= var1_18 then
			print("活动天数不足")

			return
		end

		if var1_18 < var3_18 and arg2_18 <= var1_18 then
			print("已经领过剧情关奖励")

			return
		end

		if arg2_18 > var1_18 + 1 then
			print("上一关还未解锁")

			return
		end

		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_18,
			arg1 = arg1_18,
			arg2 = arg2_18,
			arg3 = math.floor(LaunchBallGameVo.gameStepTime)
		})
	elseif arg1_18 == LaunchBallGameConst.round_type_wuxian then
		if var1_18 < var3_18 then
			print("还没有完全通关剧情关卡")

			return
		end

		if arg3_18 <= var4_18 then
			print("没有超过往期的最大分数")

			return
		end

		local var6_18 = false

		for iter0_18 = 1, #var5_18 do
			if not var6_18 and arg3_18 >= var5_18[iter0_18][1] and var4_18 < var5_18[iter0_18][1] then
				var6_18 = true
			end
		end

		if var6_18 then
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = arg0_18,
				arg1 = arg1_18,
				arg2 = arg3_18,
				arg3 = math.floor(LaunchBallGameVo.gameStepTime)
			})
		end
	else
		if not LaunchBallActivityMgr.CheckZhuanShuAble(arg0_18, arg2_18) then
			print("专属关卡没有解锁")

			return
		end

		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_18,
			arg1 = arg1_18,
			arg2 = arg2_18,
			arg3 = math.floor(LaunchBallGameVo.gameStepTime)
		})
	end
end

function var0_0.GetGameScores(arg0_19)
	local var0_19 = LaunchBallActivityMgr.GetActivityById(arg0_19)

	if not var0_19 then
		return 0
	end

	return var0_19:getConfig("config_data")[5]
end

function var0_0.GetGamePtId(arg0_20)
	local var0_20 = LaunchBallActivityMgr.GetActivityById(arg0_20)

	if not var0_20 then
		return 0
	end

	return var0_20:getConfig("config_data")[2]
end

return var0_0
