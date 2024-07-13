local var0_0 = class("FormationDetailCard")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.lockTF = arg0_1.tr:Find("lock")
	arg0_1.addTF = arg0_1.tr:Find("add")
	arg0_1.content = arg0_1.tr:Find("content")
	arg0_1.bgImage = arg0_1.content:Find("bg"):GetComponent(typeof(Image))
	arg0_1.paintingTr = arg0_1.content:Find("ship_icon/painting")
	arg0_1.detailTF = arg0_1.content:Find("detail")
	arg0_1.lvTxtTF = arg0_1.detailTF:Find("top/level")
	arg0_1.lvTxt = arg0_1.lvTxtTF:GetComponent(typeof(Text))
	arg0_1.shipType = arg0_1.detailTF:Find("top/type")
	arg0_1.propsTr = arg0_1.detailTF:Find("info")
	arg0_1.propsTr1 = arg0_1.detailTF:Find("info1")
	arg0_1.nameTxt = arg0_1.detailTF:Find("name_mask/name")
	arg0_1.frame = arg0_1.content:Find("front/frame")
	arg0_1.UIlist = UIItemList.New(arg0_1.content:Find("front/stars"), arg0_1.content:Find("front/stars/star_tpl"))
	arg0_1.shipState = arg0_1.content:Find("front/flag")
	arg0_1.proposeMark = arg0_1.content:Find("front/propose")
	arg0_1.otherBg = arg0_1.content:Find("front/bg_other")

	setActive(arg0_1.propsTr1, false)
	setActive(arg0_1.shipState, false)
	setText(arg0_1.tr:Find("add/Text"), i18n("rect_ship_card_tpl_add"))
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	arg0_2.shipVO = arg1_2
	arg0_2.isLocked = arg2_2

	arg0_2:flush()
end

function var0_0.getState(arg0_3)
	if arg0_3.isLocked then
		return var1_0
	elseif arg0_3.shipVO then
		return var3_0
	elseif not arg0_3.isLocked and not arg0_3.shipVO then
		return var2_0
	end
end

function var0_0.flush(arg0_4)
	local var0_4 = arg0_4:getState()

	if arg0_4.otherBg then
		eachChild(arg0_4.otherBg, function(arg0_5)
			setActive(arg0_5, false)
		end)
	end

	if var0_4 == var1_0 then
		-- block empty
	elseif var0_4 == var3_0 then
		local var1_4 = arg0_4.shipVO

		arg0_4.lvTxt.text = "Lv." .. var1_4.level

		local var2_4 = var1_4:getMaxStar()
		local var3_4 = var1_4:getStar()

		arg0_4.UIlist:make(function(arg0_6, arg1_6, arg2_6)
			if arg0_6 == UIItemList.EventUpdate then
				setActive(arg2_6:Find("star"), arg1_6 < var3_4)
			end
		end)
		arg0_4.UIlist:align(var2_4)
		setScrollText(arg0_4.nameTxt, var1_4:GetColorName())
		arg0_4:updateProps({})
		setPaintingPrefabAsync(arg0_4.paintingTr, var1_4:getPainting(), "biandui")

		local var4_4 = arg0_4.shipVO:rarity2bgPrint()

		GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var4_4, "", arg0_4.bgImage)

		local var5_4, var6_4 = var1_4:GetFrameAndEffect(true)

		setRectShipCardFrame(arg0_4.frame, var4_4, var5_4)
		setFrameEffect(arg0_4.otherBg, var6_4)
		setProposeMarkIcon(arg0_4.proposeMark, var1_4)

		local var7_4 = arg0_4.shipVO:getShipType()

		setImageSprite(arg0_4.shipType, GetSpriteFromAtlas("shiptype", shipType2print(var7_4)))
	elseif var0_4 == var2_0 then
		-- block empty
	end

	setActive(arg0_4.lockTF, var0_4 == var1_0)
	setActive(arg0_4.addTF, var0_4 == var2_0)
	setActive(arg0_4.content, var0_4 == var3_0)
end

function var0_0.updateProps(arg0_7, arg1_7)
	for iter0_7 = 0, 2 do
		local var0_7 = arg0_7.propsTr:GetChild(iter0_7)

		if iter0_7 < #arg1_7 then
			var0_7.gameObject:SetActive(true)

			var0_7:GetChild(0):GetComponent("Text").text = arg1_7[iter0_7 + 1][1]
			var0_7:GetChild(1):GetComponent("Text").text = arg1_7[iter0_7 + 1][2]
		else
			var0_7.gameObject:SetActive(false)
		end
	end
end

function var0_0.clear(arg0_8)
	local var0_8 = arg0_8.shipVO

	if var0_8 then
		retPaintingPrefab(arg0_8.paintingTr, var0_8:getPainting())
	end
end

return var0_0
