local var0_0 = class("TaskEmptyListPage", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "TaskEmptyListUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2._tf:SetSiblingIndex(1)

	local var0_2 = findTF(arg0_2._tf, "Text")

	setText(var0_2, i18n("list_empty_tip_taskscene"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.isShowUI = false
end

function var0_0.ShowOrHide(arg0_4, arg1_4)
	if arg0_4.isShowUI == arg1_4 then
		return
	end

	if arg1_4 then
		arg0_4:Show()
	else
		arg0_4:Hide()
	end

	arg0_4.isShowUI = arg1_4
end

return var0_0
