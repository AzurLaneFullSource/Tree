local var0_0 = class("ReversePacmanInterviewList", import("view.base.BasePanel"))

var0_0.ON_CLICK_TOGGLE = "ReversePacmanInterviewList::ON_CLICK_TOGGLE"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.btnList = {
		ReversePacmanInterviewRoleTypeToggle.New(arg0_2.uiAllTf, arg0_2, ReversePacmanHomeConst.ROLE_TYPE.ALL),
		ReversePacmanInterviewRoleTypeToggle.New(arg0_2.uiChaserTf, arg0_2, ReversePacmanHomeConst.ROLE_TYPE.CHASER),
		ReversePacmanInterviewRoleTypeToggle.New(arg0_2.uiAmbusherTf, arg0_2, ReversePacmanHomeConst.ROLE_TYPE.AMBUSHER),
		ReversePacmanInterviewRoleTypeToggle.New(arg0_2.uiPlannerTf, arg0_2, ReversePacmanHomeConst.ROLE_TYPE.PLANNER)
	}

	setText(arg0_2.uiRoleTitleText, i18n("reverse_pacman_select_role"))
	setText(arg0_2.uiHiredTitleText, i18n("reverse_pacman_hired_role"))

	arg0_2.unHireItemList = {}
	arg0_2.alreadyHireItemList = {}
end

function var0_0.didEnter(arg0_3)
	arg0_3.eventIDList = {
		arg0_3:bind(var0_0.ON_CLICK_TOGGLE, handler(arg0_3, arg0_3.OnClickToggle)),
		arg0_3:bind(ReversePacmanInterviewScene.ON_SELECTED_ROLE, handler(arg0_3, arg0_3.OnSelectedRole))
	}

	arg0_3.btnList[1]:OnTriggerToggle()
end

function var0_0.OnClickToggle(arg0_4, arg1_4, arg2_4, arg3_4)
	arg2_4 = arg2_4 or arg0_4.selectedRoleType
	arg0_4.selectedRoleType = arg2_4

	local var0_4 = ReversePacmanTools.GetActivity()
	local var1_4 = {}

	if arg2_4 == ReversePacmanHomeConst.ROLE_TYPE.ALL then
		var1_4 = var0_4:getConfig("config_client").chasing_char
	else
		var1_4 = ReversePacmanTools.GetRoleListByType(arg2_4)
	end

	local var2_4 = {}
	local var3_4 = {}

	for iter0_4, iter1_4 in ipairs(var1_4) do
		if ReversePacmanTools.IsHireRole(iter1_4) then
			table.insert(var3_4, iter1_4)
		else
			table.insert(var2_4, iter1_4)
		end
	end

	table.sort(var2_4, function(arg0_5, arg1_5)
		local var0_5 = ReversePacmanTools.IsUnlockRole(arg0_5)

		if var0_5 == ReversePacmanTools.IsUnlockRole(arg1_5) then
			return arg0_5 < arg1_5
		else
			return var0_5
		end
	end)

	arg0_4.unHireList = var2_4
	arg0_4.alreadyHireList = var3_4

	arg0_4:RefreshUnHireRoleList()
	arg0_4:RefreshAlreadyHireList()

	local var4_4 = arg3_4 or arg0_4.unHireList[1] or arg0_4.alreadyHireList[1]

	arg0_4:emit(ReversePacmanInterviewScene.ON_SELECTED_ROLE, var4_4)
end

function var0_0.RefreshUnHireRoleList(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.unHireList) do
		arg0_6.unHireItemList[iter0_6] = arg0_6.unHireItemList[iter0_6] or ReversePacmanInterviewRoleItem.New(Object.Instantiate(arg0_6.uiRoleItem, arg0_6.uiUnHireListParent), arg0_6)

		arg0_6.unHireItemList[iter0_6]:SetRoleID(iter1_6)
	end

	for iter2_6 = #arg0_6.unHireList + 1, #arg0_6.unHireItemList do
		arg0_6.unHireItemList[iter2_6]:Show(false)
	end
end

function var0_0.RefreshAlreadyHireList(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.alreadyHireList) do
		arg0_7.alreadyHireItemList[iter0_7] = arg0_7.alreadyHireItemList[iter0_7] or ReversePacmanInterviewRoleItem.New(Object.Instantiate(arg0_7.uiRoleItem, arg0_7.uiAlreadyHireListParent), arg0_7)

		arg0_7.alreadyHireItemList[iter0_7]:SetRoleID(iter1_7)
	end

	for iter2_7 = #arg0_7.alreadyHireList + 1, #arg0_7.alreadyHireItemList do
		arg0_7.alreadyHireItemList[iter2_7]:Show(false)
	end
end

function var0_0.OnSelectedRole(arg0_8, arg1_8, arg2_8)
	arg0_8.selectedID = arg2_8

	for iter0_8, iter1_8 in ipairs(arg0_8.unHireItemList) do
		iter1_8:OnSlectedRole(arg2_8)
	end

	for iter2_8, iter3_8 in ipairs(arg0_8.alreadyHireItemList) do
		iter3_8:OnSlectedRole(arg2_8)
	end
end

function var0_0.willExit(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.eventIDList) do
		arg0_9:disconnect(iter1_9)
	end

	arg0_9.eventIDList = nil

	for iter2_9, iter3_9 in ipairs(arg0_9.unHireItemList) do
		iter3_9:willExit()
	end

	arg0_9.unHireItemList = nil

	for iter4_9, iter5_9 in ipairs(arg0_9.alreadyHireItemList) do
		iter5_9:willExit()
	end

	arg0_9.alreadyHireItemList = nil

	arg0_9:detach()
end

return var0_0
