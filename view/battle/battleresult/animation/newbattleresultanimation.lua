local var0_0 = class("NewBattleResultAnimation")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.bgImage = arg0_1._tf:GetComponent(typeof(Image))
	arg0_1.paintingTr = arg0_1._tf:Find("painting/painting")
	arg0_1.mask = arg0_1._tf:Find("mask")
	arg0_1.items = {}
	arg0_1.paintingPosition = Vector2(698, 0)
	arg0_1.paintingSizeDelta = Vector2(625, 1080)

	arg0_1:Start()
end

function var0_0.CollectionItems(arg0_2, arg1_2)
	eachChild(arg0_2._tf, function(arg0_3)
		if arg0_3 ~= arg0_2.mask then
			table.insert(arg1_2, {
				position = arg0_3.position,
				tr = arg0_3
			})
		end
	end)
end

function var0_0.Start(arg0_4)
	if not arg0_4.handle then
		arg0_4.handle = UpdateBeat:CreateListener(arg0_4.Update, arg0_4)
	end

	UpdateBeat:AddListener(arg0_4.handle)
end

function var0_0.Play(arg0_5, arg1_5, arg2_5)
	arg0_5.setUp = true

	setActive(arg0_5.mask, true)
	arg0_5:CollectionItems(arg0_5.items)
	arg0_5:MaskItems()
	parallelAsync({
		function(arg0_6)
			arg0_5:ZoomMask(arg0_6)
		end,
		function(arg0_7)
			if not arg1_5 then
				return arg0_7()
			end

			arg0_5:ZoomPainting(arg1_5, arg0_7)
		end
	}, function()
		arg0_5.setUp = false

		arg0_5:RevertItems()
		setActive(arg0_5.mask, false)
		arg0_5:Clear()
		arg2_5()
	end)
end

function var0_0.ZoomPainting(arg0_9, arg1_9, arg2_9)
	local function var0_9()
		if arg0_9.exited then
			return
		end

		local var0_10 = arg0_9.paintingTr:Find("fitter")

		var0_10:GetComponent(typeof(PaintingScaler)).enabled = false

		local var1_10 = arg1_9.position
		local var2_10 = arg1_9.scale
		local var3_10 = arg1_9.pivot
		local var4_10 = var0_10:GetChild(0)

		arg0_9:SetPivot(var4_10, var3_10)
		LeanTween.value(var4_10.gameObject, Vector2(var4_10.position.x, var4_10.position.y), var1_10, 0.2):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0_11)
			var4_10.position = Vector3(arg0_11.x, arg0_11.y, 0)
			var4_10.localPosition = Vector3(var4_10.localPosition.x, var4_10.localPosition.y, 0)
		end))
		LeanTween.value(var4_10.gameObject, Vector2(var4_10.localScale.x, var4_10.localScale.y), var2_10, 0.2):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0_12)
			var4_10.localScale = Vector3(arg0_12.x, arg0_12.y, 1)
		end)):setOnComplete(System.Action(arg2_9))
	end

	onNextTick(var0_9)
end

function var0_0.SetPivot(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13.rect.size
	local var1_13 = arg1_13.pivot - arg2_13
	local var2_13 = Vector3(var1_13.x * var0_13.x, var1_13.y * var0_13.y)

	arg1_13.pivot = arg2_13
	arg1_13.localPosition = arg1_13.localPosition - var2_13
end

local function var1_0(arg0_14, arg1_14)
	return arg0_14:InverseTransformPoint(arg1_14)
end

function var0_0.RevertItems(arg0_15)
	for iter0_15 = #arg0_15.items, 1, -1 do
		local var0_15 = arg0_15.items[iter0_15]
		local var1_15 = var0_15.tr
		local var2_15 = var0_15.position

		setParent(var1_15, arg0_15._tf, true)

		var1_15.localPosition = var1_0(arg0_15._tf, var2_15)
	end
end

function var0_0.ZoomMask(arg0_16, arg1_16)
	LeanTween.value(arg0_16.mask.gameObject, Vector2(418, 936), Vector2(4180, 2000), 0.4):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0_17)
		arg0_16.mask.sizeDelta = arg0_17
	end)):setOnComplete(System.Action(arg1_16))
end

function var0_0.MaskItems(arg0_18)
	for iter0_18 = #arg0_18.items, 1, -1 do
		local var0_18 = arg0_18.items[iter0_18].tr

		setParent(var0_18, arg0_18.mask, true)
	end
end

function var0_0.Update(arg0_19)
	if arg0_19.setUp then
		arg0_19:SynItemsPosition()
	end
end

function var0_0.SynItemsPosition(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.items) do
		local var0_20 = iter1_20.tr
		local var1_20 = iter1_20.position

		var0_20.localPosition = var1_0(arg0_20.mask, var1_20)
	end
end

function var0_0.Clear(arg0_21)
	if arg0_21.handle then
		UpdateBeat:RemoveListener(arg0_21.handle)

		arg0_21.handle = nil
	end

	if LeanTween.isTweening(arg0_21.mask.gameObject) then
		LeanTween.cancel(arg0_21.mask.gameObject)
	end

	if LeanTween.isTweening(arg0_21.paintingTr.gameObject) then
		LeanTween.cancel(arg0_21.paintingTr.gameObject)
	end
end

function var0_0.Dispose(arg0_22)
	arg0_22.exited = true

	arg0_22:Clear()
end

return var0_0
