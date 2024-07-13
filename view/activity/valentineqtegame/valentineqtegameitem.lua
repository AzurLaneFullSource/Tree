local var0_0 = class("ValentineQteGameItem")
local var1_0 = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6"
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.rect = arg0_1._tf.rect
	arg0_1.image = arg0_1._go:GetComponent(typeof(Image))

	arg0_1:SetTime(arg3_1)
	arg0_1:SetPosition(arg2_1)

	arg0_1.bound = getBounds(arg0_1._tf)

	local var0_1 = math.random(1, #var1_0)
	local var1_1 = GetSpriteFromAtlas("ui/valentineqtegame_atlas", var1_0[var0_1])

	arg0_1.image.sprite = var1_1

	arg0_1.image:SetNativeSize()
end

function var0_0.SetTime(arg0_2, arg1_2)
	arg0_2.genTime = arg1_2
end

function var0_0.SetPosition(arg0_3, arg1_3)
	arg0_3.genPos = arg1_3
	arg0_3._tf.localPosition = arg1_3
end

function var0_0.ShouldDisapper(arg0_4, arg1_4)
	if arg0_4.genTime - arg1_4 >= ValentineQteGameConst.ITEM_DISAPPEAR_TIME then
		return true
	end

	return false
end

function var0_0.IsOverlap(arg0_5, arg1_5)
	local var0_5 = getBounds(arg1_5)

	return arg0_5.bound:Intersects(var0_5)
end

function var0_0.IsSufficientLength(arg0_6, arg1_6, arg2_6)
	return arg2_6 < math.abs(arg0_6._tf.localPosition.x - arg1_6)
end

function var0_0.Destroy(arg0_7)
	arg0_7.image.sprite = nil
end

return var0_0
