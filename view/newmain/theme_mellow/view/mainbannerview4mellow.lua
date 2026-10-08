local var0_0 = class("MainBannerView4Mellow", import("...theme_classic.view.MainBannerView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scrollSnap = BannerScrollRect4Mellow.New(findTF(arg1_1, "mask/content"), findTF(arg1_1, "dots"))
end

function var0_0.LayoutBannerItem(arg0_2, arg1_2)
	local var0_2 = arg1_2.transform
	local var1_2 = var0_2.parent
	local var2_2 = arg1_2:GetComponent(typeof(Image))

	if IsNil(var2_2) or IsNil(var2_2.sprite) then
		return
	end

	var0_2.localScale = Vector3.one
	var0_2.anchorMin = Vector2(0.5, 0.5)
	var0_2.anchorMax = Vector2(0.5, 0.5)
	var0_2.anchoredPosition = Vector2.zero

	var2_2:SetNativeSize()

	local var3_2 = var1_2.rect
	local var4_2 = var0_2.rect

	if var3_2.width <= 0 or var3_2.height <= 0 or var4_2.width <= 0 or var4_2.height <= 0 then
		return
	end

	local var5_2 = var3_2.width / var4_2.width
	local var6_2 = var3_2.height / var4_2.height
	local var7_2 = math.max(var5_2, var6_2)

	var0_2.localScale = Vector3(var7_2, var7_2, 1)
end

function var0_0.WhenRecycleBanner(arg0_3, arg1_3)
	local var0_3 = arg1_3.transform

	var0_3.localScale = Vector3.one
	var0_3.anchorMin = Vector2(0.5, 0.5)
	var0_3.anchorMax = Vector2(0.5, 0.5)
	var0_3.anchoredPosition = Vector2.zero
end

function var0_0.GetDirection(arg0_4)
	return Vector2.zero
end

return var0_0
