local var0_0 = class("FormationSuggestionShipItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.paintingDefaultAngle = arg0_2.uiPaintingTf.localEulerAngles
	arg0_2.UIlist = UIItemList.New(arg0_2.uiStartsTf, arg0_2.uiStartItem)

	setText(arg0_2.uiUnownedText, i18n("word_not_get"))
end

function var0_0.didEnter(arg0_3)
	return
end

function var0_0.SetData(arg0_4, arg1_4, arg2_4)
	arg0_4.id = arg1_4

	if arg0_4.shipVO then
		retPaintingPrefab(arg0_4.uiPaintingTf, arg0_4.shipVO:getPainting())
	end

	local var0_4 = pg.chapter_suggestion_char[arg0_4.id]
	local var1_4 = Ship.New({
		id = arg0_4.id,
		configId = var0_4.char_id,
		level = var0_4.char_lv
	})

	if var0_4.remoulded == 1 then
		var1_4.remoulded = true

		var1_4:updateSkinId(var1_4:getRemouldSkinId(), 0)
	end

	setScrollText(arg0_4.uiNameText, var1_4:GetColorName())
	setText(arg0_4.uiLevelText, string.format("Lv.%s", var1_4.level))

	local var2_4 = var1_4:getMaxStar()
	local var3_4 = var0_4.star

	arg0_4.UIlist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			setActive(arg2_5:Find("star"), arg1_5 < var3_4)
		end
	end)
	arg0_4.UIlist:align(var2_4)
	setPaintingPrefabAsync(arg0_4.uiPaintingTf, var1_4:getPainting(), "biandui", nil, {
		skinID = var1_4:getSkinId(),
		rotateZ = arg0_4.paintingDefaultAngle.z
	})

	local var4_4 = var1_4:rarity2bgPrint()

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var4_4, "", arg0_4.uiRaryImage)

	local var5_4, var6_4 = var1_4:GetFrameAndEffect(true)

	setRectShipCardFrame(arg0_4.uiFrameImage, var4_4, var5_4)
	setFrameEffect(arg0_4.uiEffectTf, var6_4)
	setProposeMarkIcon(arg0_4.uiProposeTf, var1_4)

	local var7_4 = var1_4:getShipType()

	setImageSprite(arg0_4.uiTypeImage, GetSpriteFromAtlas("shiptype", shipType2print(var7_4)))

	arg0_4.shipVO = var1_4

	setActive(arg0_4.uiFlagGo, arg2_4)

	local var8_4 = pg.ship_data_template[var0_4.char_id].group_type
	local var9_4 = getProxy(BayProxy):findShipsByGroup(var8_4)

	for iter0_4 = #var9_4, 1, -1 do
		if var0_4.remoulded == 1 and not var9_4[iter0_4]:isRemoulded() then
			table.remove(var9_4, iter0_4)
		end
	end

	local var10_4 = #var9_4 > 0

	setActive(arg0_4.uiUnownedGo, not var10_4)
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()

	local var0_6 = arg0_6.shipVO

	if var0_6 then
		retPaintingPrefab(arg0_6.uiPaintingTf, var0_6:getPainting())
	end
end

return var0_0
