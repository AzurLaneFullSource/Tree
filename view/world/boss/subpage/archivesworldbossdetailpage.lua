local var0_0 = class("ArchivesWorldBossDetailPage", import(".BaseWorldBossDetailPage"))

function var0_0.getUIName(arg0_1)
	return "ArchivesWorldBossDetailUI"
end

function var0_0.OnAutoBattleResult(arg0_2, arg1_2)
	local var0_2 = arg1_2.cnt
	local var1_2 = arg1_2.damage
	local var2_2 = arg1_2.oil

	arg0_2.autoBattleResultMsg:ExecuteAction("Show", {
		battleCnt = var0_2,
		damage = var1_2,
		oil = var2_2
	})
	arg0_2:Flush()
	arg0_2:UpdatePainting(arg0_2.groupId)
end

function var0_0.OnAutoBattleStart(arg0_3)
	arg0_3:Flush()
	arg0_3:UpdatePainting(arg0_3.groupId)
end

function var0_0.GetResSuffix(arg0_4)
	return "_archives"
end

function var0_0.OnLoaded(arg0_5)
	var0_0.super.OnLoaded(arg0_5)

	arg0_5.currProgressTr = arg0_5:findTF("progress")
	arg0_5.currProgressTxt = arg0_5:findTF("progress/value"):GetComponent(typeof(Text))
	arg0_5.listBtn = arg0_5:findTF("list_btn")
	arg0_5.archivesWorldbossBtn = ArchivesWorldbossBtn.New(arg0_5:findTF("archives_btn"), arg0_5.event)
	arg0_5.autoBattleBtn = arg0_5:findTF("btns/auto_btn")
	arg0_5.autoBattleTimeTxt = arg0_5.autoBattleBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_5.battleMask = arg0_5:findTF("battle_mask")
	arg0_5.helpWindow = ArchivesWorldBossHelpPage.New(arg0_5._parentTf.parent, arg0_5.event)
	arg0_5.autoBattleTip = ArchivesWorldBossAutoBattleTipPage.New(arg0_5._parentTf.parent, arg0_5.event)
	arg0_5.autoBattleMsg = ArchivesWorldBossAutoBattleMsgbox.New(arg0_5._parentTf.parent, arg0_5.event)
	arg0_5.autoBattleResultMsg = ArchivesWorldBossAutoBattleResultMsg.New(arg0_5._parentTf.parent, arg0_5.event)
end

function var0_0.OnInit(arg0_6)
	var0_0.super.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.listBtn, function()
		arg0_6:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.currProgressTr, function()
		local var0_8 = WorldBossConst.GetAchieveBossItemInfo()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0_8.name,
			content = var0_8.display,
			iconPath = var0_8.icon,
			frame = var0_8.rarity
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6:findTF("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_archives_boss_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.battleMask, function()
		triggerButton(arg0_6.autoBattleBtn)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.autoBattleBtn, function()
		if pg.TimeMgr.GetInstance():GetServerTime() + WorldBossConst.GetArchivesBossAutoBattleSecond() > arg0_6.boss:GetExpiredTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_no_time_to_auto_battle"))

			return
		end

		local var0_11 = WorldBossConst.GetAutoBattleState(arg0_6.boss)

		if var0_11 == WorldBossConst.AUTO_BATTLE_STATE_STARTING then
			arg0_6.autoBattleMsg:ExecuteAction("Show", {
				onContent = function()
					local var0_12 = WorldBossConst.GetAutoBattleLeftTime()

					if var0_12 <= 0 then
						return nil
					end

					return (pg.TimeMgr.GetInstance():DescCDTime(var0_12))
				end,
				title = i18n("world_boss_archives_stop_auto_battle_title"),
				yesText = i18n("world_boss_archives_continue_auto_battle"),
				noText = i18n("world_boss_archives_stop_auto_battle"),
				onNo = function()
					arg0_6:emit(WorldBossMediator.ON_ARCHIVES_BOSS_STOP_AUTO_BATTLE, arg0_6.boss.id)
				end
			})
		elseif var0_11 == WorldBossConst.AUTO_BATTLE_STATE_HIDE then
			pg.TipsMgr.GetInstance():ShowTip(i18n("world_word_expired"))
		elseif var0_11 == WorldBossConst.AUTO_BATTLE_STATE_LOCK then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_archives_auto_battle_unopen"))
		else
			local var1_11 = WorldBossConst.GetHighestDamage()
			local var2_11 = WorldBossConst.GetAutoBattleCnt()
			local var3_11 = WorldBossConst.GetAutoBattleOilConsume()
			local var4_11 = WorldBossConst.GetArchivesBossAutoBattleMinute()

			arg0_6.autoBattleTip:ExecuteAction("Show", {
				highestDamage = var1_11,
				autoBattleCnt = var2_11,
				oil = var3_11,
				time = var4_11,
				onYes = function()
					arg0_6:emit(WorldBossMediator.ON_ARCHIVES_BOSS_AUTO_BATTLE, arg0_6.boss.id)
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.OnStart(arg0_15)
	if nowWorld():GetBossProxy():InAutoBattle() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_archives_need_stop_auto_battle"))

		return
	end

	var0_0.super.OnStart(arg0_15)
end

function var0_0.OnRescue(arg0_16)
	if arg0_16.helpWindow then
		arg0_16.helpWindow:ExecuteAction("Update", arg0_16.boss)
	end
end

function var0_0.OnUpdateRes(arg0_17)
	if not arg0_17.currProgressTxt then
		return
	end

	local var0_17, var1_17, var2_17 = WorldBossConst.GetAchieveBossConsume()
	local var3_17 = WorldBossConst.GetAchieveBossItemProgress()

	arg0_17.currProgressTxt.text = var3_17 .. "/" .. var2_17
end

function var0_0.UpdateMainInfo(arg0_18)
	var0_0.super.UpdateMainInfo(arg0_18)

	local var0_18 = arg0_18.boss
	local var1_18 = var0_18:GetHP()
	local var2_18 = var0_18:GetMaxHp()

	arg0_18.levelTxt.text = var0_18:GetLevel()
	arg0_18.hpTxt.text = var1_18 .. "/<color=#CF4E24>" .. var2_18 .. "</color>"
end

function var0_0.OnPaintingLoad(arg0_19)
	local var0_19 = arg0_19.painting:Find("fitter")

	if var0_19.childCount > 0 then
		local var1_19 = var0_19:GetChild(0)
		local var2_19 = WorldBossConst.GetAutoBattleState(arg0_19.boss) == WorldBossConst.AUTO_BATTLE_STATE_STARTING
		local var3_19 = GetOrAddComponent(var1_19, typeof(Gradient))

		if var3_19 then
			var3_19.enabled = var2_19
		end
	end
end

function var0_0.Show(arg0_20)
	var0_0.super.Show(arg0_20)
	arg0_20:Flush()
end

function var0_0.OnBossExpired(arg0_21)
	if WorldBossConst.GetAutoBattleState(arg0_21.boss) == WorldBossConst.AUTO_BATTLE_STATE_STARTING then
		if WorldBossConst.GetAutoBattleLeftTime() <= 0 then
			arg0_21:emit(WorldBossMediator.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER, arg0_21.boss.id)
		end

		return
	end

	arg0_21:emit(WorldBossMediator.ON_SELF_BOSS_OVERTIME)
end

function var0_0.Flush(arg0_22)
	arg0_22.archivesWorldbossBtn:Flush()

	local var0_22 = WorldBossConst.GetAutoBattleState(arg0_22.boss)
	local var1_22 = arg0_22.autoBattleBtn:GetComponent(typeof(Image))

	arg0_22:RemoveBattleTimer()
	setActive(arg0_22.battleMask, false)

	arg0_22.autoBattleTimeTxt.text = ""

	local var2_22

	if var0_22 == WorldBossConst.AUTO_BATTLE_STATE_LOCK then
		var2_22 = "auto_03"
	elseif var0_22 == WorldBossConst.AUTO_BATTLE_STATE_STARTING then
		var2_22 = "auto_02"

		arg0_22:AddBattleTimer()
		setActive(arg0_22.battleMask, true)
	else
		var2_22 = "auto_01"
	end

	GetSpriteFromAtlasAsync("ui/WorldBossUI_atlas", var2_22, function(arg0_23)
		var1_22.sprite = arg0_23
	end)
	setActive(arg0_22.autoBattleBtn, var0_22 ~= WorldBossConst.AUTO_BATTLE_STATE_HIDE)
	setGray(arg0_22.startBtn, WorldBossConst.AUTO_BATTLE_STATE_STARTING == var0_22, true)
end

function var0_0.AddBattleTimer(arg0_24)
	if arg0_24.boss:IsExpired() then
		return
	end

	if WorldBossConst.GetAutoBattleLeftTime() <= 0 then
		arg0_24:emit(WorldBossMediator.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER, arg0_24.boss.id)

		return
	end

	arg0_24.timer = Timer.New(function()
		local var0_25 = WorldBossConst.GetAutoBattleLeftTime()

		if var0_25 < 0 then
			arg0_24:RemoveBattleTimer()

			arg0_24.autoBattleTimeTxt.text = ""
		end

		if var0_25 < 0 and arg0_24.boss then
			arg0_24:emit(WorldBossMediator.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER, arg0_24.boss.id)
		else
			arg0_24.autoBattleTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0_25)
		end
	end, 1, -1)

	arg0_24.timer.func()
	arg0_24.timer:Start()
end

function var0_0.RemoveBattleTimer(arg0_26)
	if arg0_26.timer then
		arg0_26.timer:Stop()

		arg0_26.timer = nil
	end
end

function var0_0.Hide(arg0_27)
	var0_0.super.Hide(arg0_27)
	arg0_27:RemoveBattleTimer()
end

function var0_0.OnDestroy(arg0_28)
	local var0_28 = arg0_28.painting:Find("fitter"):GetChild(0)

	if var0_28 and var0_28:GetComponent(typeof(Gradient)) then
		var0_28:GetComponent(typeof(Gradient)).enabled = false
	end

	var0_0.super.OnDestroy(arg0_28)

	if arg0_28.helpWindow then
		arg0_28.helpWindow:Destroy()

		arg0_28.helpWindow = nil
	end

	if arg0_28.autoBattleTip then
		arg0_28.autoBattleTip:Destroy()

		arg0_28.autoBattleTip = nil
	end

	if arg0_28.autoBattleMsg then
		arg0_28.autoBattleMsg:Destroy()

		arg0_28.autoBattleMsg = nil
	end

	if arg0_28.archivesWorldbossBtn then
		arg0_28.archivesWorldbossBtn:Dispose()

		arg0_28.archivesWorldbossBtn = nil
	end

	if arg0_28.autoBattleResultMsg then
		arg0_28.autoBattleResultMsg:Destroy()

		arg0_28.autoBattleResultMsg = nil
	end
end

return var0_0
