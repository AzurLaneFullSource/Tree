local var0_0 = class("PrayPoolSuccessView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PrayPoolSuccessView"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateUI()
	arg0_2:Show()
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.buildMsgBox:hide()
end

function var0_0.OnBackPress(arg0_4)
	if arg0_4:GetLoaded() and isActive(arg0_4.boxTF) then
		arg0_4.buildMsgBox:hide()

		return true
	end
end

function var0_0.initData(arg0_5)
	arg0_5.prayProxy = getProxy(PrayProxy)
	arg0_5.poolType = arg0_5.prayProxy:getSelectedPoolType()
	arg0_5.playerProxy = getProxy(PlayerProxy)
	arg0_5.bagProxy = getProxy(BagProxy)
	arg0_5.useItem = pg.ship_data_create_material[1].use_item

	print("useitem " .. arg0_5.useItem)

	arg0_5.buildShipProxy = getProxy(BuildShipProxy)
end

function var0_0.initUI(arg0_6)
	arg0_6.shipTF = {
		arg0_6:findTF("Ship1"),
		(arg0_6:findTF("Ship2"))
	}
	arg0_6.shipRarityTF = {
		arg0_6:findTF("Rarity1"),
		(arg0_6:findTF("Rarity2"))
	}
	arg0_6.boxTF = arg0_6:findTF("build_msg")
	arg0_6.buildMsgBox = var0_0.MsgBox(arg0_6.boxTF)
	arg0_6.buildBtn = arg0_6:findTF("BuildBtn")
	arg0_6.buildCubeNumText = arg0_6:findTF("BuildInfo/CubeNum")
	arg0_6.buildGoldNumText = arg0_6:findTF("BuildInfo/GoldNum")
	arg0_6.curCubeNumText = arg0_6:findTF("CubeImg/NumText")
	arg0_6.material1 = arg0_6:findTF("material1")
	arg0_6.material2 = arg0_6:findTF("material2")
	arg0_6.ratioSpriteMap = {}

	local var0_6 = arg0_6:findTF("Ratio")

	for iter0_6 = 2, 6 do
		local var1_6 = getImageSprite(arg0_6:findTF(tostring(iter0_6), var0_6))

		arg0_6.ratioSpriteMap[iter0_6] = var1_6
	end

	arg0_6.raritySpriteMap = {
		Normal = {
			Light1 = getImageSprite(arg0_6:findTF("Light/Normal/Light1")),
			Light2 = getImageSprite(arg0_6:findTF("Light/Normal/Light2")),
			Light2_2 = getImageSprite(arg0_6:findTF("Light/Normal/Light2_2")),
			Light3 = getImageSprite(arg0_6:findTF("Light/Normal/Light3")),
			RarityBG = getImageSprite(arg0_6:findTF("RarityBG/Normal"))
		},
		UR = {
			Light1 = getImageSprite(arg0_6:findTF("Light/UR/Light1")),
			Light2 = getImageSprite(arg0_6:findTF("Light/UR/Light2")),
			Light2_2 = getImageSprite(arg0_6:findTF("Light/UR/Light2_2")),
			Light3 = getImageSprite(arg0_6:findTF("Light/UR/Light3")),
			RarityBG = getImageSprite(arg0_6:findTF("RarityBG/UR"))
		}
	}

	onButton(arg0_6, arg0_6.buildBtn, function()
		local var0_7 = pg.ship_data_create_material[pg.activity_ship_create[arg0_6.poolType].create_id]
		local var1_7 = arg0_6.playerProxy:getData()
		local var2_7 = arg0_6.bagProxy:getItemCountById(arg0_6.useItem)
		local var3_7 = arg0_6.buildShipProxy:getRawData()
		local var4_7 = table.getCount(var3_7)
		local var5_7 = _.min({
			math.floor(var1_7.gold / var0_7.use_gold),
			math.floor(var2_7 / var0_7.number_1),
			MAX_BUILD_WORK_COUNT - var4_7
		})
		local var6_7 = math.max(1, var5_7)

		local function var7_7(arg0_8)
			if arg0_8 > var6_7 or var1_7.gold < arg0_8 * var0_7.use_gold or var2_7 < arg0_8 * var0_7.number_1 then
				return false
			end

			return true
		end

		arg0_6.buildMsgBox:show(var6_7, var7_7, function(arg0_9)
			arg0_6:emit(PrayPoolConst.START_BUILD_SHIP_EVENT, var0_7.id, arg0_9, 0)
		end, function(arg0_10)
			local var0_10 = arg0_10 * var0_7.use_gold
			local var1_10 = arg0_10 * var0_7.number_1
			local var2_10 = var7_7(arg0_10) and COLOR_GREEN or COLOR_RED

			return i18n("build_ship_tip", arg0_10, var0_7.name, var0_10, var1_10, var2_10)
		end)
	end, SFX_UI_BUILDING_STARTBUILDING)
end

function var0_0.updateUI(arg0_11)
	local var0_11 = arg0_11.prayProxy:getSelectedShipIDList()

	arg0_11:updatePaint(var0_11)

	local var1_11
	local var2_11 = arg0_11.bagProxy:getItemById(arg0_11.useItem) or {
		count = 0
	}

	setText(arg0_11.curCubeNumText, var2_11.count)

	local var3_11 = pg.ship_data_create_material[pg.activity_ship_create[arg0_11.poolType].create_id]

	setText(arg0_11.buildCubeNumText, var3_11.number_1)
	setText(arg0_11.buildGoldNumText, var3_11.use_gold)
end

function var0_0.updatePaint(arg0_12, arg1_12)
	for iter0_12 = 1, 2 do
		local var0_12 = arg1_12[iter0_12]
		local var1_12 = pg.ship_data_statistics[var0_12].name
		local var2_12 = pg.ship_data_statistics[var0_12].english_name
		local var3_12 = pg.ship_data_statistics[var0_12].rarity
		local var4_12 = var3_12 == ShipRarity.SSR
		local var5_12 = arg0_12.shipTF[iter0_12]
		local var6_12 = arg0_12:findTF("Mask/Paint", var5_12)

		local function var7_12()
			local var0_13 = arg0_12:findTF("fitter", var6_12):GetChild(0)
			local var1_13 = GetComponent(var0_13, "MeshImage")
			local var2_13 = (iter0_12 == 2 and arg0_12.material2 or arg0_12.material1):GetComponent(typeof(Image)).material

			var2_13:SetFloat("_Range", iter0_12 == 2 and 0.9 or -0.57)
			var2_13:SetFloat("_Degree", iter0_12 == 2 and -50 or 50)

			var1_13.material = var2_13
		end

		setPaintingPrefabAsync(var6_12, Ship.getPaintingName(var0_12), "build", var7_12)

		local var8_12 = arg0_12:findTF("Light1", var5_12)
		local var9_12 = arg0_12:findTF("Light2", var5_12)
		local var10_12 = arg0_12:findTF("Light2_2", var9_12)
		local var11_12 = arg0_12:findTF("Light3", var5_12)

		if not var4_12 then
			setImageSprite(var8_12, arg0_12.raritySpriteMap.Normal.Light1)
			setImageSprite(var9_12, arg0_12.raritySpriteMap.Normal.Light2)
			setImageSprite(var10_12, arg0_12.raritySpriteMap.Normal.Light2_2)
			setImageSprite(var11_12, arg0_12.raritySpriteMap.Normal.Light3)
			setImageColor(var8_12, var0_0.Rarity_To_Light_Color_1[var3_12])
			setImageColor(var9_12, var0_0.Rarity_To_Light_Color_1[var3_12])
			setImageColor(var10_12, var0_0.Rarity_To_Light_Color_1[var3_12])
			setImageColor(var11_12, var0_0.Rarity_To_Light_Color_2[var3_12])
		else
			setImageSprite(var8_12, arg0_12.raritySpriteMap.UR.Light1)
			setImageSprite(var9_12, arg0_12.raritySpriteMap.UR.Light2)
			setImageSprite(var10_12, arg0_12.raritySpriteMap.UR.Light2_2)
			setImageSprite(var11_12, arg0_12.raritySpriteMap.UR.Light3)
		end

		local var12_12 = arg0_12.shipRarityTF[iter0_12]
		local var13_12 = var4_12 and arg0_12.raritySpriteMap.UR.RarityBG or arg0_12.raritySpriteMap.Normal.RarityBG

		setImageSprite(var12_12, var13_12)

		local var14_12 = arg0_12:findTF("NameText", var5_12)

		setText(var14_12, var1_12)

		local var15_12 = arg0_12:findTF("NameEngText", var5_12)

		setText(var15_12, var2_12)

		local var16_12 = arg0_12:findTF("NumImg", var12_12)

		setImageSprite(var16_12, arg0_12.ratioSpriteMap[var3_12], true)
	end
end

function var0_0.MsgBox(arg0_14)
	local var0_14 = {
		_go = arg0_14
	}

	var0_14.__cname = "buildmsgbox"
	var0_14._tf = tf(arg0_14)
	var0_14.inited = false
	var0_14.cancenlBtn = findTF(var0_14._go, "window/btns/cancel_btn")
	var0_14.confirmBtn = findTF(var0_14._go, "window/btns/confirm_btn")
	var0_14.closeBtn = findTF(var0_14._go, "window/close_btn")
	var0_14.count = 1
	var0_14.minusBtn = findTF(var0_14._go, "window/content/calc_panel/minus")
	var0_14.addBtn = findTF(var0_14._go, "window/content/calc_panel/add")
	var0_14.maxBtn = findTF(var0_14._go, "window/content/max")
	var0_14.valueTxt = findTF(var0_14._go, "window/content/calc_panel/Text"):GetComponent(typeof(Text))
	var0_14.text = findTF(var0_14._go, "window/content/Text"):GetComponent(typeof(Text))
	var0_14.buildUI = arg0_14.parent
	var0_14.active = false

	pg.DelegateInfo.New(var0_14)
	setText(findTF(var0_14.cancenlBtn, "Image/Image (1)"), i18n("text_cancel"))
	setText(findTF(var0_14.confirmBtn, "Image/Image (1)"), i18n("text_confirm"))

	local function var1_14(arg0_15, arg1_15)
		var0_14.valueTxt.text = arg0_15

		if arg1_15 then
			local var0_15 = arg1_15(arg0_15)

			var0_14.text.text = var0_15
		else
			var0_14.text.text = ""
		end
	end

	function var0_14.init(arg0_16)
		arg0_16.inited = true

		onButton(arg0_16, arg0_16._tf, function()
			arg0_16:hide()
		end, SFX_PANEL)
		onButton(arg0_16, arg0_16.cancenlBtn, function()
			arg0_16:hide()
		end, SFX_PANEL)
		onButton(arg0_16, arg0_16.confirmBtn, function()
			if arg0_16.onConfirm then
				arg0_16.onConfirm(arg0_16.count)
			end

			arg0_16:hide()
		end, SFX_PANEL)
		onButton(arg0_16, arg0_16.closeBtn, function()
			arg0_16:hide()
		end, SFX_PANEL)
		onButton(arg0_16, arg0_16.minusBtn, function()
			if arg0_16:verifyCount(arg0_16.count - 1) then
				arg0_16.count = math.max(arg0_16.count - 1, 1)

				var1_14(arg0_16.count, arg0_16.updateText)
			end
		end, SFX_PANEL)
		onButton(arg0_16, arg0_16.addBtn, function()
			if arg0_16:verifyCount(arg0_16.count + 1) then
				arg0_16.count = math.min(arg0_16.count + 1, arg0_16.max)

				var1_14(arg0_16.count, arg0_16.updateText)
			end
		end, SFX_PANEL)
		onButton(arg0_16, arg0_16.maxBtn, function()
			if arg0_16:verifyCount(arg0_16.max) then
				arg0_16.count = arg0_16.max

				var1_14(arg0_16.count, arg0_16.updateText)
			end
		end, SFX_PANEL)
	end

	function var0_14.verifyCount(arg0_24, arg1_24)
		if arg0_24.verify then
			return arg0_24.verify(arg1_24)
		end

		return true
	end

	function var0_14.isActive(arg0_25)
		return arg0_25.active
	end

	function var0_14.show(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
		arg0_26.verify = arg2_26
		arg0_26.onConfirm = arg3_26
		arg0_26.active = true
		arg0_26.max = arg1_26 or 1
		arg0_26.count = 1
		arg0_26.updateText = arg4_26

		var1_14(arg0_26.count, arg4_26)
		setActive(var0_14._go, true)

		if not arg0_26.inited then
			arg0_26:init()
		end

		pg.UIMgr.GetInstance():BlurPanel(arg0_26._tf)
	end

	function var0_14.hide(arg0_27)
		if arg0_27:isActive() then
			arg0_27.onConfirm = nil
			arg0_27.active = false
			arg0_27.updateText = nil
			arg0_27.count = 1
			arg0_27.max = 1
			arg0_27.verify = nil

			setActive(var0_14._go, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_27._tf, arg0_27.buildUI)
		end
	end

	function var0_14.close(arg0_28)
		arg0_28:hide()
		pg.DelegateInfo.Dispose(arg0_28)
	end

	return var0_14
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
