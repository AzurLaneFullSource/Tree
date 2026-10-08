local var0_0 = class("ActivityRemasterInfoDisplayPage", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.getUIName(arg0_1)
	return "ActivityRemasterInfoDisplayPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.toggles = {
		[var1_0] = arg0_2._tf:Find("window/middle/toggles/ship"),
		[var2_0] = arg0_2._tf:Find("window/middle/toggles/es"),
		[var3_0] = arg0_2._tf:Find("window/middle/toggles/other")
	}
	arg0_2.uiItemList = {
		[var1_0] = UIItemList.New(arg0_2._tf:Find("window/middle/view/ship/content"), arg0_2._tf:Find("window/middle/view/ship/content/ship_tpl")),
		[var2_0] = UIItemList.New(arg0_2._tf:Find("window/middle/view/es/content"), arg0_2._tf:Find("window/middle/view/es/content/ship_tpl")),
		[var3_0] = UIItemList.New(arg0_2._tf:Find("window/middle/view/other/content"), arg0_2._tf:Find("window/middle/view/es/content/ship_tpl"))
	}

	setText(arg0_2._tf:Find("window/middle/title_bg/Text"), i18n("ActivityRemasterCore_award_preview_title"))

	arg0_2.awardPage = ActivityRemasterInfoAwardPage.New(arg0_2._tf, arg0_2.event)
end

function var0_0.OnInit(arg0_3)
	arg0_3:CommonSetting({})
end

function var0_0.Show(arg0_4, arg1_4, arg2_4, arg3_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)

	arg0_4.onConfirm = arg3_4
	arg0_4.remasterData = ActivityRemasterData.New({
		id = arg1_4
	})

	setText(arg0_4._tf:Find("window/middle/content"), arg2_4)
	setActive(arg0_4._tf, true)
	arg0_4:InitToggles()
	triggerToggle(arg0_4.toggles[var1_0], true)
end

function var0_0.Hide(arg0_5, arg1_5)
	if not arg0_5._tf then
		return
	end

	setActive(arg0_5._tf, false)

	arg0_5.onConfirm = nil

	if arg0_5.awardPage and arg0_5.awardPage:GetLoaded() then
		arg0_5.awardPage:Hide()
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_5._tf, pg.UIMgr.GetInstance().OverlayMain)
end

local function var4_0(arg0_6, arg1_6)
	local var0_6 = ""

	if arg1_6 == var1_0 then
		var0_6 = arg0_6:GetShipOwnStr()
	elseif arg1_6 == var2_0 then
		var0_6 = arg0_6:GetEsOwnStr()
	elseif arg1_6 == var3_0 then
		var0_6 = arg0_6:GetOtherOwnStr()
	end

	return ({
		[var1_0] = i18n("ActivityRemasterCore_award_preview_ship", var0_6),
		[var2_0] = i18n("ActivityRemasterCore_award_preview_es", var0_6),
		[var3_0] = i18n("ActivityRemasterCore_award_preview_other", var0_6)
	})[arg1_6]
end

function var0_0.InitToggles(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.toggles) do
		local var0_7 = var4_0(arg0_7.remasterData, iter0_7)

		onToggle(arg0_7, iter1_7, function(arg0_8)
			local var0_8 = arg0_8 and COLOR_WHITE or "#393a3c"

			setText(iter1_7:Find("Text"), setColorStr(var0_7, var0_8))

			if arg0_8 then
				arg0_7:SwitchPage(iter0_7)
			end
		end, SFX_PANEL)
		setText(iter1_7:Find("Text"), setColorStr(var0_7, "#393a3c"))
	end
end

function var0_0.GetDisplayData(arg0_9, arg1_9)
	local var0_9 = {}
	local var1_9 = arg0_9.remasterData

	if arg1_9 == var1_0 then
		var0_9 = var1_9:GetRawCollectableShipIdList()
	elseif arg1_9 == var2_0 then
		var0_9 = var1_9:GetRawCollectableEsList()
	elseif arg1_9 == var3_0 then
		var0_9 = var1_9:GetRawCollectableOtherList()
	end

	return var0_9
end

function var0_0.SwitchPage(arg0_10, arg1_10)
	local var0_10 = arg0_10.uiItemList[arg1_10]
	local var1_10 = arg0_10:GetDisplayData(arg1_10)

	var0_10:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			if arg1_10 == var1_0 then
				arg0_10:UpdateShipCard(arg2_11, var1_10[arg1_11 + 1])
			elseif arg1_10 == var2_0 or arg1_10 == var3_0 then
				arg0_10:UpdateItemCard(arg2_11, var1_10[arg1_11 + 1])
			end
		end
	end)
	var0_10:align(#var1_10)
	scrollToBottom(var0_10.container.parent)
end

function var0_0.UpdateShipCard(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg2_12:GetRawDropData()[2]
	local var1_12 = ShipGroup.getDefaultShipConfig(var0_12)
	local var2_12 = var1_12.skin_id
	local var3_12 = pg.ship_skin_template[var2_12]

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var3_12.painting, var3_12.painting, arg1_12:Find("tpl/ico"))

	local var4_12 = getProxy(CollectionProxy):getShipGroup(var0_12)

	setActive(arg1_12:Find("tpl/mask"), var4_12)
	setScrollText(arg1_12:Find("name/mask/Text"), var1_12.name)
	onButton(arg0_12, arg1_12, function()
		local var0_13 = var1_12.id

		arg0_12:OpenDesc(arg2_12)
	end, SFX_PANEL)
end

function var0_0.UpdateItemCard(arg0_14, arg1_14, arg2_14)
	local var0_14 = Drop.Create(arg2_14:GetRawDropData())

	updateDrop(arg1_14:Find("award"), var0_14)
	setScrollText(arg1_14:Find("name/mask/Text"), var0_14.cfg.name)
	setActive(arg1_14:Find("award/mask"), var0_14:getOwnedCount() > 0)
	onButton(arg0_14, arg1_14, function()
		arg0_14:OpenDesc(arg2_14)
	end, SFX_PANEL)
end

function var0_0.OpenDesc(arg0_16, arg1_16)
	return
end

function var0_0.CommonSetting(arg0_17, arg1_17)
	setText(arg0_17._tf:Find("window/top/title"), arg1_17.title or i18n("words_information"))

	function arg0_17.hideCall()
		arg0_17.hideCall = nil

		existCall(arg1_17.onClose)
	end

	onButton(arg0_17, arg0_17._tf:Find("bg"), function()
		existCall(arg0_17.hideCall)
		arg0_17:Hide()
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17._tf:Find("window/top/btn_close"), function()
		existCall(arg0_17.hideCall)
		arg0_17:Hide()
	end, SFX_CANCEL)

	function arg0_17.confirmCall()
		arg0_17.confirmCall = nil

		existCall(arg0_17.onConfirm)
	end

	local var0_17 = arg1_17.btnList or {
		{
			type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.cancel,
			name = i18n("msgbox_text_cancel"),
			func = function()
				existCall(arg0_17.hideCall)
			end,
			sound = SFX_CANCEL
		},
		{
			type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
			name = i18n("msgbox_text_confirm"),
			func = function()
				existCall(arg0_17.confirmCall)
			end,
			sound = SFX_CONFIRM
		}
	}
	local var1_17 = arg0_17._tf:Find("window/bottom/button_container")

	eachChild(var1_17, function(arg0_24)
		setActive(arg0_24, false)
	end)

	for iter0_17, iter1_17 in ipairs(var0_17) do
		local var2_17 = var1_17:Find(iter1_17.type)

		if var2_17:GetSiblingIndex() < var1_17.childCount - iter0_17 + 1 then
			var2_17:SetAsLastSibling()
			setActive(var2_17, true)
		else
			var2_17 = cloneTplTo(var2_17, var1_17, var2_17.name)
		end

		setText(var2_17:Find("Text"), iter1_17.name)
		onButton(arg0_17, var2_17, function()
			existCall(iter1_17.func)
			arg0_17:Hide()
		end, iter1_17.sound or SFX_CONFIRM)
	end
end

function var0_0.onBackPressed(arg0_26)
	if arg0_26.awardPage and arg0_26.awardPage:GetLoaded() and arg0_26.awardPage:isShowing() then
		arg0_26.awardPage:Hide()

		return
	end

	arg0_26:Hide()
end

function var0_0.OnDestroy(arg0_27)
	if arg0_27:isShowing() then
		arg0_27:Hide()
	end

	if arg0_27.awardPage and arg0_27.awardPage:GetLoaded() then
		arg0_27.awardPage:Destroy()
	end

	arg0_27.awardPage = nil
end

return var0_0
