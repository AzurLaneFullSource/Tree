local var0_0 = class("BuffHelper")
local var1_0 = {}
local var2_0 = {}
local var3_0 = {}
local var4_0 = {}

function var0_0.GenBuffsForActivity(arg0_1)
	if arg0_1 and not arg0_1:isEnd() and var2_0[arg0_1.id] == arg0_1 then
		return underscore.map(var3_0[arg0_1.id], function(arg0_2)
			return var1_0[arg0_2]
		end)
	end

	if var3_0[arg0_1.id] then
		underscore.each(var3_0[arg0_1.id], function(arg0_3)
			if var1_0[arg0_3] then
				var4_0[var1_0[arg0_3]:getConfig("benefit_type")][arg0_3] = nil
			end

			var1_0[arg0_3] = nil
		end)
	end

	var2_0[arg0_1.id] = nil
	var3_0[arg0_1.id] = nil

	if not arg0_1 or arg0_1:isEnd() then
		return {}
	end

	local var0_1 = arg0_1:GetBuffList() or {}

	switch(arg0_1:getConfig("type"), {
		[ActivityConst.ACTIVITY_TYPE_BUFF] = function()
			local var0_4 = arg0_1:getConfig("config_id")
			local var1_4 = {}

			if var0_4 == 0 then
				var1_4 = arg0_1:getConfig("config_data")
			else
				table.insert(var1_4, var0_4)
			end

			for iter0_4, iter1_4 in ipairs(var1_4) do
				local var2_4 = ActivityBuff.New(arg0_1.id, iter1_4)

				table.insert(var0_1, var2_4)
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF] = function()
			local var0_5 = arg0_1:GetBuildingIds()

			for iter0_5, iter1_5 in pairs(var0_5) do
				local var1_5 = pg.activity_event_building[iter1_5]

				if var1_5 then
					_.each(var1_5.buff, function(arg0_6)
						table.insert(var0_1, ActivityBuff.New(arg0_1.id, arg0_6))
					end)
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2] = function()
			local var0_7 = arg0_1:GetBuildingIds()

			for iter0_7, iter1_7 in pairs(var0_7) do
				local var1_7 = pg.activity_event_building[iter1_7]

				if var1_7 then
					_.each(var1_7.buff, function(arg0_8)
						table.insert(var0_1, ActivityBuff.New(arg0_1.id, arg0_8))
					end)
				end
			end

			local var2_7 = arg0_1:GetSceneBuildingId()

			if var2_7 > 0 then
				local var3_7 = pg.activity_event_building[var2_7]

				if var3_7 then
					_.each(var3_7.buff, function(arg0_9)
						table.insert(var0_1, ActivityBuff.New(arg0_1.id, arg0_9))
					end)
				end
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = function()
			local var0_10 = arg0_1.data3_list

			for iter0_10, iter1_10 in pairs(var0_10) do
				table.insert(var0_1, ActivityBuff.New(arg0_1.id, iter1_10))
			end
		end,
		[ActivityConst.ACTIVITY_TYPE_ATELIER_LINK] = function()
			local var0_11 = arg0_1:GetSlots()

			for iter0_11, iter1_11 in ipairs(var0_11) do
				local var1_11 = iter1_11[1]
				local var2_11 = iter1_11[2]

				if var1_11 > 0 and var2_11 > 0 then
					table.insert(var0_1, ActivityBuff.New(arg0_1.id, AtelierMaterial.New({
						configId = var1_11
					}):GetBuffs()[var2_11]))
				end
			end
		end
	})

	var2_0[arg0_1.id] = arg0_1
	var3_0[arg0_1.id] = underscore.map(var0_1, function(arg0_12)
		var1_0[arg0_12.id] = arg0_12

		local var0_12 = arg0_12:getConfig("benefit_type")

		var4_0[var0_12] = var4_0[var0_12] or {}
		var4_0[var0_12][arg0_12.id] = true

		return arg0_12.id
	end)

	return var0_1
end

function var0_0.ClearAllCache()
	var1_0 = {}
	var2_0 = {}
	var3_0 = {}
	var4_0 = {}
end

function var0_0.GetBenefitTypeBuffs(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(getProxy(PlayerProxy):getRawData():GetBuffs()) do
		local var1_14 = CommonBuff.New(iter1_14)

		if var1_14:getConfig("benefit_type") == arg0_14 then
			table.insert(var0_14, var1_14)
		end
	end

	for iter2_14, iter3_14 in pairs(var4_0[arg0_14] or {}) do
		if iter3_14 and tobool(var1_0[iter2_14]) then
			table.insert(var0_14, var1_0[iter2_14])
		end
	end

	return underscore.filter(var0_14, function(arg0_15)
		return arg0_15:isActivate()
	end)
end

function var0_0.GetAllBuff()
	local var0_16 = underscore.map(getProxy(PlayerProxy):getRawData():GetBuffs(), function(arg0_17)
		return CommonBuff.New(arg0_17)
	end)
	local var1_16 = getProxy(ActivityProxy):getRawData()

	for iter0_16, iter1_16 in pairs(var1_16) do
		table.insertto(var0_16, var0_0.GenBuffsForActivity(iter1_16))
	end

	return underscore.filter(var0_16, function(arg0_18)
		return arg0_18:isActivate()
	end)
end

function var0_0.GetBackYardExpBuffs()
	return underscore.filter(var0_0.GetBenefitTypeBuffs(BuffUsageConst.DORM_EXP), function(arg0_20)
		return arg0_20:isActivate()
	end)
end

function var0_0.GetBackYardEnergyBuffs()
	return underscore.filter(var0_0.GetBenefitTypeBuffs(BuffUsageConst.DORM_ENERGY), function(arg0_22)
		return arg0_22:isActivate()
	end)
end

function var0_0.GetShipModExpBuff()
	return underscore.filter(var0_0.GetBenefitTypeBuffs(BuffUsageConst.SHIP_MOD_EXP), function(arg0_24)
		return arg0_24:isActivate()
	end)
end

function var0_0.GetBackYardPlayerBuffs()
	local var0_25 = {}

	for iter0_25, iter1_25 in ipairs(getProxy(PlayerProxy):getRawData():GetBuffs()) do
		local var1_25 = CommonBuff.New(iter1_25)

		if var1_25:getConfig("benefit_type") == BuffUsageConst.DORM_EXP then
			table.insert(var0_25, var1_25)
		end
	end

	return underscore.filter(var0_25, function(arg0_26)
		return arg0_26:isActivate()
	end)
end

function var0_0.GetBattleBuffs(arg0_27)
	return underscore.filter(var0_0.GetBenefitTypeBuffs(BuffUsageConst.BATTLE), function(arg0_28)
		return arg0_28:isActivate()
	end)
end

function var0_0.GetBuffsByActivityType(arg0_29)
	local var0_29 = {}
	local var1_29 = getProxy(ActivityProxy):getActivitiesByType(arg0_29)

	_.each(var1_29, function(arg0_30)
		table.insertto(var0_29, var0_0.GenBuffsForActivity(arg0_30))
	end)

	return underscore.filter(var0_29, function(arg0_31)
		return arg0_31:isActivate()
	end)
end

function var0_0.GetBuffsForMainUI()
	local var0_32 = getProxy(ActivityProxy)
	local var1_32 = var0_0.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF)

	for iter0_32 = #var1_32, 1, -1 do
		if not var1_32[iter0_32]:checkShow() then
			table.remove(var1_32, iter0_32)
		end
	end

	local var2_32 = var0_32:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	if var2_32 and not var2_32:isEnd() then
		local var3_32 = var2_32:getConfig("config_client").bufflist
		local var4_32 = getProxy(PlayerProxy):getRawData()

		for iter1_32, iter2_32 in pairs(var4_32.buff_list) do
			if pg.TimeMgr.GetInstance():GetServerTime() < iter2_32.timestamp and table.contains(var3_32, iter2_32.id) then
				local var5_32 = ActivityBuff.New(var2_32.id, iter2_32.id, iter2_32.timestamp)

				if var5_32:checkShow() then
					table.insert(var1_32, var5_32)
				end
			end
		end
	end

	local var6_32 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var6_32 then
		local var7_32 = getProxy(PlayerProxy):getRawData()
		local var8_32 = var6_32:getConfig("config_data")[2]
		local var9_32

		for iter3_32, iter4_32 in ipairs(var7_32.buff_list) do
			if table.indexof(var8_32, iter4_32.id, 1) then
				if pg.TimeMgr.GetInstance():GetServerTime() < iter4_32.timestamp then
					local var10_32 = var0_32:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
					local var11_32 = ActivityBuff.New(var10_32.id, iter4_32.id, iter4_32.timestamp)

					if var11_32:checkShow() then
						table.insert(var1_32, var11_32)
					end
				end

				break
			end
		end
	end

	local var12_32 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var12_32 then
		local var13_32 = getProxy(PlayerProxy):getRawData()
		local var14_32 = var12_32:getConfig("config_data")[2]
		local var15_32

		for iter5_32, iter6_32 in ipairs(var13_32.buff_list) do
			if table.indexof(var14_32, iter6_32.id, 1) then
				if pg.TimeMgr.GetInstance():GetServerTime() < iter6_32.timestamp then
					local var16_32 = var0_32:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
					local var17_32 = ActivityBuff.New(var16_32.id, iter6_32.id, iter6_32.timestamp)

					if var17_32:checkShow() then
						table.insert(var1_32, var17_32)
					end
				end

				break
			end
		end
	end

	return var1_32
end

return var0_0
