local var0 = class("ShopBgView")

function var0.Ctor(arg0, arg1)
	arg0._bg = arg1
	arg0.img = arg0._bg:GetComponent(typeof(Image))

	setActive(arg1, false)

	arg0.bgs = {}
end

function var0.Init(arg0, arg1)
	setActive(arg0._bg, arg1 ~= nil)

	if arg1 then
		local var0

		if arg0.bgs[arg1] then
			var0 = arg0.bgs[arg1]
		else
			var0 = GetSpriteFromAtlas(arg1, "")
		end

		arg0.img.sprite = var0
	end
end

function var0.Dispose(arg0)
	UIUtil.ClearImageSprite(arg0._bg.gameObject)

	arg0.bgs = nil
end

return var0
