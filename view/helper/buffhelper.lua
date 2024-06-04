local var0 = class("BuffHelper")

local function var1(arg0, arg1)
	if arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUFF then
		if arg1 and not arg1:isEnd() then
			local var0 = arg1:getConfig("config_id")
			local var1 = {}

			if var0 == 0 then
				var1 = arg1:getConfig("config_data")
			else
				table.insert(var1, var0)
			end

			for iter0, iter1 in ipairs(var1) do
				local var2 = ActivityBuff.New(arg1.id, iter1)

				if var2:isActivate() then
					table.insert(arg0, var2)
				end
			end
		end
	elseif arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF or arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
		if arg1 and not arg1:isEnd() then
			local var3 = arg1:GetBuildingIds()

			for iter2, iter3 in pairs(var3) do
				local var4 = pg.activity_event_building[iter3]

				if var4 then
					_.each(var4.buff, function(arg0)
						local var0 = ActivityBuff.New(arg1.id, arg0)

						if var0:isActivate() then
							table.insert(arg0, var0)
						end
					end)
				end
			end

			if arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
				local var5 = arg1:GetSceneBuildingId()

				if var5 > 0 then
					local var6 = pg.activity_event_building[var5]

					if var6 then
						_.each(var6.buff, function(arg0)
							local var0 = ActivityBuff.New(arg1.id, arg0)

							if var0:isActivate() then
								table.insert(arg0, var0)
							end
						end)
					end
				end
			end
		end
	elseif arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF then
		if arg1 then
			local var7 = ActivityPtData.New(arg1)

			if not arg1:isEnd() and var7:isInBuffTime() then
				local var8 = arg1.data3_list

				for iter4, iter5 in pairs(var8) do
					table.insert(arg0, ActivityBuff.New(arg1.id, iter5))
				end
			end
		end
	elseif arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ATELIER_LINK and arg1 then
		local var9 = arg1:GetSlots()

		for iter6, iter7 in ipairs(var9) do
			local var10 = iter7[1]
			local var11 = iter7[2]

			if var10 > 0 and var11 > 0 then
				table.insert(arg0, ActivityBuff.New(arg1.id, AtelierMaterial.New({
					configId = var10
				}):GetBuffs()[var11]))
			end
		end
	end

	for iter8, iter9 in pairs(arg1:GetBuffList()) do
		table.insert(arg0, iter9)
	end
end

function var0.GetAllBuff(arg0)
	local var0 = {}
	local var1 = getProxy(PlayerProxy):getRawData()

	for iter0, iter1 in ipairs(var1:GetBuffs()) do
		table.insert(var0, CommonBuff.New(iter1))
	end

	local var2 = getProxy(ActivityProxy):getRawData()

	for iter2, iter3 in pairs(var2) do
		if (function()
			if arg0 and arg0.system and arg0.system == SYSTEM_SCENARIO and iter3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ATELIER_LINK then
				local var0 = getProxy(ChapterProxy):getActiveChapter(true)
				local var1 = var0 and getProxy(ChapterProxy):getMapById(var0:getConfig("map")) or nil

				if var1 and not AtelierActivity.IsActivityBuffMap(var1) then
					return false
				end
			end

			return true
		end)() then
			var1(var0, iter3)
		end
	end

	return var0
end

function var0.GetBackYardExpBuffs()
	local var0 = {}
	local var1 = var0.GetAllBuff()

	for iter0, iter1 in ipairs(var1) do
		if iter1:BackYardExpUsage() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetShipModExpBuff()
	return getProxy(ActivityProxy):getShipModExpActivity()
end

function var0.GetBackYardPlayerBuffs()
	local var0 = {}
	local var1 = getProxy(PlayerProxy):getRawData()

	for iter0, iter1 in ipairs(var1:GetBuffs()) do
		local var2 = CommonBuff.New(iter1)

		if var2:BackYardExpUsage() then
			table.insert(var0, var2)
		end
	end

	return var0
end

function var0.GetBattleBuffs(arg0)
	local var0 = {}
	local var1 = var0.GetAllBuff({
		system = arg0
	})

	for iter0, iter1 in ipairs(var1) do
		if iter1:BattleUsage() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetBuffsByActivityType(arg0)
	local var0 = {}
	local var1 = getProxy(ActivityProxy):getActivitiesByType(arg0)

	_.each(var1, function(arg0)
		var1(var0, arg0)
	end)

	return var0
end

function var0.GetBuffsForMainUI()
	local var0 = getProxy(ActivityProxy)
	local var1 = var0.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF)

	for iter0 = #var1, 1, -1 do
		if not var1[iter0]:checkShow() then
			table.remove(var1, iter0)
		end
	end

	local var2 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	if var2 and not var2:isEnd() then
		local var3 = var2:getConfig("config_client").bufflist
		local var4 = getProxy(PlayerProxy):getRawData()

		for iter1, iter2 in pairs(var4.buff_list) do
			if pg.TimeMgr:GetInstance():GetServerTime() < iter2.timestamp and table.contains(var3, iter2.id) then
				local var5 = ActivityBuff.New(var2.id, iter2.id, iter2.timestamp)

				if var5:checkShow() then
					table.insert(var1, var5)
				end
			end
		end
	end

	local var6 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_3)

	if var6 then
		local var7 = getProxy(PlayerProxy):getRawData()
		local var8 = var6:getConfig("config_data")[2]
		local var9

		for iter3, iter4 in ipairs(var7.buff_list) do
			if table.indexof(var8, iter4.id, 1) then
				if pg.TimeMgr.GetInstance():GetServerTime() < iter4.timestamp then
					local var10 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
					local var11 = ActivityBuff.New(var10.id, iter4.id, iter4.timestamp)

					if var11:checkShow() then
						table.insert(var1, var11)
					end
				end

				break
			end
		end
	end

	local var12 = getProxy(MiniGameProxy):GetMiniGameDataByType(MiniGameConst.MG_TYPE_5)

	if var12 then
		local var13 = getProxy(PlayerProxy):getRawData()
		local var14 = var12:getConfig("config_data")[2]
		local var15

		for iter5, iter6 in ipairs(var13.buff_list) do
			if table.indexof(var14, iter6.id, 1) then
				if pg.TimeMgr.GetInstance():GetServerTime() < iter6.timestamp then
					local var16 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
					local var17 = ActivityBuff.New(var16.id, iter6.id, iter6.timestamp)

					if var17:checkShow() then
						table.insert(var1, var17)
					end
				end

				break
			end
		end
	end

	return var1
end

return var0
