local var0 = class("TechnologyNationProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.typeAttrTable = {}
	arg0.typeOrder = {}
	arg0.typeAttrOrderTable = {}
	arg0.groupListInCount = {}
	arg0.nationToPoint = {}
	arg0.ifShowRedPoint = false
	arg0.techList = {}

	arg0:on(64000, function(arg0)
		for iter0, iter1 in ipairs(arg0.tech_list) do
			arg0.techList[iter1.group_id] = {
				completeID = iter1.effect_tech_id,
				studyID = iter1.study_tech_id,
				finishTime = iter1.study_finish_time,
				rewardedID = iter1.rewarded_tech
			}
		end

		arg0:flushData()
		arg0:setTimer()
		arg0:initSetableAttrAddition(arg0.techset_list)
	end)

	if IsUnityEditor then
		local var0 = {
			ShipType.FengFanM,
			ShipType.FengFanS,
			ShipType.FengFanV
		}

		local function var1(arg0)
			if #var0 ~= #arg0 then
				return false
			end

			local var0 = {}
			local var1 = {}

			for iter0, iter1 in ipairs(var0) do
				var0[iter1] = (var0[iter1] or 0) + 1
			end

			for iter2, iter3 in ipairs(arg0) do
				var1[iter3] = (var1[iter3] or 0) + 1
			end

			for iter4, iter5 in pairs(var0) do
				if var1[iter4] ~= iter5 then
					return false
				end
			end

			return true
		end

		for iter0, iter1 in ipairs(pg.fleet_tech_ship_class.all) do
			if pg.fleet_tech_ship_class[iter1].nation == Nation.MOT then
				local var2 = pg.fleet_tech_ship_template[iter1]
				local var3 = var2.add_get_shiptype
				local var4 = var2.add_level_shiptype

				if not var1(var3) then
					assert(false, "请检查fleet_tech_ship_class中的add_get_shiptype， ID：" .. iter1)
				end

				if not var1(var4) then
					assert(false, "请检查fleet_tech_ship_class中的add_level_shiptype， ID：" .. iter1)
				end
			end
		end
	end
end

function var0.flushData(arg0)
	arg0:shipGroupFilter()
	arg0:nationPointFilter()
	arg0:calculateTecBuff()
	arg0:refreshRedPoint()
end

function var0.updateTecItem(arg0, arg1, arg2, arg3, arg4, arg5)
	if not arg0.techList[arg1] then
		arg0.techList[arg1] = {
			completeID = 0,
			rewardedID = 0,
			studyID = arg3,
			finishTime = arg4
		}

		return
	end

	arg0.techList[arg1] = {
		completeID = arg2 or arg0.techList[arg1].completeID,
		studyID = arg3,
		finishTime = arg4,
		rewardedID = arg5 or arg0.techList[arg1].rewardedID
	}
end

function var0.updateTecItemAward(arg0, arg1, arg2)
	arg0.techList[arg1].rewardedID = arg2
end

function var0.updateTecItemAwardOneStep(arg0)
	for iter0, iter1 in pairs(arg0.techList) do
		iter1.rewardedID = iter1.completeID
	end
end

function var0.shipGroupFilter(arg0)
	arg0.groupListInCount = {}

	local var0 = getProxy(CollectionProxy).shipGroups

	for iter0, iter1 in pairs(var0) do
		if pg.fleet_tech_ship_template[iter1.id] then
			table.insert(arg0.groupListInCount, iter1)
		end
	end
end

function var0.nationPointFilter(arg0)
	local var0 = {
		Nation.US,
		Nation.EN,
		Nation.JP,
		Nation.DE,
		Nation.CN,
		Nation.ITA,
		Nation.SN,
		Nation.FF,
		Nation.MNF,
		Nation.FR,
		Nation.META
	}

	if not LOCK_TEC_MOT then
		table.insert(var0, Nation.MOT)
	end

	arg0.nationToPoint = {}
	arg0.nationToPointLog = {}
	arg0.nationToPointLog2 = {}

	for iter0, iter1 in ipairs(var0) do
		arg0.nationToPoint[iter1] = 0
		arg0.nationToPointLog[iter1] = {
			{},
			{},
			{}
		}
		arg0.nationToPointLog2[iter1] = {}
	end

	for iter2, iter3 in ipairs(arg0.groupListInCount) do
		local var1 = iter3:getNation()
		local var2 = iter3.id

		if var1 ~= tonumber(string.sub(tostring(var2), 1, 1)) then
			table.insert(arg0.nationToPointLog2[var1], iter3)
		end

		local var3 = pg.fleet_tech_ship_template[var2]
		local var4 = 0 + var3.pt_get

		table.insert(arg0.nationToPointLog[var1][1], var2)

		if iter3.maxLV and iter3.maxLV >= TechnologyConst.SHIP_LEVEL_FOR_BUFF then
			var4 = var4 + var3.pt_level

			table.insert(arg0.nationToPointLog[var1][2], var2)
		end

		if iter3.star >= var3.max_star then
			var4 = var4 + var3.pt_upgrage

			table.insert(arg0.nationToPointLog[var1][3], var2)
		end

		arg0.nationToPoint[var1] = arg0.nationToPoint[var1] + var4
	end

	arg0.point = 0

	for iter4, iter5 in pairs(arg0.nationToPoint) do
		arg0.point = arg0.point + iter5
	end
end

function var0.calculateTecBuff(arg0)
	arg0.typeBuffList = {}
	arg0.typeOrder = {}

	for iter0, iter1 in ipairs(arg0.groupListInCount) do
		local var0 = iter1.id
		local var1 = pg.fleet_tech_ship_template[var0].add_get_shiptype
		local var2 = pg.fleet_tech_ship_template[var0].add_get_attr
		local var3 = pg.fleet_tech_ship_template[var0].add_get_value

		for iter2, iter3 in ipairs(var1) do
			if not arg0.typeBuffList[iter3] then
				arg0.typeBuffList[iter3] = {
					{
						var2,
						var3
					}
				}
				arg0.typeOrder[#arg0.typeOrder + 1] = iter3
			else
				arg0.typeBuffList[iter3][#arg0.typeBuffList[iter3] + 1] = {
					var2,
					var3
				}
			end
		end

		if iter1.maxLV >= TechnologyConst.SHIP_LEVEL_FOR_BUFF then
			local var4 = pg.fleet_tech_ship_template[var0].add_level_shiptype
			local var5 = pg.fleet_tech_ship_template[var0].add_level_attr
			local var6 = pg.fleet_tech_ship_template[var0].add_level_value

			for iter4, iter5 in ipairs(var4) do
				if not arg0.typeBuffList[iter5] then
					arg0.typeBuffList[iter5] = {
						{
							var5,
							var6
						}
					}
					arg0.typeOrder[#arg0.typeOrder + 1] = iter5
				else
					arg0.typeBuffList[iter5][#arg0.typeBuffList[iter5] + 1] = {
						var5,
						var6
					}
				end
			end
		end
	end

	for iter6, iter7 in pairs(arg0.techList) do
		if iter7.completeID ~= 0 then
			local var7 = pg.fleet_tech_template[iter7.completeID].add

			for iter8, iter9 in ipairs(var7) do
				local var8 = iter9[1]
				local var9 = iter9[2]
				local var10 = iter9[3]

				for iter10, iter11 in ipairs(var8) do
					if not arg0.typeBuffList[iter11] then
						arg0.typeBuffList[iter11] = {
							{
								var9,
								var10
							}
						}
						arg0.typeOrder[#arg0.typeOrder + 1] = iter11
					else
						arg0.typeBuffList[iter11][#arg0.typeBuffList[iter11] + 1] = {
							var9,
							var10
						}
					end
				end
			end
		end
	end

	arg0.typeAttrTable = {}
	arg0.typeAttrOrderTable = {}

	for iter12, iter13 in pairs(arg0.typeBuffList) do
		if not arg0.typeAttrTable[iter12] then
			arg0.typeAttrTable[iter12] = {}
			arg0.typeAttrOrderTable[iter12] = {}
		end

		for iter14, iter15 in ipairs(iter13) do
			local var11 = iter15[1]
			local var12 = iter15[2]

			if not arg0.typeAttrTable[iter12][var11] then
				arg0.typeAttrTable[iter12][var11] = var12
				arg0.typeAttrOrderTable[iter12][#arg0.typeAttrOrderTable[iter12] + 1] = var11
			else
				arg0.typeAttrTable[iter12][var11] = arg0.typeAttrTable[iter12][var11] + var12
			end
		end
	end

	table.sort(arg0.typeOrder, function(arg0, arg1)
		return arg0 < arg1
	end)

	for iter16, iter17 in pairs(arg0.typeAttrOrderTable) do
		table.sort(iter17, function(arg0, arg1)
			return arg0 < arg1
		end)
	end
end

function var0.setTimer(arg0)
	for iter0, iter1 in pairs(arg0.techList) do
		if iter1.studyID ~= 0 then
			local var0 = iter1.finishTime
			local var1 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2 = table.indexof(pg.fleet_tech_group[iter0].techs, iter1.completeID, 1) or 0
			local var3 = pg.fleet_tech_group[iter0].techs[var2 + 1]

			if var0 < var1 then
				arg0:sendNotification(GAME.FINISH_CAMP_TEC, {
					tecID = iter0,
					levelID = var3
				})

				return
			else
				onDelayTick(function()
					arg0:sendNotification(GAME.FINISH_CAMP_TEC, {
						tecID = iter0,
						levelID = var3
					})
				end, var0 - var1)

				return
			end
		end
	end
end

function var0.refreshRedPoint(arg0)
	arg0.ifShowRedPoint = false

	for iter0, iter1 in pairs(arg0.techList) do
		if iter1.studyID ~= 0 then
			if iter1.finishTime < pg.TimeMgr.GetInstance():GetServerTime() then
				arg0.ifShowRedPoint = true

				return
			else
				return
			end
		end
	end

	for iter2, iter3 in ipairs(pg.fleet_tech_group.all) do
		if not arg0.techList[iter3] or arg0.techList[iter3].studyID == 0 then
			local var0 = arg0:getLevelByTecID(iter3)

			if var0 < #pg.fleet_tech_group[iter3].techs then
				local var1 = pg.fleet_tech_group[iter3].nation[1]
				local var2 = pg.fleet_tech_group[iter3].techs[var0 + 1]

				if arg0.nationToPoint[var1] >= pg.fleet_tech_template[var2].pt then
					arg0.ifShowRedPoint = true

					break
				end
			end
		end
	end

	arg0.ifShowRedPoint = arg0:isAnyTecCampCanGetAward()
end

function var0.isAnyTecCampCanGetAward(arg0)
	local var0 = false

	if not LOCK_TEC_NATION_AWARD then
		for iter0, iter1 in pairs(arg0.techList) do
			local var1 = pg.fleet_tech_group[iter0]
			local var2 = iter1.rewardedID
			local var3 = iter1.completeID

			if (table.indexof(var1.techs, var2, 1) or 0) < (table.indexof(var1.techs, var3, 1) or 0) then
				var0 = true

				break
			end
		end
	end

	return var0
end

function var0.GetTecList(arg0)
	return arg0.techList
end

function var0.GetTecItemByGroupID(arg0, arg1)
	return arg0.techList[arg1]
end

function var0.getLevelByTecID(arg0, arg1)
	local var0

	return not arg0.techList[arg1] and 0 or table.indexof(pg.fleet_tech_group[arg1].techs, arg0.techList[arg1].completeID, 1) or 0
end

function var0.getGroupListInCount(arg0)
	return arg0.groupListInCount
end

function var0.getShowRedPointTag(arg0)
	return arg0.ifShowRedPoint
end

function var0.getStudyingTecItem(arg0)
	for iter0, iter1 in pairs(arg0.techList) do
		if iter1.studyID ~= 0 then
			return iter0
		end
	end

	return nil
end

function var0.getPoint(arg0)
	return arg0.point
end

function var0.getNationPointList(arg0)
	return arg0.nationToPoint
end

function var0.getNationPoint(arg0, arg1)
	return arg0.nationToPoint[arg1]
end

function var0.getLeftTime(arg0)
	local var0 = arg0.techList[arg0:getStudyingTecItem()]

	if var0 then
		local var1 = var0.finishTime - pg.TimeMgr.GetInstance():GetServerTime()

		return var1 > 0 and var1 or 0
	else
		return 0
	end
end

function var0.getTecBuff(arg0)
	if OPEN_TEC_TREE_SYSTEM then
		return arg0.typeAttrTable, arg0.typeOrder, arg0.typeAttrOrderTable
	end
end

function var0.getShipAddition(arg0, arg1, arg2)
	local var0 = table.indexof(TechnologyConst.TECH_NATION_ATTRS, arg2)
	local var1 = 0
	local var2 = (arg0:getTecBuff() or {})[arg1]

	if var2 and var0 and var2[var0] then
		var1 = arg0:getSetableAttrAdditionValueByTypeAttr(arg1, var0)
	end

	return var1
end

function var0.getShipMaxAddition(arg0, arg1, arg2)
	local var0 = table.indexof(TechnologyConst.TECH_NATION_ATTRS, arg2)
	local var1 = 0
	local var2 = (arg0:getTecBuff() or {})[arg1]

	if var2 and var0 and var2[var0] then
		var1 = var2[var0]
	end

	return var1
end

function var0.printNationPointLog(arg0)
	for iter0, iter1 in pairs(arg0.nationToPointLog) do
		print("----------------" .. iter0 .. "----------------")

		for iter2, iter3 in ipairs(iter1) do
			local var0 = iter2 .. "    :"

			for iter4, iter5 in ipairs(iter3) do
				var0 = var0 .. "  " .. iter5
			end

			print(var0)
		end
	end

	print("----------------Filte----------------")

	for iter6, iter7 in pairs(arg0.nationToPointLog2) do
		local var1 = iter6 .. " :"

		for iter8, iter9 in ipairs(iter7) do
			local var2 = iter9.id
			local var3 = iter9:getNation()
			local var4

			for iter10 = 4, 1, -1 do
				if pg.ship_data_statistics[tonumber(var2 .. iter10)] then
					var4 = pg.ship_data_statistics[tonumber(var2 .. iter10)].nationality
				end
			end

			var1 = var1 .. tostring(var2) .. " " .. tostring(var3) .. " " .. tostring(var4) .. "||"
		end

		print(var1)
	end
end

function var0.initSetableAttrAddition(arg0, arg1)
	arg0.setValueTypeAttrTable = {}

	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1.ship_type
		local var1 = iter1.attr_type
		local var2 = iter1.set_value

		if not arg0.setValueTypeAttrTable[var0] then
			arg0.setValueTypeAttrTable[var0] = {}
		end

		arg0.setValueTypeAttrTable[var0][var1] = var2
	end
end

function var0.getSetableAttrAddition(arg0)
	return arg0.setValueTypeAttrTable
end

function var0.getSetableAttrAdditionValueByTypeAttr(arg0, arg1, arg2)
	if arg0.setValueTypeAttrTable[arg1] and arg0.setValueTypeAttrTable[arg1][arg2] then
		return arg0.setValueTypeAttrTable[arg1][arg2]
	else
		return arg0.typeAttrTable[arg1][arg2]
	end
end

return var0
