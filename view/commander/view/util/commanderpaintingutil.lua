local var0_0 = class("CommanderPaintingUtil")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.rect = arg1_1.parent.rect

	local var0_1 = arg1_1.parent.parent:Find("background")

	arg0_1._tf = arg1_1
	arg0_1.zoomDelegate = GetOrAddComponent(arg1_1, "MultiTouchZoom")
	arg0_1.dragDelegate = GetOrAddComponent(arg1_1, "EventTriggerListener")
	arg0_1.initPosition = arg0_1._tf.localPosition
end

function var0_0.Fold(arg0_2)
	arg0_2.zoomDelegate:SetZoomTarget(arg0_2._tf)

	arg0_2.zoomDelegate.enabled = true
	arg0_2.dragDelegate.enabled = true

	LeanTween.move(rtf(arg0_2._tf), Vector3.zero, 0.5)

	local var0_2 = arg0_2._tf:Find("fitter"):GetChild(0)

	if var0_2 then
		var0_2:GetComponent(typeof(Image)).raycastTarget = true
	end

	local var1_2 = arg0_2._tf
	local var2_2 = var1_2.anchoredPosition.x
	local var3_2 = var1_2.anchoredPosition.y
	local var4_2 = var1_2.rect.width
	local var5_2 = var1_2.rect.height
	local var6_2 = arg0_2.rect.width / UnityEngine.Screen.width
	local var7_2 = arg0_2.rect.height / UnityEngine.Screen.height
	local var8_2 = var4_2 / 2
	local var9_2 = var5_2 / 2
	local var10_2
	local var11_2
	local var12_2 = true
	local var13_2 = false

	arg0_2.dragDelegate:AddPointDownFunc(function(arg0_3)
		if Input.touchCount == 1 or IsUnityEditor then
			var13_2 = true
			var12_2 = true
		elseif Input.touchCount >= 2 then
			var12_2 = false
			var13_2 = false
		end
	end)
	arg0_2.dragDelegate:AddPointUpFunc(function(arg0_4)
		if Input.touchCount <= 2 then
			var12_2 = true
		end
	end)
	arg0_2.dragDelegate:AddBeginDragFunc(function(arg0_5, arg1_5)
		var13_2 = false
		var10_2 = arg1_5.position.x * var6_2 - var8_2 - var1_2.localPosition.x
		var11_2 = arg1_5.position.y * var7_2 - var9_2 - var1_2.localPosition.y
	end)
	arg0_2.dragDelegate:AddDragFunc(function(arg0_6, arg1_6)
		if var12_2 then
			local var0_6 = arg0_2._tf.localPosition

			arg0_2._tf.localPosition = Vector3(arg1_6.position.x * var6_2 - var8_2 - var10_2, arg1_6.position.y * var7_2 - var9_2 - var11_2, -22)
		end
	end)
end

function var0_0.UnFold(arg0_7)
	LeanTween.move(rtf(arg0_7._tf), arg0_7.initPosition, 0.5)

	arg0_7.zoomDelegate.enabled = false
	arg0_7.dragDelegate.enabled = false

	arg0_7.dragDelegate:AddPointDownFunc(nil)
	arg0_7.dragDelegate:AddPointUpFunc(nil)
	arg0_7.dragDelegate:AddBeginDragFunc(nil)
	arg0_7.dragDelegate:AddDragFunc(nil)

	local var0_7 = arg0_7._tf:Find("fitter"):GetChild(0)

	if var0_7 then
		var0_7:GetComponent(typeof(Image)).raycastTarget = false
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8:UnFold()
end

return var0_0
