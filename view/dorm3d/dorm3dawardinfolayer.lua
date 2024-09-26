local var0_0 = class("Dorm3dAwardInfoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dAwardInfoUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		if arg0_2.inAnimPlaying or arg0_2.isCloseAnim then
			return
		end

		arg0_2.isCloseAnim = true

		arg0_2._tf:GetComponent(typeof(Animation)):Play("anim_educate_awardinfo_award_out")
	end, SFX_CANCEL)
	arg0_2._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_2:closeView()
	end)

	arg0_2.tipTF = arg0_2._tf:Find("panel/tip")

	setText(arg0_2.tipTF, i18n("child_close_tip"))

	arg0_2.itemContainer = arg0_2._tf:Find("panel/content")

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.didEnter(arg0_5)
	UIItemList.StaticAlign(arg0_5.itemContainer, arg0_5.itemContainer:Find("tpl"), #arg0_5.contextData.items, function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg0_5.contextData.items[arg1_6]

			updateDorm3dIcon(arg2_6, var0_6)
			onButton(arg0_5, arg2_6, function()
				arg0_5:emit(BaseUI.ON_NEW_DROP, {
					drop = var0_6
				})
			end, SFX_PANEL)
		end
	end)

	arg0_5.inAnimPlaying = true

	local var0_5 = {}

	table.insert(var0_5, function(arg0_8)
		arg0_5:managedTween(LeanTween.delayedCall, arg0_8, 0.33, nil)
	end)
	eachChild(arg0_5.itemContainer, function(arg0_9)
		if isActive(arg0_9) then
			setActive(arg0_9, false)
			table.insert(var0_5, function(arg0_10)
				setActive(arg0_9, true)
				arg0_5:managedTween(LeanTween.delayedCall, arg0_10, 0.066, nil)
			end)
		end
	end)
	seriesAsync(var0_5, function()
		arg0_5:managedTween(LeanTween.delayedCall, function()
			arg0_5.inAnimPlaying = false
		end, 0.066, nil)
	end)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_reward")
end

function var0_0.onBackPressed(arg0_13)
	triggerButton(arg0_13._tf:Find("bg"))
end

function var0_0.willExit(arg0_14)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf)
end

return var0_0
