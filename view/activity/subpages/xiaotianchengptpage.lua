local var0 = class("XiaoTianChengPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.hearts = UIItemList.New(arg0:findTF("AD/heart"), arg0:findTF("AD/heart/mark"))
	arg0.helpBtn = arg0:findTF("AD/Image")

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.gametip_xiaotiancheng.tip
		})
	end, SFX_PANEL)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()

	arg0.hearts:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setActive(arg2, arg1 < arg0.ptData.level)
		end
	end)
	arg0.hearts:align(var1)
end

return var0
