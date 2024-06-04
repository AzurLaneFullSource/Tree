local var0 = class("Dorm3dAwardInfoLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dAwardInfoUI"
end

function var0.init(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		if arg0.inAnimPlaying or arg0.isCloseAnim then
			return
		end

		arg0.isCloseAnim = true

		arg0._tf:GetComponent(typeof(Animation)):Play("anim_educate_awardinfo_award_out")
	end, SFX_CANCEL)
	arg0._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:closeView()
	end)

	arg0.tipTF = arg0._tf:Find("panel/tip")

	setText(arg0.tipTF, i18n("child_close_tip"))

	arg0.itemContainer = arg0._tf:Find("panel/content")

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0.didEnter(arg0)
	UIItemList.StaticAlign(arg0.itemContainer, arg0.itemContainer:Find("tpl"), #arg0.contextData.items, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.contextData.items[arg1]

			updateDorm3dIcon(arg2, var0)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var0)
			end, SFX_PANEL)
		end
	end)

	arg0.inAnimPlaying = true

	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:managedTween(LeanTween.delayedCall, arg0, 0.33, nil)
	end)
	eachChild(arg0.itemContainer, function(arg0)
		if isActive(arg0) then
			setActive(arg0, false)
			table.insert(var0, function(arg0)
				setActive(arg0, true)
				arg0:managedTween(LeanTween.delayedCall, arg0, 0.066, nil)
			end)
		end
	end)
	seriesAsync(var0, function()
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0.inAnimPlaying = false
		end, 0.066, nil)
	end)
end

function var0.onBackPressed(arg0)
	triggerButton(arg0._tf:Find("bg"))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
