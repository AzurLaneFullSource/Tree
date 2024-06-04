local var0 = class("ArchivesWorldBossChallengePage", import(".BaseWorldBossChallengePage"))

function var0.getUIName(arg0)
	return "ArchivesWorldBossChallengeUI"
end

function var0.OnFilterBoss(arg0, arg1)
	return not WorldBossConst._IsCurrBoss(arg1)
end

function var0.GetResSuffix(arg0)
	return "_archives"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.switchBtn = arg0:findTF("detail_btn")
	arg0.currentChallengeBtn = arg0:findTF("current_list_btn")
	arg0.tipTr = arg0:findTF("tip")

	setText(arg0.tipTr, i18n("world_boss_archives_boss_tip"))
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.switchBtn, function()
		local var0 = nowWorld():GetBossProxy():GetSelfBoss()

		if var0 and WorldBossConst._IsCurrBoss(var0) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("current_boss_was_opened"))
		else
			arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.currentChallengeBtn, function()
		arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_archives_boss_help.tip
		})
	end, SFX_PANEL)
end

function var0.UpdateEmptyCard(arg0)
	local var0 = arg0:findTF("list_panel/mask/tpl"):Find("empty"):GetComponent(typeof(Image))

	if WorldBossConst.GetAchieveState() == WorldBossConst.ACHIEVE_STATE_STARTING then
		local var1 = WorldBossConst.GetArchivesId()
		local var2 = WorldBossConst.BossId2MetaId(var1)

		var0.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var2, "item_04")
	else
		var0.sprite = GetSpriteFromAtlas("MetaWorldboss/extra_empty", "")
	end

	var0:SetNativeSize()
end

return var0
