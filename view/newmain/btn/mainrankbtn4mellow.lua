local var0 = class("MainRankBtn4Mellow", import(".MainRankBtn"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.rankImage = arg1:Find("root/Image"):GetComponent(typeof(Image))
end

function var0.Flush(arg0)
	local var0 = arg0:IsActive()

	setActive(arg0._tf:Find("root/lock"), not var0)

	local var1 = var0 and Color(1, 1, 1, 1) or Color(0.3, 0.3, 0.3, 1)

	arg0.rankImage.color = var1
end

return var0
