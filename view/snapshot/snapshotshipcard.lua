local var0_0 = class("SnapshotShipCard")

var0_0.TypeCard = 1
var0_0.TypeTrans = 2

local var1_0 = pg.ship_data_group

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.btn = GetOrAddComponent(arg1_1, "Button")
	arg0_1.content = findTF(arg0_1.tr, "content").gameObject

	setActive(findTF(arg0_1.content, "dockyard"), false)
	setActive(findTF(arg0_1.content, "collection"), true)

	arg0_1.shipFrameImg = findTF(arg0_1.content, "front/frame")
	arg0_1.iconShip = findTF(arg0_1.content, "ship_icon"):GetComponent(typeof(Image))
	arg0_1.imageBg = findTF(arg0_1.content, "bg"):GetComponent(typeof(Image))
	arg0_1.labelName = findTF(arg0_1.content, "info/name_mask/name")
	arg0_1.iconType = findTF(arg0_1.content, "info/top/type"):GetComponent(typeof(Image))
	arg0_1.ringTF = findTF(arg0_1.content, "front/ring")
	arg0_1.maskTF = findTF(arg0_1.content, "collection/mask")
	arg0_1.heart = findTF(arg0_1.content, "collection/heart")
	arg0_1.labelHeart = findTF(arg0_1.heart, "heart"):GetComponent(typeof(Text))
	arg0_1.labelHeartIcon = findTF(arg0_1.heart, "icon"):GetComponent(typeof(Image))
	arg0_1.labelHeartPlus = findTF(arg0_1.heart, "heart+"):GetComponent(typeof(Text))
	arg0_1.imageUnknown = findTF(arg0_1.tr, "unknown"):GetComponent(typeof(Image))

	ClearTweenItemAlphaAndWhite(arg0_1.go)
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2)
	TweenItemAlphaAndWhite(arg0_2.go)

	local var0_2 = ShipGroup.getState(arg5_2, arg2_2, arg3_2)

	if arg0_2.code ~= arg1_2 or arg0_2.shipGroup ~= arg2_2 or arg0_2.showTrans ~= arg3_2 or arg0_2.propose ~= arg4_2 or arg0_2.state ~= var0_2 then
		arg0_2.code = arg1_2
		arg0_2.shipGroup = arg2_2
		arg0_2.showTrans = arg3_2
		arg0_2.propose = arg4_2
		arg0_2.state = var0_2
		arg0_2.config = var1_0[arg5_2]

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
			if arg0_3.go then
				arg0_3.iconShip.sprite = arg0_4
			end
		end)

		arg0_3.iconType.sprite = GetSpriteFromAtlas("shiptype", shipType2print(var0_3:getShipType(arg0_3.showTrans)))

		setScrollText(arg0_3.labelName, var0_3:getName(arg0_3.showTrans))

		arg0_3.labelHeart.text = var0_3.hearts > 999 and "999" or tostring(var0_3.hearts)

		setActive(arg0_3.labelHeartPlus, var0_3.hearts > 999)

		arg0_3.labelHeart.color = var0_3.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)
		arg0_3.labelHeartIcon.color = var0_3.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)
		arg0_3.labelHeartPlus.color = var0_3.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

		setShipCardFrame(arg0_3.shipFrameImg, var1_3)
	end

	arg0_3.content:SetActive(tobool(var0_3))
	arg0_3.imageUnknown.gameObject:SetActive(not var0_3)

	arg0_3.btn.targetGraphic = var0_3 and arg0_3.imageFrame or arg0_3.imageUnknown

	setActive(arg0_3.ringTF, arg0_3.propose)
end

function var0_0.clear(arg0_5)
	ClearTweenItemAlphaAndWhite(arg0_5.go)

	arg0_5.shipGroup = nil
	arg0_5.showTrans = nil
	arg0_5.propose = nil
	arg0_5.code = nil
end

return var0_0
