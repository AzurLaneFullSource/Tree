local var0_0 = class("SingleBuffDetailLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TechnologyTreeSingleBuffDetailUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3:addListener()
	arg0_3:updateDetail()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	arg0_5.groupID = arg0_5.contextData.groupID
	arg0_5.maxLV = arg0_5.contextData.maxLV
	arg0_5.star = arg0_5.contextData.star
	arg0_5.classID = pg.fleet_tech_ship_template[arg0_5.groupID].class
	arg0_5.shipID = arg0_5.groupID * 10 + 1
	arg0_5.rarity = pg.ship_data_statistics[arg0_5.shipID].rarity
	arg0_5.shipPaintName = Ship.getPaintingName(arg0_5.shipID)
	arg0_5.shipType = pg.fleet_tech_ship_class[arg0_5.classID].shiptype
	arg0_5.classLevel = pg.fleet_tech_ship_class[arg0_5.classID].t_level
	arg0_5.typeToColor = {
		[ShipType.QuZhu] = Color.New(0.258823529411765, 0.92156862745098, 1, 1),
		[ShipType.QingXun] = Color.New(1, 0.913725490196078, 0.447058823529412, 1),
		[ShipType.ZhongXun] = Color.New(1, 0.913725490196078, 0.447058823529412, 1),
		[ShipType.ChaoXun] = Color.New(1, 0.913725490196078, 0.447058823529412, 1),
		[ShipType.ZhanXun] = Color.New(0.952941176470588, 0.396078431372549, 0.396078431372549, 1),
		[ShipType.ZhanLie] = Color.New(0.952941176470588, 0.396078431372549, 0.396078431372549, 1),
		[ShipType.HangXun] = Color.New(0.952941176470588, 0.396078431372549, 0.396078431372549, 1),
		[ShipType.HangZhan] = Color.New(0.952941176470588, 0.396078431372549, 0.396078431372549, 1),
		[ShipType.LeiXun] = Color.New(0.952941176470588, 0.396078431372549, 0.396078431372549, 1),
		[ShipType.ZhongPao] = Color.New(0.952941176470588, 0.396078431372549, 0.396078431372549, 1),
		[ShipType.QingHang] = Color.New(0.874509803921569, 0.658823529411765, 1, 1),
		[ShipType.ZhengHang] = Color.New(0.874509803921569, 0.658823529411765, 1, 1),
		[ShipType.QianTing] = Color.New(0.72156862745098, 1, 0.235294117647059, 1),
		[ShipType.QianMu] = Color.New(0.72156862745098, 1, 0.235294117647059, 1),
		[ShipType.WeiXiu] = Color.New(0.72156862745098, 1, 0.235294117647059, 1),
		[ShipType.Yunshu] = Color.New(0.72156862745098, 1, 0.235294117647059, 1),
		[ShipType.FengFanS] = Color.New(0.72156862745098, 1, 0.235294117647059, 1),
		[ShipType.FengFanV] = Color.New(0.72156862745098, 1, 0.235294117647059, 1),
		[ShipType.FengFanM] = Color.New(0.72156862745098, 1, 0.235294117647059, 1)
	}
end

function var0_0.findUI(arg0_6)
	arg0_6.backBtn = arg0_6:findTF("BG")
	arg0_6.detailPanel = arg0_6:findTF("DetailPanel")
	arg0_6.baseImg = arg0_6:findTF("Info/BaseImg", arg0_6.detailPanel)
	arg0_6.modelImg = arg0_6:findTF("ModelImg", arg0_6.baseImg)
	arg0_6.top = arg0_6:findTF("Info/top", arg0_6.detailPanel)
	arg0_6.levelImg = arg0_6:findTF("LevelImg", arg0_6.top)
	arg0_6.typeTextImg = arg0_6:findTF("TypeTextImg", arg0_6.top)
	arg0_6.nameText = arg0_6:findTF("Name/NameText", arg0_6.top)
	arg0_6.buffItemTpl = arg0_6:findTF("Info/BuffItemTpl", arg0_6.detailPanel)
	arg0_6.buffGetItem = arg0_6:findTF("Info/BuffGetItemTop", arg0_6.detailPanel)
	arg0_6.statusGetImg = arg0_6:findTF("StatusBG/StatusImg", arg0_6.buffGetItem)
	arg0_6.pointNumGetText = arg0_6:findTF("Point/PointNumText", arg0_6.buffGetItem)
	arg0_6.buffGetItemContainer = arg0_6:findTF("Info/BuffGetItemContainer", arg0_6.detailPanel)
	arg0_6.buffCompleteItem = arg0_6:findTF("Info/BuffCompleteItemTop", arg0_6.detailPanel)
	arg0_6.statusCompleteImg = arg0_6:findTF("StatusBG/StatusImg", arg0_6.buffCompleteItem)
	arg0_6.pointNumCompleteText = arg0_6:findTF("Point/PointNumText", arg0_6.buffCompleteItem)
	arg0_6.buffCompleteItemContainer = arg0_6:findTF("Info/BuffCompleteItemContainer", arg0_6.detailPanel)
	arg0_6.allStarStatusImg = arg0_6:findTF("Info/AllStarTop/StatusBG/StatusImg", arg0_6.detailPanel)
	arg0_6.allStarPointText = arg0_6:findTF("Info/AllStarTop/Point/PointNumText", arg0_6.detailPanel)
end

function var0_0.onBackPressed(arg0_7)
	triggerButton(arg0_7.backBtn)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
end

function var0_0.updateDetail(arg0_10)
	LoadSpriteAsync("shipmodels/" .. arg0_10.shipPaintName, function(arg0_11)
		if arg0_11 then
			setImageSprite(arg0_10.modelImg, arg0_11, true)

			rtf(arg0_10.modelImg).pivot = getSpritePivot(arg0_11)
		end
	end)
	setImageSprite(arg0_10.baseImg, GetSpriteFromAtlas("shipraritybaseicon", "base_" .. arg0_10.rarity))
	setImageSprite(arg0_10.typeTextImg, GetSpriteFromAtlas("ShipType", "ch_title_" .. arg0_10.shipType), true)
	setText(arg0_10.nameText, ShipGroup.getDefaultShipNameByGroupID(arg0_10.groupID))

	if ShipGroup.IsMetaGroup(arg0_10.groupID) or ShipGroup.IsMotGroup(arg0_10.groupID) then
		setActive(arg0_10.levelImg, false)
	else
		setImageSprite(arg0_10.levelImg, GetSpriteFromAtlas("TecClassLevelIcon", "T" .. arg0_10.classLevel), true)
		setActive(arg0_10.levelImg, true)
	end

	local var0_10 = pg.fleet_tech_ship_template[arg0_10.groupID].pt_get
	local var1_10 = pg.fleet_tech_ship_template[arg0_10.groupID].pt_level

	setText(arg0_10.pointNumGetText, "+" .. var0_10)
	setText(arg0_10.pointNumCompleteText, "+" .. var1_10)
	setText(arg0_10.allStarPointText, "+" .. pg.fleet_tech_ship_template[arg0_10.groupID].pt_upgrage)

	if arg0_10.star >= pg.fleet_tech_ship_template[arg0_10.groupID].max_star then
		setImageColor(arg0_10.allStarStatusImg, Color.New(1, 0.913725490196078, 0.447058823529412, 1))
	end

	if arg0_10.maxLV >= TechnologyConst.SHIP_LEVEL_FOR_BUFF then
		setImageColor(arg0_10.statusCompleteImg, Color.New(1, 0.913725490196078, 0.447058823529412, 1))
	end

	local var2_10 = arg0_10:getSpecialTypeList(pg.fleet_tech_ship_template[arg0_10.groupID].add_get_shiptype)
	local var3_10 = pg.fleet_tech_ship_template[arg0_10.groupID].add_get_attr
	local var4_10 = pg.fleet_tech_ship_template[arg0_10.groupID].add_get_value
	local var5_10 = UIItemList.New(arg0_10.buffGetItemContainer, arg0_10.buffItemTpl)

	var5_10:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_10:findTF("Symbol/Left", arg2_12)
			local var1_12 = arg0_10:findTF("Symbol/Right", arg2_12)
			local var2_12 = arg0_10:findTF("TypeText", arg2_12)
			local var3_12 = arg0_10:findTF("AttrText", arg2_12)
			local var4_12 = arg0_10:findTF("ValueText", arg2_12)
			local var5_12 = var2_10[arg1_12 + 1]
			local var6_12 = arg0_10.typeToColor[var5_12]

			setTextColor(var0_12, var6_12)
			setTextColor(var1_12, var6_12)
			setText(var2_12, ShipType.Type2Name(var5_12))
			setTextColor(var2_12, var6_12)
			setText(var3_12, AttributeType.Type2Name(pg.attribute_info_by_type[var3_10].name))
			setText(var4_12, "+" .. var4_10)
			setActive(arg2_12, true)
		end
	end)
	var5_10:align(#var2_10)

	local var6_10 = arg0_10:getSpecialTypeList(pg.fleet_tech_ship_template[arg0_10.groupID].add_level_shiptype)
	local var7_10 = pg.fleet_tech_ship_template[arg0_10.groupID].add_level_attr
	local var8_10 = pg.fleet_tech_ship_template[arg0_10.groupID].add_level_value
	local var9_10 = UIItemList.New(arg0_10.buffCompleteItemContainer, arg0_10.buffItemTpl)

	var9_10:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg0_10:findTF("Symbol/Left", arg2_13)
			local var1_13 = arg0_10:findTF("Symbol/Right", arg2_13)
			local var2_13 = arg0_10:findTF("TypeText", arg2_13)
			local var3_13 = arg0_10:findTF("AttrText", arg2_13)
			local var4_13 = arg0_10:findTF("ValueText", arg2_13)
			local var5_13 = arg0_10:findTF("BG", arg2_13)
			local var6_13 = var6_10[arg1_13 + 1]
			local var7_13

			if arg0_10.maxLV >= TechnologyConst.SHIP_LEVEL_FOR_BUFF then
				var7_13 = arg0_10.typeToColor[var6_13]

				setGray(var5_13, false)
			else
				var7_13 = Color.New(0.63921568627451, 0.63921568627451, 0.63921568627451, 1)

				setTextColor(var4_13, var7_13)
				setTextColor(var3_13, var7_13)
				setGray(var5_13, true)
			end

			setTextColor(var0_13, var7_13)
			setTextColor(var1_13, var7_13)
			setText(var2_13, ShipType.Type2Name(var6_13))
			setTextColor(var2_13, var7_13)
			setText(var3_13, AttributeType.Type2Name(pg.attribute_info_by_type[var7_10].name))
			setText(var4_13, "+" .. var8_10)
			setActive(arg2_13, true)
		end
	end)
	var9_10:align(#var6_10)
end

function var0_0.getSpecialTypeList(arg0_14, arg1_14)
	local var0_14 = ShipType.FilterOverQuZhuType(arg1_14)

	return (ShipType.FilterOverFengFanType(var0_14))
end

return var0_0
