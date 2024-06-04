local var0 = class("MainCommissionBtn", import(".MainBaseBtn"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.animTime = arg3 or 0.2

	arg0:bind(GAME.REMOVE_LAYERS, function(arg0, arg1)
		arg0:OnRemoveLayer(arg1.context)
	end)
end

function var0.IsFixed(arg0)
	return true
end

function var0.OnClick(arg0)
	if LeanTween.isTweening(arg0._tf.gameObject) then
		return
	end

	LeanTween.moveX(arg0._tf, -1 * arg0._tf.rect.width, arg0.animTime):setOnComplete(System.Action(function()
		arg0:emit(NewMainMediator.OPEN_COMMISION)
	end))
end

function var0.OnRemoveLayer(arg0, arg1)
	if arg1.mediator == CommissionInfoMediator then
		arg0:ResetCommissionBtn()
	end
end

function var0.ResetCommissionBtn(arg0)
	local var0 = arg0._tf.localPosition

	arg0._tf.localPosition = Vector3(0, var0.y, 0)
end

function var0.Flush(arg0, arg1)
	arg0:ResetCommissionBtn()
end

return var0
