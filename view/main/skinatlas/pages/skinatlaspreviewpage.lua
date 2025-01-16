local var0_0 = class("SkinAtlasPreviewPage", import("....base.BaseSubView"))

var0_0.ON_BG_SWITCH_DONE = "SkinAtlasScene:ON_BG_SWITCH_DONE"
var0_0.ON_L2D_SWITCH_DONE = "SkinAtlasScene:ON_L2D_SWITCH_DONE"

function var0_0.getUIName(arg0_1)
	return "SkinAtlasPreviewPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.paintingTr = arg0_2:findTF("paint")
	arg0_2.live2dContainer = arg0_2:findTF("paint/live2d")
	arg0_2.mainImg = arg0_2:findTF("main"):GetComponent(typeof(UnityEngine.UI.Graphic))
	arg0_2.backBtn = arg0_2:findTF("main/left/back")
	arg0_2.nameTxt = arg0_2:findTF("main/left/name_bg/skin_name"):GetComponent(typeof(Text))
	arg0_2.shipnameTxt = arg0_2:findTF("main/left/name_bg/name"):GetComponent(typeof(Text))
	arg0_2.charParent = arg0_2:findTF("main/right/char")
	arg0_2.viewBtn = arg0_2:findTF("main/right/view_btn")
	arg0_2.changeBtn = arg0_2:findTF("main/right/change_btn")
	arg0_2.changeBtnDis = arg0_2.changeBtn:Find("dis")
	arg0_2.changeBtnEn = arg0_2.changeBtn:Find("en")
	arg0_2.obtainBtn = arg0_2:findTF("main/right/obtain_btn")
	arg0_2.bgFlag = true
	arg0_2.l2dFlag = false

	local var0_2 = arg0_2:findTF("main/left/tpl")

	arg0_2.btns = {
		ShipAtlasBgBtn.New(var0_2, PlayerVitaeBaseBtn.HRZ_TYPE, arg0_2.event, arg0_2.bgFlag),
		ShipAtlasLive2dBtn.New(var0_2, PlayerVitaeBaseBtn.HRZ_TYPE, arg0_2.event, arg0_2.l2dFlag)
	}
	arg0_2.changeSkinUI = arg0_2:findTF("main/bottom/changeSkin")
	arg0_2.changeSkinToggle = ChangeSkinToggle.New(findTF(arg0_2.changeSkinUI, "ChangeSkinToggleUI"))
	arg0_2.bgView = SkinAtlasBgView.New(arg0_2:findTF("bg/bg"))
	arg0_2.paintingView = SkinAtlasPaintingView.New(arg0_2:findTF("paint"))
	arg0_2.selectShipPage = ChangeShipSkinPage.New(arg0_2._parentTf, arg0_2.event)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.viewBtn, function()
		arg0_3.mainImg.enabled = false

		arg0_3.paintingView:Enter()

		if arg0_3.live2d then
			arg0_3.live2d:OpenClick()
		end
	end, SFX_PANEL)

	local var0_3 = arg0_3._tf:GetComponent(typeof(PinchZoom))

	onButton(arg0_3, arg0_3._tf, function()
		if var0_3.processing then
			return
		end

		arg0_3.mainImg.enabled = true

		arg0_3.paintingView:Exit()

		if arg0_3.live2d then
			arg0_3.live2d:CloseClick()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.changeBtn, function()
		if arg0_3.skin:CantUse() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_ship_to_wear"))

			return
		end

		arg0_3.selectShipPage:ExecuteAction("Show", arg0_3.skin)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.obtainBtn, function()
		local var0_8 = arg0_3.skin:getConfig("ship_group")
		local var1_8 = ShipGroup.New({
			id = var0_8
		})
		local var2_8 = {
			type = MSGBOX_TYPE_OBTAIN,
			shipId = var1_8:getShipConfigId(),
			list = var1_8.groupConfig.description,
			mediatorName = SkinAtlasMediator.__cname
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox(var2_8)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.changeSkinUI, function()
		if ShipGroup.GetChangeSkinData(arg0_3.skin.id) then
			local var0_9 = ShipSkin.New({
				id = ShipGroup.GetChangeSkinNextId(arg0_3.skin.id)
			})

			arg0_3:Flush(var0_9, arg0_3.index)
		end
	end, SFX_PANEL)
	arg0_3:bind(var0_0.ON_BG_SWITCH_DONE, function(arg0_10, arg1_10)
		arg0_3.bgFlag = arg1_10

		arg0_3.bgView:Init(arg0_3.ship, arg0_3.bgFlag)
	end)
	arg0_3:bind(var0_0.ON_L2D_SWITCH_DONE, function(arg0_11, arg1_11)
		arg0_3.l2dFlag = arg1_11

		arg0_3:UpdatePainting(arg0_3.ship)
	end)
	addSlip(SLIP_TYPE_HRZ, arg0_3:findTF("main"), function()
		arg0_3:OnPrev()
	end, function()
		arg0_3:OnNext()
	end)
end

function var0_0.OnNext(arg0_14)
	if arg0_14.loading then
		return
	end

	arg0_14:emit(SkinAtlasScene.ON_NEXT_SKIN, arg0_14.index)
end

function var0_0.OnPrev(arg0_15)
	if arg0_15.loading then
		return
	end

	arg0_15:emit(SkinAtlasScene.ON_PREV_SKIN, arg0_15.index)
end

function var0_0.Show(arg0_16, arg1_16, arg2_16)
	var0_0.super.Show(arg0_16)

	arg0_16.index = arg2_16
	arg0_16.skin = arg1_16
	arg0_16.bgFlag = true
	arg0_16.l2dFlag = false

	local var0_16 = arg0_16.skin:ToShip()

	assert(var0_16)

	arg0_16.ship = var0_16

	arg0_16:UpdateMain(var0_16)

	local var1_16 = arg0_16.skin:CantUse()

	setActive(arg0_16.changeBtnDis, var1_16)
	setActive(arg0_16.changeBtnEn, not var1_16)

	local var2_16 = ShipGroup.GetChangeSkinData(arg0_16.skin.id)

	setActive(arg0_16.changeSkinUI, var2_16 and true or false)
	arg0_16.changeSkinToggle:setSkinData(arg0_16.skin.id)
	setActive(arg0_16.obtainBtn, not arg0_16.skin:OwnShip())
end

function var0_0.Flush(arg0_17, arg1_17, arg2_17)
	arg0_17:Clear()
	arg0_17:Show(arg1_17, arg2_17)
end

function var0_0.UpdateMain(arg0_18, arg1_18)
	local var0_18 = 0

	for iter0_18, iter1_18 in ipairs(arg0_18.btns) do
		local var1_18 = iter1_18:IsActive(arg1_18)

		if var1_18 then
			var0_18 = var0_18 + 1
		end

		iter1_18:Update(var1_18, var0_18, arg1_18)
	end

	arg0_18.nameTxt.text = arg0_18.skin:getConfig("name")
	arg0_18.shipnameTxt.text = arg1_18:getName()
	arg0_18.loading = true

	parallelAsync({
		function(arg0_19)
			arg0_18.bgView:Init(arg1_18, arg0_18.bgFlag, arg0_19)
		end,
		function(arg0_20)
			arg0_18:UpdatePainting(arg1_18, arg0_20)
		end,
		function(arg0_21)
			arg0_18:UpdateChar(arg1_18, arg0_21)
		end
	}, function()
		arg0_18.loading = false
	end)
end

function var0_0.UpdatePainting(arg0_23, arg1_23, arg2_23)
	if arg0_23.l2dFlag then
		arg0_23:InitL2D(arg1_23, arg2_23)
	else
		arg0_23:InitPainting(arg1_23, arg2_23)
	end
end

function var0_0.InitPainting(arg0_24, arg1_24, arg2_24)
	arg0_24:ClearPainting(arg1_24)
	setActive(arg0_24.live2dContainer, false)

	arg0_24.painting = arg1_24:getPainting()

	setPaintingPrefabAsync(arg0_24.paintingTr, arg0_24.painting, "chuanwu", arg2_24)
end

function var0_0.InitL2D(arg0_25, arg1_25, arg2_25)
	arg0_25:ClearPainting(arg1_25)

	arg0_25.live2d = SkinAtlasLive2dView.New(arg1_25, arg0_25.live2dContainer, arg2_25)

	arg0_25.live2d.live2dChar:changeTriggerFlag(false)
end

function var0_0.UpdateChar(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg1_26:getPrefab()

	PoolMgr.GetInstance():GetSpineChar(var0_26, true, function(arg0_27)
		arg0_26.modelTf = tf(arg0_27)
		arg0_26.modelTf.localScale = Vector3(0.9, 0.9, 1)
		arg0_26.modelTf.localPosition = Vector3(0, -135, 0)

		pg.ViewUtils.SetLayer(arg0_26.modelTf, Layer.UI)
		setParent(arg0_26.modelTf, arg0_26.charParent)
		arg0_27:GetComponent("SpineAnimUI"):SetAction("normal", 0)
		arg2_26()
	end)
end

function var0_0.ClearPainting(arg0_28, arg1_28)
	if arg0_28.live2d then
		arg0_28.live2d:Dispose()

		arg0_28.live2d = nil
	elseif arg0_28.painting then
		retPaintingPrefab(arg0_28.paintingTr, arg0_28.painting)

		arg0_28.painting = nil
	end
end

function var0_0.ClearChar(arg0_29, arg1_29)
	if arg0_29.modelTf then
		PoolMgr.GetInstance():ReturnSpineChar(arg1_29:getPrefab(), arg0_29.modelTf.gameObject)

		arg0_29.modelTf = nil
	end
end

function var0_0.Clear(arg0_30)
	local var0_30 = arg0_30.ship

	if var0_30 then
		arg0_30:ClearPainting(var0_30)
		arg0_30:ClearChar(var0_30)

		arg0_30.ship = nil
	end
end

function var0_0.Hide(arg0_31)
	var0_0.super.Hide(arg0_31)
	arg0_31:Clear()

	arg0_31.skin = nil

	arg0_31.bgView:Clear()

	if arg0_31.paintingView:IsEnter() then
		arg0_31.paintingView:Exit()
	end
end

function var0_0.IsShowSelectShipView(arg0_32)
	return arg0_32.selectShipPage and arg0_32.selectShipPage:GetLoaded() and arg0_32.selectShipPage:isShowing()
end

function var0_0.CloseSelectShipView(arg0_33)
	arg0_33.selectShipPage:Hide()
end

function var0_0.OnDestroy(arg0_34)
	if arg0_34:isShowing() then
		arg0_34:Hide()
	end

	for iter0_34, iter1_34 in ipairs(arg0_34.btns) do
		iter1_34:Dispose()
	end

	arg0_34.btns = nil

	arg0_34.bgView:Dispose()

	arg0_34.bgView = nil

	arg0_34.selectShipPage:Destroy()

	arg0_34.selectShipPage = nil

	arg0_34.paintingView:Dispose()

	arg0_34.paintingView = nil
end

return var0_0
