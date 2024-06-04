local var0 = class("CurrentWorldBossDetailPage", import(".BaseWorldBossDetailPage"))

function var0.getUIName(arg0)
	return "CurrentWorldBossDetailUI"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.listBtn = arg0:findTF("list_btn")
	arg0.metaWorldbossBtn = MetaWorldbossBtn.New(arg0:findTF("archives_btn"), arg0.event)
	arg0.helpWindow = WorldBossHelpPage.New(arg0._tf, arg0.event)
	arg0.currProgressTr = arg0:findTF("progress")
	arg0.currProgressTxt = arg0:findTF("progress/value"):GetComponent(typeof(Text))
	arg0.ptBtn = WorldbossPtBtn.New(arg0:findTF("point"))
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.listBtn, function()
		arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0, arg0.currProgressTr, function()
		local var0 = WorldBossConst.GetCurrBossItemInfo()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0.name,
			content = var0.display,
			iconPath = var0.icon,
			frame = var0.rarity
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("point/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help_meta.tip
		})
	end, SFX_PANEL)
end

function var0.OnUpdateRes(arg0)
	local var0, var1, var2 = WorldBossConst.GetCurrBossConsume()
	local var3 = WorldBossConst.GetCurrBossItemProgress()

	arg0.currProgressTxt.text = var3 .. "/" .. var2
end

function var0.OnUpdatePt(arg0)
	if arg0.ptBtn then
		arg0.ptBtn:Update()
	end
end

function var0.OnRescue(arg0)
	if arg0.helpWindow then
		arg0.helpWindow:ExecuteAction("Update", arg0.boss)
	end
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	arg0:TryPlayGuide()
end

function var0.TryPlayGuide(arg0)
	if pg.NewStoryMgr.GetInstance():IsPlayed("WorldG191") then
		WorldGuider.GetInstance():PlayGuide("WorldG191_1")
	end

	if pg.NewStoryMgr.GetInstance():IsPlayed("WorldG191_1") and not CurrentWorldBossDetailPage.formDock then
		WorldGuider.GetInstance():PlayGuide("WorldG192")
	end

	CurrentWorldBossDetailPage.formDock = false
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.helpWindow then
		arg0.helpWindow:Destroy()

		arg0.helpWindow = nil
	end

	if arg0.metaWorldbossBtn then
		arg0.metaWorldbossBtn:Dispose()

		arg0.metaWorldbossBtn = nil
	end

	if arg0.ptBtn then
		arg0.ptBtn:Dispose()

		arg0.ptBtn = nil
	end
end

return var0
