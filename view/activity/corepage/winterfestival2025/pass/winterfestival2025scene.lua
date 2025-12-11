local var0_0 = class("WinterFestival2025Scene", import("...PSS.Hei5.PSSHei5Scene"))

function var0_0.getUIName(arg0_1)
	return "WinterFestival2025UI"
end

function var0_0.initTplVar(arg0_2)
	arg0_2.helpBtnTip = "battlepass_main_help_1211"
	arg0_2.awardPageCls = WinterFestival2025AwardPage
	arg0_2.taskPageCls = WinterFestival2025TaskPage
	arg0_2.chargePageCls = WinterFestival2025CruiseChargePage
	arg0_2.dayTextTip = "winter_battlepass_main_time_title"
	arg0_2.titleTextTip = "winter_cruise_title_1211"
	arg0_2.rewardTip = "winter_battlepass_rewards"
	arg0_2.missionTip = "winter_battlepass_mission"

	local var0_2 = arg0_2._tf:Find("frame/phase/btn_pay/Text")

	setText(var0_2, i18n("winter_cruise_btn_pay"))

	local var1_2 = arg0_2._tf:Find("frame/phase/AwardTipText")

	setText(var1_2, i18n("winter_cruise_pay_reward"))
end

return var0_0
