local var0 = class("SelectSkinCard", import(".SkinAtlasCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.ownTr = arg0._tf:Find("own")
	arg0.timeLimitTr = arg0._tf:Find("timelimit")
end

function var0.Update(arg0, arg1, arg2, arg3, arg4)
	var0.super.Update(arg0, arg1, arg2)

	local var0 = isActive(arg0.usingTr) or isActive(arg0.unavailableTr)

	setAnchoredPosition(arg0.timeLimitTr, {
		y = var0 and -40 or 0
	})
	setActive(arg0.timeLimitTr, arg3)
	setActive(arg0.ownTr, arg4)
end

return var0
