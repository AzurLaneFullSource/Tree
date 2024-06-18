local var0_0 = class("CipherTestLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CipherTest"
end

function var0_0.init(arg0_2)
	arg0_2.nextBtn = arg0_2:findTF("Next")
	arg0_2.gcBtn = arg0_2:findTF("GC")
	arg0_2.live2dContainer = arg0_2:findTF("Painting/Live2D")
	arg0_2.l2dList = arg0_2:GetL2DList()
	arg0_2.curIndex = 0
	arg0_2.live2dChar = nil
	arg0_2.skinID = nil
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.nextBtn, function()
		arg0_3:ClearL2dPainting()

		arg0_3.curIndex = arg0_3.curIndex + 1
		arg0_3.curL2D = arg0_3.l2dList[arg0_3.curIndex]

		arg0_3:LoadL2dPainting(arg0_3.curL2D)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.gcBtn, function()
		gcAll()
	end, SFX_PANEL)
end

function var0_0.willExit(arg0_6)
	return
end

function var0_0.GetL2DList(arg0_7)
	local var0_7 = {}
	local var1_7 = pg.ship_skin_template.all

	for iter0_7, iter1_7 in ipairs(var1_7) do
		if ShipSkin.New({
			id = iter1_7
		}):IsLive2d() then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.LoadL2dPainting(arg0_8, arg1_8)
	local var0_8 = pg.ship_skin_template[arg1_8].ship_group
	local var1_8 = ShipGroup.getDefaultShipConfig(var0_8)
	local var2_8 = Live2D.GenerateData({
		ship = Ship.New({
			id = 999,
			configId = var1_8.id,
			skin_id = arg1_8
		}),
		scale = Vector3(52, 52, 52),
		position = Vector3(0, 0, -1),
		parent = arg0_8.live2dContainer
	})

	var2_8.shopPreView = true

	pg.UIMgr.GetInstance():LoadingOn()

	local var3_8

	var3_8 = Live2D.New(var2_8, function(arg0_9)
		arg0_9:IgonreReactPos(true)
		arg0_8:ClearL2dPainting()
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_8.live2dChar = var3_8
	end)
end

function var0_0.ClearL2dPainting(arg0_10)
	if arg0_10.live2dChar then
		arg0_10.live2dChar:Dispose()

		arg0_10.live2dChar = nil
	end
end

return var0_0
