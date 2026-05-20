local var0_0 = class("RoleStoryCustomIndexLayer", import("..common.CustomIndexLayer"))

function var0_0.getUIName(arg0_1)
	return "RoleStoryCustomIndexUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	setText(arg0_2._tf:Find("index_panel/Text"), i18n("memory_filter_title_1"))
	setText(arg0_2._tf:Find("index_panel/Text/Text"), i18n("memory_filter_title_2"))
end

function var0_0.InitGroup(arg0_3)
	arg0_3.onInit = true
	arg0_3.contextData.indexDatas = arg0_3.contextData.indexDatas or {}
	arg0_3.dropdownDic = {}
	arg0_3.updateList = {}
	arg0_3.simpleDropdownDic = {}

	for iter0_3, iter1_3 in pairs(arg0_3.contextData.groupList) do
		if iter1_3.dropdown then
			arg0_3:InitDropdown(iter1_3)
		else
			arg0_3:InitCustoms(iter1_3)
		end
	end

	for iter2_3, iter3_3 in ipairs(arg0_3.updateList) do
		iter3_3()
	end
end

return var0_0
