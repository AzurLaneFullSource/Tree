local var0_0 = class("ChangeRandomFlagShipsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.addList
	local var2_1 = var0_1.deleteList
	local var3_1 = 300
	local var4_1 = math.max(#var2_1, #var1_1)
	local var5_1 = math.ceil(var4_1 / var3_1)
	local var6_1 = {}

	for iter0_1 = 1, var5_1 do
		local var7_1 = {}
		local var8_1 = {}
		local var9_1 = (iter0_1 - 1) * var3_1 + 1

		for iter1_1 = var9_1, var9_1 + var3_1 - 1 do
			if iter1_1 <= #var1_1 then
				table.insert(var7_1, var1_1[iter1_1])
			end

			if iter1_1 <= #var2_1 then
				table.insert(var8_1, var2_1[iter1_1])
			end
		end

		table.insert(var6_1, function(arg0_2)
			arg0_1:Send(var7_1, var8_1, arg0_2)
		end)
	end

	seriesAsync(var6_1, function()
		if #var1_1 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_custom_mode_add_complete"))
		end

		if #var2_1 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_custom_mode_remove_complete"))
		end

		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIPS_DONE)
	end)
end

function var0_0.Send(arg0_4, arg1_4, arg2_4, arg3_4)
	pg.ConnectionMgr.GetInstance():Send(12208, {
		add_list = arg1_4,
		del_list = arg2_4
	}, 12209, function(arg0_5)
		if arg0_5.result == 0 then
			local var0_5 = getProxy(PlayerProxy):getRawData()
			local var1_5 = var0_5:GetCustomRandomShipList()
			local var2_5 = {}

			for iter0_5, iter1_5 in ipairs(arg2_4) do
				var2_5[iter1_5] = true
			end

			for iter2_5 = #var1_5, 1, -1 do
				if var2_5[var1_5[iter2_5]] then
					table.remove(var1_5, iter2_5)
				end
			end

			for iter3_5, iter4_5 in ipairs(arg1_4) do
				if not table.contains(var1_5, iter4_5) then
					table.insert(var1_5, iter4_5)
				end
			end

			var0_5:UpdateCustomRandomShipList(var1_5)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.result] .. arg0_5.result)
		end

		if arg3_4 then
			arg3_4()
		end
	end)
end

return var0_0
