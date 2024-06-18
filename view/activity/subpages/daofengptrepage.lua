local var0_0 = class("DaofengPTRePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)

	local var0_1, var1_1, var2_1 = arg0_1.ptData:GetResProgress()

	setText(arg0_1.progress, setColorStr(var0_1, "#915167") .. "/" .. var1_1)

	local var3_1 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0_1.ptData.resId
	}):getIcon()

	LoadImageSpriteAsync(var3_1, arg0_1:findTF("AD/icon"), false)
end

return var0_0
