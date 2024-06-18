local var0_0 = class("MainCommonSpActBtnAdapt")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.spActBtn = arg1_1

	pg.DelegateInfo.New(arg0_1)
	setmetatable(arg0_1, {
		__index = function(arg0_2, arg1_2)
			local var0_2 = rawget(arg0_2, "class")

			return var0_2[arg1_2] and var0_2[arg1_2] or arg0_1.spActBtn[arg1_2]
		end
	})
end

function var0_0.GetUIName(arg0_3)
	return arg0_3.spActBtn:GetUIName()
end

function var0_0.Dispose(arg0_4)
	pg.DelegateInfo.Dispose(arg0_4)
	arg0_4.spActBtn:Dispose()

	arg0_4.spActBtn = nil
end

return var0_0
