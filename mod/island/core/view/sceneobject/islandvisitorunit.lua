local var0_0 = class("IslandVisitorUnit", import(".IslandSceneUnit"))

function var0_0.OnAttach(arg0_1, arg1_1)
	arg0_1._tf = arg0_1._go.transform
	arg0_1._animator = arg0_1._tf:GetChild(0):GetComponent(typeof(Animator))
end

function var0_0.GetAnimator(arg0_2)
	return arg0_2._animator
end

return var0_0
