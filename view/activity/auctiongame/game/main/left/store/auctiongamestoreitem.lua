local var0_0 = class("AuctionGameStoreItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setActive(arg0_2.uiCoutourGo, false)
	setActive(arg0_2.uiRarityGo, false)
	setActive(arg0_2.uiIconImage, false)
	setActive(arg0_2.uiPosGo, false)
	onButton(arg0_2, arg0_2.uiBtn, function()
		if pg.NewGuideMgr.GetInstance():IsBusy() then
			return
		end

		arg0_2:OnClickItem()
	end, SFX_PANEL)

	arg0_2.contourList = UIItemList.New(arg0_2.uiContourParent, arg0_2.uiContourItem)

	arg0_2.contourList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			-- block empty
		end
	end)
end

function var0_0.didEnter(arg0_5, arg1_5)
	arg0_5:ShowSize(arg1_5)

	arg0_5._tf.name = arg1_5.uid

	if arg1_5.id and arg1_5.id ~= 0 then
		if arg0_5.data and arg0_5.data.id == arg1_5.id then
			return
		end

		setActive(arg0_5.uiIconImage, false)
		setActive(arg0_5.uiPosGo, false)
		arg0_5:HideContour()
		arg0_5:ShowRarity(arg1_5)

		local var0_5 = AuctionGameTools.GetRevealItemEffectName(arg1_5.id)

		PoolMgr.GetInstance():GetPrefab(var0_5, "", true, function(arg0_6)
			if not IsNil(arg0_5._go) then
				arg0_5.effectGo = arg0_6

				setParent(arg0_6, arg0_5._tf)
				setActive(arg0_6, true)

				local var0_6 = pg.auction_collection[arg1_5.id].icon

				LoadSpriteAsync(var0_6, function(arg0_7)
					if not IsNil(arg0_5.uiIconImage) then
						arg0_5.uiIconImage.sprite = arg0_7

						setActive(arg0_5.uiIconImage, true)
					end
				end)
				setActive(arg0_5._go, true)
			else
				PoolMgr.GetInstance():ReturnPrefab(var0_5, "", arg0_6, true)
			end
		end)
	else
		setActive(arg0_5.uiPosGo, false)

		if arg1_5.showRarity then
			arg0_5:ShowRarity(arg1_5)
			arg0_5:HideContour()
		elseif arg1_5.showContour then
			arg0_5:ShowContour(arg1_5)
		end

		if not arg1_5.showContour and not arg1_5.showRarity and arg1_5.showPos then
			setActive(arg0_5.uiPosGo, true)
		end

		setActive(arg0_5._go, true)
	end

	arg0_5.data = arg1_5
end

function var0_0.OnClickItem(arg0_8)
	local var0_8 = arg0_8.data

	if var0_8 == nil then
		return
	end

	if var0_8.id and var0_8.id ~= 0 then
		arg0_8:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameCollectionInfoLayer,
			mediator = AuctionGameCollectionInfoMediator,
			data = {
				id = var0_8.id
			}
		}))
	else
		local var1_8

		if var0_8.showContour then
			var1_8 = var0_8.contour
		end

		arg0_8:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameCollectionListLayer,
			mediator = AuctionGameCollectionListMediator,
			data = {
				rarityIndex = var0_8.rarity,
				contour = var1_8
			}
		}))
	end
end

function var0_0.ShowSize(arg0_9, arg1_9)
	if arg1_9.contour then
		arg0_9.uiItemTf.sizeDelta = Vector2(arg1_9.contour[1] * AuctionGameConst.CELL_WIDTH, arg1_9.contour[2] * AuctionGameConst.CELL_HEIGHT)
	end
end

function var0_0.ShowRarity(arg0_10, arg1_10)
	setActive(arg0_10.uiRarityGo, true)

	if arg1_10.showContour then
		setActive(arg0_10.uiRarityImage, true)
		setActive(arg0_10.uiRarityContourImage, false)
		LoadSpriteAtlasAsync("ui/auctiongameui_atlas", string.format("main_cell_item_rarity_%s", arg1_10.rarity), function(arg0_11)
			if not IsNil(arg0_10.uiRarityImage) then
				arg0_10.uiRarityImage.sprite = arg0_11
			end
		end)
	else
		setActive(arg0_10.uiRarityImage, false)
		setActive(arg0_10.uiRarityContourImage, true)
		LoadSpriteAtlasAsync("ui/auctiongameui_atlas", string.format("main_cell_item_contour_rarity_%s", arg1_10.rarity), function(arg0_12)
			if not IsNil(arg0_10.uiRarityContourImage) then
				arg0_10.uiRarityContourImage.sprite = arg0_12
			end
		end)
	end

	LoadSpriteAtlasAsync("ui/auctiongameui_atlas", string.format("main_cell_item_frame_rarity_%s", arg1_10.rarity), function(arg0_13)
		if not IsNil(arg0_10.uiRarityFrameImage) then
			arg0_10.uiRarityFrameImage.sprite = arg0_13
		end
	end)
end

function var0_0.ShowContour(arg0_14, arg1_14)
	setActive(arg0_14.uiCoutourGo, true)
	arg0_14.contourList:align(arg1_14.contour[1] * arg1_14.contour[2])
end

function var0_0.HideContour(arg0_15)
	setActive(arg0_15.uiCoutourGo, false)
end

function var0_0.SetPosition(arg0_16, arg1_16)
	arg0_16.uiItemTf.localPosition = arg1_16
end

function var0_0.willExit(arg0_17)
	arg0_17:detach()

	if arg0_17.effectGo then
		PoolMgr.GetInstance():ReturnPrefab(AuctionGameTools.GetRevealItemEffectName(arg0_17.data.id), "", arg0_17.effectGo, true)
	end

	Object.Destroy(arg0_17._go)
end

return var0_0
