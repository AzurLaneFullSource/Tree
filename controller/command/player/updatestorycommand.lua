local var0_0 = class("UpdateStoryCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().storyId

	assert(type(var0_1) == "string")

	if not pg.ConnectionMgr.GetInstance():getConnection() or not pg.ConnectionMgr.GetInstance():isConnected() then
		return
	end

	if not getProxy(PlayerProxy) then
		return
	end

	local var1_1 = pg.NewStoryMgr.GetInstance()
	local var2_1 = {}

	local function var3_1(arg0_2, arg1_2)
		pg.ConnectionMgr.GetInstance():Send(11017, {
			story_id = arg0_2
		}, 11018, function(arg0_3)
			var1_1:SetPlayedFlag(arg0_2)

			local var0_3 = PlayerConst.addTranDrop(arg0_3.drop_list)

			table.insertto(var2_1, var0_3)

			if arg1_2 then
				arg1_2()
			end
		end)
	end

	local function var4_1(arg0_4, arg1_4)
		local var0_4, var1_4 = var1_1:StoryName2StoryId(arg0_4)
		local var2_4 = {}

		if var0_4 and var0_4 > 0 and not var1_1:GetPlayedFlag(var0_4) then
			table.insert(var2_4, function(arg0_5)
				var3_1(var0_4, arg0_5)
			end)
		end

		if var1_4 and var1_4 > 0 and not var1_1:GetPlayedFlag(var1_4) then
			table.insert(var2_4, function(arg0_6)
				var3_1(var1_4, arg0_6)
			end)
		end

		parallelAsync(var2_4, arg1_4)
	end

	local var5_1 = var1_1:StoryLinkNames(var0_1) or {}

	table.insert(var5_1, var0_1)

	local var6_1 = {}

	for iter0_1, iter1_1 in ipairs(var5_1) do
		table.insert(var6_1, function(arg0_7)
			var4_1(iter1_1, arg0_7)
		end)
	end

	seriesAsync(var6_1, function()
		arg0_1:sendNotification(GAME.STORY_UPDATE_DONE, {
			storyName = var0_1,
			awards = var2_1
		})
	end)
end

return var0_0
