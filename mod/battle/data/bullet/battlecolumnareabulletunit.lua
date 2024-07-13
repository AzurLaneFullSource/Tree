ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBulletEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = Vector3.up
local var4_0 = var0_0.Battle.BattleVariable
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleConst
local var7_0 = var0_0.Battle.BattleTargetChoise
local var8_0 = class("BattleColumnAreaBulletUnit", var0_0.Battle.BattleAreaBulletUnit)

var8_0.__name = "BattleColumnAreaBulletUnit"
var0_0.Battle.BattleColumnAreaBulletUnit = var8_0
var8_0.AreaType = var6_0.AreaType.COLUMN

function var8_0.InitCldComponent(arg0_1)
	local var0_1 = arg0_1:GetTemplate().cld_box
	local var1_1 = arg0_1:GetTemplate().cld_offset

	arg0_1._cldComponent = var0_0.Battle.BattleColumnCldComponent.New(var0_1[1], var0_1[3])

	local var2_1 = {
		type = var6_0.CldType.AOE,
		UID = arg0_1:GetUniqueID(),
		IFF = arg0_1:GetIFF()
	}

	arg0_1._cldComponent:SetCldData(var2_1)
end

function var8_0.GetBoxSize(arg0_2)
	local var0_2 = arg0_2._cldComponent:GetCldBoxSize()

	return Vector3(var0_2.range, var0_2.range, var0_2.tickness)
end
