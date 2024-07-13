local var0_0 = class("CurrentWorldBossDetailPage", import(".BaseWorldBossDetailPage"))

function var0_0.getUIName(arg0_1)
	return "CurrentWorldBossDetailUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.listBtn = arg0_2:findTF("list_btn")
	arg0_2.metaWorldbossBtn = MetaWorldbossBtn.New(arg0_2:findTF("archives_btn"), arg0_2.event)
	arg0_2.helpWindow = WorldBossHelpPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.currProgressTr = arg0_2:findTF("progress")
	arg0_2.currProgressTxt = arg0_2:findTF("progress/value"):GetComponent(typeof(Text))
	arg0_2.ptBtn = WorldbossPtBtn.New(arg0_2:findTF("point"))
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.listBtn, function()
		arg0_3:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.currProgressTr, function()
		local var0_5 = WorldBossConst.GetCurrBossItemInfo()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0_5.name,
			content = var0_5.display,
			iconPath = var0_5.icon,
			frame = var0_5.rarity
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("point/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help_meta.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateRes(arg0_7)
	local var0_7, var1_7, var2_7 = WorldBossConst.GetCurrBossConsume()
	local var3_7 = WorldBossConst.GetCurrBossItemProgress()

	arg0_7.currProgressTxt.text = var3_7 .. "/" .. var2_7
end

function var0_0.OnUpdatePt(arg0_8)
	if arg0_8.ptBtn then
		arg0_8.ptBtn:Update()
	end
end

function var0_0.OnRescue(arg0_9)
	if arg0_9.helpWindow then
		arg0_9.helpWindow:ExecuteAction("Update", arg0_9.boss)
	end
end

function var0_0.Show(arg0_10)
	var0_0.super.Show(arg0_10)
	arg0_10:TryPlayGuide()
end

function var0_0.TryPlayGuide(arg0_11)
	if pg.NewStoryMgr.GetInstance():IsPlayed("WorldG191") then
		WorldGuider.GetInstance():PlayGuide("WorldG191_1")
	end

	if pg.NewStoryMgr.GetInstance():IsPlayed("WorldG191_1") and not CurrentWorldBossDetailPage.formDock then
		WorldGuider.GetInstance():PlayGuide("WorldG192")
	end

	CurrentWorldBossDetailPage.formDock = false
end

function var0_0.OnDestroy(arg0_12)
	var0_0.super.OnDestroy(arg0_12)

	if arg0_12.helpWindow then
		arg0_12.helpWindow:Destroy()

		arg0_12.helpWindow = nil
	end

	if arg0_12.metaWorldbossBtn then
		arg0_12.metaWorldbossBtn:Dispose()

		arg0_12.metaWorldbossBtn = nil
	end

	if arg0_12.ptBtn then
		arg0_12.ptBtn:Dispose()

		arg0_12.ptBtn = nil
	end
end

return var0_0
