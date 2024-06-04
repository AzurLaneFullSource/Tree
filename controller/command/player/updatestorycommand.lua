local var0 = class("UpdateStoryCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().storyId

	assert(type(var0) == "string")

	if not pg.ConnectionMgr.GetInstance():getConnection() or not pg.ConnectionMgr.GetInstance():isConnected() then
		return
	end

	if not getProxy(PlayerProxy) then
		return
	end

	local var1 = pg.NewStoryMgr.GetInstance()
	local var2 = {}

	local function var3(arg0, arg1)
		pg.ConnectionMgr.GetInstance():Send(11017, {
			story_id = arg0
		}, 11018, function(arg0)
			var1:SetPlayedFlag(arg0)

			local var0 = PlayerConst.addTranDrop(arg0.drop_list)

			table.insertto(var2, var0)

			if arg1 then
				arg1()
			end
		end)
	end

	local function var4(arg0, arg1)
		local var0, var1 = var1:StoryName2StoryId(arg0)
		local var2 = {}

		if var0 and var0 > 0 and not var1:GetPlayedFlag(var0) then
			table.insert(var2, function(arg0)
				var3(var0, arg0)
			end)
		end

		if var1 and var1 > 0 and not var1:GetPlayedFlag(var1) then
			table.insert(var2, function(arg0)
				var3(var1, arg0)
			end)
		end

		parallelAsync(var2, arg1)
	end

	local var5 = var1:StoryLinkNames(var0) or {}

	table.insert(var5, var0)

	local var6 = {}

	for iter0, iter1 in ipairs(var5) do
		table.insert(var6, function(arg0)
			var4(iter1, arg0)
		end)
	end

	seriesAsync(var6, function()
		arg0:sendNotification(GAME.STORY_UPDATE_DONE, {
			storyName = var0,
			awards = var2
		})
	end)
end

return var0
