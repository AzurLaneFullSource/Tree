local var0_0 = class("ReqPlayerAssistCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.playerIds
	local var2_1 = var0_1.callback
	local var3_1 = var0_1.type

	pg.ConnectionMgr.GetInstance():Send(12301, {
		type = var3_1,
		id_list = var1_1
	}, 12302, function(arg0_2)
		local var0_2 = getProxy(PlayerProxy)
		local var1_2

		if var3_1 == Player.ASSISTS_TYPE_SHAM then
			var1_2 = var0_2.playerAssists
		elseif var3_1 == Player.ASSISTS_TYPE_GUILD then
			var1_2 = var0_2.playerGuildAssists
		end

		for iter0_2, iter1_2 in ipairs(arg0_2.ship_list) do
			local var2_2 = {
				playerId = var1_1[iter0_2],
				timeStamp = pg.TimeMgr.GetInstance():GetServerTime()
			}

			if iter1_2 and pg.ship_data_statistics[iter1_2.template_id] then
				var2_2.ship = Ship.New(iter1_2)
			end

			var1_2[var2_2.playerId] = var2_2
		end

		if var2_1 then
			var2_1()
		end
	end)
end

return var0_0
