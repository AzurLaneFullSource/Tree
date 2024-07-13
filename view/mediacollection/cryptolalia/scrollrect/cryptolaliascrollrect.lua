local var0_0 = class("CryptolaliaScrollRect")
local var1_0 = 150

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.tpl = arg1_1.gameObject
	arg0_1.tpls = {
		arg0_1.tpl
	}
	arg0_1.startPosition = arg1_1.localPosition
	arg0_1.eventTriggerListener = arg1_1.parent:GetComponent(typeof(EventTriggerListener))
	arg0_1.animation = arg2_1
	arg0_1.items = {}
end

local function var2_0(arg0_2)
	if #arg0_2.tpls > 0 then
		return table.remove(arg0_2.tpls, 1)
	else
		return Object.Instantiate(arg0_2.tpl, arg0_2.tpl.transform.parent)
	end
end

function NewTpl(arg0_3, arg1_3)
	return Object.Instantiate(arg1_3, arg0_3.tpl.transform.parent)
end

function var0_0.Make(arg0_4, arg1_4, arg2_4)
	arg0_4.OnItemInit = arg1_4
	arg0_4.OnSelect = arg2_4
end

function var0_0.Align(arg0_5, arg1_5, arg2_5)
	arg0_5.totalCnt = math.max(5, arg1_5)
	arg0_5.midIndex = math.ceil(arg0_5.totalCnt / 2)

	local var0_5 = {}

	for iter0_5 = 1, arg0_5.totalCnt do
		table.insert(var0_5, function(arg0_6)
			local var0_6 = CryptolaliaScrollRectItem.New(var2_0(arg0_5), arg0_5.midIndex, iter0_5)

			if arg0_5.OnItemInit then
				arg0_5.OnItemInit(var0_6)
			end

			if var0_6:IsMidIndex() and arg0_5.OnSelect then
				arg0_5.OnSelect(var0_6)
			end

			table.insert(arg0_5.items, var0_6)

			if iter0_5 % 3 == 0 then
				onNextTick(arg0_6)
			else
				arg0_6()
			end
		end)
	end

	seriesAsync(var0_5, arg2_5)
end

function var0_0.SetUp(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.items) do
		onButton(arg0_7, iter1_7._go, function()
			if arg0_7.inAnimation then
				return
			end

			arg0_7:JumpToMid(iter1_7:GetIndex())
		end, SFX_PANEL)
	end

	arg0_7:AddDrag()
end

function var0_0.AddDrag(arg0_9)
	arg0_9.eventTriggerListener:AddBeginDragFunc(function(arg0_10, arg1_10)
		arg0_9.position = arg1_10.position
	end)
	arg0_9.eventTriggerListener:AddDragEndFunc(function(arg0_11, arg1_11)
		if not arg0_9.position then
			return
		end

		local var0_11 = arg1_11.position - arg0_9.position

		if math.abs(var0_11.x) > var1_0 and math.abs(var0_11.y) > var1_0 then
			if var0_11.x >= 0 then
				arg0_9:OnListUp()
			end

			if var0_11.x < 0 then
				arg0_9:OnListDown()
			end
		end

		arg0_9.position = nil
	end)
end

function var0_0.OnListUp(arg0_12)
	local var0_12 = arg0_12.midIndex + 1

	arg0_12:trigger(var0_12)
end

function var0_0.OnListDown(arg0_13)
	local var0_13 = arg0_13.midIndex - 1

	arg0_13:trigger(var0_13)
end

function var0_0.trigger(arg0_14, arg1_14)
	local var0_14

	for iter0_14, iter1_14 in ipairs(arg0_14.items) do
		if iter1_14:GetIndex() == arg1_14 then
			var0_14 = iter1_14

			break
		end
	end

	if var0_14 and var0_14:CanInteractable() then
		arg0_14:JumpToMid(var0_14:GetIndex())
	end
end

function var0_0.JumpToMid(arg0_15, arg1_15)
	local var0_15 = math.abs(arg0_15.midIndex - arg1_15)
	local var1_15 = arg0_15.midIndex - arg1_15 <= 0
	local var2_15 = {}

	for iter0_15 = 1, var0_15 do
		table.insert(var2_15, function(arg0_16)
			local var0_16 = var1_15 and arg0_15.midIndex + 1 or arg0_15.midIndex - 1

			if iter0_15 == var0_15 then
				arg0_15:Step(arg0_15.midIndex - var0_16, arg0_16)
			else
				arg0_15:Step(arg0_15.midIndex - var0_16, onNextTick(arg0_16))
			end
		end)
	end

	seriesAsync(var2_15)
end

function var0_0.Step1(arg0_17, arg1_17, arg2_17)
	if arg0_17.inAnimation then
		arg0_17:ClearAnimation()
	end

	local var0_17 = {}
	local var1_17

	for iter0_17, iter1_17 in ipairs(arg0_17.items) do
		local var2_17 = iter1_17:GetIndex() + arg1_17
		local var3_17 = var2_17

		if var3_17 > arg0_17.totalCnt then
			var3_17 = var3_17 - arg0_17.totalCnt
			arg0_17.sinker = CryptolaliaScrollRectItem.New(NewTpl(arg0_17, iter1_17._go), arg0_17.midIndex, 0)
		elseif var3_17 <= 0 then
			var3_17 = arg0_17.totalCnt - math.abs(var3_17)
			arg0_17.sinker = CryptolaliaScrollRectItem.New(NewTpl(arg0_17, iter1_17._go), arg0_17.midIndex, arg0_17.totalCnt + 1)
		end

		if var3_17 == arg0_17.midIndex then
			var1_17 = iter1_17
		end

		table.insert(var0_17, function(arg0_18)
			iter1_17:UpdateIndexWithAnim(var3_17, var2_17, arg0_18)
		end)
	end

	if arg0_17.sinker then
		table.insert(var0_17, function(arg0_19)
			local var0_19 = arg0_17.sinker:GetIndex() + arg1_17

			arg0_17.sinker:UpdateIndexWithAnim(var0_19, var0_19, arg0_19)
		end)
	end

	table.insert(var0_17, function(arg0_20)
		arg0_17.animation:Play(arg1_17):OnComplete(arg0_20):OnTrigger(function()
			if arg0_17.OnSelect then
				arg0_17.OnSelect(var1_17)
			end
		end)
	end)

	arg0_17.inAnimation = true

	parallelAsync(var0_17, function()
		arg0_17:ClearAnimation()
		arg2_17()
	end)
end

function var0_0.Step(arg0_23, arg1_23, arg2_23)
	if arg0_23.inAnimation then
		arg0_23:ClearAnimation()
	end

	local var0_23 = {}
	local var1_23
	local var2_23 = {}
	local var3_23

	for iter0_23, iter1_23 in ipairs(arg0_23.items) do
		local var4_23 = iter1_23:GetIndex() + arg1_23

		if var4_23 > arg0_23.totalCnt then
			var4_23 = var4_23 - arg0_23.totalCnt
			arg0_23.sinker = CryptolaliaScrollRectItem.New(NewTpl(arg0_23, iter1_23._go), arg0_23.midIndex, 0)
			var3_23 = arg0_23.sinker:GetPosition()
		elseif var4_23 <= 0 then
			var4_23 = arg0_23.totalCnt - math.abs(var4_23)
			arg0_23.sinker = CryptolaliaScrollRectItem.New(NewTpl(arg0_23, iter1_23._go), arg0_23.midIndex, arg0_23.totalCnt + 1)
			var3_23 = arg0_23.sinker:GetPosition()
		end

		if var4_23 == arg0_23.midIndex then
			var1_23 = iter1_23
		end

		iter1_23:UpdateIndexSilence(var4_23)
		table.insert(var2_23, iter1_23:GetPosition())
	end

	table.insert(var0_23, function(arg0_24)
		arg0_23.animation:Play(arg1_23):OnComplete(arg0_24):OnUpdate(function(arg0_25)
			for iter0_25, iter1_25 in ipairs(arg0_23.items) do
				iter1_25:SetPosition(var2_23[iter0_25] + arg0_25)
			end

			if arg0_23.sinker then
				arg0_23.sinker:SetPosition(var3_23 + arg0_25)
			end
		end):OnLastUpdate(function()
			for iter0_26, iter1_26 in ipairs(arg0_23.items) do
				iter1_26:Refresh()
			end
		end):OnTrigger(function()
			if arg0_23.OnSelect then
				arg0_23.OnSelect(var1_23)
			end
		end)
	end)

	arg0_23.inAnimation = true

	parallelAsync(var0_23, function()
		arg0_23:ClearAnimation()
		arg2_23()
	end)
end

function var0_0.ClearAnimation(arg0_29)
	if arg0_29.inAnimation then
		arg0_29.animation:Stop()

		for iter0_29, iter1_29 in ipairs(arg0_29.items) do
			iter1_29:ClearAnimation()
		end

		if arg0_29.sinker then
			Object.Destroy(arg0_29.sinker._go)

			arg0_29.sinker = nil
		end

		arg0_29.inAnimation = false
	end
end

function var0_0.Dispose(arg0_30)
	for iter0_30, iter1_30 in ipairs(arg0_30.items) do
		iter1_30:Dispose()
	end

	arg0_30:ClearAnimation()

	arg0_30.items = nil
	arg0_30.OnItemInit = nil
	arg0_30.OnSelect = nil

	pg.DelegateInfo.Dispose(arg0_30)
	arg0_30.eventTriggerListener:AddBeginDragFunc(nil)
	arg0_30.eventTriggerListener:AddDragEndFunc(nil)

	arg0_30.eventTriggerListener = nil
end

return var0_0
