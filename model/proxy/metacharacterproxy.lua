local var0_0 = class("MetaCharacterProxy", import(".NetProxy"))

var0_0.METAPROGRESS_UPDATED = "MetaCharacterProxy:METAPROGRESS_UPDATED"

local var1_0 = pg.ship_strengthen_meta

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.metaProgressVOList = {}
	arg0_1.metaTacticsInfoTable = nil
	arg0_1.metaTacticsInfoTableOnStart = nil
	arg0_1.metaSkillLevelMaxInfoList = nil
	arg0_1.lastMetaSkillExpInfoList = nil
	arg0_1.startRecordTag = false

	for iter0_1, iter1_1 in pairs(var1_0.all) do
		local var0_1 = MetaProgress.New({
			id = iter1_1
		})

		arg0_1.data[iter1_1] = var0_1

		table.insert(arg0_1.metaProgressVOList, var0_1)
	end

	arg0_1.redTagTable = {}

	for iter2_1, iter3_1 in pairs(var1_0.all) do
		arg0_1.redTagTable[iter3_1] = {
			false,
			false
		}
	end

	arg0_1:on(63315, function(arg0_2)
		print("63315 get red tag info")

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.arg1) do
			local var1_2 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(iter1_2)

			table.insert(var0_2, var1_2)
		end

		if arg0_2.type == 1 then
			for iter2_2, iter3_2 in pairs(arg0_1.redTagTable) do
				if table.contains(var0_2, iter2_2) then
					iter3_2[1] = true
					iter3_2[2] = false
				else
					iter3_2[1] = false
					iter3_2[2] = false
				end
			end
		end
	end)
	arg0_1:on(63316, function(arg0_3)
		print("63316 get meta skill exp info")

		local var0_3 = {}
		local var1_3 = {}
		local var2_3 = arg0_1.metaSkillLevelMaxInfoList or {}

		for iter0_3, iter1_3 in ipairs(arg0_3.skill_info_list) do
			print("shipID", iter1_3.ship_id)

			local var3_3 = iter1_3.ship_id
			local var4_3 = iter1_3.skill_id
			local var5_3 = iter1_3.skill_level
			local var6_3 = iter1_3.skill_exp
			local var7_3 = iter1_3.day_exp
			local var8_3 = iter1_3.add_exp

			arg0_1:addExpToMetaTacticsInfo(iter1_3)
			arg0_1:setLastMetaSkillExpInfo(var1_3, iter1_3)
			arg0_1:setMetaSkillLevelMaxInfo(var2_3, iter1_3)

			local var9_3 = getProxy(BayProxy):getShipById(var3_3)
			local var10_3 = pg.gameset.meta_skill_exp_max.key_value
			local var11_3 = var9_3:getMetaSkillLevelBySkillID(var4_3)
			local var12_3 = var10_3 <= var7_3
			local var13_3 = var11_3 < var5_3

			if var12_3 or var13_3 then
				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_META, {
					metaShipVO = var9_3,
					newDayExp = var7_3,
					addDayExp = var8_3,
					curSkillID = var4_3,
					newSkillLevel = var5_3,
					oldSkillLevel = var11_3
				})
			end

			var9_3:updateSkill({
				skill_id = var4_3,
				skill_lv = var5_3,
				skill_exp = var6_3
			})
			getProxy(BayProxy):updateShip(var9_3)
		end

		if #var2_3 > 0 then
			arg0_1.metaSkillLevelMaxInfoList = var2_3
		end

		if #var1_3 > 0 then
			arg0_1.lastMetaSkillExpInfoList = var1_3
		end
	end)
end

function var0_0.getMetaProgressVOList(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.metaProgressVOList) do
		iter1_4:setDataBeforeGet()
	end

	return arg0_4.metaProgressVOList
end

function var0_0.getMetaProgressVOByID(arg0_5, arg1_5)
	local var0_5 = arg0_5.data[arg1_5]

	assert(var0_5, "progressVO is null:" .. arg1_5)

	if var0_5 then
		var0_5:setDataBeforeGet()
	end

	return var0_5
end

function var0_0.setAllProgressPTData(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg1_6) do
		local var0_6 = iter1_6.group_id
		local var1_6 = arg0_6.data[var0_6]

		assert(var1_6, "Null ProgressVO, ID:", var0_6)
		var1_6.metaPtData:initFromServerData(iter1_6)
	end
end

function var0_0.updateRedTag(arg0_7, arg1_7)
	if arg0_7.redTagTable[arg1_7][1] == true then
		arg0_7.redTagTable[arg1_7][2] = true
	end
end

function var0_0.getRedTag(arg0_8, arg1_8)
	local var0_8 = arg0_8.redTagTable[arg1_8]

	return var0_8[2] == false and var0_8[1] == true
end

function var0_0.isHaveVaildMetaProgressVO(arg0_9)
	local var0_9 = arg0_9:getMetaProgressVOList()

	for iter0_9, iter1_9 in ipairs(var0_9) do
		if iter1_9:isShow() then
			return true
		end
	end

	return false
end

function var0_0.setMetaTacticsInfo(arg0_10, arg1_10)
	arg0_10.metaTacticsInfoTable = arg0_10.metaTacticsInfoTable or {}

	local var0_10 = arg1_10.ship_id
	local var1_10 = MetaTacticsInfo.New(arg1_10)

	if var1_10 then
		arg0_10.metaTacticsInfoTable[var0_10] = var1_10

		var1_10:printInfo()
	else
		errorMessage("Creat MetaTacticsInfo Fail!")
	end
end

function var0_0.addExpToMetaTacticsInfo(arg0_11, arg1_11)
	local var0_11 = arg1_11.ship_id
	local var1_11 = arg0_11.metaTacticsInfoTable[var0_11]

	if var1_11 then
		var1_11:updateExp(arg1_11)
		var1_11:printInfo()
	else
		errorMsg("MetaTacticsInfo is Null", var0_11)
	end
end

function var0_0.switchMetaTacticsSkill(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.metaTacticsInfoTable[arg1_12]

	if var0_12 then
		var0_12:switchSkill(arg2_12)
		var0_12:printInfo()
	else
		errorMsg("MetaTacticsInfo is Null", arg1_12)
	end
end

function var0_0.unlockMetaTacticsSkill(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13.metaTacticsInfoTable = arg0_13.metaTacticsInfoTable or {}

	local var0_13 = arg0_13.metaTacticsInfoTable[arg1_13]

	if var0_13 then
		var0_13:unlockSkill(arg2_13, arg3_13)
	else
		local var1_13 = {
			ship_id = arg1_13,
			exp = arg3_13 and 0,
			skill_id = arg3_13 and arg2_13,
			skill_exp = {
				{
					exp = 0,
					skill_id = arg2_13
				}
			}
		}

		arg0_13.metaTacticsInfoTable[arg1_13] = MetaTacticsInfo.New(var1_13)
	end

	var0_13:printInfo()
end

function var0_0.requestMetaTacticsInfo(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg1_14 or getProxy(BayProxy):getMetaShipIDList()

	if #var0_14 == 0 then
		return
	end

	if arg2_14 then
		arg0_14:sendNotification(GAME.TACTICS_EXP_META_INFO_REQUEST, {
			idList = var0_14
		})
	elseif not arg0_14.metaTacticsInfoTable then
		arg0_14:sendNotification(GAME.TACTICS_EXP_META_INFO_REQUEST, {
			idList = var0_14
		})
	end
end

function var0_0.getMetaTacticsInfoByShipID(arg0_15, arg1_15)
	if not arg0_15.metaTacticsInfoTable then
		return MetaTacticsInfo.New()
	end

	return arg0_15.metaTacticsInfoTable[arg1_15] or MetaTacticsInfo.New()
end

function var0_0.printAllMetaTacticsInfo(arg0_16)
	for iter0_16, iter1_16 in pairs(arg0_16.metaTacticsInfoTable) do
		iter1_16:printInfo()
	end
end

function var0_0.setMetaTacticsInfoOnStart(arg0_17)
	if arg0_17.startRecordTag then
		return
	end

	local var0_17 = true

	if arg0_17.metaTacticsInfoTable then
		for iter0_17, iter1_17 in pairs(arg0_17.metaTacticsInfoTable) do
			if iter1_17 then
				var0_17 = false

				break
			end
		end
	end

	if arg0_17.metaTacticsInfoTable and not var0_17 then
		arg0_17.metaTacticsInfoTableOnStart = Clone(arg0_17.metaTacticsInfoTable)
		arg0_17.startRecordTag = true
	end
end

function var0_0.getMetaTacticsInfoOnEnd(arg0_18)
	if not arg0_18.metaTacticsInfoTableOnStart then
		return false
	end

	local var0_18 = {}
	local var1_18 = arg0_18.metaTacticsInfoTable
	local var2_18 = arg0_18.metaTacticsInfoTableOnStart

	for iter0_18, iter1_18 in pairs(var1_18) do
		local var3_18 = iter1_18.shipID
		local var4_18 = var1_18[var3_18]
		local var5_18 = var2_18[var3_18] or MetaTacticsInfo.New()
		local var6_18 = var4_18:isAnyLearning() and var5_18:isAnyLearning()
		local var7_18 = getProxy(BayProxy):getShipById(var3_18):isAllMetaSkillLevelMax()
		local var8_18 = var5_18 and var5_18:isExpMaxPerDay() or false

		if var6_18 and not var7_18 and not var8_18 then
			local var9_18 = var4_18.curSkillID
			local var10_18 = var4_18.curDayExp - var5_18.curDayExp
			local var11_18 = getProxy(BayProxy):getShipById(var3_18):isSkillLevelMax(var9_18)
			local var12_18 = var10_18 > 0 and var11_18
			local var13_18 = var4_18:isExpMaxPerDay()
			local var14_18 = var5_18.curDayExp / pg.gameset.meta_skill_exp_max.key_value
			local var15_18 = var4_18.curDayExp / pg.gameset.meta_skill_exp_max.key_value

			if var10_18 > 0 then
				table.insert(var0_18, {
					shipID = var3_18,
					addDayExp = var10_18,
					isUpLevel = var12_18,
					isMaxLevel = var11_18,
					isExpMax = var13_18,
					progressOld = var14_18,
					progressNew = var15_18
				})
			end
		end
	end

	arg0_18:clearMetaTacticsInfoRecord()

	return var0_18
end

function var0_0.clearMetaTacticsInfoRecord(arg0_19)
	arg0_19.metaTacticsInfoTableOnStart = nil
	arg0_19.startRecordTag = false
end

function var0_0.setMetaSkillLevelMaxInfo(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg2_20.ship_id
	local var1_20 = arg2_20.skill_id
	local var2_20 = arg2_20.skill_level
	local var3_20 = arg2_20.skill_exp
	local var4_20 = arg2_20.day_exp
	local var5_20 = arg2_20.add_exp
	local var6_20 = getProxy(BayProxy):getShipById(var0_20)
	local var7_20 = var6_20:getMetaSkillLevelBySkillID(var1_20)
	local var8_20 = pg.skill_data_template[var1_20].max_level
	local var9_20 = var7_20 < var2_20
	local var10_20 = var8_20 <= var2_20

	if var9_20 and var10_20 then
		local var11_20 = {
			metaShipVO = var6_20,
			metaSkillID = var1_20
		}
		local var12_20 = false

		for iter0_20, iter1_20 in pairs(arg1_20) do
			if iter1_20.metaShipVO.configId == var11_20.metaShipVO.configId then
				var12_20 = true

				break
			end
		end

		if not var12_20 then
			table.insert(arg1_20, var11_20)
		end
	end
end

function var0_0.getMetaSkillLevelMaxInfoList(arg0_21)
	return arg0_21.metaSkillLevelMaxInfoList or {}
end

function var0_0.clearMetaSkillLevelMaxInfoList(arg0_22)
	arg0_22.metaSkillLevelMaxInfoList = nil
end

function var0_0.tryRemoveMetaSkillLevelMaxInfo(arg0_23, arg1_23, arg2_23)
	if arg0_23.metaSkillLevelMaxInfoList and #arg0_23.metaSkillLevelMaxInfoList > 0 then
		local var0_23

		for iter0_23, iter1_23 in ipairs(arg0_23.metaSkillLevelMaxInfoList) do
			local var1_23 = iter1_23.metaShipVO
			local var2_23 = var1_23.id
			local var3_23 = var1_23.metaSkillID

			if arg1_23 == var2_23 and arg2_23 ~= var3_23 then
				var0_23 = iter0_23

				break
			end
		end

		if var0_23 then
			table.remove(arg0_23.metaSkillLevelMaxInfoList, var0_23)
		end
	end
end

function var0_0.setLastMetaSkillExpInfo(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg2_24.ship_id
	local var1_24 = arg2_24.skill_id
	local var2_24 = arg2_24.skill_level
	local var3_24 = arg2_24.skill_exp
	local var4_24 = arg2_24.day_exp
	local var5_24 = arg2_24.add_exp
	local var6_24 = getProxy(BayProxy):getShipById(var0_24):getMetaSkillLevelBySkillID(var1_24)
	local var7_24 = pg.skill_data_template[var1_24].max_level
	local var8_24 = var6_24 < var2_24
	local var9_24 = var7_24 <= var2_24
	local var10_24 = var4_24 >= pg.gameset.meta_skill_exp_max.key_value

	table.insert(arg1_24, {
		shipID = var0_24,
		addDayExp = var5_24,
		isUpLevel = var8_24,
		isMaxLevel = var9_24,
		isExpMax = var10_24,
		progress = var4_24 / pg.gameset.meta_skill_exp_max.key_value
	})
end

function var0_0.getLastMetaSkillExpInfoList(arg0_25)
	return arg0_25.lastMetaSkillExpInfoList or {}
end

function var0_0.clearLastMetaSkillExpInfoList(arg0_26)
	arg0_26.lastMetaSkillExpInfoList = nil
end

return var0_0
