local var0_0 = class("IslandGetFriendTradeRankCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback
	local var1_1 = getProxy(IslandProxy):GetIsland():GetTradeAgency()

	if not var1_1:ShouldRefreshRank() then
		if var0_1 then
			var0_1()
		end

		return
	end

	local var2_1 = GetZeroTime()
	local var3_1 = GetZeroTime()

	if pg.TimeMgr.GetInstance():GetServerHour() <= 2 then
		var3_1 = var3_1 - 86400
	end

	local var4_1 = var3_1 + 10800
	local var5_1 = arg0_1:CollectFirends()

	if #var5_1 <= 0 then
		if var0_1 then
			var0_1()
		end

		return
	end

	local var6_1 = {}
	local var7_1 = {}

	for iter0_1, iter1_1 in pairs(var5_1) do
		table.insert(var6_1, function(arg0_2)
			arg0_1:Send(iter1_1, function(arg0_3)
				table.insert(var7_1, arg0_3)
				arg0_2()
			end)
		end)
	end

	seriesAsync(var6_1, function()
		var1_1:SetRanks(var7_1, var4_1)

		if var0_1 then
			var0_1()
		end
	end)
end

function var0_0.CollectFirends(arg0_5)
	local var0_5 = getProxy(FriendProxy):getAllFriends()

	return _.map(var0_5, function(arg0_6)
		return arg0_6.id
	end)
end

function var0_0.Send(arg0_7, arg1_7, arg2_7)
	local var0_7 = pg.TimeMgr.GetInstance():GetServerTime()

	pg.ConnectionMgr.GetInstance():Send(21243, {
		island_id = arg1_7
	}, 21244, function(arg0_8)
		local var0_8 = arg0_8.today_price.timestamp <= var0_7 and 0 or arg0_8.today_price.price
		local var1_8 = getProxy(FriendProxy):getFriend(arg1_7)
		local var2_8 = IslandTradeRank.New({
			id = arg1_7,
			value = var0_8,
			skinId = var1_8 and var1_8.skinId or 100000,
			islandLevel = arg0_8.island_lv,
			name = var1_8 and var1_8.name or ""
		})

		arg2_7(var2_8)
	end)
end

return var0_0
