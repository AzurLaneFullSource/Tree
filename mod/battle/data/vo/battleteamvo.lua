ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = var0_0.Battle.BattleDataFunction
local var6_0 = class("BattleTeamVO")

var0_0.Battle.BattleTeamVO = var6_0
var6_0.__name = "BattleTeamVO"

function var6_0.Ctor(arg0_1, arg1_1)
	arg0_1._teamID = arg1_1

	arg0_1:init()
end

function var6_0.UpdateMotion(arg0_2)
	if arg0_2._motionReferenceUnit then
		arg0_2._motionVO:UpdatePos(arg0_2._motionReferenceUnit)
		arg0_2._motionVO:UpdateSpeed(arg0_2._motionReferenceUnit:GetSpeed())
	end
end

function var6_0.IsFatalDamage(arg0_3)
	return arg0_3._count == 0
end

function var6_0.AppendUnit(arg0_4, arg1_4)
	arg1_4:SetMotion(arg0_4._motionVO)

	arg0_4._enemyList[#arg0_4._enemyList + 1] = arg1_4
	arg0_4._count = arg0_4._count + 1

	arg0_4:refreshTeamFormation()
	arg1_4:SetTeamVO(arg0_4)
end

function var6_0.RemoveUnit(arg0_5, arg1_5)
	local var0_5 = 0

	for iter0_5, iter1_5 in ipairs(arg0_5._enemyList) do
		if iter1_5 == arg1_5 then
			var0_5 = iter0_5

			break
		end
	end

	table.remove(arg0_5._enemyList, var0_5)

	arg0_5._count = arg0_5._count - 1

	arg1_5:SetTeamVO(nil)
	arg0_5:refreshTeamFormation()
end

function var6_0.init(arg0_6)
	arg0_6._enemyList = {}
	arg0_6._motionVO = var0_0.Battle.BattleFleetMotionVO.New()
	arg0_6._count = 0
end

function var6_0.refreshTeamFormation(arg0_7)
	local var0_7 = 1
	local var1_7 = #arg0_7._enemyList
	local var2_7 = {}

	while var0_7 <= var1_7 do
		var2_7[#var2_7 + 1] = var0_7
		var0_7 = var0_7 + 1
	end

	local var3_7 = var5_0.GetFormationTmpDataFromID(var4_0.FORMATION_ID).pos_offset

	arg0_7._enemyList = var5_0.SortFleetList(var2_7, arg0_7._enemyList)

	local var4_7 = var4_0.BornOffset

	for iter0_7, iter1_7 in ipairs(arg0_7._enemyList) do
		if iter0_7 == 1 then
			arg0_7._motionReferenceUnit = iter1_7

			iter1_7:CancelFollowTeam()
		else
			local var5_7 = var3_7[iter0_7]

			iter1_7:UpdateFormationOffset(Vector3(var5_7.x, var5_7.y, var5_7.z) + var4_7 * (iter0_7 - 1))
		end
	end
end

function var6_0.Dispose(arg0_8)
	arg0_8._enemyList = nil
	arg0_8._motionReferenceUnit = nil
	arg0_8._motionVO = nil
end
