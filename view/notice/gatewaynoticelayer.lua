local var0 = class("GatewayNoticeLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "GatewayNoticeUI"
end

function var0.init(arg0)
	arg0.trFrame = arg0:findTF("frame")
	arg0.txtTitle = arg0:findTF("frame/title"):GetComponent("Text")
	arg0.txtContent = arg0:findTF("frame/content"):GetComponent("RichText")
	arg0.btnBack = arg0:findTF("frame/title_pop/btnBack")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnBack, function()
		arg0:showNext()
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false)
end

function var0.updateNotices(arg0, arg1)
	arg0.notices = arg1

	arg0:showNext()
end

function var0.showNext(arg0)
	if arg0.notice then
		arg0.notice:markAsRead()
	end

	if #arg0.notices > 0 then
		arg0.notice = table.remove(arg0.notices, 1)
		arg0.txtTitle.text = arg0.notice.title
		arg0.txtContent.text = arg0.notice.content

		local var0 = arg0.trFrame:GetComponent("CanvasGroup")

		LeanTween.cancel(go(arg0.trFrame))
		LeanTween.value(go(arg0.trFrame), 0, 1, 0.3):setEase(LeanTweenType.easeOutBack):setOnUpdate(System.Action_float(function(arg0)
			var0.alpha = arg0
			arg0.trFrame.localScale = Vector3(0.8, 0.8, 1) + Vector3(0.2, 0.2, 0) * arg0
		end))
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	else
		arg0:emit(BaseUI.ON_CLOSE)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	end
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0.trFrame))
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
