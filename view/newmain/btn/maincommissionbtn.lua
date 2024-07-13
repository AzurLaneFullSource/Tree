local var0_0 = class("MainCommissionBtn", import(".MainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.animTime = arg3_1 or 0.2

	arg0_1:bind(GAME.REMOVE_LAYERS, function(arg0_2, arg1_2)
		arg0_1:OnRemoveLayer(arg1_2.context)
	end)
end

function var0_0.IsFixed(arg0_3)
	return true
end

function var0_0.OnClick(arg0_4)
	if LeanTween.isTweening(arg0_4._tf.gameObject) then
		return
	end

	LeanTween.moveX(arg0_4._tf, -1 * arg0_4._tf.rect.width, arg0_4.animTime):setOnComplete(System.Action(function()
		arg0_4:emit(NewMainMediator.OPEN_COMMISION)
	end))
end

function var0_0.OnRemoveLayer(arg0_6, arg1_6)
	if arg1_6.mediator == CommissionInfoMediator then
		arg0_6:ResetCommissionBtn()
	end
end

function var0_0.ResetCommissionBtn(arg0_7)
	local var0_7 = arg0_7._tf.localPosition

	arg0_7._tf.localPosition = Vector3(0, var0_7.y, 0)
end

function var0_0.Flush(arg0_8, arg1_8)
	arg0_8:ResetCommissionBtn()
end

return var0_0
