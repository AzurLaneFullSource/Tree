local var0 = class("CipherTestLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "CipherTest"
end

function var0.init(arg0)
	arg0.nextBtn = arg0:findTF("Next")
	arg0.gcBtn = arg0:findTF("GC")
	arg0.live2dContainer = arg0:findTF("Painting/Live2D")
	arg0.l2dList = arg0:GetL2DList()
	arg0.curIndex = 0
	arg0.live2dChar = nil
	arg0.skinID = nil
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.nextBtn, function()
		arg0:ClearL2dPainting()

		arg0.curIndex = arg0.curIndex + 1
		arg0.curL2D = arg0.l2dList[arg0.curIndex]

		arg0:LoadL2dPainting(arg0.curL2D)
	end, SFX_PANEL)
	onButton(arg0, arg0.gcBtn, function()
		gcAll()
	end, SFX_PANEL)
end

function var0.willExit(arg0)
	return
end

function var0.GetL2DList(arg0)
	local var0 = {}
	local var1 = pg.ship_skin_template.all

	for iter0, iter1 in ipairs(var1) do
		if ShipSkin.New({
			id = iter1
		}):IsLive2d() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.LoadL2dPainting(arg0, arg1)
	local var0 = pg.ship_skin_template[arg1].ship_group
	local var1 = ShipGroup.getDefaultShipConfig(var0)
	local var2 = Live2D.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var1.id,
			skin_id = arg1
		}),
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -1),
		parent = arg0.live2dContainer
	})

	var2.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	local var3

	var3 = Live2D.New(var2, function(arg0)
		arg0:IgonreReactPos(true)
		arg0:ClearL2dPainting()
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.live2dChar = var3
	end)
end

function var0.ClearL2dPainting(arg0)
	if arg0.live2dChar then
		arg0.live2dChar:Dispose()

		arg0.live2dChar = nil
	end
end

return var0
