local var0_0 = class("BackYardDecorationBasePage", import("....base.BaseSubView"))

function var0_0.OnLoaded(arg0_1)
	arg0_1.scrollRect = arg0_1._tf:GetComponent("LScrollRect")
end

function var0_0.OnInit(arg0_2)
	arg0_2.cards = {}

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.SetUp(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	arg0_5:Show()

	arg0_5.pageType = arg1_5
	arg0_5.dorm = arg2_5
	arg0_5.customTheme = arg3_5
	arg0_5.orderMode = arg4_5

	arg0_5:OnDisplayList()
	arg0_5:UpdateFliterData()
end

function var0_0.Show(arg0_6)
	setActiveViaLayer(arg0_6._tf, true)
end

function var0_0.Hide(arg0_7)
	setActiveViaLayer(arg0_7._tf, false)
end

function var0_0.DormUpdated(arg0_8, arg1_8)
	arg0_8.dorm = arg1_8

	arg0_8:UpdateFliterData()
	arg0_8:OnDormUpdated()
end

function var0_0.FurnitureUpdated(arg0_9, arg1_9)
	arg0_9:OnFurnitureUpdated(arg1_9)
end

function var0_0.CustomThemeAdded(arg0_10, arg1_10)
	arg0_10.customTheme[arg1_10.id] = arg1_10

	arg0_10:CustomThemeUpdated(arg0_10.customTheme)
end

function var0_0.CustomThemeDeleted(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg0_11.customTheme) do
		if iter1_11.id == arg1_11 then
			arg0_11.customTheme[iter0_11] = nil

			break
		end
	end

	arg0_11:CustomThemeUpdated(arg0_11.customTheme)
end

function var0_0.ThemeUpdated(arg0_12)
	arg0_12:OnThemeUpdated()
end

function var0_0.CustomThemeUpdated(arg0_13, arg1_13)
	arg0_13.customTheme = arg1_13

	arg0_13:ThemeUpdated()
end

function var0_0.OrderModeUpdated(arg0_14, arg1_14)
	arg0_14.orderMode = arg1_14

	arg0_14:UpdateFliterData()

	if arg0_14.contextData.filterPanel:GetLoaded() then
		arg0_14.contextData.filterPanel:Sort()

		local var0_14 = arg0_14.contextData.filterPanel:GetFilterData()

		arg0_14:OnFilterDone(var0_14)
	else
		arg0_14:OnOrderModeUpdated()
	end
end

function var0_0.UpdateFliterData(arg0_15)
	arg0_15.contextData.filterPanel:SetDorm(arg0_15.dorm)
	arg0_15.contextData.filterPanel:updateOrderMode(arg0_15.orderMode)
end

function var0_0.ShowFilterPanel(arg0_16, arg1_16)
	arg0_16.contextData.filterPanel:setFilterData(arg0_16:GetDisplays())

	function arg0_16.contextData.filterPanel.confirmFunc()
		local var0_17 = arg0_16.contextData.filterPanel.sortTxt

		if arg1_16 then
			arg1_16(var0_17)
		end

		local var1_17 = arg0_16.contextData.filterPanel:GetFilterData()

		arg0_16:OnFilterDone(var1_17)
	end

	arg0_16.contextData.filterPanel:ExecuteAction("Show")
end

function var0_0.SearchKeyUpdated(arg0_18, arg1_18)
	arg0_18.searchKey = arg1_18

	arg0_18:OnSearchKeyChanged()
end

function var0_0.OnInitItem(arg0_19, arg1_19)
	return
end

function var0_0.OnUpdateItem(arg0_20, arg1_20, arg2_20)
	return
end

function var0_0.OnDisplayList(arg0_21)
	return
end

function var0_0.OnDormUpdated(arg0_22)
	return
end

function var0_0.OnFurnitureUpdated(arg0_23, arg1_23)
	return
end

function var0_0.OnThemeUpdated(arg0_24)
	return
end

function var0_0.OnOrderModeUpdated(arg0_25)
	return
end

function var0_0.OnFilterDone(arg0_26, arg1_26)
	return
end

function var0_0.GetDisplays(arg0_27)
	return {}
end

function var0_0.OnSearchKeyChanged(arg0_28)
	return
end

function var0_0.OnBackPressed(arg0_29)
	return false
end

function var0_0.OnApplyThemeBefore(arg0_30)
	return
end

function var0_0.OnApplyThemeAfter(arg0_31, arg1_31)
	return
end

return var0_0
