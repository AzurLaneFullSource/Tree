local var0_0 = class("RyzaAwardRePage", import("view.activity.CorePage.templatePage.CoreAwardTemplatePage"))

function var0_0.RefreshCountText(arg0_1, arg1_1, arg2_1)
	setText(arg2_1:Find("owner/number"), string.format("%s<color=#D3C5BF>/%s</color>", arg1_1.count, arg1_1.config.count))
end

return var0_0
