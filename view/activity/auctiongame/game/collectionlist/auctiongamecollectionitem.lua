local var0_0 = class("AuctionGameCollectionItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3, arg1_3)
	if arg0_3.id == arg1_3 then
		return
	end

	arg0_3.id = arg1_3

	local var0_3 = pg.auction_collection[arg1_3]

	setScrollText(arg0_3.uiNameText, var0_3.name)
	setText(arg0_3.uiPriceText, StringHelper.ForamtNumber(var0_3.value))

	arg0_3.uiIconImage.sprite = nil

	setActive(arg0_3.uiIconImage, false)
	LoadSpriteAsync(var0_3.icon, function(arg0_4)
		if not IsNil(arg0_3.uiIconImage) then
			arg0_3.uiIconImage.sprite = arg0_4

			setActive(arg0_3.uiIconImage, true)
		end
	end)
	LoadSpriteAtlasAsync("ui/auctiongameui_atlas", string.format("rarity%s", var0_3.rarity), function(arg0_5)
		if not IsNil(arg0_3.uiRarityImage) then
			arg0_3.uiRarityImage.sprite = arg0_5
		end
	end)

	local var1_3 = var0_3.contour[1]
	local var2_3 = var0_3.contour[2]

	for iter0_3 = 1, 9 do
		local var3_3 = var2_3 >= math.ceil(iter0_3 / 3) and var1_3 >= (iter0_3 - 1) % 3 + 1

		setActive(arg0_3[string.format("uiContourItem%s", iter0_3)], var3_3)
	end
end

function var0_0.ShowLockState(arg0_6)
	local var0_6 = getProxy(AuctionGameBaseProxy):GetUnlockCollectionList()
	local var1_6 = table.keyof(var0_6, arg0_6.id) ~= nil

	setActive(arg0_6.uiLockGo, not var1_6)
end

function var0_0.willExit(arg0_7)
	arg0_7:detach()
end

return var0_0
