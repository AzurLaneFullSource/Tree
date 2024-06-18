local var0_0 = class("ArchivesWorldBossEmptyPage", import(".BaseWorldBossEmptyPage"))

function var0_0.getUIName(arg0_1)
	return "ArchivesWorldBossEmptyUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	onButton(arg0_2, arg0_2.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_archives_boss_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2:findTF("list_btn"), function()
		arg0_2:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.activeBtn, function()
		local var0_5 = WorldBossConst.GetAchieveState()

		if var0_5 == WorldBossConst.ACHIEVE_STATE_NOSTART then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_no_select_archives"))
		elseif var0_5 == WorldBossConst.ACHIEVE_STATE_STARTING then
			if WorldBossConst.CanUnlockArchivesBoss() then
				arg0_2:emit(WorldBossMediator.ON_ACTIVE_ARCHIVES_BOSS)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_archives_item_count_noenough"))
			end
		elseif var0_5 == WorldBossConst.ACHIEVE_STATE_CLEAR then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_archives_are_clear"))
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.progressTr, function()
		local var0_6 = WorldBossConst.GetAchieveBossItemInfo()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0_6.name,
			content = var0_6.display,
			iconPath = var0_6.icon,
			frame = var0_6.rarity
		})
	end, SFX_PANEL)

	if not pg.NewStoryMgr.GetInstance():IsPlayed("WorldG193") then
		WorldGuider.GetInstance():PlayGuide("WorldG193")
	end
end

function var0_0.OnUpdate(arg0_7)
	arg0_7.archivesWorldbossBtn = arg0_7.archivesWorldbossBtn or ArchivesWorldbossBtn.New(arg0_7:findTF("archives_btn"), arg0_7.event)

	local var0_7 = WorldBossConst.GetAchieveState()
	local var1_7

	if var0_7 == WorldBossConst.ACHIEVE_STATE_NOSTART then
		var1_7 = "text04"
	elseif var0_7 == WorldBossConst.ACHIEVE_STATE_CLEAR then
		var1_7 = "text05"
	end

	if var1_7 then
		local var2_7 = arg0_7.noItem:GetComponent(typeof(Image))

		var2_7.sprite = GetSpriteFromAtlas("ui/WorldBossUI_atlas", var1_7)

		var2_7:SetNativeSize()
	end

	local var3_7 = WorldBossConst.GetAchieveState() == WorldBossConst.ACHIEVE_STATE_STARTING

	if var3_7 then
		local var4_7 = WorldBossConst.GetArchivesId()
		local var5_7 = WorldBossConst.BossId2MetaId(var4_7)

		arg0_7:UpdateUseItemStyle(var5_7)
	end

	setActive(arg0_7.useItem, var3_7)
	setActive(arg0_7.noItem, not var3_7)
	arg0_7.archivesWorldbossBtn:Flush()
end

function var0_0.OnUpdateRes(arg0_8)
	if not arg0_8.progressTxt then
		return
	end

	local var0_8, var1_8, var2_8 = WorldBossConst.GetAchieveBossConsume()
	local var3_8 = WorldBossConst.GetAchieveBossItemProgress()

	arg0_8.progressTxt.text = var3_8 .. "/" .. var2_8
end

function var0_0.OnDestroy(arg0_9)
	var0_0.super.OnDestroy(arg0_9)

	if arg0_9.archivesWorldbossBtn then
		arg0_9.archivesWorldbossBtn:Dispose()

		arg0_9.archivesWorldbossBtn = nil
	end
end

return var0_0
