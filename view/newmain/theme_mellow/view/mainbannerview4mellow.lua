local var0_0 = class("MainBannerView4Mellow", import("...theme_classic.view.MainBannerView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scrollSnap = BannerScrollRect4Mellow.New(findTF(arg1_1, "mask/content"), findTF(arg1_1, "dots"))
end

function var0_0.GetDirection(arg0_2)
	return Vector2.zero
end

return var0_0
