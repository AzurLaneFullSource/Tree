local var0 = class("MainActivityBtnMellowAdapt")

function var0.Ctor(arg0, arg1)
	arg0.activityBtn = arg1

	pg.DelegateInfo.New(arg0)
	setmetatable(arg0, {
		__index = function(arg0, arg1)
			local var0 = rawget(arg0, "class")

			return var0[arg1] and var0[arg1] or arg0.activityBtn[arg1]
		end
	})
end

function var0.UpdatePosition(arg0, arg1)
	return
end

function var0.ResPath(arg0)
	return "LinkButton_mellow"
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0.activityBtn:Dispose()

	arg0.activityBtn = nil
end

return var0
