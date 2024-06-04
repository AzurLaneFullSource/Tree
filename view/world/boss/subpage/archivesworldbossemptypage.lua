local var0 = class("ArchivesWorldBossEmptyPage", import(".BaseWorldBossEmptyPage"))

function var0.getUIName(arg0)
	return "ArchivesWorldBossEmptyUI"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_archives_boss_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("list_btn"), function()
		arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0, arg0.activeBtn, function()
		local var0 = WorldBossConst.GetAchieveState()

		if var0 == WorldBossConst.ACHIEVE_STATE_NOSTART then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_no_select_archives"))
		elseif var0 == WorldBossConst.ACHIEVE_STATE_STARTING then
			if WorldBossConst.CanUnlockArchivesBoss() then
				arg0:emit(WorldBossMediator.ON_ACTIVE_ARCHIVES_BOSS)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_archives_item_count_noenough"))
			end
		elseif var0 == WorldBossConst.ACHIEVE_STATE_CLEAR then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_archives_are_clear"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.progressTr, function()
		local var0 = WorldBossConst.GetAchieveBossItemInfo()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0.name,
			content = var0.display,
			iconPath = var0.icon,
			frame = var0.rarity
		})
	end, SFX_PANEL)

	if not pg.NewStoryMgr.GetInstance():IsPlayed("WorldG193") then
		WorldGuider.GetInstance():PlayGuide("WorldG193")
	end
end

function var0.OnUpdate(arg0)
	arg0.archivesWorldbossBtn = arg0.archivesWorldbossBtn or ArchivesWorldbossBtn.New(arg0:findTF("archives_btn"), arg0.event)

	local var0 = WorldBossConst.GetAchieveState()
	local var1

	if var0 == WorldBossConst.ACHIEVE_STATE_NOSTART then
		var1 = "text04"
	elseif var0 == WorldBossConst.ACHIEVE_STATE_CLEAR then
		var1 = "text05"
	end

	if var1 then
		local var2 = arg0.noItem:GetComponent(typeof(Image))

		var2.sprite = GetSpriteFromAtlas("ui/WorldBossUI_atlas", var1)

		var2:SetNativeSize()
	end

	local var3 = WorldBossConst.GetAchieveState() == WorldBossConst.ACHIEVE_STATE_STARTING

	if var3 then
		local var4 = WorldBossConst.GetArchivesId()
		local var5 = WorldBossConst.BossId2MetaId(var4)

		arg0:UpdateUseItemStyle(var5)
	end

	setActive(arg0.useItem, var3)
	setActive(arg0.noItem, not var3)
	arg0.archivesWorldbossBtn:Flush()
end

function var0.OnUpdateRes(arg0)
	if not arg0.progressTxt then
		return
	end

	local var0, var1, var2 = WorldBossConst.GetAchieveBossConsume()
	local var3 = WorldBossConst.GetAchieveBossItemProgress()

	arg0.progressTxt.text = var3 .. "/" .. var2
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.archivesWorldbossBtn then
		arg0.archivesWorldbossBtn:Dispose()

		arg0.archivesWorldbossBtn = nil
	end
end

return var0
