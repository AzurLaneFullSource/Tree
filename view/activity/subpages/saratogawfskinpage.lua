local var0 = class("SaratogaWFSkinPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.displayBtn, function()
		arg0:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0.ptData.type,
			dropList = arg0.ptData.dropList,
			targets = arg0.ptData.targets,
			level = arg0.ptData.level,
			count = arg0.ptData.count,
			resId = arg0.ptData.resId
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		local var0, var1 = arg0.ptData:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0.ptData:GetId(),
			arg1 = var1
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, setColorStr(var0, "#F294B8FF") .. "/" .. var1)
end

return var0
