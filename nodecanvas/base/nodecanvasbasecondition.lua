local var0_0 = class("NodeCanvasBaseCondition", import(".NodeCanvasBaseObject"))

function var0_0.Enable(arg0_1, arg1_1, arg2_1)
	arg0_1:Init(arg1_1, arg2_1)
	arg0_1:OnEnable()
end

function var0_0.Disable(arg0_2)
	arg0_2:OnDisable()
end

function var0_0.Check(arg0_3)
	return arg0_3:OnCheck()
end

function var0_0.OnEnable(arg0_4)
	return
end

function var0_0.OnDisable(arg0_5)
	return
end

function var0_0.OnCheck(arg0_6)
	return true
end

return var0_0
