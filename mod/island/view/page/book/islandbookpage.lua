local var0_0 = class("IslandBookPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandBookUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_guide"))
	setText(arg0_2._tf:Find("top/title/Text/en"), i18n("island_guide_en"))

	arg0_2.charBtn = arg0_2._tf:Find("view/content/char")
	arg0_2.charTip = arg0_2.charBtn:Find("tip")
	arg0_2.npcBtn = arg0_2._tf:Find("view/content/npc")
	arg0_2.npcTip = arg0_2.npcBtn:Find("tip")
	arg0_2.itemBtn = arg0_2._tf:Find("view/content/item")
	arg0_2.itemTip = arg0_2.itemBtn:Find("tip")
	arg0_2.fishBtn = arg0_2._tf:Find("view/content/fish")
	arg0_2.fishTip = arg0_2.fishBtn:Find("tip")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.charBtn, function()
		arg0_3:OpenPage(IslandBookCharPage)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.npcBtn, function()
		arg0_3:OpenPage(IslandBookNpcPage)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.itemBtn, function()
		arg0_3:OpenPage(IslandBookItemPage)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.fishBtn, function()
		arg0_3:OpenPage(IslandBookFishPage)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE, arg0_9.FlushTips)
	arg0_9:AddListener(GAME.ISLAND_GET_COLLECT_POINT_DONE, arg0_9.FlushTips)
	arg0_9:AddListener(GAME.ISLAND_GET_POINT_AWARD_DONE, arg0_9.FlushTips)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE, arg0_10.FlushTips)
	arg0_10:RemoveListener(GAME.ISLAND_GET_COLLECT_POINT_DONE, arg0_10.FlushTips)
	arg0_10:RemoveListener(GAME.ISLAND_GET_POINT_AWARD_DONE, arg0_10.FlushTips)
end

function var0_0.OnShow(arg0_11)
	arg0_11:FlushTips()
end

function var0_0.FlushTips(arg0_12)
	setActive(arg0_12.fishBtn, IslandMainBtnTipHelper.IsUnlock("book_fish"))

	arg0_12.bookAgency = getProxy(IslandProxy):GetIsland():GetBookAgency()

	setActive(arg0_12.charTip, arg0_12.bookAgency:IsTipFromTypes({
		IslandIllustration.TYPES.CHAR
	}))
	setActive(arg0_12.npcTip, arg0_12.bookAgency:IsTipFromTypes({
		IslandIllustration.TYPES.NPC
	}))
	setActive(arg0_12.itemTip, arg0_12.bookAgency:IsTipFromTypes({
		IslandIllustration.TYPES.ITEM
	}))
	setActive(arg0_12.fishTip, arg0_12.bookAgency:IsTipFromTypes({
		IslandIllustration.TYPES.FISH
	}))
end

return var0_0
