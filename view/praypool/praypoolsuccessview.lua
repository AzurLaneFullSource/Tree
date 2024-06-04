local var0 = class("PrayPoolSuccessView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "PrayPoolSuccessView"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateUI()
	arg0:Show()
end

function var0.OnDestroy(arg0)
	arg0.buildMsgBox:hide()
end

function var0.OnBackPress(arg0)
	if arg0:GetLoaded() and isActive(arg0.boxTF) then
		arg0.buildMsgBox:hide()

		return true
	end
end

function var0.initData(arg0)
	arg0.prayProxy = getProxy(PrayProxy)
	arg0.poolType = arg0.prayProxy:getSelectedPoolType()
	arg0.playerProxy = getProxy(PlayerProxy)
	arg0.bagProxy = getProxy(BagProxy)
	arg0.useItem = pg.ship_data_create_material[1].use_item

	print("useitem " .. arg0.useItem)

	arg0.buildShipProxy = getProxy(BuildShipProxy)
end

function var0.initUI(arg0)
	arg0.shipTF = {
		arg0:findTF("Ship1"),
		(arg0:findTF("Ship2"))
	}
	arg0.shipRarityTF = {
		arg0:findTF("Rarity1"),
		(arg0:findTF("Rarity2"))
	}
	arg0.boxTF = arg0:findTF("build_msg")
	arg0.buildMsgBox = var0.MsgBox(arg0.boxTF)
	arg0.buildBtn = arg0:findTF("BuildBtn")
	arg0.buildCubeNumText = arg0:findTF("BuildInfo/CubeNum")
	arg0.buildGoldNumText = arg0:findTF("BuildInfo/GoldNum")
	arg0.curCubeNumText = arg0:findTF("CubeImg/NumText")
	arg0.material1 = arg0:findTF("material1")
	arg0.material2 = arg0:findTF("material2")
	arg0.ratioSpriteMap = {}

	local var0 = arg0:findTF("Ratio")

	for iter0 = 2, 6 do
		local var1 = getImageSprite(arg0:findTF(tostring(iter0), var0))

		arg0.ratioSpriteMap[iter0] = var1
	end

	arg0.raritySpriteMap = {
		Normal = {
			Light1 = getImageSprite(arg0:findTF("Light/Normal/Light1")),
			Light2 = getImageSprite(arg0:findTF("Light/Normal/Light2")),
			Light2_2 = getImageSprite(arg0:findTF("Light/Normal/Light2_2")),
			Light3 = getImageSprite(arg0:findTF("Light/Normal/Light3")),
			RarityBG = getImageSprite(arg0:findTF("RarityBG/Normal"))
		},
		UR = {
			Light1 = getImageSprite(arg0:findTF("Light/UR/Light1")),
			Light2 = getImageSprite(arg0:findTF("Light/UR/Light2")),
			Light2_2 = getImageSprite(arg0:findTF("Light/UR/Light2_2")),
			Light3 = getImageSprite(arg0:findTF("Light/UR/Light3")),
			RarityBG = getImageSprite(arg0:findTF("RarityBG/UR"))
		}
	}

	onButton(arg0, arg0.buildBtn, function()
		local var0 = pg.ship_data_create_material[pg.activity_ship_create[arg0.poolType].create_id]
		local var1 = arg0.playerProxy:getData()
		local var2 = arg0.bagProxy:getItemCountById(arg0.useItem)
		local var3 = arg0.buildShipProxy:getRawData()
		local var4 = table.getCount(var3)
		local var5 = _.min({
			math.floor(var1.gold / var0.use_gold),
			math.floor(var2 / var0.number_1),
			MAX_BUILD_WORK_COUNT - var4
		})
		local var6 = math.max(1, var5)

		local function var7(arg0)
			if arg0 > var6 or var1.gold < arg0 * var0.use_gold or var2 < arg0 * var0.number_1 then
				return false
			end

			return true
		end

		arg0.buildMsgBox:show(var6, var7, function(arg0)
			arg0:emit(PrayPoolConst.START_BUILD_SHIP_EVENT, var0.id, arg0, 0)
		end, function(arg0)
			local var0 = arg0 * var0.use_gold
			local var1 = arg0 * var0.number_1
			local var2 = var7(arg0) and COLOR_GREEN or COLOR_RED

			return i18n("build_ship_tip", arg0, var0.name, var0, var1, var2)
		end)
	end, SFX_UI_BUILDING_STARTBUILDING)
end

function var0.updateUI(arg0)
	local var0 = arg0.prayProxy:getSelectedShipIDList()

	arg0:updatePaint(var0)

	local var1
	local var2 = arg0.bagProxy:getItemById(arg0.useItem) or {
		count = 0
	}

	setText(arg0.curCubeNumText, var2.count)

	local var3 = pg.ship_data_create_material[pg.activity_ship_create[arg0.poolType].create_id]

	setText(arg0.buildCubeNumText, var3.number_1)
	setText(arg0.buildGoldNumText, var3.use_gold)
end

function var0.updatePaint(arg0, arg1)
	for iter0 = 1, 2 do
		local var0 = arg1[iter0]
		local var1 = pg.ship_data_statistics[var0].name
		local var2 = pg.ship_data_statistics[var0].english_name
		local var3 = pg.ship_data_statistics[var0].rarity
		local var4 = var3 == ShipRarity.SSR
		local var5 = arg0.shipTF[iter0]
		local var6 = arg0:findTF("Mask/Paint", var5)

		local function var7()
			local var0 = arg0:findTF("fitter", var6):GetChild(0)
			local var1 = GetComponent(var0, "MeshImage")
			local var2 = (iter0 == 2 and arg0.material2 or arg0.material1):GetComponent(typeof(Image)).material

			var2:SetFloat("_Range", iter0 == 2 and 0.9 or -0.57)
			var2:SetFloat("_Degree", iter0 == 2 and -50 or 50)

			var1.material = var2
		end

		setPaintingPrefabAsync(var6, Ship.getPaintingName(var0), "build", var7)

		local var8 = arg0:findTF("Light1", var5)
		local var9 = arg0:findTF("Light2", var5)
		local var10 = arg0:findTF("Light2_2", var9)
		local var11 = arg0:findTF("Light3", var5)

		if not var4 then
			setImageSprite(var8, arg0.raritySpriteMap.Normal.Light1)
			setImageSprite(var9, arg0.raritySpriteMap.Normal.Light2)
			setImageSprite(var10, arg0.raritySpriteMap.Normal.Light2_2)
			setImageSprite(var11, arg0.raritySpriteMap.Normal.Light3)
			setImageColor(var8, var0.Rarity_To_Light_Color_1[var3])
			setImageColor(var9, var0.Rarity_To_Light_Color_1[var3])
			setImageColor(var10, var0.Rarity_To_Light_Color_1[var3])
			setImageColor(var11, var0.Rarity_To_Light_Color_2[var3])
		else
			setImageSprite(var8, arg0.raritySpriteMap.UR.Light1)
			setImageSprite(var9, arg0.raritySpriteMap.UR.Light2)
			setImageSprite(var10, arg0.raritySpriteMap.UR.Light2_2)
			setImageSprite(var11, arg0.raritySpriteMap.UR.Light3)
		end

		local var12 = arg0.shipRarityTF[iter0]
		local var13 = var4 and arg0.raritySpriteMap.UR.RarityBG or arg0.raritySpriteMap.Normal.RarityBG

		setImageSprite(var12, var13)

		local var14 = arg0:findTF("NameText", var5)

		setText(var14, var1)

		local var15 = arg0:findTF("NameEngText", var5)

		setText(var15, var2)

		local var16 = arg0:findTF("NumImg", var12)

		setImageSprite(var16, arg0.ratioSpriteMap[var3], true)
	end
end

function var0.MsgBox(arg0)
	local var0 = {
		_go = arg0
	}

	var0.__cname = "buildmsgbox"
	var0._tf = tf(arg0)
	var0.inited = false
	var0.cancenlBtn = findTF(var0._go, "window/btns/cancel_btn")
	var0.confirmBtn = findTF(var0._go, "window/btns/confirm_btn")
	var0.closeBtn = findTF(var0._go, "window/close_btn")
	var0.count = 1
	var0.minusBtn = findTF(var0._go, "window/content/calc_panel/minus")
	var0.addBtn = findTF(var0._go, "window/content/calc_panel/add")
	var0.maxBtn = findTF(var0._go, "window/content/max")
	var0.valueTxt = findTF(var0._go, "window/content/calc_panel/Text"):GetComponent(typeof(Text))
	var0.text = findTF(var0._go, "window/content/Text"):GetComponent(typeof(Text))
	var0.buildUI = arg0.parent
	var0.active = false

	pg.DelegateInfo.New(var0)
	setText(findTF(var0.cancenlBtn, "Image/Image (1)"), i18n("text_cancel"))
	setText(findTF(var0.confirmBtn, "Image/Image (1)"), i18n("text_confirm"))

	local function var1(arg0, arg1)
		var0.valueTxt.text = arg0

		if arg1 then
			local var0 = arg1(arg0)

			var0.text.text = var0
		else
			var0.text.text = ""
		end
	end

	function var0.init(arg0)
		arg0.inited = true

		onButton(arg0, arg0._tf, function()
			arg0:hide()
		end, SFX_PANEL)
		onButton(arg0, arg0.cancenlBtn, function()
			arg0:hide()
		end, SFX_PANEL)
		onButton(arg0, arg0.confirmBtn, function()
			if arg0.onConfirm then
				arg0.onConfirm(arg0.count)
			end

			arg0:hide()
		end, SFX_PANEL)
		onButton(arg0, arg0.closeBtn, function()
			arg0:hide()
		end, SFX_PANEL)
		onButton(arg0, arg0.minusBtn, function()
			if arg0:verifyCount(arg0.count - 1) then
				arg0.count = math.max(arg0.count - 1, 1)

				var1(arg0.count, arg0.updateText)
			end
		end, SFX_PANEL)
		onButton(arg0, arg0.addBtn, function()
			if arg0:verifyCount(arg0.count + 1) then
				arg0.count = math.min(arg0.count + 1, arg0.max)

				var1(arg0.count, arg0.updateText)
			end
		end, SFX_PANEL)
		onButton(arg0, arg0.maxBtn, function()
			if arg0:verifyCount(arg0.max) then
				arg0.count = arg0.max

				var1(arg0.count, arg0.updateText)
			end
		end, SFX_PANEL)
	end

	function var0.verifyCount(arg0, arg1)
		if arg0.verify then
			return arg0.verify(arg1)
		end

		return true
	end

	function var0.isActive(arg0)
		return arg0.active
	end

	function var0.show(arg0, arg1, arg2, arg3, arg4)
		arg0.verify = arg2
		arg0.onConfirm = arg3
		arg0.active = true
		arg0.max = arg1 or 1
		arg0.count = 1
		arg0.updateText = arg4

		var1(arg0.count, arg4)
		setActive(var0._go, true)

		if not arg0.inited then
			arg0:init()
		end

		pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	end

	function var0.hide(arg0)
		if arg0:isActive() then
			arg0.onConfirm = nil
			arg0.active = false
			arg0.updateText = nil
			arg0.count = 1
			arg0.max = 1
			arg0.verify = nil

			setActive(var0._go, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.buildUI)
		end
	end

	function var0.close(arg0)
		arg0:hide()
		pg.DelegateInfo.Dispose(arg0)
	end

	return var0
end

var0.Rarity_To_Light_Color_1 = {
	[2] = Color(0.556862745098039, 0.556862745098039, 0.556862745098039, 1),
	[3] = Color(0.156862745098039, 0.266666666666667, 0.615686274509804, 1),
	[4] = Color(0.329411764705882, 0.156862745098039, 0.615686274509804, 1),
	[5] = Color(1, 0.831372549019608, 0.313725490196078, 1)
}
var0.Rarity_To_Light_Color_2 = {
	[2] = Color(0.623529411764706, 0.654901960784314, 0.741176470588235, 1),
	[3] = Color(0.349019607843137, 0.529411764705882, 0.996078431372549, 1),
	[4] = Color(0.905882352941176, 0.615686274509804, 0.996078431372549, 1),
	[5] = Color(0.996078431372549, 0.870588235294118, 0.32156862745098, 1)
}

return var0
