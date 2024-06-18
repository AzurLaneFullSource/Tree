local var0_0 = class("GuildTechnologyLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "GuildEmptyUI"
end

function var0_0.setGuild(arg0_2, arg1_2)
	arg0_2.guildVO = arg1_2
end

function var0_0.init(arg0_3)
	arg0_3.technologyPage = GuildTechnologyPage.New(arg0_3._tf, arg0_3.event)
	arg0_3.helpBtn = arg0_3:findTF("frame/help")
end

function var0_0.didEnter(arg0_4)
	arg0_4:UpdatePainting()
	arg0_4.technologyPage:ExecuteAction("SetUp", arg0_4.guildVO)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_tech_tip.tip
		})
	end, SFX_PANEL)
end

function var0_0.UpdatePainting(arg0_6)
	local var0_6 = arg0_6.guildVO:GetOfficePainting()

	pg.GuildPaintingMgr:GetInstance():Update(var0_6, Vector3(-737, -171, 0))
end

function var0_0.UpdateUpgradeList(arg0_7)
	if arg0_7.technologyPage:GetLoaded() then
		arg0_7.technologyPage:UpdateUpgradeList()
	end
end

function var0_0.UpdateBreakOutList(arg0_8)
	if arg0_8.technologyPage:GetLoaded() then
		arg0_8.technologyPage:UpdateBreakOutList()
	end
end

function var0_0.UpdateGuild(arg0_9, arg1_9)
	arg0_9:setGuild(arg1_9)

	if arg0_9.technologyPage and arg0_9.technologyPage:GetLoaded() then
		arg0_9.technologyPage:Update(arg0_9.guildVO)
	end
end

function var0_0.UpdateAll(arg0_10)
	if arg0_10.technologyPage:GetLoaded() then
		arg0_10.technologyPage:Flush()
	end
end

function var0_0.onBackPressed(arg0_11)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_11:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_12)
	arg0_12.technologyPage:Destroy()

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return var0_0
