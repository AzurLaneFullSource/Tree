local var0 = class("TargetCatchupPanel5", import(".BaseTargetCatchupPanel"))

function var0.getUIName(arg0)
	return "TargetCatchupPanel5"
end

function var0.init(arg0)
	arg0.tecID = 5

	arg0:initData()
	arg0:initUI()
end

return var0
