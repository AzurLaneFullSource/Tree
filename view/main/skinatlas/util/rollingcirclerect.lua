local var0 = class("RollingCircleRect")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.childs = {}
	arg0.tpl = arg1
	arg0.parent = arg2

	arg0:AddDragListener()
end

function var0.SetCallback(arg0, arg1, arg2, arg3)
	arg0.binder = arg1
	arg0.OnSelected = arg2
	arg0.OnRelease = arg3
end

function var0.AddItem(arg0, arg1)
	local var0
	local var1 = #arg0.childs

	if var1 <= 0 then
		var0 = RollingCircleItem.New(arg0.tpl, var1 + 1, arg1)

		var0:Init()
	else
		local var2 = Object.Instantiate(arg0.tpl, arg0.tpl.parent)

		var0 = RollingCircleItem.New(var2, var1 + 1, arg1)

		local var3 = arg0.childs[#arg0.childs]
		local var4 = arg0.childs[1]

		var0:SetPrev(var3)
		var0:SetNext(var4)
		var4:SetPrev(var0)
		var3:SetNext(var0)
		var0:Init()
	end

	table.insert(arg0.childs, var0)
	onButton(arg0, var0._tr, function()
		arg0:ScrollToCenter(var0)

		if arg0.OnRelease then
			arg0.OnRelease(arg0.binder, var0)
		end
	end, SFX_PANEL)

	return var0
end

function var0.ScrollTo(arg0, arg1)
	Canvas.ForceUpdateCanvases()

	local var0 = _.detect(arg0.childs, function(arg0)
		return arg0:GetID() == arg1
	end)

	if var0 then
		triggerButton(var0._tr)
	end
end

function var0.AddDragListener(arg0)
	local function var0(arg0)
		local var0 = arg0 > 0 and -1 or 1

		arg0:Step(var0)
	end

	local function var1()
		local var0 = _.detect(arg0.childs, function(arg0)
			return arg0:IsCenter(arg0:GetCenterIndex())
		end)

		if arg0.OnRelease then
			arg0.OnRelease(arg0.binder, var0)
		end
	end

	var0.AddVerticalDrag(arg0.parent, var0, var1)
end

function var0.GetCenterIndex(arg0)
	local var0 = #arg0.childs
	local var1 = math.ceil(var0 / 2)

	return math.min(4, var1)
end

function var0.ScrollToCenter(arg0, arg1)
	local var0 = arg0:GetCenterIndex() - arg1:GetIndex()

	if var0 == 0 then
		return
	end

	arg0:Step(var0)
end

function var0.Step(arg0, arg1)
	local var0 = arg1 > 0 and "GoForward" or "GoBack"
	local var1 = math.abs(arg1)
	local var2 = arg0:GetCenterIndex()

	for iter0 = 1, var1 do
		for iter1, iter2 in ipairs(arg0.childs) do
			iter2:Record()
		end

		local var3

		for iter3, iter4 in ipairs(arg0.childs) do
			iter4[var0](iter4)

			if iter4:IsCenter(var2) then
				var3 = iter4
			end
		end

		if arg0.OnSelected then
			arg0.OnSelected(arg0.binder, var3)
		end
	end
end

function var0.AddVerticalDrag(arg0, arg1, arg2)
	local var0 = GetOrAddComponent(arg0, "EventTriggerListener")
	local var1 = 90
	local var2
	local var3 = 0
	local var4 = 0
	local var5 = 0

	var0:AddBeginDragFunc(function(arg0, arg1)
		var3 = 0
		var4 = 0
		var2 = arg1.position
		var5 = var2.y
	end)
	var0:AddDragFunc(function(arg0, arg1)
		if var5 > arg1.position.y and var4 ~= 0 then
			var2 = arg1.position
			var4 = 0
		elseif var5 < arg1.position.y and var3 ~= 0 then
			var2 = arg1.position
			var3 = 0
		end

		local var0 = arg1.position.y - var2.y
		local var1 = math.abs(math.floor(var0 / var1))

		if arg1 and var1 > var3 then
			var3 = var1

			arg1(var0)
		end

		if arg1 and var1 < var4 then
			var4 = var1

			arg1(var0)
		end

		var5 = var2.y
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if arg2 then
			arg2()
		end
	end)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	for iter0, iter1 in ipairs(arg0.childs) do
		iter1:Dispose()
	end

	ClearEventTrigger(GetOrAddComponent(arg0.parent, "EventTriggerListener"))

	arg0.binder = nil
	arg0.OnSelected = nil
	arg0.OnRelease = nil
	arg0.childs = nil
end

return var0
