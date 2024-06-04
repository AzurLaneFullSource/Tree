local var0 = class("TargetCatchupPanel2", import(".BaseTargetCatchupPanel"))

function var0.getUIName(arg0)
	return "TargetCatchupPanel2"
end

function var0.init(arg0)
	arg0.tecID = 2

	arg0:initData()
	arg0:initUI()
end

return var0
