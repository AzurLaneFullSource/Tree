local var0_0 = class("MainCompatibleDataSequence")

function var0_0.Execute(arg0_1, arg1_1)
	seriesAsync({
		function(arg0_2)
			getProxy(IslandProxy):CheckAndRequest(arg0_2)
		end,
		function(arg0_3)
			arg0_1:CheckSpecialDayForEducateChar(arg0_3)
		end,
		function(arg0_4)
			arg0_1:FetchGameTrackingCache(arg0_4)
		end
	}, arg1_1)
end

function var0_0.CheckSpecialDayForEducateChar(arg0_5, arg1_5)
	if LOCK_EDUCATE_SYSTEM then
		arg1_5()

		return
	end

	local var0_5 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_5, var2_5, var3_5 = ChineseCalendar.GetCurrYearMonthDay(var0_5)
	local var4_5 = getProxy(PlayerProxy):getRawData():ExistEducateChar()
	local var5_5 = getProxy(SettingsProxy)

	if var4_5 and var5_5:GetFlagShipDisplayMode() ~= FlAG_SHIP_DISPLAY_ONLY_SHIP and not var5_5:IsTipDay(var1_5, var2_5, var3_5) and ChineseCalendar.AnySpecialDay(var1_5, var2_5, var3_5) then
		local var6_5, var7_5 = PlayerVitaeShipsPage.GetSlotMaxCnt()
		local var8_5 = var7_5 + 1

		if var8_5 and var8_5 > 0 then
			var5_5:setCurrentSecretaryIndex(var8_5)
		end
	end

	arg1_5()
end

function var0_0.FetchGameTrackingCache(arg0_6, arg1_6)
	pg.GameTrackerMgr.GetInstance():FetchCache()
	arg1_6()
end

return var0_0
