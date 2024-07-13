local var0_0 = class("TargetCatchupPanel1", import(".BaseTargetCatchupPanel"))

function var0_0.getUIName(arg0_1)
	return "TargetCatchupPanel1"
end

function var0_0.init(arg0_2)
	arg0_2.tecID = 1

	arg0_2:initData()
	arg0_2:initUI()
end

return var0_0
