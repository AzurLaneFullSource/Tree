local var0_0 = class("SVAchievement", import("view.base.BaseSubView"))

var0_0.HideView = "SVAchievement.HideView"

function var0_0.getUIName(arg0_1)
	return "SVAchievement"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	local var0_3 = arg0_3._tf:Find("display")
	local var1_3 = arg0_3._tf.rect.width / var0_3.rect.width

	var0_3.localScale = Vector3.New(var1_3, var1_3, 0)
	arg0_3.rtDesc = var0_3:Find("desc")
	arg0_3.rtStar = arg0_3.rtDesc:Find("star")

	onButton(arg0_3, arg0_3._tf, function()
		if arg0_3.isClosing then
			return
		end

		arg0_3:Hide()
	end, SFX_CANCEL)
end

function var0_0.OnDestroy(arg0_5)
	return
end

function var0_0.Show(arg0_6)
	setAnchoredPosition(arg0_6.rtStar, Vector2.New(100, 0))
	setActive(arg0_6.rtStar:Find("SVAstar"), false)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_6._tf)
	setActive(arg0_6._tf, true)
end

function var0_0.Hide(arg0_7)
	arg0_7.isClosing = true

	local var0_7 = arg0_7.rtDesc:InverseTransformPoint(arg0_7.starWorldPos)
	local var1_7 = {}

	table.insert(var1_7, function(arg0_8)
		setActive(arg0_7.rtStar:Find("SVAstar"), true)
		LeanTween.moveLocal(go(arg0_7.rtStar), Vector3.New(var0_7.x, var0_7.y, 0), 0.5):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0_8))
	end)
	table.insert(var1_7, function(arg0_9)
		Timer.New(arg0_9, 1.1):Start()
	end)
	seriesAsync(var1_7, function()
		arg0_7.isClosing = false

		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7._tf, arg0_7._parentTf)
		setActive(arg0_7._tf, false)
		arg0_7:emit(var0_0.HideView)
	end)
end

function var0_0.Setup(arg0_11, arg1_11, arg2_11)
	setText(arg0_11.rtDesc, arg1_11.config.target_desc)

	arg0_11.starWorldPos = arg2_11
end

return var0_0
