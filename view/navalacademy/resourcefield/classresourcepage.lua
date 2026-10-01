local var0_0 = class("ClassResourcePage", import(".ResourcePage"))

function var0_0.getUIName(arg0_1)
	return "ClassResourcePage"
end

function var0_0.getResource(arg0_2)
	return {
		"ui/classresourcepage",
		"ui/resourcefieldui_atlas"
	}
end

function var0_0.Load(arg0_3, arg1_3)
	if arg0_3._state ~= var0_0.STATES.NONE or arg0_3.isDownloadingResource then
		return
	end

	arg0_3.isDownloadingResource = true

	SplitPackConst.DownloadByLuaArr(arg0_3:getResource(), function()
		arg0_3.isDownloadingResource = nil

		if arg0_3._state == var0_0.STATES.DESTROY then
			return
		end

		var0_0.super.Load(arg0_3, arg1_3)
	end)
end

function var0_0.OnUpgrade(arg0_5)
	local var0_5 = arg0_5.resourceField:GetUpgradeType()

	arg0_5:emit(ClassMediator.UPGRADE_FIELD, var0_5)
end

return var0_0
