ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleConfig
local var5 = var0.Battle.BattleDataFunction
local var6 = class("BattleTeamVO")

var0.Battle.BattleTeamVO = var6
var6.__name = "BattleTeamVO"

function var6.Ctor(arg0, arg1)
	arg0._teamID = arg1

	arg0:init()
end

function var6.UpdateMotion(arg0)
	if arg0._motionReferenceUnit then
		arg0._motionVO:UpdatePos(arg0._motionReferenceUnit)
		arg0._motionVO:UpdateSpeed(arg0._motionReferenceUnit:GetSpeed())
	end
end

function var6.IsFatalDamage(arg0)
	return arg0._count == 0
end

function var6.AppendUnit(arg0, arg1)
	arg1:SetMotion(arg0._motionVO)

	arg0._enemyList[#arg0._enemyList + 1] = arg1
	arg0._count = arg0._count + 1

	arg0:refreshTeamFormation()
	arg1:SetTeamVO(arg0)
end

function var6.RemoveUnit(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0._enemyList) do
		if iter1 == arg1 then
			var0 = iter0

			break
		end
	end

	table.remove(arg0._enemyList, var0)

	arg0._count = arg0._count - 1

	arg1:SetTeamVO(nil)
	arg0:refreshTeamFormation()
end

function var6.init(arg0)
	arg0._enemyList = {}
	arg0._motionVO = var0.Battle.BattleFleetMotionVO.New()
	arg0._count = 0
end

function var6.refreshTeamFormation(arg0)
	local var0 = 1
	local var1 = #arg0._enemyList
	local var2 = {}

	while var0 <= var1 do
		var2[#var2 + 1] = var0
		var0 = var0 + 1
	end

	local var3 = var5.GetFormationTmpDataFromID(var4.FORMATION_ID).pos_offset

	arg0._enemyList = var5.SortFleetList(var2, arg0._enemyList)

	local var4 = var4.BornOffset

	for iter0, iter1 in ipairs(arg0._enemyList) do
		if iter0 == 1 then
			arg0._motionReferenceUnit = iter1

			iter1:CancelFollowTeam()
		else
			local var5 = var3[iter0]

			iter1:UpdateFormationOffset(Vector3(var5.x, var5.y, var5.z) + var4 * (iter0 - 1))
		end
	end
end

function var6.Dispose(arg0)
	arg0._enemyList = nil
	arg0._motionReferenceUnit = nil
	arg0._motionVO = nil
end
