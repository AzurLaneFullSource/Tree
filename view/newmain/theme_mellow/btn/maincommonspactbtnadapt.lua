local var0 = class("MainCommonSpActBtnAdapt")

function var0.Ctor(arg0, arg1)
	arg0.spActBtn = arg1

	pg.DelegateInfo.New(arg0)
	setmetatable(arg0, {
		__index = function(arg0, arg1)
			local var0 = rawget(arg0, "class")

			return var0[arg1] and var0[arg1] or arg0.spActBtn[arg1]
		end
	})
end

function var0.GetUIName(arg0)
	return arg0.spActBtn:GetUIName()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0.spActBtn:Dispose()

	arg0.spActBtn = nil
end

return var0
