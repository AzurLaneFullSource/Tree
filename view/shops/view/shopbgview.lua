local var0_0 = class("ShopBgView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._bg = arg1_1
	arg0_1.img = arg0_1._bg:GetComponent(typeof(Image))

	setActive(arg1_1, false)

	arg0_1.bgs = {}
end

function var0_0.Init(arg0_2, arg1_2)
	setActive(arg0_2._bg, arg1_2 ~= nil)

	if arg1_2 then
		local var0_2

		if arg0_2.bgs[arg1_2] then
			var0_2 = arg0_2.bgs[arg1_2]
		else
			var0_2 = GetSpriteFromAtlas(arg1_2, "")
		end

		arg0_2.img.sprite = var0_2
	end
end

function var0_0.Dispose(arg0_3)
	UIUtil.ClearImageSprite(arg0_3._bg.gameObject)

	arg0_3.bgs = nil
end

return var0_0
