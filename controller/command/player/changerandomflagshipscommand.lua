local var0_0 = class("ChangeRandomFlagShipsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.addList
	local var2_1 = var0_1.deleteList
	local var3_1 = {}

	for iter0_1, iter1_1 in ipairs({
		{
			var1_1,
			1
		},
		{
			var2_1,
			-1
		}
	}) do
		local var4_1, var5_1 = unpack(iter1_1)

		for iter2_1, iter3_1 in ipairs(var4_1) do
			var3_1[iter3_1] = defaultValue(var3_1[iter3_1], 0) + var5_1
		end
	end

	local var6_1 = getProxy(BayProxy):getRandomFlagShipPhantomMarks()

	for iter4_1, iter5_1 in ipairs(var6_1) do
		if var3_1[iter5_1] then
			var3_1[iter5_1] = var3_1[iter5_1] + 1
		end
	end

	local var7_1 = {}

	for iter6_1, iter7_1 in pairs(var3_1) do
		if iter7_1 == math.clamp(iter7_1, 0, 1) then
			local var8_1, var9_1 = ShipPhantom.UnpackMark(iter6_1)

			table.insert(var7_1, {
				ship_id = var8_1,
				shadow = var9_1,
				flag = iter7_1
			})
		end
	end

	local var10_1 = 300
	local var11_1 = math.ceil(#var7_1 / var10_1)
	local var12_1 = {}

	for iter8_1 = 1, var11_1 do
		table.insert(var12_1, function(arg0_2)
			arg0_1:Send(underscore.slice(var7_1, (iter8_1 - 1) * var10_1 + 1, var10_1), arg0_2)
		end)
	end

	seriesAsync(var12_1, function()
		if #var1_1 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_custom_mode_add_shadow_complete"))
		end

		if #var2_1 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_custom_mode_remove_shadow_complete"))
		end

		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIPS_DONE)
	end)
end

function var0_0.Send(arg0_4, arg1_4, arg2_4)
	pg.ConnectionMgr.GetInstance():Send(12208, {
		ship_shadow_list = underscore.map(arg1_4, function(arg0_5)
			return {
				key = arg0_5.ship_id,
				value1 = arg0_5.shadow,
				value2 = arg0_5.flag
			}
		end)
	}, 12209, function(arg0_6)
		if arg0_6.result == 0 then
			getProxy(BayProxy):updateRandomFlagShips(arg1_4)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_6.result] .. arg0_6.result)
		end

		if arg2_4 then
			arg2_4()
		end
	end)
end

return var0_0
