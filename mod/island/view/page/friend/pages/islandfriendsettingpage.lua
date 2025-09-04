local var0_0 = class("IslandFriendSettingPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandFriendAccessUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.toggle = arg0_2:findTF("frame/toggle")
	arg0_2.friendToggle = arg0_2:findTF("frame/on_panel/friend")
	arg0_2.guildToggle = arg0_2:findTF("frame/on_panel/guild")
	arg0_2.codeToggle = arg0_2:findTF("frame/on_panel/code")
	arg0_2.codeTxt = arg0_2:findTF("frame/code_panel/id/Text"):GetComponent(typeof(Text))
	arg0_2.codeMask = arg0_2:findTF("frame/code_panel/mask")
	arg0_2.codeRefreshBtn = arg0_2:findTF("frame/code_panel/refresh")
	arg0_2.codeRefreshTxt = arg0_2:findTF("frame/code_panel/refresh/Text"):GetComponent(typeof(Text))
	arg0_2.codeCopyBtn = arg0_2:findTF("frame/code_panel/copy")
	arg0_2.tipBtn = arg0_2:findTF("frame/tip")

	setText(arg0_2:findTF("frame/title/Text"), i18n("island_open_settings"))
	setText(arg0_2:findTF("frame/on_panel/friend/Text"), i18n("island_friend"))
	setText(arg0_2:findTF("frame/on_panel/guild/Text"), i18n("island_guild"))
	setText(arg0_2:findTF("frame/on_panel/code/Text"), i18n("island_code"))
	setText(arg0_2:findTF("frame/on_tip/Text"), i18n("island_open_settings_tip1"))
	setText(arg0_2:findTF("frame/off_tip/Text"), i18n("island_open_settings_tip2"))
	setText(arg0_2:findTF("frame/code_panel/copy/Text"), i18n("island_btn_label_copy"))
	setText(arg0_2:findTF("frame/toggle/on/Text"), i18n("island_visit_on"))
	setText(arg0_2:findTF("frame/toggle/off/Text_1"), i18n("island_visit_on"))
	setText(arg0_2:findTF("frame/toggle/on/Text_2"), i18n("island_visit_off"))
	setText(arg0_2:findTF("frame/toggle/off/Text"), i18n("island_visit_off"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.codeRefreshBtn, function()
		arg0_3:emit(IslandMediator.REFRESH_INVITECODE, false)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.tipBtn, function()
		arg0_3:emit(IslandFriendPage.EVENT_MSG, i18n("island_open_settings_tip3"))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.codeCopyBtn, function()
		UniPasteBoard.SetClipBoardString(arg0_3.inviteCode)
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
	end, SFX_PANEL)
end

function var0_0.OnRefreshInviteCode(arg0_7)
	arg0_7.inviteCode = getProxy(IslandProxy):GetIsland():GetAccessAgency():GetInviteCode()

	arg0_7:InitInviteCode(true)
	arg0_7:UpdateRefreshBtn()
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)

	local var0_8 = getProxy(IslandProxy):GetIsland():GetAccessAgency()

	arg0_8.openFlags = var0_8:GetOpenFlag()
	arg0_8.inviteCode = var0_8:GetInviteCode()

	arg0_8:InitToggles()
end

function var0_0.InitInviteCode(arg0_9, arg1_9)
	if arg1_9 then
		arg0_9.codeTxt.text = arg0_9.inviteCode
	else
		arg0_9.codeTxt.text = ""
	end
end

function var0_0.InitToggles(arg0_10)
	triggerToggle(arg0_10.toggle, table.contains(arg0_10.openFlags, IslandConst.OPEN_ALL))
	triggerToggle(arg0_10.friendToggle, not table.contains(arg0_10.openFlags, IslandConst.OPEN_FRIEND))
	triggerToggle(arg0_10.guildToggle, not table.contains(arg0_10.openFlags, IslandConst.OPEN_GUILD))
	triggerToggle(arg0_10.codeToggle, table.contains(arg0_10.openFlags, IslandConst.OPEN_CODE))
	arg0_10:InitCodePanenl(table.contains(arg0_10.openFlags, IslandConst.OPEN_CODE))
	onToggle(arg0_10, arg0_10.toggle, function(arg0_11)
		if arg0_11 then
			table.insert(arg0_10.openFlags, IslandConst.OPEN_ALL)
			arg0_10:Send()
		else
			table.removebyvalue(arg0_10.openFlags, IslandConst.OPEN_ALL)
			arg0_10:Send()
		end
	end)
	onToggle(arg0_10, arg0_10.friendToggle, function(arg0_12)
		if arg0_12 then
			table.removebyvalue(arg0_10.openFlags, IslandConst.OPEN_FRIEND)
		else
			table.insert(arg0_10.openFlags, IslandConst.OPEN_FRIEND)
		end

		arg0_10:Send()
	end, SFX_PANEl)
	onToggle(arg0_10, arg0_10.guildToggle, function(arg0_13)
		if arg0_13 then
			table.removebyvalue(arg0_10.openFlags, IslandConst.OPEN_GUILD)
		else
			table.insert(arg0_10.openFlags, IslandConst.OPEN_GUILD)
		end

		arg0_10:Send()
	end, SFX_PANEl)
	onToggle(arg0_10, arg0_10.codeToggle, function(arg0_14)
		if arg0_14 then
			table.insert(arg0_10.openFlags, IslandConst.OPEN_CODE)

			if not arg0_10.inviteCode or arg0_10.inviteCode == "" then
				arg0_10:emit(IslandMediator.REFRESH_INVITECODE, true)
			end
		else
			table.removebyvalue(arg0_10.openFlags, IslandConst.OPEN_CODE)
		end

		arg0_10:InitCodePanenl(arg0_14)
		arg0_10:Send()
	end, SFX_PANEl)
	arg0_10:UpdateRefreshBtn()
end

function var0_0.UpdateRefreshBtn(arg0_15)
	local var0_15 = getProxy(IslandProxy):GetIsland():GetAccessAgency():isFreshInviteCode() and "0" or "1"

	arg0_15.codeRefreshTxt.text = i18n("island_code_refresh_cnt", var0_15)
end

function var0_0.InitCodePanenl(arg0_16, arg1_16)
	setActive(arg0_16.codeMask, not arg1_16)
	arg0_16:InitInviteCode(arg1_16)
end

function var0_0.Send(arg0_17)
	local var0_17 = {}
	local var1_17 = {}
	local var2_17 = getProxy(IslandProxy):GetIsland():GetAccessAgency():GetOpenFlag()
	local var3_17 = arg0_17.openFlags

	for iter0_17, iter1_17 in ipairs(var3_17) do
		if not table.contains(var2_17, iter1_17) then
			table.insert(var0_17, iter1_17)
		end
	end

	for iter2_17, iter3_17 in ipairs(var2_17) do
		if not table.contains(var3_17, iter3_17) then
			table.insert(var1_17, iter3_17)
		end
	end

	if #var0_17 > 0 or #var1_17 > 0 then
		arg0_17:emit(IslandMediator.SET_ACCESS_FLAG, var0_17, var1_17)
	end
end

function var0_0.Hide(arg0_18)
	var0_0.super.Hide(arg0_18)
	removeOnToggle(arg0_18.toggle)
	removeOnToggle(arg0_18.friendToggle)
	removeOnToggle(arg0_18.guildToggle)
	removeOnToggle(arg0_18.codeToggle)
end

function var0_0.OnDestroy(arg0_19)
	if arg0_19:isShowing() then
		arg0_19:Hide()
	end
end

return var0_0
