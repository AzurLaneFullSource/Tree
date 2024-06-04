local var0 = class("CurrentWorldBossChallengePage", import(".BaseWorldBossChallengePage"))

var0.Listeners = {
	onPtUpdated = "OnPtUpdated",
	onRankListUpdated = "OnRankListUpdated",
	onCacheBossUpdated = "OnCacheBossUpdated"
}

function var0.getUIName(arg0)
	return "CurrentWorldBossChallengeUI"
end

function var0.OnFilterBoss(arg0, arg1)
	return WorldBossConst._IsCurrBoss(arg1)
end

function var0.Setup(arg0, arg1)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.proxy = arg1
end

function var0.AddListeners(arg0, arg1)
	var0.super.AddListeners(arg0, arg1)
	arg1:AddListener(WorldBossProxy.EventPtUpdated, arg0.onPtUpdated)
end

function var0.RemoveListeners(arg0, arg1)
	var0.super.RemoveListeners(arg0, arg1)
	arg1:RemoveListener(WorldBossProxy.EventPtUpdated, arg0.onPtUpdated)
end

function var0.OnPtUpdated(arg0, arg1)
	if arg0.ptBtn then
		arg0.ptBtn:Update()
	end
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.awardPage = WorldBossAwardPage.New(arg0._tf.parent.parent, arg0.event)
	arg0.switchBtn = arg0:findTF("detail_btn")
	arg0.archivesChallengeBtn = arg0:findTF("archives_list_btn")
	arg0.awardBtn = arg0:findTF("main/award_btn")

	setActive(arg0.archivesChallengeBtn, not LOCK_WORLDBOSS_ARCHIVES)
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.switchBtn, function()
		local var0 = nowWorld():GetBossProxy():GetSelfBoss()

		if var0 and not WorldBossConst._IsCurrBoss(var0) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("archives_boss_was_opened"))
		else
			arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CURRENT)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.archivesChallengeBtn, function()
		arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES_CHALLENGE)
	end, SFX_PANEL)
	onToggle(arg0, arg0:findTF("list_panel/frame/filter/toggles/world"), function(arg0)
		arg0.filterFlags[1] = arg0 and WorldBoss.BOSS_TYPE_WORLD or -1

		arg0:CheckToggle()
		arg0:UpdateNonProcessList()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("point/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help_meta.tip
		})
	end, SFX_PANEL)

	arg0.ptBtn = WorldbossPtBtn.New(arg0:findTF("point"))
end

function var0.CheckToggle(arg0)
	var0.super.CheckToggle(arg0)

	if _.all(arg0.filterFlags, function(arg0)
		return arg0 == -1
	end) then
		triggerToggle(arg0:findTF("list_panel/frame/filter/toggles/world"), true)
	end
end

function var0.UpdateMainView(arg0, arg1, arg2)
	var0.super.UpdateMainView(arg0, arg1, arg2)

	local var0 = arg1:isDeath()

	setActive(arg0.awardBtn, not var0)
	onButton(arg0, arg0.awardBtn, function()
		arg0.awardPage:ExecuteAction("Update", arg1)
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.awardPage then
		arg0.awardPage:Destroy()

		arg0.awardPage = nil
	end

	if arg0.ptBtn then
		arg0.ptBtn:Dispose()

		arg0.ptBtn = nil
	end
end

return var0
