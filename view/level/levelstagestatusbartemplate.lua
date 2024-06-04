local var0 = class("LevelStageStatusBarTemplate", BaseSubPanel)

function var0.OnInit(arg0)
	arg0.anim = arg0._go:GetComponent(typeof(Animator))
	arg0.animEvent = arg0._go:GetComponent(typeof(DftAniEvent))
end

function var0.OnShow(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		weight = LayerWeightConst.THIRD_LAYER,
		groupName = LayerWeightConst.GROUP_LEVELUI
	})
	arg0.animEvent:SetEndEvent(function()
		arg0:Hide()
	end)
end

function var0.OnHide(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

function var0.PlayAnim(arg0)
	arg0:Hide()
	arg0:Show()
end

return var0
