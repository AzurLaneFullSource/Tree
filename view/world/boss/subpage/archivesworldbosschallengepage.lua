local var0_0 = class("ArchivesWorldBossChallengePage", import(".BaseWorldBossChallengePage"))

function var0_0.getUIName(arg0_1)
	return "ArchivesWorldBossChallengeUI"
end

function var0_0.OnFilterBoss(arg0_2, arg1_2)
	return not WorldBossConst._IsCurrBoss(arg1_2)
end

function var0_0.GetResSuffix(arg0_3)
	return "_archives"
end

function var0_0.OnLoaded(arg0_4)
	var0_0.super.OnLoaded(arg0_4)

	arg0_4.switchBtn = arg0_4:findTF("detail_btn")
	arg0_4.currentChallengeBtn = arg0_4:findTF("current_list_btn")
	arg0_4.tipTr = arg0_4:findTF("tip")

	setText(arg0_4.tipTr, i18n("world_boss_archives_boss_tip"))
end

function var0_0.OnInit(arg0_5)
	var0_0.super.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.switchBtn, function()
		local var0_6 = nowWorld():GetBossProxy():GetSelfBoss()

		if var0_6 and WorldBossConst._IsCurrBoss(var0_6) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("current_boss_was_opened"))
		else
			arg0_5:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES)
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.currentChallengeBtn, function()
		arg0_5:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_archives_boss_help.tip
		})
	end, SFX_PANEL)
end

function var0_0.UpdateEmptyCard(arg0_9)
	local var0_9 = arg0_9:findTF("list_panel/mask/tpl"):Find("empty"):GetComponent(typeof(Image))

	if WorldBossConst.GetAchieveState() == WorldBossConst.ACHIEVE_STATE_STARTING then
		local var1_9 = WorldBossConst.GetArchivesId()
		local var2_9 = WorldBossConst.BossId2MetaId(var1_9)

		var0_9.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var2_9, "item_04")
	else
		var0_9.sprite = GetSpriteFromAtlas("MetaWorldboss/extra_empty", "")
	end

	var0_9:SetNativeSize()
end

return var0_0
