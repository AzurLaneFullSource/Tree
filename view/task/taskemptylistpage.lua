local var0 = class("TaskEmptyListPage", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "TaskEmptyListUI"
end

function var0.OnLoaded(arg0)
	arg0._tf:SetSiblingIndex(1)

	local var0 = findTF(arg0._tf, "Text")

	setText(var0, i18n("list_empty_tip_taskscene"))
end

function var0.OnInit(arg0)
	arg0.isShowUI = false
end

function var0.ShowOrHide(arg0, arg1)
	if arg0.isShowUI == arg1 then
		return
	end

	if arg1 then
		arg0:Show()
	else
		arg0:Hide()
	end

	arg0.isShowUI = arg1
end

return var0
