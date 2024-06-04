local var0 = class("CryptolaliaScrollRect")
local var1 = 150

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.tpl = arg1.gameObject
	arg0.tpls = {
		arg0.tpl
	}
	arg0.startPosition = arg1.localPosition
	arg0.eventTriggerListener = arg1.parent:GetComponent(typeof(EventTriggerListener))
	arg0.animation = arg2
	arg0.items = {}
end

local function var2(arg0)
	if #arg0.tpls > 0 then
		return table.remove(arg0.tpls, 1)
	else
		return Object.Instantiate(arg0.tpl, arg0.tpl.transform.parent)
	end
end

function NewTpl(arg0, arg1)
	return Object.Instantiate(arg1, arg0.tpl.transform.parent)
end

function var0.Make(arg0, arg1, arg2)
	arg0.OnItemInit = arg1
	arg0.OnSelect = arg2
end

function var0.Align(arg0, arg1, arg2)
	arg0.totalCnt = math.max(5, arg1)
	arg0.midIndex = math.ceil(arg0.totalCnt / 2)

	local var0 = {}

	for iter0 = 1, arg0.totalCnt do
		table.insert(var0, function(arg0)
			local var0 = CryptolaliaScrollRectItem.New(var2(arg0), arg0.midIndex, iter0)

			if arg0.OnItemInit then
				arg0.OnItemInit(var0)
			end

			if var0:IsMidIndex() and arg0.OnSelect then
				arg0.OnSelect(var0)
			end

			table.insert(arg0.items, var0)

			if iter0 % 3 == 0 then
				onNextTick(arg0)
			else
				arg0()
			end
		end)
	end

	seriesAsync(var0, arg2)
end

function var0.SetUp(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		onButton(arg0, iter1._go, function()
			if arg0.inAnimation then
				return
			end

			arg0:JumpToMid(iter1:GetIndex())
		end, SFX_PANEL)
	end

	arg0:AddDrag()
end

function var0.AddDrag(arg0)
	arg0.eventTriggerListener:AddBeginDragFunc(function(arg0, arg1)
		arg0.position = arg1.position
	end)
	arg0.eventTriggerListener:AddDragEndFunc(function(arg0, arg1)
		if not arg0.position then
			return
		end

		local var0 = arg1.position - arg0.position

		if math.abs(var0.x) > var1 and math.abs(var0.y) > var1 then
			if var0.x >= 0 then
				arg0:OnListUp()
			end

			if var0.x < 0 then
				arg0:OnListDown()
			end
		end

		arg0.position = nil
	end)
end

function var0.OnListUp(arg0)
	local var0 = arg0.midIndex + 1

	arg0:trigger(var0)
end

function var0.OnListDown(arg0)
	local var0 = arg0.midIndex - 1

	arg0:trigger(var0)
end

function var0.trigger(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg0.items) do
		if iter1:GetIndex() == arg1 then
			var0 = iter1

			break
		end
	end

	if var0 and var0:CanInteractable() then
		arg0:JumpToMid(var0:GetIndex())
	end
end

function var0.JumpToMid(arg0, arg1)
	local var0 = math.abs(arg0.midIndex - arg1)
	local var1 = arg0.midIndex - arg1 <= 0
	local var2 = {}

	for iter0 = 1, var0 do
		table.insert(var2, function(arg0)
			local var0 = var1 and arg0.midIndex + 1 or arg0.midIndex - 1

			if iter0 == var0 then
				arg0:Step(arg0.midIndex - var0, arg0)
			else
				arg0:Step(arg0.midIndex - var0, onNextTick(arg0))
			end
		end)
	end

	seriesAsync(var2)
end

function var0.Step1(arg0, arg1, arg2)
	if arg0.inAnimation then
		arg0:ClearAnimation()
	end

	local var0 = {}
	local var1

	for iter0, iter1 in ipairs(arg0.items) do
		local var2 = iter1:GetIndex() + arg1
		local var3 = var2

		if var3 > arg0.totalCnt then
			var3 = var3 - arg0.totalCnt
			arg0.sinker = CryptolaliaScrollRectItem.New(NewTpl(arg0, iter1._go), arg0.midIndex, 0)
		elseif var3 <= 0 then
			var3 = arg0.totalCnt - math.abs(var3)
			arg0.sinker = CryptolaliaScrollRectItem.New(NewTpl(arg0, iter1._go), arg0.midIndex, arg0.totalCnt + 1)
		end

		if var3 == arg0.midIndex then
			var1 = iter1
		end

		table.insert(var0, function(arg0)
			iter1:UpdateIndexWithAnim(var3, var2, arg0)
		end)
	end

	if arg0.sinker then
		table.insert(var0, function(arg0)
			local var0 = arg0.sinker:GetIndex() + arg1

			arg0.sinker:UpdateIndexWithAnim(var0, var0, arg0)
		end)
	end

	table.insert(var0, function(arg0)
		arg0.animation:Play(arg1):OnComplete(arg0):OnTrigger(function()
			if arg0.OnSelect then
				arg0.OnSelect(var1)
			end
		end)
	end)

	arg0.inAnimation = true

	parallelAsync(var0, function()
		arg0:ClearAnimation()
		arg2()
	end)
end

function var0.Step(arg0, arg1, arg2)
	if arg0.inAnimation then
		arg0:ClearAnimation()
	end

	local var0 = {}
	local var1
	local var2 = {}
	local var3

	for iter0, iter1 in ipairs(arg0.items) do
		local var4 = iter1:GetIndex() + arg1

		if var4 > arg0.totalCnt then
			var4 = var4 - arg0.totalCnt
			arg0.sinker = CryptolaliaScrollRectItem.New(NewTpl(arg0, iter1._go), arg0.midIndex, 0)
			var3 = arg0.sinker:GetPosition()
		elseif var4 <= 0 then
			var4 = arg0.totalCnt - math.abs(var4)
			arg0.sinker = CryptolaliaScrollRectItem.New(NewTpl(arg0, iter1._go), arg0.midIndex, arg0.totalCnt + 1)
			var3 = arg0.sinker:GetPosition()
		end

		if var4 == arg0.midIndex then
			var1 = iter1
		end

		iter1:UpdateIndexSilence(var4)
		table.insert(var2, iter1:GetPosition())
	end

	table.insert(var0, function(arg0)
		arg0.animation:Play(arg1):OnComplete(arg0):OnUpdate(function(arg0)
			for iter0, iter1 in ipairs(arg0.items) do
				iter1:SetPosition(var2[iter0] + arg0)
			end

			if arg0.sinker then
				arg0.sinker:SetPosition(var3 + arg0)
			end
		end):OnLastUpdate(function()
			for iter0, iter1 in ipairs(arg0.items) do
				iter1:Refresh()
			end
		end):OnTrigger(function()
			if arg0.OnSelect then
				arg0.OnSelect(var1)
			end
		end)
	end)

	arg0.inAnimation = true

	parallelAsync(var0, function()
		arg0:ClearAnimation()
		arg2()
	end)
end

function var0.ClearAnimation(arg0)
	if arg0.inAnimation then
		arg0.animation:Stop()

		for iter0, iter1 in ipairs(arg0.items) do
			iter1:ClearAnimation()
		end

		if arg0.sinker then
			Object.Destroy(arg0.sinker._go)

			arg0.sinker = nil
		end

		arg0.inAnimation = false
	end
end

function var0.Dispose(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		iter1:Dispose()
	end

	arg0:ClearAnimation()

	arg0.items = nil
	arg0.OnItemInit = nil
	arg0.OnSelect = nil

	pg.DelegateInfo.Dispose(arg0)
	arg0.eventTriggerListener:AddBeginDragFunc(nil)
	arg0.eventTriggerListener:AddDragEndFunc(nil)

	arg0.eventTriggerListener = nil
end

return var0
