local var0_0 = class("BackYardShopBasePage", import("....base.BaseSubView"))

function var0_0.PlayerUpdated(arg0_1, arg1_1)
	arg0_1.player = arg1_1

	arg0_1:OnPlayerUpdated()
end

function var0_0.DormUpdated(arg0_2, arg1_2)
	arg0_2.dorm = arg1_2

	arg0_2:OnDormUpdated()
end

function var0_0.FurnituresUpdated(arg0_3, arg1_3)
	local var0_3 = arg0_3.dorm:GetPurchasedFurnitures()

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		local var1_3 = var0_3[iter1_3]

		arg0_3:OnDisplayUpdated(var1_3)
		arg0_3:OnCardUpdated(var1_3)
	end
end

function var0_0.SetUp(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	arg0_4:Show()

	arg0_4.pageType = arg1_4
	arg0_4.dorm = arg2_4
	arg0_4.player = arg3_4

	arg0_4:OnSetUp()

	if arg4_4 then
		arg4_4()
	end
end

function var0_0.Show(arg0_5)
	setActiveViaLayer(arg0_5._tf, true)
end

function var0_0.Hide(arg0_6)
	setActiveViaLayer(arg0_6._tf, false)
end

function var0_0.ShowFurnitureMsgBox(arg0_7, arg1_7)
	arg0_7.contextData.furnitureMsgBox:ExecuteAction("SetUp", arg1_7, arg0_7.dorm, arg0_7.player)
end

function var0_0.ShowThemeVOMsgBox(arg0_8, arg1_8)
	arg0_8.contextData.themeMsgBox:ExecuteAction("SetUp", arg1_8, arg0_8.dorm, arg0_8.player)
end

function var0_0.OnSetUp(arg0_9)
	return
end

function var0_0.OnPlayerUpdated(arg0_10)
	return
end

function var0_0.OnDisplayUpdated(arg0_11, arg1_11)
	return
end

function var0_0.OnCardUpdated(arg0_12, arg1_12)
	return
end

function var0_0.OnDormUpdated(arg0_13)
	return
end

return var0_0
