local var0_0 = class("PublicGuildMainScene", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "PublicGuildMainUI"
end

function var0_0.OnUpdateDonateList(arg0_2)
	if arg0_2.page and isa(arg0_2.page, PublicGuildOfficePage) and arg0_2.page:GetLoaded() then
		arg0_2.page:Flush()
	end
end

function var0_0.OnPlayerUpdate(arg0_3, arg1_3)
	arg0_3:SetPlayer(arg1_3)

	if arg0_3.resPage and arg0_3.resPage:GetLoaded() then
		arg0_3.resPage:Update(arg1_3)
	end
end

function var0_0.OnTechGroupUpdate(arg0_4, arg1_4)
	if arg0_4.page and isa(arg0_4.page, PublicGuildTechnologyPage) and arg0_4.page:GetLoaded() then
		arg0_4.page:OnTechGroupUpdate(arg1_4)
	end
end

function var0_0.RefreshAll(arg0_5)
	if arg0_5.page and arg0_5.page:GetLoaded() then
		arg0_5.page:Show(arg0_5.publicGuild)
	end
end

function var0_0.SetPublicGuild(arg0_6, arg1_6)
	arg0_6.publicGuild = arg1_6
end

function var0_0.SetPlayer(arg0_7, arg1_7)
	arg0_7.player = arg1_7
end

function var0_0.init(arg0_8)
	arg0_8._playerResOb = arg0_8:findTF("blur_panel/adapt/top/res")
	arg0_8.resPage = PublicGuildResPage.New(arg0_8._playerResOb, arg0_8.event)
	arg0_8.backBtn = arg0_8:findTF("blur_panel/adapt/top/back")
	arg0_8.helpBtn = arg0_8:findTF("blur_panel/adapt/left_length/frame/help")
	arg0_8.toggles = {
		arg0_8:findTF("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot/office"),
		arg0_8:findTF("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot/technology")
	}

	local var0_8 = arg0_8:findTF("pages")

	arg0_8.pages = {
		PublicGuildOfficePage.New(var0_8, arg0_8.event),
		PublicGuildTechnologyPage.New(var0_8, arg0_8.event)
	}
end

function var0_0.didEnter(arg0_9)
	pg.GuildPaintingMgr.GetInstance():Enter(arg0_9:findTF("bg/painting"))
	arg0_9.resPage:ExecuteAction("Update", arg0_9.player)
	onButton(arg0_9, arg0_9.backBtn, function()
		arg0_9:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.helpBtn, function()
		if isa(arg0_9.page, PublicGuildOfficePage) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("guild_public_office_tip")
			})
		elseif isa(arg0_9.page, PublicGuildTechnologyPage) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("guild_public_tech_tip")
			})
		end
	end, SFX_PANEL)

	for iter0_9, iter1_9 in ipairs(arg0_9.toggles) do
		onToggle(arg0_9, iter1_9, function(arg0_12)
			if arg0_12 then
				arg0_9:SwitchPage(iter0_9)
			end
		end, SFX_PANEL)

		if iter0_9 == 1 then
			triggerToggle(iter1_9, true)
		end
	end
end

function var0_0.SwitchPage(arg0_13, arg1_13)
	local var0_13 = arg0_13.pages[arg1_13]

	if arg0_13.page then
		arg0_13.page:Hide()
	end

	var0_13:ExecuteAction("Show", arg0_13.publicGuild)

	arg0_13.page = var0_13
end

function var0_0.willExit(arg0_14)
	pg.GuildPaintingMgr.GetInstance():Exit()
	arg0_14.resPage:Destroy()

	for iter0_14, iter1_14 in pairs(arg0_14.pages) do
		iter1_14:Destroy()
	end
end

return var0_0
