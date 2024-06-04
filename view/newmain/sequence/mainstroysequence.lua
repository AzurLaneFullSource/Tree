local var0 = class("MainStroySequence")

function var0.Execute(arg0, arg1)
	local var0 = {}

	arg0:CollectTaskStories(var0)
	arg0:CollectCommanderStories(var0)
	arg0:CollectNpcStories(var0)
	arg0:CollectPuzzlaStories(var0)
	arg0:CollectIdolStories(var0)
	arg0:CollectDOAStories(var0)
	arg0:CollectActivityStage(var0)
	arg0:Play(var0, arg1)
end

function var0.Play(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		if type(iter1) == "string" and not pg.NewStoryMgr.GetInstance():IsPlayed(iter1) then
			table.insert(var0, function(arg0)
				pg.NewStoryMgr.GetInstance():Play(iter1, arg0, true, true)
			end)
		elseif type(iter1) == "function" then
			table.insert(var0, iter1)
		end
	end

	seriesAsync(var0, arg2)
end

function var0.CollectTaskStories(arg0, arg1)
	local var0 = getProxy(TaskProxy):getRawData()

	for iter0, iter1 in pairs(var0) do
		local var1 = iter1:getConfig("story_id")

		if var1 and var1 ~= "" then
			table.insert(arg1, var1)
		end
	end
end

function var0.CollectCommanderStories(arg0, arg1)
	if ENABLE_GUIDE and getProxy(PlayerProxy):getRawData().level >= 40 then
		table.insert(arg1, "ZHIHUIMIAO1")
	end
end

function var0.CollectNpcStories(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACT_NPC_SHIP_ID)
	local var1 = getProxy(TaskProxy)

	if var0 and not var0:isEnd() then
		local var2 = var0:getConfig("config_client")

		if var2.npc then
			local var3 = var2.npc[1]
			local var4 = var2.npc[2]

			if var3 and var3 ~= "" then
				table.insert(arg1, var3)
			end

			if var4 and type(var4) == "number" then
				local function var5(arg0)
					local var0 = var1:getTaskById(var4) or var1:getFinishTaskById(var4)

					if var0 and var0:isFinish() and not var0:isReceive() then
						pg.m02:sendNotification(GAME.FETCH_NPC_SHIP, {
							taskId = var0.id,
							callback = arg0
						})
					else
						arg0()
					end
				end

				table.insert(arg1, var5)
			end
		end
	end
end

function var0.CollectPuzzlaStories(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	for iter0, iter1 in ipairs(var0) do
		if iter1 and not iter1:isEnd() then
			local var1 = iter1:getConfig("config_client")

			if type(var1) == "table" and var1[2] and type(var1[2]) == "string" then
				table.insert(arg1, var1[2])
			end
		end
	end
end

function var0.CollectIdolStories(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_CHUIXUE7DAY_ID)

	if var0 and not var0:isEnd() then
		local var1 = var0:getConfig("config_client").story[1][1]

		if var1 then
			table.insert(arg1, var1)
		end
	end
end

function var0.CollectDOAStories(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_COLLECTION_FURNITURE)

	if var0 and not var0:isEnd() and var0:getConfig("config_client").story ~= nil then
		table.insert(arg1, var0:getConfig("config_client").story)
	end
end

function var0.CollectActivityStage(arg0, arg1)
	for iter0, iter1 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)) do
		if iter1 and not iter1:isEnd() and iter1:getConfig("config_client").story ~= nil then
			table.insert(arg1, iter1:getConfig("config_client").story)
		end
	end
end

return var0
