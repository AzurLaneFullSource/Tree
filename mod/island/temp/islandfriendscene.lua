local var0_0 = class("IslandFriendScene", import("view.friend.FriendScene"))
local var1_0 = 5

var0_0.MODE_VIEW = 0
var0_0.MODE_EDIT = 1

function var0_0.getUIName(arg0_1)
	return "IslandFriendUI"
end

function var0_0.GetGuildMemberList(arg0_2)
	local var0_2 = {}
	local var1_2 = getProxy(GuildProxy):getRawData()

	if var1_2 then
		local var2_2 = getProxy(PlayerProxy):getRawData().id

		for iter0_2, iter1_2 in ipairs(var1_2:getSortMember()) do
			if iter1_2.id ~= var2_2 then
				table.insert(var0_2, iter1_2)
			end
		end
	end

	return var0_2
end

function var0_0.GetWhiteList(arg0_3)
	local var0_3 = {}
	local var1_3 = getProxy(IslandProxy):GetIsland():GetAccessAgency():GetWhiteList()

	for iter0_3, iter1_3 in ipairs(var1_3) do
		table.insert(var0_3, iter1_3)
	end

	return var0_3
end

function var0_0.wrapData(arg0_4)
	local var0_4 = var0_0.super.wrapData(arg0_4)

	var0_4.memberVOs = arg0_4:GetGuildMemberList()

	return var0_4
end

function var0_0.init(arg0_5)
	var0_0.super.init(arg0_5)

	local var0_5 = var1_0

	arg0_5.pages[1] = IslandFriendListPage.New(arg0_5:findTF("pages"), arg0_5.event, arg0_5.contextData)
	arg0_5.pages[2] = IslandFriendSearchPage.New(arg0_5:findTF("pages"), arg0_5.event, arg0_5.contextData)

	table.insert(arg0_5.pages, IslandGuildListPage.New(arg0_5:findTF("pages"), arg0_5.event, arg0_5.contextData))

	local var1_5 = cloneTplTo(arg0_5.toggles[1], arg0_5.togglesTF)

	var1_5:SetSiblingIndex(1)
	table.insert(arg0_5.toggles, var1_5)

	for iter0_5, iter1_5 in pairs(arg0_5.toggles) do
		onToggle(arg0_5, iter1_5, function(arg0_6)
			if arg0_6 then
				arg0_5:switchPage(iter0_5)
			end
		end, SFX_PANEL)
	end

	arg0_5.accessToggles = {
		[IslandConst.ACCESS_TYPE_OPEN] = arg0_5:findTF("authority/on"),
		[IslandConst.ACCESS_TYPE_CLOSE] = arg0_5:findTF("authority/off")
	}
	arg0_5.modifyBtn = arg0_5:findTF("authority/manage")
	arg0_5.confrimBtn = arg0_5:findTF("authority/confrim")
	arg0_5.cancelBtn = arg0_5:findTF("authority/cancel")
end

function var0_0.didEnter(arg0_7)
	var0_0.super.didEnter(arg0_7)
	onButton(arg0_7, arg0_7:findTF("blur_panel/adapt/top/back_btn"), function()
		arg0_7:closeView()
	end, SOUND_BACK)

	arg0_7.contextData.editMode = var0_0.MODE_VIEW

	arg0_7:UpdateWhiteList()
	onButton(arg0_7, arg0_7.modifyBtn, function()
		arg0_7:SwitchEditMode()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.cancelBtn, function()
		arg0_7:SwitchEditMode()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.confrimBtn, function()
		arg0_7:emit(IslandFriendMediator.ACCESS_OP, IslandConst.ACCESS_OP_SET_WHITELIST, arg0_7.contextData.whiteList)
		arg0_7:SwitchEditMode()
	end, SFX_PANEL)
	arg0_7:SetUp()
end

function var0_0.UpdateWhiteList(arg0_12)
	arg0_12.contextData.whiteList = arg0_12:GetWhiteList()
end

function var0_0.SwitchEditMode(arg0_13, arg1_13)
	arg0_13.contextData.editMode = arg1_13 or 1 - arg0_13.contextData.editMode

	setActive(arg0_13.modifyBtn, arg0_13.contextData.editMode == var0_0.MODE_VIEW)
	setActive(arg0_13.confrimBtn, arg0_13.contextData.editMode == var0_0.MODE_EDIT)
	setActive(arg0_13.cancelBtn, arg0_13.contextData.editMode == var0_0.MODE_EDIT)

	local var0_13 = table.indexof(arg0_13.pages, arg0_13.page)

	arg0_13:switchPage(var0_13)
end

function var0_0.UpdateAccessType(arg0_14, arg1_14)
	arg0_14:emit(IslandFriendMediator.MODIFY_ACCESS_TYPE, arg1_14)
end

function var0_0.SetUp(arg0_15)
	arg0_15:SwitchEditMode(var0_0.MODE_VIEW)

	local var0_15 = getProxy(IslandProxy):GetIsland():GetAccessAgency():GetAccessType()

	triggerToggle(arg0_15.accessToggles[var0_15], true)

	for iter0_15, iter1_15 in pairs(arg0_15.accessToggles) do
		onToggle(arg0_15, iter1_15, function(arg0_16)
			if arg0_16 then
				arg0_15:UpdateAccessType(iter0_15)
			end
		end, SFX_PANEL)
	end

	arg0_15:UpdateModifyBtn()
end

function var0_0.UpdateModifyBtn(arg0_17)
	return
end

function var0_0.updateEmpty(arg0_18, arg1_18, arg2_18)
	if arg1_18 == var1_0 then
		local var0_18 = arg2_18.memberVOs
		local var1_18 = i18n("list_empty_tip_friendui")

		setActive(arg0_18.listEmptyTF, not var0_18 or #var0_18 <= 0)
		setText(arg0_18.listEmptyTxt, var1_18)
	else
		var0_0.super.updateEmpty(arg0_18, arg1_18, arg2_18)
	end
end

function var0_0.switchPage(arg0_19, arg1_19)
	var0_0.super.switchPage(arg0_19, arg1_19)

	local var0_19 = arg1_19 == FriendScene.FRIEND_PAGE or arg1_19 == var1_0

	if not var0_19 and arg0_19.contextData.editMode == var0_0.MODE_EDIT then
		triggerButton(arg0_19.cancelBtn)
	end

	setActive(arg0_19.modifyBtn, var0_19)
end

return var0_0
