local var0_0 = class("ClassResourcePage", import(".ResourcePage"))

function var0_0.getUIName(arg0_1)
	return "ClassResourcePage"
end

function var0_0.OnUpgrade(arg0_2)
	local var0_2 = arg0_2.resourceField:GetUpgradeType()

	arg0_2:emit(ClassMediator.UPGRADE_FIELD, var0_2)
end

return var0_0
