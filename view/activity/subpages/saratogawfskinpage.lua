local var0_0 = class("SaratogaWFSkinPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.displayBtn, function()
		arg0_1:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0_1.ptData.type,
			dropList = arg0_1.ptData.dropList,
			targets = arg0_1.ptData.targets,
			level = arg0_1.ptData.level,
			count = arg0_1.ptData.count,
			resId = arg0_1.ptData.resId
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.getBtn, function()
		local var0_4, var1_4 = arg0_1.ptData:GetResProgress()

		arg0_1:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_1.ptData:GetId(),
			arg1 = var1_4
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)

	local var0_5, var1_5, var2_5 = arg0_5.ptData:GetResProgress()

	setText(arg0_5.progress, setColorStr(var0_5, "#F294B8FF") .. "/" .. var1_5)
end

return var0_0
