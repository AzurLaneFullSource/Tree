local var0_0 = class("MainRankBtn4Mellow", import(".MainRankBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.rankImage = arg1_1:Find("root/Image"):GetComponent(typeof(Image))
end

function var0_0.Flush(arg0_2)
	local var0_2 = arg0_2:IsActive()

	setActive(arg0_2._tf:Find("root/lock"), not var0_2)

	local var1_2 = var0_2 and Color(1, 1, 1, 1) or Color(0.3, 0.3, 0.3, 1)

	arg0_2.rankImage.color = var1_2
end

return var0_0
