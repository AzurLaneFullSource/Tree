local var0 = class("SnapshotShipCard")

var0.TypeCard = 1
var0.TypeTrans = 2

local var1 = pg.ship_data_group

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tr = arg1.transform
	arg0.btn = GetOrAddComponent(arg1, "Button")
	arg0.content = findTF(arg0.tr, "content").gameObject

	setActive(findTF(arg0.content, "dockyard"), false)
	setActive(findTF(arg0.content, "collection"), true)

	arg0.shipFrameImg = findTF(arg0.content, "front/frame")
	arg0.iconShip = findTF(arg0.content, "ship_icon"):GetComponent(typeof(Image))
	arg0.imageBg = findTF(arg0.content, "bg"):GetComponent(typeof(Image))
	arg0.labelName = findTF(arg0.content, "info/name_mask/name")
	arg0.iconType = findTF(arg0.content, "info/top/type"):GetComponent(typeof(Image))
	arg0.ringTF = findTF(arg0.content, "front/ring")
	arg0.maskTF = findTF(arg0.content, "collection/mask")
	arg0.heart = findTF(arg0.content, "collection/heart")
	arg0.labelHeart = findTF(arg0.heart, "heart"):GetComponent(typeof(Text))
	arg0.labelHeartIcon = findTF(arg0.heart, "icon"):GetComponent(typeof(Image))
	arg0.labelHeartPlus = findTF(arg0.heart, "heart+"):GetComponent(typeof(Text))
	arg0.imageUnknown = findTF(arg0.tr, "unknown"):GetComponent(typeof(Image))

	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.update(arg0, arg1, arg2, arg3, arg4, arg5)
	TweenItemAlphaAndWhite(arg0.go)

	local var0 = ShipGroup.getState(arg5, arg2, arg3)

	if arg0.code ~= arg1 or arg0.shipGroup ~= arg2 or arg0.showTrans ~= arg3 or arg0.propose ~= arg4 or arg0.state ~= var0 then
		arg0.code = arg1
		arg0.shipGroup = arg2
		arg0.showTrans = arg3
		arg0.propose = arg4
		arg0.state = var0
		arg0.config = var1[arg5]

		arg0:flush()
	end
end

function var0.flush(arg0)
	local var0 = arg0.shipGroup

	if var0 then
		local var1 = var0:rarity2bgPrint(arg0.showTrans)
		local var2 = var0:getPainting(arg0.showTrans)

		GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var1, "", arg0.imageBg)

		arg0.iconShip.sprite = GetSpriteFromAtlas("shipYardIcon/unknown", "")

		LoadSpriteAsync("shipYardIcon/" .. var2, function(arg0)
			if arg0.go then
				arg0.iconShip.sprite = arg0
			end
		end)

		arg0.iconType.sprite = GetSpriteFromAtlas("shiptype", shipType2print(var0:getShipType(arg0.showTrans)))

		setScrollText(arg0.labelName, var0:getName(arg0.showTrans))

		arg0.labelHeart.text = var0.hearts > 999 and "999" or tostring(var0.hearts)

		setActive(arg0.labelHeartPlus, var0.hearts > 999)

		arg0.labelHeart.color = var0.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)
		arg0.labelHeartIcon.color = var0.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)
		arg0.labelHeartPlus.color = var0.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

		setShipCardFrame(arg0.shipFrameImg, var1)
	end

	arg0.content:SetActive(tobool(var0))
	arg0.imageUnknown.gameObject:SetActive(not var0)

	arg0.btn.targetGraphic = var0 and arg0.imageFrame or arg0.imageUnknown

	setActive(arg0.ringTF, arg0.propose)
end

function var0.clear(arg0)
	ClearTweenItemAlphaAndWhite(arg0.go)

	arg0.shipGroup = nil
	arg0.showTrans = nil
	arg0.propose = nil
	arg0.code = nil
end

return var0
