local var0_0 = class("RollingCircleRect")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.childs = {}
	arg0_1.tpl = arg1_1
	arg0_1.parent = arg2_1

	arg0_1:AddDragListener()
end

function var0_0.SetCallback(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.binder = arg1_2
	arg0_2.OnSelected = arg2_2
	arg0_2.OnRelease = arg3_2
end

function var0_0.AddItem(arg0_3, arg1_3)
	local var0_3
	local var1_3 = #arg0_3.childs

	if var1_3 <= 0 then
		var0_3 = RollingCircleItem.New(arg0_3.tpl, var1_3 + 1, arg1_3)

		var0_3:Init()
	else
		local var2_3 = Object.Instantiate(arg0_3.tpl, arg0_3.tpl.parent)

		var0_3 = RollingCircleItem.New(var2_3, var1_3 + 1, arg1_3)

		local var3_3 = arg0_3.childs[#arg0_3.childs]
		local var4_3 = arg0_3.childs[1]

		var0_3:SetPrev(var3_3)
		var0_3:SetNext(var4_3)
		var4_3:SetPrev(var0_3)
		var3_3:SetNext(var0_3)
		var0_3:Init()
	end

	table.insert(arg0_3.childs, var0_3)
	onButton(arg0_3, var0_3._tr, function()
		arg0_3:ScrollToCenter(var0_3)

		if arg0_3.OnRelease then
			arg0_3.OnRelease(arg0_3.binder, var0_3)
		end
	end, SFX_PANEL)

	return var0_3
end

function var0_0.ScrollTo(arg0_5, arg1_5)
	Canvas.ForceUpdateCanvases()

	local var0_5 = _.detect(arg0_5.childs, function(arg0_6)
		return arg0_6:GetID() == arg1_5
	end)

	if var0_5 then
		triggerButton(var0_5._tr)
	end
end

function var0_0.AddDragListener(arg0_7)
	local function var0_7(arg0_8)
		local var0_8 = arg0_8 > 0 and -1 or 1

		arg0_7:Step(var0_8)
	end

	local function var1_7()
		local var0_9 = _.detect(arg0_7.childs, function(arg0_10)
			return arg0_10:IsCenter(arg0_7:GetCenterIndex())
		end)

		if arg0_7.OnRelease then
			arg0_7.OnRelease(arg0_7.binder, var0_9)
		end
	end

	var0_0.AddVerticalDrag(arg0_7.parent, var0_7, var1_7)
end

function var0_0.GetCenterIndex(arg0_11)
	local var0_11 = #arg0_11.childs
	local var1_11 = math.ceil(var0_11 / 2)

	return math.min(4, var1_11)
end

function var0_0.ScrollToCenter(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetCenterIndex() - arg1_12:GetIndex()

	if var0_12 == 0 then
		return
	end

	arg0_12:Step(var0_12)
end

function var0_0.Step(arg0_13, arg1_13)
	local var0_13 = arg1_13 > 0 and "GoForward" or "GoBack"
	local var1_13 = math.abs(arg1_13)
	local var2_13 = arg0_13:GetCenterIndex()

	for iter0_13 = 1, var1_13 do
		for iter1_13, iter2_13 in ipairs(arg0_13.childs) do
			iter2_13:Record()
		end

		local var3_13

		for iter3_13, iter4_13 in ipairs(arg0_13.childs) do
			iter4_13[var0_13](iter4_13)

			if iter4_13:IsCenter(var2_13) then
				var3_13 = iter4_13
			end
		end

		if arg0_13.OnSelected then
			arg0_13.OnSelected(arg0_13.binder, var3_13)
		end
	end
end

function var0_0.AddVerticalDrag(arg0_14, arg1_14, arg2_14)
	local var0_14 = GetOrAddComponent(arg0_14, "EventTriggerListener")
	local var1_14 = 90
	local var2_14
	local var3_14 = 0
	local var4_14 = 0
	local var5_14 = 0

	var0_14:AddBeginDragFunc(function(arg0_15, arg1_15)
		var3_14 = 0
		var4_14 = 0
		var2_14 = arg1_15.position
		var5_14 = var2_14.y
	end)
	var0_14:AddDragFunc(function(arg0_16, arg1_16)
		if var5_14 > arg1_16.position.y and var4_14 ~= 0 then
			var2_14 = arg1_16.position
			var4_14 = 0
		elseif var5_14 < arg1_16.position.y and var3_14 ~= 0 then
			var2_14 = arg1_16.position
			var3_14 = 0
		end

		local var0_16 = arg1_16.position.y - var2_14.y
		local var1_16 = math.abs(math.floor(var0_16 / var1_14))

		if arg1_14 and var1_16 > var3_14 then
			var3_14 = var1_16

			arg1_14(var0_16)
		end

		if arg1_14 and var1_16 < var4_14 then
			var4_14 = var1_16

			arg1_14(var0_16)
		end

		var5_14 = var2_14.y
	end)
	var0_14:AddDragEndFunc(function(arg0_17, arg1_17)
		if arg2_14 then
			arg2_14()
		end
	end)
end

function var0_0.Dispose(arg0_18)
	pg.DelegateInfo.Dispose(arg0_18)

	for iter0_18, iter1_18 in ipairs(arg0_18.childs) do
		iter1_18:Dispose()
	end

	ClearEventTrigger(GetOrAddComponent(arg0_18.parent, "EventTriggerListener"))

	arg0_18.binder = nil
	arg0_18.OnSelected = nil
	arg0_18.OnRelease = nil
	arg0_18.childs = nil
end

return var0_0
