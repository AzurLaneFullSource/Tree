local var0 = class("TrophyClaimCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().trophyID
	local var1 = getProxy(CollectionProxy)

	pg.ConnectionMgr.GetInstance():Send(17301, {
		id = var0
	}, 17302, function(arg0)
		if arg0.result == 0 then
			local var0 = arg0.timestamp

			var1:updateTrophyClaim(var0, var0)

			local var1 = {}

			for iter0, iter1 in ipairs(arg0.next) do
				var1[#var1 + 1] = Trophy.New(iter1)
			end

			var1:unlockNewTrophy(var1)
			arg0:sendNotification(GAME.TROPHY_CLAIM_DONE, {
				trophyID = var0
			})
			var1:updateTrophy()
		end
	end)
end

return var0
