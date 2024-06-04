local var0 = class("MiniGameFriendRankCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if var0.id == nil then
		return
	end

	local var1 = var0.id

	pg.ConnectionMgr.GetInstance():Send(26111, {
		gameid = var1
	}, 26112, function(arg0)
		local var0 = underscore(arg0.ranks):chain():sort(function(arg0, arg1)
			return arg0.score > arg1.score
		end):reduce({}, function(arg0, arg1)
			local var0 = {
				position = #arg0 + 1,
				player_id = arg1.id,
				name = arg1.name,
				score = arg1.score,
				display = arg1.display,
				time_data = arg1.time_data
			}

			arg0[#arg0 + 1] = var0

			if #arg0 > 1 and arg0[#arg0 - 1].score == arg1.score then
				var0.position = arg0[#arg0 - 1].position
			end

			return arg0
		end):value()

		getProxy(MiniGameProxy):SetRank(var1, var0)

		if var0.callback then
			var0.callback(var0)
		end
	end)
end

return var0
