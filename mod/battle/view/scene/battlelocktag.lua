ys = ys or {}

local var0 = ys

var0.Battle.BattleLockTag = class("BattleLockTag")
var0.Battle.BattleLockTag.__name = "BattleLockTag"

local var1 = var0.Battle.BattleLockTag

function var1.Ctor(arg0, arg1, arg2)
	arg0._markGO = arg1
	arg0._markTF = arg1.transform
	arg0._controller = arg0._markTF:GetComponent("LockTag")
	arg0._flag = true
end

function var1.Mark(arg0, arg1)
	arg0._markTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0._requiredTime = arg1

	SetActive(arg0._markGO, true)

	arg0._controller.enabled = true
end

function var1.Update(arg0, arg1)
	local var0 = (arg1 - arg0._markTime) / arg0._requiredTime

	if var0 >= 1 and arg0._flag then
		arg0._controller:SetRate(1)

		arg0._controller.enabled = false
		arg0._markTF:GetComponent(typeof(Animator)).enabled = true
		arg0._flag = false
	elseif arg0._flag then
		arg0._controller:SetRate(var0)
	end
end

function var1.SetPosition(arg0, arg1)
	arg0._markTF.position = arg1
end

function var1.SetTagCount(arg0, arg1)
	arg0._controller.count = arg1
end

function var1.Dispose(arg0)
	Object.Destroy(arg0._markGO)
end
