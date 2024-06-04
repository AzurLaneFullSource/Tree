local var0 = class("FormationDetailCard")
local var1 = 0
local var2 = 1
local var3 = 2

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tr = arg1.transform
	arg0.lockTF = arg0.tr:Find("lock")
	arg0.addTF = arg0.tr:Find("add")
	arg0.content = arg0.tr:Find("content")
	arg0.bgImage = arg0.content:Find("bg"):GetComponent(typeof(Image))
	arg0.paintingTr = arg0.content:Find("ship_icon/painting")
	arg0.detailTF = arg0.content:Find("detail")
	arg0.lvTxtTF = arg0.detailTF:Find("top/level")
	arg0.lvTxt = arg0.lvTxtTF:GetComponent(typeof(Text))
	arg0.shipType = arg0.detailTF:Find("top/type")
	arg0.propsTr = arg0.detailTF:Find("info")
	arg0.propsTr1 = arg0.detailTF:Find("info1")
	arg0.nameTxt = arg0.detailTF:Find("name_mask/name")
	arg0.frame = arg0.content:Find("front/frame")
	arg0.UIlist = UIItemList.New(arg0.content:Find("front/stars"), arg0.content:Find("front/stars/star_tpl"))
	arg0.shipState = arg0.content:Find("front/flag")
	arg0.proposeMark = arg0.content:Find("front/propose")
	arg0.otherBg = arg0.content:Find("front/bg_other")

	setActive(arg0.propsTr1, false)
	setActive(arg0.shipState, false)
	setText(arg0.tr:Find("add/Text"), i18n("rect_ship_card_tpl_add"))
end

function var0.update(arg0, arg1, arg2)
	arg0.shipVO = arg1
	arg0.isLocked = arg2

	arg0:flush()
end

function var0.getState(arg0)
	if arg0.isLocked then
		return var1
	elseif arg0.shipVO then
		return var3
	elseif not arg0.isLocked and not arg0.shipVO then
		return var2
	end
end

function var0.flush(arg0)
	local var0 = arg0:getState()

	if arg0.otherBg then
		eachChild(arg0.otherBg, function(arg0)
			setActive(arg0, false)
		end)
	end

	if var0 == var1 then
		-- block empty
	elseif var0 == var3 then
		local var1 = arg0.shipVO

		arg0.lvTxt.text = "Lv." .. var1.level

		local var2 = var1:getMaxStar()
		local var3 = var1:getStar()

		arg0.UIlist:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				setActive(arg2:Find("star"), arg1 < var3)
			end
		end)
		arg0.UIlist:align(var2)
		setScrollText(arg0.nameTxt, var1:GetColorName())
		arg0:updateProps({})
		setPaintingPrefabAsync(arg0.paintingTr, var1:getPainting(), "biandui")

		local var4 = arg0.shipVO:rarity2bgPrint()

		GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var4, "", arg0.bgImage)

		local var5, var6 = var1:GetFrameAndEffect(true)

		setRectShipCardFrame(arg0.frame, var4, var5)
		setFrameEffect(arg0.otherBg, var6)
		setProposeMarkIcon(arg0.proposeMark, var1)

		local var7 = arg0.shipVO:getShipType()

		setImageSprite(arg0.shipType, GetSpriteFromAtlas("shiptype", shipType2print(var7)))
	elseif var0 == var2 then
		-- block empty
	end

	setActive(arg0.lockTF, var0 == var1)
	setActive(arg0.addTF, var0 == var2)
	setActive(arg0.content, var0 == var3)
end

function var0.updateProps(arg0, arg1)
	for iter0 = 0, 2 do
		local var0 = arg0.propsTr:GetChild(iter0)

		if iter0 < #arg1 then
			var0.gameObject:SetActive(true)

			var0:GetChild(0):GetComponent("Text").text = arg1[iter0 + 1][1]
			var0:GetChild(1):GetComponent("Text").text = arg1[iter0 + 1][2]
		else
			var0.gameObject:SetActive(false)
		end
	end
end

function var0.clear(arg0)
	local var0 = arg0.shipVO

	if var0 then
		retPaintingPrefab(arg0.paintingTr, var0:getPainting())
	end
end

return var0
