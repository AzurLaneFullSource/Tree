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
	arg0_3:bind(var0_0.ON_BG_SWITCH_DONE, function(arg0_9, arg1_9)
		arg0_3.bgFlag = arg1_9

		arg0_3.bgView:Init(arg0_3.ship, arg0_3.bgFlag)
	end)
	arg0_3:bind(var0_0.ON_L2D_SWITCH_DONE, function(arg0_10, arg1_10)
		arg0_3.l2dFlag = arg1_10

		arg0_3:UpdatePainting(arg0_3.ship)
	end)
	addSlip(SLIP_TYPE_HRZ, arg0_3:findTF("main"), function()
		arg0_3:OnPrev()
	end, function()
		arg0_3:OnNext()
	end)
end

function var0_0.OnNext(arg0_13)
	if arg0_13.loading then
		return
	end

	arg0_13:emit(SkinAtlasScene.ON_NEXT_SKIN, arg0_13.index)
end

function var0_0.OnPrev(arg0_14)
	if arg0_14.loading then
		return
	end

	arg0_14:emit(SkinAtlasScene.ON_PREV_SKIN, arg0_14.index)
end

function var0_0.Show(arg0_15, arg1_15, arg2_15)
	var0_0.super.Show(arg0_15)

	arg0_15.index = arg2_15
	arg0_15.skin = arg1_15
	arg0_15.bgFlag = true
	arg0_15.l2dFlag = false

	local var0_15 = arg0_15.skin:ToShip()

	assert(var0_15)

	arg0_15.ship = var0_15

	arg0_15:UpdateMain(var0_15)

	local var1_15 = arg0_15.skin:CantUse()

	setActive(arg0_15.changeBtnDis, var1_15)
	setActive(arg0_15.changeBtnEn, not var1_15)
	setActive(arg0_15.obtainBtn, not arg0_15.skin:OwnShip())
end

function var0_0.Flush(arg0_16, arg1_16, arg2_16)
	arg0_16:Clear()
	arg0_16:Show(arg1_16, arg2_16)
end

function var0_0.UpdateMain(arg0_17, arg1_17)
	local var0_17 = 0

	for iter0_17, iter1_17 in ipairs(arg0_17.btns) do
		local var1_17 = iter1_17:IsActive(arg1_17)

		if var1_17 then
			var0_17 = var0_17 + 1
		end

		iter1_17:Update(var1_17, var0_17, arg1_17)
	end

	arg0_17.nameTxt.text = arg0_17.skin:getConfig("name")
	arg0_17.shipnameTxt.text = arg1_17:getName()
	arg0_17.loading = true

	parallelAsync({
		function(arg0_18)
			arg0_17.bgView:Init(arg1_17, arg0_17.bgFlag, arg0_18)
		end,
		function(arg0_19)
			arg0_17:UpdatePainting(arg1_17, arg0_19)
		end,
		function(arg0_20)
			arg0_17:UpdateChar(arg1_17, arg0_20)
		end
	}, function()
		arg0_17.loading = false
	end)
end

function var0_0.UpdatePainting(arg0_22, arg1_22, arg2_22)
	if arg0_22.l2dFlag then
		arg0_22:InitL2D(arg1_22, arg2_22)
	else
		arg0_22:InitPainting(arg1_22, arg2_22)
	end
end

function var0_0.InitPainting(arg0_23, arg1_23, arg2_23)
	arg0_23:ClearPainting(arg1_23)
	setActive(arg0_23.live2dContainer, false)

	arg0_23.painting = arg1_23:getPainting()

	setPaintingPrefabAsync(arg0_23.paintingTr, arg0_23.painting, "chuanwu", arg2_23)
end

function var0_0.InitL2D(arg0_24, arg1_24, arg2_24)
	arg0_24:ClearPainting(arg1_24)

	arg0_24.live2d = SkinAtlasLive2dView.New(arg1_24, arg0_24.live2dContainer, arg2_24)

	arg0_24.live2d.live2dChar:changeTriggerFlag(false)
end

function var0_0.UpdateChar(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg1_25:getPrefab()

	PoolMgr.GetInstance():GetSpineChar(var0_25, true, function(arg0_26)
		arg0_25.modelTf = tf(arg0_26)
		arg0_25.modelTf.localScale = Vector3(0.9, 0.9, 1)
		arg0_25.modelTf.localPosition = Vector3(0, -135, 0)

		pg.ViewUtils.SetLayer(arg0_25.modelTf, Layer.UI)
		setParent(arg0_25.modelTf, arg0_25.charParent)
		arg0_26:GetComponent("SpineAnimUI"):SetAction("normal", 0)
		arg2_25()
	end)
end

function var0_0.ClearPainting(arg0_27, arg1_27)
	if arg0_27.live2d then
		arg0_27.live2d:Dispose()

		arg0_27.live2d = nil
	elseif arg0_27.painting then
		retPaintingPrefab(arg0_27.paintingTr, arg0_27.painting)

		arg0_27.painting = nil
	end
end

function var0_0.ClearChar(arg0_28, arg1_28)
	if arg0_28.modelTf then
		PoolMgr.GetInstance():ReturnSpineChar(arg1_28:getPrefab(), arg0_28.modelTf.gameObject)

		arg0_28.modelTf = nil
	end
end

function var0_0.Clear(arg0_29)
	local var0_29 = arg0_29.ship

	if var0_29 then
		arg0_29:ClearPainting(var0_29)
		arg0_29:ClearChar(var0_29)

		arg0_29.ship = nil
	end
end

function var0_0.Hide(arg0_30)
	var0_0.super.Hide(arg0_30)
	arg0_30:Clear()

	arg0_30.skin = nil

	arg0_30.bgView:Clear()

	if arg0_30.paintingView:IsEnter() then
		arg0_30.paintingView:Exit()
	end
end

function var0_0.IsShowSelectShipView(arg0_31)
	return arg0_31.selectShipPage and arg0_31.selectShipPage:GetLoaded() and arg0_31.selectShipPage:isShowing()
end

function var0_0.CloseSelectShipView(arg0_32)
	arg0_32.selectShipPage:Hide()
end

function var0_0.OnDestroy(arg0_33)
	if arg0_33:isShowing() then
		arg0_33:Hide()
	end

	for iter0_33, iter1_33 in ipairs(arg0_33.btns) do
		iter1_33:Dispose()
	end

	arg0_33.btns = nil

	arg0_33.bgView:Dispose()

	arg0_33.bgView = nil

	arg0_33.selectShipPage:Destroy()

	arg0_33.selectShipPage = nil

	arg0_33.paintingView:Dispose()

	arg0_33.paintingView = nil
end

return var0_0
