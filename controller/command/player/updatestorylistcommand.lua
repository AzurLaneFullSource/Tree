local var0_0 = class("UpdateStoryListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.storyIds
	local var2_1 = var0_1.callback

	if not pg.ConnectionMgr.GetInstance():getConnection() or not pg.ConnectionMgr.GetInstance():isConnected() then
		return
	end

	if not getProxy(PlayerProxy) then
		return
	end

	local var3_1 = pg.NewStoryMgr.GetInstance()
	local var4_1 = {}

	for iter0_1, iter1_1 in ipairs(var1_1) do
		if not var3_1:GetPlayedFlag(iter1_1) then
			table.insert(var4_1, iter1_1)
		end
	end

	if #var4_1 == 0 then
		existCall(var2_1)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11032, {
		story_ids = var4_1
	}, 11033, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:SetPlayedFlagList(var4_1)
			existCall(var2_1)
			arg0_1:sendNotification(GAME.STORY_UPDATE_LIST_DONE, {
				storyIds = var4_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
