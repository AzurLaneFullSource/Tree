local var0_0 = class("EducateAwardInfoLayer", import("..base.EducateBaseUI"))
local var1_0 = {
	Vector2(0, 115),
	Vector2(0, 162)
}
local var2_0 = {
	Vector2(0, -280),
	Vector2(0, -315)
}
local var3_0 = 0.4

function var0_0.getUIName(arg0_1)
	return "EducateAwardInfoUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0_2.drops = arg0_2.contextData.items or {}
	arg0_2.awardWindow = arg0_2:findTF("award_window")
	arg0_2.anim = arg0_2.awardWindow:GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2.awardWindow:GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		if #arg0_2.showPolaroidDrops > 0 then
			setActive(arg0_2.awardWindow, false)
			setActive(arg0_2.polaroidWindow, true)

			arg0_2.polaroidIndex = 1

			arg0_2:showPolaroidAnim()
		else
			arg0_2:emit(var0_0.ON_CLOSE)
		end
	end)

	arg0_2.tipTF = arg0_2:findTF("tip", arg0_2.awardWindow)

	setText(arg0_2.tipTF, i18n("child_close_tip"))

	arg0_2.itemContent = arg0_2:findTF("content/items", arg0_2.awardWindow)
	arg0_2.itemContainer = arg0_2:findTF("items_scroll/content", arg0_2.itemContent)
	arg0_2.itemTpl = arg0_2:findTF("item_tpl", arg0_2.awardWindow)

	setActive(arg0_2.itemTpl, false)

	arg0_2.attrContent = arg0_2:findTF("content/attrs", arg0_2.awardWindow)
	arg0_2.attrContainer = arg0_2:findTF("attrs_scroll/content", arg0_2.attrContent)
	arg0_2.attrTpl = arg0_2:findTF("attr_tpl", arg0_2.awardWindow)

	setActive(arg0_2.attrTpl, false)

	arg0_2.polaroidWindow = arg0_2:findTF("polaroid_window")
	arg0_2.polaroidIconTF = arg0_2:findTF("content/mask/icon", arg0_2.polaroidWindow)
	arg0_2.polaroidDescTF = arg0_2:findTF("content/desc", arg0_2.polaroidWindow)

	setActive(arg0_2.awardWindow, false)
	setActive(arg0_2.polaroidWindow, false)
	arg0_2._tf:SetAsLastSibling()
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("close", arg0_4.awardWindow), function()
		arg0_4:_close()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.polaroidWindow, function()
		if arg0_4.playing then
			return
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("child_polaroid_get_tip"))

		if arg0_4.polaroidIndex <= #arg0_4.showPolaroidDrops then
			arg0_4:showPolaroidAnim()
		else
			arg0_4:emit(var0_0.ON_CLOSE)
		end
	end, SFX_CANCEL)

	arg0_4.showAwardDrops = arg0_4:getAwardDrops()
	arg0_4.showAttrDrops = arg0_4:getAttrDrops()
	arg0_4.showPolaroidDrops = arg0_4:getPolaroidDrops()

	local var0_4 = #arg0_4.showAttrDrops > 0

	setActive(arg0_4.attrContent, var0_4)
	arg0_4:showWindow()
end

function var0_0.showWindow(arg0_7)
	if #arg0_7.showAwardDrops > 0 then
		arg0_7.inAnimPlaying = true

		setActive(arg0_7.awardWindow, true)

		local var0_7 = #arg0_7.showAttrDrops > 0 and "anim_educate_awardinfo_awardattr_in" or "anim_educate_awardinfo_award_in"

		arg0_7.anim:Play(var0_7)

		local var1_7 = {}

		table.insert(var1_7, function(arg0_8)
			arg0_7:managedTween(LeanTween.delayedCall, function()
				arg0_8()
			end, 0.33, nil)
		end)

		local var2_7 = math.max(#arg0_7.showAttrDrops, #arg0_7.showAwardDrops)

		for iter0_7 = 1, var2_7 do
			table.insert(var1_7, function(arg0_10)
				local var0_10 = arg0_7.showAwardDrops[iter0_7]

				if var0_10 then
					local var1_10 = cloneTplTo(arg0_7.itemTpl, arg0_7.itemContainer)

					EducateHelper.UpdateDropShow(var1_10, var0_10)
					onButton(arg0_7, var1_10, function()
						arg0_7:emit(var0_0.EDUCATE_ON_ITEM, {
							drop = var0_10
						})
					end)
				end

				local var2_10 = arg0_7.showAttrDrops[iter0_7]

				if var2_10 then
					local var3_10 = cloneTplTo(arg0_7.attrTpl, arg0_7.attrContainer)

					EducateHelper.UpdateDropShowForAttr(var3_10, var2_10)
				end

				arg0_7:managedTween(LeanTween.delayedCall, function()
					arg0_10()
				end, 0.066, nil)
			end)
		end

		seriesAsync(var1_7, function()
			arg0_7:managedTween(LeanTween.delayedCall, function()
				arg0_7.inAnimPlaying = false
			end, 0.066, nil)
		end)
	elseif #arg0_7.showPolaroidDrops > 0 then
		setActive(arg0_7.polaroidWindow, true)

		arg0_7.polaroidIndex = 1

		arg0_7:showPolaroidAnim()
	else
		assert(nil, "不合法掉落, award/polaroid都为空, 请检查对应配置~")
	end
end

function var0_0.getAwardDrops(arg0_15)
	return EducateHelper.FilterDropByTypes(arg0_15.drops, {
		EducateConst.DROP_TYPE_ATTR,
		EducateConst.DROP_TYPE_RES,
		EducateConst.DROP_TYPE_ITEM,
		EducateConst.DROP_TYPE_BUFF
	})
end

function var0_0.getAttrDrops(arg0_16)
	local var0_16 = EducateHelper.FilterDropByTypes(arg0_16.drops, {
		EducateConst.DROP_TYPE_ITEM
	})
	local var1_16 = {}

	underscore.each(var0_16, function(arg0_17)
		var1_16 = table.mergeArray(var1_16, EducateHelper.GetItemAddDrops(arg0_17))
	end)

	return var1_16
end

function var0_0.getPolaroidDrops(arg0_18)
	return EducateHelper.FilterDropByTypes(arg0_18.drops, {
		EducateConst.DROP_TYPE_POLAROID
	})
end

function var0_0.showPolaroidAnim(arg0_19)
	arg0_19.playing = true

	local var0_19 = arg0_19.showPolaroidDrops[arg0_19.polaroidIndex]

	setActive(arg0_19.polaroidDescTF, false)

	local var1_19 = pg.child_polaroid[var0_19.id]

	LoadImageSpriteAsync("educatepolaroid/" .. var1_19.pic, arg0_19.polaroidIconTF)
	setText(arg0_19.polaroidDescTF, var1_19.title)

	local var2_19 = {}

	table.insert(var2_19, function(arg0_20)
		arg0_19:managedTween(LeanTween.delayedCall, function()
			setActive(arg0_19.polaroidDescTF, true)
			arg0_20()
		end, var3_0, nil)
	end)

	if getProxy(EducateProxy):CheckNewSecretaryTip() then
		table.insert(var2_19, function(arg0_22)
			arg0_19:emit(var0_0.EDUCATE_ON_UNLOCK_TIP, {
				type = EducateUnlockTipLayer.UNLOCK_NEW_SECRETARY,
				onExit = arg0_22
			})
		end)
	end

	seriesAsync(var2_19, function()
		arg0_19.playing = false
		arg0_19.polaroidIndex = arg0_19.polaroidIndex + 1
	end)
end

function var0_0._close(arg0_24)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		arg0_24:emit(var0_0.ON_CLOSE)

		return
	end

	if arg0_24.inAnimPlaying or arg0_24.isCloseAnim then
		return
	end

	arg0_24.anim:Play("anim_educate_awardinfo_award_out")

	arg0_24.isCloseAnim = true
end

function var0_0.onBackPressed(arg0_25)
	arg0_25:_close()
end

function var0_0.willExit(arg0_26)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_26._tf)

	if arg0_26.contextData.removeFunc then
		arg0_26.contextData.removeFunc()

		arg0_26.contextData.removeFunc = nil
	end
end

return var0_0
