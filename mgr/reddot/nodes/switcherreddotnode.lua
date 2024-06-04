local var0 = class("SwitcherRedDotNode", import(".RedDotNode"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find(arg3 and "on" or "off")

	var0.super.Ctor(arg0, var0, arg2)

	arg0.toggle = arg1:GetComponent(typeof(Toggle))
	arg0.isOn = arg3
end

function var0.SetData(arg0, arg1)
	if IsNil(arg0.gameObject) then
		return
	end

	setActive(arg0.gameObject, arg1 and arg0.toggle.isOn ~= arg0.isOn)
end

return var0
