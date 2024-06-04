local var0 = class("SVAchievement", import("view.base.BaseSubView"))

var0.HideView = "SVAchievement.HideView"

function var0.getUIName(arg0)
	return "SVAchievement"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	local var0 = arg0._tf:Find("display")
	local var1 = arg0._tf.rect.width / var0.rect.width

	var0.localScale = Vector3.New(var1, var1, 0)
	arg0.rtDesc = var0:Find("desc")
	arg0.rtStar = arg0.rtDesc:Find("star")

	onButton(arg0, arg0._tf, function()
		if arg0.isClosing then
			return
		end

		arg0:Hide()
	end, SFX_CANCEL)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0)
	setAnchoredPosition(arg0.rtStar, Vector2.New(100, 0))
	setActive(arg0.rtStar:Find("SVAstar"), false)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	arg0.isClosing = true

	local var0 = arg0.rtDesc:InverseTransformPoint(arg0.starWorldPos)
	local var1 = {}

	table.insert(var1, function(arg0)
		setActive(arg0.rtStar:Find("SVAstar"), true)
		LeanTween.moveLocal(go(arg0.rtStar), Vector3.New(var0.x, var0.y, 0), 0.5):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0))
	end)
	table.insert(var1, function(arg0)
		Timer.New(arg0, 1.1):Start()
	end)
	seriesAsync(var1, function()
		arg0.isClosing = false

		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)
		setActive(arg0._tf, false)
		arg0:emit(var0.HideView)
	end)
end

function var0.Setup(arg0, arg1, arg2)
	setText(arg0.rtDesc, arg1.config.target_desc)

	arg0.starWorldPos = arg2
end

return var0
