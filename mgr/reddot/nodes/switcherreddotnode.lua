local var0_0 = class("SwitcherRedDotNode", import(".RedDotNode"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1 = arg1_1:Find(arg3_1 and "on" or "off")

	var0_0.super.Ctor(arg0_1, var0_1, arg2_1)

	arg0_1.toggle = arg1_1:GetComponent(typeof(Toggle))
	arg0_1.isOn = arg3_1
end

function var0_0.SetData(arg0_2, arg1_2)
	if IsNil(arg0_2.gameObject) then
		return
	end

	setActive(arg0_2.gameObject, arg1_2 and arg0_2.toggle.isOn ~= arg0_2.isOn)
end

return var0_0
