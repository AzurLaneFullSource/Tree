local var0_0 = class("MainStroySequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = {}

	arg0_1:CollectTaskStories(var0_1)
	arg0_1:CollectCommanderStories(var0_1)
	arg0_1:CollectNpcStories(var0_1)
	arg0_1:CollectPuzzlaStories(var0_1)
	arg0_1:CollectIdolStories(var0_1)
	arg0_1:CollectDOAStories(var0_1)
	arg0_1:CollectActivityStage(var0_1)
	arg0_1:Play(var0_1, arg1_1)
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		if type(iter1_2) == "string" and not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_2) then
			table.insert(var0_2, function(arg0_3)
				pg.NewStoryMgr.GetInstance():Play(iter1_2, arg0_3, true, true)
			end)
		elseif type(iter1_2) == "function" then
			table.insert(var0_2, iter1_2)
		end
	end

	seriesAsync(var0_2, arg2_2)
end

function var0_0.CollectTaskStories(arg0_4, arg1_4)
	local var0_4 = getProxy(TaskProxy):getRawData()

	for iter0_4, iter1_4 in pairs(var0_4) do
		local var1_4 = iter1_4:getConfig("story_id")

		if var1_4 and var1_4 ~= "" then
			table.insert(arg1_4, var1_4)
		end
	end
end

function var0_0.CollectCommanderStories(arg0_5, arg1_5)
	if ENABLE_GUIDE and getProxy(PlayerProxy):getRawData().level >= 40 then
		table.insert(arg1_5, "ZHIHUIMIAO1")
	end
end

function var0_0.CollectNpcStories(arg0_6, arg1_6)
	local var0_6 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACT_NPC_SHIP_ID)
	local var1_6 = getProxy(TaskProxy)

	if var0_6 and not var0_6:isEnd() then
		local var2_6 = var0_6:getConfig("config_client")

		if var2_6.npc then
			local var3_6 = var2_6.npc[1]
			local var4_6 = var2_6.npc[2]

			if var3_6 and var3_6 ~= "" then
				table.insert(arg1_6, var3_6)
			end

			if var4_6 and type(var4_6) == "number" then
				local function var5_6(arg0_7)
					local var0_7 = var1_6:getTaskById(var4_6) or var1_6:getFinishTaskById(var4_6)

					if var0_7 and var0_7:isFinish() and not var0_7:isReceive() then
						pg.m02:sendNotification(GAME.FETCH_NPC_SHIP, {
							taskId = var0_7.id,
							callback = arg0_7
						})
					else
						arg0_7()
					end
				end

				table.insert(arg1_6, var5_6)
			end
		end
	end
end

function var0_0.CollectPuzzlaStories(arg0_8, arg1_8)
	local var0_8 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	for iter0_8, iter1_8 in ipairs(var0_8) do
		if iter1_8 and not iter1_8:isEnd() then
			local var1_8 = iter1_8:getConfig("config_client")

			if type(var1_8) == "table" and var1_8[2] and type(var1_8[2]) == "string" then
				table.insert(arg1_8, var1_8[2])
			end
		end
	end
end

function var0_0.CollectIdolStories(arg0_9, arg1_9)
	local var0_9 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_CHUIXUE7DAY_ID)

	if var0_9 and not var0_9:isEnd() then
		local var1_9 = var0_9:getConfig("config_client").story[1][1]

		if var1_9 then
			table.insert(arg1_9, var1_9)
		end
	end
end

function var0_0.CollectDOAStories(arg0_10, arg1_10)
	local var0_10 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_COLLECTION_FURNITURE)

	if var0_10 and not var0_10:isEnd() and var0_10:getConfig("config_client").story ~= nil then
		table.insert(arg1_10, var0_10:getConfig("config_client").story)
	end
end

function var0_0.CollectActivityStage(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)) do
		if iter1_11 and not iter1_11:isEnd() and iter1_11:getConfig("config_client").story ~= nil then
			table.insert(arg1_11, iter1_11:getConfig("config_client").story)
		end
	end
end

return var0_0
