local var0 = class("EducateAwardInfoLayer", import("..base.EducateBaseUI"))
local var1 = {
	Vector2(0, 115),
	Vector2(0, 162)
}
local var2 = {
	Vector2(0, -280),
	Vector2(0, -315)
}
local var3 = 0.4

function var0.getUIName(arg0)
	return "EducateAwardInfoUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0.drops = arg0.contextData.items or {}
	arg0.awardWindow = arg0:findTF("award_window")
	arg0.anim = arg0.awardWindow:GetComponent(typeof(Animation))
	arg0.animEvent = arg0.awardWindow:GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		if #arg0.showPolaroidDrops > 0 then
			setActive(arg0.awardWindow, false)
			setActive(arg0.polaroidWindow, true)

			arg0.polaroidIndex = 1

			arg0:showPolaroidAnim()
		else
			arg0:emit(var0.ON_CLOSE)
		end
	end)

	arg0.tipTF = arg0:findTF("tip", arg0.awardWindow)

	setText(arg0.tipTF, i18n("child_close_tip"))

	arg0.itemContent = arg0:findTF("content/items", arg0.awardWindow)
	arg0.itemContainer = arg0:findTF("items_scroll/content", arg0.itemContent)
	arg0.itemTpl = arg0:findTF("item_tpl", arg0.awardWindow)

	setActive(arg0.itemTpl, false)

	arg0.attrContent = arg0:findTF("content/attrs", arg0.awardWindow)
	arg0.attrContainer = arg0:findTF("attrs_scroll/content", arg0.attrContent)
	arg0.attrTpl = arg0:findTF("attr_tpl", arg0.awardWindow)

	setActive(arg0.attrTpl, false)

	arg0.polaroidWindow = arg0:findTF("polaroid_window")
	arg0.polaroidIconTF = arg0:findTF("content/mask/icon", arg0.polaroidWindow)
	arg0.polaroidDescTF = arg0:findTF("content/desc", arg0.polaroidWindow)

	setActive(arg0.awardWindow, false)
	setActive(arg0.polaroidWindow, false)
	arg0._tf:SetAsLastSibling()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("close", arg0.awardWindow), function()
		arg0:_close()
	end, SFX_CANCEL)
	onButton(arg0, arg0.polaroidWindow, function()
		if arg0.playing then
			return
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("child_polaroid_get_tip"))

		if arg0.polaroidIndex <= #arg0.showPolaroidDrops then
			arg0:showPolaroidAnim()
		else
			arg0:emit(var0.ON_CLOSE)
		end
	end, SFX_CANCEL)

	arg0.showAwardDrops = arg0:getAwardDrops()
	arg0.showAttrDrops = arg0:getAttrDrops()
	arg0.showPolaroidDrops = arg0:getPolaroidDrops()

	local var0 = #arg0.showAttrDrops > 0

	setActive(arg0.attrContent, var0)
	arg0:showWindow()
end

function var0.showWindow(arg0)
	if #arg0.showAwardDrops > 0 then
		arg0.inAnimPlaying = true

		setActive(arg0.awardWindow, true)

		local var0 = #arg0.showAttrDrops > 0 and "anim_educate_awardinfo_awardattr_in" or "anim_educate_awardinfo_award_in"

		arg0.anim:Play(var0)

		local var1 = {}

		table.insert(var1, function(arg0)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0()
			end, 0.33, nil)
		end)

		local var2 = math.max(#arg0.showAttrDrops, #arg0.showAwardDrops)

		for iter0 = 1, var2 do
			table.insert(var1, function(arg0)
				local var0 = arg0.showAwardDrops[iter0]

				if var0 then
					local var1 = cloneTplTo(arg0.itemTpl, arg0.itemContainer)

					EducateHelper.UpdateDropShow(var1, var0)
					onButton(arg0, var1, function()
						arg0:emit(var0.EDUCATE_ON_ITEM, {
							drop = var0
						})
					end)
				end

				local var2 = arg0.showAttrDrops[iter0]

				if var2 then
					local var3 = cloneTplTo(arg0.attrTpl, arg0.attrContainer)

					EducateHelper.UpdateDropShowForAttr(var3, var2)
				end

				arg0:managedTween(LeanTween.delayedCall, function()
					arg0()
				end, 0.066, nil)
			end)
		end

		seriesAsync(var1, function()
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0.inAnimPlaying = false
			end, 0.066, nil)
		end)
	elseif #arg0.showPolaroidDrops > 0 then
		setActive(arg0.polaroidWindow, true)

		arg0.polaroidIndex = 1

		arg0:showPolaroidAnim()
	else
		assert(nil, "不合法掉落, award/polaroid都为空, 请检查对应配置~")
	end
end

function var0.getAwardDrops(arg0)
	return EducateHelper.FilterDropByTypes(arg0.drops, {
		EducateConst.DROP_TYPE_ATTR,
		EducateConst.DROP_TYPE_RES,
		EducateConst.DROP_TYPE_ITEM,
		EducateConst.DROP_TYPE_BUFF
	})
end

function var0.getAttrDrops(arg0)
	local var0 = EducateHelper.FilterDropByTypes(arg0.drops, {
		EducateConst.DROP_TYPE_ITEM
	})
	local var1 = {}

	underscore.each(var0, function(arg0)
		var1 = table.mergeArray(var1, EducateHelper.GetItemAddDrops(arg0))
	end)

	return var1
end

function var0.getPolaroidDrops(arg0)
	return EducateHelper.FilterDropByTypes(arg0.drops, {
		EducateConst.DROP_TYPE_POLAROID
	})
end

function var0.showPolaroidAnim(arg0)
	arg0.playing = true

	local var0 = arg0.showPolaroidDrops[arg0.polaroidIndex]

	setActive(arg0.polaroidDescTF, false)

	local var1 = pg.child_polaroid[var0.id]

	LoadImageSpriteAsync("educatepolaroid/" .. var1.pic, arg0.polaroidIconTF)
	setText(arg0.polaroidDescTF, var1.title)

	local var2 = {}

	table.insert(var2, function(arg0)
		arg0:managedTween(LeanTween.delayedCall, function()
			setActive(arg0.polaroidDescTF, true)
			arg0()
		end, var3, nil)
	end)

	if getProxy(EducateProxy):CheckNewSecretaryTip() then
		table.insert(var2, function(arg0)
			arg0:emit(var0.EDUCATE_ON_UNLOCK_TIP, {
				type = EducateUnlockTipLayer.UNLOCK_NEW_SECRETARY,
				onExit = arg0
			})
		end)
	end

	seriesAsync(var2, function()
		arg0.playing = false
		arg0.polaroidIndex = arg0.polaroidIndex + 1
	end)
end

function var0._close(arg0)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		arg0:emit(var0.ON_CLOSE)

		return
	end

	if arg0.inAnimPlaying or arg0.isCloseAnim then
		return
	end

	arg0.anim:Play("anim_educate_awardinfo_award_out")

	arg0.isCloseAnim = true
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.contextData.removeFunc then
		arg0.contextData.removeFunc()

		arg0.contextData.removeFunc = nil
	end
end

return var0
