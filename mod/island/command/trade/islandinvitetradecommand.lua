local var0_0 = class("IslandInviteTradeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.list
	local var2_1 = var0_1.mapId
	local var3_1 = var0_1.price

	if #var1_1 <= 0 then
		return
	end

	local var4_1 = getProxy(IslandProxy):GetIsland():GetTradeAgency()

	pg.ConnectionMgr.GetInstance():Send(21245, {
		friend_list = var1_1,
		map_id = var2_1,
		price = var3_1
	}, 21246, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:UpdateInviteList(var1_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_invite_success"))
		end
	end)
end

return var0_0
