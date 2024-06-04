local var0 = class("MainCompatibleDataSequence")

function var0.Execute(arg0, arg1)
	seriesAsync({
		function(arg0)
			getProxy(IslandProxy):CheckAndRequest(arg0)
		end,
		function(arg0)
			arg0:CheckSpecialDayForEducateChar(arg0)
		end
	}, arg1)
end

function var0.CheckSpecialDayForEducateChar(arg0, arg1)
	if LOCK_EDUCATE_SYSTEM then
		arg1()

		return
	end

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1, var2, var3 = ChineseCalendar.GetCurrYearMonthDay(var0)
	local var4 = getProxy(PlayerProxy):getRawData():ExistEducateChar()
	local var5 = getProxy(SettingsProxy)

	if var4 and var5:GetFlagShipDisplayMode() ~= FlAG_SHIP_DISPLAY_ONLY_SHIP and not var5:IsTipDay(var1, var2, var3) and ChineseCalendar.AnySpecialDay(var1, var2, var3) then
		local var6, var7 = PlayerVitaeShipsPage.GetSlotMaxCnt()
		local var8 = var7 + 1

		if var8 and var8 > 0 then
			var5:setCurrentSecretaryIndex(var8)
		end
	end

	arg1()
end

return var0
