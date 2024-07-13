ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleLockTag = class("BattleLockTag")
var0_0.Battle.BattleLockTag.__name = "BattleLockTag"

local var1_0 = var0_0.Battle.BattleLockTag

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._markGO = arg1_1
	arg0_1._markTF = arg1_1.transform
	arg0_1._controller = arg0_1._markTF:GetComponent("LockTag")
	arg0_1._flag = true
end

function var1_0.Mark(arg0_2, arg1_2)
	arg0_2._markTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_2._requiredTime = arg1_2

	SetActive(arg0_2._markGO, true)

	arg0_2._controller.enabled = true
end

function var1_0.Update(arg0_3, arg1_3)
	local var0_3 = (arg1_3 - arg0_3._markTime) / arg0_3._requiredTime

	if var0_3 >= 1 and arg0_3._flag then
		arg0_3._controller:SetRate(1)

		arg0_3._controller.enabled = false
		arg0_3._markTF:GetComponent(typeof(Animator)).enabled = true
		arg0_3._flag = false
	elseif arg0_3._flag then
		arg0_3._controller:SetRate(var0_3)
	end
end

function var1_0.SetPosition(arg0_4, arg1_4)
	arg0_4._markTF.position = arg1_4
end

function var1_0.SetTagCount(arg0_5, arg1_5)
	arg0_5._controller.count = arg1_5
end

function var1_0.Dispose(arg0_6)
	Object.Destroy(arg0_6._markGO)
end
