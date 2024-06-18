local var0_0 = class("LittleRenownRePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.heartTpl = arg0_1:findTF("HeartTpl", arg0_1.bg)
	arg0_1.heartContainer = arg0_1:findTF("HeartContainer", arg0_1.bg)
	arg0_1.heartUIItemList = UIItemList.New(arg0_1.heartContainer, arg0_1.heartTpl)

	arg0_1.heartUIItemList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_2 + 1
			local var1_2 = arg0_1.ptData:GetLevelProgress()
			local var2_2 = arg0_1:findTF("Full", arg2_2)

			setActive(var2_2, not (var1_2 < var0_2))
		end
	end)

	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.littleRenown_npc.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)

	local var0_4, var1_4 = arg0_4.ptData:GetLevelProgress()

	arg0_4.heartUIItemList:align(var1_4)
end

function var0_0.OnFirstFlush(arg0_5)
	var0_0.super.OnFirstFlush(arg0_5)
	onButton(arg0_5, arg0_5.battleBtn, function()
		arg0_5:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL)
	end, SFX_PANEL)
end

return var0_0
