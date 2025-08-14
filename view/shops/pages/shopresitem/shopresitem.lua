local var0_0 = class("ShopResItem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = Object.Instantiate(arg1_1, arg2_1)
	arg0_1._tf = arg0_1._go.transform
	arg0_1.icon = findTF(arg0_1._tf, "icon"):GetComponent(typeof(Image))
	arg0_1.cntText = findTF(arg0_1._tf, "Text")
end

function var0_0.SetData(arg0_2, arg1_2, arg2_2, arg3_2)
	setText(arg0_2.cntText, arg3_2)

	local var0_2 = Drop.New({
		type = arg1_2,
		id = arg2_2
	})

	GetImageSpriteFromAtlasAsync(var0_2:getIcon(), "", arg0_2.icon)
	arg0_2:Show(true)
end

function var0_0.Show(arg0_3, arg1_3)
	setActive(arg0_3._go, arg1_3)
end

function var0_0.Dispose(arg0_4)
	Object.Destroy(arg0_4._go)

	arg0_4._go = nil
	arg0_4._tf = nil
end

return var0_0
