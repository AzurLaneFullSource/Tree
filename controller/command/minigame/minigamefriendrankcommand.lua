local var0_0 = class("MiniGameFriendRankCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if var0_1.id == nil then
		return
	end

	local var1_1 = var0_1.id

	pg.ConnectionMgr.GetInstance():Send(26111, {
		gameid = var1_1
	}, 26112, function(arg0_2)
		local var0_2 = underscore(arg0_2.ranks):chain():sort(function(arg0_3, arg1_3)
			return arg0_3.score > arg1_3.score
		end):reduce({}, function(arg0_4, arg1_4)
			local var0_4 = {
				position = #arg0_4 + 1,
				player_id = arg1_4.id,
				name = arg1_4.name,
				score = arg1_4.score,
				display = arg1_4.display,
				time_data = arg1_4.time_data
			}

			arg0_4[#arg0_4 + 1] = var0_4

			if #arg0_4 > 1 and arg0_4[#arg0_4 - 1].score == arg1_4.score then
				var0_4.position = arg0_4[#arg0_4 - 1].position
			end

			return arg0_4
		end):value()

		getProxy(MiniGameProxy):SetRank(var1_1, var0_2)

		if var0_1.callback then
			var0_1.callback(var0_2)
		end
	end)
end

return var0_0
