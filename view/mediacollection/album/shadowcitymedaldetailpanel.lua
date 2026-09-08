local var0_0 = class("ShadowCityMedalDetailPanel", import("view.mediaCollection.album.MedalDetailPanel"))

function var0_0.InitUI(arg0_1)
	var0_0.super.InitUI(arg0_1)

	arg0_1._stateBg = findTF(arg0_1._tf, "state_bg")
	arg0_1._progressText = findTF(arg0_1._tf, "progress/unlock/label")
	arg0_1._progressLockText = findTF(arg0_1._tf, "progress/lock/label")

	setText(arg0_1._progressLockText, i18n("word_lock"))
end

function var0_0.UpdateMedal(arg0_2)
	var0_0.super.UpdateMedal(arg0_2)

	local var0_2 = arg0_2._medalGroup:GetMedalGroupState()

	SetActive(arg0_2._stateBg, var0_2 ~= ActivityMedalGroup.STATE_ACTIVE)

	local var1_2 = findTF(arg0_2._tf, "progress/unlock")

	if var1_2 then
		SetActive(var1_2, arg0_2._medal.timeStamp)
	end
end

return var0_0
