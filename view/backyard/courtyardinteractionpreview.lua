local var0_0 = class("CourtyardInteractionPreview", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BackYardInterActionPreview"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.mask = arg0_2:findTF("frame/mask")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Destroy()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Destroy()
	end, SFX_PANEL)
	setText(arg0_3:findTF("frame/title"), i18n("word_preview"))
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	var0_0.super.Show(arg0_6)

	arg0_6.storeyId = 999
	arg0_6.furnitureId = arg1_6

	local var0_6 = pg.ship_skin_template[arg2_6]

	arg0_6.shipId = ShipGroup.getDefaultShipConfig(var0_6.ship_group).id
	arg0_6.shipSkinId = arg2_6
	arg0_6.furniturePosition = Vector2(0, 0)
	arg0_6.step = 0
	arg0_6.instance = nil

	arg0_6:SetUp()
end

function var0_0.SetUp(arg0_7)
	setActive(arg0_7.mask, false)

	arg0_7.instance = CourtYardBridge.New(arg0_7:GenCourtYardData(id))

	local var0_7 = arg0_7.instance:GetController()
	local var1_7 = arg0_7.instance:GetView()
	local var2_7 = arg0_7:GetPutFurniture()
	local var3_7 = 0

	arg0_7.timer = Timer.New(function()
		if arg0_7.step == 2 then
			local var0_8 = var0_7:GetStorey():GetFurniture(var2_7.id)

			if var0_8 and not var0_8:AnySlotIsLoop() and not var0_8:IsInteractionState() then
				GetOrAddComponent(var1_7:GetRect(), typeof(CanvasGroup)).alpha = 0

				setActive(arg0_7.mask, true)
				onButton(arg0_7, arg0_7.mask, function()
					arg0_7.step = 1

					setActive(arg0_7.mask, false)
				end, SFX_PANEL)

				arg0_7.step = 3
			end
		end

		if arg0_7.step == 1 and var1_7:GetCurrStorey():ItemsIsLoaded() then
			arg0_7:StartInteraction(var0_7)

			GetOrAddComponent(var1_7:GetRect(), typeof(CanvasGroup)).alpha = 1
			arg0_7.step = 2
		end

		if var1_7:IsInit() and var0_7:IsLoaed() and arg0_7.step == 0 then
			arg0_7.step = 1
			GetOrAddComponent(var1_7:GetRect(), typeof(CanvasGroup)).alpha = 0

			var0_7:AddFurniture(var2_7)
			var0_7:AddShip(arg0_7:GetPutShip())
		end
	end, 0.01, -1)

	arg0_7.timer:Start()
end

function var0_0.RemoveTimer(arg0_10)
	if arg0_10.timer then
		arg0_10.timer:Stop()

		arg0_10.timer = nil
	end
end

function var0_0.StartInteraction(arg0_11, arg1_11)
	if arg0_11.shipId then
		arg1_11:DragShip(arg0_11.shipId)
		arg1_11:DragShipEnd(arg0_11.shipId, arg0_11.furniturePosition)
	end
end

function var0_0.Hide(arg0_12)
	var0_0.super.Hide(arg0_12)
	arg0_12:RemoveTimer()

	if arg0_12.instance then
		arg0_12.instance:Dispose()
	end

	arg0_12.instance = nil
end

function var0_0.GenCourtYardData(arg0_13)
	local var0_13 = arg0_13.storeyId
	local var1_13 = 4
	local var2_13 = {
		[var0_13] = {
			id = var0_13,
			level = var1_13,
			furnitures = {},
			ships = {}
		}
	}
	local var3_13 = Dorm.StaticGetMapSize(var1_13)

	return {
		system = CourtYardConst.SYSTEM_VISIT,
		storeys = var2_13,
		storeyId = var0_13,
		style = CourtYardConst.STYLE_PREVIEW,
		mapSize = var3_13,
		name = arg0_13:getUIName()
	}
end

function var0_0.GetPutFurniture(arg0_14)
	return (BackyardThemeFurniture.New({
		id = 9999,
		isNewStyle = true,
		configId = arg0_14.furnitureId,
		position = arg0_14.furniturePosition
	}))
end

function var0_0.GetPutShip(arg0_15)
	if not arg0_15.shipId or arg0_15.shipId <= 0 then
		return {}
	end

	return (Ship.New({
		id = arg0_15.shipId,
		template_id = arg0_15.shipId,
		skin_id = arg0_15.shipSkinId
	}))
end

function var0_0.OnDestroy(arg0_16)
	arg0_16:Hide()
end

return var0_0
