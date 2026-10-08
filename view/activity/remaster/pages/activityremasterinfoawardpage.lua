local var0_0 = class("ActivityRemasterInfoAwardPage", import("view.base.BaseSubView"))

var0_0.ON_SKIP_ACT = "ActivityRemasterCoreActivityAdaptUI"

function var0_0.getUIName(arg0_1)
	return "ActivityRemasterInfoAwardPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.itemTr = arg0_2._tf:Find("window/middle/award")
	arg0_2.nameTxt = arg0_2._tf:Find("window/middle/name")
	arg0_2.descTxt = arg0_2._tf:Find("window/middle/desc")
	arg0_2.ownTxt = arg0_2._tf:Find("window/middle/own")
	arg0_2.boxSrcContent = arg0_2._tf:Find("window/middle/ways")
	arg0_2.boxSrcTpl = arg0_2._tf:Find("window/middle/ways/tpl")
end

function var0_0.OnInit(arg0_3)
	arg0_3:CommonSetting({
		title = i18n("word_obtain_way")
	})
end

function var0_0.CommonSetting(arg0_4, arg1_4)
	setText(arg0_4._tf:Find("window/top/title"), arg1_4.title or i18n("words_information"))

	function arg0_4.hideCall()
		arg0_4.hideCall = nil

		existCall(arg1_4.onClose)
	end

	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		existCall(arg0_4.hideCall)
		arg0_4:Hide()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4._tf:Find("window/top/btn_close"), function()
		existCall(arg0_4.hideCall)
		arg0_4:Hide()
	end, SFX_CANCEL)

	function arg0_4.confirmCall()
		arg0_4.confirmCall = nil

		existCall(arg0_4.onConfirm)
	end

	local var0_4 = arg1_4.btnList or {
		{
			type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.cancel,
			name = i18n("msgbox_text_cancel"),
			func = function()
				existCall(arg0_4.hideCall)
			end,
			sound = SFX_CANCEL
		},
		{
			type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
			name = i18n("msgbox_text_confirm"),
			func = function()
				existCall(arg0_4.confirmCall)
			end,
			sound = SFX_CONFIRM
		}
	}
	local var1_4 = arg0_4._tf:Find("window/bottom/button_container")

	eachChild(var1_4, function(arg0_11)
		setActive(arg0_11, false)
	end)

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var2_4 = var1_4:Find(iter1_4.type)

		if var2_4:GetSiblingIndex() < var1_4.childCount - iter0_4 + 1 then
			var2_4:SetAsLastSibling()
			setActive(var2_4, true)
		else
			var2_4 = cloneTplTo(var2_4, var1_4, var2_4.name)
		end

		setText(var2_4:Find("Text"), iter1_4.name)
		onButton(arg0_4, var2_4, function()
			existCall(iter1_4.func)
			arg0_4:Hide()
		end, iter1_4.sound or SFX_CONFIRM)
	end
end

function var0_0.Show(arg0_13, arg1_13)
	var0_0.super.Show(arg0_13)

	local var0_13 = arg1_13:GetDrop()

	updateDrop(arg0_13.itemTr, var0_13)
	changeToScrollText(arg0_13.nameTxt, var0_13:getName())

	local var1_13 = string.gsub(var0_13.desc or "", "#92fc63", "#39bfff")

	setText(arg0_13.descTxt, var1_13 or "")

	local var2_13 = var0_13:getCount()
	local var3_13 = arg1_13:GetOwnedCount()

	setText(arg0_13.ownTxt, i18n("ActivityRemasterCore_award_own_desc", var3_13 .. (var2_13 > 0 and "/" .. var2_13 or "")))
	arg0_13:UpdateWays(arg1_13:GetWays())
end

function var0_0.UpdateWays(arg0_14, arg1_14)
	UIItemList.StaticAlign(arg0_14.boxSrcContent, arg0_14.boxSrcTpl, #arg1_14, function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg1_14[arg1_15 + 1]
			local var1_15 = var0_15[1]
			local var2_15 = var0_15[2]
			local var3_15 = var0_15[3]

			changeToScrollText(arg2_15:Find("Text"), var3_15)

			local var4_15 = arg2_15:Find("go")

			setText(var4_15:Find("Text"), i18n("brs_reward_tip_2"))
			onButton(arg0_14, var4_15, function()
				arg0_14:DoSkip(var1_15, var2_15)
				arg0_14:Hide()
			end, SFX_PANEL)
		end
	end)
end

function var0_0.DoSkip(arg0_17, arg1_17, arg2_17)
	if arg1_17 == Msgbox4LinkCollectGuide.SKIP_TYPE_SCENE then
		pg.m02:sendNotification(GAME.GO_SCENE, arg2_17[1], arg2_17[2] or {})
	elseif arg1_17 == Msgbox4LinkCollectGuide.SKIP_TYPE_ACTIVITY then
		arg0_17:emit(ActivityRemasterInfoAwardPage.ON_SKIP_ACT, arg2_17)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg2_17
		})
	end
end

function var0_0.OnDestroy(arg0_18)
	return
end

return var0_0
