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

		local var0_6 = var2_5.modelRoot.transform

		var2_5.model:GetComponent("SkeletonGraphic").raycastTarget = false
		var0_6.anchoredPosition3D = Vector3.zero
		var0_6.localScale = Vector3.one

		pg.ViewUtils.SetLayer(var0_6, Layer.UI)
		var2_5:SetParent(arg0_5.model)

		arg0_5.modelComps = {
			var2_5.model:GetComponent("SpineAnimUI")
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
		end)
	end

	if arg1_8 == nil or arg1_8 == WorldMapFleet.EventUpdateBuff then
		arg0_8:UpdateAttaches()
	end

	if arg1_8 == nil or arg1_8 == WorldMapFleet.EventUpdateDamageLevel then
		arg0_8:UpdateDamageLevel()
	end
end

function var0_0.UpdateActive(arg0_11, arg1_11)
	if arg0_11.active ~= arg1_11 then
		arg0_11.active = arg1_11

		setActive(arg0_11.transform, arg0_11.active)
	end
end

function var0_0.UpdateSelected(arg0_12, arg1_12)
	if arg0_12.selected ~= arg1_12 then
		arg0_12.selected = arg1_12

		setActive(arg0_12.rtArrow, arg0_12.selected)
		arg0_12:DispatchEvent(var0_0.EventUpdateSelected)
	end
end

function var0_0.UpdateSubmarineSupport(arg0_13)
	local var0_13 = nowWorld()
	local var1_13 = var0_13:IsSubmarineSupporting()

	setActive(arg0_13.rtSub, var1_13)

	if var1_13 then
		setGray(arg0_13.rtSub, not var0_13:GetSubAidFlag(), false)
	end
end

function var0_0.UpdateAttaches(arg0_14)
	local var0_14 = arg0_14.fleet:GetBuffFxList()

	for iter0_14 = #var0_14 + 1, #arg0_14.attaches do
		arg0_14.attaches[iter0_14]:Unload()
	end

	for iter1_14 = #arg0_14.attaches + 1, #var0_14 do
		local var1_14 = WPool:Get(WSMapEffect)

		var1_14.transform = createNewGameObject("mapEffect")

		var1_14.transform:SetParent(arg0_14.rtFx, false)

		var1_14.modelOrder = arg0_14.modelOrder

		table.insert(arg0_14.attaches, var1_14)
	end

	for iter2_14 = 1, #var0_14 do
		local var2_14 = arg0_14.attaches[iter2_14]

		var2_14:Setup(WorldConst.GetBuffEffect(var0_14[iter2_14]))
		var2_14:Load()
	end
end

function var0_0.ClearAttaches(arg0_15)
	local var0_15 = _.map(arg0_15.attaches, function(arg0_16)
		return arg0_16.transform
	end)

	WPool:ReturnArray(arg0_15.attaches)

	for iter0_15, iter1_15 in ipairs(var0_15) do
		Destroy(iter1_15)
	end

	arg0_15.attaches = {}
end

function var0_0.UpdateDamageLevel(arg0_17)
	local var0_17 = arg0_17.fleet.damageLevel

	setActive(arg0_17.rtDamage, var0_17 > 0)

	for iter0_17 = 1, #WorldConst.DamageBuffList do
		setActive(arg0_17.rtDamage:Find(iter0_17), var0_17 == iter0_17)
	end
end

function var0_0.PlusMoveTurn(arg0_18)
	arg0_18.moveTurnCount = arg0_18.moveTurnCount + 1

	setText(arg0_18.rtMoveTurn:Find("Text"), arg0_18.moveTurnCount)
	setActive(arg0_18.rtMoveTurn, arg0_18.moveTurnCount > 0)
end

function var0_0.ClearMoveTurn(arg0_19)
	arg0_19.moveTurnCount = 0

	setActive(arg0_19.rtMoveTurn, false)
end

function var0_0.DisplayHealth(arg0_20)
	arg0_20:ClearHealthTimer()
	setActive(arg0_20.rtHealth, true)

	arg0_20.timerHealth = Timer.New(function()
		setActive(arg0_20.rtHealth, false)

		arg0_20.timerHealth = nil
	end, 2)

	arg0_20.timerHealth:Start()
end

function var0_0.ClearHealthTimer(arg0_22)
	if arg0_22.timerHealth then
		arg0_22.timerHealth:Stop()

		arg0_22.timerHealth = nil

		setActive(arg0_22.rtHealth, false)
	end
end

return var0_0
