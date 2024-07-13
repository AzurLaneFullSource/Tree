local var0_0 = class("BuffHelper")

local function var1_0(arg0_1, arg1_1)
	if arg1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		if arg1_1 and not arg1_1:isEnd() then
			local var0_1 = arg1_1:getConfig("config_id")
			local var1_1 = {}

			if var0_1 == 0 then
				var1_1 = arg1_1:getConfig("config_data")
			else
				table.insert(var1_1, var0_1)
			end

			for iter0_1, iter1_1 in ipairs(var1_1) do
				local var2_1 = ActivityBuff.New(arg1_1.id, iter1_1)

				if var2_1:isActivate() then
					table.insert(arg0_1, var2_1)
				end
			end
		end
	elseif arg1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or arg1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
		if arg1_1 and not arg1_1:isEnd() then
			local var3_1 = arg1_1:GetBuildingIds()

			for iter2_1, iter3_1 in pairs(var3_1) do
				local var4_1 = pg.activity_event_building[iter3_1]

				if var4_1 then
					_.each(var4_1.buff, function(arg0_2)
						local var0_2 = ActivityBuff.New(arg1_1.id, arg0_2)

						if var0_2:isActivate() then
							table.insert(arg0_1, var0_2)
						end
					end)
				end
			end

			if arg1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
				local var5_1 = arg1_1:GetSceneBuildingId()

				if var5_1 > 0 then
					local var6_1 = pg.activity_event_building[var5_1]

					if var6_1 then
						_.each(var6_1.buff, function(arg0_3)
							local var0_3 = ActivityBuff.New(arg1_1.id, arg0_3)

							if var0_3:isActivate() then
								table.insert(arg0_1, var0_3)
							end
						end)
					end
				end
			end
		end
	elseif arg1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		if arg1_1 then
			local var7_1 = ActivityPtData.New(arg1_1)

			if not arg1_1:isEnd() and var7_1:isInBuffTime() then
				local var8_1 = arg1_1.data3_list

				for iter4_1, iter5_1 in pairs(var8_1) do
					table.insert(arg0_1, ActivityBuff.New(arg1_1.id, iter5_1))
				end
			end
		end
	elseif arg1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ATELIER_LINK and arg1_1 then
		local var9_1 = arg1_1:GetSlots()

		for iter6_1, iter7_1 in ipairs(var9_1) do
			local var10_1 = iter7_1[1]
			local var11_1 = iter7_1[2]

			if var10_1 > 0 and var11_1 > 0 then
				table.insert(arg0_1, ActivityBuff.New(arg1_1.id, AtelierMaterial.New({
					configId = var10_1
				}):GetBuffs()[var11_1]))
			end
		end
	end

	for iter8_1, iter9_1 in pairs(arg1_1:GetBuffList()) do
		table.insert(arg0_1, iter9_1)
	end
end

function var0_0.GetAllBuff(arg0_4)
	local var0_4 = {}
	local var1_4 = getProxy(PlayerProxy):getRawData()

	for iter0_4, iter1_4 in ipairs(var1_4:GetBuffs()) do
		table.insert(var0_4, CommonBuff.New(iter1_4))
	end

	local var2_4 = getProxy(ActivityProxy):getRawData()

	for iter2_4, iter3_4 in pairs(var2_4) do
		if (function()
			if arg0_4 and arg0_4.system and arg0_4.system == SYSTEM_SCENARIO and iter3_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ATELIER_LINK then
				local var0_5 = getProxy(ChapterProxy):getActiveChapter(true)
				local var1_5 = var0_5 and getProxy(ChapterProxy):getMapById(var0_5:getConfig("map")) or nil

				if var1_5 and not AtelierActivity.IsActivityBuffMap(var1_5) then
					return false
				end
			end

			return true
		end)() then
			var1_0(var0_4, iter3_4)
		end
	end

	return var0_4
end

function var0_0.GetBackYardExpBuffs()
	local var0_6 = {}
	local var1_6 = var0_0.GetAllBuff()

	for iter0_6, iter1_6 in ipairs(var1_6) do
		if iter1_6:BackYardExpUsage() then
			table.insert(var0_6, iter1_6)
		end
	end

	return var0_6
end

function var0_0.GetShipModExpBuff()
	return getProxy(ActivityProxy):getShipModExpActivity()
end

function var0_0.GetBackYardPlayerBuffs()
	local var0_8 = {}
	local var1_8 = getProxy(PlayerProxy):getRawData()

	for iter0_8, iter1_8 in ipairs(var1_8:GetBuffs()) do
		local var2_8 = CommonBuff.New(iter1_8)

		if var2_8:BackYardExpUsage() then
			table.insert(var0_8, var2_8)
		end
	end

	return var0_8
end

function var0_0.GetBattleBuffs(arg0_9)
	local var0_9 = {}
	local var1_9 = var0_0.GetAllBuff({
		system = arg0_9
	})

	for iter0_9, iter1_9 in ipairs(var1_9) do
		if iter1_9:BattleUsage() then
			table.insert(var0_9, iter1_9)
		end
	end

	return var0_9
end

function var0_0.GetBuffsByActivityType(arg0_10)
	local var0_10 = {}
	local var1_10 = getProxy(ActivityProxy):getActivitiesByType(arg0_10)

	_.each(var1_10, function(arg0_11)
		var1_0(var0_10, arg0_11)
	end)

	return var0_10
end

function var0_0.GetBuffsForMainUI()
	local var0_12 = getProxy(ActivityProxy)
	local var1_12 = var0_0.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF)

	for iter0_12 = #var1_12, 1, -1 do
		if not var1_12[iter0_12]:checkShow() then
			table.remove(var1_12, iter0_12)
		end
	end

	local var2_12 = var0_12:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	if var2_12 and not var2_12:isEnd() then
		local var3_12 = var2_12:getConfig("config_client").bufflist
		local var4_12 = getProxy(PlayerProxy):getRawData()

		for iter1_12, iter2_12 in pairs(var4_12.buff_list) do
			if pg.TimeMgr:GetInstance():GetServerTime() < iter2_12.timestamp and table.contains(var3_12, iter2_12.id) then
				local var5_12 = ActivityBuff.New(var2_12.id, iter2_12.id, iter2_12.timestamp)

				if var5_12:checkShow() then
					table.insert(var1_12, var5_12)
				end
			end
		end
	end

	local var6_12 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var6_12 then
		local var7_12 = getProxy(PlayerProxy):getRawData()
		local var8_12 = var6_12:getConfig("config_data")[2]
		local var9_12

		for iter3_12, iter4_12 in ipairs(var7_12.buff_list) do
			if table.indexof(var8_12, iter4_12.id, 1) then
				if pg.TimeMgr.GetInstance():GetServerTime() < iter4_12.timestamp then
					local var10_12 = var0_12:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
					local var11_12 = ActivityBuff.New(var10_12.id, iter4_12.id, iter4_12.timestamp)

					if var11_12:checkShow() then
						table.insert(var1_12, var11_12)
					end
				end

				break
			end
		end
	end

	local var12_12 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var12_12 then
		local var13_12 = getProxy(PlayerProxy):getRawData()
		local var14_12 = var12_12:getConfig("config_data")[2]
		local var15_12

		for iter5_12, iter6_12 in ipairs(var13_12.buff_list) do
			if table.indexof(var14_12, iter6_12.id, 1) then
				if pg.TimeMgr.GetInstance():GetServerTime() < iter6_12.timestamp then
					local var16_12 = var0_12:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
					local var17_12 = ActivityBuff.New(var16_12.id, iter6_12.id, iter6_12.timestamp)

					if var17_12:checkShow() then
						table.insert(var1_12, var17_12)
					end
				end

				break
			end
		end
	end

	return var1_12
end

return var0_0
