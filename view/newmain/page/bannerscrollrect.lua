local var0 = class("BannerScrollRect")

function var0.Ctor(arg0, arg1, arg2)
	arg0.container = arg1
	arg0.dotContainer = arg2

	local var0 = arg1:Find("item")

	arg0.items = {
		var0
	}

	local var1 = arg2:Find("dot")

	arg0.dots = {
		var1
	}
	arg0.itemWidth = var0.sizeDelta.x
	arg0.dotStartPosX = var1.localPosition.x
	arg0.dotWidth = var1.sizeDelta.x
	arg0.total = 0
	arg0.index = 1
	arg0.dragEvent = arg0.container:GetComponent("EventTriggerListener")
end

function var0.GetItem(arg0, arg1)
	local var0 = arg0.items[arg1]

	if not var0 then
		local var1 = arg0.items[1]

		var0 = Object.Instantiate(var1, var1.transform.parent)
		arg0.items[arg1] = var0
	end

	return var0
end

function var0.GetDot(arg0, arg1)
	local var0 = arg0.dots[arg1]

	if not var0 then
		local var1 = arg0.dots[1]

		var0 = Object.Instantiate(var1, var1.transform.parent)
		arg0.dots[arg1] = var0
	end

	return var0
end

function var0.AddChild(arg0)
	arg0.total = arg0.total + 1

	local var0 = arg0:GetDot(arg0.total)
	local var1 = arg0:GetItem(arg0.total)

	setActive(var1, true)
	setActive(var0, true)
	arg0:UpdateItemPosition(arg0.total, var1)
	arg0:UpdateDotPosition(arg0.total, var0)

	return var1
end

function var0.UpdateItemPosition(arg0, arg1, arg2)
	local var0 = (arg1 - 1) * arg0.itemWidth

	arg2.localPosition = Vector3(var0, arg2.localPosition.y, 0)
end

function var0.UpdateDotPosition(arg0, arg1, arg2)
	local var0 = arg0.dotStartPosX + (arg1 - 1) * (arg0.dotWidth + 15)

	arg2.localPosition = Vector3(var0, arg2.localPosition.y, 0)
end

function var0.SetUp(arg0)
	if arg0.total == 0 then
		arg0:Disable()

		return
	end

	arg0.container.localPosition = Vector3(0, 0, 0)

	arg0:ScrollTo(1)
	arg0:AutoScroll()
	arg0:AddDrag()
end

function var0.AutoScroll(arg0)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		local var0 = (arg0.index + 1) % arg0.total

		if var0 == 0 then
			var0 = arg0.total
		end

		arg0:ScrollTo(var0)
	end, 5, -1, true)

	arg0.timer:Start()
end

function var0.ScrollTo(arg0, arg1)
	local var0 = arg0.index or 1
	local var1 = (arg1 - 1) * arg0.itemWidth

	arg0.animating = true

	LeanTween.moveLocalX(go(arg0.container), -1 * var1, 0.2):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		arg0.animating = false
	end))

	local var2 = arg0.dots[var0]

	arg0:TriggerDot(var2, false)

	local var3 = arg0.dots[arg1]

	arg0:TriggerDot(var3, true)

	arg0.index = arg1
end

function var0.TriggerDot(arg0, arg1, arg2)
	local var0 = arg2 and Color.New(1, 1, 1, 1) or Color.New(0.4, 0.45, 0.55)

	arg1:GetComponent(typeof(Image)).color = var0
end

function var0.AddDrag(arg0)
	local var0 = 0
	local var1

	arg0.dragEvent:AddBeginDragFunc(function(arg0, arg1)
		if arg0.animating then
			return
		end

		arg0:Puase()

		var0 = arg1.position.x
		var1 = arg0.container.localPosition
	end)
	arg0.dragEvent:AddDragFunc(function(arg0, arg1)
		if arg0.animating or not var1 then
			return
		end

		local var0 = (arg1.position.x - var0) * 0.5

		arg0.container.localPosition = Vector3(var1.x + var0, var1.y, 0)
	end)
	arg0.dragEvent:AddDragEndFunc(function(arg0, arg1)
		if arg0.animating or not var1 then
			return
		end

		local var0 = arg1.position.x - var0
		local var1 = math.floor(math.abs(var0 / arg0.itemWidth) + 0.5)
		local var2 = var0 < 0 and arg0.index + var1 or arg0.index - var1
		local var3 = math.clamp(var2, 1, arg0.total)

		arg0:ScrollTo(var3)
		arg0:Resume()
	end)
end

function var0.Reset(arg0)
	arg0:RemoveTimer()
	ClearEventTrigger(arg0.dragEvent)
	LeanTween.cancel(go(arg0.container))

	arg0.total = 0
	arg0.index = 1
	arg0.animating = false

	arg0:Disable()
end

function var0.Disable(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		setActive(iter1, false)
	end

	for iter2, iter3 in ipairs(arg0.dots) do
		arg0:TriggerDot(iter3, false)
		setActive(iter3, false)
	end
end

function var0.Puase(arg0)
	arg0:RemoveTimer()
end

function var0.Resume(arg0)
	if arg0.total == 0 then
		return
	end

	arg0:AutoScroll()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0:Reset()

	for iter0, iter1 in ipairs(arg0.items) do
		Object.Destroy(iter1.gameObject)
	end

	for iter2, iter3 in ipairs(arg0.dots) do
		Object.Destroy(iter3.gameObject)
	end

	arg0.items = nil
	arg0.dots = nil
end

return var0
