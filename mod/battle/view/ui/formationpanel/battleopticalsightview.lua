ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.BattleOpticalSightView = class("BattleOpticalSightView")

local var2 = var0.Battle.BattleOpticalSightView

var2.__name = "BattleOpticalSightView"
var2.SIGHT_A = var1.ChargeWeaponConfig.SIGHT_A
var2.SIGHT_B = var1.ChargeWeaponConfig.SIGHT_B
var2.SIGHT_C = var1.ChargeWeaponConfig.SIGHT_C

function var2.Ctor(arg0, arg1)
	arg0._sightTF = arg1:Find("Sight")
	arg0._rulerTF = arg1:Find("Ruler")
	arg0._cornerTF = arg1:Find("Corners")
	arg0._active = false
end

function var2.SetAreaBound(arg0, arg1, arg2)
	arg0._totalLeftBound = arg1
	arg0._totalRightBound = arg2
end

function var2.SetActive(arg0, arg1)
	arg0._active = arg1

	SetActive(arg0._sightTF, arg1)
	SetActive(arg0._rulerTF, arg1)
	SetActive(arg0._cornerTF, arg1)
end

function var2.Update(arg0)
	if not arg0._active then
		return
	end

	local var0 = arg0._fleetVO:GetMotion():GetPos().x + var2.SIGHT_C
	local var1 = math.min(var0, arg0._totalRightBound)
	local var2 = var0.Battle.BattleVariable.CameraPosToUICamera(Vector3.New(var1, 0, 5 + arg0._fleetVO:GetMotion():GetPos().z))

	arg0._sightTF.position = var2

	local var3 = Vector3.New(0, var2.y)

	arg0._rulerTF.position = var3
end

function var2.SetFleetVO(arg0, arg1)
	arg0._fleetVO = arg1
end

function var2.Dispose(arg0)
	arg0._sightTF = nil
	arg0._rulerTF = nil
	arg0._cornerTF = nil
	arg0._fleetVO = nil
end
