local var0_0 = class("XiaoQiYePtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.hearts = UIItemList.New(arg0_1:findTF("AD/heart"), arg0_1:findTF("AD/heart/mark"))
	arg0_1.helpBtn = arg0_1:findTF("AD/help_btn")

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.gametip_xiaoqiye.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)

	local var0_5, var1_5, var2_5 = arg0_5.ptData:GetLevelProgress()

	arg0_5.hearts:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			setActive(arg2_6, arg1_6 < arg0_5.ptData.level)
		end
	end)
	arg0_5.hearts:align(var1_5)
end

return var0_0
