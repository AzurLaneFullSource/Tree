local var0 = class("LaunchBallTaskMgr")

var0.type_split = 1
var0.type_series_split = 2
var0.type_close_split = 3
var0.type_over_split = 4
var0.type_many_split = 5
var0.type_pass_skill = 200
var0.type_pass_skill_split = 201
var0.type_trigger_skill = 300
var0.type_trigger_skill_split = 301
var0.type_trigger_skill_split_all = 302
var0.type_trigger_skill_time = 303
var0.type_player_target_round = 400
var0.type_player_round = 401

function var0.CheckTaskUpdate(arg0)
	local var0 = arg0.player
	local var1 = LaunchBallActivityMgr.GetPlayerZhuanshuIndex(var0)
	local var2

	if var1 and not LaunchBallActivityMgr.CheckZhuanShuAble(ActivityConst.MINIGAME_ZUMA, var1) then
		return
	end

	local var3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ZUMA_TASK):getConfig("config_client")
	local var4 = {}

	for iter0 = 1, #var3 do
		if var3[iter0].player == var0 then
			var4 = var3[iter0].task
		end
	end

	local var5 = {}

	for iter1 = 1, #var4 do
		local var6 = var4[iter1][1]
		local var7 = var4[iter1][2]
		local var8 = var4[iter1][3]
		local var9 = var4[iter1][4]
		local var10 = getProxy(TaskProxy):getTaskById(var7)

		if var10 and var10:getTaskStatus() == 0 then
			local var11 = 0
			local var12 = var10:getTargetNumber()
			local var13 = var10:getProgress()

			if var6 == var0.type_split and arg0.split_count ~= 0 then
				var11 = var12 < arg0.split_count + var13 and var12 or arg0.split_count + var13
			elseif var6 == var0.type_player_target_round then
				if var9 == arg0.round then
					var11 = var13 + 1
				end
			elseif var6 == var0.type_player_round then
				var11 = var13 + 1
			elseif var6 == var0.type_trigger_skill and arg0.use_skill ~= 0 then
				var11 = var13 + arg0.use_skill
			elseif var6 == var0.type_series_split and arg0.series_count ~= 0 then
				var11 = var13 + arg0.series_count
			elseif var6 == var0.type_close_split and arg0.mix_count ~= 0 then
				var11 = var13 + arg0.mix_count
			elseif var6 == var0.type_over_split and arg0.over_count ~= 0 then
				var11 = var13 + arg0.over_count
			elseif var6 == var0.type_many_split and arg0.many_count ~= 0 then
				var11 = var13 + arg0.many_count
			elseif var6 == var0.type_pass_skill and arg0.use_pass_skill ~= 0 then
				var11 = var13 + arg0.use_pass_skill
			elseif var6 == var0.type_trigger_skill_split and arg0.skill_count ~= 0 then
				if var8 <= arg0.skill_count then
					var11 = var12
				end
			elseif var6 == var0.type_trigger_skill_split_all and arg0.skill_count ~= 0 then
				var11 = var13 + arg0.skill_count
			elseif var6 == var0.type_pass_skill_split and arg0.pass_skill_count ~= 0 then
				var11 = var13 + arg0.pass_skill_count
			elseif var6 == var0.type_trigger_skill_time and arg0.double_skill_time and var8 >= arg0.double_skill_time then
				var11 = var12
			end

			if var11 and var11 ~= 0 then
				if var12 < var11 then
					var11 = var12
				end

				table.insert(var5, {
					id = var7,
					progress = var11
				})
			end
		end
	end

	for iter2 = 1, #var5 do
		pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
			taskId = var5[iter2].id,
			progress = var5[iter2].progress
		})
	end
end

function var0.GetRedTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ZUMA_TASK)

	if var0 and not var0:isEnd() then
		local var1 = var0:getConfig("config_data")
		local var2 = getProxy(TaskProxy)

		return underscore.any(var1, function(arg0)
			assert(var2:getTaskVO(arg0), "without this task:" .. arg0)

			return var2:getTaskVO(arg0):getTaskStatus() == 1
		end)
	end

	return false
end

return var0
