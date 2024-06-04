local var0 = class("WSMapLeft", import("...BaseEntity"))

var0.Fields = {
	map = "table",
	fleet = "table",
	rtArrow = "userdata",
	delayCallFuncs = "table",
	toggles = "table",
	onAgonyClickEnabled = "boolean",
	rtAmmo = "userdata",
	toggleSelected = "userdata",
	onAgonyClick = "function",
	rtSubBar = "userdata",
	btnCollapse = "userdata",
	world = "table",
	toggleMask = "userdata",
	rtBG = "userdata",
	rtVanguard = "userdata",
	rtSalvageList = "userdata",
	toggleList = "userdata",
	onLongPress = "function",
	rtFleet = "userdata",
	transform = "userdata",
	rtShip = "userdata",
	onClickSalvage = "function",
	rtMain = "userdata",
	rtFleetBar = "userdata"
}
var0.Listeners = {
	onUpdateShipHpRate = "OnUpdateShipHpRate",
	onUpdateFleetOrder = "OnUpdateFleetOrder",
	onUpdateFleetBar = "OnUpdateFleetBar",
	onUpdateCatSalvage = "OnUpdateCatSalvage",
	onUpdateShipBroken = "OnUpdateShipBroken",
	onUpdateSelectedFleet = "OnUpdateSelectedFleet"
}
var0.EventSelectFleet = "WSMapLeft.EventSelectFleet"

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)

	arg0.delayCallFuncs = {}

	arg0:Init()
	arg0:AddWorldListener()
	arg0:UpdateAllCatSalvage()
end

function var0.Dispose(arg0)
	local function var0(arg0)
		LeanTween.cancel(go(arg0))
		LeanTween.cancel(go(arg0:Find("text")))
	end

	eachChild(arg0.rtMain, function(arg0)
		local var0 = arg0:Find("HP_POP")

		var0(var0:Find("heal"))
		var0(var0:Find("normal"))
	end)
	eachChild(arg0.rtVanguard, function(arg0)
		local var0 = arg0:Find("HP_POP")

		var0(var0:Find("heal"))
		var0(var0:Find("normal"))
	end)
	arg0:RemoveWorldListener()
	arg0:RemoveFleetListener(arg0.fleet)
	arg0:RemoveMapListener()
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.transform

	arg0.rtBG = var0:Find("bg")
	arg0.rtFleet = arg0.rtBG:Find("fleet")
	arg0.rtMain = arg0.rtFleet:Find("main")
	arg0.rtVanguard = arg0.rtFleet:Find("vanguard")
	arg0.rtShip = arg0.rtFleet:Find("shiptpl")
	arg0.btnCollapse = arg0.rtBG:Find("collapse")
	arg0.rtArrow = arg0.btnCollapse:Find("arrow")
	arg0.rtFleetBar = var0:Find("other/fleet_bar")
	arg0.toggleMask = var0:Find("mask")
	arg0.toggleList = arg0.toggleMask:Find("list")
	arg0.toggles = {}

	for iter0 = 0, arg0.toggleList.childCount - 1 do
		table.insert(arg0.toggles, arg0.toggleList:GetChild(iter0))
	end

	arg0.rtSubBar = var0:Find("other/sub_bar")
	arg0.rtAmmo = arg0.rtSubBar:Find("text")
	arg0.rtSalvageList = var0:Find("other/salvage_list")

	setActive(arg0.rtShip, false)
	setActive(arg0.toggleMask, false)
	setActive(arg0.rtSubBar, false)
	onButton(arg0, arg0.btnCollapse, function()
		arg0:Collpase()
	end, SFX_PANEL)
	onButton(arg0, arg0.rtFleetBar, function()
		arg0:ShowToggleMask(function(arg0)
			arg0:DispatchEvent(var0.EventSelectFleet, arg0)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.toggleMask, function()
		arg0:HideToggleMask()
	end, SFX_PANEL)
end

function var0.AddWorldListener(arg0)
	underscore.each(nowWorld():GetNormalFleets(), function(arg0)
		arg0:AddListener(WorldMapFleet.EventUpdateCatSalvage, arg0.onUpdateCatSalvage)
	end)
end

function var0.RemoveWorldListener(arg0)
	underscore.each(nowWorld():GetNormalFleets(), function(arg0)
		arg0:RemoveListener(WorldMapFleet.EventUpdateCatSalvage, arg0.onUpdateCatSalvage)
	end)
end

function var0.UpdateMap(arg0, arg1)
	arg0:RemoveMapListener()

	arg0.map = arg1

	arg0:AddMapListener()
	arg0:OnUpdateSelectedFleet()
	arg0:OnUpdateSubmarineSupport()
end

function var0.AddMapListener(arg0)
	if arg0.map then
		arg0.map:AddListener(WorldMap.EventUpdateFIndex, arg0.onUpdateSelectedFleet)
	end
end

function var0.RemoveMapListener(arg0)
	if arg0.map then
		arg0.map:RemoveListener(WorldMap.EventUpdateFIndex, arg0.onUpdateSelectedFleet)
	end
end

function var0.AddFleetListener(arg0, arg1)
	if arg1 then
		arg1:AddListener(WorldMapFleet.EventUpdateShipOrder, arg0.onUpdateFleetOrder)
		arg1:AddListener(WorldMapFleet.EventUpdateBuff, arg0.onUpdateFleetBar)
		_.each(arg1:GetShips(true), function(arg0)
			arg0:AddListener(WorldMapShip.EventHpRantChange, arg0.onUpdateShipHpRate)
			arg0:AddListener(WorldMapShip.EventUpdateBroken, arg0.onUpdateShipBroken)
		end)
	end
end

function var0.RemoveFleetListener(arg0, arg1)
	if arg1 then
		arg1:RemoveListener(WorldMapFleet.EventUpdateShipOrder, arg0.onUpdateFleetOrder)
		arg1:RemoveListener(WorldMapFleet.EventUpdateBuff, arg0.onUpdateFleetBar)
		_.each(arg1:GetShips(true), function(arg0)
			arg0:RemoveListener(WorldMapShip.EventHpRantChange, arg0.onUpdateShipHpRate)
			arg0:RemoveListener(WorldMapShip.EventUpdateBroken, arg0.onUpdateShipBroken)
		end)
	end
end

function var0.OnUpdateSelectedFleet(arg0)
	local var0 = arg0.map:GetFleet()

	if arg0.fleet ~= var0 then
		arg0:RemoveFleetListener(arg0.fleet)

		arg0.fleet = var0

		arg0:AddFleetListener(arg0.fleet)

		arg0.delayCallFuncs = {}

		arg0:UpdateShipList(arg0.rtMain, arg0.fleet:GetTeamShips(TeamType.Main, true))
		arg0:UpdateShipList(arg0.rtVanguard, arg0.fleet:GetTeamShips(TeamType.Vanguard, true))
		setImageSprite(arg0.rtFleetBar:Find("text_selected/x"), getImageSprite(arg0.toggles[var0.index]:Find("text_selected/x")))
		arg0:OnUpdateFleetBar(nil, var0)
	end
end

function var0.UpdateAllCatSalvage(arg0)
	local var0 = nowWorld():GetNormalFleets()
	local var1 = arg0.rtSalvageList:GetChild(0)

	for iter0 = arg0.rtSalvageList.childCount + 1, #var0 do
		cloneTplTo(var1, arg0.rtSalvageList, var1.name)
	end

	for iter1 = #var0 + 1, arg0.rtSalvageList.childCount do
		setActive(arg0.rtSalvageList:GetChild(iter1 - 1), false)
	end

	underscore.each(var0, function(arg0)
		arg0:OnUpdateCatSalvage(nil, arg0)
	end)
end

function var0.OnUpdateCatSalvage(arg0, arg1, arg2)
	local var0 = arg2:IsCatSalvage()
	local var1 = arg0.rtSalvageList:GetChild(arg2.index - 1)

	setActive(var1, var0)

	if var0 then
		local var2 = arg2:GetDisplayCommander():getPainting()

		GetImageSpriteFromAtlasAsync("commandericon/" .. var2, "", var1:Find("icon"))
		setActive(var1:Find("rarity"), arg2:GetRarityState() > 0)
		setActive(var1:Find("doing"), arg2.catSalvageStep < #arg2.catSalvageList)
		setSlider(var1:Find("doing/Slider"), 0, #arg2.catSalvageList, arg2.catSalvageStep)
		setActive(var1:Find("finish"), arg2.catSalvageStep == #arg2.catSalvageList)
	end

	onButton(arg0, var1, function()
		arg0.onClickSalvage(arg2.id)
	end, SFX_PANEL)
end

function var0.OnUpdateSubmarineSupport(arg0)
	local var0 = nowWorld()

	setActive(arg0.rtSubBar, var0:IsSubmarineSupporting())

	local var1 = var0:GetSubmarineFleet()

	if var1 then
		local var2, var3 = var1:GetAmmo()

		setText(arg0.rtAmmo, var2 .. "/" .. var3)
		setGray(arg0.rtSubBar, var1:GetAmmo() <= 0, true)
	end
end

function var0.OnUpdateFleetOrder(arg0)
	arg0.delayCallFuncs = {}

	arg0:UpdateShipList(arg0.rtMain, arg0.fleet:GetTeamShips(TeamType.Main, true))
	arg0:UpdateShipList(arg0.rtVanguard, arg0.fleet:GetTeamShips(TeamType.Vanguard, true))
end

function var0.GetShipObject(arg0, arg1)
	local var0 = {
		[TeamType.Main] = arg0.rtMain,
		[TeamType.Vanguard] = arg0.rtVanguard
	}

	for iter0, iter1 in pairs(var0) do
		local var1 = arg0.fleet:GetTeamShips(iter0, true)

		for iter2, iter3 in ipairs(var1) do
			if arg1.id == iter3.id then
				return iter1:GetChild(iter2 - 1)
			end
		end
	end
end

function var0.OnUpdateShipHpRate(arg0, arg1, arg2)
	local var0 = arg0:GetShipObject(arg2)

	assert(var0, "can not find this ship in display fleet: " .. arg2.id)
	table.insert(arg0.delayCallFuncs[arg2.id], function()
		arg0:ShipDamageDisplay(arg2, var0, true)
	end)

	if not arg0.delayCallFuncs[arg2.id].isDoing then
		table.remove(arg0.delayCallFuncs[arg2.id], 1)()
	end
end

function var0.OnUpdateShipBroken(arg0, arg1, arg2)
	local var0 = arg0:GetShipObject(arg2)

	setActive(var0:Find("broken"), arg2:IsBroken())
end

function var0.OnUpdateFleetBar(arg0, arg1, arg2)
	local var0 = arg2:GetWatchingBuff()

	setActive(arg0.rtFleetBar:Find("watching_buff"), var0)

	if var0 then
		if #var0.config.icon > 0 then
			GetImageSpriteFromAtlasAsync("world/watchingbuff/" .. var0.config.icon, "", arg0.rtFleetBar:Find("watching_buff"))
		else
			setImageSprite(arg0.rtFleetBar:Find("watching_buff"), nil)
		end
	end
end

function var0.UpdateShipList(arg0, arg1, arg2)
	local var0 = UIItemList.New(arg1, arg0.rtShip)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2[arg1 + 1]

			updateShip(arg2, WorldConst.FetchShipVO(var0.id))
			onButton(arg0, arg2:Find("agony"), function()
				if arg0.onAgonyClickEnabled then
					arg0.onAgonyClick()
				end
			end, SFX_PANEL)

			arg0.delayCallFuncs[var0.id] = {}

			arg0:ShipDamageDisplay(var0, arg2)

			local var1 = GetOrAddComponent(arg2, "UILongPressTrigger").onLongPressed

			pg.DelegateInfo.Add(arg0, var1)
			var1:RemoveAllListeners()
			var1:AddListener(function()
				arg0.onLongPress(var0)
			end)
		end
	end)
	var0:align(#arg2)
end

function var0.ShipDamageDisplay(arg0, arg1, arg2, arg3)
	local var0 = arg2:Find("HP_POP")

	setActive(var0, true)
	setActive(var0:Find("heal"), false)
	setActive(var0:Find("normal"), false)

	local var1 = arg2:Find("blood")

	if arg3 then
		local var2 = var1:GetComponent(typeof(Slider)).value
		local var3 = WorldConst.FetchShipVO(arg1.id):getShipProperties()
		local var4 = calcFloor((arg1.hpRant - var2) / 10000 * var3[AttributeType.Durability])

		local function var5(arg0, arg1)
			setActive(arg0, true)
			setText(findTF(arg0, "text"), arg1)
			setTextAlpha(findTF(arg0, "text"), 0)

			arg0.delayCallFuncs[arg1.id].isDoing = true

			parallelAsync({
				function(arg0)
					LeanTween.moveY(arg0, 60, 1):setOnComplete(System.Action(arg0))
				end,
				function(arg0)
					LeanTween.textAlpha(findTF(arg0, "text"), 1, 0.3):setOnComplete(System.Action(function()
						LeanTween.textAlpha(findTF(arg0, "text"), 0, 0.5):setDelay(0.4):setOnComplete(System.Action(arg0))
					end))
				end
			}, function()
				arg0.localPosition = Vector3(0, 0, 0)

				if not arg0.delayCallFuncs[arg1.id] then
					return
				end

				arg0.delayCallFuncs[arg1.id].isDoing = false

				if #arg0.delayCallFuncs[arg1.id] > 0 then
					table.remove(arg0.delayCallFuncs[arg1.id], 1)()
				end
			end)
		end

		local function var6(arg0)
			local var0 = arg0.transform.localPosition.x

			LeanTween.moveX(arg0, var0, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(4)
			LeanTween.alpha(findTF(arg0, "red"), 0.5, 0.4)
			LeanTween.alpha(findTF(arg0, "red"), 0, 0.4):setDelay(0.4)
		end

		if var4 > 0 then
			var5(findTF(var0, "heal"), var4)
		elseif var4 < 0 then
			var6(arg2)
			var5(findTF(var0, "normal"), var4)
		end
	end

	local var7 = var1:Find("fillarea/green")
	local var8 = var1:Find("fillarea/red")
	local var9 = not arg1:IsHpSafe()

	setActive(var7, not var9)
	setActive(var8, var9)

	var1:GetComponent(typeof(Slider)).fillRect = var9 and var8 or var7

	setSlider(var1, 0, 10000, arg1.hpRant)

	local var10 = arg2:Find("agony")

	setActive(var10, var9)

	local var11 = arg2:Find("broken")

	setActive(var11, arg1:IsBroken())
end

function var0.ShowToggleMask(arg0, arg1)
	local var0 = arg0.toggleList.position

	var0.x = arg0.rtFleetBar.position.x
	arg0.toggleList.position = var0

	setActive(arg0.toggleMask, true)

	local var1 = arg0.map:GetNormalFleets()

	for iter0, iter1 in ipairs(arg0.toggles) do
		local var2 = var1[iter0]

		setActive(iter1, var2)

		if var2 then
			local var3 = iter0 == arg0.map.findex
			local var4 = var2:GetWatchingBuff()

			setActive(iter1:Find("selected"), var3)
			setActive(iter1:Find("text"), not var3)
			setActive(iter1:Find("text_selected"), var3)
			setActive(iter1:Find("watching_buff"), var4)

			if var4 then
				if #var4.config.icon > 0 then
					GetImageSpriteFromAtlasAsync("world/watchingbuff/" .. var4.config.icon, "", iter1:Find("watching_buff"))
				else
					setImageSprite(iter1:Find("watching_buff"), nil)
				end
			end

			onButton(arg0, iter1, function()
				arg0:HideToggleMask()
				arg1(var2)
			end, SFX_UI_TAG)
		end
	end
end

function var0.HideToggleMask(arg0)
	setActive(arg0.toggleMask, false)
end

function var0.Collpase(arg0)
	setActive(arg0.rtFleet, not isActive(arg0.rtFleet))

	local var0 = arg0.rtArrow.localScale

	var0.x = -var0.x
	arg0.rtArrow.localScale = var0
end

return var0
