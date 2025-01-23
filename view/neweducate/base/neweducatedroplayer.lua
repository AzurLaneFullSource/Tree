local var0_0 = class("NewEducateDropLayer", import("view.newEducate.base.NewEducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateDropUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0_2.drops = arg0_2.contextData.items or {}
	arg0_2.awardWindow = arg0_2._tf:Find("award_window")
	arg0_2.anim = arg0_2.awardWindow:GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2.awardWindow:GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end)

	arg0_2.tipTF = arg0_2.awardWindow:Find("tip")

	setText(arg0_2.tipTF, i18n("child_close_tip"))

	arg0_2.itemContainer = arg0_2.awardWindow:Find("scroll/content")
	arg0_2.itemTpl = arg0_2.awardWindow:Find("tpl")

	setActive(arg0_2.itemTpl, false)

	arg0_2.favorWindow = arg0_2._tf:Find("favor_window")
	arg0_2.favorLvTF = arg0_2.favorWindow:Find("gift/heart/level")

	setActive(arg0_2.awardWindow, false)
	setActive(arg0_2.favorWindow, false)
	arg0_2._tf:SetAsLastSibling()
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("close", arg0_4.awardWindow), function()
		arg0_4:_close()
	end, SFX_CANCEL)
	seriesAsync({
		function(arg0_6)
			if arg0_4.contextData.isFavor then
				setActive(arg0_4.favorWindow, true)
				setText(arg0_4.favorLvTF, arg0_4.contextData.char:GetFavorInfo().lv)
				arg0_4:managedTween(LeanTween.delayedCall, arg0_6, 1, nil)
			else
				arg0_6()
			end
		end
	}, function()
		arg0_4:ShowAwardWindow()
	end)
end

function var0_0.ShowAwardWindow(arg0_8)
	setActive(arg0_8.favorWindow, false)

	arg0_8.inAnimPlaying = true

	setActive(arg0_8.awardWindow, true)
	arg0_8.anim:Play("anim_educate_dropaward_in")

	local var0_8 = {}

	table.insert(var0_8, function(arg0_9)
		arg0_8:managedTween(LeanTween.delayedCall, function()
			arg0_9()
		end, 0.33, nil)
	end)

	for iter0_8 = 1, #arg0_8.drops do
		table.insert(var0_8, function(arg0_11)
			local var0_11 = arg0_8.drops[iter0_8]
			local var1_11 = cloneTplTo(arg0_8.itemTpl, arg0_8.itemContainer)

			NewEducateHelper.UpdateItem(var1_11, var0_11)
			onButton(arg0_8, var1_11, function()
				arg0_8:emit(NewEducateBaseUI.ON_ITEM, {
					drop = var0_11
				})
			end)
			arg0_8:managedTween(LeanTween.delayedCall, function()
				arg0_11()
			end, 0.066, nil)
		end)
	end

	seriesAsync(var0_8, function()
		arg0_8:managedTween(LeanTween.delayedCall, function()
			arg0_8.inAnimPlaying = false
		end, 0.066, nil)
	end)
end

function var0_0._close(arg0_16)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		arg0_16:emit(var0_0.ON_CLOSE)

		return
	end

	if arg0_16.inAnimPlaying or arg0_16.isCloseAnim then
		return
	end

	arg0_16.anim:Play("anim_educate_awardinfo_award_out")

	arg0_16.isCloseAnim = true
end

function var0_0.onBackPressed(arg0_17)
	arg0_17:_close()
end

function var0_0.willExit(arg0_18)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_18._tf)

	if arg0_18.contextData.removeFunc then
		arg0_18.contextData.removeFunc()

		arg0_18.contextData.removeFunc = nil
	end
end

return var0_0
