local var0_0 = class("TechnologyNationProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.typeAttrTable = {}
	arg0_1.typeOrder = {}
	arg0_1.typeAttrOrderTable = {}
	arg0_1.groupListInCount = {}
	arg0_1.nationToPoint = {}
	arg0_1.ifShowRedPoint = false
	arg0_1.techList = {}

	arg0_1:on(64000, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.tech_list) do
			arg0_1.techList[iter1_2.group_id] = {
				completeID = iter1_2.effect_tech_id,
				studyID = iter1_2.study_tech_id,
				finishTime = iter1_2.study_finish_time,
				rewardedID = iter1_2.rewarded_tech
			}
		end

		arg0_1:flushData()
		arg0_1:setTimer()
		arg0_1:initSetableAttrAddition(arg0_2.techset_list)
	end)

	if IsUnityEditor then
		local var0_1 = {
			ShipType.FengFanM,
			ShipType.FengFanS,
			ShipType.FengFanV
		}

		local function var1_1(arg0_3)
			if #var0_1 ~= #arg0_3 then
				return false
			end

			local var0_3 = {}
			local var1_3 = {}

			for iter0_3, iter1_3 in ipairs(var0_1) do
				var0_3[iter1_3] = (var0_3[iter1_3] or 0) + 1
			end

			for iter2_3, iter3_3 in ipairs(arg0_3) do
				var1_3[iter3_3] = (var1_3[iter3_3] or 0) + 1
			end

			for iter4_3, iter5_3 in pairs(var0_3) do
				if var1_3[iter4_3] ~= iter5_3 then
					return false
				end
			end

			return true
		end

		for iter0_1, iter1_1 in ipairs(pg.fleet_tech_ship_class.all) do
			if pg.fleet_tech_ship_class[iter1_1].nation == Nation.MOT then
				local var2_1 = pg.fleet_tech_ship_template[iter1_1]
				local var3_1 = var2_1.add_get_shiptype
				local var4_1 = var2_1.add_level_shiptype

				if not var1_1(var3_1) then
					assert(false, "请检查fleet_tech_ship_class中的add_get_shiptype， ID：" .. iter1_1)
				end

				if not var1_1(var4_1) then
					assert(false, "请检查fleet_tech_ship_class中的add_level_shiptype， ID：" .. iter1_1)
				end
			end
		end
	end
end

function var0_0.flushData(arg0_4)
	arg0_4:shipGroupFilter()
	arg0_4:nationPointFilter()
	arg0_4:calculateTecBuff()
	arg0_4:refreshRedPoint()
end

function var0_0.updateTecItem(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	if not arg0_5.techList[arg1_5] then
		arg0_5.techList[arg1_5] = {
			completeID = 0,
			rewardedID = 0,
			studyID = arg3_5,
			finishTime = arg4_5
		}

		return
	end

	arg0_5.techList[arg1_5] = {
		completeID = arg2_5 or arg0_5.techList[arg1_5].completeID,
		studyID = arg3_5,
		finishTime = arg4_5,
		rewardedID = arg5_5 or arg0_5.techList[arg1_5].rewardedID
	}
end

function var0_0.updateTecItemAward(arg0_6, arg1_6, arg2_6)
	arg0_6.techList[arg1_6].rewardedID = arg2_6
end

function var0_0.updateTecItemAwardOneStep(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.techList) do
		iter1_7.rewardedID = iter1_7.completeID
	end
end

function var0_0.shipGroupFilter(arg0_8)
	arg0_8.groupListInCount = {}

	local var0_8 = getProxy(CollectionProxy).shipGroups

	for iter0_8, iter1_8 in pairs(var0_8) do
		if pg.fleet_tech_ship_template[iter1_8.id] then
			table.insert(arg0_8.groupListInCount, iter1_8)
		end
	end
end

function var0_0.nationPointFilter(arg0_9)
	local var0_9 = {
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
		table.insert(var0_9, Nation.MOT)
	end

	arg0_9.nationToPoint = {}
	arg0_9.nationToPointLog = {}
	arg0_9.nationToPointLog2 = {}

	for iter0_9, iter1_9 in ipairs(var0_9) do
		arg0_9.nationToPoint[iter1_9] = 0
		arg0_9.nationToPointLog[iter1_9] = {
			{},
			{},
			{}
		}
		arg0_9.nationToPointLog2[iter1_9] = {}
	end

	for iter2_9, iter3_9 in ipairs(arg0_9.groupListInCount) do
		local var1_9 = iter3_9:getNation()
		local var2_9 = iter3_9.id

		if var1_9 ~= tonumber(string.sub(tostring(var2_9), 1, 1)) then
			table.insert(arg0_9.nationToPointLog2[var1_9], iter3_9)
		end

		local var3_9 = pg.fleet_tech_ship_template[var2_9]
		local var4_9 = 0 + var3_9.pt_get

		table.insert(arg0_9.nationToPointLog[var1_9][1], var2_9)

		if iter3_9.maxLV and iter3_9.maxLV >= TechnologyConst.SHIP_LEVEL_FOR_BUFF then
			var4_9 = var4_9 + var3_9.pt_level

			table.insert(arg0_9.nationToPointLog[var1_9][2], var2_9)
		end

		if iter3_9.star >= var3_9.max_star then
			var4_9 = var4_9 + var3_9.pt_upgrage

			table.insert(arg0_9.nationToPointLog[var1_9][3], var2_9)
		end

		arg0_9.nationToPoint[var1_9] = arg0_9.nationToPoint[var1_9] + var4_9
	end

	arg0_9.point = 0

	for iter4_9, iter5_9 in pairs(arg0_9.nationToPoint) do
		arg0_9.point = arg0_9.point + iter5_9
	end
end

function var0_0.calculateTecBuff(arg0_10)
	arg0_10.typeBuffList = {}
	arg0_10.typeOrder = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.groupListInCount) do
		local var0_10 = iter1_10.id
		local var1_10 = pg.fleet_tech_ship_template[var0_10].add_get_shiptype
		local var2_10 = pg.fleet_tech_ship_template[var0_10].add_get_attr
		local var3_10 = pg.fleet_tech_ship_template[var0_10].add_get_value

		for iter2_10, iter3_10 in ipairs(var1_10) do
			if not arg0_10.typeBuffList[iter3_10] then
				arg0_10.typeBuffList[iter3_10] = {
					{
						var2_10,
						var3_10
					}
				}
				arg0_10.typeOrder[#arg0_10.typeOrder + 1] = iter3_10
			else
				arg0_10.typeBuffList[iter3_10][#arg0_10.typeBuffList[iter3_10] + 1] = {
					var2_10,
					var3_10
				}
			end
		end

		if iter1_10.maxLV >= TechnologyConst.SHIP_LEVEL_FOR_BUFF then
			local var4_10 = pg.fleet_tech_ship_template[var0_10].add_level_shiptype
			local var5_10 = pg.fleet_tech_ship_template[var0_10].add_level_attr
			local var6_10 = pg.fleet_tech_ship_template[var0_10].add_level_value

			for iter4_10, iter5_10 in ipairs(var4_10) do
				if not arg0_10.typeBuffList[iter5_10] then
					arg0_10.typeBuffList[iter5_10] = {
						{
							var5_10,
							var6_10
						}
					}
					arg0_10.typeOrder[#arg0_10.typeOrder + 1] = iter5_10
				else
					arg0_10.typeBuffList[iter5_10][#arg0_10.typeBuffList[iter5_10] + 1] = {
						var5_10,
						var6_10
					}
				end
			end
		end
	end

	for iter6_10, iter7_10 in pairs(arg0_10.techList) do
		if iter7_10.completeID ~= 0 then
			local var7_10 = pg.fleet_tech_template[iter7_10.completeID].add

			for iter8_10, iter9_10 in ipairs(var7_10) do
				local var8_10 = iter9_10[1]
				local var9_10 = iter9_10[2]
				local var10_10 = iter9_10[3]

				for iter10_10, iter11_10 in ipairs(var8_10) do
					if not arg0_10.typeBuffList[iter11_10] then
						arg0_10.typeBuffList[iter11_10] = {
							{
								var9_10,
								var10_10
							}
						}
						arg0_10.typeOrder[#arg0_10.typeOrder + 1] = iter11_10
					else
						arg0_10.typeBuffList[iter11_10][#arg0_10.typeBuffList[iter11_10] + 1] = {
							var9_10,
							var10_10
						}
					end
				end
			end
		end
	end

	arg0_10.typeAttrTable = {}
	arg0_10.typeAttrOrderTable = {}

	for iter12_10, iter13_10 in pairs(arg0_10.typeBuffList) do
		if not arg0_10.typeAttrTable[iter12_10] then
			arg0_10.typeAttrTable[iter12_10] = {}
			arg0_10.typeAttrOrderTable[iter12_10] = {}
		end

		for iter14_10, iter15_10 in ipairs(iter13_10) do
			local var11_10 = iter15_10[1]
			local var12_10 = iter15_10[2]

			if not arg0_10.typeAttrTable[iter12_10][var11_10] then
				arg0_10.typeAttrTable[iter12_10][var11_10] = var12_10
				arg0_10.typeAttrOrderTable[iter12_10][#arg0_10.typeAttrOrderTable[iter12_10] + 1] = var11_10
			else
				arg0_10.typeAttrTable[iter12_10][var11_10] = arg0_10.typeAttrTable[iter12_10][var11_10] + var12_10
			end
		end
	end

	table.sort(arg0_10.typeOrder, function(arg0_11, arg1_11)
		return arg0_11 < arg1_11
	end)

	for iter16_10, iter17_10 in pairs(arg0_10.typeAttrOrderTable) do
		table.sort(iter17_10, function(arg0_12, arg1_12)
			return arg0_12 < arg1_12
		end)
	end
end

function var0_0.setTimer(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.techList) do
		if iter1_13.studyID ~= 0 then
			local var0_13 = iter1_13.finishTime
			local var1_13 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_13 = table.indexof(pg.fleet_tech_group[iter0_13].techs, iter1_13.completeID, 1) or 0
			local var3_13 = pg.fleet_tech_group[iter0_13].techs[var2_13 + 1]

			if var0_13 < var1_13 then
				arg0_13:sendNotification(GAME.FINISH_CAMP_TEC, {
					tecID = iter0_13,
					levelID = var3_13
				})

				return
			else
				onDelayTick(function()
					arg0_13:sendNotification(GAME.FINISH_CAMP_TEC, {
						tecID = iter0_13,
						levelID = var3_13
					})
				end, var0_13 - var1_13)

				return
			end
		end
	end
end

function var0_0.refreshRedPoint(arg0_15)
	arg0_15.ifShowRedPoint = false

	for iter0_15, iter1_15 in pairs(arg0_15.techList) do
		if iter1_15.studyID ~= 0 then
			if iter1_15.finishTime < pg.TimeMgr.GetInstance():GetServerTime() then
				arg0_15.ifShowRedPoint = true

				return
			else
				return
			end
		end
	end

	if arg0_15:isNeedRedPointTecCampUpgrade() then
		local var0_15 = getProxy(PlayerProxy):getData().gold

		for iter2_15, iter3_15 in ipairs(pg.fleet_tech_group.all) do
			if not arg0_15.techList[iter3_15] or arg0_15.techList[iter3_15].studyID == 0 then
				local var1_15 = arg0_15:getLevelByTecID(iter3_15)

				if var1_15 < #pg.fleet_tech_group[iter3_15].techs then
					local var2_15 = pg.fleet_tech_group[iter3_15].nation[1]
					local var3_15 = pg.fleet_tech_group[iter3_15].techs[var1_15 + 1]
					local var4_15 = arg0_15.nationToPoint[var2_15] >= pg.fleet_tech_template[var3_15].pt
					local var5_15 = var0_15 >= pg.fleet_tech_template[var3_15].cost

					if var4_15 and var5_15 then
						arg0_15.ifShowRedPoint = true

						return
					end
				end
			end
		end
	end

	arg0_15.ifShowRedPoint = arg0_15:isAnyTecCampCanGetAward()
end

function var0_0.isAnyTecCampCanGetAward(arg0_16)
	local var0_16 = false

	if not LOCK_TEC_NATION_AWARD then
		for iter0_16, iter1_16 in pairs(arg0_16.techList) do
			local var1_16 = pg.fleet_tech_group[iter0_16]
			local var2_16 = iter1_16.rewardedID
			local var3_16 = iter1_16.completeID

			if (table.indexof(var1_16.techs, var2_16, 1) or 0) < (table.indexof(var1_16.techs, var3_16, 1) or 0) then
				var0_16 = true

				break
			end
		end
	end

	return var0_16
end

var0_0.Ignore_TecCamp_Upgrade_Key = "Ignore_TecCamp_Upgrade_Key"

function var0_0.setRedPointIgnoreTecCampUpgrade(arg0_17)
	PlayerPrefs.SetInt(var0_0.Ignore_TecCamp_Upgrade_Key, pg.TimeMgr.GetInstance():GetServerTime())
end

function var0_0.isNeedRedPointTecCampUpgrade(arg0_18)
	local var0_18 = PlayerPrefs.GetInt(var0_0.Ignore_TecCamp_Upgrade_Key, 0)

	if var0_18 ~= 0 then
		local var1_18 = pg.TimeMgr.GetInstance():GetServerTime()

		return not pg.TimeMgr.GetInstance():IsSameDay(var0_18, var1_18)
	else
		return true
	end
end

function var0_0.GetTecList(arg0_19)
	return arg0_19.techList
end

function var0_0.GetTecItemByGroupID(arg0_20, arg1_20)
	return arg0_20.techList[arg1_20]
end

function var0_0.getLevelByTecID(arg0_21, arg1_21)
	local var0_21

	return not arg0_21.techList[arg1_21] and 0 or table.indexof(pg.fleet_tech_group[arg1_21].techs, arg0_21.techList[arg1_21].completeID, 1) or 0
end

function var0_0.getGroupListInCount(arg0_22)
	return arg0_22.groupListInCount
end

function var0_0.getShowRedPointTag(arg0_23)
	return arg0_23.ifShowRedPoint
end

function var0_0.getStudyingTecItem(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.techList) do
		if iter1_24.studyID ~= 0 then
			return iter0_24
		end
	end

	return nil
end

function var0_0.getPoint(arg0_25)
	return arg0_25.point
end

function var0_0.getNationPointList(arg0_26)
	return arg0_26.nationToPoint
end

function var0_0.getNationPoint(arg0_27, arg1_27)
	return arg0_27.nationToPoint[arg1_27]
end

function var0_0.getLeftTime(arg0_28)
	local var0_28 = arg0_28.techList[arg0_28:getStudyingTecItem()]

	if var0_28 then
		local var1_28 = var0_28.finishTime - pg.TimeMgr.GetInstance():GetServerTime()

		return var1_28 > 0 and var1_28 or 0
	else
		return 0
	end
end

function var0_0.getTecBuff(arg0_29)
	if OPEN_TEC_TREE_SYSTEM then
		return arg0_29.typeAttrTable, arg0_29.typeOrder, arg0_29.typeAttrOrderTable
	end
end

function var0_0.getShipAddition(arg0_30, arg1_30, arg2_30)
	local var0_30 = table.indexof(TechnologyConst.TECH_NATION_ATTRS, arg2_30)
	local var1_30 = 0
	local var2_30 = (arg0_30:getTecBuff() or {})[arg1_30]

	if var2_30 and var0_30 and var2_30[var0_30] then
		var1_30 = arg0_30:getSetableAttrAdditionValueByTypeAttr(arg1_30, var0_30)
	end

	return var1_30
end

function var0_0.getShipMaxAddition(arg0_31, arg1_31, arg2_31)
	local var0_31 = table.indexof(TechnologyConst.TECH_NATION_ATTRS, arg2_31)
	local var1_31 = 0
	local var2_31 = (arg0_31:getTecBuff() or {})[arg1_31]

	if var2_31 and var0_31 and var2_31[var0_31] then
		var1_31 = var2_31[var0_31]
	end

	return var1_31
end

function var0_0.printNationPointLog(arg0_32)
	for iter0_32, iter1_32 in pairs(arg0_32.nationToPointLog) do
		print("----------------" .. iter0_32 .. "----------------")

		for iter2_32, iter3_32 in ipairs(iter1_32) do
			local var0_32 = iter2_32 .. "    :"

			for iter4_32, iter5_32 in ipairs(iter3_32) do
				var0_32 = var0_32 .. "  " .. iter5_32
			end

			print(var0_32)
		end
	end

	print("----------------Filte----------------")

	for iter6_32, iter7_32 in pairs(arg0_32.nationToPointLog2) do
		local var1_32 = iter6_32 .. " :"

		for iter8_32, iter9_32 in ipairs(iter7_32) do
			local var2_32 = iter9_32.id
			local var3_32 = iter9_32:getNation()
			local var4_32

			for iter10_32 = 4, 1, -1 do
				if pg.ship_data_statistics[tonumber(var2_32 .. iter10_32)] then
					var4_32 = pg.ship_data_statistics[tonumber(var2_32 .. iter10_32)].nationality
				end
			end

			var1_32 = var1_32 .. tostring(var2_32) .. " " .. tostring(var3_32) .. " " .. tostring(var4_32) .. "||"
		end

		print(var1_32)
	end
end

function var0_0.initSetableAttrAddition(arg0_33, arg1_33)
	arg0_33.setValueTypeAttrTable = {}

	for iter0_33, iter1_33 in ipairs(arg1_33) do
		local var0_33 = iter1_33.ship_type
		local var1_33 = iter1_33.attr_type
		local var2_33 = iter1_33.set_value

		if not arg0_33.setValueTypeAttrTable[var0_33] then
			arg0_33.setValueTypeAttrTable[var0_33] = {}
		end

		arg0_33.setValueTypeAttrTable[var0_33][var1_33] = var2_33
	end
end

function var0_0.getSetableAttrAddition(arg0_34)
	return arg0_34.setValueTypeAttrTable
end

function var0_0.getSetableAttrAdditionValueByTypeAttr(arg0_35, arg1_35, arg2_35)
	if arg0_35.setValueTypeAttrTable[arg1_35] and arg0_35.setValueTypeAttrTable[arg1_35][arg2_35] then
		return arg0_35.setValueTypeAttrTable[arg1_35][arg2_35]
	else
		return arg0_35.typeAttrTable[arg1_35][arg2_35]
	end
end

return var0_0
