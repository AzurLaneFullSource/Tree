local var0 = class("SingleBuffDetailLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "TechnologyTreeSingleBuffDetailUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:addListener()
	arg0:updateDetail()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.groupID = arg0.contextData.groupID
	arg0.maxLV = arg0.contextData.maxLV
	arg0.star = arg0.contextData.star
	arg0.classID = pg.fleet_tech_ship_template[arg0.groupID].class
	arg0.shipID = arg0.groupID * 10 + 1
	arg0.rarity = pg.ship_data_statistics[arg0.shipID].rarity
	arg0.shipPaintName = Ship.getPaintingName(arg0.shipID)
	arg0.shipType = pg.fleet_tech_ship_class[arg0.classID].shiptype
	arg0.classLevel = pg.fleet_tech_ship_class[arg0.classID].t_level
	arg0.typeToColor = {
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

function var0.findUI(arg0)
	arg0.backBtn = arg0:findTF("BG")
	arg0.detailPanel = arg0:findTF("DetailPanel")
	arg0.baseImg = arg0:findTF("Info/BaseImg", arg0.detailPanel)
	arg0.modelImg = arg0:findTF("ModelImg", arg0.baseImg)
	arg0.top = arg0:findTF("Info/top", arg0.detailPanel)
	arg0.levelImg = arg0:findTF("LevelImg", arg0.top)
	arg0.typeTextImg = arg0:findTF("TypeTextImg", arg0.top)
	arg0.nameText = arg0:findTF("Name/NameText", arg0.top)
	arg0.buffItemTpl = arg0:findTF("Info/BuffItemTpl", arg0.detailPanel)
	arg0.buffGetItem = arg0:findTF("Info/BuffGetItemTop", arg0.detailPanel)
	arg0.statusGetImg = arg0:findTF("StatusBG/StatusImg", arg0.buffGetItem)
	arg0.pointNumGetText = arg0:findTF("Point/PointNumText", arg0.buffGetItem)
	arg0.buffGetItemContainer = arg0:findTF("Info/BuffGetItemContainer", arg0.detailPanel)
	arg0.buffCompleteItem = arg0:findTF("Info/BuffCompleteItemTop", arg0.detailPanel)
	arg0.statusCompleteImg = arg0:findTF("StatusBG/StatusImg", arg0.buffCompleteItem)
	arg0.pointNumCompleteText = arg0:findTF("Point/PointNumText", arg0.buffCompleteItem)
	arg0.buffCompleteItemContainer = arg0:findTF("Info/BuffCompleteItemContainer", arg0.detailPanel)
	arg0.allStarStatusImg = arg0:findTF("Info/AllStarTop/StatusBG/StatusImg", arg0.detailPanel)
	arg0.allStarPointText = arg0:findTF("Info/AllStarTop/Point/PointNumText", arg0.detailPanel)
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.backBtn)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
end

function var0.updateDetail(arg0)
	LoadSpriteAsync("shipmodels/" .. arg0.shipPaintName, function(arg0)
		if arg0 then
			setImageSprite(arg0.modelImg, arg0, true)

			rtf(arg0.modelImg).pivot = getSpritePivot(arg0)
		end
	end)
	setImageSprite(arg0.baseImg, GetSpriteFromAtlas("shipraritybaseicon", "base_" .. arg0.rarity))
	setImageSprite(arg0.typeTextImg, GetSpriteFromAtlas("ShipType", "ch_title_" .. arg0.shipType), true)
	setText(arg0.nameText, ShipGroup.getDefaultShipNameByGroupID(arg0.groupID))

	if ShipGroup.IsMetaGroup(arg0.groupID) or ShipGroup.IsMotGroup(arg0.groupID) then
		setActive(arg0.levelImg, false)
	else
		setImageSprite(arg0.levelImg, GetSpriteFromAtlas("TecClassLevelIcon", "T" .. arg0.classLevel), true)
		setActive(arg0.levelImg, true)
	end

	local var0 = pg.fleet_tech_ship_template[arg0.groupID].pt_get
	local var1 = pg.fleet_tech_ship_template[arg0.groupID].pt_level

	setText(arg0.pointNumGetText, "+" .. var0)
	setText(arg0.pointNumCompleteText, "+" .. var1)
	setText(arg0.allStarPointText, "+" .. pg.fleet_tech_ship_template[arg0.groupID].pt_upgrage)

	if arg0.star >= pg.fleet_tech_ship_template[arg0.groupID].max_star then
		setImageColor(arg0.allStarStatusImg, Color.New(1, 0.913725490196078, 0.447058823529412, 1))
	end

	if arg0.maxLV >= TechnologyConst.SHIP_LEVEL_FOR_BUFF then
		setImageColor(arg0.statusCompleteImg, Color.New(1, 0.913725490196078, 0.447058823529412, 1))
	end

	local var2 = arg0:getSpecialTypeList(pg.fleet_tech_ship_template[arg0.groupID].add_get_shiptype)
	local var3 = pg.fleet_tech_ship_template[arg0.groupID].add_get_attr
	local var4 = pg.fleet_tech_ship_template[arg0.groupID].add_get_value
	local var5 = UIItemList.New(arg0.buffGetItemContainer, arg0.buffItemTpl)

	var5:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("Symbol/Left", arg2)
			local var1 = arg0:findTF("Symbol/Right", arg2)
			local var2 = arg0:findTF("TypeText", arg2)
			local var3 = arg0:findTF("AttrText", arg2)
			local var4 = arg0:findTF("ValueText", arg2)
			local var5 = var2[arg1 + 1]
			local var6 = arg0.typeToColor[var5]

			setTextColor(var0, var6)
			setTextColor(var1, var6)
			setText(var2, ShipType.Type2Name(var5))
			setTextColor(var2, var6)
			setText(var3, AttributeType.Type2Name(pg.attribute_info_by_type[var3].name))
			setText(var4, "+" .. var4)
			setActive(arg2, true)
		end
	end)
	var5:align(#var2)

	local var6 = arg0:getSpecialTypeList(pg.fleet_tech_ship_template[arg0.groupID].add_level_shiptype)
	local var7 = pg.fleet_tech_ship_template[arg0.groupID].add_level_attr
	local var8 = pg.fleet_tech_ship_template[arg0.groupID].add_level_value
	local var9 = UIItemList.New(arg0.buffCompleteItemContainer, arg0.buffItemTpl)

	var9:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("Symbol/Left", arg2)
			local var1 = arg0:findTF("Symbol/Right", arg2)
			local var2 = arg0:findTF("TypeText", arg2)
			local var3 = arg0:findTF("AttrText", arg2)
			local var4 = arg0:findTF("ValueText", arg2)
			local var5 = arg0:findTF("BG", arg2)
			local var6 = var6[arg1 + 1]
			local var7

			if arg0.maxLV >= TechnologyConst.SHIP_LEVEL_FOR_BUFF then
				var7 = arg0.typeToColor[var6]

				setGray(var5, false)
			else
				var7 = Color.New(0.63921568627451, 0.63921568627451, 0.63921568627451, 1)

				setTextColor(var4, var7)
				setTextColor(var3, var7)
				setGray(var5, true)
			end

			setTextColor(var0, var7)
			setTextColor(var1, var7)
			setText(var2, ShipType.Type2Name(var6))
			setTextColor(var2, var7)
			setText(var3, AttributeType.Type2Name(pg.attribute_info_by_type[var7].name))
			setText(var4, "+" .. var8)
			setActive(arg2, true)
		end
	end)
	var9:align(#var6)
end

function var0.getSpecialTypeList(arg0, arg1)
	local var0 = ShipType.FilterOverQuZhuType(arg1)

	return (ShipType.FilterOverFengFanType(var0))
end

return var0
