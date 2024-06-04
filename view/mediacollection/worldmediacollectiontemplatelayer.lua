local var0 = class("WorldMediaCollectionTemplateLayer", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	assert(false, "Need Assign UIName " .. arg0.__cname)
end

function var0.Ctor(arg0, arg1, ...)
	var0.super.Ctor(arg0, ...)

	arg0.viewParent = arg1
	arg0.buffer = setmetatable({}, {
		__index = function(arg0, arg1)
			return function(arg0, ...)
				arg0:ActionInvoke(arg1, ...)
			end
		end,
		__newindex = function()
			errorMsg("Cant write Data in ActionInvoke buffer")
		end
	})
end

function var0.Show(arg0)
	var0.super.Show(arg0)

	if arg0._top then
		arg0.viewParent:Add2TopContainer(arg0._top)
	end
end

function var0.Hide(arg0)
	if arg0._top then
		setParent(arg0._top, arg0._tf)
	end

	var0.super.Hide(arg0)
end

function var0.OnSelected(arg0)
	arg0:Show()
end

function var0.OnReselected(arg0)
	return
end

function var0.OnDeselected(arg0)
	arg0:Hide()
end

function var0.OnBackward(arg0)
	return
end

function var0.Add2LayerContainer(arg0, arg1)
	setParent(arg1, arg0._tf)
end

function var0.Add2TopContainer(arg0, arg1)
	setParent(arg1, arg0._top)
end

function var0.SetActive(arg0, arg1)
	if arg1 then
		arg0:Show()
	else
		arg0:Hide()
	end
end

function var0.UpdateView(arg0)
	return
end

return var0
