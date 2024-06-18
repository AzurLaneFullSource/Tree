local var0_0 = class("MainRandomFlagShipSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(SettingsProxy):GetRandomFlagShipList()

	if #var0_1 > 0 and _.all(var0_1, function(arg0_2)
		return getProxy(BayProxy):RawGetShipById(arg0_2) == nil
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_off_0"))
		getProxy(SettingsProxy):UpdateRandomFlagShipList({})
		arg1_1()

		return
	end

	local var1_1, var2_1 = arg0_1:ShouldRandom()

	if var1_1 then
		local var3_1 = arg0_1:Random()

		if not var3_1 or #var3_1 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_off_0"))
			arg0_1:SynToCache({}, var2_1)
		else
			arg0_1:SynToCache(var3_1, var2_1)
		end
	end

	arg1_1()
end

local function var1_0(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_3 = GetZeroTime() - 18000
	local var2_3 = var1_3 - 39600
	local var3_3 = var2_3 - 46800

	if var0_3 < var2_3 and arg0_3 < var3_3 then
		return true, var3_3
	end

	if var2_3 <= var0_3 and var0_3 < var1_3 and arg0_3 < var2_3 then
		return true, var2_3
	end

	if var1_3 <= var0_3 and arg0_3 < var1_3 then
		return true, var1_3
	end

	return false
end

function var0_0.ShouldRandom(arg0_4)
	if not getProxy(SettingsProxy):IsOpenRandomFlagShip() then
		return false
	end

	local var0_4 = getProxy(SettingsProxy):GetPrevRandomFlagShipTime()

	return var1_0(var0_4)
end

local function var2_0(arg0_5, arg1_5)
	if arg1_5:isActivityNpc() then
		return false
	end

	if arg0_5 == SettingsRandomFlagShipAndSkinPanel.SHIP_FREQUENTLYUSED then
		return arg1_5:GetPreferenceTag() ~= 0
	elseif arg0_5 == SettingsRandomFlagShipAndSkinPanel.SHIP_LOCKED then
		return arg1_5:GetLockState() ~= 0
	elseif arg0_5 == SettingsRandomFlagShipAndSkinPanel.COUSTOM then
		-- block empty
	end

	return true
end

local function var3_0(arg0_6, arg1_6)
	local function var0_6(arg0_7, arg1_7, arg2_7)
		if not arg0_7[arg2_7.groupId] then
			arg0_7[arg2_7.groupId] = {}

			table.insert(arg1_7, arg2_7.groupId)
		end

		table.insert(arg0_7[arg2_7.groupId], arg2_7.id)
	end

	local var1_6 = {}

	if arg0_6 == SettingsRandomFlagShipAndSkinPanel.COUSTOM then
		for iter0_6, iter1_6 in ipairs(getProxy(PlayerProxy):getRawData():GetCustomRandomShipList()) do
			local var2_6 = getProxy(BayProxy):RawGetShipById(iter1_6)

			if var2_6 then
				table.insert(var1_6, var2_6)
			end
		end
	else
		var1_6 = getProxy(BayProxy):getRawData()
	end

	local var3_6 = {}
	local var4_6 = {}
	local var5_6 = {}
	local var6_6 = {}

	for iter2_6, iter3_6 in pairs(var1_6) do
		if var2_0(arg0_6, iter3_6) then
			if arg1_6[iter3_6.groupId] then
				var0_6(var5_6, var6_6, iter3_6)
			else
				var0_6(var3_6, var4_6, iter3_6)
			end
		end
	end

	return var3_6, var4_6, var5_6, var6_6
end

local function var4_0(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8) do
		local var1_8 = getProxy(BayProxy):RawGetShipById(iter1_8)

		if var1_8 then
			var0_8[var1_8.groupId] = true
		end
	end

	return var0_8
end

function var0_0.Random(arg0_9)
	local var0_9 = getProxy(PlayerProxy):getRawData():GetRandomFlagShipMode()
	local var1_9, var2_9 = PlayerVitaeShipsPage.GetSlotMaxCnt()
	local var3_9 = var4_0(getProxy(SettingsProxy):GetRandomFlagShipList())
	local var4_9, var5_9, var6_9, var7_9 = var3_0(var0_9, var3_9)

	return (arg0_9:RandomShips(var2_9, var4_9, var5_9, var6_9, var7_9))
end

function var0_0.RandomShips(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10)
	local var0_10 = {}

	for iter0_10 = 1, arg1_10 do
		if #arg3_10 == 0 and #arg5_10 == 0 then
			return var0_10
		end

		local var1_10 = #arg3_10 == 0
		local var2_10 = var1_10 and arg5_10 or arg3_10
		local var3_10 = var1_10 and arg4_10 or arg2_10
		local var4_10 = var2_10[math.random(1, #var2_10)]
		local var5_10 = var3_10[var4_10] or {}

		if #var5_10 > 0 then
			local var6_10 = var5_10[math.random(1, #var5_10)]

			table.insert(var0_10, var6_10)
			table.removebyvalue(var5_10, var6_10)
		end

		if #var5_10 == 0 then
			table.removebyvalue(var2_10, var4_10)
		end
	end

	return var0_10
end

function var0_0.SynToCache(arg0_11, arg1_11, arg2_11)
	getProxy(SettingsProxy):UpdateRandomFlagShipList(arg1_11)
	getProxy(SettingsProxy):SetPrevRandomFlagShipTime(arg2_11)
end

return var0_0
