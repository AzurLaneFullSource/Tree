ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = pg.effect_offset

var0_0.Battle.BattleShelterData = class("BattleShelterData")
var0_0.Battle.BattleShelterData.__name = "BattleShelterData"

local var3_0 = var0_0.Battle.BattleShelterData

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._id = arg1_1
end

function var3_0.SetIFF(arg0_2, arg1_2)
	arg0_2._IFF = arg1_2
end

function var3_0.SetArgs(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	arg0_3._duration = arg2_3
	arg0_3._bulletType = var0_0.Battle.BattleConst.BulletType.CANNON
	arg0_3._count = arg1_3
	arg0_3._effect = arg5_3
	arg0_3._doWhenHit = "intercept"

	local function var0_3(arg0_4)
		if arg0_4:GetType() == arg0_3._bulletType and arg0_3:IsWallActive() then
			arg0_3:DoWhenHit(arg0_4)
		end

		return arg0_3._count > 0
	end

	local var1_3 = {
		0,
		0,
		0
	}

	arg0_3._wall = var0_0.Battle.BattleDataProxy.GetInstance():SpawnWall(arg0_3, var0_3, arg3_3, var1_3)
	arg0_3._centerPos = arg4_3
end

function var3_0.SetStartTimeStamp(arg0_5, arg1_5)
	arg0_5._startTimeStamp = arg1_5
end

function var3_0.Update(arg0_6, arg1_6)
	if arg1_6 - arg0_6._startTimeStamp > arg0_6._duration then
		arg0_6._startTimeStamp = nil
	end
end

function var3_0.DoWhenHit(arg0_7, arg1_7)
	if arg0_7._doWhenHit == "intercept" then
		arg1_7:Intercepted()
		var0_0.Battle.BattleDataProxy.GetInstance():RemoveBulletUnit(arg1_7:GetUniqueID())

		arg0_7._count = arg0_7._count - 1
	elseif arg0_7._doWhenHit == "reflect" and arg0_7:GetIFF() ~= arg1_7:GetIFF() then
		arg1_7:Reflected()

		arg0_7._count = arg0_7._count - 1
	end
end

function var3_0.GetUniqueID(arg0_8)
	return arg0_8._id
end

function var3_0.GetIFF(arg0_9)
	return arg0_9._IFF
end

function var3_0.GetFXID(arg0_10)
	return arg0_10._effect
end

function var3_0.GetPosition(arg0_11)
	return arg0_11._centerPos
end

function var3_0.Deactive(arg0_12)
	var0_0.Battle.BattleDataProxy.GetInstance():RemoveWall(arg0_12._wall:GetUniqueID())
end

function var3_0.IsWallActive(arg0_13)
	return arg0_13._count > 0 and arg0_13._startTimeStamp
end
