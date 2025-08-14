local var0_0 = class("NewSkinShowLayer", import("...base.BaseUI"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.getUIName(arg0_1)
	return "NewSkinShowUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2._tf:Find("adapt/top/closeBtn")
	arg0_2.homeBtn = arg0_2._tf:Find("adapt/top/homeBtn")
	arg0_2.bgs = arg0_2._tf:Find("bgs")
	arg0_2.resources = arg0_2._tf:Find("adapt/top/resources")
	arg0_2.limitTime = arg0_2._tf:Find("adapt/top/skinTitle/limit_time")
	arg0_2.skinName = arg0_2._tf:Find("adapt/top/skinTitle/skin_name_mask/skin_name")
	arg0_2.shipName = arg0_2._tf:Find("adapt/top/skinTitle/name_mask/name")
	arg0_2.changeSkin = arg0_2._tf:Find("adapt/top/change_skin")
	arg0_2.sdTg = arg0_2._tf:Find("adapt/right/sdTg")
	arg0_2.hideUITg = arg0_2._tf:Find("adapt/right/hideUITg")
	arg0_2.charContainer = arg0_2._tf:Find("adapt/right/char_container")
	arg0_2.backChara = arg0_2.charContainer:Find("bg/back/chara")
	arg0_2.charTf = arg0_2.charContainer:Find("char")
	arg0_2.furnitureContainer = arg0_2.charContainer:Find("fur")
	arg0_2.dynamicToggle = arg0_2._tf:Find("adapt/right/functionsAndTags/dynamic")
	arg0_2.showBgToggle = arg0_2._tf:Find("adapt/right/functionsAndTags/showBg")
	arg0_2.dynamicResToggle = arg0_2._tf:Find("adapt/right/functionsAndTags/dynamic/l2d_res_state")
	arg0_2.tagList = UIItemList.New(arg0_2._tf:Find("adapt/right/functionsAndTags/tags"), arg0_2._tf:Find("adapt/right/functionsAndTags/tags/tag"))
	arg0_2.switchPreviewBtn = arg0_2.charContainer:Find("switch")
	arg0_2.painting = arg0_2._tf:Find("painting")
	arg0_2.paintingTF = arg0_2._tf:Find("painting/paint")
	arg0_2.defaultPaintingPosition = arg0_2.paintingTF.anchoredPosition
	arg0_2.defaultPaintingScale = arg0_2.paintingTF.localScale
	arg0_2.live2dContainer = arg0_2._tf:Find("painting/paint/live2d")
	arg0_2.spTF = arg0_2._tf:Find("painting/paint/spinePainting")
	arg0_2.spBg = arg0_2._tf:Find("painting/paintBg/spinePainting")
	arg0_2.equipBtn = arg0_2._tf:Find("adapt/equipBtn")

	setText(arg0_2._tf:Find("bgs/empty/Text"), i18n("shop_new_unfound"))
	setText(arg0_2._tf:Find("adapt/top/title/Text"), i18n("shop_new_shop"))
	setText(arg0_2.equipBtn:Find("Text"), i18n("shop_new_wear"))
	setActive(arg0_2.switchPreviewBtn, false)
	setActive(arg0_2.limitTime, false)

	arg0_2.changeSkinToggles = {}

	for iter0_2 = 1, 2 do
		local var0_2 = arg0_2.changeSkin:Find("toggle_ui/ad/toggle/" .. iter0_2)
		local var1_2 = GetComponent(var0_2, typeof(Toggle))

		var1_2.isOn = false

		table.insert(arg0_2.changeSkinToggles, var1_2)
	end

	arg0_2.downloads = {}
	arg0_2.isToggleDynamic = false
	arg0_2.isToggleShowBg = true
	arg0_2.selectShipPage = ChangeShipSkinPage.New(arg0_2._parentTf, arg0_2.event)

	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_3)
	arg0_3.shipSkin = arg0_3.contextData.skin
	arg0_3.skinId = arg0_3.shipSkin.id

	arg0_3:SetResource()
	arg0_3:UpdateMainView()
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)

	local var0_3 = getProxy(PlayerProxy):getRawData().id

	onToggle(arg0_3, arg0_3.sdTg, function(arg0_6)
		setActive(arg0_3.charContainer, arg0_6)
		PlayerPrefs.SetInt("LatestSkinShopLayerSdTg" .. var0_3, arg0_6 and 1 or 0)
		PlayerPrefs.Save()
	end, SFX_PANEL)

	local var1_3 = PlayerPrefs.GetInt("LatestSkinShopLayerSdTg" .. var0_3, 0)

	triggerToggle(arg0_3.sdTg, var1_3 == 1)
	onToggle(arg0_3, arg0_3.sdTg, function(arg0_7)
		setActive(arg0_3.charContainer, arg0_7)
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.hideUITg, function(arg0_8)
		setActive(arg0_3._tf:Find("adapt/top"), not arg0_8)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.equipBtn, function()
		if arg0_3.shipSkin:CantUse() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_ship_to_wear"))

			return
		end

		arg0_3.selectShipPage:ExecuteAction("Show", arg0_3.shipSkin)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.changeSkin, function()
		if ShipSkin.IsChangeSkin(arg0_3.skinId) then
			arg0_3.changeSkinId = ShipSkin.GetChangeSkinNextId(arg0_3.skinId)

			arg0_3:UpdateMainView()
		end
	end, SFX_PANEL)
end

function var0_0.SetResource(arg0_11)
	local var0_11 = getProxy(PlayerProxy):getRawData()

	setText(arg0_11.resources:Find("gem/Text"), var0_11:getTotalGem())
	onButton(arg0_11, arg0_11.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.UpdateMainView(arg0_13)
	local var0_13 = ShipSkin.IsChangeSkin(arg0_13.skinId)

	setActive(arg0_13.changeSkin, var0_13)

	if var0_13 then
		arg0_13:FlushChangeSkin()
	end

	arg0_13:FlushName()
	arg0_13:FlushSkin()
	arg0_13:FlushPaintingToggle()
	arg0_13:FlushTag()
	arg0_13:FlushBG()
	arg0_13:FlushPainting()
end

function var0_0.FlushChangeSkin(arg0_14)
	local var0_14 = ShipSkin.GetChangeSkinGroupId(arg0_14.skinId)

	if not arg0_14.changeSkinId then
		arg0_14.changeSkinId = arg0_14.skinId
	elseif ShipSkin.GetChangeSkinGroupId(arg0_14.changeSkinId) == var0_14 then
		arg0_14.skinId = arg0_14.changeSkinId
		arg0_14.shipSkin = ShipSkin.New({
			id = arg0_14.skinId
		})
	else
		arg0_14.changeSkinId = arg0_14.skinId
	end

	arg0_14._toggleIndex = ShipSkin.GetChangeSkinIndex(arg0_14.skinId)

	for iter0_14 = 1, 2 do
		arg0_14.changeSkinToggles[iter0_14].isOn = iter0_14 == arg0_14._toggleIndex and true or false
	end
end

function var0_0.FlushName(arg0_15)
	local var0_15 = pg.ship_skin_template[arg0_15.skinId]

	setScrollText(arg0_15.skinName, SwitchSpecialChar(var0_15.name, true))

	if var0_15.skin_type == ShipSkin.SKIN_TYPE_TB then
		setScrollText(arg0_15.shipName, NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_15.skinId)))
	else
		local var1_15 = ShipGroup.getDefaultShipConfig(var0_15.ship_group)

		setScrollText(arg0_15.shipName, var1_15.name)
	end
end

function var0_0.FlushSkin(arg0_16)
	if pg.ship_skin_template[arg0_16.skinId].skin_type == ShipSkin.SKIN_TYPE_TB then
		setActive(arg0_16.charContainer, false)

		return
	end

	setActive(arg0_16.charContainer, true)

	local var0_16 = pg.ship_skin_template[arg0_16.skinId]

	arg0_16:FlushChar(var0_16.prefab, var0_16.id)
	GetImageSpriteFromAtlasAsync("qicon/" .. var0_16.painting, "", arg0_16.backChara)
end

function var0_0.FlushChar(arg0_17, arg1_17, arg2_17)
	if arg0_17.prefabName and arg0_17.prefabName == arg1_17 then
		return
	end

	arg0_17:ReturnChar()

	arg0_17.prefabName = arg1_17

	PoolMgr.GetInstance():GetSpineChar(arg1_17, true, function(arg0_18)
		if arg0_17.prefabName ~= arg1_17 then
			PoolMgr.GetInstance():ReturnSpineChar(arg1_17, arg0_18)

			return
		end

		arg0_17.spineChar = tf(arg0_18)

		local var0_18 = pg.skinshop_spine_scale[arg2_17]

		if var0_18 then
			arg0_17.spineChar.localScale = Vector3(var0_18.skinshop_scale, var0_18.skinshop_scale, 1)
		else
			arg0_17.spineChar.localScale = Vector3(0.9, 0.9, 1)
		end

		arg0_17.spineChar.localPosition = Vector3(0, 0, 0)

		pg.ViewUtils.SetLayer(arg0_17.spineChar, Layer.UI)
		setParent(arg0_17.spineChar, arg0_17.charTf)
		arg0_18:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end)
end

function var0_0.FlushPaintingToggle(arg0_19)
	removeOnToggle(arg0_19.dynamicToggle)
	removeOnToggle(arg0_19.showBgToggle)

	local var0_19 = checkABExist("painting/" .. arg0_19.shipSkin:getConfig("painting") .. "_n")

	if arg0_19.isToggleShowBg and not var0_19 then
		triggerToggle(arg0_19.showBgToggle, false)

		arg0_19.isToggleShowBg = false
	elseif var0_19 then
		triggerToggle(arg0_19.showBgToggle, true)

		arg0_19.isToggleShowBg = true
	end

	local var1_19 = arg0_19.shipSkin:IsSpine() or arg0_19.shipSkin:IsLive2d() or arg0_19.shipSkin:IsSpinePlus() or arg0_19.shipSkin:IsLive2dPlus()

	if LOCK_SKIN_SHOP_ANIM_PREVIEW == "all" or LOCK_SKIN_SHOP_ANIM_PREVIEW and table.contains(LOCK_SKIN_SHOP_ANIM_PREVIEW, arg0_19.shipSkin.id) then
		var1_19 = false
	end

	if var1_19 and PlayerPrefs.GetInt("skinShop#l2dPreViewToggle" .. getProxy(PlayerProxy):getRawData().id, 0) == 1 then
		arg0_19.isToggleDynamic = true
	end

	if var1_19 then
		local var2_19 = 0

		if arg0_19.shipSkin:IsSpine() then
			var2_19 = 6
		elseif arg0_19.shipSkin:IsLive2d() then
			var2_19 = 1
		elseif arg0_19.shipSkin:IsSpinePlus() then
			var2_19 = 7
		elseif arg0_19.shipSkin:IsLive2dPlus() then
			var2_19 = 9
		end

		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_19) .. "_off", arg0_19.dynamicToggle)
		LoadImageSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_19), arg0_19.dynamicToggle:Find("select"))
	end

	if arg0_19.isToggleDynamic and not var1_19 then
		triggerToggle(arg0_19.dynamicToggle, false)

		arg0_19.isToggleDynamic = false
	elseif arg0_19.isToggleDynamic and not arg0_19.dynamicToggle:GetComponent(typeof(Toggle)).isOn then
		if (arg0_19.shipSkin:IsLive2d() or arg0_19.shipSkin:IsLive2dPlus()) and Live2dConst.GetLive2DArm32MatchAble() then
			arg0_19.isToggleDynamic = false

			local var3_19 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var3_19, 0)
			PlayerPrefs.Save()
			triggerToggle(arg0_19.dynamicToggle, false)
		else
			triggerToggle(arg0_19.dynamicToggle, true)

			arg0_19.isToggleDynamic = true
		end
	end

	if var0_19 then
		onToggle(arg0_19, arg0_19.showBgToggle, function(arg0_20)
			arg0_19.isToggleShowBg = arg0_20

			arg0_19:FlushPainting()
			arg0_19:FlushBG()
		end, SFX_PANEL)
	end

	if arg0_19.shipSkin:IsSpine() or arg0_19.shipSkin:IsLive2d() or arg0_19.shipSkin:IsSpinePlus() or arg0_19.shipSkin:IsLive2dPlus() then
		onToggle(arg0_19, arg0_19.dynamicToggle, function(arg0_21)
			if arg0_21 and Live2dConst.GetLive2DArm32MatchAble() and (arg0_19.shipSkin:IsLive2d() or arg0_19.shipSkin:IsLive2dPlus()) then
				Live2dConst.ShowLive2DArm32Tips()
				triggerToggle(arg0_19.dynamicToggle, false)

				return
			end

			arg0_19.isToggleDynamic = arg0_21

			setActive(arg0_19.showBgToggle, not arg0_21 and var0_19)
			arg0_19:FlushPainting()
			arg0_19:FlushDynamicPaintingResState()
			arg0_19:RecordFlag(arg0_21)
		end, SFX_PANEL)
	end

	if arg0_19.isToggleDynamic then
		arg0_19:FlushDynamicPaintingResState()
	end

	setActive(arg0_19.dynamicToggle, var1_19)
	setActive(arg0_19.showBgToggle, not arg0_19.isToggleDynamic and var0_19)
end

function var0_0.FlushPainting(arg0_22)
	local var0_22 = arg0_22:GetPaintingState()
	local var1_22 = pg.ship_skin_template[arg0_22.skinId].painting
	local var2_22 = ShipSkin.GetChangeSkinData(arg0_22.skinId) and true or false

	if var0_22 == var2_0 and not arg0_22:ExistL2dRes(var1_22) or var0_22 == var3_0 and not arg0_22:ExistSpineRes(var1_22) then
		var0_22 = var1_0
	end

	if arg0_22.paintingState and arg0_22.paintingState.state == var0_22 and arg0_22.paintingState.id == arg0_22.skinId and arg0_22.paintingState.showBg == arg0_22.isToggleShowBg and not var2_22 then
		return
	end

	arg0_22:ClearPainting()

	if var0_22 == var1_0 then
		arg0_22:LoadMeshPainting(arg0_22.isToggleShowBg)
	elseif var0_22 == var2_0 then
		arg0_22:LoadL2dPainting()
	elseif var0_22 == var3_0 then
		arg0_22:LoadSpinePainting()
	end

	arg0_22.paintingState = {
		state = var0_22,
		id = arg0_22.skinId,
		showBg = arg0_22.isToggleShowBg
	}

	arg0_22:AdjustPainting(false)
end

function var0_0.GetPaintingState(arg0_23)
	if arg0_23.isToggleDynamic and (arg0_23.shipSkin:IsLive2d() or arg0_23.shipSkin:IsLive2dPlus()) then
		return var2_0
	elseif arg0_23.isToggleDynamic and (arg0_23.shipSkin:IsSpine() or arg0_23.shipSkin:IsSpinePlus()) then
		if arg0_23.shipSkin:getConfig("spine_use_live2d") == 1 then
			return var2_0
		end

		return var3_0
	else
		return var1_0
	end
end

function var0_0.ExistL2dRes(arg0_24, arg1_24)
	local var0_24 = "live2d/" .. string.lower(arg1_24)
	local var1_24 = HXSet.autoHxShiftPath(var0_24, nil, true)

	return checkABExist(var1_24), var1_24
end

function var0_0.ExistSpineRes(arg0_25, arg1_25)
	local var0_25 = "SpinePainting/" .. string.lower(arg1_25)
	local var1_25 = HXSet.autoHxShiftPath(var0_25, nil, true)

	return checkABExist(var1_25), var1_25
end

function var0_0.FlushBG(arg0_26, arg1_26)
	local var0_26 = arg0_26.skinId
	local var1_26 = pg.ship_skin_template[var0_26]
	local var2_26

	if var1_26.skin_type == ShipSkin.SKIN_TYPE_TB then
		var2_26 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_26))
	else
		local var3_26 = ShipGroup.getDefaultShipConfig(var1_26.ship_group)

		var2_26 = Ship.New({
			id = 999,
			configId = var3_26.id,
			skin_id = var0_26
		})
	end

	local var4_26 = var2_26:getShipBgPrint(true)
	local var5_26 = pg.ship_skin_template[var0_26].painting

	if (arg0_26.isToggleShowBg or not checkABExist("painting/" .. var5_26 .. "_n")) and var1_26.bg_sp ~= "" then
		var4_26 = var1_26.bg_sp
	end

	local var6_26 = var4_26 ~= var2_26:rarity2bgPrintForGet()

	if var6_26 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_26, var4_26, arg0_26.bgs:Find("diffBg"), arg0_26.bgs:Find("diffBg/bg"), function(arg0_27)
			if arg1_26 then
				arg1_26()
			end
		end, function(arg0_28)
			if arg1_26 then
				arg1_26()
			end
		end)
	else
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_26:getUIName())

		if arg1_26 then
			arg1_26()
		end
	end

	setActive(arg0_26.bgs:Find("diffBg"), var6_26)
	setActive(arg0_26.bgs:Find("default"), not var6_26)
end

function var0_0.FlushDynamicPaintingResState(arg0_29)
	if not arg0_29.isToggleDynamic then
		return
	end

	local var0_29 = arg0_29:GetPaintingState()
	local var1_29 = false
	local var2_29 = ""
	local var3_29 = pg.ship_skin_template[arg0_29.skinId].painting

	if var2_0 == var0_29 then
		var1_29, var2_29 = arg0_29:ExistL2dRes(var3_29)
	elseif var3_0 == var0_29 then
		var1_29, var2_29 = arg0_29:ExistSpineRes(var3_29)
	end

	setActive(arg0_29.dynamicResToggle, not var1_29)
	removeOnButton(arg0_29.dynamicResToggle)

	if not var1_29 and var2_29 ~= "" then
		onButton(arg0_29, arg0_29.dynamicResToggle, function()
			arg0_29:DownloadDynamicPainting(var2_29)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadDynamicPainting(arg0_31, arg1_31)
	local var0_31 = arg0_31.skinId

	if arg0_31.downloads[var0_31] then
		return
	end

	local var1_31 = SkinShopDownloadRequest.New()

	arg0_31.downloads[var0_31] = var1_31

	var1_31:Start(arg1_31, function(arg0_32)
		if arg0_32 and arg0_31.paintingState and arg0_31.paintingState.id == arg0_31.skinId then
			arg0_31:FlushPainting()
			arg0_31:FlushDynamicPaintingResState()
		end

		var1_31:Dispose()

		arg0_31.downloads[var0_31] = nil
	end)
end

function var0_0.RecordFlag(arg0_33, arg1_33)
	local var0_33 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("skinShop#l2dPreViewToggle" .. var0_33, arg1_33 and 1 or 0)
	PlayerPrefs.Save()
	arg0_33:emit(LatestSkinShopMediator.ON_RECORD_ANIM_PREVIEW_BTN, arg1_33)
end

function var0_0.LoadMeshPainting(arg0_34, arg1_34)
	local var0_34 = findTF(arg0_34.paintingTF, "fitter")
	local var1_34 = GetOrAddComponent(var0_34, "PaintingScaler")

	var1_34.FrameName = "chuanwu"
	var1_34.Tween = 1

	local var2_34 = pg.ship_skin_template[arg0_34.skinId].painting
	local var3_34 = var2_34

	if not arg1_34 and checkABExist("painting/" .. var2_34 .. "_n") then
		var2_34 = var2_34 .. "_n"
	end

	if not checkABExist("painting/" .. var2_34) then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPainting(var2_34, true, function(arg0_35)
		pg.UIMgr.GetInstance():LoadingOff()
		setParent(arg0_35, var0_34, false)
		ShipExpressionHelper.SetExpression(var0_34:GetChild(0), var3_34)

		arg0_34.paintingName = var2_34

		if arg0_34.paintingState and arg0_34.paintingState.id ~= arg0_34.skinId then
			arg0_34:ClearMeshPainting()
		end
	end)
end

function var0_0.ClearMeshPainting(arg0_36)
	local var0_36 = arg0_36.paintingTF:Find("fitter")

	if arg0_36.paintingName and var0_36.childCount > 0 then
		local var1_36 = var0_36:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPainting(arg0_36.paintingName, var1_36)
	end

	arg0_36.paintingName = nil
end

function var0_0.LoadL2dPainting(arg0_37)
	local var0_37 = arg0_37.skinId
	local var1_37 = pg.ship_skin_template[var0_37].skin_type
	local var2_37

	if var1_37 == ShipSkin.SKIN_TYPE_TB then
		var2_37 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_37))
	else
		local var3_37 = pg.ship_skin_template[var0_37].ship_group
		local var4_37 = ShipGroup.getDefaultShipConfig(var3_37)

		var2_37 = Ship.New({
			noChangeSkin = true,
			configId = var4_37.id,
			skin_id = var0_37
		})
	end

	local var5_37 = Live2D.GenerateData({
		ship = var2_37,
		position = Vector3(0, 0, -1),
		parent = arg0_37.live2dContainer,
		offset = var2_37:GetSkinConfig().shop_offset
	})

	var5_37.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_37.live2dChar = Live2D.New(var5_37, function(arg0_38)
		arg0_38:IgonreReactPos(true)

		if arg0_37.paintingState and arg0_37.paintingState.id ~= arg0_37.skinId then
			arg0_37:ClearL2dPainting()
		end

		arg0_38:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearL2dPainting(arg0_39)
	if arg0_39.live2dChar then
		arg0_39.live2dChar:Dispose()

		arg0_39.live2dChar = nil
	end
end

function var0_0.LoadSpinePainting(arg0_40)
	local var0_40 = arg0_40.skinId
	local var1_40 = pg.ship_skin_template[var0_40].skin_type
	local var2_40

	if var1_40 == ShipSkin.SKIN_TYPE_TB then
		var2_40 = VirtualEducateCharShip.New(NewEducateHelper.GetSecIdBySkinId(var0_40))
	else
		local var3_40 = pg.ship_skin_template[var0_40].ship_group
		local var4_40 = ShipGroup.getDefaultShipConfig(var3_40)

		var2_40 = Ship.New({
			noChangeSkin = true,
			configId = var4_40.id,
			skin_id = var0_40
		})
	end

	local var5_40 = SpinePainting.GenerateData({
		ship = var2_40,
		position = Vector3(0, 0, 0),
		parent = arg0_40.spTF,
		effectParent = arg0_40.spBg,
		offset = var2_40:GetSkinConfig().shop_offset
	})

	pg.UIMgr.GetInstance():LoadingOn()

	arg0_40.spinePainting = SpinePainting.New(var5_40, function(arg0_41)
		if arg0_40.paintingState and arg0_40.paintingState.id ~= arg0_40.skinId then
			arg0_40:ClearSpinePainting()
		end

		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.ClearSpinePainting(arg0_42)
	if arg0_42.spinePainting and arg0_42.spinePainting._tf then
		local var0_42 = arg0_42.spinePainting._tf:Find("shop_hx")

		arg0_42.spinePainting:Dispose()

		arg0_42.spinePainting = nil
	end
end

function var0_0.AdjustPainting(arg0_43, arg1_43)
	local var0_43 = arg0_43.paintingTF
	local var1_43 = pg.ship_skin_newmainui_shift[arg0_43.skinId]

	if var1_43 then
		local var2_43 = var1_43.skin_shop_shift

		if arg1_43 then
			var0_43.anchoredPosition = Vector2(var2_43[1] - 440, var2_43[2] + arg0_43.defaultPaintingPosition.y)
		else
			var0_43.anchoredPosition = Vector2(var2_43[1] + arg0_43.defaultPaintingPosition.x, var2_43[2] + arg0_43.defaultPaintingPosition.y)
		end

		local var3_43 = var2_43[4]

		var0_43.localScale = Vector3(var3_43, var3_43, 1)
	else
		var0_43.anchoredPosition = Vector2(arg0_43.defaultPaintingPosition.x, arg0_43.defaultPaintingPosition.y)
		var0_43.localScale = arg0_43.defaultPaintingScale
	end
end

function var0_0.ReturnChar(arg0_44)
	if not IsNil(arg0_44.spineChar) then
		arg0_44.spineChar.gameObject:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0_44.prefabName, arg0_44.spineChar.gameObject)

		arg0_44.spineChar = nil
		arg0_44.prefabName = nil
	end
end

function var0_0.FlushTag(arg0_45)
	local var0_45 = arg0_45.skinId
	local var1_45 = pg.ship_skin_template[var0_45]
	local var2_45 = Clone(var1_45.tag)
	local var3_45 = false

	for iter0_45 = #var2_45, 1, -1 do
		local var4_45 = var2_45[iter0_45]

		if var4_45 == 1 or var4_45 == 6 or var4_45 == 7 or var4_45 == 9 then
			local var5_45 = true

			table.remove(var2_45, iter0_45)
		end
	end

	local var6_45 = checkABExist("painting/" .. arg0_45.shipSkin:getConfig("painting") .. "_n")

	arg0_45.tagList:make(function(arg0_46, arg1_46, arg2_46)
		if arg0_46 == UIItemList.EventUpdate then
			local var0_46 = var2_45[arg1_46 + 1]

			LoadSpriteAtlasAsync("SkinIcon", "type_" .. ShipSkin.Tag2Name(var2_45[arg1_46 + 1]), function(arg0_47)
				if arg0_45.exited then
					return
				end

				arg2_46:GetComponent(typeof(Image)).sprite = arg0_47
			end)
		end
	end)
	arg0_45.tagList:align(#var2_45)
end

function var0_0.ClearPainting(arg0_48)
	local var0_48 = arg0_48.paintingState

	if not var0_48 then
		return
	end

	if var0_48.state == var1_0 then
		arg0_48:ClearMeshPainting()
	elseif var0_48.state == var2_0 then
		arg0_48:ClearL2dPainting()
	elseif var0_48.state == var3_0 then
		arg0_48:ClearSpinePainting()
	end

	arg0_48.paintingState = nil
end

function var0_0.IsShowSelectShipView(arg0_49)
	return arg0_49.selectShipPage and arg0_49.selectShipPage:GetLoaded() and arg0_49.selectShipPage:isShowing()
end

function var0_0.CloseSelectShipView(arg0_50)
	arg0_50.selectShipPage:Hide()
end

function var0_0.willExit(arg0_51)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_51:getUIName())

	if arg0_51.live2dChar then
		arg0_51.live2dChar:Dispose()

		arg0_51.live2dChar = nil
	end

	for iter0_51, iter1_51 in pairs(arg0_51.downloads) do
		iter1_51:Dispose()
	end

	arg0_51.downloads = {}

	arg0_51:ClearPainting()
	arg0_51:ReturnChar()
	arg0_51.selectShipPage:Destroy()

	arg0_51.selectShipPage = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_51._tf)
end

function var0_0.onBackPressed(arg0_52)
	if arg0_52:IsShowSelectShipView() then
		arg0_52:CloseSelectShipView()

		return
	end

	var0_0.super.onBackPressed(arg0_52)
end

return var0_0
