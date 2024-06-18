local var0_0 = class("HoloLiveMioPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.heartTpl = arg0_1:findTF("HeartTpl", arg0_1.bg)
	arg0_1.heartContainer = arg0_1:findTF("HeartContainer", arg0_1.bg)
	arg0_1.helpBtn = arg0_1:findTF("HelpBtn", arg0_1.bg)

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_dashenling.tip
		})
	end, SFX_PANEL)

	arg0_1.heartUIItemList = UIItemList.New(arg0_1.heartContainer, arg0_1.heartTpl)

	arg0_1.heartUIItemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg1_3 + 1
			local var1_3 = arg0_1.ptData:GetLevelProgress()
			local var2_3 = arg0_1:findTF("Full", arg2_3)

			setActive(var2_3, not (var1_3 < var0_3))
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)

	local var0_4, var1_4 = arg0_4.ptData:GetLevelProgress()

	arg0_4.heartUIItemList:align(var1_4)
end

return var0_0
