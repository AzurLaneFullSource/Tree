local var0_0 = class("MiniGameShopBuyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	local var2_1 = var0_1.id
	local var3_1 = var0_1.list
	local var4_1 = pg.gameroom_shop_template[var2_1]
	local var5_1 = 0
	local var6_1 = 0

	for iter0_1, iter1_1 in ipairs(var3_1) do
		local var7_1 = iter1_1.id
		local var8_1 = iter1_1.num

		var6_1 = var6_1 + var8_1
		var5_1 = var5_1 + var4_1.price * var8_1
	end

	if var5_1 > getProxy(GameRoomProxy):getTicket() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("game_ticket_notenough"),
			onYes = function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.GAME_HALL)
			end,
			onNo = function()
				return
			end
		})

		return
	end

	pg.ConnectionMgr.GetInstance():Send(26152, {
		goodsid = var2_1,
		selected = var3_1
	}, 26153, function(arg0_4)
		local var0_4

		if arg0_4.result == 0 then
			local var1_4 = id2res(GameRoomProxy.ticket_res_id)

			getProxy(PlayerProxy):getRawData():consume({
				[var1_4] = var5_1 or 0
			})

			local var2_4 = getProxy(ShopsProxy):getMiniShop()

			var2_4:consume(var2_1, var6_1)
			getProxy(ShopsProxy):setMiniShop(var2_4)

			local var3_4 = PlayerConst.addTranDrop(arg0_4.drop_list)

			arg0_1:sendNotification(GAME.MINI_GAME_SHOP_BUY_DONE, {
				list = var3_4
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
		end
	end)
end

return var0_0
