local var0 = class("CurrentWorldBossEmptyPage", import(".BaseWorldBossEmptyPage"))

function var0.getUIName(arg0)
	return "CurrentWorldBossEmptyUI"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.timeTxt = arg0:findTF("time/Text"):GetComponent(typeof(Text))

	local var0 = WorldBossConst.GetCurrBossGroup() or ""

	arg0:UpdateUseItemStyle(var0)
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help_meta.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.progressTr, function()
		local var0 = WorldBossConst.GetCurrBossItemInfo()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0.name,
			content = var0.display,
			iconPath = var0.icon,
			frame = var0.rarity
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("list_btn"), function()
		arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CHALLENGE)
	end, SFX_PANEL)
	onButton(arg0, arg0.activeBtn, function()
		if WorldBossConst.CanUnlockCurrBoss() then
			local var0 = WorldBossConst.GetCurrBossID()

			arg0:emit(WorldBossMediator.ON_ACTIVE_BOSS, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_item_count_noenough"))
		end
	end, SFX_PANEL)
end

function var0.OnUpdate(arg0)
	local var0 = WorldBossConst.GetCurrBossStartTimeAndEndTime()
	local var1 = pg.TimeMgr.GetInstance():inTime(var0)
	local var2 = var1 and WorldBossConst.CanUnlockCurrBoss()

	setActive(arg0.useItem, var2)
	setActive(arg0.noItem, not var2)

	if var1 then
		arg0.timeTxt.text = pg.TimeMgr.GetInstance():DescDateFromConfig(var0[1]) .. "~" .. pg.TimeMgr.GetInstance():DescDateFromConfig(var0[2])
	else
		arg0.timeTxt.text = ""
	end

	arg0.metaWorldbossBtn = arg0.metaWorldbossBtn or MetaWorldbossBtn.New(arg0:findTF("archives_btn"), arg0.event)
	arg0.ptBtn = arg0.ptBtn or WorldbossPtBtn.New(arg0:findTF("point"))
end

function var0.OnUpdateRes(arg0)
	if not arg0.progressTxt then
		return
	end

	local var0, var1, var2 = WorldBossConst.GetCurrBossConsume()
	local var3 = WorldBossConst.GetCurrBossItemProgress()

	arg0.progressTxt.text = var3 .. "/" .. var2
end

function var0.OnUpdatePt(arg0, arg1)
	if arg0.ptBtn then
		arg0.ptBtn:Update()
	end
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.metaWorldbossBtn then
		arg0.metaWorldbossBtn:Dispose()

		arg0.metaWorldbossBtn = nil
	end

	if arg0.ptBtn then
		arg0.ptBtn:Dispose()

		arg0.ptBtn = nil
	end
end

return var0
