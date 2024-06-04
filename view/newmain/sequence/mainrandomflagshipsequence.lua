local var0 = class("MainRandomFlagShipSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(SettingsProxy):GetRandomFlagShipList()

	if #var0 > 0 and _.all(var0, function(arg0)
		return getProxy(BayProxy):RawGetShipById(arg0) == nil
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_off_0"))
		getProxy(SettingsProxy):UpdateRandomFlagShipList({})
		arg1()

		return
	end

	local var1, var2 = arg0:ShouldRandom()

	if var1 then
		local var3 = arg0:Random()

		if not var3 or #var3 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_off_0"))
			arg0:SynToCache({}, var2)
		else
			arg0:SynToCache(var3, var2)
		end
	end

	arg1()
end

local function var1(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = GetZeroTime() - 18000
	local var2 = var1 - 39600
	local var3 = var2 - 46800

	if var0 < var2 and arg0 < var3 then
		return true, var3
	end

	if var2 <= var0 and var0 < var1 and arg0 < var2 then
		return true, var2
	end

	if var1 <= var0 and arg0 < var1 then
		return true, var1
	end

	return false
end

function var0.ShouldRandom(arg0)
	if not getProxy(SettingsProxy):IsOpenRandomFlagShip() then
		return false
	end

	local var0 = getProxy(SettingsProxy):GetPrevRandomFlagShipTime()

	return var1(var0)
end

local function var2(arg0, arg1)
	if arg1:isActivityNpc() then
		return false
	end

	if arg0 == SettingsRandomFlagShipAndSkinPanel.SHIP_FREQUENTLYUSED then
		return arg1:GetPreferenceTag() ~= 0
	elseif arg0 == SettingsRandomFlagShipAndSkinPanel.SHIP_LOCKED then
		return arg1:GetLockState() ~= 0
	elseif arg0 == SettingsRandomFlagShipAndSkinPanel.COUSTOM then
		-- block empty
	end

	return true
end

local function var3(arg0, arg1)
	local function var0(arg0, arg1, arg2)
		if not arg0[arg2.groupId] then
			arg0[arg2.groupId] = {}

			table.insert(arg1, arg2.groupId)
		end

		table.insert(arg0[arg2.groupId], arg2.id)
	end

	local var1 = {}

	if arg0 == SettingsRandomFlagShipAndSkinPanel.COUSTOM then
		for iter0, iter1 in ipairs(getProxy(PlayerProxy):getRawData():GetCustomRandomShipList()) do
			local var2 = getProxy(BayProxy):RawGetShipById(iter1)

			if var2 then
				table.insert(var1, var2)
			end
		end
	else
		var1 = getProxy(BayProxy):getRawData()
	end

	local var3 = {}
	local var4 = {}
	local var5 = {}
	local var6 = {}

	for iter2, iter3 in pairs(var1) do
		if var2(arg0, iter3) then
			if arg1[iter3.groupId] then
				var0(var5, var6, iter3)
			else
				var0(var3, var4, iter3)
			end
		end
	end

	return var3, var4, var5, var6
end

local function var4(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var1 = getProxy(BayProxy):RawGetShipById(iter1)

		if var1 then
			var0[var1.groupId] = true
		end
	end

	return var0
end

function var0.Random(arg0)
	local var0 = getProxy(PlayerProxy):getRawData():GetRandomFlagShipMode()
	local var1, var2 = PlayerVitaeShipsPage.GetSlotMaxCnt()
	local var3 = var4(getProxy(SettingsProxy):GetRandomFlagShipList())
	local var4, var5, var6, var7 = var3(var0, var3)

	return (arg0:RandomShips(var2, var4, var5, var6, var7))
end

function var0.RandomShips(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = {}

	for iter0 = 1, arg1 do
		if #arg3 == 0 and #arg5 == 0 then
			return var0
		end

		local var1 = #arg3 == 0
		local var2 = var1 and arg5 or arg3
		local var3 = var1 and arg4 or arg2
		local var4 = var2[math.random(1, #var2)]
		local var5 = var3[var4] or {}

		if #var5 > 0 then
			local var6 = var5[math.random(1, #var5)]

			table.insert(var0, var6)
			table.removebyvalue(var5, var6)
		end

		if #var5 == 0 then
			table.removebyvalue(var2, var4)
		end
	end

	return var0
end

function var0.SynToCache(arg0, arg1, arg2)
	getProxy(SettingsProxy):UpdateRandomFlagShipList(arg1)
	getProxy(SettingsProxy):SetPrevRandomFlagShipTime(arg2)
end

return var0
