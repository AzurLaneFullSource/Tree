local var0_0 = class("UpdateStoryCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.storyId
	local var2_1 = var0_1.callback

	assert(type(var1_1) == "string")

	if not pg.ConnectionMgr.GetInstance():getConnection() or not pg.ConnectionMgr.GetInstance():isConnected() then
		return
	end

	if not getProxy(PlayerProxy) then
		return
	end

	local var3_1 = pg.NewStoryMgr.GetInstance()
	local var4_1 = {}

	local function var5_1(arg0_2, arg1_2)
		pg.ConnectionMgr.GetInstance():Send(11017, {
			story_id = arg0_2
		}, 11018, function(arg0_3)
			var3_1:SetPlayedFlag(arg0_2)

			local var0_3 = PlayerConst.addTranDrop(arg0_3.drop_list)

			table.insertto(var4_1, var0_3)

			if arg1_2 then
				arg1_2()
			end
		end)
	end

	local function var6_1(arg0_4, arg1_4)
		local var0_4, var1_4 = var3_1:StoryName2StoryId(arg0_4)
		local var2_4 = {}

		if var0_4 and var0_4 > 0 and not var3_1:GetPlayedFlag(var0_4) then
			table.insert(var2_4, function(arg0_5)
				var5_1(var0_4, arg0_5)
			end)
		end

		if var1_4 and var1_4 > 0 and not var3_1:GetPlayedFlag(var1_4) then
			table.insert(var2_4, function(arg0_6)
				var5_1(var1_4, arg0_6)
			end)
		end

		parallelAsync(var2_4, arg1_4)
	end

	local var7_1 = var3_1:StoryLinkNames(var1_1) or {}

	table.insert(var7_1, var1_1)

	local var8_1 = {}

	for iter0_1, iter1_1 in ipairs(var7_1) do
		table.insert(var8_1, function(arg0_7)
			var6_1(iter1_1, arg0_7)
		end)
	end

	seriesAsync(var8_1, function()
		existCall(var2_1)
		arg0_1:sendNotification(GAME.STORY_UPDATE_DONE, {
			storyName = var1_1,
			awards = var4_1
		})
	end)
end

return var0_0
