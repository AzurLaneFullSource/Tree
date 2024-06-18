local var0_0 = class("ZProjectPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.awardTF = arg0_1:findTF("AD/award")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)

	local var0_2 = arg0_2.activity:getConfig("config_client").drop

	updateDrop(arg0_2.awardTF, var0_2)
	onButton(arg0_2, arg0_2.awardTF, function()
		arg0_2:emit(BaseUI.ON_DROP, var0_2)
	end, SFX_PANEL)
end

return var0_0
