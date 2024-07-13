local var0_0 = class("PlayerVitaeScene", import("..base.BaseUI"))

var0_0.ON_PAGE_SWTICH = "PlayerVitaeScene:ON_PAGE_SWTICH"
var0_0.PAGE_DEFAULT = 1
var0_0.PAGE_NATIVE_SHIPS = 2
var0_0.PAGE_RANDOM_SHIPS = 3

function var0_0.getUIName(arg0_1)
	return "PlayerVitaeUI"
end

function var0_0.GetBGM(arg0_2)
	local var0_2 = arg0_2:GetFlagShip()
	local var1_2 = getProxy(SettingsProxy):IsBGMEnable()

	if var0_2:IsBgmSkin() and var1_2 then
		return var0_2:GetSkinBgm()
	else
		return "main"
	end
end

function var0_0.OnPlayerNameChange(arg0_3)
	if arg0_3.detailPage and arg0_3.detailPage:GetLoaded() then
		arg0_3.detailPage:OnPlayerNameChange(arg0_3:GetPlayer())
	end
end

function var0_0.OnShipSkinChanged(arg0_4, arg1_4)
	arg0_4:UpdatePainting()

	if arg0_4.shipsPage and arg0_4.shipsPage:GetLoaded() and arg0_4.shipsPage:isShowing() then
		arg0_4.shipsPage:UpdateCard(arg1_4.id)
	end
end

function var0_0.ReloadPanting(arg0_5, arg1_5)
	if arg0_5.displaySkinID and arg0_5.displaySkinID == arg1_5 then
		local var0_5 = arg0_5:GetFlagShip()

		arg0_5:ReturnPainting()

		local var1_5 = var0_5:getPainting()

		setPaintingPrefabAsync(arg0_5.painting, var1_5, "kanban")

		arg0_5.paintingName = var1_5
	end
end

function var0_0.RefreshShips(arg0_6)
	if arg0_6.shipsPage and arg0_6.shipsPage:GetLoaded() and arg0_6.shipsPage:isShowing() then
		arg0_6.shipsPage:RefreshShips()
	end
end

function var0_0.GetPlayer(arg0_7)
	return getProxy(PlayerProxy):getRawData()
end

function var0_0.GetFlagShip(arg0_8)
	return (arg0_8:GetPlayer():GetFlagShip())
end

function var0_0.init(arg0_9)
	arg0_9.bg = arg0_9:findTF("bg")
	arg0_9.backBtn = arg0_9:findTF("top/frame/back")
	arg0_9.mainViewCg = arg0_9:findTF("adapt"):GetComponent(typeof(CanvasGroup))
	arg0_9.mainTr = arg0_9.mainViewCg.gameObject.transform
	arg0_9.painting = arg0_9:findTF("adapt/paint")
	arg0_9.btnContainer = arg0_9:findTF("adapt/btns")
	arg0_9.switchSkinBtn = arg0_9:findTF("adapt/btns/swichSkin_btn")
	arg0_9.replaceBtn = arg0_9:findTF("adapt/btns/replace_btn")
	arg0_9.replaceBtnTip = arg0_9.replaceBtn:Find("tip")
	arg0_9.cryptolaliaBtn = arg0_9:findTF("adapt/btns/cryptolalia_btn")
	arg0_9.switchSkinBtnTag = arg0_9:findTF("Tag", arg0_9.switchSkinBtn)
	arg0_9.titlt = arg0_9:findTF("top/frame/title")
	arg0_9.titltNative = arg0_9:findTF("top/frame/title_native")
	arg0_9.titltRandom = arg0_9:findTF("top/frame/title_random")

	local var0_9 = arg0_9:findTF("detail")

	arg0_9.detailCg = GetOrAddComponent(var0_9, typeof(CanvasGroup))

	local var1_9 = arg0_9:findTF("adapt/tpl")

	setActive(var1_9, false)

	arg0_9.btns = {
		PlayerVitaeSpineBtn.New(var1_9, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeBGBtn.New(var1_9, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeBMGBtn.New(var1_9, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeLive2dBtn.New(var1_9, PlayerVitaeBaseBtn.HRZ_TYPE)
	}

	for iter0_9 = 1, #arg0_9.btns do
		arg0_9.btns[iter0_9]:setParent(arg0_9:findTF("adapt/toggleBtns"), #arg0_9.btns - iter0_9)
	end

	arg0_9.btnLive2dReset = arg0_9:findTF("adapt/btnLive2dReset")

	GetComponent(findTF(arg0_9.btnLive2dReset, "img"), typeof(Image)):SetNativeSize()
	GetComponent(arg0_9.btnLive2dReset, typeof(Image)):SetNativeSize()
	SetParent(arg0_9.btnLive2dReset, arg0_9:findTF("adapt/toggleBtns"))

	arg0_9.shipsPage = PlayerVitaeShipsPage.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)
	arg0_9.detailPage = PlayerVitaeDetailPage.New(var0_9, arg0_9.event, arg0_9.contextData)

	setParent(arg0_9:findTF("adapt/toggleBtns"), arg0_9:findTF("detail"), true)

	arg0_9.contextData.renamePage = PlayerVitaeRenamePage.New(arg0_9._tf, arg0_9.event)
	arg0_9.topFrame = arg0_9:findTF("top/frame")

	local var2_9 = PlayerVitaeDetailPage.PreCalcAspect(var0_9, 1080)

	arg0_9.detailPosx = arg0_9._tf.rect.width * 0.5 - 937 * var2_9

	LoadSpriteAsync("CommonBG/bg_admiral", function(arg0_10)
		if IsNil(arg0_9.bg) then
			return
		end

		local var0_10 = arg0_9.bg:GetComponent(typeof(Image))

		var0_10.sprite = arg0_10
		var0_10.color = Color.New(1, 1, 1, 1)
	end)
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11.backBtn, function()
		if arg0_11.shipsPage:GetLoaded() and arg0_11.shipsPage:isShowing() then
			arg0_11.shipsPage:Hide()
			arg0_11:ShowOrHideMainView(true)
		else
			arg0_11:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.switchSkinBtn, function()
		local var0_13 = arg0_11:GetFlagShip()

		arg0_11:emit(PlayerVitaeMediator.CHANGE_SKIN, var0_13)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.replaceBtn, function()
		arg0_11.shipsPage:ExecuteAction("Update")
		arg0_11:ShowOrHideMainView(false)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.cryptolaliaBtn, function()
		local var0_15 = arg0_11:GetFlagShip()

		arg0_11:emit(PlayerVitaeMediator.OPEN_CRYPTOLALIA, var0_15:getGroupId())
	end, SFX_PANEL)
	arg0_11:bind(var0_0.ON_PAGE_SWTICH, function(arg0_16, arg1_16)
		setActive(arg0_11.titlt, arg1_16 == var0_0.PAGE_DEFAULT)
		setActive(arg0_11.titltNative, arg1_16 == var0_0.PAGE_NATIVE_SHIPS)
		setActive(arg0_11.titltRandom, arg1_16 == var0_0.PAGE_RANDOM_SHIPS)
	end)

	local var0_11 = false

	if arg0_11.contextData.showSelectCharacters then
		arg0_11.contextData.showSelectCharacters = nil

		triggerButton(arg0_11.replaceBtn)
	else
		arg0_11:DoEnterAnimation()

		var0_11 = true
	end

	arg0_11:UpdatePainting()
	arg0_11:UpdateReplaceTip()
	arg0_11.detailPage:ExecuteAction("Show", arg0_11:GetPlayer(), var0_11)
	arg0_11:emit(var0_0.ON_PAGE_SWTICH, var0_0.PAGE_DEFAULT)
	arg0_11:checkShowResetL2dBtn()
end

function var0_0.UpdateReplaceTip(arg0_17)
	setActive(arg0_17.replaceBtnTip, getProxy(SettingsProxy):ShouldEducateCharTip())
end

function var0_0.DoEnterAnimation(arg0_18)
	local function var0_18(arg0_19)
		local var0_19 = arg0_19.anchoredPosition3D

		arg0_19.anchoredPosition3D = Vector3(var0_19.x - 1200, var0_19.y, 0)

		LeanTween.value(arg0_19.gameObject, var0_19.x - 1200, var0_19.x, 0.2):setOnUpdate(System.Action_float(function(arg0_20)
			arg0_19.anchoredPosition3D = Vector3(arg0_20, var0_19.y, 0)
		end)):setDelay(0.1):setEase(LeanTweenType.easeInOutSine)
	end

	local var1_18 = {
		arg0_18.btnContainer,
		arg0_18.painting
	}

	for iter0_18, iter1_18 in ipairs(var1_18) do
		var0_18(iter1_18)
	end

	;(function(arg0_21)
		local var0_21 = arg0_21.localPosition

		arg0_21.localPosition = Vector3(var0_21.x, var0_21.y + 150, 0)

		LeanTween.moveLocalY(arg0_21.gameObject, var0_21.y, 0.2):setDelay(0.1):setEase(LeanTweenType.easeInOutSine)
	end)(arg0_18.topFrame)
end

function var0_0.ShowOrHideMainView(arg0_22, arg1_22)
	arg0_22.mainViewCg.alpha = arg1_22 and 1 or 0
	arg0_22.mainViewCg.blocksRaycasts = arg1_22
	arg0_22.detailCg.alpha = arg1_22 and 1 or 0
	arg0_22.detailCg.blocksRaycasts = arg1_22

	if arg1_22 then
		arg0_22:UpdatePainting()
		arg0_22:UpdateReplaceTip()
	end
end

function var0_0.UpdatePainting(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetFlagShip()
	local var1_23 = false
	local var2_23 = {}

	for iter0_23, iter1_23 in ipairs(arg0_23.btns) do
		local var3_23 = iter1_23:IsActive(var0_23)

		if var3_23 then
			table.insert(var2_23, iter1_23)
		end

		iter1_23:Update(var3_23, #var2_23, var0_23)

		if var3_23 and not var1_23 and iter1_23:IsOverlap(arg0_23.detailPosx) then
			var1_23 = true
		end
	end

	if var1_23 then
		for iter2_23, iter3_23 in ipairs(var2_23) do
			iter3_23:SwitchToVecLayout()
		end
	end

	if not arg0_23.displaySkinID or arg0_23.displaySkinID ~= var0_23.skinId or arg1_23 then
		arg0_23:ReturnPainting()

		local var4_23 = var0_23:getPainting()

		setPaintingPrefabAsync(arg0_23.painting, var4_23, "kanban")

		arg0_23.paintingName = var4_23

		local var5_23 = not HXSet.isHxSkin() and getProxy(ShipSkinProxy):HasFashion(var0_23)

		setActive(arg0_23.switchSkinBtn, var5_23 and not isa(var0_23, VirtualEducateCharShip))

		arg0_23.displaySkinID = var0_23.skinId
	end

	local var6_23 = var0_23:getGroupId()

	setActive(arg0_23.cryptolaliaBtn, getProxy(PlayerProxy):getRawData():ExistCryptolalia(var6_23))
	arg0_23:updateSwitchSkinBtnTag()
	arg0_23:checkShowResetL2dBtn()
end

function var0_0.ReturnPainting(arg0_24)
	if arg0_24.paintingName then
		retPaintingPrefab(arg0_24.painting, arg0_24.paintingName)
	end

	arg0_24.paintingName = nil
end

function var0_0.updateSwitchSkinBtnTag(arg0_25)
	local var0_25 = arg0_25:GetFlagShip()

	setActive(arg0_25.switchSkinBtnTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0_25) > 0)
end

function var0_0.onBackPressed(arg0_26)
	if arg0_26.shipsPage and arg0_26.shipsPage:GetLoaded() and arg0_26.shipsPage:isShowing() then
		triggerButton(arg0_26.backBtn)

		return
	end

	if arg0_26.contextData.renamePage and arg0_26.contextData.renamePage:GetLoaded() and arg0_26.contextData.renamePage:isShowing() then
		arg0_26.contextData.renamePage:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_26)
end

function var0_0.checkShowResetL2dBtn(arg0_27)
	local var0_27 = arg0_27:GetFlagShip()

	if var0_27 and var0_27:GetSkinConfig().spine_use_live2d == 1 then
		setActive(arg0_27.btnLive2dReset, false)

		return
	end

	local var1_27 = "live2d/" .. string.lower(var0_27:getPainting())
	local var2_27 = HXSet.autoHxShiftPath(var1_27, nil, true)

	if not checkABExist(var2_27) then
		setActive(arg0_27.btnLive2dReset, false)

		return
	end

	setActive(arg0_27.btnLive2dReset, true)
	onButton(arg0_27, arg0_27.btnLive2dReset, function()
		if arg0_27:GetFlagShip() then
			local var0_28 = arg0_27:GetFlagShip()

			Live2dConst.ClearLive2dSave(var0_28.skinId, var0_28.id)
		end
	end, SFX_CONFIRM)
end

function var0_0.willExit(arg0_29)
	arg0_29:ReturnPainting()

	if LeanTween.isTweening(arg0_29.painting.gameObject) then
		LeanTween.cancel(arg0_29.painting.gameObject)
	end

	for iter0_29, iter1_29 in ipairs(arg0_29.btns) do
		iter1_29:Dispose()
	end

	arg0_29.btns = nil

	if arg0_29.shipsPage then
		arg0_29.shipsPage:Destroy()

		arg0_29.shipsPage = nil
	end

	if arg0_29.detailPage then
		arg0_29.detailPage:Destroy()

		arg0_29.detailPage = nil
	end

	if arg0_29.contextData.renamePage then
		arg0_29.contextData.renamePage:Destroy()

		arg0_29.contextData.renamePage = nil
	end
end

return var0_0
