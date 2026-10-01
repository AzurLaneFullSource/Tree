local var0_0 = class("PlayerVitaeScene", import("..base.BaseUI"))

var0_0.ON_PAGE_SWTICH = "PlayerVitaeScene:ON_PAGE_SWTICH"
var0_0.PAGE_DEFAULT = 1
var0_0.PAGE_NATIVE_SHIPS = 2
var0_0.PAGE_RANDOM_SHIPS = 3

function var0_0.getUIName(arg0_1)
	return "PlayerVitaeUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/playervitaeui",
		"ui/share/btn_l2d_atlas",
		"commonbg/bg_admiral",
		"ui/shareui",
		"ui/admiralui_atlas",
		"ui/playervitaeshipspage"
	}

	local function var1_2()
		local var0_3 = {}
		local var1_3 = getProxy(MilitaryExerciseProxy):RawGetSeasonInfo()
		local var2_3 = SeasonInfo.getEmblem(var1_3.score, var1_3.rank)

		table.insert(var0_3, "emblem/" .. var2_3)
		table.insert(var0_3, "emblem/n_" .. var2_3)

		return var0_3
	end

	local function var2_2()
		local var0_4 = {}
		local var1_4 = arg0_2:GetFlagShip()
		local var2_4 = getProxy(ShipSkinProxy):GetAllSkinForShip(var1_4)
		local var3_4 = getProxy(ShipSkinProxy):GetShareSkinsForShip(var1_4)
		local var4_4 = _.map(var3_4, function(arg0_5)
			return pg.ship_skin_template[arg0_5.id]
		end)

		table.insertto(var2_4, var4_4)

		for iter0_4, iter1_4 in ipairs(var2_4) do
			local var5_4 = iter1_4 and iter1_4.painting or "unknown"

			if var5_4 ~= "unknown" then
				local var6_4 = ResPathSupport.GetPaintingListByPaintingName(var5_4)

				table.insertto(var0_4, var6_4)
			end
		end

		return var0_4
	end

	local function var3_2()
		local var0_6 = {}
		local var1_6 = arg0_2:GetPlayer().displayTrophyList

		for iter0_6, iter1_6 in ipairs(var1_6) do
			local var2_6 = iter1_6 > 1000000000 and LoveLetterTrophy.New({
				id = iter1_6
			}) or Trophy.New({
				id = iter1_6
			})

			if var2_6:isLoverLetter() then
				table.insert(var0_6, var2_6:GetPrefabName())
				table.insert(var0_6, "SquareIcon/" .. var2_6:GetPainting())
			else
				table.insert(var0_6, "medal/s_" .. var2_6:getConfig("icon"))
			end
		end

		return var0_6
	end

	local function var4_2()
		return {}
	end

	local var5_2 = var1_2()
	local var6_2 = var2_2()
	local var7_2 = var4_2()
	local var8_2 = var3_2()

	return ResPathSupport.MergeLuaArr(var0_2, var5_2, var6_2, var7_2, var8_2)
end

function var0_0.GetBGM(arg0_8)
	local var0_8 = arg0_8:GetFlagShip()
	local var1_8 = getProxy(SettingsProxy):IsBGMEnable()

	if var0_8:IsBgmSkin() and var1_8 then
		return var0_8:GetSkinBgm()
	else
		return "main"
	end
end

function var0_0.OnPlayerNameChange(arg0_9)
	if arg0_9.detailPage and arg0_9.detailPage:GetLoaded() then
		arg0_9.detailPage:OnPlayerNameChange(arg0_9:GetPlayer())
	end
end

function var0_0.OnShipSkinChanged(arg0_10, arg1_10)
	arg0_10:UpdatePainting()

	if arg0_10.shipsPage and arg0_10.shipsPage:isShowing() then
		arg0_10.shipsPage:UpdateCard(arg1_10)
	end
end

function var0_0.ReloadPanting(arg0_11, arg1_11)
	if arg0_11.displaySkinID and arg0_11.displaySkinID == arg1_11 then
		local var0_11 = arg0_11:GetFlagShip()

		arg0_11:ReturnPainting()

		local var1_11 = var0_11:getPainting()

		setPaintingPrefabAsync(arg0_11.painting, var1_11, "kanban")

		arg0_11.paintingName = var1_11
	end
end

function var0_0.RefreshShips(arg0_12)
	if arg0_12.shipsPage and arg0_12.shipsPage:GetLoaded() and arg0_12.shipsPage:isShowing() then
		arg0_12.shipsPage:RefreshShips()
	end
end

function var0_0.GetPlayer(arg0_13)
	return getProxy(PlayerProxy):getRawData()
end

function var0_0.GetFlagShip(arg0_14)
	return (arg0_14:GetPlayer():GetFlagShip())
end

function var0_0.init(arg0_15)
	arg0_15.bg = arg0_15._tf:Find("bg")
	arg0_15.backBtn = arg0_15._tf:Find("top/frame/back")
	arg0_15.mainViewCg = arg0_15._tf:Find("adapt"):GetComponent(typeof(CanvasGroup))
	arg0_15.mainTr = arg0_15.mainViewCg.gameObject.transform
	arg0_15.painting = arg0_15._tf:Find("adapt/paint")
	arg0_15.btnContainer = arg0_15._tf:Find("adapt/btns")
	arg0_15.switchSkinBtn = arg0_15._tf:Find("adapt/btns/swichSkin_btn")
	arg0_15.replaceBtn = arg0_15._tf:Find("adapt/btns/replace_btn")
	arg0_15.replaceBtnTip = arg0_15.replaceBtn:Find("tip")
	arg0_15.cryptolaliaBtn = arg0_15._tf:Find("adapt/btns/cryptolalia_btn")
	arg0_15.switchSkinBtnTag = arg0_15.switchSkinBtn:Find("Tag")
	arg0_15.titlt = arg0_15._tf:Find("top/frame/title")
	arg0_15.titltNative = arg0_15._tf:Find("top/frame/title_native")
	arg0_15.titltRandom = arg0_15._tf:Find("top/frame/title_random")

	local var0_15 = arg0_15._tf:Find("detail")

	arg0_15.detailCg = GetOrAddComponent(var0_15, typeof(CanvasGroup))

	local var1_15 = arg0_15._tf:Find("adapt/tpl")

	setActive(var1_15, false)

	arg0_15.btns = {
		PlayerVitaeSpineBtn.New(var1_15, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeBGBtn.New(var1_15, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeBMGBtn.New(var1_15, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeLive2dBtn.New(var1_15, PlayerVitaeBaseBtn.HRZ_TYPE)
	}

	for iter0_15 = 1, #arg0_15.btns do
		arg0_15.btns[iter0_15]:setParent(arg0_15._tf:Find("adapt/toggleBtns"), #arg0_15.btns - iter0_15)
	end

	arg0_15.btnLive2dReset = arg0_15._tf:Find("adapt/btnLive2dReset")

	GetComponent(findTF(arg0_15.btnLive2dReset, "img"), typeof(Image)):SetNativeSize()
	GetComponent(arg0_15.btnLive2dReset, typeof(Image)):SetNativeSize()
	SetParent(arg0_15.btnLive2dReset, arg0_15._tf:Find("adapt/toggleBtns"))

	arg0_15.shipsPage = PlayerVitaeShipsPage.New(arg0_15._tf, arg0_15.event, arg0_15.contextData)
	arg0_15.detailPage = PlayerVitaeDetailPage.New(var0_15, arg0_15.event, arg0_15.contextData)

	setParent(arg0_15._tf:Find("adapt/toggleBtns"), arg0_15._tf:Find("detail"), true)

	arg0_15.contextData.renamePage = PlayerVitaeRenamePage.New(arg0_15._tf, arg0_15.event)
	arg0_15.topFrame = arg0_15._tf:Find("top/frame")

	local var2_15 = PlayerVitaeDetailPage.PreCalcAspect(var0_15, 1080)

	arg0_15.detailPosx = arg0_15._tf.rect.width * 0.5 - 937 * var2_15

	LoadSpriteAsync("CommonBG/bg_admiral", function(arg0_16)
		if IsNil(arg0_15.bg) then
			return
		end

		local var0_16 = arg0_15.bg:GetComponent(typeof(Image))

		var0_16.sprite = arg0_16
		var0_16.color = Color.New(1, 1, 1, 1)
	end)
end

function var0_0.didEnter(arg0_17)
	onButton(arg0_17, arg0_17.backBtn, function()
		if arg0_17.shipsPage:GetLoaded() and arg0_17.shipsPage:isShowing() then
			arg0_17.shipsPage:Hide()
			arg0_17:ShowOrHideMainView(true)
		else
			arg0_17:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17.switchSkinBtn, function()
		local var0_19 = arg0_17:GetFlagShip()

		arg0_17:emit(PlayerVitaeMediator.CHANGE_SKIN, var0_19)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.replaceBtn, function()
		arg0_17.shipsPage:ExecuteAction("Update")
		arg0_17:ShowOrHideMainView(false)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.cryptolaliaBtn, function()
		local var0_21 = arg0_17:GetFlagShip()

		arg0_17:emit(PlayerVitaeMediator.OPEN_CRYPTOLALIA, var0_21:getGroupId())
	end, SFX_PANEL)
	arg0_17:bind(var0_0.ON_PAGE_SWTICH, function(arg0_22, arg1_22)
		setActive(arg0_17.titlt, arg1_22 == var0_0.PAGE_DEFAULT)
		setActive(arg0_17.titltNative, arg1_22 == var0_0.PAGE_NATIVE_SHIPS)
		setActive(arg0_17.titltRandom, arg1_22 == var0_0.PAGE_RANDOM_SHIPS)
	end)

	local var0_17 = false

	if arg0_17.contextData.showSelectCharacters then
		arg0_17.contextData.showSelectCharacters = nil

		triggerButton(arg0_17.replaceBtn)
	else
		arg0_17:DoEnterAnimation()

		var0_17 = true
	end

	arg0_17:UpdatePainting()
	arg0_17:UpdateReplaceTip()
	arg0_17.detailPage:ExecuteAction("Show", arg0_17:GetPlayer(), var0_17)
	arg0_17:emit(var0_0.ON_PAGE_SWTICH, var0_0.PAGE_DEFAULT)
	arg0_17:checkShowResetL2dBtn()
end

function var0_0.UpdateReplaceTip(arg0_23)
	setActive(arg0_23.replaceBtnTip, getProxy(SettingsProxy):ShouldEducateCharTip() or getProxy(ActivityProxy):IsTipLoveLetterMail())
end

function var0_0.DoEnterAnimation(arg0_24)
	local function var0_24(arg0_25)
		local var0_25 = arg0_25.anchoredPosition3D

		arg0_25.anchoredPosition3D = Vector3(var0_25.x - 1200, var0_25.y, 0)

		LeanTween.value(arg0_25.gameObject, var0_25.x - 1200, var0_25.x, 0.2):setOnUpdate(System.Action_float(function(arg0_26)
			arg0_25.anchoredPosition3D = Vector3(arg0_26, var0_25.y, 0)
		end)):setDelay(0.1):setEase(LeanTweenType.easeInOutSine)
	end

	local var1_24 = {
		arg0_24.btnContainer,
		arg0_24.painting
	}

	for iter0_24, iter1_24 in ipairs(var1_24) do
		var0_24(iter1_24)
	end

	;(function(arg0_27)
		local var0_27 = arg0_27.localPosition

		arg0_27.localPosition = Vector3(var0_27.x, var0_27.y + 150, 0)

		LeanTween.moveLocalY(arg0_27.gameObject, var0_27.y, 0.2):setDelay(0.1):setEase(LeanTweenType.easeInOutSine)
	end)(arg0_24.topFrame)
end

function var0_0.ShowOrHideMainView(arg0_28, arg1_28)
	arg0_28.mainViewCg.alpha = arg1_28 and 1 or 0
	arg0_28.mainViewCg.blocksRaycasts = arg1_28
	arg0_28.detailCg.alpha = arg1_28 and 1 or 0
	arg0_28.detailCg.blocksRaycasts = arg1_28

	if arg1_28 then
		arg0_28:UpdatePainting()
		arg0_28:UpdateReplaceTip()
	end
end

function var0_0.UpdatePainting(arg0_29, arg1_29)
	local var0_29 = arg0_29:GetFlagShip()
	local var1_29 = false
	local var2_29 = {}

	for iter0_29, iter1_29 in ipairs(arg0_29.btns) do
		local var3_29 = iter1_29:IsActive(var0_29)

		if var3_29 then
			table.insert(var2_29, iter1_29)
		end

		iter1_29:Update(var3_29, #var2_29, var0_29)

		if var3_29 and not var1_29 and iter1_29:IsOverlap(arg0_29.detailPosx) then
			var1_29 = true
		end
	end

	if var1_29 then
		for iter2_29, iter3_29 in ipairs(var2_29) do
			iter3_29:SwitchToVecLayout()
		end
	end

	if not arg0_29.displaySkinID or arg0_29.displaySkinID ~= var0_29:getSkinId() or arg1_29 then
		arg0_29:ReturnPainting()

		local var4_29 = var0_29:getPainting()

		setPaintingPrefabAsync(arg0_29.painting, var4_29, "kanban")

		arg0_29.paintingName = var4_29

		local var5_29 = not HXSet.isHxSkin() and getProxy(ShipSkinProxy):HasFashion(var0_29)

		setActive(arg0_29.switchSkinBtn, var5_29 and not isa(var0_29, VirtualEducateCharShip))

		arg0_29.displaySkinID = var0_29:getSkinId()
	end

	local var6_29 = var0_29:getGroupId()

	setActive(arg0_29.cryptolaliaBtn, getProxy(PlayerProxy):getRawData():ExistCryptolalia(var6_29))
	arg0_29:updateSwitchSkinBtnTag()
	arg0_29:checkShowResetL2dBtn()
end

function var0_0.ReturnPainting(arg0_30)
	if arg0_30.paintingName then
		retPaintingPrefab(arg0_30.painting, arg0_30.paintingName)
	end

	arg0_30.paintingName = nil
end

function var0_0.updateSwitchSkinBtnTag(arg0_31)
	local var0_31 = arg0_31:GetFlagShip()

	setActive(arg0_31.switchSkinBtnTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0_31) > 0)
end

function var0_0.onBackPressed(arg0_32)
	if arg0_32.shipsPage and arg0_32.shipsPage:GetLoaded() and arg0_32.shipsPage:isShowing() then
		triggerButton(arg0_32.backBtn)

		return
	end

	if arg0_32.contextData.renamePage and arg0_32.contextData.renamePage:GetLoaded() and arg0_32.contextData.renamePage:isShowing() then
		arg0_32.contextData.renamePage:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_32)
end

function var0_0.checkShowResetL2dBtn(arg0_33)
	local var0_33 = arg0_33:GetFlagShip()

	if var0_33 and var0_33:GetSkinConfig().spine_use_live2d == 1 then
		setActive(arg0_33.btnLive2dReset, false)

		return
	end

	local var1_33 = "live2d/" .. string.lower(var0_33:getPainting())
	local var2_33 = HXSet.autoHxShiftPath(var1_33, nil, true)

	if not checkABExist(var2_33) then
		setActive(arg0_33.btnLive2dReset, false)

		return
	end

	setActive(arg0_33.btnLive2dReset, true)
	onButton(arg0_33, arg0_33.btnLive2dReset, function()
		if arg0_33:GetFlagShip() then
			local var0_34 = arg0_33:GetFlagShip()

			Live2dConst.ClearLive2dSave(var0_34:getSkinId(), var0_34.id)
			Live2dConst.SetLive2dDirty(var0_34:getSkinId(), var0_34.id)
		end
	end, SFX_CONFIRM)
end

function var0_0.willExit(arg0_35)
	arg0_35:ReturnPainting()

	if LeanTween.isTweening(arg0_35.painting.gameObject) then
		LeanTween.cancel(arg0_35.painting.gameObject)
	end

	for iter0_35, iter1_35 in ipairs(arg0_35.btns) do
		iter1_35:Dispose()
	end

	arg0_35.btns = nil

	if arg0_35.shipsPage then
		arg0_35.shipsPage:Destroy()

		arg0_35.shipsPage = nil
	end

	if arg0_35.detailPage then
		arg0_35.detailPage:Destroy()

		arg0_35.detailPage = nil
	end

	if arg0_35.contextData.renamePage then
		arg0_35.contextData.renamePage:Destroy()

		arg0_35.contextData.renamePage = nil
	end
end

return var0_0
