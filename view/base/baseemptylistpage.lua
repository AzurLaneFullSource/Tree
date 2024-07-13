local var0_0 = class("BaseEmptyListPage", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "TaskEmptyListUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2._tf:SetSiblingIndex(1)
end

function var0_0.OnInit(arg0_3)
	arg0_3.isShowUI = false
end

function var0_0.SetEmptyText(arg0_4, arg1_4)
	local var0_4 = findTF(arg0_4._tf, "Text")

	setText(var0_4, arg1_4)
end

function var0_0.SetPosY(arg0_5, arg1_5)
	setAnchoredPosition(arg0_5._tf, arg1_5)
end

function var0_0.ShowOrHide(arg0_6, arg1_6)
	if arg0_6.isShowUI == arg1_6 then
		return
	end

	if arg1_6 then
		arg0_6:Show()
	else
		arg0_6:Hide()
	end

	arg0_6.isShowUI = arg1_6
end

return var0_0
