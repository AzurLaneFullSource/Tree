local var0 = class("MetaTacticsInfo")

function var0.Ctor(arg0, arg1)
	if arg1 then
		arg0.shipID = arg1.ship_id
		arg0.curDayExp = arg1.exp
		arg0.curSkillID = arg1.skill_id
		arg0.skillExpInfoTable = {}

		for iter0, iter1 in ipairs(arg1.skill_exp) do
			local var0 = iter1.skill_id
			local var1 = iter1.exp

			arg0.skillExpInfoTable[var0] = var1
		end
	else
		arg0.shipID = nil
		arg0.curDayExp = 0
		arg0.curSkillID = nil
		arg0.skillExpInfoTable = {}
	end
end

function var0.updateExp(arg0, arg1)
	local var0 = arg1.day_exp
	local var1 = arg1.skill_id
	local var2 = arg1.skill_exp

	arg0.curDayExp = var0
	arg0.skillExpInfoTable[var1] = var2
end

function var0.setNewExp(arg0, arg1, arg2)
	arg0.skillExpInfoTable[arg1] = arg2

	arg0:printInfo()
end

function var0.switchSkill(arg0, arg1)
	arg0.curSkillID = arg1
end

function var0.unlockSkill(arg0, arg1, arg2)
	arg0.skillExpInfoTable[arg1] = 0

	if arg2 then
		arg0.curSkillID = arg1
	end
end

function var0.getSkillExp(arg0, arg1)
	return arg0.skillExpInfoTable[arg1] or 0
end

function var0.isExpMaxPerDay(arg0)
	return arg0.curDayExp >= pg.gameset.meta_skill_exp_max.key_value
end

function var0.isAnyLearning(arg0)
	return arg0.curSkillID and arg0.curSkillID > 0
end

var0.States = {
	LearnAble = 1,
	LearnFinished = 3,
	None = 0,
	Learning = 2
}

function var0.getTacticsStateForShow(arg0)
	local var0 = arg0:isAnyLearning()
	local var1 = getProxy(BayProxy):getShipById(arg0.shipID)
	local var2 = var1 and var1:isAllMetaSkillLevelMax() or false

	if not var0 and not var2 then
		return var0.States.LearnAble
	elseif var0 then
		if getProxy(BayProxy):getShipById(arg0.shipID):isSkillLevelMax(arg0.curSkillID) then
			if not var2 then
				local var3 = getProxy(BayProxy):getShipById(arg0.shipID):getGroupId()

				if not MetaCharacterConst.isMetaTacticsRedTag(var3) then
					return var0.States.LearnAble
				end
			end

			return var0.States.LearnFinished
		else
			return var0.States.Learning
		end
	else
		return var0.States.None
	end
end

function var0.printInfo(arg0)
	return
end

return var0
