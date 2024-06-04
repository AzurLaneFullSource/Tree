local var0 = class("DaofengPTRePage", import(".TemplatePage.PtTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, setColorStr(var0, "#915167") .. "/" .. var1)

	local var3 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0.ptData.resId
	}):getIcon()

	LoadImageSpriteAsync(var3, arg0:findTF("AD/icon"), false)
end

return var0
