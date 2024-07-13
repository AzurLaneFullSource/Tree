local var0_0 = class("CurrentWorldBossChallengePage", import(".BaseWorldBossChallengePage"))

var0_0.Listeners = {
	onPtUpdated = "OnPtUpdated",
	onRankListUpdated = "OnRankListUpdated",
	onCacheBossUpdated = "OnCacheBossUpdated"
}

function var0_0.getUIName(arg0_1)
	return "CurrentWorldBossChallengeUI"
end

function var0_0.OnFilterBoss(arg0_2, arg1_2)
	return WorldBossConst._IsCurrBoss(arg1_2)
end

function var0_0.Setup(arg0_3, arg1_3)
	for iter0_3, iter1_3 in pairs(var0_0.Listeners) do
		arg0_3[iter0_3] = function(...)
			var0_0[iter1_3](arg0_3, ...)
		end
	end

	arg0_3.proxy = arg1_3
end

function var0_0.AddListeners(arg0_5, arg1_5)
	var0_0.super.AddListeners(arg0_5, arg1_5)
	arg1_5:AddListener(WorldBossProxy.EventPtUpdated, arg0_5.onPtUpdated)
end

function var0_0.RemoveListeners(arg0_6, arg1_6)
	var0_0.super.RemoveListeners(arg0_6, arg1_6)
	arg1_6:RemoveListener(WorldBossProxy.EventPtUpdated, arg0_6.onPtUpdated)
end

function var0_0.OnPtUpdated(arg0_7, arg1_7)
	if arg0_7.ptBtn then
		arg0_7.ptBtn:Update()
	end
end

function var0_0.OnLoaded(arg0_8)
	var0_0.super.OnLoaded(arg0_8)

	arg0_8.awardPage = WorldBossAwardPage.New(arg0_8._tf.parent.parent, arg0_8.event)
	arg0_8.switchBtn = arg0_8:findTF("detail_btn")
	arg0_8.archivesChallengeBtn = arg0_8:findTF("archives_list_btn")
	arg0_8.awardBtn = arg0_8:findTF("main/award_btn")

	setActive(arg0_8.archivesChallengeBtn, not LOCK_WORLDBOSS_ARCHIVES)
end

function var0_0.OnInit(arg0_9)
	var0_0.super.OnInit(arg0_9)
	onButton(arg0_9, arg0_9.switchBtn, function()
		local var0_10 = nowWorld():GetBossProxy():GetSelfBoss()

		if var0_10 and not WorldBossConst._IsCurrBoss(var0_10) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("archives_boss_was_opened"))
		else
			arg0_9:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CURRENT)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.archivesChallengeBtn, function()
		arg0_9:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES_CHALLENGE)
	end, SFX_PANEL)
	onToggle(arg0_9, arg0_9:findTF("list_panel/frame/filter/toggles/world"), function(arg0_12)
		arg0_9.filterFlags[1] = arg0_12 and WorldBoss.BOSS_TYPE_WORLD or -1

		arg0_9:CheckToggle()
		arg0_9:UpdateNonProcessList()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9:findTF("point/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help_meta.tip
		})
	end, SFX_PANEL)

	arg0_9.ptBtn = WorldbossPtBtn.New(arg0_9:findTF("point"))
end

function var0_0.CheckToggle(arg0_14)
	var0_0.super.CheckToggle(arg0_14)

	if _.all(arg0_14.filterFlags, function(arg0_15)
		return arg0_15 == -1
	end) then
		triggerToggle(arg0_14:findTF("list_panel/frame/filter/toggles/world"), true)
	end
end

function var0_0.UpdateMainView(arg0_16, arg1_16, arg2_16)
	var0_0.super.UpdateMainView(arg0_16, arg1_16, arg2_16)

	local var0_16 = arg1_16:isDeath()

	setActive(arg0_16.awardBtn, not var0_16)
	onButton(arg0_16, arg0_16.awardBtn, function()
		arg0_16.awardPage:ExecuteAction("Update", arg1_16)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_18)
	var0_0.super.OnDestroy(arg0_18)

	if arg0_18.awardPage then
		arg0_18.awardPage:Destroy()

		arg0_18.awardPage = nil
	end

	if arg0_18.ptBtn then
		arg0_18.ptBtn:Dispose()

		arg0_18.ptBtn = nil
	end
end

return var0_0
