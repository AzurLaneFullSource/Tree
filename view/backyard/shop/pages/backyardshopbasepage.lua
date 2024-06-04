local var0 = class("BackYardShopBasePage", import("....base.BaseSubView"))

function var0.PlayerUpdated(arg0, arg1)
	arg0.player = arg1

	arg0:OnPlayerUpdated()
end

function var0.DormUpdated(arg0, arg1)
	arg0.dorm = arg1

	arg0:OnDormUpdated()
end

function var0.FurnituresUpdated(arg0, arg1)
	local var0 = arg0.dorm:GetPurchasedFurnitures()

	for iter0, iter1 in ipairs(arg1) do
		local var1 = var0[iter1]

		arg0:OnDisplayUpdated(var1)
		arg0:OnCardUpdated(var1)
	end
end

function var0.SetUp(arg0, arg1, arg2, arg3, arg4)
	arg0:Show()

	arg0.pageType = arg1
	arg0.dorm = arg2
	arg0.player = arg3

	arg0:OnSetUp()

	if arg4 then
		arg4()
	end
end

function var0.Show(arg0)
	setActiveViaLayer(arg0._tf, true)
end

function var0.Hide(arg0)
	setActiveViaLayer(arg0._tf, false)
end

function var0.ShowFurnitureMsgBox(arg0, arg1)
	arg0.contextData.furnitureMsgBox:ExecuteAction("SetUp", arg1, arg0.dorm, arg0.player)
end

function var0.ShowThemeVOMsgBox(arg0, arg1)
	arg0.contextData.themeMsgBox:ExecuteAction("SetUp", arg1, arg0.dorm, arg0.player)
end

function var0.OnSetUp(arg0)
	return
end

function var0.OnPlayerUpdated(arg0)
	return
end

function var0.OnDisplayUpdated(arg0, arg1)
	return
end

function var0.OnCardUpdated(arg0, arg1)
	return
end

function var0.OnDormUpdated(arg0)
	return
end

return var0
