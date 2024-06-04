local var0 = class("MetaCharacterProxy", import(".NetProxy"))

var0.METAPROGRESS_UPDATED = "MetaCharacterProxy:METAPROGRESS_UPDATED"

local var1 = pg.ship_strengthen_meta

function var0.register(arg0)
	arg0.data = {}
	arg0.metaProgressVOList = {}
	arg0.metaTacticsInfoTable = nil
	arg0.metaTacticsInfoTableOnStart = nil
	arg0.metaSkillLevelMaxInfoList = nil
	arg0.lastMetaSkillExpInfoList = nil
	arg0.startRecordTag = false

	for iter0, iter1 in pairs(var1.all) do
		local var0 = MetaProgress.New({
			id = iter1
		})

		arg0.data[iter1] = var0

		table.insert(arg0.metaProgressVOList, var0)
	end

	arg0.redTagTable = {}

	for iter2, iter3 in pairs(var1.all) do
		arg0.redTagTable[iter3] = {
			false,
			false
		}
	end

	arg0:on(63315, function(arg0)
		print("63315 get red tag info")

		local var0 = {}

		for iter0, iter1 in ipairs(arg0.arg1) do
			local var1 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(iter1)

			table.insert(var0, var1)
		end

		if arg0.type == 1 then
			for iter2, iter3 in pairs(arg0.redTagTable) do
				if table.contains(var0, iter2) then
					iter3[1] = true
					iter3[2] = false
				else
					iter3[1] = false
					iter3[2] = false
				end
			end
		end
	end)
	arg0:on(63316, function(arg0)
		print("63316 get meta skill exp info")

		local var0 = {}
		local var1 = {}
		local var2 = arg0.metaSkillLevelMaxInfoList or {}

		for iter0, iter1 in ipairs(arg0.skill_info_list) do
			print("shipID", iter1.ship_id)

			local var3 = iter1.ship_id
			local var4 = iter1.skill_id
			local var5 = iter1.skill_level
			local var6 = iter1.skill_exp
			local var7 = iter1.day_exp
			local var8 = iter1.add_exp

			arg0:addExpToMetaTacticsInfo(iter1)
			arg0:setLastMetaSkillExpInfo(var1, iter1)
			arg0:setMetaSkillLevelMaxInfo(var2, iter1)

			local var9 = getProxy(BayProxy):getShipById(var3)
			local var10 = pg.gameset.meta_skill_exp_max.key_value
			local var11 = var9:getMetaSkillLevelBySkillID(var4)
			local var12 = var10 <= var7
			local var13 = var11 < var5

			if var12 or var13 then
				pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_META, {
					metaShipVO = var9,
					newDayExp = var7,
					addDayExp = var8,
					curSkillID = var4,
					newSkillLevel = var5,
					oldSkillLevel = var11
				})
			end

			var9:updateSkill({
				skill_id = var4,
				skill_lv = var5,
				skill_exp = var6
			})
			getProxy(BayProxy):updateShip(var9)
		end

		if #var2 > 0 then
			arg0.metaSkillLevelMaxInfoList = var2
		end

		if #var1 > 0 then
			arg0.lastMetaSkillExpInfoList = var1
		end
	end)
end

function var0.getMetaProgressVOList(arg0)
	for iter0, iter1 in ipairs(arg0.metaProgressVOList) do
		iter1:setDataBeforeGet()
	end

	return arg0.metaProgressVOList
end

function var0.getMetaProgressVOByID(arg0, arg1)
	local var0 = arg0.data[arg1]

	assert(var0, "progressVO is null:" .. arg1)

	if var0 then
		var0:setDataBeforeGet()
	end

	return var0
end

function var0.setAllProgressPTData(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1.group_id
		local var1 = arg0.data[var0]

		assert(var1, "Null ProgressVO, ID:", var0)
		var1.metaPtData:initFromServerData(iter1)
	end
end

function var0.updateRedTag(arg0, arg1)
	if arg0.redTagTable[arg1][1] == true then
		arg0.redTagTable[arg1][2] = true
	end
end

function var0.getRedTag(arg0, arg1)
	local var0 = arg0.redTagTable[arg1]

	return var0[2] == false and var0[1] == true
end

function var0.isHaveVaildMetaProgressVO(arg0)
	local var0 = arg0:getMetaProgressVOList()

	for iter0, iter1 in ipairs(var0) do
		if iter1:isShow() then
			return true
		end
	end

	return false
end

function var0.setMetaTacticsInfo(arg0, arg1)
	arg0.metaTacticsInfoTable = arg0.metaTacticsInfoTable or {}

	local var0 = arg1.ship_id
	local var1 = MetaTacticsInfo.New(arg1)

	if var1 then
		arg0.metaTacticsInfoTable[var0] = var1

		var1:printInfo()
	else
		errorMessage("Creat MetaTacticsInfo Fail!")
	end
end

function var0.addExpToMetaTacticsInfo(arg0, arg1)
	local var0 = arg1.ship_id
	local var1 = arg0.metaTacticsInfoTable[var0]

	if var1 then
		var1:updateExp(arg1)
		var1:printInfo()
	else
		errorMsg("MetaTacticsInfo is Null", var0)
	end
end

function var0.switchMetaTacticsSkill(arg0, arg1, arg2)
	local var0 = arg0.metaTacticsInfoTable[arg1]

	if var0 then
		var0:switchSkill(arg2)
		var0:printInfo()
	else
		errorMsg("MetaTacticsInfo is Null", arg1)
	end
end

function var0.unlockMetaTacticsSkill(arg0, arg1, arg2, arg3)
	arg0.metaTacticsInfoTable = arg0.metaTacticsInfoTable or {}

	local var0 = arg0.metaTacticsInfoTable[arg1]

	if var0 then
		var0:unlockSkill(arg2, arg3)
	else
		local var1 = {
			ship_id = arg1,
			exp = arg3 and 0,
			skill_id = arg3 and arg2,
			skill_exp = {
				{
					exp = 0,
					skill_id = arg2
				}
			}
		}

		arg0.metaTacticsInfoTable[arg1] = MetaTacticsInfo.New(var1)
	end

	var0:printInfo()
end

function var0.requestMetaTacticsInfo(arg0, arg1, arg2)
	local var0 = arg1 or getProxy(BayProxy):getMetaShipIDList()

	if #var0 == 0 then
		return
	end

	if arg2 then
		arg0:sendNotification(GAME.TACTICS_EXP_META_INFO_REQUEST, {
			idList = var0
		})
	elseif not arg0.metaTacticsInfoTable then
		arg0:sendNotification(GAME.TACTICS_EXP_META_INFO_REQUEST, {
			idList = var0
		})
	end
end

function var0.getMetaTacticsInfoByShipID(arg0, arg1)
	if not arg0.metaTacticsInfoTable then
		return MetaTacticsInfo.New()
	end

	return arg0.metaTacticsInfoTable[arg1] or MetaTacticsInfo.New()
end

function var0.printAllMetaTacticsInfo(arg0)
	for iter0, iter1 in pairs(arg0.metaTacticsInfoTable) do
		iter1:printInfo()
	end
end

function var0.setMetaTacticsInfoOnStart(arg0)
	if arg0.startRecordTag then
		return
	end

	local var0 = true

	if arg0.metaTacticsInfoTable then
		for iter0, iter1 in pairs(arg0.metaTacticsInfoTable) do
			if iter1 then
				var0 = false

				break
			end
		end
	end

	if arg0.metaTacticsInfoTable and not var0 then
		arg0.metaTacticsInfoTableOnStart = Clone(arg0.metaTacticsInfoTable)
		arg0.startRecordTag = true
	end
end

function var0.getMetaTacticsInfoOnEnd(arg0)
	if not arg0.metaTacticsInfoTableOnStart then
		return false
	end

	local var0 = {}
	local var1 = arg0.metaTacticsInfoTable
	local var2 = arg0.metaTacticsInfoTableOnStart

	for iter0, iter1 in pairs(var1) do
		local var3 = iter1.shipID
		local var4 = var1[var3]
		local var5 = var2[var3] or MetaTacticsInfo.New()
		local var6 = var4:isAnyLearning() and var5:isAnyLearning()
		local var7 = getProxy(BayProxy):getShipById(var3):isAllMetaSkillLevelMax()
		local var8 = var5 and var5:isExpMaxPerDay() or false

		if var6 and not var7 and not var8 then
			local var9 = var4.curSkillID
			local var10 = var4.curDayExp - var5.curDayExp
			local var11 = getProxy(BayProxy):getShipById(var3):isSkillLevelMax(var9)
			local var12 = var10 > 0 and var11
			local var13 = var4:isExpMaxPerDay()
			local var14 = var5.curDayExp / pg.gameset.meta_skill_exp_max.key_value
			local var15 = var4.curDayExp / pg.gameset.meta_skill_exp_max.key_value

			if var10 > 0 then
				table.insert(var0, {
					shipID = var3,
					addDayExp = var10,
					isUpLevel = var12,
					isMaxLevel = var11,
					isExpMax = var13,
					progressOld = var14,
					progressNew = var15
				})
			end
		end
	end

	arg0:clearMetaTacticsInfoRecord()

	return var0
end

function var0.clearMetaTacticsInfoRecord(arg0)
	arg0.metaTacticsInfoTableOnStart = nil
	arg0.startRecordTag = false
end

function var0.setMetaSkillLevelMaxInfo(arg0, arg1, arg2)
	local var0 = arg2.ship_id
	local var1 = arg2.skill_id
	local var2 = arg2.skill_level
	local var3 = arg2.skill_exp
	local var4 = arg2.day_exp
	local var5 = arg2.add_exp
	local var6 = getProxy(BayProxy):getShipById(var0)
	local var7 = var6:getMetaSkillLevelBySkillID(var1)
	local var8 = pg.skill_data_template[var1].max_level
	local var9 = var7 < var2
	local var10 = var8 <= var2

	if var9 and var10 then
		local var11 = {
			metaShipVO = var6,
			metaSkillID = var1
		}
		local var12 = false

		for iter0, iter1 in pairs(arg1) do
			if iter1.metaShipVO.configId == var11.metaShipVO.configId then
				var12 = true

				break
			end
		end

		if not var12 then
			table.insert(arg1, var11)
		end
	end
end

function var0.getMetaSkillLevelMaxInfoList(arg0)
	return arg0.metaSkillLevelMaxInfoList or {}
end

function var0.clearMetaSkillLevelMaxInfoList(arg0)
	arg0.metaSkillLevelMaxInfoList = nil
end

function var0.tryRemoveMetaSkillLevelMaxInfo(arg0, arg1, arg2)
	if arg0.metaSkillLevelMaxInfoList and #arg0.metaSkillLevelMaxInfoList > 0 then
		local var0

		for iter0, iter1 in ipairs(arg0.metaSkillLevelMaxInfoList) do
			local var1 = iter1.metaShipVO
			local var2 = var1.id
			local var3 = var1.metaSkillID

			if arg1 == var2 and arg2 ~= var3 then
				var0 = iter0

				break
			end
		end

		if var0 then
			table.remove(arg0.metaSkillLevelMaxInfoList, var0)
		end
	end
end

function var0.setLastMetaSkillExpInfo(arg0, arg1, arg2)
	local var0 = arg2.ship_id
	local var1 = arg2.skill_id
	local var2 = arg2.skill_level
	local var3 = arg2.skill_exp
	local var4 = arg2.day_exp
	local var5 = arg2.add_exp
	local var6 = getProxy(BayProxy):getShipById(var0):getMetaSkillLevelBySkillID(var1)
	local var7 = pg.skill_data_template[var1].max_level
	local var8 = var6 < var2
	local var9 = var7 <= var2
	local var10 = var4 >= pg.gameset.meta_skill_exp_max.key_value

	table.insert(arg1, {
		shipID = var0,
		addDayExp = var5,
		isUpLevel = var8,
		isMaxLevel = var9,
		isExpMax = var10,
		progress = var4 / pg.gameset.meta_skill_exp_max.key_value
	})
end

function var0.getLastMetaSkillExpInfoList(arg0)
	return arg0.lastMetaSkillExpInfoList or {}
end

function var0.clearLastMetaSkillExpInfoList(arg0)
	arg0.lastMetaSkillExpInfoList = nil
end

return var0
