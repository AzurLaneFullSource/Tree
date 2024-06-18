local var0_0 = class("ShipRotateLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ShipRotateUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
end

function var0_0.didEnter(arg0_3)
	local var0_3 = arg0_3.skin and arg0_3.skin.id or arg0_3.shipGroup:GetSkin(arg0_3.showTrans).id

	arg0_3:SetPainting(var0_3, arg0_3.showTrans)
	arg0_3.paintingView:setBGCallback(function()
		arg0_3:closeView()
	end)
	arg0_3.paintingView:Start()
	setActive(arg0_3:findTF("Enc"), true)
end

function var0_0.willExit(arg0_5)
	arg0_5.paintingView:Dispose()
	arg0_5:RecyclePainting()
end

function var0_0.initData(arg0_6)
	arg0_6.paintingName = nil
	arg0_6.shipGroup = arg0_6.contextData.shipGroup
	arg0_6.showTrans = arg0_6.contextData.showTrans
	arg0_6.skin = arg0_6.contextData.skin
end

function var0_0.findUI(arg0_7)
	arg0_7.painting = arg0_7:findTF("paint")
	arg0_7.paintingFitter = findTF(arg0_7.painting, "fitter")
	arg0_7.paintingInitPos = arg0_7.painting.transform.localPosition
	arg0_7.paintingView = ShipProfilePaintingView.New(arg0_7._tf, arg0_7.painting, true)
end

function var0_0.SetPainting(arg0_8, arg1_8, arg2_8)
	arg0_8:RecyclePainting()

	local var0_8 = pg.ship_skin_template[arg1_8].painting

	setPaintingPrefabAsync(arg0_8.painting, var0_8, "chuanwu")

	arg0_8.paintingName = var0_8
end

function var0_0.RecyclePainting(arg0_9)
	if arg0_9.paintingName then
		retPaintingPrefab(arg0_9.painting, arg0_9.paintingName)
	end
end

return var0_0
