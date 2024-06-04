local var0 = class("AccountSearchCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = var0.update
	local var3 = getProxy(UserProxy):getData()
	local var4 = getProxy(ServerProxy).data
	local var5 = {}

	for iter0, iter1 in pairs(var4) do
		table.insert(var5, function(arg0)
			local var0 = iter1:getHost()
			local var1 = iter1:getPort()
			local var2

			pg.SimpleConnectionMgr.GetInstance():Disconnect()
			pg.SimpleConnectionMgr.GetInstance():SetErrorCB(function()
				if not var2 then
					var2({
						id = iter1.id
					})
					arg0()
				end
			end)
			pg.SimpleConnectionMgr.GetInstance():Connect(var0, var1, function()
				pg.SimpleConnectionMgr.GetInstance():Send(10026, {
					account_id = var3.uid
				}, 10027, function(arg0)
					if arg0.user_id and arg0.user_id ~= 0 and arg0.level and arg0.level > 0 then
						var2({
							id = iter1.id,
							user_id = arg0.user_id,
							level = arg0.level
						})
					else
						var2({
							id = iter1.id
						})
					end

					var2 = iter1.id

					arg0()
				end, nil, 0.5)
			end, 0.5)
		end)
	end

	seriesAsync(var5, function()
		var1()
	end)
end

return var0
