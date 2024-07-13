local var0_0 = class("XiaoDaDiPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.hearts = UIItemList.New(arg0_1:findTF("AD/heart"), arg0_1:findTF("AD/heart/mark"))
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)

	local var0_4, var1_4, var2_4 = arg0_4.ptData:GetLevelProgress()
	local var3_4, var4_4, var5_4 = arg0_4.ptData:GetResProgress()

	arg0_4.hearts:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			setActive(arg2_5, arg1_5 < arg0_4.ptData.level)
		end
	end)
	setText(arg0_4.progress, var3_4 .. "/" .. var4_4)
	arg0_4.hearts:align(var1_4)
end

return var0_0
