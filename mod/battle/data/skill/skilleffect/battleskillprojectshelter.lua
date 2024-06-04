ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleSkillProjectShelter", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillProjectShelter = var3
var3.__name = "BattleSkillProjectShelter"

function var3.Ctor(arg0, arg1, arg2)
	var3.super.Ctor(arg0, arg1, arg2)

	arg0._duration = arg0._tempData.arg_list.duration
	arg0._offset = arg0._tempData.arg_list.offset
	arg0._fxID = arg0._tempData.arg_list.effect
	arg0._box = arg0._tempData.arg_list.box
	arg0._count = arg0._tempData.arg_list.count
end

function var3.DoDataEffect(arg0, arg1)
	local var0 = var0.Battle.BattleDataProxy.GetInstance()
	local var1 = var0:SpawnShelter(arg0._box, arg0._duration)
	local var2 = arg1:GetIFF()

	if var2 == var2.FOE_CODE then
		arg0._offset[1] = arg0._offset[1] * -1
	end

	local var3 = arg1:GetPosition() + BuildVector3(arg0._offset)

	var1:SetIFF(var2)
	var1:SetArgs(arg0._count, arg0._duration, arg0._box, var3, arg0._fxID)
	var1:SetStartTimeStamp(pg.TimeMgr.GetInstance():GetCombatTime())

	local var4 = {
		shelter = var1
	}

	var0:DispatchEvent(var0.Event.New(var1.ADD_SHELTER, var4))
end

function var3.DataEffectWithoutTarget(arg0, arg1)
	arg0:DoDataEffect(arg1)
end
