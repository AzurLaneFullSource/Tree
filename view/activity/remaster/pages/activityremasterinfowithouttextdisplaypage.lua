local var0_0 = class("ActivityRemasterInfoWithoutTextDisplayPage", import(".ActivityRemasterInfoDisplayPage"))

function var0_0.getUIName(arg0_1)
	return "ActivityRemasterInfoWithoutTextDisplayPage"
end

function var0_0.OpenDesc(arg0_2, arg1_2)
	arg0_2.awardPage:ExecuteAction("Show", arg1_2)
end

return var0_0
