local var0_0 = class("WSMapFleet", import(".WSMapTransform"))

var0_0.Fields = {
	rtShadow = "userdata",
	rtSub = "userdata",
	rtArrow = "userdata",
	spineRole = "table",
	selected = "boolean",
	rtRetreat = "userdata",
	theme = "table",
	moveTurnCount = "number",
	fleet = "table",
	rtFx = "userdata",
	timerHealth = "table",
	rtDamage = "userdata",
	rtHealth = "userdata",
	attaches = "table",
	rtMoveTurn = "userdata",
	active = "boolean",
	submarineSupport = "boolean"
}
var0_0.Listeners = {
	onUpdate = "Update"
}
var0_0.EventUpdateSelected = "WSMapFleet.EventUpdateSelected"

function var0_0.GetResName(arg0_1)
	return "ship_tpl"
end

function var0_0.Setup(arg0_2, arg1_2, arg2_2)
	arg0_2.fleet = arg1_2

	arg0_2.fleet:AddListener(WorldMapFleet.EventUpdateLocation, arg0_2.onUpdate)
	arg0_2.fleet:AddListener(WorldMapFleet.EventUpdateShipOrder, arg0_2.onUpdate)
	arg0_2.fleet:AddListener(WorldMapFleet.EventUpdateBuff, arg0_2.onUpdate)
	arg0_2.fleet:AddListener(WorldMapFleet.EventUpdateDamageLevel, arg0_2.onUpdate)

	arg0_2.theme = arg2_2
	arg0_2.attaches = {}

	arg0_2:Init()
end

function var0_0.Dispose(arg0_3)
	arg0_3.fleet:RemoveListener(WorldMapFleet.EventUpdateLocation, arg0_3.onUpdate)
	arg0_3.fleet:RemoveListener(WorldMapFleet.EventUpdateShipOrder, arg0_3.onUpdate)
	arg0_3.fleet:RemoveListener(WorldMapFleet.EventUpdateBuff, arg0_3.onUpdate)
	arg0_3.fleet:RemoveListener(WorldMapFleet.EventUpdateDamageLevel, arg0_3.onUpdate)
	arg0_3:ClearAttaches()
	arg0_3:ClearHealthTimer()
	var0_0.super.Dispose(arg0_3)
end

function var0_0.Init(arg0_4)
	arg0_4.rtRetreat = arg0_4.transform:Find("retreat")
	arg0_4.rtArrow = arg0_4.transform:Find("arrow")
	arg0_4.rtFx = arg0_4.transform:Find("fx")
	arg0_4.rtShadow = arg0_4.transform:Find("shadow")
	arg0_4.rtSub = arg0_4.transform:Find("marks/sub")
	arg0_4.rtDamage = arg0_4.transform:Find("marks/damage")
	arg0_4.rtMoveTurn = arg0_4.transform:Find("marks/move_turn")
	arg0_4.rtHealth = arg0_4.transform:Find("Health")

	setActive(arg0_4.rtRetreat, false)
	setActive(arg0_4.rtArrow, false)
	setActive(arg0_4.rtSub, false)
	setActive(arg0_4.rtDamage, false)
	setActive(arg0_4.rtMoveTurn, false)
	setActive(arg0_4.rtHealth, false)

	arg0_4.transform.name = "fleet_" .. arg0_4.fleet.id
	arg0_4.transform.localEulerAngles = Vector3(-arg0_4.theme.angle, 0, 0)
	arg0_4.rtShadow.localPosition = Vector3.zero

	arg0_4:Update()
	arg0_4:UpdateActive(arg0_4.active or true)
	arg0_4:UpdateSelected(arg0_4.selected or false)
	arg0_4:UpdateSubmarineSupport()
	arg0_4:UpdateModelScale(Vector3(0.4, 0.4, 1))
	arg0_4:UpdateModelAngles(Vector3.zero)

	arg0_4.moveTurnCount = 0
end

function var0_0.LoadSpine(arg0_5, arg1_5)
	local var0_5 = arg0_5.modelResAsync
	local var1_5 = arg0_5.fleet:GetFlagShipVO()
	local var2_5 = SpineRole.New(var1_5)

	var2_5:Load(function()
		if arg0_5.modelType ~= WorldConst.ModelSpine then
			var2_5:Dispose()

			return
		end

		var2_5:SetRaycastTarget(false)
		var2_5:SetAnchoredPosition3D(Vector3.zero)
		var2_5:SetLocalScale(Vector3.one)
		var2_5:SetLayer(Layer.UI)
		var2_5:SetParent(arg0_5.model)

		arg0_5.modelComps = {
			var2_5
		}
		arg0_5.spineRole = var2_5

		arg1_5()
	end, var0_5, var2_5.ORBIT_KEY_SLG)
end

function var0_0.UnloadSpine(arg0_7)
	if arg0_7.spineRole then
		arg0_7.spineRole:Dispose()

		arg0_7.spineRole = nil
	end
end

function var0_0.Update(arg0_8, arg1_8)
	local var0_8 = arg0_8.fleet

	if arg1_8 == nil or arg1_8 == WorldMapFleet.EventUpdateLocation and not arg0_8.isMoving then
		arg0_8.transform.anchoredPosition3D = arg0_8.theme:GetLinePosition(var0_8.row, var0_8.column)
	end

	if arg1_8 == nil or arg1_8 == WorldMapFleet.EventUpdateLocation then
		arg0_8:SetModelOrder(WorldConst.LOFleet, var0_8.row)
		underscore.each(arg0_8.attaches, function(arg0_9)
			arg0_9.modelOrder = arg0_8.modelOrder
		end)
	end

	if arg1_8 == nil or arg1_8 == WorldMapFleet.EventUpdateShipOrder then
		arg0_8:LoadModel(WorldConst.ModelSpine, var0_8:GetPrefab(), nil, true, function()
			arg0_8.model:SetParent(arg0_8.transform:Find("ship"), false)
			arg0_8:ModelOrderChanged()
		end)
	end

	if arg1_8 == nil or arg1_8 == WorldMapFleet.EventUpdateBuff then
		arg0_8:UpdateAttaches()
	end

	if arg1_8 == nil or arg1_8 == WorldMapFleet.EventUpdateDamageLevel then
		arg0_8:UpdateDamageLevel()
	end
end

function var0_0.ModelOrderChanged(arg0_11)
	if arg0_11.spineRole and arg0_11.modelOrder then
		arg0_11.spineRole:SetSortLayer(arg0_11.modelOrder - 2)
	end
end

function var0_0.UpdateActive(arg0_12, arg1_12)
	if arg0_12.active ~= arg1_12 then
		arg0_12.active = arg1_12

		setActive(arg0_12.transform, arg0_12.active)
	end
end

function var0_0.UpdateSelected(arg0_13, arg1_13)
	if arg0_13.selected ~= arg1_13 then
		arg0_13.selected = arg1_13

		setActive(arg0_13.rtArrow, arg0_13.selected)
		arg0_13:DispatchEvent(var0_0.EventUpdateSelected)
	end
end

function var0_0.UpdateSubmarineSupport(arg0_14)
	local var0_14 = nowWorld()
	local var1_14 = var0_14:IsSubmarineSupporting()

	setActive(arg0_14.rtSub, var1_14)

	if var1_14 then
		setGray(arg0_14.rtSub, not var0_14:GetSubAidFlag(), false)
	end
end

function var0_0.UpdateAttaches(arg0_15)
	local var0_15 = arg0_15.fleet:GetBuffFxList()

	for iter0_15 = #var0_15 + 1, #arg0_15.attaches do
		arg0_15.attaches[iter0_15]:Unload()
	end

	for iter1_15 = #arg0_15.attaches + 1, #var0_15 do
		local var1_15 = WPool:Get(WSMapEffect)

		var1_15.transform = createNewGameObject("mapEffect")

		var1_15.transform:SetParent(arg0_15.rtFx, false)

		var1_15.modelOrder = arg0_15.modelOrder

		table.insert(arg0_15.attaches, var1_15)
	end

	for iter2_15 = 1, #var0_15 do
		local var2_15 = arg0_15.attaches[iter2_15]

		var2_15:Setup(WorldConst.GetBuffEffect(var0_15[iter2_15]))
		var2_15:Load()
	end
end

function var0_0.ClearAttaches(arg0_16)
	local var0_16 = _.map(arg0_16.attaches, function(arg0_17)
		return arg0_17.transform
	end)

	WPool:ReturnArray(arg0_16.attaches)

	for iter0_16, iter1_16 in ipairs(var0_16) do
		Destroy(iter1_16)
	end

	arg0_16.attaches = {}
end

function var0_0.UpdateDamageLevel(arg0_18)
	local var0_18 = arg0_18.fleet.damageLevel

	setActive(arg0_18.rtDamage, var0_18 > 0)

	for iter0_18 = 1, #WorldConst.DamageBuffList do
		setActive(arg0_18.rtDamage:Find(iter0_18), var0_18 == iter0_18)
	end
end

function var0_0.PlusMoveTurn(arg0_19)
	arg0_19.moveTurnCount = arg0_19.moveTurnCount + 1

	setText(arg0_19.rtMoveTurn:Find("Text"), arg0_19.moveTurnCount)
	setActive(arg0_19.rtMoveTurn, arg0_19.moveTurnCount > 0)
end

function var0_0.ClearMoveTurn(arg0_20)
	arg0_20.moveTurnCount = 0

	setActive(arg0_20.rtMoveTurn, false)
end

function var0_0.DisplayHealth(arg0_21)
	arg0_21:ClearHealthTimer()
	setActive(arg0_21.rtHealth, true)

	arg0_21.timerHealth = Timer.New(function()
		setActive(arg0_21.rtHealth, false)

		arg0_21.timerHealth = nil
	end, 2)

	arg0_21.timerHealth:Start()
end

function var0_0.ClearHealthTimer(arg0_23)
	if arg0_23.timerHealth then
		arg0_23.timerHealth:Stop()

		arg0_23.timerHealth = nil

		setActive(arg0_23.rtHealth, false)
	end
end

return var0_0
