local var0_0 = class("CryptolaliaScrollRectItem")
local var1_0 = Vector3(490, -35, 0)
local var2_0 = Vector3(297, 297, 0)

local function var3_0(arg0_1, arg1_1)
	local var0_1 = arg0_1.midIndex - arg1_1
	local var1_1 = var2_0 * var0_1

	return var1_0 + var1_1
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2.initIndex = arg3_2
	arg0_2.midIndex = arg2_2
	arg0_2.img = arg0_2._go:GetComponent(typeof(Image))
	arg0_2.text = arg0_2._tf:Find("Text")
	arg0_2.index = arg3_2

	local var0_2 = var3_0(arg0_2, arg3_2)

	arg0_2:SetPosition(var0_2)
end

function var0_0.Interactable(arg0_3, arg1_3)
	arg0_3.img.raycastTarget = arg1_3

	setActive(arg0_3.text, not arg1_3)
end

function var0_0.CanInteractable(arg0_4)
	return arg0_4.img.raycastTarget
end

function var0_0.UpdateIndexWithAnim(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = math.abs(arg1_5 - arg0_5.index) > 1

	local function var1_5(arg0_6, arg1_6)
		LeanTween.moveLocal(arg0_5._go, arg0_6, 0.594):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg1_6))
	end

	if var0_5 then
		local var2_5 = var3_0(arg0_5, arg2_5)

		var1_5(var2_5, function()
			arg0_5:UpdateIndex(arg1_5)
			arg3_5()
		end)
	else
		local var3_5 = var3_0(arg0_5, arg1_5)

		var1_5(var3_5, function()
			arg0_5:UpdateIndex(arg1_5)
		end)
	end
end

function var0_0.UpdateIndex(arg0_9, arg1_9)
	arg0_9.index = arg1_9
	arg0_9._go.name = arg1_9

	local var0_9 = var3_0(arg0_9, arg1_9)

	arg0_9:SetPosition(var0_9)
end

function var0_0.UpdateIndexSilence(arg0_10, arg1_10)
	arg0_10.index = arg1_10
	arg0_10._go.name = arg1_10
end

function var0_0.Refresh(arg0_11)
	local var0_11 = arg0_11:GetIndex()

	arg0_11:UpdateIndex(var0_11)
end

function var0_0.ClearAnimation(arg0_12)
	if LeanTween.isTweening(arg0_12._go) then
		LeanTween.cancel(arg0_12._go)
	end

	arg0_12:SetPosition(var3_0(arg0_12, arg0_12.index))
end

function var0_0.GetIndex(arg0_13)
	return arg0_13.index
end

function var0_0.GetInitIndex(arg0_14)
	return arg0_14.initIndex
end

function var0_0.IsMidIndex(arg0_15)
	return arg0_15:GetIndex() == arg0_15.midIndex
end

function var0_0.UpdateSprite(arg0_16, arg1_16)
	arg0_16.img.sprite = arg1_16

	arg0_16.img:SetNativeSize()
end

function var0_0.SetPosition(arg0_17, arg1_17)
	arg0_17._tf.localPosition = arg1_17
end

function var0_0.GetPosition(arg0_18)
	return arg0_18._tf.localPosition
end

function var0_0.Dispose(arg0_19)
	arg0_19:ClearAnimation()
end

return var0_0
