local var0_0 = class("IslandMsgBoxForStatusWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForStatus"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.uiItemList = UIItemList.New(arg0_2._tf:Find("scrollrect/list"), arg0_2._tf:Find("scrollrect/list/tpl"))
	arg0_2.timers = {}
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)
	arg0_3:FlushItems(arg0_3.settings)
end

function var0_0.FlushBtn(arg0_4, arg1_4)
	setActive(arg0_4.cancelBtn, false)
end

function var0_0.FlushItems(arg0_5, arg1_5)
	local var0_5 = arg1_5.statusList

	assert(var0_5)
	arg0_5.uiItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5[arg1_6 + 1]
			local var1_6 = "#303a3c"

			if var0_6:IsRed() then
				var1_6 = "#ff7e7e"
			elseif var0_6:IsBlue() then
				var1_6 = "#5dcbff"
			end

			setText(arg2_6:Find("label/Text"), setColorStr(var0_6:GetName(), var1_6))
			setText(arg2_6:Find("Text"), var0_6:GetDesc())
			arg0_5:AddTimer(var0_6:GetEndTime(), arg2_6:Find("time/Text"), var0_6.id)
		end
	end)
	arg0_5.uiItemList:align(#var0_5)
end

function var0_0.AddTimer(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7:RemoveTimer(arg3_7)

	if arg1_7 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		setText(arg2_7, i18n("island_buff_lasttime", pg.TimeMgr.GetInstance():DescCDTime(0)))

		return
	end

	arg0_7.timers[arg3_7] = Timer.New(function()
		local var0_8 = arg1_7 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_8 > 0 then
			setText(arg2_7, i18n("island_buff_lasttime", pg.TimeMgr.GetInstance():DescCDTime(var0_8)))
		else
			arg0_7:RemoveTimer(arg3_7)
			setText(arg2_7, i18n("island_buff_lasttime", pg.TimeMgr.GetInstance():DescCDTime(0)))
		end
	end, 1, -1)

	arg0_7.timers[arg3_7]:Start()
	arg0_7.timers[arg3_7].func()
end

function var0_0.RemoveTimer(arg0_9, arg1_9)
	if arg0_9.timers[arg1_9] then
		arg0_9.timers[arg1_9]:Stop()

		arg0_9.timers[arg1_9] = nil
	end
end

function var0_0.RemoveTimers(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.timers) do
		iter1_10:Stop()
	end

	arg0_10.timers = {}
end

function var0_0.OnHide(arg0_11)
	var0_0.super.OnHide(arg0_11)
	arg0_11:RemoveTimers()
end

function var0_0.OnDestroy(arg0_12)
	arg0_12:RemoveTimers()
end

return var0_0
