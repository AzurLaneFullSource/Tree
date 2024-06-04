local var0 = class("ChangeRandomFlagShipsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.addList
	local var2 = var0.deleteList
	local var3 = 300
	local var4 = math.max(#var2, #var1)
	local var5 = math.ceil(var4 / var3)
	local var6 = {}

	for iter0 = 1, var5 do
		local var7 = {}
		local var8 = {}
		local var9 = (iter0 - 1) * var3 + 1

		for iter1 = var9, var9 + var3 - 1 do
			if iter1 <= #var1 then
				table.insert(var7, var1[iter1])
			end

			if iter1 <= #var2 then
				table.insert(var8, var2[iter1])
			end
		end

		table.insert(var6, function(arg0)
			arg0:Send(var7, var8, arg0)
		end)
	end

	seriesAsync(var6, function()
		if #var1 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_custom_mode_add_complete"))
		end

		if #var2 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_custom_mode_remove_complete"))
		end

		arg0:sendNotification(GAME.CHANGE_RANDOM_SHIPS_DONE)
	end)
end

function var0.Send(arg0, arg1, arg2, arg3)
	pg.ConnectionMgr.GetInstance():Send(12208, {
		add_list = arg1,
		del_list = arg2
	}, 12209, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(PlayerProxy):getRawData()
			local var1 = var0:GetCustomRandomShipList()
			local var2 = {}

			for iter0, iter1 in ipairs(arg2) do
				var2[iter1] = true
			end

			for iter2 = #var1, 1, -1 do
				if var2[var1[iter2]] then
					table.remove(var1, iter2)
				end
			end

			for iter3, iter4 in ipairs(arg1) do
				if not table.contains(var1, iter4) then
					table.insert(var1, iter4)
				end
			end

			var0:UpdateCustomRandomShipList(var1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end

		if arg3 then
			arg3()
		end
	end)
end

return var0
