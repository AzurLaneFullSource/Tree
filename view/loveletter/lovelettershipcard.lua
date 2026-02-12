local var0_0 = class("LoveLetterShipCard")
local var1_0 = pg.ship_data_group

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.btn = GetOrAddComponent(arg1_1, "Button")
	arg0_1.content = findTF(arg0_1.tr, "content").gameObject

	setActive(findTF(arg0_1.content, "dockyard"), false)

	arg0_1.shipFrameImg = findTF(arg0_1.content, "front/frame")
	arg0_1.iconShip = findTF(arg0_1.content, "ship_icon"):GetComponent(typeof(Image))
	arg0_1.imageBg = findTF(arg0_1.content, "bg"):GetComponent(typeof(Image))
	arg0_1.labelName = findTF(arg0_1.content, "info/name_mask/name")
	arg0_1.iconType = findTF(arg0_1.content, "info/top/type"):GetComponent(typeof(Image))
	arg0_1.ringTF = findTF(arg0_1.content, "front/ring")
	arg0_1.maskTF = findTF(arg0_1.content, "collection/mask")
	arg0_1.imageUnknown = findTF(arg0_1.tr, "unknown"):GetComponent(typeof(Image))

	ClearTweenItemAlphaAndWhite(arg0_1.go)
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	TweenItemAlphaAndWhite(arg0_2.go)

	local var0_2 = ShipGroup.getState(arg4_2, arg1_2, arg2_2)

	if arg0_2.shipGroup ~= arg1_2 or arg0_2.showTrans ~= arg2_2 or arg0_2.propose ~= arg3_2 or arg0_2.state ~= var0_2 then
		arg0_2.shipGroup = arg1_2
		arg0_2.showTrans = arg2_2
		arg0_2.propose = arg3_2
		arg0_2.state = var0_2

		arg0_2:flush()
	end
end

function var0_0.flush(arg0_3)
	local var0_3 = arg0_3.shipGroup

	if var0_3 then
		local var1_3 = var0_3:rarity2bgPrint(arg0_3.showTrans)
		local var2_3 = var0_3:getPainting(arg0_3.showTrans)

		GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var1_3, "", arg0_3.imageBg)

		arg0_3.iconShip.sprite = GetSpriteFromAtlas("shipYardIcon/unknown", "")

		LoadSpriteAsync("shipYardIcon/" .. var2_3, function(arg0_4)
			if arg0_3.iconShip then
				arg0_3.iconShip.sprite = arg0_4
			end
		end)

		arg0_3.iconType.sprite = GetSpriteFromAtlas("shiptype", shipType2print(var0_3:getShipType(arg0_3.showTrans)))

		setScrollText(arg0_3.labelName, var0_3:getName(arg0_3.showTrans))
		setShipCardFrame(arg0_3.shipFrameImg, var1_3)

		local var3_3 = arg0_3.content.transform:Find("love_letter")
		local var4_3 = getProxy(LoveLetterProxy):GetGroupData(var0_3.id)

		setActive(var3_3, var4_3.exp > 0)

		if var4_3.exp > 0 then
			local var5_3, var6_3 = var4_3:GetDisplayExp()

			if var6_3 == 0 then
				setSlider(var3_3, 0, 1, 1)
			else
				setSlider(var3_3, 0, var6_3, var5_3)
			end

			setText(var3_3:Find("mark/Text"), var4_3:GetDisplayLevelMark())

			local var7_3 = var4_3:GetDisplayRank()

			eachChild(var3_3:Find("mark/bg"), function(arg0_5, arg1_5)
				setActive(arg0_5, arg1_5 == var7_3)
			end)
		end
	end

	arg0_3.content:SetActive(tobool(var0_3))
	arg0_3.imageUnknown.gameObject:SetActive(not var0_3)

	arg0_3.btn.targetGraphic = var0_3 and arg0_3.imageFrame or arg0_3.imageUnknown

	setActive(arg0_3.ringTF, arg0_3.propose)
end

function var0_0.clear(arg0_6)
	ClearTweenItemAlphaAndWhite(arg0_6.go)

	arg0_6.shipGroup = nil
	arg0_6.showTrans = nil
	arg0_6.propose = nil
end

return var0_0
