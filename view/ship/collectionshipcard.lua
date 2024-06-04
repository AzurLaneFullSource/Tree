local var0 = class("CollectionShipCard")

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
	setActive(findTF(arg0.content, "expbuff"), false)

	arg0.shipFrameImg = findTF(arg0.content, "front/frame")
	arg0.iconShip = findTF(arg0.content, "ship_icon"):GetComponent(typeof(Image))
	arg0.imageBg = findTF(arg0.content, "bg"):GetComponent(typeof(Image))
	arg0.labelName = findTF(arg0.content, "info/name_mask/name")
	arg0.mask2D = GetOrAddComponent(findTF(arg0.content, "info/name_mask"), typeof(RectMask2D))
	arg0.iconType = findTF(arg0.content, "info/top/type"):GetComponent(typeof(Image))
	arg0.ringTF = findTF(arg0.content, "front/ring")
	arg0.ringMetaTF = findTF(arg0.content, "front/ring_meta")
	arg0.maskTF = findTF(arg0.content, "collection/mask")
	arg0.heart = findTF(arg0.content, "collection/heart")
	arg0.labelHeart = findTF(arg0.heart, "heart"):GetComponent(typeof(Text))
	arg0.labelHeartIcon = findTF(arg0.heart, "icon"):GetComponent(typeof(Image))
	arg0.labelHeartPlus = findTF(arg0.heart, "heart+"):GetComponent(typeof(Text))
	arg0.imageUnknown = findTF(arg0.tr, "unknown"):GetComponent(typeof(Image))

	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.getIsInited(arg0)
	return arg0.shipGroup ~= nil
end

function var0.update(arg0, arg1, arg2, arg3, arg4, arg5)
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

	TweenItemAlphaAndWhite(arg0.go)
end

function var0.flush(arg0)
	local var0 = arg0.shipGroup

	setActive(arg0.heart, arg0.state == ShipGroup.STATE_UNLOCK)

	if arg0.state == ShipGroup.STATE_UNLOCK then
		arg0.labelHeart.text = var0.hearts > 999 and "999" or tostring(var0.hearts)

		setActive(arg0.labelHeartPlus, var0.hearts > 999)

		arg0.labelHeart.color = var0.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)
		arg0.labelHeartIcon.color = var0.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)
		arg0.labelHeartPlus.color = var0.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

		arg0:loadImage(arg0.shipGroup, true)
	elseif arg0.state == ShipGroup.STATE_NOTGET then
		arg0.shipGroup = ShipGroup.New({
			id = arg0.config.group_type
		})
		arg0.shipGroup.trans = true

		if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
			arg0:loadImage(arg0.shipGroup, false)
		else
			arg0:loadImage(arg0.shipGroup, true)
		end
	elseif arg0.state == ShipGroup.STATE_LOCK then
		-- block empty
	end

	setActive(arg0.content, arg0.state == ShipGroup.STATE_NOTGET or arg0.state == ShipGroup.STATE_UNLOCK)
	setActive(arg0.imageUnknown, arg0.state == ShipGroup.STATE_LOCK)
	setActive(arg0.maskTF, arg0.state == ShipGroup.STATE_NOTGET)

	if var0 then
		local var1 = var0:isMetaGroup()

		setActive(arg0.ringTF, arg0.propose and not var1)
		setActive(arg0.ringMetaTF, arg0.propose and var1)
	else
		setActive(arg0.ringTF, false)
		setActive(arg0.ringMetaTF, false)
	end

	if not arg0.mask2D.enabled then
		arg0.mask2D.enabled = true
	end

	setActive(arg0.labelName, false)
	setActive(arg0.labelName, true)
end

function var0.loadImage(arg0, arg1, arg2)
	local var0 = arg1:rarity2bgPrint(arg0.showTrans)
	local var1 = arg2 and arg1:getPainting(arg0.showTrans) or "unknown"

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0, "", arg0.imageBg)

	arg0.loadingPaintingName = var1

	GetSpriteFromAtlasAsync("shipYardIcon/" .. var1, "", function(arg0)
		if not IsNil(arg0.go) and arg0.loadingPaintingName == var1 then
			arg0.iconShip.sprite = arg0
		end
	end)

	arg0.iconType.sprite = GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType(arg0.showTrans)))

	setScrollText(arg0.labelName, arg1:getName(arg0.showTrans))
	setShipCardFrame(arg0.shipFrameImg, var0)
end

function var0.clear(arg0)
	arg0.shipGroup = nil
	arg0.showTrans = nil
	arg0.propose = nil
	arg0.code = nil

	ClearTweenItemAlphaAndWhite(arg0.go)
end

return var0
