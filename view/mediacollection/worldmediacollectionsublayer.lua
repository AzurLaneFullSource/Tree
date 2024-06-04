local var0 = class("WorldMediaCollectionSubLayer", import("view.base.BaseSubView"))

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

function var0.SetActive(arg0, arg1)
	if arg1 then
		arg0:Show()
	else
		arg0:Hide()
	end
end

function var0.OnDestroy(arg0)
	if arg0.loader then
		arg0.loader:Clear()

		arg0.loader = nil
	end
end

return var0
