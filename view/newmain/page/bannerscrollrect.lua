local var0_0 = class("BannerScrollRect")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.container = arg1_1
	arg0_1.dotContainer = arg2_1

	local var0_1 = arg1_1:Find("item")

	arg0_1.items = {
		var0_1
	}

	local var1_1 = arg2_1:Find("dot")

	arg0_1.dots = {
		var1_1
	}
	arg0_1.itemWidth = var0_1.sizeDelta.x
	arg0_1.dotStartPosX = var1_1.localPosition.x
	arg0_1.dotWidth = var1_1.sizeDelta.x
	arg0_1.total = 0
	arg0_1.index = 1
	arg0_1.dragEvent = arg0_1.container:GetComponent("EventTriggerListener")
end

function var0_0.GetItem(arg0_2, arg1_2)
	local var0_2 = arg0_2.items[arg1_2]

	if not var0_2 then
		local var1_2 = arg0_2.items[1]

		var0_2 = Object.Instantiate(var1_2, var1_2.transform.parent)
		arg0_2.items[arg1_2] = var0_2
	end

	return var0_2
end

function var0_0.GetDot(arg0_3, arg1_3)
	local var0_3 = arg0_3.dots[arg1_3]

	if not var0_3 then
		local var1_3 = arg0_3.dots[1]

		var0_3 = Object.Instantiate(var1_3, var1_3.transform.parent)
		arg0_3.dots[arg1_3] = var0_3
	end

	return var0_3
end

function var0_0.AddChild(arg0_4)
	arg0_4.total = arg0_4.total + 1

	local var0_4 = arg0_4:GetDot(arg0_4.total)
	local var1_4 = arg0_4:GetItem(arg0_4.total)

	setActive(var1_4, true)
	setActive(var0_4, true)
	arg0_4:UpdateItemPosition(arg0_4.total, var1_4)
	arg0_4:UpdateDotPosition(arg0_4.total, var0_4)

	return var1_4
end

function var0_0.UpdateItemPosition(arg0_5, arg1_5, arg2_5)
	local var0_5 = (arg1_5 - 1) * arg0_5.itemWidth

	arg2_5.localPosition = Vector3(var0_5, arg2_5.localPosition.y, 0)
end

function var0_0.UpdateDotPosition(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.dotStartPosX + (arg1_6 - 1) * (arg0_6.dotWidth + 15)

	arg2_6.localPosition = Vector3(var0_6, arg2_6.localPosition.y, 0)
end

function var0_0.SetUp(arg0_7)
	if arg0_7.total == 0 then
		arg0_7:Disable()

		return
	end

	arg0_7.container.localPosition = Vector3(0, 0, 0)

	arg0_7:ScrollTo(1)
	arg0_7:AutoScroll()
	arg0_7:AddDrag()
end

function var0_0.AutoScroll(arg0_8)
	arg0_8:RemoveTimer()

	arg0_8.timer = Timer.New(function()
		local var0_9 = (arg0_8.index + 1) % arg0_8.total

		if var0_9 == 0 then
			var0_9 = arg0_8.total
		end

		arg0_8:ScrollTo(var0_9)
	end, 5, -1, true)

	arg0_8.timer:Start()
end

function var0_0.ScrollTo(arg0_10, arg1_10)
	local var0_10 = arg0_10.index or 1
	local var1_10 = (arg1_10 - 1) * arg0_10.itemWidth

	arg0_10.animating = true

	LeanTween.moveLocalX(go(arg0_10.container), -1 * var1_10, 0.2):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		arg0_10.animating = false
	end))

	local var2_10 = arg0_10.dots[var0_10]

	arg0_10:TriggerDot(var2_10, false)

	local var3_10 = arg0_10.dots[arg1_10]

	arg0_10:TriggerDot(var3_10, true)

	arg0_10.index = arg1_10
end

function var0_0.TriggerDot(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg2_12 and Color.New(1, 1, 1, 1) or Color.New(0.4, 0.45, 0.55)

	arg1_12:GetComponent(typeof(Image)).color = var0_12
end

function var0_0.AddDrag(arg0_13)
	local var0_13 = 0
	local var1_13

	arg0_13.dragEvent:AddBeginDragFunc(function(arg0_14, arg1_14)
		if arg0_13.animating then
			return
		end

		arg0_13:Puase()

		var0_13 = arg1_14.position.x
		var1_13 = arg0_13.container.localPosition
	end)
	arg0_13.dragEvent:AddDragFunc(function(arg0_15, arg1_15)
		if arg0_13.animating or not var1_13 then
			return
		end

		local var0_15 = (arg1_15.position.x - var0_13) * 0.5

		arg0_13.container.localPosition = Vector3(var1_13.x + var0_15, var1_13.y, 0)
	end)
	arg0_13.dragEvent:AddDragEndFunc(function(arg0_16, arg1_16)
		if arg0_13.animating or not var1_13 then
			return
		end

		local var0_16 = arg1_16.position.x - var0_13
		local var1_16 = math.floor(math.abs(var0_16 / arg0_13.itemWidth) + 0.5)
		local var2_16 = var0_16 < 0 and arg0_13.index + var1_16 or arg0_13.index - var1_16
		local var3_16 = math.clamp(var2_16, 1, arg0_13.total)

		arg0_13:ScrollTo(var3_16)
		arg0_13:Resume()
	end)
end

function var0_0.Reset(arg0_17)
	arg0_17:RemoveTimer()
	ClearEventTrigger(arg0_17.dragEvent)
	LeanTween.cancel(go(arg0_17.container))

	arg0_17.total = 0
	arg0_17.index = 1
	arg0_17.animating = false

	arg0_17:Disable()
end

function var0_0.Disable(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.items) do
		setActive(iter1_18, false)
	end

	for iter2_18, iter3_18 in ipairs(arg0_18.dots) do
		arg0_18:TriggerDot(iter3_18, false)
		setActive(iter3_18, false)
	end
end

function var0_0.Puase(arg0_19)
	arg0_19:RemoveTimer()
end

function var0_0.Resume(arg0_20)
	if arg0_20.total == 0 then
		return
	end

	arg0_20:AutoScroll()
end

function var0_0.RemoveTimer(arg0_21)
	if arg0_21.timer then
		arg0_21.timer:Stop()

		arg0_21.timer = nil
	end
end

function var0_0.Dispose(arg0_22)
	arg0_22:Reset()

	for iter0_22, iter1_22 in ipairs(arg0_22.items) do
		Object.Destroy(iter1_22.gameObject)
	end

	for iter2_22, iter3_22 in ipairs(arg0_22.dots) do
		Object.Destroy(iter3_22.gameObject)
	end

	arg0_22.items = nil
	arg0_22.dots = nil
end

return var0_0
