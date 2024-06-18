ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleOpticalSightView = class("BattleOpticalSightView")

local var2_0 = var0_0.Battle.BattleOpticalSightView

var2_0.__name = "BattleOpticalSightView"
var2_0.SIGHT_A = var1_0.ChargeWeaponConfig.SIGHT_A
var2_0.SIGHT_B = var1_0.ChargeWeaponConfig.SIGHT_B
var2_0.SIGHT_C = var1_0.ChargeWeaponConfig.SIGHT_C

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._sightTF = arg1_1:Find("Sight")
	arg0_1._rulerTF = arg1_1:Find("Ruler")
	arg0_1._cornerTF = arg1_1:Find("Corners")
	arg0_1._active = false
end

function var2_0.SetAreaBound(arg0_2, arg1_2, arg2_2)
	arg0_2._totalLeftBound = arg1_2
	arg0_2._totalRightBound = arg2_2
end

function var2_0.SetActive(arg0_3, arg1_3)
	arg0_3._active = arg1_3

	SetActive(arg0_3._sightTF, arg1_3)
	SetActive(arg0_3._rulerTF, arg1_3)
	SetActive(arg0_3._cornerTF, arg1_3)
end

function var2_0.Update(arg0_4)
	if not arg0_4._active then
		return
	end

	local var0_4 = arg0_4._fleetVO:GetMotion():GetPos().x + var2_0.SIGHT_C
	local var1_4 = math.min(var0_4, arg0_4._totalRightBound)
	local var2_4 = var0_0.Battle.BattleVariable.CameraPosToUICamera(Vector3.New(var1_4, 0, 5 + arg0_4._fleetVO:GetMotion():GetPos().z))

	arg0_4._sightTF.position = var2_4

	local var3_4 = Vector3.New(0, var2_4.y)

	arg0_4._rulerTF.position = var3_4
end

function var2_0.SetFleetVO(arg0_5, arg1_5)
	arg0_5._fleetVO = arg1_5
end

function var2_0.Dispose(arg0_6)
	arg0_6._sightTF = nil
	arg0_6._rulerTF = nil
	arg0_6._cornerTF = nil
	arg0_6._fleetVO = nil
end
