local var0_0 = class("IslandUpgradeDisplayPage", import("...base.IslandBasePage"))
local var1_0 = 1
local var2_0 = 2

function var0_0.getUIName(arg0_1)
	return "IslandCommonUpgradeDisplayUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.onlnyLevelTr = arg0_2._tf:Find("small")
	arg0_2.dropPanelTr = arg0_2._tf:Find("module")
	arg0_2.unlockUIList = UIItemList.New(arg0_2.dropPanelTr:Find("Board/Content/award/content"), arg0_2.dropPanelTr:Find("Board/Content/award/content/tpl"))
	arg0_2.canvasGroup = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))

	setText(arg0_2._tf:Find("module/tip"), i18n("island_3Dshop_close"))
	setText(arg0_2._tf:Find("small/tip"), i18n("island_3Dshop_close"))
	GetComponent(arg0_2._tf:Find("module/bg/Top/title"), "Image"):SetNativeSize()
	GetComponent(arg0_2._tf:Find("module/bg/Top/title/title_item"), "Image"):SetNativeSize()
	GetComponent(arg0_2._tf:Find("module/bg/Top/star"), "Image"):SetNativeSize()
	GetComponent(arg0_2._tf:Find("module/bg/Top/star/title_item"), "Image"):SetNativeSize()
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:PlayExitAnimation(function()
			local var0_5 = arg0_3.callback

			arg0_3:Hide()

			if var0_5 then
				var0_5()
			end
		end)
	end, SFX_PANEL)
end

function var0_0.PlayExitAnimation(arg0_6, arg1_6)
	local var0_6 = arg0_6.targetTr:GetComponent(typeof(Animation))
	local var1_6 = arg0_6.targetTr:GetComponent(typeof(DftAniEvent))

	arg0_6.canvasGroup.blocksRaycasts = false

	var1_6:SetEndEvent(function()
		var1_6:SetEndEvent(nil)

		arg0_6.canvasGroup.blocksRaycasts = true

		arg1_6()
	end)

	if arg0_6.targetTr == arg0_6.onlnyLevelTr then
		var0_6:Play("anim_Island_commonget_onlylv_out")
	else
		var0_6:Play("anim_Island_commonget_single_out")
	end
end

function var0_0.Show(arg0_8, arg1_8, arg2_8)
	var0_0.super.Show(arg0_8)

	arg0_8.callback = arg2_8

	local var0_8 = arg0_8:GetIsland()
	local var1_8 = arg1_8 and #arg1_8 > 0

	if var1_8 then
		arg0_8:CommonSettings(var0_8, arg0_8.dropPanelTr)
		arg0_8:UpdateUnlockList(arg1_8)
	else
		arg0_8:CommonSettings(var0_8, arg0_8.onlnyLevelTr)
	end

	setActive(arg0_8.onlnyLevelTr, not var1_8)
	setActive(arg0_8.dropPanelTr, var1_8)

	arg0_8.targetTr = var1_8 and arg0_8.dropPanelTr or arg0_8.onlnyLevelTr

	local var2_8 = arg0_8.targetTr:GetComponent(typeof(Animation))

	if arg0_8.targetTr == arg0_8.onlnyLevelTr then
		var2_8:Play("anim_Island_commonget_onlylv_in")
	else
		var2_8:Play("anim_Island_commonget_single_in")
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0_8._tf)
end

function var0_0.Hide(arg0_9)
	arg0_9.callback = nil

	var0_0.super.Hide(arg0_9)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9._tf, arg0_9._parentTf)
end

function var0_0.OnShow(arg0_10)
	arg0_10.canvasGroup.interactable = true
	arg0_10.canvasGroup.blocksRaycasts = true
end

function var0_0.OnHide(arg0_11)
	arg0_11.canvasGroup.interactable = false
	arg0_11.canvasGroup.blocksRaycasts = false
end

function var0_0.CommonSettings(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12:GetLevel()

	setText(arg2_12:Find("Board/Top/LV/prev/prev_1"), "<size=50>" .. var0_12 - 1 .. "</size>")
	setText(arg2_12:Find("Board/Top/LV/next/next_1"), "<size=50>" .. var0_12 .. "</size>")
end

function var0_0.UpdateUnlockList(arg0_13, arg1_13)
	arg0_13.unlockUIList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg1_13[arg1_14 + 1]

			updateCustomDrop(arg2_14, var0_14)
			setText(arg2_14:Find("icon_bg/name_bg/Text"), shortenString(var0_14:getConfigTable().unlock_text, 5))

			local var1_14 = var0_14:getConfigTable().show_type

			GetImageSpriteFromAtlasAsync("ui/islandupgradedisplayui_atlas", "ability_type" .. var1_14, arg2_14:Find("icon_bg/type"))
		end
	end)
	arg0_13.unlockUIList:align(#arg1_13)
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
