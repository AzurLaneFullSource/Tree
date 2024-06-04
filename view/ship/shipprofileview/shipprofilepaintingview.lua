local var0 = class("ShipProfilePaintingView")

function var0.Ctor(arg0, arg1, arg2, arg3)
	pg.DelegateInfo.New(arg0)

	arg0.prefab = arg1
	arg0.painting = arg2
	arg0.cg = arg0.painting:GetComponent("CanvasGroup")
	arg0.bg = arg0.prefab:Find("bg")
	arg0.bgBtn = arg0.bg:GetComponent("Button")
	arg0.recorder = {}
	arg0.hideObjList = {}
	arg0.isPreview = false
	arg0.zoomDelegate = GetOrAddComponent(arg0.bg, "MultiTouchZoom")
	arg0.zoomDelegate.enabled = false
	arg0.dragTrigger = GetOrAddComponent(arg0.bg, "EventTriggerListener")

	arg0:SetHideObject()

	arg0.isBanRotate = arg3
end

function var0.SetHideObject(arg0)
	local var0 = arg0.prefab.childCount
	local var1 = 0

	while var1 < var0 do
		local var2 = arg0.prefab:GetChild(var1)

		if var2.gameObject.activeSelf and var2 ~= arg0.painting and var2 ~= arg0.bg then
			arg0.hideObjList[#arg0.hideObjList + 1] = var2
		end

		var1 = var1 + 1
	end
end

function var0.setBGCallback(arg0, arg1)
	arg0.bgCallback = arg1
end

function var0.Start(arg0)
	arg0.cg.blocksRaycasts = false

	arg0:EnableObjects(false)
	arg0:RecodObjectInfo()
	LeanTween.moveX(arg0.painting, 0, 0.3):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		arg0:TweenObjects()
	end))

	arg0.isPreview = true
end

function var0.EnableObjects(arg0, arg1)
	_.each(arg0.hideObjList, function(arg0)
		setActive(arg0, arg1)
	end)
end

function var0.TweenObjects(arg0)
	if not arg0.isBanRotate then
		openPortrait(arg0.prefab)
	end

	local var0 = true

	arg0.exitFlag = false

	local var1
	local var2

	arg0.zoomDelegate:SetZoomTarget(arg0.painting)

	arg0.zoomDelegate.enabled = true

	local var3 = arg0.dragTrigger

	var3.enabled = true

	var3:AddPointDownFunc(function(arg0)
		if Input.touchCount == 1 or IsUnityEditor then
			arg0.exitFlag = true
			var0 = true
		elseif Input.touchCount >= 2 then
			var0 = false
			arg0.exitFlag = false
		end
	end)
	var3:AddPointUpFunc(function(arg0)
		if Input.touchCount <= 2 then
			var0 = true
		end
	end)
	var3:AddBeginDragFunc(function(arg0, arg1)
		arg0.exitFlag = false
		var1 = arg1.position.x * arg0.recorder.widthRate - arg0.recorder.halfWidth - tf(arg0.painting).localPosition.x
		var2 = arg1.position.y * arg0.recorder.heightRate - arg0.recorder.halfHeight - tf(arg0.painting).localPosition.y
	end)
	var3:AddDragFunc(function(arg0, arg1)
		if var0 then
			local var0 = tf(arg0.painting).localPosition

			tf(arg0.painting).localPosition = Vector3(arg1.position.x * arg0.recorder.widthRate - arg0.recorder.halfWidth - var1 - 150, arg1.position.y * arg0.recorder.heightRate - arg0.recorder.halfHeight - var2, -22)
		end
	end)

	arg0.bgBtn.enabled = true

	onButton(arg0, arg0.bg, function()
		if arg0.bgCallback then
			if arg0.exitFlag then
				arg0.bgCallback()
			end
		else
			arg0:Finish()
		end
	end, SFX_CANCEL)
end

function var0.RecodObjectInfo(arg0)
	arg0.recorder.srcPosX = arg0.painting.anchoredPosition.x
	arg0.recorder.srcPosY = arg0.painting.anchoredPosition.y
	arg0.recorder.srcWidth = arg0.painting.rect.width
	arg0.recorder.srcHeight = arg0.painting.rect.height
	arg0.recorder.widthRate = arg0.prefab.rect.width / UnityEngine.Screen.width
	arg0.recorder.heightRate = arg0.prefab.rect.height / UnityEngine.Screen.height
	arg0.recorder.halfWidth = arg0.recorder.srcWidth / 2
	arg0.recorder.halfHeight = arg0.recorder.srcHeight / 2
end

function var0.Finish(arg0, arg1)
	if not arg1 and not arg0.exitFlag then
		return
	end

	arg0.dragTrigger.enabled = false
	arg0.zoomDelegate.enabled = false

	_.each(arg0.hideObjList, function(arg0)
		setActive(arg0, true)
	end)

	if not arg0.isBanRotate then
		closePortrait(arg0.prefab)
	end

	arg0:EnableObjects(true)

	arg0.painting.localScale = Vector3(1, 1, 1)

	setAnchoredPosition(arg0.painting, {
		x = arg0.recorder.srcPosX,
		y = arg0.recorder.srcPosY
	})

	arg0.bgBtn.enabled = false
	arg0.cg.blocksRaycasts = true
	arg0.isPreview = false
	arg0.exitFlag = false
	arg0.recorder = {}
end

function var0.Dispose(arg0)
	if arg0.isPreview then
		arg0:Finish(true)
	end

	if arg0.dragTrigger then
		ClearEventTrigger(arg0.dragTrigger)

		arg0.dragTrigger = nil
	end

	arg0.exitFlag = nil
	arg0.recorder = nil
	arg0.isPreview = nil

	pg.DelegateInfo.Dispose(arg0)
end

return var0
