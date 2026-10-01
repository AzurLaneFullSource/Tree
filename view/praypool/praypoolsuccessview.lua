local var0_0 = class("PrayPoolSuccessView", import("..base.BaseSubView"))

function var0_0.getResource(arg0_1)
	local var0_1 = {}
	local var1_1 = getProxy(PrayProxy)

	for iter0_1, iter1_1 in ipairs(var1_1:getSelectedShipIDList() or {}) do
		table.insertto(var0_1, ResPathSupport.GetPaintingListByPaintingName(Ship.getPaintingName(iter1_1)))
	end

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1))
end

function var0_0.getUIName(arg0_2)
	return "PrayPoolSuccessView"
end

function var0_0.OnInit(arg0_3)
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:updateUI()
	arg0_3:Show()
end

function var0_0.OnDestroy(arg0_4)
	arg0_4.buildMsgBox:hide()
end

function var0_0.OnBackPress(arg0_5)
	if arg0_5:GetLoaded() and isActive(arg0_5.boxTF) then
		arg0_5.buildMsgBox:hide()

		return true
	end
end

function var0_0.initData(arg0_6)
	arg0_6.prayProxy = getProxy(PrayProxy)
	arg0_6.poolType = arg0_6.prayProxy:getSelectedPoolType()
	arg0_6.playerProxy = getProxy(PlayerProxy)
	arg0_6.bagProxy = getProxy(BagProxy)
	arg0_6.useItem = pg.ship_data_create_material[1].use_item

	print("useitem " .. arg0_6.useItem)

	arg0_6.buildShipProxy = getProxy(BuildShipProxy)
end

function var0_0.initUI(arg0_7)
	arg0_7.shipTF = {
		arg0_7._tf:Find("Ship1"),
		(arg0_7._tf:Find("Ship2"))
	}
	arg0_7.shipRarityTF = {
		arg0_7._tf:Find("Rarity1"),
		(arg0_7._tf:Find("Rarity2"))
	}
	arg0_7.boxTF = arg0_7._tf:Find("build_msg")
	arg0_7.buildMsgBox = var0_0.MsgBox(arg0_7.boxTF)
	arg0_7.buildBtn = arg0_7._tf:Find("BuildBtn")
	arg0_7.buildCubeNumText = arg0_7._tf:Find("BuildInfo/CubeNum")
	arg0_7.buildGoldNumText = arg0_7._tf:Find("BuildInfo/GoldNum")
	arg0_7.curCubeNumText = arg0_7._tf:Find("CubeImg/NumText")
	arg0_7.material1 = arg0_7._tf:Find("material1")
	arg0_7.material2 = arg0_7._tf:Find("material2")
	arg0_7.ratioSpriteMap = {}

	local var0_7 = arg0_7._tf:Find("Ratio")

	for iter0_7 = 2, 6 do
		local var1_7 = getImageSprite(var0_7:Find(tostring(iter0_7)))

		arg0_7.ratioSpriteMap[iter0_7] = var1_7
	end

	arg0_7.raritySpriteMap = {
		Normal = {
			Light1 = getImageSprite(arg0_7._tf:Find("Light/Normal/Light1")),
			Light2 = getImageSprite(arg0_7._tf:Find("Light/Normal/Light2")),
			Light2_2 = getImageSprite(arg0_7._tf:Find("Light/Normal/Light2_2")),
			Light3 = getImageSprite(arg0_7._tf:Find("Light/Normal/Light3")),
			RarityBG = getImageSprite(arg0_7._tf:Find("RarityBG/Normal"))
		},
		UR = {
			Light1 = getImageSprite(arg0_7._tf:Find("Light/UR/Light1")),
			Light2 = getImageSprite(arg0_7._tf:Find("Light/UR/Light2")),
			Light2_2 = getImageSprite(arg0_7._tf:Find("Light/UR/Light2_2")),
			Light3 = getImageSprite(arg0_7._tf:Find("Light/UR/Light3")),
			RarityBG = getImageSprite(arg0_7._tf:Find("RarityBG/UR"))
		}
	}

	onButton(arg0_7, arg0_7.buildBtn, function()
		local var0_8 = pg.ship_data_create_material[pg.activity_ship_create[arg0_7.poolType].create_id]
		local var1_8 = arg0_7.playerProxy:getData()
		local var2_8 = arg0_7.bagProxy:getItemCountById(arg0_7.useItem)
		local var3_8 = arg0_7.buildShipProxy:getRawData()
		local var4_8 = table.getCount(var3_8)
		local var5_8 = _.min({
			math.floor(var1_8.gold / var0_8.use_gold),
			math.floor(var2_8 / var0_8.number_1),
			MAX_BUILD_WORK_COUNT - var4_8
		})
		local var6_8 = math.max(1, var5_8)

		local function var7_8(arg0_9)
			if arg0_9 > var6_8 or var1_8.gold < arg0_9 * var0_8.use_gold or var2_8 < arg0_9 * var0_8.number_1 then
				return false
			end

			return true
		end

		arg0_7.buildMsgBox:show(var6_8, var7_8, function(arg0_10)
			arg0_7:emit(PrayPoolConst.START_BUILD_SHIP_EVENT, var0_8.id, arg0_10, 0)
		end, function(arg0_11)
			local var0_11 = arg0_11 * var0_8.use_gold
			local var1_11 = arg0_11 * var0_8.number_1
			local var2_11 = var7_8(arg0_11) and COLOR_GREEN or COLOR_RED

			return i18n("build_ship_tip", arg0_11, var0_8.name, var0_11, var1_11, var2_11)
		end)
	end, SFX_UI_BUILDING_STARTBUILDING)
end

function var0_0.updateUI(arg0_12)
	local var0_12 = arg0_12.prayProxy:getSelectedShipIDList()

	arg0_12:updatePaint(var0_12)

	local var1_12
	local var2_12 = arg0_12.bagProxy:getItemById(arg0_12.useItem) or {
		count = 0
	}

	setText(arg0_12.curCubeNumText, var2_12.count)

	local var3_12 = pg.ship_data_create_material[pg.activity_ship_create[arg0_12.poolType].create_id]

	setText(arg0_12.buildCubeNumText, var3_12.number_1)
	setText(arg0_12.buildGoldNumText, var3_12.use_gold)
end

function var0_0.updatePaint(arg0_13, arg1_13)
	for iter0_13 = 1, 2 do
		local var0_13 = arg1_13[iter0_13]
		local var1_13 = pg.ship_data_statistics[var0_13].name
		local var2_13 = pg.ship_data_statistics[var0_13].english_name
		local var3_13 = pg.ship_data_statistics[var0_13].rarity
		local var4_13 = var3_13 == ShipRarity.SSR
		local var5_13 = arg0_13.shipTF[iter0_13]
		local var6_13 = var5_13:Find("Mask/Paint")

		local function var7_13()
			local var0_14 = var6_13:Find("fitter"):GetChild(0)
			local var1_14 = GetComponent(var0_14, "MeshImage")
			local var2_14 = (iter0_13 == 2 and arg0_13.material2 or arg0_13.material1):GetComponent(typeof(Image)).material

			var2_14:SetFloat("_Range", iter0_13 == 2 and 0.9 or -0.57)
			var2_14:SetFloat("_Degree", iter0_13 == 2 and -50 or 50)

			var1_14.material = var2_14
		end

		setPaintingPrefabAsync(var6_13, Ship.getPaintingName(var0_13), "build", var7_13)

		local var8_13 = var5_13:Find("Light1")
		local var9_13 = var5_13:Find("Light2")
		local var10_13 = var9_13:Find("Light2_2")
		local var11_13 = var5_13:Find("Light3")

		if not var4_13 then
			setImageSprite(var8_13, arg0_13.raritySpriteMap.Normal.Light1)
			setImageSprite(var9_13, arg0_13.raritySpriteMap.Normal.Light2)
			setImageSprite(var10_13, arg0_13.raritySpriteMap.Normal.Light2_2)
			setImageSprite(var11_13, arg0_13.raritySpriteMap.Normal.Light3)
			setImageColor(var8_13, var0_0.Rarity_To_Light_Color_1[var3_13])
			setImageColor(var9_13, var0_0.Rarity_To_Light_Color_1[var3_13])
			setImageColor(var10_13, var0_0.Rarity_To_Light_Color_1[var3_13])
			setImageColor(var11_13, var0_0.Rarity_To_Light_Color_2[var3_13])
		else
			setImageSprite(var8_13, arg0_13.raritySpriteMap.UR.Light1)
			setImageSprite(var9_13, arg0_13.raritySpriteMap.UR.Light2)
			setImageSprite(var10_13, arg0_13.raritySpriteMap.UR.Light2_2)
			setImageSprite(var11_13, arg0_13.raritySpriteMap.UR.Light3)
		end

		local var12_13 = arg0_13.shipRarityTF[iter0_13]
		local var13_13 = var4_13 and arg0_13.raritySpriteMap.UR.RarityBG or arg0_13.raritySpriteMap.Normal.RarityBG

		setImageSprite(var12_13, var13_13)

		local var14_13 = var5_13:Find("NameText")

		setText(var14_13, var1_13)

		local var15_13 = var5_13:Find("NameEngText")

		setText(var15_13, var2_13)

		local var16_13 = var12_13:Find("NumImg")

		setImageSprite(var16_13, arg0_13.ratioSpriteMap[var3_13], true)
	end
end

function var0_0.MsgBox(arg0_15)
	local var0_15 = {
		_go = arg0_15
	}

	var0_15.__cname = "buildmsgbox"
	var0_15._tf = tf(arg0_15)
	var0_15.inited = false
	var0_15.cancenlBtn = findTF(var0_15._go, "window/btns/cancel_btn")
	var0_15.confirmBtn = findTF(var0_15._go, "window/btns/confirm_btn")
	var0_15.closeBtn = findTF(var0_15._go, "window/close_btn")
	var0_15.count = 1
	var0_15.minusBtn = findTF(var0_15._go, "window/content/calc_panel/minus")
	var0_15.addBtn = findTF(var0_15._go, "window/content/calc_panel/add")
	var0_15.maxBtn = findTF(var0_15._go, "window/content/max")
	var0_15.valueTxt = findTF(var0_15._go, "window/content/calc_panel/Text"):GetComponent(typeof(Text))
	var0_15.text = findTF(var0_15._go, "window/content/Text"):GetComponent(typeof(Text))
	var0_15.buildUI = arg0_15.parent
	var0_15.active = false

	pg.DelegateInfo.New(var0_15)
	setText(findTF(var0_15.cancenlBtn, "Image/Image (1)"), i18n("text_cancel"))
	setText(findTF(var0_15.confirmBtn, "Image/Image (1)"), i18n("text_confirm"))

	local function var1_15(arg0_16, arg1_16)
		var0_15.valueTxt.text = arg0_16

		if arg1_16 then
			local var0_16 = arg1_16(arg0_16)

			var0_15.text.text = var0_16
		else
			var0_15.text.text = ""
		end
	end

	function var0_15.init(arg0_17)
		arg0_17.inited = true

		onButton(arg0_17, arg0_17._tf, function()
			arg0_17:hide()
		end, SFX_PANEL)
		onButton(arg0_17, arg0_17.cancenlBtn, function()
			arg0_17:hide()
		end, SFX_PANEL)
		onButton(arg0_17, arg0_17.confirmBtn, function()
			if arg0_17.onConfirm then
				arg0_17.onConfirm(arg0_17.count)
			end

			arg0_17:hide()
		end, SFX_PANEL)
		onButton(arg0_17, arg0_17.closeBtn, function()
			arg0_17:hide()
		end, SFX_PANEL)
		onButton(arg0_17, arg0_17.minusBtn, function()
			if arg0_17:verifyCount(arg0_17.count - 1) then
				arg0_17.count = math.max(arg0_17.count - 1, 1)

				var1_15(arg0_17.count, arg0_17.updateText)
			end
		end, SFX_PANEL)
		onButton(arg0_17, arg0_17.addBtn, function()
			if arg0_17:verifyCount(arg0_17.count + 1) then
				arg0_17.count = math.min(arg0_17.count + 1, arg0_17.max)

				var1_15(arg0_17.count, arg0_17.updateText)
			end
		end, SFX_PANEL)
		onButton(arg0_17, arg0_17.maxBtn, function()
			if arg0_17:verifyCount(arg0_17.max) then
				arg0_17.count = arg0_17.max

				var1_15(arg0_17.count, arg0_17.updateText)
			end
		end, SFX_PANEL)
	end

	function var0_15.verifyCount(arg0_25, arg1_25)
		if arg0_25.verify then
			return arg0_25.verify(arg1_25)
		end

		return true
	end

	function var0_15.isActive(arg0_26)
		return arg0_26.active
	end

	function var0_15.show(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27)
		arg0_27.verify = arg2_27
		arg0_27.onConfirm = arg3_27
		arg0_27.active = true
		arg0_27.max = arg1_27 or 1
		arg0_27.count = 1
		arg0_27.updateText = arg4_27

		var1_15(arg0_27.count, arg4_27)
		setActive(var0_15._go, true)

		if not arg0_27.inited then
			arg0_27:init()
		end

		pg.UIMgr.GetInstance():BlurPanel(arg0_27._tf)
	end

	function var0_15.hide(arg0_28)
		if arg0_28:isActive() then
			arg0_28.onConfirm = nil
			arg0_28.active = false
			arg0_28.updateText = nil
			arg0_28.count = 1
			arg0_28.max = 1
			arg0_28.verify = nil

			setActive(var0_15._go, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_28._tf, arg0_28.buildUI)
		end
	end

	function var0_15.close(arg0_29)
		arg0_29:hide()
		pg.DelegateInfo.Dispose(arg0_29)
	end

	return var0_15
end

var0_0.Rarity_To_Light_Color_1 = {
	[2] = Color(0.556862745098039, 0.556862745098039, 0.556862745098039, 1),
	[3] = Color(0.156862745098039, 0.266666666666667, 0.615686274509804, 1),
	[4] = Color(0.329411764705882, 0.156862745098039, 0.615686274509804, 1),
	[5] = Color(1, 0.831372549019608, 0.313725490196078, 1)
}
var0_0.Rarity_To_Light_Color_2 = {
	[2] = Color(0.623529411764706, 0.654901960784314, 0.741176470588235, 1),
	[3] = Color(0.349019607843137, 0.529411764705882, 0.996078431372549, 1),
	[4] = Color(0.905882352941176, 0.615686274509804, 0.996078431372549, 1),
	[5] = Color(0.996078431372549, 0.870588235294118, 0.32156862745098, 1)
}

return var0_0
