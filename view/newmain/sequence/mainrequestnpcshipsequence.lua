local var0_0 = class("MainRequestNPCShipSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_NPC_COLLECTION)) do
		local var1_1 = iter1_1:GetConfigClientSetting("story_id")

		if noEmptyStr(var1_1) and not pg.NewStoryMgr.GetInstance():IsPlayed(var1_1) then
			table.insert(var0_1, function(arg0_2)
				pg.NewStoryMgr.GetInstance():Play(var1_1, arg0_2, true, true)
			end)
		end

		if iter1_1.data1 == 0 then
			table.insert(var0_1, function(arg0_3)
				pg.m02:sendNotification(GAME.FETCH_NPC_SHIP_ACTIVITY, {
					activity_id = iter1_1.id,
					callback = arg0_3
				})
			end)
		end
	end

	seriesAsync(var0_1, arg1_1)
end

return var0_0
