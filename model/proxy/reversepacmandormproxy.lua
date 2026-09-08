local var0_0 = class("ReversePacmanDormProxy", import("model.proxy.NetProxy"))

function var0_0.register(arg0_1)
	return
end

function var0_0.RequestData(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN)

	if not var0_2 or var0_2:isEnd() then
		arg0_2:RequestDormData()
		arg1_2()

		return
	end

	seriesAsync({
		function(arg0_3)
			arg0_2:RequestDormData(arg0_3)
		end,
		function(arg0_4)
			arg0_2:RandomShipData(var0_2, arg0_4)
		end
	}, arg1_2)
end

function var0_0.RequestDormData(arg0_5, arg1_5)
	local var0_5 = ReversePacmanDorm.New({
		id = 6
	})

	arg0_5:SetData(var0_5)
	existCall(arg1_5)
end

function var0_0.RandomShipData(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetFavorabilityList()

	for iter0_6, iter1_6 in pairs(var0_6) do
		arg0_6:AddShip(iter0_6)
	end

	existCall(arg2_6)
end

function var0_0.AddShip(arg0_7, arg1_7)
	local var0_7 = pg.activity_chasing_character[arg1_7]
	local var1_7 = ShipGroup.getDefaultShipConfig(pg.ship_skin_template[var0_7.skin_id].ship_group).id
	local var2_7 = ReversePacmanDormShip.New({
		id = var1_7,
		configId = var1_7,
		skin_id = var0_7.skin_id,
		roleID = arg1_7
	})

	arg0_7.data:AddShip(var2_7)
end

function var0_0.SetData(arg0_8, arg1_8)
	arg0_8.data = arg1_8

	arg0_8:AddRefreshTimer()
end

function var0_0.AddRefreshTimer(arg0_9)
	arg0_9:RemoveRefreshTimer()

	local var0_9 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_9 = GetZeroTime() - var0_9

	arg0_9.timer = Timer.New(function()
		arg0_9:RemoveRefreshTimer()

		local var0_10 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

		if var0_10 and not var0_10:isEnd() then
			arg0_9:RandomShipData()
		end
	end, var1_9 + 1, 1)

	arg0_9.timer:Start()
end

function var0_0.RemoveRefreshTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.remove(arg0_12)
	arg0_12:RemoveRefreshTimer()
end

return var0_0
