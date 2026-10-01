local var0_0 = class("PublicGuildMainScene", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "PublicGuildMainUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"guildtechnology",
		"ui/guildrespanel",
		"ui/guildmainui_atlas",
		"guildpainting/guild_office_blue"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.OnUpdateDonateList(arg0_3)
	if arg0_3.page and isa(arg0_3.page, PublicGuildOfficePage) and arg0_3.page:GetLoaded() then
		arg0_3.page:Flush()
	end
end

function var0_0.OnPlayerUpdate(arg0_4, arg1_4)
	arg0_4:SetPlayer(arg1_4)

	if arg0_4.resPage and arg0_4.resPage:GetLoaded() then
		arg0_4.resPage:Update(arg1_4)
	end
end

function var0_0.OnTechGroupUpdate(arg0_5, arg1_5)
	if arg0_5.page and isa(arg0_5.page, PublicGuildTechnologyPage) and arg0_5.page:GetLoaded() then
		arg0_5.page:OnTechGroupUpdate(arg1_5)
	end
end

function var0_0.RefreshAll(arg0_6)
	if arg0_6.page and arg0_6.page:GetLoaded() then
		arg0_6.page:Show(arg0_6.publicGuild)
	end
end

function var0_0.SetPublicGuild(arg0_7, arg1_7)
	arg0_7.publicGuild = arg1_7
end

function var0_0.SetPlayer(arg0_8, arg1_8)
	arg0_8.player = arg1_8
end

function var0_0.init(arg0_9)
	arg0_9._playerResOb = arg0_9._tf:Find("blur_panel/adapt/top/res")
	arg0_9.resPage = PublicGuildResPage.New(arg0_9._playerResOb, arg0_9.event)
	arg0_9.backBtn = arg0_9._tf:Find("blur_panel/adapt/top/back")
	arg0_9.helpBtn = arg0_9._tf:Find("blur_panel/adapt/left_length/frame/help")
	arg0_9.toggles = {
		arg0_9._tf:Find("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot/office"),
		arg0_9._tf:Find("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot/technology")
	}

	local var0_9 = arg0_9._tf:Find("pages")

	arg0_9.pages = {
		PublicGuildOfficePage.New(var0_9, arg0_9.event),
		PublicGuildTechnologyPage.New(var0_9, arg0_9.event)
	}
end

function var0_0.didEnter(arg0_10)
	pg.GuildPaintingMgr.GetInstance():Enter(arg0_10._tf:Find("bg/painting"))
	arg0_10.resPage:ExecuteAction("Update", arg0_10.player)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.helpBtn, function()
		if isa(arg0_10.page, PublicGuildOfficePage) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("guild_public_office_tip")
			})
		elseif isa(arg0_10.page, PublicGuildTechnologyPage) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("guild_public_tech_tip")
			})
		end
	end, SFX_PANEL)

	for iter0_10, iter1_10 in ipairs(arg0_10.toggles) do
		onToggle(arg0_10, iter1_10, function(arg0_13)
			if arg0_13 then
				arg0_10:SwitchPage(iter0_10)
			end
		end, SFX_PANEL)

		if iter0_10 == 1 then
			triggerToggle(iter1_10, true)
		end
	end
end

function var0_0.SwitchPage(arg0_14, arg1_14)
	local var0_14 = arg0_14.pages[arg1_14]

	if arg0_14.page then
		arg0_14.page:Hide()
	end

	var0_14:ExecuteAction("Show", arg0_14.publicGuild)

	arg0_14.page = var0_14
end

function var0_0.willExit(arg0_15)
	pg.GuildPaintingMgr.GetInstance():Exit()
	arg0_15.resPage:Destroy()

	for iter0_15, iter1_15 in pairs(arg0_15.pages) do
		iter1_15:Destroy()
	end
end

return var0_0
