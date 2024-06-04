local var0 = class("TargetCatchupPanel3", import(".BaseTargetCatchupPanel"))

function var0.getUIName(arg0)
	return "TargetCatchupPanel3"
end

function var0.init(arg0)
	arg0.tecID = 3

	arg0:initData()
	arg0:initUI()
end

return var0
