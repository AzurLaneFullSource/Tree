local var0 = class("NewBattleResultAnimation")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.bgImage = arg0._tf:GetComponent(typeof(Image))
	arg0.paintingTr = arg0._tf:Find("painting/painting")
	arg0.mask = arg0._tf:Find("mask")
	arg0.items = {}
	arg0.paintingPosition = Vector2(698, 0)
	arg0.paintingSizeDelta = Vector2(625, 1080)

	arg0:Start()
end

function var0.CollectionItems(arg0, arg1)
	eachChild(arg0._tf, function(arg0)
		if arg0 ~= arg0.mask then
			table.insert(arg1, {
				position = arg0.position,
				tr = arg0
			})
		end
	end)
end

function var0.Start(arg0)
	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.Play(arg0, arg1, arg2)
	arg0.setUp = true

	setActive(arg0.mask, true)
	arg0:CollectionItems(arg0.items)
	arg0:MaskItems()
	parallelAsync({
		function(arg0)
			arg0:ZoomMask(arg0)
		end,
		function(arg0)
			if not arg1 then
				return arg0()
			end

			arg0:ZoomPainting(arg1, arg0)
		end
	}, function()
		arg0.setUp = false

		arg0:RevertItems()
		setActive(arg0.mask, false)
		arg0:Clear()
		arg2()
	end)
end

function var0.ZoomPainting(arg0, arg1, arg2)
	local function var0()
		if arg0.exited then
			return
		end

		local var0 = arg0.paintingTr:Find("fitter")

		var0:GetComponent(typeof(PaintingScaler)).enabled = false

		local var1 = arg1.position
		local var2 = arg1.scale
		local var3 = arg1.pivot
		local var4 = var0:GetChild(0)

		arg0:SetPivot(var4, var3)
		LeanTween.value(var4.gameObject, Vector2(var4.position.x, var4.position.y), var1, 0.2):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0)
			var4.position = Vector3(arg0.x, arg0.y, 0)
			var4.localPosition = Vector3(var4.localPosition.x, var4.localPosition.y, 0)
		end))
		LeanTween.value(var4.gameObject, Vector2(var4.localScale.x, var4.localScale.y), var2, 0.2):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0)
			var4.localScale = Vector3(arg0.x, arg0.y, 1)
		end)):setOnComplete(System.Action(arg2))
	end

	onNextTick(var0)
end

function var0.SetPivot(arg0, arg1, arg2)
	local var0 = arg1.rect.size
	local var1 = arg1.pivot - arg2
	local var2 = Vector3(var1.x * var0.x, var1.y * var0.y)

	arg1.pivot = arg2
	arg1.localPosition = arg1.localPosition - var2
end

local function var1(arg0, arg1)
	return arg0:InverseTransformPoint(arg1)
end

function var0.RevertItems(arg0)
	for iter0 = #arg0.items, 1, -1 do
		local var0 = arg0.items[iter0]
		local var1 = var0.tr
		local var2 = var0.position

		setParent(var1, arg0._tf, true)

		var1.localPosition = var1(arg0._tf, var2)
	end
end

function var0.ZoomMask(arg0, arg1)
	LeanTween.value(arg0.mask.gameObject, Vector2(418, 936), Vector2(4180, 2000), 0.4):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0)
		arg0.mask.sizeDelta = arg0
	end)):setOnComplete(System.Action(arg1))
end

function var0.MaskItems(arg0)
	for iter0 = #arg0.items, 1, -1 do
		local var0 = arg0.items[iter0].tr

		setParent(var0, arg0.mask, true)
	end
end

function var0.Update(arg0)
	if arg0.setUp then
		arg0:SynItemsPosition()
	end
end

function var0.SynItemsPosition(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		local var0 = iter1.tr
		local var1 = iter1.position

		var0.localPosition = var1(arg0.mask, var1)
	end
end

function var0.Clear(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)

		arg0.handle = nil
	end

	if LeanTween.isTweening(arg0.mask.gameObject) then
		LeanTween.cancel(arg0.mask.gameObject)
	end

	if LeanTween.isTweening(arg0.paintingTr.gameObject) then
		LeanTween.cancel(arg0.paintingTr.gameObject)
	end
end

function var0.Dispose(arg0)
	arg0.exited = true

	arg0:Clear()
end

return var0
