local var0 = class("ZProjectPage", import(".TemplatePage.PreviewTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.awardTF = arg0:findTF("AD/award")
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	local var0 = arg0.activity:getConfig("config_client").drop

	updateDrop(arg0.awardTF, var0)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var0)
	end, SFX_PANEL)
end

return var0
