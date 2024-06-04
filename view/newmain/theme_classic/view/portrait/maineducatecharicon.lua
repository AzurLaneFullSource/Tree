local var0 = class("MainEducateCharIcon", import(".MainBaseIcon"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.iconTr = arg1:Find("icon")
	arg0.iconImg = arg0.iconTr:GetComponent(typeof(Image))
end

function var0.Load(arg0, arg1)
	setActive(arg0.iconTr, true)
	GetImageSpriteFromAtlasAsync("SquareIcon/" .. arg1, "", arg0.iconTr, true)
end

function var0.Unload(arg0)
	setActive(arg0.iconTr, false)

	arg0.iconImg.sprite = nil
end

return var0
