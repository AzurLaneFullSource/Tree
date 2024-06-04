local var0 = class("PlayerVitaeScene", import("..base.BaseUI"))

var0.ON_PAGE_SWTICH = "PlayerVitaeScene:ON_PAGE_SWTICH"
var0.PAGE_DEFAULT = 1
var0.PAGE_NATIVE_SHIPS = 2
var0.PAGE_RANDOM_SHIPS = 3

function var0.getUIName(arg0)
	return "PlayerVitaeUI"
end

function var0.GetBGM(arg0)
	local var0 = arg0:GetFlagShip()
	local var1 = getProxy(SettingsProxy):IsBGMEnable()

	if var0:IsBgmSkin() and var1 then
		return var0:GetSkinBgm()
	else
		return "main"
	end
end

function var0.OnPlayerNameChange(arg0)
	if arg0.detailPage and arg0.detailPage:GetLoaded() then
		arg0.detailPage:OnPlayerNameChange(arg0:GetPlayer())
	end
end

function var0.OnShipSkinChanged(arg0, arg1)
	arg0:UpdatePainting()

	if arg0.shipsPage and arg0.shipsPage:GetLoaded() and arg0.shipsPage:isShowing() then
		arg0.shipsPage:UpdateCard(arg1.id)
	end
end

function var0.ReloadPanting(arg0, arg1)
	if arg0.displaySkinID and arg0.displaySkinID == arg1 then
		local var0 = arg0:GetFlagShip()

		arg0:ReturnPainting()

		local var1 = var0:getPainting()

		setPaintingPrefabAsync(arg0.painting, var1, "kanban")

		arg0.paintingName = var1
	end
end

function var0.RefreshShips(arg0)
	if arg0.shipsPage and arg0.shipsPage:GetLoaded() and arg0.shipsPage:isShowing() then
		arg0.shipsPage:RefreshShips()
	end
end

function var0.GetPlayer(arg0)
	return getProxy(PlayerProxy):getRawData()
end

function var0.GetFlagShip(arg0)
	return (arg0:GetPlayer():GetFlagShip())
end

function var0.init(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.backBtn = arg0:findTF("top/frame/back")
	arg0.mainViewCg = arg0:findTF("adapt"):GetComponent(typeof(CanvasGroup))
	arg0.mainTr = arg0.mainViewCg.gameObject.transform
	arg0.painting = arg0:findTF("adapt/paint")
	arg0.btnContainer = arg0:findTF("adapt/btns")
	arg0.switchSkinBtn = arg0:findTF("adapt/btns/swichSkin_btn")
	arg0.replaceBtn = arg0:findTF("adapt/btns/replace_btn")
	arg0.replaceBtnTip = arg0.replaceBtn:Find("tip")
	arg0.cryptolaliaBtn = arg0:findTF("adapt/btns/cryptolalia_btn")
	arg0.switchSkinBtnTag = arg0:findTF("Tag", arg0.switchSkinBtn)
	arg0.titlt = arg0:findTF("top/frame/title")
	arg0.titltNative = arg0:findTF("top/frame/title_native")
	arg0.titltRandom = arg0:findTF("top/frame/title_random")

	local var0 = arg0:findTF("detail")

	arg0.detailCg = GetOrAddComponent(var0, typeof(CanvasGroup))

	local var1 = arg0:findTF("adapt/tpl")

	setActive(var1, false)

	arg0.btns = {
		PlayerVitaeSpineBtn.New(var1, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeBGBtn.New(var1, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeBMGBtn.New(var1, PlayerVitaeBaseBtn.HRZ_TYPE),
		PlayerVitaeLive2dBtn.New(var1, PlayerVitaeBaseBtn.HRZ_TYPE)
	}

	for iter0 = 1, #arg0.btns do
		arg0.btns[iter0]:setParent(arg0:findTF("adapt/toggleBtns"), #arg0.btns - iter0)
	end

	arg0.btnLive2dReset = arg0:findTF("adapt/btnLive2dReset")

	GetComponent(findTF(arg0.btnLive2dReset, "img"), typeof(Image)):SetNativeSize()
	GetComponent(arg0.btnLive2dReset, typeof(Image)):SetNativeSize()
	SetParent(arg0.btnLive2dReset, arg0:findTF("adapt/toggleBtns"))

	arg0.shipsPage = PlayerVitaeShipsPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.detailPage = PlayerVitaeDetailPage.New(var0, arg0.event, arg0.contextData)

	setParent(arg0:findTF("adapt/toggleBtns"), arg0:findTF("detail"), true)

	arg0.contextData.renamePage = PlayerVitaeRenamePage.New(arg0._tf, arg0.event)
	arg0.topFrame = arg0:findTF("top/frame")

	local var2 = PlayerVitaeDetailPage.PreCalcAspect(var0, 1080)

	arg0.detailPosx = arg0._tf.rect.width * 0.5 - 937 * var2

	LoadSpriteAsync("CommonBG/bg_admiral", function(arg0)
		if IsNil(arg0.bg) then
			return
		end

		local var0 = arg0.bg:GetComponent(typeof(Image))

		var0.sprite = arg0
		var0.color = Color.New(1, 1, 1, 1)
	end)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		if arg0.shipsPage:GetLoaded() and arg0.shipsPage:isShowing() then
			arg0.shipsPage:Hide()
			arg0:ShowOrHideMainView(true)
		else
			arg0:emit(var0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.switchSkinBtn, function()
		local var0 = arg0:GetFlagShip()

		arg0:emit(PlayerVitaeMediator.CHANGE_SKIN, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.replaceBtn, function()
		arg0.shipsPage:ExecuteAction("Update")
		arg0:ShowOrHideMainView(false)
	end, SFX_PANEL)
	onButton(arg0, arg0.cryptolaliaBtn, function()
		local var0 = arg0:GetFlagShip()

		arg0:emit(PlayerVitaeMediator.OPEN_CRYPTOLALIA, var0:getGroupId())
	end, SFX_PANEL)
	arg0:bind(var0.ON_PAGE_SWTICH, function(arg0, arg1)
		setActive(arg0.titlt, arg1 == var0.PAGE_DEFAULT)
		setActive(arg0.titltNative, arg1 == var0.PAGE_NATIVE_SHIPS)
		setActive(arg0.titltRandom, arg1 == var0.PAGE_RANDOM_SHIPS)
	end)

	local var0 = false

	if arg0.contextData.showSelectCharacters then
		arg0.contextData.showSelectCharacters = nil

		triggerButton(arg0.replaceBtn)
	else
		arg0:DoEnterAnimation()

		var0 = true
	end

	arg0:UpdatePainting()
	arg0:UpdateReplaceTip()
	arg0.detailPage:ExecuteAction("Show", arg0:GetPlayer(), var0)
	arg0:emit(var0.ON_PAGE_SWTICH, var0.PAGE_DEFAULT)
	arg0:checkShowResetL2dBtn()
end

function var0.UpdateReplaceTip(arg0)
	setActive(arg0.replaceBtnTip, getProxy(SettingsProxy):ShouldEducateCharTip())
end

function var0.DoEnterAnimation(arg0)
	local function var0(arg0)
		local var0 = arg0.anchoredPosition3D

		arg0.anchoredPosition3D = Vector3(var0.x - 1200, var0.y, 0)

		LeanTween.value(arg0.gameObject, var0.x - 1200, var0.x, 0.2):setOnUpdate(System.Action_float(function(arg0)
			arg0.anchoredPosition3D = Vector3(arg0, var0.y, 0)
		end)):setDelay(0.1):setEase(LeanTweenType.easeInOutSine)
	end

	local var1 = {
		arg0.btnContainer,
		arg0.painting
	}

	for iter0, iter1 in ipairs(var1) do
		var0(iter1)
	end

	;(function(arg0)
		local var0 = arg0.localPosition

		arg0.localPosition = Vector3(var0.x, var0.y + 150, 0)

		LeanTween.moveLocalY(arg0.gameObject, var0.y, 0.2):setDelay(0.1):setEase(LeanTweenType.easeInOutSine)
	end)(arg0.topFrame)
end

function var0.ShowOrHideMainView(arg0, arg1)
	arg0.mainViewCg.alpha = arg1 and 1 or 0
	arg0.mainViewCg.blocksRaycasts = arg1
	arg0.detailCg.alpha = arg1 and 1 or 0
	arg0.detailCg.blocksRaycasts = arg1

	if arg1 then
		arg0:UpdatePainting()
		arg0:UpdateReplaceTip()
	end
end

function var0.UpdatePainting(arg0, arg1)
	local var0 = arg0:GetFlagShip()
	local var1 = false
	local var2 = {}

	for iter0, iter1 in ipairs(arg0.btns) do
		local var3 = iter1:IsActive(var0)

		if var3 then
			table.insert(var2, iter1)
		end

		iter1:Update(var3, #var2, var0)

		if var3 and not var1 and iter1:IsOverlap(arg0.detailPosx) then
			var1 = true
		end
	end

	if var1 then
		for iter2, iter3 in ipairs(var2) do
			iter3:SwitchToVecLayout()
		end
	end

	if not arg0.displaySkinID or arg0.displaySkinID ~= var0.skinId or arg1 then
		arg0:ReturnPainting()

		local var4 = var0:getPainting()

		setPaintingPrefabAsync(arg0.painting, var4, "kanban")

		arg0.paintingName = var4

		local var5 = not HXSet.isHxSkin() and getProxy(ShipSkinProxy):HasFashion(var0)

		setActive(arg0.switchSkinBtn, var5 and not isa(var0, VirtualEducateCharShip))

		arg0.displaySkinID = var0.skinId
	end

	local var6 = var0:getGroupId()

	setActive(arg0.cryptolaliaBtn, getProxy(PlayerProxy):getRawData():ExistCryptolalia(var6))
	arg0:updateSwitchSkinBtnTag()
	arg0:checkShowResetL2dBtn()
end

function var0.ReturnPainting(arg0)
	if arg0.paintingName then
		retPaintingPrefab(arg0.painting, arg0.paintingName)
	end

	arg0.paintingName = nil
end

function var0.updateSwitchSkinBtnTag(arg0)
	local var0 = arg0:GetFlagShip()

	setActive(arg0.switchSkinBtnTag, #PaintingGroupConst.GetPaintingNameListByShipVO(var0) > 0)
end

function var0.onBackPressed(arg0)
	if arg0.shipsPage and arg0.shipsPage:GetLoaded() and arg0.shipsPage:isShowing() then
		triggerButton(arg0.backBtn)

		return
	end

	if arg0.contextData.renamePage and arg0.contextData.renamePage:GetLoaded() and arg0.contextData.renamePage:isShowing() then
		arg0.contextData.renamePage:Hide()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.checkShowResetL2dBtn(arg0)
	local var0 = arg0:GetFlagShip()

	if var0 and var0:GetSkinConfig().spine_use_live2d == 1 then
		setActive(arg0.btnLive2dReset, false)

		return
	end

	local var1 = "live2d/" .. string.lower(var0:getPainting())
	local var2 = HXSet.autoHxShiftPath(var1, nil, true)

	if not checkABExist(var2) then
		setActive(arg0.btnLive2dReset, false)

		return
	end

	setActive(arg0.btnLive2dReset, true)
	onButton(arg0, arg0.btnLive2dReset, function()
		if arg0:GetFlagShip() then
			local var0 = arg0:GetFlagShip()

			Live2dConst.ClearLive2dSave(var0.skinId, var0.id)
		end
	end, SFX_CONFIRM)
end

function var0.willExit(arg0)
	arg0:ReturnPainting()

	if LeanTween.isTweening(arg0.painting.gameObject) then
		LeanTween.cancel(arg0.painting.gameObject)
	end

	for iter0, iter1 in ipairs(arg0.btns) do
		iter1:Dispose()
	end

	arg0.btns = nil

	if arg0.shipsPage then
		arg0.shipsPage:Destroy()

		arg0.shipsPage = nil
	end

	if arg0.detailPage then
		arg0.detailPage:Destroy()

		arg0.detailPage = nil
	end

	if arg0.contextData.renamePage then
		arg0.contextData.renamePage:Destroy()

		arg0.contextData.renamePage = nil
	end
end

return var0
