local var0_0 = class("IslandTicketCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.bgTF = arg0_1._tf:Find("bg")
	arg0_1.frameTF = arg0_1._tf:Find("icon_bg")
	arg0_1.iconTF = arg0_1._tf:Find("icon_bg/icon")
	arg0_1.nameTF = arg0_1._tf:Find("name")
	arg0_1.countTF = arg0_1._tf:Find("icon_bg/count/Text")
	arg0_1.timePanel = arg0_1._tf:Find("time_panel")
	arg0_1.validTimeTF = arg0_1.timePanel:Find("valid")
	arg0_1.validTimeTxt = arg0_1.validTimeTF:Find("Text"):GetComponent(typeof(Text))
	arg0_1.expiredTF = arg0_1.timePanel:Find("expired")

	setText(arg0_1.expiredTF:Find("Text"), i18n("island_ticket_expired"))

	arg0_1.willExpireTF = arg0_1.timePanel:Find("will_expire")
	arg0_1.willExpireTxt = arg0_1.willExpireTF:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.ticket = arg1_2

	setText(arg0_2.nameTF, arg0_2.ticket:getConfig("name"))
	setText(arg0_2.countTF, arg0_2.ticket:GetCount())
	GetImageSpriteFromAtlasAsync("island/islandframe", arg0_2.ticket:GetFrameName(), arg0_2.frameTF, true)
	GetImageSpriteFromAtlasAsync("ui/islandticketui_atlas", arg0_2.ticket:GetBgName(), arg0_2.bgTF, true)
	GetImageSpriteFromAtlasAsync(arg0_2.ticket:GetIconName(), "", arg0_2.iconTF, true)

	local var0_2 = arg0_2.ticket:IsForever()

	setActive(arg0_2.timePanel, not var0_2)
	arg0_2:UpdateTimer()
	arg0_2:StopTimer()

	if not var0_2 then
		arg0_2:StartTimer()
	end
end

function var0_0.StartTimer(arg0_3)
	arg0_3.timer = Timer.New(function()
		arg0_3:UpdateTimer()
	end, 1, -1)

	arg0_3.timer:Start()
end

function var0_0.UpdateTimer(arg0_5)
	local var0_5 = arg0_5.ticket:IsExpired()

	setActive(arg0_5.expiredTF, var0_5)
	setActive(arg0_5.validTimeTF, not var0_5)

	if not var0_5 then
		local var1_5 = arg0_5.ticket:GetRemainTime()
		local var2_5 = math.floor(var1_5 / 86400)

		if var2_5 >= 1 then
			arg0_5.validTimeTxt.text = i18n("island_ticket_expired_day", var2_5)
		else
			arg0_5.validTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_5)
		end
	end
end

function var0_0.StopTimer(arg0_6)
	if arg0_6.timer then
		arg0_6.timer:Stop()

		arg0_6.timer = nil
	end
end

function var0_0.Dispose(arg0_7)
	arg0_7:StopTimer()
end

return var0_0
