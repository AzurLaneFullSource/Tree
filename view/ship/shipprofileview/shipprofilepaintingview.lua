local var0_0 = class("ShipProfilePaintingView")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.prefab = arg1_1
	arg0_1.painting = arg2_1
	arg0_1.cg = arg0_1.painting:GetComponent("CanvasGroup")
	arg0_1.bg = arg0_1.prefab:Find("bg")
	arg0_1.bgBtn = arg0_1.bg:GetComponent("Button")
	arg0_1.recorder = {}
	arg0_1.hideObjList = {}
	arg0_1.isPreview = false
	arg0_1.zoomDelegate = GetOrAddComponent(arg0_1.bg, "MultiTouchZoom")
	arg0_1.zoomDelegate.enabled = false
	arg0_1.dragTrigger = GetOrAddComponent(arg0_1.bg, "EventTriggerListener")

	arg0_1:SetHideObject()

	arg0_1.isBanRotate = arg3_1
end

function var0_0.SetHideObject(arg0_2)
	local var0_2 = arg0_2.prefab.childCount
	local var1_2 = 0

	while var1_2 < var0_2 do
		local var2_2 = arg0_2.prefab:GetChild(var1_2)

		if var2_2.gameObject.activeSelf and var2_2 ~= arg0_2.painting and var2_2 ~= arg0_2.bg then
			arg0_2.hideObjList[#arg0_2.hideObjList + 1] = var2_2
		end

		var1_2 = var1_2 + 1
	end
end

function var0_0.setBGCallback(arg0_3, arg1_3)
	arg0_3.bgCallback = arg1_3
end

function var0_0.Start(arg0_4)
	arg0_4.cg.blocksRaycasts = false

	arg0_4:EnableObjects(false)
	arg0_4:RecodObjectInfo()
	LeanTween.moveX(arg0_4.painting, 0, 0.3):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		arg0_4:TweenObjects()
	end))

	arg0_4.isPreview = true
end

function var0_0.EnableObjects(arg0_6, arg1_6)
	_.each(arg0_6.hideObjList, function(arg0_7)
		setActive(arg0_7, arg1_6)
	end)
end

function var0_0.TweenObjects(arg0_8)
	if not arg0_8.isBanRotate then
		openPortrait(arg0_8.prefab)
	end

	local var0_8 = true

	arg0_8.exitFlag = false

	local var1_8
	local var2_8

	arg0_8.zoomDelegate:SetZoomTarget(arg0_8.painting)

	arg0_8.zoomDelegate.enabled = true

	local var3_8 = arg0_8.dragTrigger

	var3_8.enabled = true

	var3_8:AddPointDownFunc(function(arg0_9)
		if Input.touchCount == 1 or IsUnityEditor then
			arg0_8.exitFlag = true
			var0_8 = true
		elseif Input.touchCount >= 2 then
			var0_8 = false
			arg0_8.exitFlag = false
		end
	end)
	var3_8:AddPointUpFunc(function(arg0_10)
		if Input.touchCount <= 2 then
			var0_8 = true
		end
	end)
	var3_8:AddBeginDragFunc(function(arg0_11, arg1_11)
		arg0_8.exitFlag = false
		var1_8 = arg1_11.position.x * arg0_8.recorder.widthRate - arg0_8.recorder.halfWidth - tf(arg0_8.painting).localPosition.x
		var2_8 = arg1_11.position.y * arg0_8.recorder.heightRate - arg0_8.recorder.halfHeight - tf(arg0_8.painting).localPosition.y
	end)
	var3_8:AddDragFunc(function(arg0_12, arg1_12)
		if var0_8 then
			local var0_12 = tf(arg0_8.painting).localPosition

			tf(arg0_8.painting).localPosition = Vector3(arg1_12.position.x * arg0_8.recorder.widthRate - arg0_8.recorder.halfWidth - var1_8 - 150, arg1_12.position.y * arg0_8.recorder.heightRate - arg0_8.recorder.halfHeight - var2_8, -22)
		end
	end)

	arg0_8.bgBtn.enabled = true

	onButton(arg0_8, arg0_8.bg, function()
		if arg0_8.bgCallback then
			if arg0_8.exitFlag then
				arg0_8.bgCallback()
			end
		else
			arg0_8:Finish()
		end
	end, SFX_CANCEL)
end

function var0_0.RecodObjectInfo(arg0_14)
	arg0_14.recorder.srcPosX = arg0_14.painting.anchoredPosition.x
	arg0_14.recorder.srcPosY = arg0_14.painting.anchoredPosition.y
	arg0_14.recorder.srcWidth = arg0_14.painting.rect.width
	arg0_14.recorder.srcHeight = arg0_14.painting.rect.height
	arg0_14.recorder.widthRate = arg0_14.prefab.rect.width / UnityEngine.Screen.width
	arg0_14.recorder.heightRate = arg0_14.prefab.rect.height / UnityEngine.Screen.height
	arg0_14.recorder.halfWidth = arg0_14.recorder.srcWidth / 2
	arg0_14.recorder.halfHeight = arg0_14.recorder.srcHeight / 2
end

function var0_0.Finish(arg0_15, arg1_15)
	if not arg1_15 and not arg0_15.exitFlag then
		return
	end

	arg0_15.dragTrigger.enabled = false
	arg0_15.zoomDelegate.enabled = false

	_.each(arg0_15.hideObjList, function(arg0_16)
		setActive(arg0_16, true)
	end)

	if not arg0_15.isBanRotate then
		closePortrait(arg0_15.prefab)
	end

	arg0_15:EnableObjects(true)

	arg0_15.painting.localScale = Vector3(1, 1, 1)

	setAnchoredPosition(arg0_15.painting, {
		x = arg0_15.recorder.srcPosX,
		y = arg0_15.recorder.srcPosY
	})

	arg0_15.bgBtn.enabled = false
	arg0_15.cg.blocksRaycasts = true
	arg0_15.isPreview = false
	arg0_15.exitFlag = false
	arg0_15.recorder = {}
end

function var0_0.Dispose(arg0_17)
	if arg0_17.isPreview then
		arg0_17:Finish(true)
	end

	if arg0_17.dragTrigger then
		ClearEventTrigger(arg0_17.dragTrigger)

		arg0_17.dragTrigger = nil
	end

	arg0_17.exitFlag = nil
	arg0_17.recorder = nil
	arg0_17.isPreview = nil

	pg.DelegateInfo.Dispose(arg0_17)
end

return var0_0
