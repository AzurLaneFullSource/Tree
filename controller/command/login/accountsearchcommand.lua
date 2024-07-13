local var0_0 = class("AccountSearchCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.update
	local var3_1 = getProxy(UserProxy):getData()
	local var4_1 = getProxy(ServerProxy).data
	local var5_1 = {}

	for iter0_1, iter1_1 in pairs(var4_1) do
		table.insert(var5_1, function(arg0_2)
			local var0_2 = iter1_1:getHost()
			local var1_2 = iter1_1:getPort()
			local var2_2

			pg.SimpleConnectionMgr.GetInstance():Disconnect()
			pg.SimpleConnectionMgr.GetInstance():SetErrorCB(function()
				if not var2_2 then
					var2_1({
						id = iter1_1.id
					})
					arg0_2()
				end
			end)
			pg.SimpleConnectionMgr.GetInstance():Connect(var0_2, var1_2, function()
				pg.SimpleConnectionMgr.GetInstance():Send(10026, {
					account_id = var3_1.uid
				}, 10027, function(arg0_5)
					if arg0_5.user_id and arg0_5.user_id ~= 0 and arg0_5.level and arg0_5.level > 0 then
						var2_1({
							id = iter1_1.id,
							user_id = arg0_5.user_id,
							level = arg0_5.level
						})
					else
						var2_1({
							id = iter1_1.id
						})
					end

					var2_2 = iter1_1.id

					arg0_2()
				end, nil, 0.5)
			end, 0.5)
		end)
	end

	seriesAsync(var5_1, function()
		var1_1()
	end)
end

return var0_0
