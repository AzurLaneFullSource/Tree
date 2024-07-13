local var0_0 = class("MainActivityBtnMellowAdapt")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.activityBtn = arg1_1

	pg.DelegateInfo.New(arg0_1)
	setmetatable(arg0_1, {
		__index = function(arg0_2, arg1_2)
			local var0_2 = rawget(arg0_2, "class")

			return var0_2[arg1_2] and var0_2[arg1_2] or arg0_1.activityBtn[arg1_2]
		end
	})
end

function var0_0.UpdatePosition(arg0_3, arg1_3)
	return
end

function var0_0.ResPath(arg0_4)
	return "LinkButton_mellow"
end

function var0_0.Dispose(arg0_5)
	pg.DelegateInfo.Dispose(arg0_5)
	arg0_5.activityBtn:Dispose()

	arg0_5.activityBtn = nil
end

return var0_0
