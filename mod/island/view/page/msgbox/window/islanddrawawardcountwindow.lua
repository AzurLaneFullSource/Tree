local var0_0 = class("IslandDrawAwardCountWindow", import("Mod.Island.View.page.msgbox.window.IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandDrawAwardCountMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	setText(arg0_3.rtTitle, i18n("island_draw_choice_title"))
	onButton(arg0_3, arg0_3.btnClose, function()
		arg0_3:Hide()
	end, SFX_CANCEL)

	arg0_3.toggleList = UIItemList.New(arg0_3.rtToggles, arg0_3.rtToggleTpl)

	arg0_3.toggleList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			local var0_5, var1_5 = unpack(arg0_3.countAwardList[arg1_5])
			local var2_5 = pg.island_draw_reward[var0_5]
			local var3_5 = Drop.New({
				type = var2_5.drop_type,
				id = var2_5.drop_id
			})

			IslandShopDrawAwardPage.ShowDropInfo(var3_5, arg2_5:Find("mask/Image"))
			setText(arg2_5:Find("name/Text"), var3_5:getName())
			setText(arg2_5:Find("got/got/Text"), i18n("island_draw_get"))
			onToggle(arg0_3, arg2_5, function(arg0_6)
				if arg0_6 then
					arg0_3.selectedTarget = var0_5
				elseif arg0_3.selectedTarget == var0_5 then
					arg0_3.selectedTarget = nil
				end
			end, SFX_UI_CLICK)
			triggerToggle(arg2_5, false)
			setToggleEnabled(arg2_5, var1_5)
			setActive(arg2_5:Find("got"), not var1_5)
		end
	end)
	setText(arg0_3.btnConfirm:Find("Text"), i18n("word_take"))
	onButton(arg0_3, arg0_3.btnConfirm, function()
		if not arg0_3.selectedTarget or not arg0_3.activity:CanCountAward(arg0_3.selectedTarget) then
			return
		end

		arg0_3:emit(IslandMediator.DRAW_AWARD_OPERATION, {
			op = "count_award",
			activity_id = arg0_3.activity.id,
			target_id = arg0_3.selectedTarget
		})
		arg0_3:Hide()
	end, SFX_CONFIRM)
end

function var0_0.OnShow(arg0_8)
	var0_0.super.OnShow(arg0_8)
	arg0_8:UpdateActivity(arg0_8.settings.activity)
end

function var0_0.UpdateActivity(arg0_9, arg1_9)
	arg0_9.activity = arg1_9
	arg0_9.countAwardList = arg1_9:GetCountAwards()

	arg0_9.toggleList:align(#arg0_9.countAwardList)

	local var0_9 = arg0_9.activity:GetDrawCount()
	local var1_9 = arg0_9.activity:GetNextCountAwardTimes() or 0

	setText(arg0_9.rtCountWord, i18n("island_draw_choice") .. string.format("%d/%d", var0_9, var1_9))
	setGray(arg0_9.btnConfirm, not arg0_9.activity:CanCountAward(arg0_9.selectedTarget))
end

return var0_0
