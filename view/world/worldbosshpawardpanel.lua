local var0 = class("WorldBossHPAwardPanel", import("view.base.BaseSubView"))

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.buffer = FuncBuffer.New()
end

function var0.getUIName(arg0)
	return "WorldBossHPAwardWindow"
end

function var0.OnInit(arg0)
	setText(arg0:findTF("window/top/bg/infomation"), i18n("world_expedition_reward_display"))

	arg0.itemList = arg0:findTF("window/panel/viewport/list")

	onButton(arg0, arg0:findTF("window/top/btnBack"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("bg_dark"), function()
		arg0:Hide()
	end)
	arg0.buffer:SetNotifier(arg0)
	arg0.buffer:ExcuteAll()
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	var0.super.Hide(arg0)
end

function var0.UpdateView(arg0, arg1)
	arg0:Show()

	local var0 = arg1:GetHP()

	if arg1:IsPeriodEnemy() then
		var0 = math.min(var0, nowWorld():GetHistoryLowestHP(arg1.id))
	end

	local var1 = arg1:GetBattleStageId()
	local var2 = pg.world_expedition_data[var1]
	local var3 = var2 and var2.phase_drop_display

	UIItemList.StaticAlign(arg0.itemList, arg0.itemList:GetChild(0), var3 and #var3 or 0, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var3[arg1 + 1]
		local var1 = var0 <= var0[1]

		setText(arg2:Find("target"), i18n("world_expedition_reward_display2", math.ceil(var0[1] / 100)))
		setActive(arg2:Find("mask"), var1)
		UIItemList.StaticAlign(arg2:Find("awards"), arg2:Find("awards"):GetChild(0), #var0[2], function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var0[2][arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2:Find("IconTpl"), var1)
			onButton(arg0, arg2:Find("IconTpl"), function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end)
		end)
	end)
end

return var0
