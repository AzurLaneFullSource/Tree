local var0 = class("CommanderPaintingUtil")

function var0.Ctor(arg0, arg1)
	arg0.rect = arg1.parent.rect

	local var0 = arg1.parent.parent:Find("background")

	arg0._tf = arg1
	arg0.zoomDelegate = GetOrAddComponent(arg1, "MultiTouchZoom")
	arg0.dragDelegate = GetOrAddComponent(arg1, "EventTriggerListener")
	arg0.initPosition = arg0._tf.localPosition
end

function var0.Fold(arg0)
	arg0.zoomDelegate:SetZoomTarget(arg0._tf)

	arg0.zoomDelegate.enabled = true
	arg0.dragDelegate.enabled = true

	LeanTween.move(rtf(arg0._tf), Vector3.zero, 0.5)

	local var0 = arg0._tf:Find("fitter"):GetChild(0)

	if var0 then
		var0:GetComponent(typeof(Image)).raycastTarget = true
	end

	local var1 = arg0._tf
	local var2 = var1.anchoredPosition.x
	local var3 = var1.anchoredPosition.y
	local var4 = var1.rect.width
	local var5 = var1.rect.height
	local var6 = arg0.rect.width / UnityEngine.Screen.width
	local var7 = arg0.rect.height / UnityEngine.Screen.height
	local var8 = var4 / 2
	local var9 = var5 / 2
	local var10
	local var11
	local var12 = true
	local var13 = false

	arg0.dragDelegate:AddPointDownFunc(function(arg0)
		if Input.touchCount == 1 or IsUnityEditor then
			var13 = true
			var12 = true
		elseif Input.touchCount >= 2 then
			var12 = false
			var13 = false
		end
	end)
	arg0.dragDelegate:AddPointUpFunc(function(arg0)
		if Input.touchCount <= 2 then
			var12 = true
		end
	end)
	arg0.dragDelegate:AddBeginDragFunc(function(arg0, arg1)
		var13 = false
		var10 = arg1.position.x * var6 - var8 - var1.localPosition.x
		var11 = arg1.position.y * var7 - var9 - var1.localPosition.y
	end)
	arg0.dragDelegate:AddDragFunc(function(arg0, arg1)
		if var12 then
			local var0 = arg0._tf.localPosition

			arg0._tf.localPosition = Vector3(arg1.position.x * var6 - var8 - var10, arg1.position.y * var7 - var9 - var11, -22)
		end
	end)
end

function var0.UnFold(arg0)
	LeanTween.move(rtf(arg0._tf), arg0.initPosition, 0.5)

	arg0.zoomDelegate.enabled = false
	arg0.dragDelegate.enabled = false

	arg0.dragDelegate:AddPointDownFunc(nil)
	arg0.dragDelegate:AddPointUpFunc(nil)
	arg0.dragDelegate:AddBeginDragFunc(nil)
	arg0.dragDelegate:AddDragFunc(nil)

	local var0 = arg0._tf:Find("fitter"):GetChild(0)

	if var0 then
		var0:GetComponent(typeof(Image)).raycastTarget = false
	end
end

function var0.Dispose(arg0)
	arg0:UnFold()
end

return var0
