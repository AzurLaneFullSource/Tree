local var0_0 = class("IslandMallDelegationPage", import("Mod.Island.View.page.building.IslandRoleDelegationPage"))

function var0_0.getUIName(arg0_1)
	return "IslandMallDelegationUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("handbookBtn"), function()
		arg0_2:OpenPage(IslandSetMealHandbookPage)
	end)

	local var0_2 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	setActive(arg0_2._tf:Find("handbookBtn"), var0_2:HasAbility(29001))
end

return var0_0
