local var0_0 = class("GatewayNoticeLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "GatewayNoticeUI"
end

function var0_0.init(arg0_2)
	arg0_2.trFrame = arg0_2:findTF("frame")
	arg0_2.txtTitle = arg0_2:findTF("frame/title"):GetComponent("Text")
	arg0_2.txtContent = arg0_2:findTF("frame/content"):GetComponent("RichText")
	arg0_2.btnBack = arg0_2:findTF("frame/title_pop/btnBack")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:showNext()
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false)
end

function var0_0.updateNotices(arg0_5, arg1_5)
	arg0_5.notices = arg1_5

	arg0_5:showNext()
end

function var0_0.showNext(arg0_6)
	if arg0_6.notice then
		arg0_6.notice:markAsRead()
	end

	if #arg0_6.notices > 0 then
		arg0_6.notice = table.remove(arg0_6.notices, 1)
		arg0_6.txtTitle.text = arg0_6.notice.title
		arg0_6.txtContent.text = arg0_6.notice.content

		local var0_6 = arg0_6.trFrame:GetComponent("CanvasGroup")

		LeanTween.cancel(go(arg0_6.trFrame))
		LeanTween.value(go(arg0_6.trFrame), 0, 1, 0.3):setEase(LeanTweenType.easeOutBack):setOnUpdate(System.Action_float(function(arg0_7)
			var0_6.alpha = arg0_7
			arg0_6.trFrame.localScale = Vector3(0.8, 0.8, 1) + Vector3(0.2, 0.2, 0) * arg0_7
		end))
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	else
		arg0_6:emit(BaseUI.ON_CLOSE)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	end
end

function var0_0.willExit(arg0_8)
	LeanTween.cancel(go(arg0_8.trFrame))
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf)
end

return var0_0
