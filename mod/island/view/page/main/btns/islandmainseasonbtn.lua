local var0_0 = class("IslandMainSeasonBtn", import(".IslandMainBaseBtn"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	arg0_1.invitePanel = arg0_1._tf:Find("invitePanel")
	arg0_1.inviteSlider = GetComponent(arg0_1.invitePanel:Find("Slider"), typeof(Image))

	setText(arg0_1.invitePanel:Find("Text"), i18n("match_ui_matching_invitation"))

	arg0_1.timer = FrameTimer.New(function()
		arg0_1:RefreshInvite()
	end, 3, -1)

	arg0_1.timer:Start()
end

function var0_0.Dispose(arg0_3)
	if arg0_3.timer then
		arg0_3.timer:Stop()

		arg0_3.timer = nil
	end

	arg0_3:StopLeanTween()
	var0_0.super.Dispose(arg0_3)
end

function var0_0.RefreshInvite(arg0_4)
	local var0_4 = getProxy(PlayRoomProxy):GetInviteList()

	setActive(arg0_4.invitePanel, var0_4[1] ~= nil)

	if var0_4[1] and arg0_4.endTime ~= var0_4[1].timestamp then
		arg0_4.endTime = var0_4[1].timestamp

		local var1_4 = pg.gameset.match_refuseCD.key_value

		arg0_4:StartLeanTween(pg.TimeMgr.GetInstance():GetServerTime(), var0_4[1].timestamp + var1_4)
	end
end

function var0_0.StartLeanTween(arg0_5, arg1_5, arg2_5)
	arg0_5:StopLeanTween()

	if arg2_5 <= arg1_5 then
		return
	end

	LeanTween.value(arg0_5._tf.gameObject, (arg2_5 - arg1_5) / pg.gameset.match_refuseCD.key_value, 0, arg2_5 - arg1_5):setOnUpdate(System.Action_float(function(arg0_6)
		arg0_5.inviteSlider.fillAmount = arg0_6
	end)):setOnComplete(System.Action(function()
		arg0_5:StopLeanTween()
	end))
end

function var0_0.StopLeanTween(arg0_8)
	LeanTween.cancel(arg0_8._tf.gameObject)
end

return var0_0
