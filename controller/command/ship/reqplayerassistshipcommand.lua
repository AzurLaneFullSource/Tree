local var0 = class("ReqPlayerAssistCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.playerIds
	local var2 = var0.callback
	local var3 = var0.type

	pg.ConnectionMgr.GetInstance():Send(12301, {
		type = var3,
		id_list = var1
	}, 12302, function(arg0)
		local var0 = getProxy(PlayerProxy)
		local var1

		if var3 == Player.ASSISTS_TYPE_SHAM then
			var1 = var0.playerAssists
		elseif var3 == Player.ASSISTS_TYPE_GUILD then
			var1 = var0.playerGuildAssists
		end

		for iter0, iter1 in ipairs(arg0.ship_list) do
			local var2 = {
				playerId = var1[iter0],
				timeStamp = pg.TimeMgr.GetInstance():GetServerTime()
			}

			if iter1 and pg.ship_data_statistics[iter1.template_id] then
				var2.ship = Ship.New(iter1)
			end

			var1[var2.playerId] = var2
		end

		if var2 then
			var2()
		end
	end)
end

return var0
