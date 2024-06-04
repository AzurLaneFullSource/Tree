local var0 = class("CourtYardEmptyFoodPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CourtYardEmptyFoodUI"
end

function var0.OnLoaded(arg0)
	arg0.confirmBtn = arg0:findTF("frame/ok_btn")
	arg0.cancelBtn = arg0:findTF("frame/cancel_btn")

	setButtonText(arg0.confirmBtn, i18n("text_nofood_yes"))
	setButtonText(arg0.cancelBtn, i18n("text_nofood_no"))

	arg0.frame = arg0:findTF("frame")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:emit(CourtYardMediator.GO_GRANARY)
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Flush(arg0)
	arg0:Show()
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	LeanTween.cancel(go(arg0.frame))

	arg0.frame.localScale = Vector3(0, 0, 0)

	LeanTween.scale(arg0.frame, Vector3(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack)
end

function var0.Hide(arg0)
	LeanTween.cancel(go(arg0.frame))
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
