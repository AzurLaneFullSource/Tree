local var0_0 = class("IslandAgoraUpgradeMsgboxWindow", import(".IslandCommonMsgboxEXWindow"))

function var0_0.OnLoaded(arg0_1)
	var0_0.super.OnLoaded(arg0_1)
	setText(arg0_1:findTF("cancel/Text"), i18n("island_label_furniture_exit"))
	setText(arg0_1:findTF("confirm/Text"), i18n("island_label_furniture_save"))
end

function var0_0.OnShow(arg0_2)
	var0_0.super.OnShow(arg0_2)

	local var0_2 = arg0_2.settings

	arg0_2:AddTimer(var0_2.duetime)
end

function var0_0.AddTimer(arg0_3, arg1_3)
	arg0_3:RemoveTimer()

	if arg1_3 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_3:Hide()

		return
	end

	arg0_3.timer = Timer.New(function()
		local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg1_3 - var0_4 <= 0 then
			arg0_3:RemoveTimer()
			arg0_3:Hide()
		else
			arg0_3.contentTxt.text = i18n("island_label_furniture_save_tip", pg.TimeMgr.GetInstance():DescCDTime(arg1_3 - var0_4))
		end
	end, 1, -1)

	arg0_3.timer:Start()
	arg0_3.timer.func()
end

function var0_0.RemoveTimer(arg0_5)
	if arg0_5.timer then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end
end

function var0_0.OnHide(arg0_6)
	var0_0.super.OnHide(arg0_6)
	arg0_6:RemoveTimer()
end

function var0_0.FlushBtn(arg0_7, arg1_7)
	return
end

function var0_0.OnDestroy(arg0_8)
	arg0_8:RemoveTimer()
end

return var0_0
