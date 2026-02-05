local var0_0 = class("IslandSignInInvitationCard", import(".IslandBaseVisitorCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.btn1 = arg1_1.transform:Find("btn_1")
	arg0_1.btn1Txt = arg1_1.transform:Find("btn_1/Text"):GetComponent(typeof(Text))
	arg0_1.online = arg1_1.transform:Find("online")
	arg0_1.offline = arg1_1.transform:Find("offline")

	setText(arg0_1.online:Find("Text"), i18n("island_btn_label_online"))

	arg0_1.offlineTxt = arg0_1.offline:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	var0_0.super.Update(arg0_2, arg1_2)

	arg0_2.btnTxt.text = i18n("island_btn_label_invitation")
	arg0_2.btn1Txt.text = i18n("island_btn_label_invitation_already")

	local var0_2 = arg1_2:isOnline()

	setActive(arg0_2.online, var0_2)
	setActive(arg0_2.offline, not var0_2)

	if not var0_2 then
		arg0_2.offlineTxt.text = getOfflineTimeStamp(arg1_2.preOnLineTime)
	end

	setActive(arg0_2.btn, not arg2_2)
	setActive(arg0_2.btn1, arg2_2)
end

return var0_0
