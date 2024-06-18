ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = class("BattleCustomWarningLabel")

var0_0.Battle.BattleCustomWarningLabel = var2_0
var2_0.__name = "BattleCustomWarningLabel"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._expire = false
end

function var2_0.ConfigData(arg0_2, arg1_2)
	setText(arg0_2._tf:Find("text"), i18n(arg1_2.dialogue))

	arg0_2._duration = arg1_2.duration

	local var0_2 = (arg1_2.x + 1) * 0.5
	local var1_2 = (arg1_2.y + 1) * 0.5

	arg0_2._tf.anchorMin = Vector2(var0_2, var1_2)
	arg0_2._tf.anchorMax = Vector2(var0_2, var1_2)
	arg0_2._startTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var2_0.GetDuration(arg0_3)
	return arg0_3._duration
end

function var2_0.SetExpire(arg0_4)
	arg0_4._expire = true
end

function var2_0.IsExpire(arg0_5)
	return arg0_5._expire
end

function var2_0.Update(arg0_6)
	if arg0_6._duration > 0 and pg.TimeMgr.GetInstance():GetCombatTime() - arg0_6._startTimeStamp > arg0_6._duration then
		arg0_6:SetExpire()
	end
end

function var2_0.Dispose(arg0_7)
	Destroy(arg0_7._go)

	arg0_7._go = nil
	arg0_7._tf = nil
end
