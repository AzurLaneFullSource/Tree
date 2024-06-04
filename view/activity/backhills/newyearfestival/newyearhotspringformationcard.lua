local var0 = class("FormationCard")
local var1 = 0
local var2 = 1
local var3 = 2

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tr = arg1.transform
	arg0.content = arg0.tr:Find("content")
	arg0.bgImage = arg0.content:Find("bg"):GetComponent(typeof(Image))
	arg0.paintingTr = arg0.content:Find("ship_icon/painting")
	arg0.detailTF = arg0.content:Find("detail")
	arg0.lvTxt = arg0.detailTF:Find("top/level"):GetComponent(typeof(Text))
	arg0.shipType = arg0.detailTF:Find("top/type")
	arg0.propsTr = arg0.detailTF:Find("info")
	arg0.propsTr1 = arg0.detailTF:Find("info1")
	arg0.nameTxt = arg0.detailTF:Find("name_mask/name")
	arg0.frame = arg0.content:Find("front/frame")
	arg0.UIlist = UIItemList.New(arg0.content:Find("front/stars"), arg0.content:Find("front/stars/star_tpl"))
	arg0.shipState = arg0.content:Find("front/flag")
	arg0.otherBg = arg0.content:Find("front/bg_other")

	setActive(arg0.propsTr1, false)
	setActive(arg0.shipState, false)

	arg0.loader = AutoLoader.New()
end

function var0.update(arg0, arg1)
	if arg1 then
		setActive(arg0.content, true)

		arg0.shipVO = arg1

		arg0:flush()
	else
		setActive(arg0.content, false)
	end
end

function var0.flush(arg0)
	local var0 = arg0.shipVO

	arg0.lvTxt.text = "Lv." .. var0.level

	local var1 = var0:getMaxStar()
	local var2 = var0:getStar()

	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("star"), arg1 < var2)
		end
	end)
	arg0.UIlist:align(var1)
	setScrollText(arg0.nameTxt, var0:getName())
	arg0:updateProps({})
	setPaintingPrefabAsync(arg0.paintingTr, var0:getPainting(), "biandui")

	local var3 = arg0.shipVO:rarity2bgPrint()

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var3, "", arg0.bgImage)

	local var4, var5 = var0:GetFrameAndEffect(true)

	setRectShipCardFrame(arg0.frame, var3, var4)
	setFrameEffect(arg0.otherBg, var5)
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

function var0.updateProps1(arg0, arg1)
	for iter0 = 0, 2 do
		local var0 = arg0.propsTr1:GetChild(iter0)

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

	arg0.loader:Clear()
end

return var0
