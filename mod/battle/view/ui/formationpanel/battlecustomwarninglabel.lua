ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = class("BattleCustomWarningLabel")

var0.Battle.BattleCustomWarningLabel = var2
var2.__name = "BattleCustomWarningLabel"

function var2.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._expire = false
end

function var2.ConfigData(arg0, arg1)
	setText(arg0._tf:Find("text"), i18n(arg1.dialogue))

	arg0._duration = arg1.duration

	local var0 = (arg1.x + 1) * 0.5
	local var1 = (arg1.y + 1) * 0.5

	arg0._tf.anchorMin = Vector2(var0, var1)
	arg0._tf.anchorMax = Vector2(var0, var1)
	arg0._startTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var2.GetDuration(arg0)
	return arg0._duration
end

function var2.SetExpire(arg0)
	arg0._expire = true
end

function var2.IsExpire(arg0)
	return arg0._expire
end

function var2.Update(arg0)
	if arg0._duration > 0 and pg.TimeMgr.GetInstance():GetCombatTime() - arg0._startTimeStamp > arg0._duration then
		arg0:SetExpire()
	end
end

function var2.Dispose(arg0)
	Destroy(arg0._go)

	arg0._go = nil
	arg0._tf = nil
end
