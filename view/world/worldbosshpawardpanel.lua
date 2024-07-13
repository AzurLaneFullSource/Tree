local var0_0 = class("WorldBossHPAwardPanel", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.buffer = FuncBuffer.New()
end

function var0_0.getUIName(arg0_2)
	return "WorldBossHPAwardWindow"
end

function var0_0.OnInit(arg0_3)
	setText(arg0_3:findTF("window/top/bg/infomation"), i18n("world_expedition_reward_display"))

	arg0_3.itemList = arg0_3:findTF("window/panel/viewport/list")

	onButton(arg0_3, arg0_3:findTF("window/top/btnBack"), function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("bg_dark"), function()
		arg0_3:Hide()
	end)
	arg0_3.buffer:SetNotifier(arg0_3)
	arg0_3.buffer:ExcuteAll()
end

function var0_0.Show(arg0_6)
	var0_0.super.Show(arg0_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.Hide(arg0_7)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf)
	var0_0.super.Hide(arg0_7)
end

function var0_0.UpdateView(arg0_8, arg1_8)
	arg0_8:Show()

	local var0_8 = arg1_8:GetHP()

	if arg1_8:IsPeriodEnemy() then
		var0_8 = math.min(var0_8, nowWorld():GetHistoryLowestHP(arg1_8.id))
	end

	local var1_8 = arg1_8:GetBattleStageId()
	local var2_8 = pg.world_expedition_data[var1_8]
	local var3_8 = var2_8 and var2_8.phase_drop_display

	UIItemList.StaticAlign(arg0_8.itemList, arg0_8.itemList:GetChild(0), var3_8 and #var3_8 or 0, function(arg0_9, arg1_9, arg2_9)
		if arg0_9 ~= UIItemList.EventUpdate then
			return
		end

		local var0_9 = var3_8[arg1_9 + 1]
		local var1_9 = var0_8 <= var0_9[1]

		setText(arg2_9:Find("target"), i18n("world_expedition_reward_display2", math.ceil(var0_9[1] / 100)))
		setActive(arg2_9:Find("mask"), var1_9)
		UIItemList.StaticAlign(arg2_9:Find("awards"), arg2_9:Find("awards"):GetChild(0), #var0_9[2], function(arg0_10, arg1_10, arg2_10)
			if arg0_10 ~= UIItemList.EventUpdate then
				return
			end

			local var0_10 = var0_9[2][arg1_10 + 1]
			local var1_10 = {
				type = var0_10[1],
				id = var0_10[2],
				count = var0_10[3]
			}

			updateDrop(arg2_10:Find("IconTpl"), var1_10)
			onButton(arg0_8, arg2_10:Find("IconTpl"), function()
				arg0_8:emit(BaseUI.ON_DROP, var1_10)
			end)
		end)
	end)
end

return var0_0
