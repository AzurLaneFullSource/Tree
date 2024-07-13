local var0_0 = class("TrophyClaimCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().trophyID
	local var1_1 = getProxy(CollectionProxy)

	pg.ConnectionMgr.GetInstance():Send(17301, {
		id = var0_1
	}, 17302, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = arg0_2.timestamp

			var1_1:updateTrophyClaim(var0_1, var0_2)

			local var1_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.next) do
				var1_2[#var1_2 + 1] = Trophy.New(iter1_2)
			end

			var1_1:unlockNewTrophy(var1_2)
			arg0_1:sendNotification(GAME.TROPHY_CLAIM_DONE, {
				trophyID = var0_1
			})
			var1_1:updateTrophy()
		end
	end)
end

return var0_0
