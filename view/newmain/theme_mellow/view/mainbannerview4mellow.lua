local var0 = class("MainBannerView4Mellow", import("...theme_classic.view.MainBannerView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.scrollSnap = BannerScrollRect4Mellow.New(findTF(arg1, "mask/content"), findTF(arg1, "dots"))
end

function var0.GetDirection(arg0)
	return Vector2.zero
end

return var0
