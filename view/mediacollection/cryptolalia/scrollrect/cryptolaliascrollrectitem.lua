local var0 = class("CryptolaliaScrollRectItem")
local var1 = Vector3(490, -35, 0)
local var2 = Vector3(297, 297, 0)

local function var3(arg0, arg1)
	local var0 = arg0.midIndex - arg1
	local var1 = var2 * var0

	return var1 + var1
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.initIndex = arg3
	arg0.midIndex = arg2
	arg0.img = arg0._go:GetComponent(typeof(Image))
	arg0.text = arg0._tf:Find("Text")
	arg0.index = arg3

	local var0 = var3(arg0, arg3)

	arg0:SetPosition(var0)
end

function var0.Interactable(arg0, arg1)
	arg0.img.raycastTarget = arg1

	setActive(arg0.text, not arg1)
end

function var0.CanInteractable(arg0)
	return arg0.img.raycastTarget
end

function var0.UpdateIndexWithAnim(arg0, arg1, arg2, arg3)
	local var0 = math.abs(arg1 - arg0.index) > 1

	local function var1(arg0, arg1)
		LeanTween.moveLocal(arg0._go, arg0, 0.594):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg1))
	end

	if var0 then
		local var2 = var3(arg0, arg2)

		var1(var2, function()
			arg0:UpdateIndex(arg1)
			arg3()
		end)
	else
		local var3 = var3(arg0, arg1)

		var1(var3, function()
			arg0:UpdateIndex(arg1)
		end)
	end
end

function var0.UpdateIndex(arg0, arg1)
	arg0.index = arg1
	arg0._go.name = arg1

	local var0 = var3(arg0, arg1)

	arg0:SetPosition(var0)
end

function var0.UpdateIndexSilence(arg0, arg1)
	arg0.index = arg1
	arg0._go.name = arg1
end

function var0.Refresh(arg0)
	local var0 = arg0:GetIndex()

	arg0:UpdateIndex(var0)
end

function var0.ClearAnimation(arg0)
	if LeanTween.isTweening(arg0._go) then
		LeanTween.cancel(arg0._go)
	end

	arg0:SetPosition(var3(arg0, arg0.index))
end

function var0.GetIndex(arg0)
	return arg0.index
end

function var0.GetInitIndex(arg0)
	return arg0.initIndex
end

function var0.IsMidIndex(arg0)
	return arg0:GetIndex() == arg0.midIndex
end

function var0.UpdateSprite(arg0, arg1)
	arg0.img.sprite = arg1

	arg0.img:SetNativeSize()
end

function var0.SetPosition(arg0, arg1)
	arg0._tf.localPosition = arg1
end

function var0.GetPosition(arg0)
	return arg0._tf.localPosition
end

function var0.Dispose(arg0)
	arg0:ClearAnimation()
end

return var0
