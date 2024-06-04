local var0 = class("ValentineQteGameItem")
local var1 = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6"
}

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.rect = arg0._tf.rect
	arg0.image = arg0._go:GetComponent(typeof(Image))

	arg0:SetTime(arg3)
	arg0:SetPosition(arg2)

	arg0.bound = getBounds(arg0._tf)

	local var0 = math.random(1, #var1)
	local var1 = GetSpriteFromAtlas("ui/valentineqtegame_atlas", var1[var0])

	arg0.image.sprite = var1

	arg0.image:SetNativeSize()
end

function var0.SetTime(arg0, arg1)
	arg0.genTime = arg1
end

function var0.SetPosition(arg0, arg1)
	arg0.genPos = arg1
	arg0._tf.localPosition = arg1
end

function var0.ShouldDisapper(arg0, arg1)
	if arg0.genTime - arg1 >= ValentineQteGameConst.ITEM_DISAPPEAR_TIME then
		return true
	end

	return false
end

function var0.IsOverlap(arg0, arg1)
	local var0 = getBounds(arg1)

	return arg0.bound:Intersects(var0)
end

function var0.IsSufficientLength(arg0, arg1, arg2)
	return arg2 < math.abs(arg0._tf.localPosition.x - arg1)
end

function var0.Destroy(arg0)
	arg0.image.sprite = nil
end

return var0
