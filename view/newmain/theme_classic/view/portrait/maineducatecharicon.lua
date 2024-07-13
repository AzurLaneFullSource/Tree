local var0_0 = class("MainEducateCharIcon", import(".MainBaseIcon"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.iconTr = arg1_1:Find("icon")
	arg0_1.iconImg = arg0_1.iconTr:GetComponent(typeof(Image))
end

function var0_0.Load(arg0_2, arg1_2)
	setActive(arg0_2.iconTr, true)
	GetImageSpriteFromAtlasAsync("SquareIcon/" .. arg1_2, "", arg0_2.iconTr, true)
end

function var0_0.Unload(arg0_3)
	setActive(arg0_3.iconTr, false)

	arg0_3.iconImg.sprite = nil
end

return var0_0
