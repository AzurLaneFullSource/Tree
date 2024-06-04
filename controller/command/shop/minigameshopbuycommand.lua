local var0 = class("MiniGameShopBuyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	local var2 = var0.id
	local var3 = var0.list
	local var4 = pg.gameroom_shop_template[var2]
	local var5 = 0
	local var6 = 0

	for iter0, iter1 in ipairs(var3) do
		local var7 = iter1.id
		local var8 = iter1.num

		var6 = var6 + var8
		var5 = var5 + var4.price * var8
	end

	if var5 > getProxy(GameRoomProxy):getTicket() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("game_ticket_notenough"),
			onYes = function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.GAME_HALL)
			end,
			onNo = function()
				return
			end
		})

		return
	end

	pg.ConnectionMgr.GetInstance():Send(26152, {
		goodsid = var2,
		selected = var3
	}, 26153, function(arg0)
		local var0

		if arg0.result == 0 then
			local var1 = id2res(GameRoomProxy.ticket_res_id)

			getProxy(PlayerProxy):getRawData():consume({
				[var1] = var5 or 0
			})

			local var2 = getProxy(ShopsProxy):getMiniShop()

			var2:consume(var2, var6)
			getProxy(ShopsProxy):setMiniShop(var2)

			local var3 = PlayerConst.addTranDrop(arg0.drop_list)

			arg0:sendNotification(GAME.MINI_GAME_SHOP_BUY_DONE, {
				list = var3
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
