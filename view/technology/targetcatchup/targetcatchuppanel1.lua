local var0 = class("TargetCatchupPanel1", import(".BaseTargetCatchupPanel"))

function var0.getUIName(arg0)
	return "TargetCatchupPanel1"
end

function var0.init(arg0)
	arg0.tecID = 1

	arg0:initData()
	arg0:initUI()
end

return var0
