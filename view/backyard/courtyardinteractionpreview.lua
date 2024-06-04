local var0 = class("CourtyardInteractionPreview", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "BackYardInterActionPreview"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.mask = arg0:findTF("frame/mask")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Destroy()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Destroy()
	end, SFX_PANEL)
	setText(arg0:findTF("frame/title"), i18n("word_preview"))
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)

	arg0.storeyId = 999
	arg0.furnitureId = arg1

	local var0 = pg.ship_skin_template[arg2]

	arg0.shipId = ShipGroup.getDefaultShipConfig(var0.ship_group).id
	arg0.shipSkinId = arg2
	arg0.furniturePosition = Vector2(0, 0)
	arg0.step = 0
	arg0.instance = nil

	arg0:SetUp()
end

function var0.SetUp(arg0)
	setActive(arg0.mask, false)

	arg0.instance = CourtYardBridge.New(arg0:GenCourtYardData(id))

	local var0 = arg0.instance:GetController()
	local var1 = arg0.instance:GetView()
	local var2 = arg0:GetPutFurniture()
	local var3 = 0

	arg0.timer = Timer.New(function()
		if arg0.step == 2 then
			local var0 = var0:GetStorey():GetFurniture(var2.id)

			if var0 and not var0:AnySlotIsLoop() and not var0:IsInteractionState() then
				GetOrAddComponent(var1:GetRect(), typeof(CanvasGroup)).alpha = 0

				setActive(arg0.mask, true)
				onButton(arg0, arg0.mask, function()
					arg0.step = 1

					setActive(arg0.mask, false)
				end, SFX_PANEL)

				arg0.step = 3
			end
		end

		if arg0.step == 1 and var1:GetCurrStorey():ItemsIsLoaded() then
			arg0:StartInteraction(var0)

			GetOrAddComponent(var1:GetRect(), typeof(CanvasGroup)).alpha = 1
			arg0.step = 2
		end

		if var1:IsInit() and var0:IsLoaed() and arg0.step == 0 then
			arg0.step = 1
			GetOrAddComponent(var1:GetRect(), typeof(CanvasGroup)).alpha = 0

			var0:AddFurniture(var2)
			var0:AddShip(arg0:GetPutShip())
		end
	end, 0.01, -1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.StartInteraction(arg0, arg1)
	if arg0.shipId then
		arg1:DragShip(arg0.shipId)
		arg1:DragShipEnd(arg0.shipId, arg0.furniturePosition)
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:RemoveTimer()

	if arg0.instance then
		arg0.instance:Dispose()
	end

	arg0.instance = nil
end

function var0.GenCourtYardData(arg0)
	local var0 = arg0.storeyId
	local var1 = 4
	local var2 = {
		[var0] = {
			id = var0,
			level = var1,
			furnitures = {},
			ships = {}
		}
	}
	local var3 = Dorm.StaticGetMapSize(var1)

	return {
		system = CourtYardConst.SYSTEM_VISIT,
		storeys = var2,
		storeyId = var0,
		style = CourtYardConst.STYLE_PREVIEW,
		mapSize = var3,
		name = arg0:getUIName()
	}
end

function var0.GetPutFurniture(arg0)
	return (BackyardThemeFurniture.New({
		id = 9999,
		isNewStyle = true,
		configId = arg0.furnitureId,
		position = arg0.furniturePosition
	}))
end

function var0.GetPutShip(arg0)
	if not arg0.shipId or arg0.shipId <= 0 then
		return {}
	end

	return (Ship.New({
		id = arg0.shipId,
		template_id = arg0.shipId,
		skin_id = arg0.shipSkinId
	}))
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
