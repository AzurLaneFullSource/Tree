local var0 = class("TargetCatchupPanel4", import(".BaseTargetCatchupPanel"))

function var0.getUIName(arg0)
	return "TargetCatchupPanel4"
end

function var0.init(arg0)
	arg0.tecID = 4

	arg0:initData()
	arg0:initUI()
end

return var0
