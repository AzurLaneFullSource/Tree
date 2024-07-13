local var0_0 = class("SelectSkinCard", import(".SkinAtlasCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.ownTr = arg0_1._tf:Find("own")
	arg0_1.timeLimitTr = arg0_1._tf:Find("timelimit")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	var0_0.super.Update(arg0_2, arg1_2, arg2_2)

	local var0_2 = isActive(arg0_2.usingTr) or isActive(arg0_2.unavailableTr)

	setAnchoredPosition(arg0_2.timeLimitTr, {
		y = var0_2 and -40 or 0
	})
	setActive(arg0_2.timeLimitTr, arg3_2)
	setActive(arg0_2.ownTr, arg4_2)
end

return var0_0
