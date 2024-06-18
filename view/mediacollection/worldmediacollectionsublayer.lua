local var0_0 = class("WorldMediaCollectionSubLayer", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.viewParent = arg1_1
	arg0_1.buffer = setmetatable({}, {
		__index = function(arg0_2, arg1_2)
			return function(arg0_3, ...)
				arg0_1:ActionInvoke(arg1_2, ...)
			end
		end,
		__newindex = function()
			errorMsg("Cant write Data in ActionInvoke buffer")
		end
	})
end

function var0_0.SetActive(arg0_5, arg1_5)
	if arg1_5 then
		arg0_5:Show()
	else
		arg0_5:Hide()
	end
end

function var0_0.OnDestroy(arg0_6)
	if arg0_6.loader then
		arg0_6.loader:Clear()

		arg0_6.loader = nil
	end
end

return var0_0
