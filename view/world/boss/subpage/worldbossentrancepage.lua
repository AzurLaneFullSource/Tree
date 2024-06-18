local var0_0 = class("WorldBossEntrancePage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldBossEntranceUI"
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.proxy = arg1_2
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.currentTr = arg0_3:findTF("current")
	arg0_3.pastTr = arg0_3:findTF("past")
	arg0_3.currTimeTxt = arg0_3.currentTr:Find("time"):GetComponent(typeof(Text))
	arg0_3.currConsumeTxt = arg0_3.currentTr:Find("consume"):GetComponent(typeof(Text))
	arg0_3.currAccTxt = arg0_3.currentTr:Find("acc"):GetComponent(typeof(Text))
	arg0_3.pastConsumeTxt = arg0_3.pastTr:Find("consume"):GetComponent(typeof(Text))
	arg0_3.pastAccTxt = arg0_3.pastTr:Find("acc"):GetComponent(typeof(Text))
	arg0_3.currProgressTr = arg0_3:findTF("current_progress")
	arg0_3.pastProgressTr = arg0_3:findTF("past_progress")
	arg0_3.currProgressTxt = arg0_3:findTF("current_progress/value"):GetComponent(typeof(Text))
	arg0_3.pastProgressTxt = arg0_3:findTF("past_progress/value"):GetComponent(typeof(Text))
	arg0_3.backBtn = arg0_3:findTF("blur_panel/adapt/top/back")

	local var0_3 = WorldBossConst.GetCurrBossGroup()
	local var1_3 = arg0_3:findTF("current"):GetComponent(typeof(Image))

	var1_3.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var0_3, "cur")

	var1_3:SetNativeSize()
	setText(arg0_3:findTF("tip/Text"), i18n("world_boss_item_usage_tip"))
	setText(arg0_3.currentTr:Find("label"), i18n("world_boss_current_boss_label"))
	setText(arg0_3.currentTr:Find("label1"), i18n("world_boss_current_boss_label1"))
	setText(arg0_3.pastTr:Find("label"), i18n("world_boss_current_boss_label"))
	setText(arg0_3.pastTr:Find("label1"), i18n("world_boss_current_boss_label1"))

	arg0_3.pastLabels = {
		arg0_3.pastTr:Find("label"),
		arg0_3.pastTr:Find("label1"),
		arg0_3.pastTr:Find("label2"),
		arg0_3.pastTr:Find("label3")
	}
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.currentTr, function()
		arg0_4:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CURRENT)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.pastTr, function()
		arg0_4:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.currProgressTr, function()
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
	onButton(arg0_4, arg0_4.pastProgressTr, function()
		local var0_9 = WorldBossConst.GetAchieveBossItemInfo()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0_9.name,
			content = var0_9.display,
			iconPath = var0_9.icon,
			frame = var0_9.rarity
		})
	end, SFX_PANEL)
end

function var0_0.Update(arg0_10)
	arg0_10:UpdateCurrent()
	arg0_10:UpdatePast()
	arg0_10:Show()
end

function var0_0.UpdateCurrent(arg0_11)
	arg0_11:ClearTimer()

	local var0_11

	local function var1_11()
		local var0_12, var1_12 = WorldBossConst.GetCurrBossLeftDay()

		arg0_11.currTimeTxt.text = i18n("world_boss_lefttime", var0_12)

		if var1_12 > 0 then
			arg0_11.timer = Timer.New(function()
				var1_11()
			end, var1_12, 1)

			arg0_11.timer:Start()
		end
	end

	var1_11()

	local var2_11, var3_11, var4_11 = WorldBossConst.GetCurrBossConsume()
	local var5_11 = WorldBossConst.GetCurrBossItemProgress()

	arg0_11.currConsumeTxt.text = var2_11

	local var6_11 = WorldBossConst.GetCurrBossItemAcc()

	arg0_11.currAccTxt.text = "<color=#ffdf5d>" .. var6_11 .. "</color>/" .. var3_11
	arg0_11.currProgressTxt.text = var5_11 .. "/" .. var4_11
end

function var0_0.UpdatePast(arg0_14)
	local var0_14, var1_14, var2_14 = WorldBossConst.GetAchieveBossConsume()
	local var3_14 = WorldBossConst.GetAchieveBossItemProgress()

	arg0_14.pastProgressTxt.text = var3_14 .. "/" .. var2_14

	local var4_14 = WorldBossConst.GetSummonPtOldAcc()
	local var5_14 = WorldBossConst.GetAchieveState()
	local var6_14 = arg0_14.pastTr:GetComponent(typeof(Image))
	local var7_14
	local var8_14 = ""

	if WorldBossConst.ACHIEVE_STATE_STARTING == var5_14 then
		arg0_14.pastAccTxt.text = "<color=#ffdf5d>" .. var4_14 .. "</color>/" .. var1_14
		arg0_14.pastConsumeTxt.text = var0_14

		local var9_14 = "/" .. WorldBossConst.BossId2MetaId(WorldBossConst.GetArchivesId())

		var7_14 = "useitem_archives"
		var6_14.sprite = GetSpriteFromAtlas("MetaWorldboss" .. var9_14, var7_14)

		var6_14:SetNativeSize()
	else
		arg0_14.pastAccTxt.text = ""
		arg0_14.pastConsumeTxt.text = ""

		if WorldBossConst.ACHIEVE_STATE_NOSTART == var5_14 then
			var7_14 = "extra_unselect"
		elseif WorldBossConst.ACHIEVE_STATE_CLEAR == var5_14 then
			var7_14 = "extra_clear"
		end

		var6_14.sprite = LoadSprite("MetaWorldboss/" .. var7_14)

		var6_14:SetNativeSize()
	end

	for iter0_14, iter1_14 in ipairs(arg0_14.pastLabels) do
		setActive(iter1_14, WorldBossConst.ACHIEVE_STATE_STARTING == var5_14)
	end
end

function var0_0.ClearTimer(arg0_15)
	if arg0_15.timer then
		arg0_15.timer:Stop()

		arg0_15.timer = nil
	end
end

function var0_0.OnDestroy(arg0_16)
	arg0_16:ClearTimer()
end

return var0_0
