ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = pg.effect_offset

var0.Battle.BattleShelterData = class("BattleShelterData")
var0.Battle.BattleShelterData.__name = "BattleShelterData"

local var3 = var0.Battle.BattleShelterData

function var3.Ctor(arg0, arg1)
	arg0._id = arg1
end

function var3.SetIFF(arg0, arg1)
	arg0._IFF = arg1
end

function var3.SetArgs(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._duration = arg2
	arg0._bulletType = var0.Battle.BattleConst.BulletType.CANNON
	arg0._count = arg1
	arg0._effect = arg5
	arg0._doWhenHit = "intercept"

	local function var0(arg0)
		if arg0:GetType() == arg0._bulletType and arg0:IsWallActive() then
			arg0:DoWhenHit(arg0)
		end

		return arg0._count > 0
	end

	local var1 = {
		0,
		0,
		0
	}

	arg0._wall = var0.Battle.BattleDataProxy.GetInstance():SpawnWall(arg0, var0, arg3, var1)
	arg0._centerPos = arg4
end

function var3.SetStartTimeStamp(arg0, arg1)
	arg0._startTimeStamp = arg1
end

function var3.Update(arg0, arg1)
	if arg1 - arg0._startTimeStamp > arg0._duration then
		arg0._startTimeStamp = nil
	end
end

function var3.DoWhenHit(arg0, arg1)
	if arg0._doWhenHit == "intercept" then
		arg1:Intercepted()
		var0.Battle.BattleDataProxy.GetInstance():RemoveBulletUnit(arg1:GetUniqueID())

		arg0._count = arg0._count - 1
	elseif arg0._doWhenHit == "reflect" and arg0:GetIFF() ~= arg1:GetIFF() then
		arg1:Reflected()

		arg0._count = arg0._count - 1
	end
end

function var3.GetUniqueID(arg0)
	return arg0._id
end

function var3.GetIFF(arg0)
	return arg0._IFF
end

function var3.GetFXID(arg0)
	return arg0._effect
end

function var3.GetPosition(arg0)
	return arg0._centerPos
end

function var3.Deactive(arg0)
	var0.Battle.BattleDataProxy.GetInstance():RemoveWall(arg0._wall:GetUniqueID())
end

function var3.IsWallActive(arg0)
	return arg0._count > 0 and arg0._startTimeStamp
end
