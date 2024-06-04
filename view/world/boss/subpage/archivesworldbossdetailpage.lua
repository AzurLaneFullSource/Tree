local var0 = class("ArchivesWorldBossDetailPage", import(".BaseWorldBossDetailPage"))

function var0.getUIName(arg0)
	return "ArchivesWorldBossDetailUI"
end

function var0.OnAutoBattleResult(arg0, arg1)
	local var0 = arg1.cnt
	local var1 = arg1.damage
	local var2 = arg1.oil

	arg0.autoBattleResultMsg:ExecuteAction("Show", {
		battleCnt = var0,
		damage = var1,
		oil = var2
	})
	arg0:Flush()
	arg0:UpdatePainting(arg0.groupId)
end

function var0.OnAutoBattleStart(arg0)
	arg0:Flush()
	arg0:UpdatePainting(arg0.groupId)
end

function var0.GetResSuffix(arg0)
	return "_archives"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.currProgressTr = arg0:findTF("progress")
	arg0.currProgressTxt = arg0:findTF("progress/value"):GetComponent(typeof(Text))
	arg0.listBtn = arg0:findTF("list_btn")
	arg0.archivesWorldbossBtn = ArchivesWorldbossBtn.New(arg0:findTF("archives_btn"), arg0.event)
	arg0.autoBattleBtn = arg0:findTF("btns/auto_btn")
	arg0.autoBattleTimeTxt = arg0.autoBattleBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.battleMask = arg0:findTF("battle_mask")
	arg0.helpWindow = ArchivesWorldBossHelpPage.New(arg0._parentTf.parent, arg0.event)
	arg0.autoBattleTip = ArchivesWorldBossAutoBattleTipPage.New(arg0._parentTf.parent, arg0.event)
	arg0.autoBattleMsg = ArchivesWorldBossAutoBattleMsgbox.New(arg0._parentTf.parent, arg0.event)
	arg0.autoBattleResultMsg = ArchivesWorldBossAutoBattleResultMsg.New(arg0._parentTf.parent, arg0.event)
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.listBtn, function()
		arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0, arg0.currProgressTr, function()
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
	onButton(arg0, arg0:findTF("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_archives_boss_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.battleMask, function()
		triggerButton(arg0.autoBattleBtn)
	end, SFX_PANEL)
	onButton(arg0, arg0.autoBattleBtn, function()
		if pg.TimeMgr.GetInstance():GetServerTime() + WorldBossConst.GetArchivesBossAutoBattleSecond() > arg0.boss:GetExpiredTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_no_time_to_auto_battle"))

			return
		end

		local var0 = WorldBossConst.GetAutoBattleState(arg0.boss)

		if var0 == WorldBossConst.AUTO_BATTLE_STATE_STARTING then
			arg0.autoBattleMsg:ExecuteAction("Show", {
				onContent = function()
					local var0 = WorldBossConst.GetAutoBattleLeftTime()

					if var0 <= 0 then
						return nil
					end

					return (pg.TimeMgr.GetInstance():DescCDTime(var0))
				end,
				title = i18n("world_boss_archives_stop_auto_battle_title"),
				yesText = i18n("world_boss_archives_continue_auto_battle"),
				noText = i18n("world_boss_archives_stop_auto_battle"),
				onNo = function()
					arg0:emit(WorldBossMediator.ON_ARCHIVES_BOSS_STOP_AUTO_BATTLE, arg0.boss.id)
				end
			})
		elseif var0 == WorldBossConst.AUTO_BATTLE_STATE_HIDE then
			pg.TipsMgr.GetInstance():ShowTip(i18n("world_word_expired"))
		elseif var0 == WorldBossConst.AUTO_BATTLE_STATE_LOCK then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_archives_auto_battle_unopen"))
		else
			local var1 = WorldBossConst.GetHighestDamage()
			local var2 = WorldBossConst.GetAutoBattleCnt()
			local var3 = WorldBossConst.GetAutoBattleOilConsume()
			local var4 = WorldBossConst.GetArchivesBossAutoBattleMinute()

			arg0.autoBattleTip:ExecuteAction("Show", {
				highestDamage = var1,
				autoBattleCnt = var2,
				oil = var3,
				time = var4,
				onYes = function()
					arg0:emit(WorldBossMediator.ON_ARCHIVES_BOSS_AUTO_BATTLE, arg0.boss.id)
				end
			})
		end
	end, SFX_PANEL)
end

function var0.OnStart(arg0)
	if nowWorld():GetBossProxy():InAutoBattle() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_archives_need_stop_auto_battle"))

		return
	end

	var0.super.OnStart(arg0)
end

function var0.OnRescue(arg0)
	if arg0.helpWindow then
		arg0.helpWindow:ExecuteAction("Update", arg0.boss)
	end
end

function var0.OnUpdateRes(arg0)
	if not arg0.currProgressTxt then
		return
	end

	local var0, var1, var2 = WorldBossConst.GetAchieveBossConsume()
	local var3 = WorldBossConst.GetAchieveBossItemProgress()

	arg0.currProgressTxt.text = var3 .. "/" .. var2
end

function var0.UpdateMainInfo(arg0)
	var0.super.UpdateMainInfo(arg0)

	local var0 = arg0.boss
	local var1 = var0:GetHP()
	local var2 = var0:GetMaxHp()

	arg0.levelTxt.text = var0:GetLevel()
	arg0.hpTxt.text = var1 .. "/<color=#CF4E24>" .. var2 .. "</color>"
end

function var0.OnPaintingLoad(arg0)
	local var0 = arg0.painting:Find("fitter")

	if var0.childCount > 0 then
		local var1 = var0:GetChild(0)
		local var2 = WorldBossConst.GetAutoBattleState(arg0.boss) == WorldBossConst.AUTO_BATTLE_STATE_STARTING
		local var3 = GetOrAddComponent(var1, typeof(Gradient))

		if var3 then
			var3.enabled = var2
		end
	end
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	arg0:Flush()
end

function var0.OnBossExpired(arg0)
	if WorldBossConst.GetAutoBattleState(arg0.boss) == WorldBossConst.AUTO_BATTLE_STATE_STARTING then
		if WorldBossConst.GetAutoBattleLeftTime() <= 0 then
			arg0:emit(WorldBossMediator.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER, arg0.boss.id)
		end

		return
	end

	arg0:emit(WorldBossMediator.ON_SELF_BOSS_OVERTIME)
end

function var0.Flush(arg0)
	arg0.archivesWorldbossBtn:Flush()

	local var0 = WorldBossConst.GetAutoBattleState(arg0.boss)
	local var1 = arg0.autoBattleBtn:GetComponent(typeof(Image))

	arg0:RemoveBattleTimer()
	setActive(arg0.battleMask, false)

	arg0.autoBattleTimeTxt.text = ""

	local var2

	if var0 == WorldBossConst.AUTO_BATTLE_STATE_LOCK then
		var2 = "auto_03"
	elseif var0 == WorldBossConst.AUTO_BATTLE_STATE_STARTING then
		var2 = "auto_02"

		arg0:AddBattleTimer()
		setActive(arg0.battleMask, true)
	else
		var2 = "auto_01"
	end

	GetSpriteFromAtlasAsync("ui/WorldBossUI_atlas", var2, function(arg0)
		var1.sprite = arg0
	end)
	setActive(arg0.autoBattleBtn, var0 ~= WorldBossConst.AUTO_BATTLE_STATE_HIDE)
	setGray(arg0.startBtn, WorldBossConst.AUTO_BATTLE_STATE_STARTING == var0, true)
end

function var0.AddBattleTimer(arg0)
	if arg0.boss:IsExpired() then
		return
	end

	if WorldBossConst.GetAutoBattleLeftTime() <= 0 then
		arg0:emit(WorldBossMediator.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER, arg0.boss.id)

		return
	end

	arg0.timer = Timer.New(function()
		local var0 = WorldBossConst.GetAutoBattleLeftTime()

		if var0 < 0 then
			arg0:RemoveBattleTimer()

			arg0.autoBattleTimeTxt.text = ""
		end

		if var0 < 0 and arg0.boss then
			arg0:emit(WorldBossMediator.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER, arg0.boss.id)
		else
			arg0.autoBattleTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		end
	end, 1, -1)

	arg0.timer.func()
	arg0.timer:Start()
end

function var0.RemoveBattleTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:RemoveBattleTimer()
end

function var0.OnDestroy(arg0)
	local var0 = arg0.painting:Find("fitter"):GetChild(0)

	if var0 and var0:GetComponent(typeof(Gradient)) then
		var0:GetComponent(typeof(Gradient)).enabled = false
	end

	var0.super.OnDestroy(arg0)

	if arg0.helpWindow then
		arg0.helpWindow:Destroy()

		arg0.helpWindow = nil
	end

	if arg0.autoBattleTip then
		arg0.autoBattleTip:Destroy()

		arg0.autoBattleTip = nil
	end

	if arg0.autoBattleMsg then
		arg0.autoBattleMsg:Destroy()

		arg0.autoBattleMsg = nil
	end

	if arg0.archivesWorldbossBtn then
		arg0.archivesWorldbossBtn:Dispose()

		arg0.archivesWorldbossBtn = nil
	end

	if arg0.autoBattleResultMsg then
		arg0.autoBattleResultMsg:Destroy()

		arg0.autoBattleResultMsg = nil
	end
end

return var0
