local var0 = class("GetFeastDataCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = var0.activityId

	pg.ConnectionMgr.GetInstance():Send(26156, {
		act_id = var2
	}, 26157, function(arg0)
		if arg0.ret == 0 then
			local var0 = FeastDorm.New({
				id = 4
			}, arg0)

			arg0:FixStoryList(var0)
			getProxy(FeastProxy):SetData(var0)
			arg0:sendNotification(GAME.GET_FEAST_DATA_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end

		if var1 then
			var1()
		end
	end)
end

function var0.FixStoryList(arg0, arg1)
	local var0 = arg1:GetInvitedFeastShips()
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		if iter1:GotTicket() then
			table.insert(var1, iter1:GetInvitationStory())
		end

		if iter1:GotGift() then
			table.insert(var1, iter1:GetGiftStory())
		end
	end

	if #var1 <= 0 then
		return
	end

	local var2 = {}

	for iter2, iter3 in pairs(var1) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter3) then
			table.insert(var2, iter3)
		end
	end

	if #var2 > 0 then
		for iter4, iter5 in ipairs(var2) do
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter5
			})
		end
	end
end

return var0
