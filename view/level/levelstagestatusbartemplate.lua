local var0_0 = class("LevelStageStatusBarTemplate", BaseSubPanel)

function var0_0.OnInit(arg0_1)
	arg0_1.anim = arg0_1._go:GetComponent(typeof(Animator))
	arg0_1.animEvent = arg0_1._go:GetComponent(typeof(DftAniEvent))
end

function var0_0.OnShow(arg0_2)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf, {
		weight = LayerWeightConst.THIRD_LAYER,
		groupName = LayerWeightConst.GROUP_LEVELUI
	})
	arg0_2.animEvent:SetEndEvent(function()
		arg0_2:Hide()
	end)
end

function var0_0.OnHide(arg0_4)
	arg0_4.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf)
end

function var0_0.PlayAnim(arg0_5)
	arg0_5:Hide()
	arg0_5:Show()
end

return var0_0
