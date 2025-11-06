local var0_0 = class("CurrentWorldBossEmptyPage", import(".BaseWorldBossEmptyPage"))

function var0_0.getUIName(arg0_1)
	return "CurrentWorldBossEmptyUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.timeTxt = arg0_2._tf:Find("time/Text"):GetComponent(typeof(Text))

	local var0_2 = WorldBossConst.GetCurrBossGroup() or ""

	arg0_2:UpdateUseItemStyle(var0_2)

	arg0_2.simulateBtn = arg0_2._tf:Find("simulate_btn")
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help_meta.tip
		})
	end, SFX_PANEL)
	setActive(arg0_3.simulateBtn, true)
	onButton(arg0_3, arg0_3.simulateBtn, function()
		arg0_3:emit(WorldBossMediator.ON_UPDATE_BOSS_INFO, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("meta_simulated_btn", nowWorld():GetBossProxy().currentBossLV),
				onYes = function()
					arg0_3:emit(WorldBossMediator.ON_BATTLE, WorldBossConst.GetCurrBossID(), nil, 1, true)
				end
			})
		end)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.progressTr, function()
		local var0_8 = WorldBossConst.GetCurrBossItemInfo()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0_8.name,
			content = var0_8.display,
			iconPath = var0_8.icon,
			frame = var0_8.rarity
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("list_btn"), function()
		arg0_3:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.activeBtn, function()
		if WorldBossConst.CanUnlockCurrBoss() then
			local var0_10 = WorldBossConst.GetCurrBossID()

			arg0_3:emit(WorldBossMediator.ON_ACTIVE_BOSS, var0_10)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_item_count_noenough"))
		end
	end, SFX_PANEL)
end

function var0_0.OnUpdate(arg0_11)
	local var0_11 = WorldBossConst.GetCurrBossStartTimeAndEndTime()
	local var1_11 = pg.TimeMgr.GetInstance():inTime(var0_11)
	local var2_11 = var1_11 and WorldBossConst.CanUnlockCurrBoss()

	setActive(arg0_11.useItem, var2_11)
	setActive(arg0_11.noItem, not var2_11)

	if var1_11 then
		arg0_11.timeTxt.text = pg.TimeMgr.GetInstance():DescDateFromConfig(var0_11[1]) .. "~" .. pg.TimeMgr.GetInstance():DescDateFromConfig(var0_11[2])
	else
		arg0_11.timeTxt.text = ""
	end

	arg0_11.metaWorldbossBtn = arg0_11.metaWorldbossBtn or MetaWorldbossBtn.New(arg0_11._tf:Find("archives_btn"), arg0_11.event)
	arg0_11.ptBtn = arg0_11.ptBtn or WorldbossPtBtn.New(arg0_11._tf:Find("point"))
end

function var0_0.OnUpdateRes(arg0_12)
	if not arg0_12.progressTxt then
		return
	end

	local var0_12, var1_12, var2_12 = WorldBossConst.GetCurrBossConsume()
	local var3_12 = WorldBossConst.GetCurrBossItemProgress()

	arg0_12.progressTxt.text = var3_12 .. "/" .. var2_12
end

function var0_0.OnUpdatePt(arg0_13, arg1_13)
	if arg0_13.ptBtn then
		arg0_13.ptBtn:Update()
	end
end

function var0_0.OnDestroy(arg0_14)
	var0_0.super.OnDestroy(arg0_14)

	if arg0_14.metaWorldbossBtn then
		arg0_14.metaWorldbossBtn:Dispose()

		arg0_14.metaWorldbossBtn = nil
	end

	if arg0_14.ptBtn then
		arg0_14.ptBtn:Dispose()

		arg0_14.ptBtn = nil
	end
end

return var0_0
