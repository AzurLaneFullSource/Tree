local var0_0 = class("AgoraDecorationView", import("Mod.Island.Core.View.IslandBaseSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraDecorationUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform

	setParent(arg1_2, pg.UIMgr.GetInstance().UIMain)

	arg0_2.cards = {}
	arg0_2.scrollRect = arg0_2._tf:Find("panel/scrollrect"):GetComponent("LScrollRect")
	arg0_2.agoraSaveBtn = arg0_2._tf:Find("btns/save")
	arg0_2.agoraUpgradeBtn = arg0_2._tf:Find("btns/upgrade")
	arg0_2.agoraClearBtn = arg0_2._tf:Find("btns/clear")
	arg0_2.agoraRevertBtn = arg0_2._tf:Find("btns/revert")
	arg0_2.agoraShopBtn = arg0_2._tf:Find("btns/shop")
	arg0_2.agoraSwitchBtn = arg0_2._tf:Find("btns/switch")
	arg0_2.backBtn = arg0_2._tf:Find("panel/back")

	arg0_2:RegisterEvent()
	setText(arg0_2._tf:Find("btns/upgrade/Text"), i18n1("更新"))
	setText(arg0_2._tf:Find("btns/clear/Text"), i18n1("清空"))
	setText(arg0_2._tf:Find("btns/revert/Text"), i18n1("还原"))
	setText(arg0_2._tf:Find("btns/save/Text"), i18n1("保存"))
	setText(arg0_2._tf:Find("btns/switch/Text"), i18n1("当前:室外"))
	setText(arg0_2._tf:Find("btns/capacity/Text"), i18n1("容量: 1/1"))
	setText(arg0_2._tf:Find("panel/title/Text"), i18n1("集会所"))
end

function var0_0.RegisterEvent(arg0_3)
	function arg0_3.scrollRect.onInitItem(arg0_4)
		arg0_3:OnInitItem(arg0_4)
	end

	function arg0_3.scrollRect.onUpdateItem(arg0_5, arg1_5)
		arg0_3:OnUpdateItem(arg0_5, arg1_5)
	end

	onButton(arg0_3, arg0_3.agoraSaveBtn, function()
		arg0_3:Op("Save")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.agoraUpgradeBtn, function()
		arg0_3:Op("Upgrade")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.agoraClearBtn, function()
		arg0_3:Op("ClearAll")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.agoraRevertBtn, function()
		arg0_3:Op("Revert")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.agoraShopBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n1("尚未开发"))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.agoraSwitchBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n1("尚未开发"))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Op("RevertAndExit")
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_13, arg1_13)
	local var0_13 = AgoraDecorationCard.New(arg1_13)

	onButton(arg0_13, var0_13._go, function()
		if var0_13.isUsing then
			return
		end

		arg0_13:Op("PlaceItemRandonPosition", var0_13.item.id)
	end, SFX_PANEL)

	arg0_13.cards[arg1_13] = var0_13
end

function var0_0.OnUpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.cards[arg2_15]

	if not var0_15 then
		arg0_15:OnInitItem(arg2_15)

		var0_15 = arg0_15.cards[arg2_15]
	end

	local var1_15 = arg0_15.displays[arg1_15 + 1]
	local var2_15 = var1_15.item
	local var3_15 = var1_15.isUsing

	var0_15:Update(var2_15, var3_15)
end

function var0_0.GetDisplays(arg0_16)
	local var0_16 = arg0_16:GetView()
	local var1_16 = var0_16.agora:GetPlaceableList()
	local var2_16 = {}

	for iter0_16, iter1_16 in pairs(var1_16) do
		local var3_16 = var0_16.agora:IsUsing(iter1_16.id)

		table.insert(var2_16, {
			item = iter1_16,
			isUsing = var3_16
		})
	end

	return var2_16
end

function var0_0.Flush(arg0_17)
	arg0_17:FlushList()
end

function var0_0.FlushList(arg0_18)
	arg0_18.displays = arg0_18:GetDisplays()

	arg0_18.scrollRect:SetTotalCount(#arg0_18.displays)
end

function var0_0.OnDestroy(arg0_19)
	for iter0_19, iter1_19 in pairs(arg0_19.cards or {}) do
		iter1_19:Dispose()
	end

	arg0_19.cards = {}
end

return var0_0
