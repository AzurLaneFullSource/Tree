local var0 = class("WSMapFleet", import(".WSMapTransform"))

var0.Fields = {
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
var0.Listeners = {
	onUpdate = "Update"
}
var0.EventUpdateSelected = "WSMapFleet.EventUpdateSelected"

function var0.GetResName(arg0)
	return "ship_tpl"
end

function var0.Setup(arg0, arg1, arg2)
	arg0.fleet = arg1

	arg0.fleet:AddListener(WorldMapFleet.EventUpdateLocation, arg0.onUpdate)
	arg0.fleet:AddListener(WorldMapFleet.EventUpdateShipOrder, arg0.onUpdate)
	arg0.fleet:AddListener(WorldMapFleet.EventUpdateBuff, arg0.onUpdate)
	arg0.fleet:AddListener(WorldMapFleet.EventUpdateDamageLevel, arg0.onUpdate)

	arg0.theme = arg2
	arg0.attaches = {}

	arg0:Init()
end

function var0.Dispose(arg0)
	arg0.fleet:RemoveListener(WorldMapFleet.EventUpdateLocation, arg0.onUpdate)
	arg0.fleet:RemoveListener(WorldMapFleet.EventUpdateShipOrder, arg0.onUpdate)
	arg0.fleet:RemoveListener(WorldMapFleet.EventUpdateBuff, arg0.onUpdate)
	arg0.fleet:RemoveListener(WorldMapFleet.EventUpdateDamageLevel, arg0.onUpdate)
	arg0:ClearAttaches()
	arg0:ClearHealthTimer()
	var0.super.Dispose(arg0)
end

function var0.Init(arg0)
	arg0.rtRetreat = arg0.transform:Find("retreat")
	arg0.rtArrow = arg0.transform:Find("arrow")
	arg0.rtFx = arg0.transform:Find("fx")
	arg0.rtShadow = arg0.transform:Find("shadow")
	arg0.rtSub = arg0.transform:Find("marks/sub")
	arg0.rtDamage = arg0.transform:Find("marks/damage")
	arg0.rtMoveTurn = arg0.transform:Find("marks/move_turn")
	arg0.rtHealth = arg0.transform:Find("Health")

	setActive(arg0.rtRetreat, false)
	setActive(arg0.rtArrow, false)
	setActive(arg0.rtSub, false)
	setActive(arg0.rtDamage, false)
	setActive(arg0.rtMoveTurn, false)
	setActive(arg0.rtHealth, false)

	arg0.transform.name = "fleet_" .. arg0.fleet.id
	arg0.transform.localEulerAngles = Vector3(-arg0.theme.angle, 0, 0)
	arg0.rtShadow.localPosition = Vector3.zero

	arg0:Update()
	arg0:UpdateActive(arg0.active or true)
	arg0:UpdateSelected(arg0.selected or false)
	arg0:UpdateSubmarineSupport()
	arg0:UpdateModelScale(Vector3(0.4, 0.4, 1))
	arg0:UpdateModelAngles(Vector3.zero)

	arg0.moveTurnCount = 0
end

function var0.LoadSpine(arg0, arg1)
	local var0 = arg0.modelResAsync
	local var1 = arg0.fleet:GetFlagShipVO()
	local var2 = SpineRole.New(var1)

	var2:Load(function()
		if arg0.modelType ~= WorldConst.ModelSpine then
			var2:Dispose()

			return
		end

		local var0 = var2.modelRoot.transform

		var2.model:GetComponent("SkeletonGraphic").raycastTarget = false
		var0.anchoredPosition3D = Vector3.zero
		var0.localScale = Vector3.one

		pg.ViewUtils.SetLayer(var0, Layer.UI)
		var2:SetParent(arg0.model)

		arg0.modelComps = {
			var2.model:GetComponent("SpineAnimUI")
		}
		arg0.spineRole = var2

		arg1()
	end, var0, var2.ORBIT_KEY_SLG)
end

function var0.UnloadSpine(arg0)
	if arg0.spineRole then
		arg0.spineRole:Dispose()

		arg0.spineRole = nil
	end
end

function var0.Update(arg0, arg1)
	local var0 = arg0.fleet

	if arg1 == nil or arg1 == WorldMapFleet.EventUpdateLocation and not arg0.isMoving then
		arg0.transform.anchoredPosition3D = arg0.theme:GetLinePosition(var0.row, var0.column)
	end

	if arg1 == nil or arg1 == WorldMapFleet.EventUpdateLocation then
		arg0:SetModelOrder(WorldConst.LOFleet, var0.row)
		underscore.each(arg0.attaches, function(arg0)
			arg0.modelOrder = arg0.modelOrder
		end)
	end

	if arg1 == nil or arg1 == WorldMapFleet.EventUpdateShipOrder then
		arg0:LoadModel(WorldConst.ModelSpine, var0:GetPrefab(), nil, true, function()
			arg0.model:SetParent(arg0.transform:Find("ship"), false)
		end)
	end

	if arg1 == nil or arg1 == WorldMapFleet.EventUpdateBuff then
		arg0:UpdateAttaches()
	end

	if arg1 == nil or arg1 == WorldMapFleet.EventUpdateDamageLevel then
		arg0:UpdateDamageLevel()
	end
end

function var0.UpdateActive(arg0, arg1)
	if arg0.active ~= arg1 then
		arg0.active = arg1

		setActive(arg0.transform, arg0.active)
	end
end

function var0.UpdateSelected(arg0, arg1)
	if arg0.selected ~= arg1 then
		arg0.selected = arg1

		setActive(arg0.rtArrow, arg0.selected)
		arg0:DispatchEvent(var0.EventUpdateSelected)
	end
end

function var0.UpdateSubmarineSupport(arg0)
	local var0 = nowWorld()
	local var1 = var0:IsSubmarineSupporting()

	setActive(arg0.rtSub, var1)

	if var1 then
		setGray(arg0.rtSub, not var0:GetSubAidFlag(), false)
	end
end

function var0.UpdateAttaches(arg0)
	local var0 = arg0.fleet:GetBuffFxList()

	for iter0 = #var0 + 1, #arg0.attaches do
		arg0.attaches[iter0]:Unload()
	end

	for iter1 = #arg0.attaches + 1, #var0 do
		local var1 = WPool:Get(WSMapEffect)

		var1.transform = createNewGameObject("mapEffect")

		var1.transform:SetParent(arg0.rtFx, false)

		var1.modelOrder = arg0.modelOrder

		table.insert(arg0.attaches, var1)
	end

	for iter2 = 1, #var0 do
		local var2 = arg0.attaches[iter2]

		var2:Setup(WorldConst.GetBuffEffect(var0[iter2]))
		var2:Load()
	end
end

function var0.ClearAttaches(arg0)
	local var0 = _.map(arg0.attaches, function(arg0)
		return arg0.transform
	end)

	WPool:ReturnArray(arg0.attaches)

	for iter0, iter1 in ipairs(var0) do
		Destroy(iter1)
	end

	arg0.attaches = {}
end

function var0.UpdateDamageLevel(arg0)
	local var0 = arg0.fleet.damageLevel

	setActive(arg0.rtDamage, var0 > 0)

	for iter0 = 1, #WorldConst.DamageBuffList do
		setActive(arg0.rtDamage:Find(iter0), var0 == iter0)
	end
end

function var0.PlusMoveTurn(arg0)
	arg0.moveTurnCount = arg0.moveTurnCount + 1

	setText(arg0.rtMoveTurn:Find("Text"), arg0.moveTurnCount)
	setActive(arg0.rtMoveTurn, arg0.moveTurnCount > 0)
end

function var0.ClearMoveTurn(arg0)
	arg0.moveTurnCount = 0

	setActive(arg0.rtMoveTurn, false)
end

function var0.DisplayHealth(arg0)
	arg0:ClearHealthTimer()
	setActive(arg0.rtHealth, true)

	arg0.timerHealth = Timer.New(function()
		setActive(arg0.rtHealth, false)

		arg0.timerHealth = nil
	end, 2)

	arg0.timerHealth:Start()
end

function var0.ClearHealthTimer(arg0)
	if arg0.timerHealth then
		arg0.timerHealth:Stop()

		arg0.timerHealth = nil

		setActive(arg0.rtHealth, false)
	end
end

return var0
