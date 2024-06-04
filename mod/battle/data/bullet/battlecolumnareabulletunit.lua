ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBulletEvent
local var2 = var0.Battle.BattleFormulas
local var3 = Vector3.up
local var4 = var0.Battle.BattleVariable
local var5 = var0.Battle.BattleConfig
local var6 = var0.Battle.BattleConst
local var7 = var0.Battle.BattleTargetChoise
local var8 = class("BattleColumnAreaBulletUnit", var0.Battle.BattleAreaBulletUnit)

var8.__name = "BattleColumnAreaBulletUnit"
var0.Battle.BattleColumnAreaBulletUnit = var8
var8.AreaType = var6.AreaType.COLUMN

function var8.InitCldComponent(arg0)
	local var0 = arg0:GetTemplate().cld_box
	local var1 = arg0:GetTemplate().cld_offset

	arg0._cldComponent = var0.Battle.BattleColumnCldComponent.New(var0[1], var0[3])

	local var2 = {
		type = var6.CldType.AOE,
		UID = arg0:GetUniqueID(),
		IFF = arg0:GetIFF()
	}

	arg0._cldComponent:SetCldData(var2)
end

function var8.GetBoxSize(arg0)
	local var0 = arg0._cldComponent:GetCldBoxSize()

	return Vector3(var0.range, var0.range, var0.tickness)
end
