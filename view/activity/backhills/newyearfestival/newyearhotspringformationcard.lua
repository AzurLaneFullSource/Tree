local var0_0 = class("FormationCard")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.content = arg0_1.tr:Find("content")
	arg0_1.bgImage = arg0_1.content:Find("bg"):GetComponent(typeof(Image))
	arg0_1.paintingTr = arg0_1.content:Find("ship_icon/painting")
	arg0_1.detailTF = arg0_1.content:Find("detail")
	arg0_1.lvTxt = arg0_1.detailTF:Find("top/level"):GetComponent(typeof(Text))
	arg0_1.shipType = arg0_1.detailTF:Find("top/type")
	arg0_1.propsTr = arg0_1.detailTF:Find("info")
	arg0_1.propsTr1 = arg0_1.detailTF:Find("info1")
	arg0_1.nameTxt = arg0_1.detailTF:Find("name_mask/name")
	arg0_1.frame = arg0_1.content:Find("front/frame")
	arg0_1.UIlist = UIItemList.New(arg0_1.content:Find("front/stars"), arg0_1.content:Find("front/stars/star_tpl"))
	arg0_1.shipState = arg0_1.content:Find("front/flag")
	arg0_1.otherBg = arg0_1.content:Find("front/bg_other")

	setActive(arg0_1.propsTr1, false)
	setActive(arg0_1.shipState, false)

	arg0_1.loader = AutoLoader.New()
end

function var0_0.update(arg0_2, arg1_2)
	if arg1_2 then
		setActive(arg0_2.content, true)

		arg0_2.shipVO = arg1_2

		arg0_2:flush()
	else
		setActive(arg0_2.content, false)
	end
end

function var0_0.flush(arg0_3)
	local var0_3 = arg0_3.shipVO

	arg0_3.lvTxt.text = "Lv." .. var0_3.level

	local var1_3 = var0_3:getMaxStar()
	local var2_3 = var0_3:getStar()

	arg0_3.UIlist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			setActive(arg2_4:Find("star"), arg1_4 < var2_3)
		end
	end)
	arg0_3.UIlist:align(var1_3)
	setScrollText(arg0_3.nameTxt, var0_3:getName())
	arg0_3:updateProps({})
	setPaintingPrefabAsync(arg0_3.paintingTr, var0_3:getPainting(), "biandui")

	local var3_3 = arg0_3.shipVO:rarity2bgPrint()

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var3_3, "", arg0_3.bgImage)

	local var4_3, var5_3 = var0_3:GetFrameAndEffect(true)

	setRectShipCardFrame(arg0_3.frame, var3_3, var4_3)
	setFrameEffect(arg0_3.otherBg, var5_3)
end

function var0_0.updateProps(arg0_5, arg1_5)
	for iter0_5 = 0, 2 do
		local var0_5 = arg0_5.propsTr:GetChild(iter0_5)

		if iter0_5 < #arg1_5 then
			var0_5.gameObject:SetActive(true)

			var0_5:GetChild(0):GetComponent("Text").text = arg1_5[iter0_5 + 1][1]
			var0_5:GetChild(1):GetComponent("Text").text = arg1_5[iter0_5 + 1][2]
		else
			var0_5.gameObject:SetActive(false)
		end
	end
end

function var0_0.updateProps1(arg0_6, arg1_6)
	for iter0_6 = 0, 2 do
		local var0_6 = arg0_6.propsTr1:GetChild(iter0_6)

		if iter0_6 < #arg1_6 then
			var0_6.gameObject:SetActive(true)

			var0_6:GetChild(0):GetComponent("Text").text = arg1_6[iter0_6 + 1][1]
			var0_6:GetChild(1):GetComponent("Text").text = arg1_6[iter0_6 + 1][2]
		else
			var0_6.gameObject:SetActive(false)
		end
	end
end

function var0_0.clear(arg0_7)
	local var0_7 = arg0_7.shipVO

	if var0_7 then
		retPaintingPrefab(arg0_7.paintingTr, var0_7:getPainting())
	end

	arg0_7.loader:Clear()
end

return var0_0
