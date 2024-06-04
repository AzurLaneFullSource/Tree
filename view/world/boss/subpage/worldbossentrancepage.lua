local var0 = class("WorldBossEntrancePage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "WorldBossEntranceUI"
end

function var0.Setup(arg0, arg1)
	arg0.proxy = arg1
end

function var0.OnLoaded(arg0)
	arg0.currentTr = arg0:findTF("current")
	arg0.pastTr = arg0:findTF("past")
	arg0.currTimeTxt = arg0.currentTr:Find("time"):GetComponent(typeof(Text))
	arg0.currConsumeTxt = arg0.currentTr:Find("consume"):GetComponent(typeof(Text))
	arg0.currAccTxt = arg0.currentTr:Find("acc"):GetComponent(typeof(Text))
	arg0.pastConsumeTxt = arg0.pastTr:Find("consume"):GetComponent(typeof(Text))
	arg0.pastAccTxt = arg0.pastTr:Find("acc"):GetComponent(typeof(Text))
	arg0.currProgressTr = arg0:findTF("current_progress")
	arg0.pastProgressTr = arg0:findTF("past_progress")
	arg0.currProgressTxt = arg0:findTF("current_progress/value"):GetComponent(typeof(Text))
	arg0.pastProgressTxt = arg0:findTF("past_progress/value"):GetComponent(typeof(Text))
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back")

	local var0 = WorldBossConst.GetCurrBossGroup()
	local var1 = arg0:findTF("current"):GetComponent(typeof(Image))

	var1.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var0, "cur")

	var1:SetNativeSize()
	setText(arg0:findTF("tip/Text"), i18n("world_boss_item_usage_tip"))
	setText(arg0.currentTr:Find("label"), i18n("world_boss_current_boss_label"))
	setText(arg0.currentTr:Find("label1"), i18n("world_boss_current_boss_label1"))
	setText(arg0.pastTr:Find("label"), i18n("world_boss_current_boss_label"))
	setText(arg0.pastTr:Find("label1"), i18n("world_boss_current_boss_label1"))

	arg0.pastLabels = {
		arg0.pastTr:Find("label"),
		arg0.pastTr:Find("label1"),
		arg0.pastTr:Find("label2"),
		arg0.pastTr:Find("label3")
	}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.currentTr, function()
		arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_CURRENT)
	end, SFX_PANEL)
	onButton(arg0, arg0.pastTr, function()
		arg0:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES)
	end, SFX_PANEL)
	onButton(arg0, arg0.currProgressTr, function()
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
	onButton(arg0, arg0.pastProgressTr, function()
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
end

function var0.Update(arg0)
	arg0:UpdateCurrent()
	arg0:UpdatePast()
	arg0:Show()
end

function var0.UpdateCurrent(arg0)
	arg0:ClearTimer()

	local var0

	local function var1()
		local var0, var1 = WorldBossConst.GetCurrBossLeftDay()

		arg0.currTimeTxt.text = i18n("world_boss_lefttime", var0)

		if var1 > 0 then
			arg0.timer = Timer.New(function()
				var1()
			end, var1, 1)

			arg0.timer:Start()
		end
	end

	var1()

	local var2, var3, var4 = WorldBossConst.GetCurrBossConsume()
	local var5 = WorldBossConst.GetCurrBossItemProgress()

	arg0.currConsumeTxt.text = var2

	local var6 = WorldBossConst.GetCurrBossItemAcc()

	arg0.currAccTxt.text = "<color=#ffdf5d>" .. var6 .. "</color>/" .. var3
	arg0.currProgressTxt.text = var5 .. "/" .. var4
end

function var0.UpdatePast(arg0)
	local var0, var1, var2 = WorldBossConst.GetAchieveBossConsume()
	local var3 = WorldBossConst.GetAchieveBossItemProgress()

	arg0.pastProgressTxt.text = var3 .. "/" .. var2

	local var4 = WorldBossConst.GetSummonPtOldAcc()
	local var5 = WorldBossConst.GetAchieveState()
	local var6 = arg0.pastTr:GetComponent(typeof(Image))
	local var7
	local var8 = ""

	if WorldBossConst.ACHIEVE_STATE_STARTING == var5 then
		arg0.pastAccTxt.text = "<color=#ffdf5d>" .. var4 .. "</color>/" .. var1
		arg0.pastConsumeTxt.text = var0

		local var9 = "/" .. WorldBossConst.BossId2MetaId(WorldBossConst.GetArchivesId())

		var7 = "useitem_archives"
		var6.sprite = GetSpriteFromAtlas("MetaWorldboss" .. var9, var7)

		var6:SetNativeSize()
	else
		arg0.pastAccTxt.text = ""
		arg0.pastConsumeTxt.text = ""

		if WorldBossConst.ACHIEVE_STATE_NOSTART == var5 then
			var7 = "extra_unselect"
		elseif WorldBossConst.ACHIEVE_STATE_CLEAR == var5 then
			var7 = "extra_clear"
		end

		var6.sprite = LoadSprite("MetaWorldboss/" .. var7)

		var6:SetNativeSize()
	end

	for iter0, iter1 in ipairs(arg0.pastLabels) do
		setActive(iter1, WorldBossConst.ACHIEVE_STATE_STARTING == var5)
	end
end

function var0.ClearTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:ClearTimer()
end

return var0
