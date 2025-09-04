local var0_0 = class("IslandAgoraUpgradeMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)
	setText(arg0_2:findTF("cancel/Text"), i18n("island_label_furniture_exit"))
	setText(arg0_2:findTF("confirm/Text"), i18n("island_label_furniture_save"))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)

	local var0_3 = arg0_3.settings

	arg0_3:AddTimer(var0_3.duetime)
end

function var0_0.AddTimer(arg0_4, arg1_4)
	arg0_4:RemoveTimer()

	if arg1_4 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_4:Hide()

		return
	end

	arg0_4.timer = Timer.New(function()
		local var0_5 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg1_4 - var0_5 <= 0 then
			arg0_4:RemoveTimer()
			arg0_4:Hide()
		else
			arg0_4.contentTxt.text = i18n("island_label_furniture_save_tip", pg.TimeMgr.GetInstance():DescCDTime(arg1_4 - var0_5))
		end
	end, 1, -1)

	arg0_4.timer:Start()
	arg0_4.timer.func()
end

function var0_0.RemoveTimer(arg0_6)
	if arg0_6.timer then
		arg0_6.timer:Stop()

		arg0_6.timer = nil
	end
end

function var0_0.OnHide(arg0_7)
	var0_0.super.OnHide(arg0_7)
	arg0_7:RemoveTimer()
end

function var0_0.FlushBtn(arg0_8, arg1_8)
	return
end

function var0_0.OnDestroy(arg0_9)
	arg0_9:RemoveTimer()
end

return var0_0
