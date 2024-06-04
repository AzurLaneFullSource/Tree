local var0 = class("ShipRotateLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ShipRotateUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
end

function var0.didEnter(arg0)
	local var0 = arg0.skin and arg0.skin.id or arg0.shipGroup:GetSkin(arg0.showTrans).id

	arg0:SetPainting(var0, arg0.showTrans)
	arg0.paintingView:setBGCallback(function()
		arg0:closeView()
	end)
	arg0.paintingView:Start()
	setActive(arg0:findTF("Enc"), true)
end

function var0.willExit(arg0)
	arg0.paintingView:Dispose()
	arg0:RecyclePainting()
end

function var0.initData(arg0)
	arg0.paintingName = nil
	arg0.shipGroup = arg0.contextData.shipGroup
	arg0.showTrans = arg0.contextData.showTrans
	arg0.skin = arg0.contextData.skin
end

function var0.findUI(arg0)
	arg0.painting = arg0:findTF("paint")
	arg0.paintingFitter = findTF(arg0.painting, "fitter")
	arg0.paintingInitPos = arg0.painting.transform.localPosition
	arg0.paintingView = ShipProfilePaintingView.New(arg0._tf, arg0.painting, true)
end

function var0.SetPainting(arg0, arg1, arg2)
	arg0:RecyclePainting()

	local var0 = pg.ship_skin_template[arg1].painting

	setPaintingPrefabAsync(arg0.painting, var0, "chuanwu")

	arg0.paintingName = var0
end

function var0.RecyclePainting(arg0)
	if arg0.paintingName then
		retPaintingPrefab(arg0.painting, arg0.paintingName)
	end
end

return var0
