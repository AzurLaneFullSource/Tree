local var0_0 = class("LaunchBallTaskMgr")

var0_0.type_split = 1
var0_0.type_series_split = 2
var0_0.type_close_split = 3
var0_0.type_over_split = 4
var0_0.type_many_split = 5
var0_0.type_pass_skill = 200
var0_0.type_pass_skill_split = 201
var0_0.type_trigger_skill = 300
var0_0.type_trigger_skill_split = 301
var0_0.type_trigger_skill_split_all = 302
var0_0.type_trigger_skill_time = 303
var0_0.type_player_target_round = 400
var0_0.type_player_round = 401

function var0_0.CheckTaskUpdate(arg0_1)
	local var0_1 = arg0_1.player
	local var1_1 = LaunchBallActivityMgr.GetPlayerZhuanshuIndex(var0_1)
	local var2_1

	if var1_1 and not LaunchBallActivityMgr.CheckZhuanShuAble(ActivityConst.MINIGAME_ZUMA, var1_1) then
		return
	end

	local var3_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ZUMA_TASK):getConfig("config_client")
	local var4_1 = {}

	for iter0_1 = 1, #var3_1 do
		if var3_1[iter0_1].player == var0_1 then
			var4_1 = var3_1[iter0_1].task
		end
	end

	local var5_1 = {}

	for iter1_1 = 1, #var4_1 do
		local var6_1 = var4_1[iter1_1][1]
		local var7_1 = var4_1[iter1_1][2]
		local var8_1 = var4_1[iter1_1][3]
		local var9_1 = var4_1[iter1_1][4]
		local var10_1 = getProxy(TaskProxy):getTaskById(var7_1)

		if var10_1 and var10_1:getTaskStatus() == 0 then
			local var11_1 = 0
			local var12_1 = var10_1:getTargetNumber()
			local var13_1 = var10_1:getProgress()

			if var6_1 == var0_0.type_split and arg0_1.split_count ~= 0 then
				var11_1 = var12_1 < arg0_1.split_count + var13_1 and var12_1 or arg0_1.split_count + var13_1
			elseif var6_1 == var0_0.type_player_target_round then
				if var9_1 == arg0_1.round then
					var11_1 = var13_1 + 1
				end
			elseif var6_1 == var0_0.type_player_round then
				var11_1 = var13_1 + 1
			elseif var6_1 == var0_0.type_trigger_skill and arg0_1.use_skill ~= 0 then
				var11_1 = var13_1 + arg0_1.use_skill
			elseif var6_1 == var0_0.type_series_split and arg0_1.series_count ~= 0 then
				var11_1 = var13_1 + arg0_1.series_count
			elseif var6_1 == var0_0.type_close_split and arg0_1.mix_count ~= 0 then
				var11_1 = var13_1 + arg0_1.mix_count
			elseif var6_1 == var0_0.type_over_split and arg0_1.over_count ~= 0 then
				var11_1 = var13_1 + arg0_1.over_count
			elseif var6_1 == var0_0.type_many_split and arg0_1.many_count ~= 0 then
				var11_1 = var13_1 + arg0_1.many_count
			elseif var6_1 == var0_0.type_pass_skill and arg0_1.use_pass_skill ~= 0 then
				var11_1 = var13_1 + arg0_1.use_pass_skill
			elseif var6_1 == var0_0.type_trigger_skill_split and arg0_1.skill_count ~= 0 then
				if var8_1 <= arg0_1.skill_count then
					var11_1 = var12_1
				end
			elseif var6_1 == var0_0.type_trigger_skill_split_all and arg0_1.skill_count ~= 0 then
				var11_1 = var13_1 + arg0_1.skill_count
			elseif var6_1 == var0_0.type_pass_skill_split and arg0_1.pass_skill_count ~= 0 then
				var11_1 = var13_1 + arg0_1.pass_skill_count
			elseif var6_1 == var0_0.type_trigger_skill_time and arg0_1.double_skill_time and var8_1 >= arg0_1.double_skill_time then
				var11_1 = var12_1
			end

			if var11_1 and var11_1 ~= 0 then
				if var12_1 < var11_1 then
					var11_1 = var12_1
				end

				table.insert(var5_1, {
					id = var7_1,
					progress = var11_1
				})
			end
		end
	end

	for iter2_1 = 1, #var5_1 do
		pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
			taskId = var5_1[iter2_1].id,
			progress = var5_1[iter2_1].progress
		})
	end
end

function var0_0.GetRedTip()
	local var0_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ZUMA_TASK)

	if var0_2 and not var0_2:isEnd() then
		local var1_2 = var0_2:getConfig("config_data")
		local var2_2 = getProxy(TaskProxy)

		return underscore.any(var1_2, function(arg0_3)
			assert(var2_2:getTaskVO(arg0_3), "without this task:" .. arg0_3)

			return var2_2:getTaskVO(arg0_3):getTaskStatus() == 1
		end)
	end

	return false
end

return var0_0
