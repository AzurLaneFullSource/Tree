local var0 = class("BackYardDecorationBasePage", import("....base.BaseSubView"))

function var0.OnLoaded(arg0)
	arg0.scrollRect = arg0._tf:GetComponent("LScrollRect")
end

function var0.OnInit(arg0)
	arg0.cards = {}

	function arg0.scrollRect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end
end

function var0.SetUp(arg0, arg1, arg2, arg3, arg4)
	arg0:Show()

	arg0.pageType = arg1
	arg0.dorm = arg2
	arg0.customTheme = arg3
	arg0.orderMode = arg4

	arg0:OnDisplayList()
	arg0:UpdateFliterData()
end

function var0.Show(arg0)
	setActiveViaLayer(arg0._tf, true)
end

function var0.Hide(arg0)
	setActiveViaLayer(arg0._tf, false)
end

function var0.DormUpdated(arg0, arg1)
	arg0.dorm = arg1

	arg0:UpdateFliterData()
	arg0:OnDormUpdated()
end

function var0.FurnitureUpdated(arg0, arg1)
	arg0:OnFurnitureUpdated(arg1)
end

function var0.CustomThemeAdded(arg0, arg1)
	arg0.customTheme[arg1.id] = arg1

	arg0:CustomThemeUpdated(arg0.customTheme)
end

function var0.CustomThemeDeleted(arg0, arg1)
	for iter0, iter1 in pairs(arg0.customTheme) do
		if iter1.id == arg1 then
			arg0.customTheme[iter0] = nil

			break
		end
	end

	arg0:CustomThemeUpdated(arg0.customTheme)
end

function var0.ThemeUpdated(arg0)
	arg0:OnThemeUpdated()
end

function var0.CustomThemeUpdated(arg0, arg1)
	arg0.customTheme = arg1

	arg0:ThemeUpdated()
end

function var0.OrderModeUpdated(arg0, arg1)
	arg0.orderMode = arg1

	arg0:UpdateFliterData()

	if arg0.contextData.filterPanel:GetLoaded() then
		arg0.contextData.filterPanel:Sort()

		local var0 = arg0.contextData.filterPanel:GetFilterData()

		arg0:OnFilterDone(var0)
	else
		arg0:OnOrderModeUpdated()
	end
end

function var0.UpdateFliterData(arg0)
	arg0.contextData.filterPanel:SetDorm(arg0.dorm)
	arg0.contextData.filterPanel:updateOrderMode(arg0.orderMode)
end

function var0.ShowFilterPanel(arg0, arg1)
	arg0.contextData.filterPanel:setFilterData(arg0:GetDisplays())

	function arg0.contextData.filterPanel.confirmFunc()
		local var0 = arg0.contextData.filterPanel.sortTxt

		if arg1 then
			arg1(var0)
		end

		local var1 = arg0.contextData.filterPanel:GetFilterData()

		arg0:OnFilterDone(var1)
	end

	arg0.contextData.filterPanel:ExecuteAction("Show")
end

function var0.SearchKeyUpdated(arg0, arg1)
	arg0.searchKey = arg1

	arg0:OnSearchKeyChanged()
end

function var0.OnInitItem(arg0, arg1)
	return
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	return
end

function var0.OnDisplayList(arg0)
	return
end

function var0.OnDormUpdated(arg0)
	return
end

function var0.OnFurnitureUpdated(arg0, arg1)
	return
end

function var0.OnThemeUpdated(arg0)
	return
end

function var0.OnOrderModeUpdated(arg0)
	return
end

function var0.OnFilterDone(arg0, arg1)
	return
end

function var0.GetDisplays(arg0)
	return {}
end

function var0.OnSearchKeyChanged(arg0)
	return
end

function var0.OnBackPressed(arg0)
	return false
end

function var0.OnApplyThemeBefore(arg0)
	return
end

function var0.OnApplyThemeAfter(arg0, arg1)
	return
end

return var0
