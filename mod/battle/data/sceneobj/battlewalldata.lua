ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst

var0.Battle.BattleWallData = class("BattleWallData")
var0.Battle.BattleWallData.__name = "BattleWallData"

local var2 = var0.Battle.BattleWallData

var2.CLD_OBJ_TYPE_BULLET = 1
var2.CLD_OBJ_TYPE_SHIP = 2

function var2.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._id = arg1
	arg0._host = arg2
	arg0._cldFun = arg3
	arg0._cldBox = arg4
	arg0._cldOffset = arg5

	arg0:InitCldComponent()
end

function var2.InitCldComponent(arg0)
	local var0 = arg0._cldBox
	local var1 = arg0._cldOffset

	if var0.range then
		arg0._cldComponent = var0.Battle.BattleColumnCldComponent.New(var0.range, 5, var1[1], var1[3])
	else
		arg0._cldComponent = var0.Battle.BattleCubeCldComponent.New(var0[1], var0[2], var0[3], var1[1], var1[3])
	end

	local var2 = {
		type = var1.CldType.WALL,
		UID = arg0:GetUniqueID(),
		func = arg0:GetCldFunc()
	}

	arg0._cldComponent:SetCldData(var2)
	arg0._cldComponent:SetActive(true)
	arg0:SetCldObjType()
end

function var2.IsActive(arg0)
	return arg0._host:IsWallActive()
end

function var2.DeactiveCldBox(arg0)
	arg0._cldComponent:SetActive(false)
end

function var2.GetCldBox(arg0)
	return arg0._cldComponent:GetCldBox(arg0:GetPosition())
end

function var2.GetCldData(arg0)
	return arg0._cldComponent:GetCldData()
end

function var2.GetBoxSize(arg0)
	return arg0._cldComponent:GetCldBoxSize()
end

function var2.GetHost(arg0)
	return arg0._host
end

function var2.GetIFF(arg0)
	return arg0:GetHost():GetIFF()
end

function var2.GetPosition(arg0)
	return arg0:GetHost():GetPosition()
end

function var2.GetUniqueID(arg0)
	return arg0._id
end

function var2.GetCldFunc(arg0)
	return arg0._cldFun
end

function var2.SetCldObjType(arg0, arg1)
	arg0._cldObjType = arg1 or var2.CLD_OBJ_TYPE_BULLET
end

function var2.GetCldObjType(arg0)
	return arg0._cldObjType
end
