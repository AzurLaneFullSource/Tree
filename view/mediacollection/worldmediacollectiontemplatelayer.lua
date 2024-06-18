local var0_0 = class("WorldMediaCollectionTemplateLayer", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	assert(false, "Need Assign UIName " .. arg0_1.__cname)
end

function var0_0.Ctor(arg0_2, arg1_2, ...)
	var0_0.super.Ctor(arg0_2, ...)

	arg0_2.viewParent = arg1_2
	arg0_2.buffer = setmetatable({}, {
		__index = function(arg0_3, arg1_3)
			return function(arg0_4, ...)
				arg0_2:ActionInvoke(arg1_3, ...)
			end
		end,
		__newindex = function()
			errorMsg("Cant write Data in ActionInvoke buffer")
		end
	})
end

function var0_0.Show(arg0_6)
	var0_0.super.Show(arg0_6)

	if arg0_6._top then
		arg0_6.viewParent:Add2TopContainer(arg0_6._top)
	end
end

function var0_0.Hide(arg0_7)
	if arg0_7._top then
		setParent(arg0_7._top, arg0_7._tf)
	end

	var0_0.super.Hide(arg0_7)
end

function var0_0.OnSelected(arg0_8)
	arg0_8:Show()
end

function var0_0.OnReselected(arg0_9)
	return
end

function var0_0.OnDeselected(arg0_10)
	arg0_10:Hide()
end

function var0_0.OnBackward(arg0_11)
	return
end

function var0_0.Add2LayerContainer(arg0_12, arg1_12)
	setParent(arg1_12, arg0_12._tf)
end

function var0_0.Add2TopContainer(arg0_13, arg1_13)
	setParent(arg1_13, arg0_13._top)
end

function var0_0.SetActive(arg0_14, arg1_14)
	if arg1_14 then
		arg0_14:Show()
	else
		arg0_14:Hide()
	end
end

function var0_0.UpdateView(arg0_15)
	return
end

return var0_0
