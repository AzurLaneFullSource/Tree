local var0_0 = class("CollectionShipCard")

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
	setActive(findTF(arg0_1.content, "expbuff"), false)

	arg0_1.shipFrameImg = findTF(arg0_1.content, "front/frame")
	arg0_1.iconShip = findTF(arg0_1.content, "ship_icon"):GetComponent(typeof(Image))
	arg0_1.imageBg = findTF(arg0_1.content, "bg"):GetComponent(typeof(Image))
	arg0_1.labelName = findTF(arg0_1.content, "info/name_mask/name")
	arg0_1.mask2D = GetOrAddComponent(findTF(arg0_1.content, "info/name_mask"), typeof(RectMask2D))
	arg0_1.iconType = findTF(arg0_1.content, "info/top/type"):GetComponent(typeof(Image))
	arg0_1.ringTF = findTF(arg0_1.content, "front/ring")
	arg0_1.ringMetaTF = findTF(arg0_1.content, "front/ring_meta")
	arg0_1.maskTF = findTF(arg0_1.content, "collection/mask")
	arg0_1.heart = findTF(arg0_1.content, "collection/heart")
	arg0_1.labelHeart = findTF(arg0_1.heart, "heart"):GetComponent(typeof(Text))
	arg0_1.labelHeartIcon = findTF(arg0_1.heart, "icon"):GetComponent(typeof(Image))
	arg0_1.labelHeartPlus = findTF(arg0_1.heart, "heart+"):GetComponent(typeof(Text))
	arg0_1.imageUnknown = findTF(arg0_1.tr, "unknown"):GetComponent(typeof(Image))

	ClearTweenItemAlphaAndWhite(arg0_1.go)
end

function var0_0.getIsInited(arg0_2)
	return arg0_2.shipGroup ~= nil
end

function var0_0.update(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	local var0_3 = ShipGroup.getState(arg5_3, arg2_3, arg3_3)

	if arg0_3.code ~= arg1_3 or arg0_3.shipGroup ~= arg2_3 or arg0_3.showTrans ~= arg3_3 or arg0_3.propose ~= arg4_3 or arg0_3.state ~= var0_3 then
		arg0_3.code = arg1_3
		arg0_3.shipGroup = arg2_3
		arg0_3.showTrans = arg3_3
		arg0_3.propose = arg4_3
		arg0_3.state = var0_3
		arg0_3.config = var1_0[arg5_3]

		arg0_3:flush()
	end

	TweenItemAlphaAndWhite(arg0_3.go)
end

function var0_0.flush(arg0_4)
	local var0_4 = arg0_4.shipGroup

	setActive(arg0_4.heart, arg0_4.state == ShipGroup.STATE_UNLOCK)

	if arg0_4.state == ShipGroup.STATE_UNLOCK then
		arg0_4.labelHeart.text = var0_4.hearts > 999 and "999" or tostring(var0_4.hearts)

		setActive(arg0_4.labelHeartPlus, var0_4.hearts > 999)

		arg0_4.labelHeart.color = var0_4.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)
		arg0_4.labelHeartIcon.color = var0_4.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)
		arg0_4.labelHeartPlus.color = var0_4.iheart and Color.New(1, 0.6, 0.6) or Color.New(1, 1, 1)

		arg0_4:loadImage(arg0_4.shipGroup, true)
	elseif arg0_4.state == ShipGroup.STATE_NOTGET then
		arg0_4.shipGroup = ShipGroup.New({
			id = arg0_4.config.group_type
		})
		arg0_4.shipGroup.trans = true

		if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
			arg0_4:loadImage(arg0_4.shipGroup, false)
		else
			arg0_4:loadImage(arg0_4.shipGroup, true)
		end
	elseif arg0_4.state == ShipGroup.STATE_LOCK then
		-- block empty
	end

	setActive(arg0_4.content, arg0_4.state == ShipGroup.STATE_NOTGET or arg0_4.state == ShipGroup.STATE_UNLOCK)
	setActive(arg0_4.imageUnknown, arg0_4.state == ShipGroup.STATE_LOCK)
	setActive(arg0_4.maskTF, arg0_4.state == ShipGroup.STATE_NOTGET)

	if var0_4 then
		local var1_4 = var0_4:isMetaGroup()

		setActive(arg0_4.ringTF, arg0_4.propose and not var1_4)
		setActive(arg0_4.ringMetaTF, arg0_4.propose and var1_4)
	else
		setActive(arg0_4.ringTF, false)
		setActive(arg0_4.ringMetaTF, false)
	end

	if not arg0_4.mask2D.enabled then
		arg0_4.mask2D.enabled = true
	end

	setActive(arg0_4.labelName, false)
	setActive(arg0_4.labelName, true)
end

function var0_0.loadImage(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:rarity2bgPrint(arg0_5.showTrans)
	local var1_5 = arg2_5 and arg1_5:getPainting(arg0_5.showTrans) or "unknown"

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_5, "", arg0_5.imageBg)

	arg0_5.loadingPaintingName = var1_5

	GetSpriteFromAtlasAsync("shipYardIcon/" .. var1_5, "", function(arg0_6)
		if not IsNil(arg0_5.go) and arg0_5.loadingPaintingName == var1_5 then
			arg0_5.iconShip.sprite = arg0_6
		end
	end)

	arg0_5.iconType.sprite = GetSpriteFromAtlas("shiptype", shipType2print(arg1_5:getShipType(arg0_5.showTrans)))

	setScrollText(arg0_5.labelName, arg1_5:getName(arg0_5.showTrans))
	setShipCardFrame(arg0_5.shipFrameImg, var0_5)
end

function var0_0.clear(arg0_7)
	arg0_7.shipGroup = nil
	arg0_7.showTrans = nil
	arg0_7.propose = nil
	arg0_7.code = nil

	ClearTweenItemAlphaAndWhite(arg0_7.go)
end

return var0_0
