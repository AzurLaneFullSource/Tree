local var0_0 = class("MainCompatibleDataSequence")

function var0_0.Execute(arg0_1, arg1_1)
	seriesAsync({
		function(arg0_2)
			getProxy(IslandProxy):CheckAndRequest(arg0_2)
		end,
		function(arg0_3)
			arg0_1:CheckSpecialDayForEducateChar(arg0_3)
		end
	}, arg1_1)
end

function var0_0.CheckSpecialDayForEducateChar(arg0_4, arg1_4)
	if LOCK_EDUCATE_SYSTEM then
		arg1_4()

		return
	end

	local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_4, var2_4, var3_4 = ChineseCalendar.GetCurrYearMonthDay(var0_4)
	local var4_4 = getProxy(PlayerProxy):getRawData():ExistEducateChar()
	local var5_4 = getProxy(SettingsProxy)

	if var4_4 and var5_4:GetFlagShipDisplayMode() ~= FlAG_SHIP_DISPLAY_ONLY_SHIP and not var5_4:IsTipDay(var1_4, var2_4, var3_4) and ChineseCalendar.AnySpecialDay(var1_4, var2_4, var3_4) then
		local var6_4, var7_4 = PlayerVitaeShipsPage.GetSlotMaxCnt()
		local var8_4 = var7_4 + 1

		if var8_4 and var8_4 > 0 then
			var5_4:setCurrentSecretaryIndex(var8_4)
		end
	end

	arg1_4()
end

return var0_0
