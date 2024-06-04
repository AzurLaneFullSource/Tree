local var0 = class("SVGlobalBuff", import("view.base.BaseSubView"))

var0.HideView = "SVGlobalBuff.HideView"

function var0.getUIName(arg0)
	return "SVGlobalBuff"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.rtFrame = arg0._tf:Find("frame")
	arg0.rtPanel = arg0.rtFrame:Find("buff_panel/buff_bg")
	arg0.rtInfo = arg0.rtFrame:Find("buff_panel/info")

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CANCEL)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0)
	setLocalScale(arg0.rtFrame, Vector3(0.5, 0.5, 0.5))
	LeanTween.cancel(go(arg0.rtFrame))
	LeanTween.scale(arg0.rtFrame, Vector3.one, 0.15)
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	LeanTween.cancel(go(arg0.rtFrame))
	setActive(arg0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	arg0:emit(var0.HideView, arg0.callback)
end

function var0.Setup(arg0, arg1, arg2)
	arg0.callback = arg2

	eachChild(arg0.rtPanel, function(arg0)
		setActive(arg0, arg0.name == tostring(arg1.id))
	end)

	local var0 = WorldBuff.New()

	var0:Setup({
		id = arg1.id,
		floor = arg1.before
	})
	setText(arg0.rtInfo:Find("name"), var0.config.name)
	setText(arg0.rtInfo:Find("value_before"), var0:GetFloor())
	var0:AddFloor(arg1.floor)
	setText(arg0.rtInfo:Find("value"), var0:GetFloor())
end

return var0
