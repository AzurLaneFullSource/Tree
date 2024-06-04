local var0 = class("ClassResourcePage", import(".ResourcePage"))

function var0.getUIName(arg0)
	return "ClassResourcePage"
end

function var0.OnUpgrade(arg0)
	local var0 = arg0.resourceField:GetUpgradeType()

	arg0:emit(ClassMediator.UPGRADE_FIELD, var0)
end

return var0
