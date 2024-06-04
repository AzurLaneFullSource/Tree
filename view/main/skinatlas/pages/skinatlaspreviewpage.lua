local var0 = class("SkinAtlasPreviewPage", import("....base.BaseSubView"))

var0.ON_BG_SWITCH_DONE = "SkinAtlasScene:ON_BG_SWITCH_DONE"
var0.ON_L2D_SWITCH_DONE = "SkinAtlasScene:ON_L2D_SWITCH_DONE"

function var0.getUIName(arg0)
	return "SkinAtlasPreviewPage"
end

function var0.OnLoaded(arg0)
	arg0.paintingTr = arg0:findTF("paint")
	arg0.live2dContainer = arg0:findTF("paint/live2d")
	arg0.mainImg = arg0:findTF("main"):GetComponent(typeof(UnityEngine.UI.Graphic))
	arg0.backBtn = arg0:findTF("main/left/back")
	arg0.nameTxt = arg0:findTF("main/left/name_bg/skin_name"):GetComponent(typeof(Text))
	arg0.shipnameTxt = arg0:findTF("main/left/name_bg/name"):GetComponent(typeof(Text))
	arg0.charParent = arg0:findTF("main/right/char")
	arg0.viewBtn = arg0:findTF("main/right/view_btn")
	arg0.changeBtn = arg0:findTF("main/right/change_btn")
	arg0.changeBtnDis = arg0.changeBtn:Find("dis")
	arg0.changeBtnEn = arg0.changeBtn:Find("en")
	arg0.obtainBtn = arg0:findTF("main/right/obtain_btn")
	arg0.bgFlag = true
	arg0.l2dFlag = false

	local var0 = arg0:findTF("main/left/tpl")

	arg0.btns = {
		ShipAtlasBgBtn.New(var0, PlayerVitaeBaseBtn.HRZ_TYPE, arg0.event, arg0.bgFlag),
		ShipAtlasLive2dBtn.New(var0, PlayerVitaeBaseBtn.HRZ_TYPE, arg0.event, arg0.l2dFlag)
	}
	arg0.bgView = SkinAtlasBgView.New(arg0:findTF("bg/bg"))
	arg0.paintingView = SkinAtlasPaintingView.New(arg0:findTF("paint"))
	arg0.selectShipPage = ChangeShipSkinPage.New(arg0._parentTf, arg0.event)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.viewBtn, function()
		arg0.mainImg.enabled = false

		arg0.paintingView:Enter()

		if arg0.live2d then
			arg0.live2d:OpenClick()
		end
	end, SFX_PANEL)

	local var0 = arg0._tf:GetComponent(typeof(PinchZoom))

	onButton(arg0, arg0._tf, function()
		if var0.processing then
			return
		end

		arg0.mainImg.enabled = true

		arg0.paintingView:Exit()

		if arg0.live2d then
			arg0.live2d:CloseClick()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.changeBtn, function()
		if arg0.skin:CantUse() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_ship_to_wear"))

			return
		end

		arg0.selectShipPage:ExecuteAction("Show", arg0.skin)
	end, SFX_PANEL)
	onButton(arg0, arg0.obtainBtn, function()
		local var0 = arg0.skin:getConfig("ship_group")
		local var1 = ShipGroup.New({
			id = var0
		})
		local var2 = {
			type = MSGBOX_TYPE_OBTAIN,
			shipId = var1:getShipConfigId(),
			list = var1.groupConfig.description,
			mediatorName = SkinAtlasMediator.__cname
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox(var2)
	end, SFX_PANEL)
	arg0:bind(var0.ON_BG_SWITCH_DONE, function(arg0, arg1)
		arg0.bgFlag = arg1

		arg0.bgView:Init(arg0.ship, arg0.bgFlag)
	end)
	arg0:bind(var0.ON_L2D_SWITCH_DONE, function(arg0, arg1)
		arg0.l2dFlag = arg1

		arg0:UpdatePainting(arg0.ship)
	end)
	addSlip(SLIP_TYPE_HRZ, arg0:findTF("main"), function()
		arg0:OnPrev()
	end, function()
		arg0:OnNext()
	end)
end

function var0.OnNext(arg0)
	if arg0.loading then
		return
	end

	arg0:emit(SkinAtlasScene.ON_NEXT_SKIN, arg0.index)
end

function var0.OnPrev(arg0)
	if arg0.loading then
		return
	end

	arg0:emit(SkinAtlasScene.ON_PREV_SKIN, arg0.index)
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)

	arg0.index = arg2
	arg0.skin = arg1
	arg0.bgFlag = true
	arg0.l2dFlag = false

	local var0 = arg0.skin:ToShip()

	assert(var0)

	arg0.ship = var0

	arg0:UpdateMain(var0)

	local var1 = arg0.skin:CantUse()

	setActive(arg0.changeBtnDis, var1)
	setActive(arg0.changeBtnEn, not var1)
	setActive(arg0.obtainBtn, not arg0.skin:OwnShip())
end

function var0.Flush(arg0, arg1, arg2)
	arg0:Clear()
	arg0:Show(arg1, arg2)
end

function var0.UpdateMain(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.btns) do
		local var1 = iter1:IsActive(arg1)

		if var1 then
			var0 = var0 + 1
		end

		iter1:Update(var1, var0, arg1)
	end

	arg0.nameTxt.text = arg0.skin:getConfig("name")
	arg0.shipnameTxt.text = arg1:getName()
	arg0.loading = true

	parallelAsync({
		function(arg0)
			arg0.bgView:Init(arg1, arg0.bgFlag, arg0)
		end,
		function(arg0)
			arg0:UpdatePainting(arg1, arg0)
		end,
		function(arg0)
			arg0:UpdateChar(arg1, arg0)
		end
	}, function()
		arg0.loading = false
	end)
end

function var0.UpdatePainting(arg0, arg1, arg2)
	if arg0.l2dFlag then
		arg0:InitL2D(arg1, arg2)
	else
		arg0:InitPainting(arg1, arg2)
	end
end

function var0.InitPainting(arg0, arg1, arg2)
	arg0:ClearPainting(arg1)
	setActive(arg0.live2dContainer, false)

	arg0.painting = arg1:getPainting()

	setPaintingPrefabAsync(arg0.paintingTr, arg0.painting, "chuanwu", arg2)
end

function var0.InitL2D(arg0, arg1, arg2)
	arg0:ClearPainting(arg1)

	arg0.live2d = SkinAtlasLive2dView.New(arg1, arg0.live2dContainer, arg2)

	arg0.live2d.live2dChar:changeTriggerFlag(false)
end

function var0.UpdateChar(arg0, arg1, arg2)
	local var0 = arg1:getPrefab()

	PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
		arg0.modelTf = tf(arg0)
		arg0.modelTf.localScale = Vector3(0.9, 0.9, 1)
		arg0.modelTf.localPosition = Vector3(0, -135, 0)

		pg.ViewUtils.SetLayer(arg0.modelTf, Layer.UI)
		setParent(arg0.modelTf, arg0.charParent)
		arg0:GetComponent("SpineAnimUI"):SetAction("normal", 0)
		arg2()
	end)
end

function var0.ClearPainting(arg0, arg1)
	if arg0.live2d then
		arg0.live2d:Dispose()

		arg0.live2d = nil
	elseif arg0.painting then
		retPaintingPrefab(arg0.paintingTr, arg0.painting)

		arg0.painting = nil
	end
end

function var0.ClearChar(arg0, arg1)
	if arg0.modelTf then
		PoolMgr.GetInstance():ReturnSpineChar(arg1:getPrefab(), arg0.modelTf.gameObject)

		arg0.modelTf = nil
	end
end

function var0.Clear(arg0)
	local var0 = arg0.ship

	if var0 then
		arg0:ClearPainting(var0)
		arg0:ClearChar(var0)

		arg0.ship = nil
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:Clear()

	arg0.skin = nil

	arg0.bgView:Clear()

	if arg0.paintingView:IsEnter() then
		arg0.paintingView:Exit()
	end
end

function var0.IsShowSelectShipView(arg0)
	return arg0.selectShipPage and arg0.selectShipPage:GetLoaded() and arg0.selectShipPage:isShowing()
end

function var0.CloseSelectShipView(arg0)
	arg0.selectShipPage:Hide()
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end

	for iter0, iter1 in ipairs(arg0.btns) do
		iter1:Dispose()
	end

	arg0.btns = nil

	arg0.bgView:Dispose()

	arg0.bgView = nil

	arg0.selectShipPage:Destroy()

	arg0.selectShipPage = nil

	arg0.paintingView:Dispose()

	arg0.paintingView = nil
end

return var0
