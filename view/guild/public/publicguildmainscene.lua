local var0 = class("PublicGuildMainScene", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "PublicGuildMainUI"
end

function var0.OnUpdateDonateList(arg0)
	if arg0.page and isa(arg0.page, PublicGuildOfficePage) and arg0.page:GetLoaded() then
		arg0.page:Flush()
	end
end

function var0.OnPlayerUpdate(arg0, arg1)
	arg0:SetPlayer(arg1)

	if arg0.resPage and arg0.resPage:GetLoaded() then
		arg0.resPage:Update(arg1)
	end
end

function var0.OnTechGroupUpdate(arg0, arg1)
	if arg0.page and isa(arg0.page, PublicGuildTechnologyPage) and arg0.page:GetLoaded() then
		arg0.page:OnTechGroupUpdate(arg1)
	end
end

function var0.RefreshAll(arg0)
	if arg0.page and arg0.page:GetLoaded() then
		arg0.page:Show(arg0.publicGuild)
	end
end

function var0.SetPublicGuild(arg0, arg1)
	arg0.publicGuild = arg1
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.init(arg0)
	arg0._playerResOb = arg0:findTF("blur_panel/adapt/top/res")
	arg0.resPage = PublicGuildResPage.New(arg0._playerResOb, arg0.event)
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back")
	arg0.helpBtn = arg0:findTF("blur_panel/adapt/left_length/frame/help")
	arg0.toggles = {
		arg0:findTF("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot/office"),
		arg0:findTF("blur_panel/adapt/left_length/frame/scroll_rect/tagRoot/technology")
	}

	local var0 = arg0:findTF("pages")

	arg0.pages = {
		PublicGuildOfficePage.New(var0, arg0.event),
		PublicGuildTechnologyPage.New(var0, arg0.event)
	}
end

function var0.didEnter(arg0)
	pg.GuildPaintingMgr.GetInstance():Enter(arg0:findTF("bg/painting"))
	arg0.resPage:ExecuteAction("Update", arg0.player)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		if isa(arg0.page, PublicGuildOfficePage) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("guild_public_office_tip")
			})
		elseif isa(arg0.page, PublicGuildTechnologyPage) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("guild_public_tech_tip")
			})
		end
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				arg0:SwitchPage(iter0)
			end
		end, SFX_PANEL)

		if iter0 == 1 then
			triggerToggle(iter1, true)
		end
	end
end

function var0.SwitchPage(arg0, arg1)
	local var0 = arg0.pages[arg1]

	if arg0.page then
		arg0.page:Hide()
	end

	var0:ExecuteAction("Show", arg0.publicGuild)

	arg0.page = var0
end

function var0.willExit(arg0)
	pg.GuildPaintingMgr.GetInstance():Exit()
	arg0.resPage:Destroy()

	for iter0, iter1 in pairs(arg0.pages) do
		iter1:Destroy()
	end
end

return var0
