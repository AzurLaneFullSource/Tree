ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleSkillProjectShelter", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillProjectShelter = var3_0
var3_0.__name = "BattleSkillProjectShelter"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	var3_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._duration = arg0_1._tempData.arg_list.duration
	arg0_1._offset = arg0_1._tempData.arg_list.offset
	arg0_1._fxID = arg0_1._tempData.arg_list.effect
	arg0_1._box = arg0_1._tempData.arg_list.box
	arg0_1._count = arg0_1._tempData.arg_list.count
end

function var3_0.DoDataEffect(arg0_2, arg1_2)
	local var0_2 = var0_0.Battle.BattleDataProxy.GetInstance()
	local var1_2 = var0_2:SpawnShelter(arg0_2._box, arg0_2._duration)
	local var2_2 = arg1_2:GetIFF()

	if var2_2 == var2_0.FOE_CODE then
		arg0_2._offset[1] = arg0_2._offset[1] * -1
	end

	local var3_2 = arg1_2:GetPosition() + BuildVector3(arg0_2._offset)

	var1_2:SetIFF(var2_2)
	var1_2:SetArgs(arg0_2._count, arg0_2._duration, arg0_2._box, var3_2, arg0_2._fxID)
	var1_2:SetStartTimeStamp(pg.TimeMgr.GetInstance():GetCombatTime())

	local var4_2 = {
		shelter = var1_2
	}

	var0_2:DispatchEvent(var0_0.Event.New(var1_0.ADD_SHELTER, var4_2))
end

function var3_0.DataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:DoDataEffect(arg1_3)
end
