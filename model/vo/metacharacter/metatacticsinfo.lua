local var0_0 = class("MetaTacticsInfo")

function var0_0.Ctor(arg0_1, arg1_1)
	if arg1_1 then
		arg0_1.shipID = arg1_1.ship_id
		arg0_1.curDayExp = arg1_1.exp
		arg0_1.curSkillID = arg1_1.skill_id
		arg0_1.skillExpInfoTable = {}

		for iter0_1, iter1_1 in ipairs(arg1_1.skill_exp) do
			local var0_1 = iter1_1.skill_id
			local var1_1 = iter1_1.exp

			arg0_1.skillExpInfoTable[var0_1] = var1_1
		end
	else
		arg0_1.shipID = nil
		arg0_1.curDayExp = 0
		arg0_1.curSkillID = nil
		arg0_1.skillExpInfoTable = {}
	end
end

function var0_0.updateExp(arg0_2, arg1_2)
	local var0_2 = arg1_2.day_exp
	local var1_2 = arg1_2.skill_id
	local var2_2 = arg1_2.skill_exp

	arg0_2.curDayExp = var0_2
	arg0_2.skillExpInfoTable[var1_2] = var2_2
end

function var0_0.setNewExp(arg0_3, arg1_3, arg2_3)
	arg0_3.skillExpInfoTable[arg1_3] = arg2_3

	arg0_3:printInfo()
end

function var0_0.switchSkill(arg0_4, arg1_4)
	arg0_4.curSkillID = arg1_4
end

function var0_0.unlockSkill(arg0_5, arg1_5, arg2_5)
	arg0_5.skillExpInfoTable[arg1_5] = 0

	if arg2_5 then
		arg0_5.curSkillID = arg1_5
	end
end

function var0_0.getSkillExp(arg0_6, arg1_6)
	return arg0_6.skillExpInfoTable[arg1_6] or 0
end

function var0_0.isExpMaxPerDay(arg0_7)
	return arg0_7.curDayExp >= pg.gameset.meta_skill_exp_max.key_value
end

function var0_0.isAnyLearning(arg0_8)
	return arg0_8.curSkillID and arg0_8.curSkillID > 0
end

var0_0.States = {
	LearnAble = 1,
	LearnFinished = 3,
	None = 0,
	Learning = 2
}

function var0_0.getTacticsStateForShow(arg0_9)
	local var0_9 = arg0_9:isAnyLearning()
	local var1_9 = getProxy(BayProxy):getShipById(arg0_9.shipID)
	local var2_9 = var1_9 and var1_9:isAllMetaSkillLevelMax() or false

	if not var0_9 and not var2_9 then
		return var0_0.States.LearnAble
	elseif var0_9 then
		if getProxy(BayProxy):getShipById(arg0_9.shipID):isSkillLevelMax(arg0_9.curSkillID) then
			if not var2_9 then
				local var3_9 = getProxy(BayProxy):getShipById(arg0_9.shipID):getGroupId()

				if not MetaCharacterConst.isMetaTacticsRedTag(var3_9) then
					return var0_0.States.LearnAble
				end
			end

			return var0_0.States.LearnFinished
		else
			return var0_0.States.Learning
		end
	else
		return var0_0.States.None
	end
end

function var0_0.printInfo(arg0_10)
	return
end

return var0_0
