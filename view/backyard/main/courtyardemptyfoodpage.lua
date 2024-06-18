local var0_0 = class("CourtYardEmptyFoodPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CourtYardEmptyFoodUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confirmBtn = arg0_2:findTF("frame/ok_btn")
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel_btn")

	setButtonText(arg0_2.confirmBtn, i18n("text_nofood_yes"))
	setButtonText(arg0_2.cancelBtn, i18n("text_nofood_no"))

	arg0_2.frame = arg0_2:findTF("frame")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:emit(CourtYardMediator.GO_GRANARY)
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_7)
	arg0_7:Show()
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	LeanTween.cancel(go(arg0_8.frame))

	arg0_8.frame.localScale = Vector3(0, 0, 0)

	LeanTween.scale(arg0_8.frame, Vector3(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack)
end

function var0_0.Hide(arg0_9)
	LeanTween.cancel(go(arg0_9.frame))
	var0_0.super.Hide(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._parentTf)
end

function var0_0.OnDestroy(arg0_10)
	arg0_10:Hide()
end

return var0_0
