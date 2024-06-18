ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleWallData = class("BattleWallData")
var0_0.Battle.BattleWallData.__name = "BattleWallData"

local var2_0 = var0_0.Battle.BattleWallData

var2_0.CLD_OBJ_TYPE_BULLET = 1
var2_0.CLD_OBJ_TYPE_SHIP = 2

function var2_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1._id = arg1_1
	arg0_1._host = arg2_1
	arg0_1._cldFun = arg3_1
	arg0_1._cldBox = arg4_1
	arg0_1._cldOffset = arg5_1

	arg0_1:InitCldComponent()
end

function var2_0.InitCldComponent(arg0_2)
	local var0_2 = arg0_2._cldBox
	local var1_2 = arg0_2._cldOffset

	if var0_2.range then
		arg0_2._cldComponent = var0_0.Battle.BattleColumnCldComponent.New(var0_2.range, 5, var1_2[1], var1_2[3])
	else
		arg0_2._cldComponent = var0_0.Battle.BattleCubeCldComponent.New(var0_2[1], var0_2[2], var0_2[3], var1_2[1], var1_2[3])
	end

	local var2_2 = {
		type = var1_0.CldType.WALL,
		UID = arg0_2:GetUniqueID(),
		func = arg0_2:GetCldFunc()
	}

	arg0_2._cldComponent:SetCldData(var2_2)
	arg0_2._cldComponent:SetActive(true)
	arg0_2:SetCldObjType()
end

function var2_0.IsActive(arg0_3)
	return arg0_3._host:IsWallActive()
end

function var2_0.DeactiveCldBox(arg0_4)
	arg0_4._cldComponent:SetActive(false)
end

function var2_0.GetCldBox(arg0_5)
	return arg0_5._cldComponent:GetCldBox(arg0_5:GetPosition())
end

function var2_0.GetCldData(arg0_6)
	return arg0_6._cldComponent:GetCldData()
end

function var2_0.GetBoxSize(arg0_7)
	return arg0_7._cldComponent:GetCldBoxSize()
end

function var2_0.GetHost(arg0_8)
	return arg0_8._host
end

function var2_0.GetIFF(arg0_9)
	return arg0_9:GetHost():GetIFF()
end

function var2_0.GetPosition(arg0_10)
	return arg0_10:GetHost():GetPosition()
end

function var2_0.GetUniqueID(arg0_11)
	return arg0_11._id
end

function var2_0.GetCldFunc(arg0_12)
	return arg0_12._cldFun
end

function var2_0.SetCldObjType(arg0_13, arg1_13)
	arg0_13._cldObjType = arg1_13 or var2_0.CLD_OBJ_TYPE_BULLET
end

function var2_0.GetCldObjType(arg0_14)
	return arg0_14._cldObjType
end
