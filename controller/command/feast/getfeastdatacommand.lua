local var0_0 = class("GetFeastDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.activityId

	pg.ConnectionMgr.GetInstance():Send(26156, {
		act_id = var2_1
	}, 26157, function(arg0_2)
		if arg0_2.ret == 0 then
			local var0_2 = FeastDorm.New({
				id = 4
			}, arg0_2)

			arg0_1:FixStoryList(var0_2)
			getProxy(FeastProxy):SetData(var0_2)
			arg0_1:sendNotification(GAME.GET_FEAST_DATA_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end

		if var1_1 then
			var1_1()
		end
	end)
end

function var0_0.FixStoryList(arg0_3, arg1_3)
	local var0_3 = arg1_3:GetInvitedFeastShips()
	local var1_3 = {}

	for iter0_3, iter1_3 in pairs(var0_3) do
		if iter1_3:GotTicket() then
			table.insert(var1_3, iter1_3:GetInvitationStory())
		end

		if iter1_3:GotGift() then
			table.insert(var1_3, iter1_3:GetGiftStory())
		end
	end

	if #var1_3 <= 0 then
		return
	end

	local var2_3 = {}

	for iter2_3, iter3_3 in pairs(var1_3) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter3_3) then
			table.insert(var2_3, iter3_3)
		end
	end

	if #var2_3 > 0 then
		for iter4_3, iter5_3 in ipairs(var2_3) do
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter5_3
			})
		end
	end
end

return var0_0
