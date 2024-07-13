local var0_0 = class("TargetCatchupPanel3", import(".BaseTargetCatchupPanel"))

function var0_0.getUIName(arg0_1)
	return "TargetCatchupPanel3"
end

function var0_0.init(arg0_2)
	arg0_2.tecID = 3

	arg0_2:initData()
	arg0_2:initUI()
end

return var0_0
