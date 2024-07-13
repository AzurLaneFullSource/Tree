local var0_0 = class("CurrentWorldBossEmptyPage", import(".BaseWorldBossEmptyPage"))

function var0_0.getUIName(arg0_1)
	return "CurrentWorldBossEmptyUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.timeTxt = arg0_2:findTF("time/Text"):GetComponent(typeof(Text))

	local var0_2 = WorldBossConst.GetCurrBossGroup() or ""

	arg0_2:UpdateUseItemStyle(var0_2)
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help_meta.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.progressTr, function()
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
	onButton(arg0_3, arg0_3:findTF("list_btn"), function()
		arg0_3:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.activeBtn, function()
		if WorldBossConst.CanUnlockCurrBoss() then
			local var0_7 = WorldBossConst.GetCurrBossID()

			arg0_3:emit(WorldBossMediator.ON_ACTIVE_BOSS, var0_7)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_item_count_noenough"))
		end
	end, SFX_PANEL)
end

function var0_0.OnUpdate(arg0_8)
	local var0_8 = WorldBossConst.GetCurrBossStartTimeAndEndTime()
	local var1_8 = pg.TimeMgr.GetInstance():inTime(var0_8)
	local var2_8 = var1_8 and WorldBossConst.CanUnlockCurrBoss()

	setActive(arg0_8.useItem, var2_8)
	setActive(arg0_8.noItem, not var2_8)

	if var1_8 then
		arg0_8.timeTxt.text = pg.TimeMgr.GetInstance():DescDateFromConfig(var0_8[1]) .. "~" .. pg.TimeMgr.GetInstance():DescDateFromConfig(var0_8[2])
	else
		arg0_8.timeTxt.text = ""
	end

	arg0_8.metaWorldbossBtn = arg0_8.metaWorldbossBtn or MetaWorldbossBtn.New(arg0_8:findTF("archives_btn"), arg0_8.event)
	arg0_8.ptBtn = arg0_8.ptBtn or WorldbossPtBtn.New(arg0_8:findTF("point"))
end

function var0_0.OnUpdateRes(arg0_9)
	if not arg0_9.progressTxt then
		return
	end

	local var0_9, var1_9, var2_9 = WorldBossConst.GetCurrBossConsume()
	local var3_9 = WorldBossConst.GetCurrBossItemProgress()

	arg0_9.progressTxt.text = var3_9 .. "/" .. var2_9
end

function var0_0.OnUpdatePt(arg0_10, arg1_10)
	if arg0_10.ptBtn then
		arg0_10.ptBtn:Update()
	end
end

function var0_0.OnDestroy(arg0_11)
	var0_0.super.OnDestroy(arg0_11)

	if arg0_11.metaWorldbossBtn then
		arg0_11.metaWorldbossBtn:Dispose()

		arg0_11.metaWorldbossBtn = nil
	end

	if arg0_11.ptBtn then
		arg0_11.ptBtn:Dispose()

		arg0_11.ptBtn = nil
	end
end

return var0_0
