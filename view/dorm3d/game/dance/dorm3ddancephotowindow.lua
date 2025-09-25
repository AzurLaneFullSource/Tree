local var0_0 = class("Dorm3dDancePhotoWindow", import("..Dorm3dGameBaseSubView"))

function var0_0.Init(arg0_1)
	arg0_1.parentTf = arg0_1._tf.parent
	arg0_1.imageTf = arg0_1._tf:Find("border/mask/image")
	arg0_1.maskTf = arg0_1._tf:Find("border/mask")
	arg0_1.frameTf = arg0_1._tf:Find("border")

	onButton(arg0_1, arg0_1._tf:Find("btn_save"), function()
		arg0_1.contextData.onSaveImage(arg0_1.frameTf)
	end, SFX_DORM_CLICK)
	onButton(arg0_1, arg0_1._tf, function()
		arg0_1:CloseWindow()
	end, SFX_DORM_CLICK)
end

function var0_0.Flush(arg0_4, arg1_4, arg2_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
	arg0_4.contextData.onShowRealImage(arg1_4, arg0_4.imageTf, arg0_4.maskTf)
	setActive(arg0_4._tf:Find("btn_save"), not arg2_4)

	if arg2_4 then
		arg0_4.tId = LeanTween.delayedCall(1, System.Action(function()
			arg0_4:CloseWindow()
		end)).uniqueId
	end
end

function var0_0.CloseWindow(arg0_6)
	if arg0_6.tId then
		LeanTween.cancel(arg0_6.tId)

		arg0_6.tId = nil
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_6._tf, arg0_6.parentTf)
	arg0_6:Hide()
	arg0_6.contextData.onHide()
end

function var0_0.Dispose(arg0_7)
	if isActive(arg0_7._tf) then
		arg0_7:CloseWindow()
	end
end

return var0_0
