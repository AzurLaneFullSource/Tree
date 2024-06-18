local var0_0 = class("WSMapLeft", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.Listeners = {
	onUpdateShipHpRate = "OnUpdateShipHpRate",
	onUpdateFleetOrder = "OnUpdateFleetOrder",
	onUpdateFleetBar = "OnUpdateFleetBar",
	onUpdateCatSalvage = "OnUpdateCatSalvage",
	onUpdateShipBroken = "OnUpdateShipBroken",
	onUpdateSelectedFleet = "OnUpdateSelectedFleet"
}
var0_0.EventSelectFleet = "WSMapLeft.EventSelectFleet"

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.delayCallFuncs = {}

	arg0_1:Init()
	arg0_1:AddWorldListener()
	arg0_1:UpdateAllCatSalvage()
end

function var0_0.Dispose(arg0_2)
	local function var0_2(arg0_3)
		LeanTween.cancel(go(arg0_3))
		LeanTween.cancel(go(arg0_3:Find("text")))
	end

	eachChild(arg0_2.rtMain, function(arg0_4)
		local var0_4 = arg0_4:Find("HP_POP")

		var0_2(var0_4:Find("heal"))
		var0_2(var0_4:Find("normal"))
	end)
	eachChild(arg0_2.rtVanguard, function(arg0_5)
		local var0_5 = arg0_5:Find("HP_POP")

		var0_2(var0_5:Find("heal"))
		var0_2(var0_5:Find("normal"))
	end)
	arg0_2:RemoveWorldListener()
	arg0_2:RemoveFleetListener(arg0_2.fleet)
	arg0_2:RemoveMapListener()
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_6)
	local var0_6 = arg0_6.transform

	arg0_6.rtBG = var0_6:Find("bg")
	arg0_6.rtFleet = arg0_6.rtBG:Find("fleet")
	arg0_6.rtMain = arg0_6.rtFleet:Find("main")
	arg0_6.rtVanguard = arg0_6.rtFleet:Find("vanguard")
	arg0_6.rtShip = arg0_6.rtFleet:Find("shiptpl")
	arg0_6.btnCollapse = arg0_6.rtBG:Find("collapse")
	arg0_6.rtArrow = arg0_6.btnCollapse:Find("arrow")
	arg0_6.rtFleetBar = var0_6:Find("other/fleet_bar")
	arg0_6.toggleMask = var0_6:Find("mask")
	arg0_6.toggleList = arg0_6.toggleMask:Find("list")
	arg0_6.toggles = {}

	for iter0_6 = 0, arg0_6.toggleList.childCount - 1 do
		table.insert(arg0_6.toggles, arg0_6.toggleList:GetChild(iter0_6))
	end

	arg0_6.rtSubBar = var0_6:Find("other/sub_bar")
	arg0_6.rtAmmo = arg0_6.rtSubBar:Find("text")
	arg0_6.rtSalvageList = var0_6:Find("other/salvage_list")

	setActive(arg0_6.rtShip, false)
	setActive(arg0_6.toggleMask, false)
	setActive(arg0_6.rtSubBar, false)
	onButton(arg0_6, arg0_6.btnCollapse, function()
		arg0_6:Collpase()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rtFleetBar, function()
		arg0_6:ShowToggleMask(function(arg0_9)
			arg0_6:DispatchEvent(var0_0.EventSelectFleet, arg0_9)
		end)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.toggleMask, function()
		arg0_6:HideToggleMask()
	end, SFX_PANEL)
end

function var0_0.AddWorldListener(arg0_11)
	underscore.each(nowWorld():GetNormalFleets(), function(arg0_12)
		arg0_12:AddListener(WorldMapFleet.EventUpdateCatSalvage, arg0_11.onUpdateCatSalvage)
	end)
end

function var0_0.RemoveWorldListener(arg0_13)
	underscore.each(nowWorld():GetNormalFleets(), function(arg0_14)
		arg0_14:RemoveListener(WorldMapFleet.EventUpdateCatSalvage, arg0_13.onUpdateCatSalvage)
	end)
end

function var0_0.UpdateMap(arg0_15, arg1_15)
	arg0_15:RemoveMapListener()

	arg0_15.map = arg1_15

	arg0_15:AddMapListener()
	arg0_15:OnUpdateSelectedFleet()
	arg0_15:OnUpdateSubmarineSupport()
end

function var0_0.AddMapListener(arg0_16)
	if arg0_16.map then
		arg0_16.map:AddListener(WorldMap.EventUpdateFIndex, arg0_16.onUpdateSelectedFleet)
	end
end

function var0_0.RemoveMapListener(arg0_17)
	if arg0_17.map then
		arg0_17.map:RemoveListener(WorldMap.EventUpdateFIndex, arg0_17.onUpdateSelectedFleet)
	end
end

function var0_0.AddFleetListener(arg0_18, arg1_18)
	if arg1_18 then
		arg1_18:AddListener(WorldMapFleet.EventUpdateShipOrder, arg0_18.onUpdateFleetOrder)
		arg1_18:AddListener(WorldMapFleet.EventUpdateBuff, arg0_18.onUpdateFleetBar)
		_.each(arg1_18:GetShips(true), function(arg0_19)
			arg0_19:AddListener(WorldMapShip.EventHpRantChange, arg0_18.onUpdateShipHpRate)
			arg0_19:AddListener(WorldMapShip.EventUpdateBroken, arg0_18.onUpdateShipBroken)
		end)
	end
end

function var0_0.RemoveFleetListener(arg0_20, arg1_20)
	if arg1_20 then
		arg1_20:RemoveListener(WorldMapFleet.EventUpdateShipOrder, arg0_20.onUpdateFleetOrder)
		arg1_20:RemoveListener(WorldMapFleet.EventUpdateBuff, arg0_20.onUpdateFleetBar)
		_.each(arg1_20:GetShips(true), function(arg0_21)
			arg0_21:RemoveListener(WorldMapShip.EventHpRantChange, arg0_20.onUpdateShipHpRate)
			arg0_21:RemoveListener(WorldMapShip.EventUpdateBroken, arg0_20.onUpdateShipBroken)
		end)
	end
end

function var0_0.OnUpdateSelectedFleet(arg0_22)
	local var0_22 = arg0_22.map:GetFleet()

	if arg0_22.fleet ~= var0_22 then
		arg0_22:RemoveFleetListener(arg0_22.fleet)

		arg0_22.fleet = var0_22

		arg0_22:AddFleetListener(arg0_22.fleet)

		arg0_22.delayCallFuncs = {}

		arg0_22:UpdateShipList(arg0_22.rtMain, arg0_22.fleet:GetTeamShips(TeamType.Main, true))
		arg0_22:UpdateShipList(arg0_22.rtVanguard, arg0_22.fleet:GetTeamShips(TeamType.Vanguard, true))
		setImageSprite(arg0_22.rtFleetBar:Find("text_selected/x"), getImageSprite(arg0_22.toggles[var0_22.index]:Find("text_selected/x")))
		arg0_22:OnUpdateFleetBar(nil, var0_22)
	end
end

function var0_0.UpdateAllCatSalvage(arg0_23)
	local var0_23 = nowWorld():GetNormalFleets()
	local var1_23 = arg0_23.rtSalvageList:GetChild(0)

	for iter0_23 = arg0_23.rtSalvageList.childCount + 1, #var0_23 do
		cloneTplTo(var1_23, arg0_23.rtSalvageList, var1_23.name)
	end

	for iter1_23 = #var0_23 + 1, arg0_23.rtSalvageList.childCount do
		setActive(arg0_23.rtSalvageList:GetChild(iter1_23 - 1), false)
	end

	underscore.each(var0_23, function(arg0_24)
		arg0_23:OnUpdateCatSalvage(nil, arg0_24)
	end)
end

function var0_0.OnUpdateCatSalvage(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg2_25:IsCatSalvage()
	local var1_25 = arg0_25.rtSalvageList:GetChild(arg2_25.index - 1)

	setActive(var1_25, var0_25)

	if var0_25 then
		local var2_25 = arg2_25:GetDisplayCommander():getPainting()

		GetImageSpriteFromAtlasAsync("commandericon/" .. var2_25, "", var1_25:Find("icon"))
		setActive(var1_25:Find("rarity"), arg2_25:GetRarityState() > 0)
		setActive(var1_25:Find("doing"), arg2_25.catSalvageStep < #arg2_25.catSalvageList)
		setSlider(var1_25:Find("doing/Slider"), 0, #arg2_25.catSalvageList, arg2_25.catSalvageStep)
		setActive(var1_25:Find("finish"), arg2_25.catSalvageStep == #arg2_25.catSalvageList)
	end

	onButton(arg0_25, var1_25, function()
		arg0_25.onClickSalvage(arg2_25.id)
	end, SFX_PANEL)
end

function var0_0.OnUpdateSubmarineSupport(arg0_27)
	local var0_27 = nowWorld()

	setActive(arg0_27.rtSubBar, var0_27:IsSubmarineSupporting())

	local var1_27 = var0_27:GetSubmarineFleet()

	if var1_27 then
		local var2_27, var3_27 = var1_27:GetAmmo()

		setText(arg0_27.rtAmmo, var2_27 .. "/" .. var3_27)
		setGray(arg0_27.rtSubBar, var1_27:GetAmmo() <= 0, true)
	end
end

function var0_0.OnUpdateFleetOrder(arg0_28)
	arg0_28.delayCallFuncs = {}

	arg0_28:UpdateShipList(arg0_28.rtMain, arg0_28.fleet:GetTeamShips(TeamType.Main, true))
	arg0_28:UpdateShipList(arg0_28.rtVanguard, arg0_28.fleet:GetTeamShips(TeamType.Vanguard, true))
end

function var0_0.GetShipObject(arg0_29, arg1_29)
	local var0_29 = {
		[TeamType.Main] = arg0_29.rtMain,
		[TeamType.Vanguard] = arg0_29.rtVanguard
	}

	for iter0_29, iter1_29 in pairs(var0_29) do
		local var1_29 = arg0_29.fleet:GetTeamShips(iter0_29, true)

		for iter2_29, iter3_29 in ipairs(var1_29) do
			if arg1_29.id == iter3_29.id then
				return iter1_29:GetChild(iter2_29 - 1)
			end
		end
	end
end

function var0_0.OnUpdateShipHpRate(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30:GetShipObject(arg2_30)

	assert(var0_30, "can not find this ship in display fleet: " .. arg2_30.id)
	table.insert(arg0_30.delayCallFuncs[arg2_30.id], function()
		arg0_30:ShipDamageDisplay(arg2_30, var0_30, true)
	end)

	if not arg0_30.delayCallFuncs[arg2_30.id].isDoing then
		table.remove(arg0_30.delayCallFuncs[arg2_30.id], 1)()
	end
end

function var0_0.OnUpdateShipBroken(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32:GetShipObject(arg2_32)

	setActive(var0_32:Find("broken"), arg2_32:IsBroken())
end

function var0_0.OnUpdateFleetBar(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg2_33:GetWatchingBuff()

	setActive(arg0_33.rtFleetBar:Find("watching_buff"), var0_33)

	if var0_33 then
		if #var0_33.config.icon > 0 then
			GetImageSpriteFromAtlasAsync("world/watchingbuff/" .. var0_33.config.icon, "", arg0_33.rtFleetBar:Find("watching_buff"))
		else
			setImageSprite(arg0_33.rtFleetBar:Find("watching_buff"), nil)
		end
	end
end

function var0_0.UpdateShipList(arg0_34, arg1_34, arg2_34)
	local var0_34 = UIItemList.New(arg1_34, arg0_34.rtShip)

	var0_34:make(function(arg0_35, arg1_35, arg2_35)
		if arg0_35 == UIItemList.EventUpdate then
			local var0_35 = arg2_34[arg1_35 + 1]

			updateShip(arg2_35, WorldConst.FetchShipVO(var0_35.id))
			onButton(arg0_34, arg2_35:Find("agony"), function()
				if arg0_34.onAgonyClickEnabled then
					arg0_34.onAgonyClick()
				end
			end, SFX_PANEL)

			arg0_34.delayCallFuncs[var0_35.id] = {}

			arg0_34:ShipDamageDisplay(var0_35, arg2_35)

			local var1_35 = GetOrAddComponent(arg2_35, "UILongPressTrigger").onLongPressed

			pg.DelegateInfo.Add(arg0_34, var1_35)
			var1_35:RemoveAllListeners()
			var1_35:AddListener(function()
				arg0_34.onLongPress(var0_35)
			end)
		end
	end)
	var0_34:align(#arg2_34)
end

function var0_0.ShipDamageDisplay(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = arg2_38:Find("HP_POP")

	setActive(var0_38, true)
	setActive(var0_38:Find("heal"), false)
	setActive(var0_38:Find("normal"), false)

	local var1_38 = arg2_38:Find("blood")

	if arg3_38 then
		local var2_38 = var1_38:GetComponent(typeof(Slider)).value
		local var3_38 = WorldConst.FetchShipVO(arg1_38.id):getShipProperties()
		local var4_38 = calcFloor((arg1_38.hpRant - var2_38) / 10000 * var3_38[AttributeType.Durability])

		local function var5_38(arg0_39, arg1_39)
			setActive(arg0_39, true)
			setText(findTF(arg0_39, "text"), arg1_39)
			setTextAlpha(findTF(arg0_39, "text"), 0)

			arg0_38.delayCallFuncs[arg1_38.id].isDoing = true

			parallelAsync({
				function(arg0_40)
					LeanTween.moveY(arg0_39, 60, 1):setOnComplete(System.Action(arg0_40))
				end,
				function(arg0_41)
					LeanTween.textAlpha(findTF(arg0_39, "text"), 1, 0.3):setOnComplete(System.Action(function()
						LeanTween.textAlpha(findTF(arg0_39, "text"), 0, 0.5):setDelay(0.4):setOnComplete(System.Action(arg0_41))
					end))
				end
			}, function()
				arg0_39.localPosition = Vector3(0, 0, 0)

				if not arg0_38.delayCallFuncs[arg1_38.id] then
					return
				end

				arg0_38.delayCallFuncs[arg1_38.id].isDoing = false

				if #arg0_38.delayCallFuncs[arg1_38.id] > 0 then
					table.remove(arg0_38.delayCallFuncs[arg1_38.id], 1)()
				end
			end)
		end

		local function var6_38(arg0_44)
			local var0_44 = arg0_44.transform.localPosition.x

			LeanTween.moveX(arg0_44, var0_44, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(4)
			LeanTween.alpha(findTF(arg0_44, "red"), 0.5, 0.4)
			LeanTween.alpha(findTF(arg0_44, "red"), 0, 0.4):setDelay(0.4)
		end

		if var4_38 > 0 then
			var5_38(findTF(var0_38, "heal"), var4_38)
		elseif var4_38 < 0 then
			var6_38(arg2_38)
			var5_38(findTF(var0_38, "normal"), var4_38)
		end
	end

	local var7_38 = var1_38:Find("fillarea/green")
	local var8_38 = var1_38:Find("fillarea/red")
	local var9_38 = not arg1_38:IsHpSafe()

	setActive(var7_38, not var9_38)
	setActive(var8_38, var9_38)

	var1_38:GetComponent(typeof(Slider)).fillRect = var9_38 and var8_38 or var7_38

	setSlider(var1_38, 0, 10000, arg1_38.hpRant)

	local var10_38 = arg2_38:Find("agony")

	setActive(var10_38, var9_38)

	local var11_38 = arg2_38:Find("broken")

	setActive(var11_38, arg1_38:IsBroken())
end

function var0_0.ShowToggleMask(arg0_45, arg1_45)
	local var0_45 = arg0_45.toggleList.position

	var0_45.x = arg0_45.rtFleetBar.position.x
	arg0_45.toggleList.position = var0_45

	setActive(arg0_45.toggleMask, true)

	local var1_45 = arg0_45.map:GetNormalFleets()

	for iter0_45, iter1_45 in ipairs(arg0_45.toggles) do
		local var2_45 = var1_45[iter0_45]

		setActive(iter1_45, var2_45)

		if var2_45 then
			local var3_45 = iter0_45 == arg0_45.map.findex
			local var4_45 = var2_45:GetWatchingBuff()

			setActive(iter1_45:Find("selected"), var3_45)
			setActive(iter1_45:Find("text"), not var3_45)
			setActive(iter1_45:Find("text_selected"), var3_45)
			setActive(iter1_45:Find("watching_buff"), var4_45)

			if var4_45 then
				if #var4_45.config.icon > 0 then
					GetImageSpriteFromAtlasAsync("world/watchingbuff/" .. var4_45.config.icon, "", iter1_45:Find("watching_buff"))
				else
					setImageSprite(iter1_45:Find("watching_buff"), nil)
				end
			end

			onButton(arg0_45, iter1_45, function()
				arg0_45:HideToggleMask()
				arg1_45(var2_45)
			end, SFX_UI_TAG)
		end
	end
end

function var0_0.HideToggleMask(arg0_47)
	setActive(arg0_47.toggleMask, false)
end

function var0_0.Collpase(arg0_48)
	setActive(arg0_48.rtFleet, not isActive(arg0_48.rtFleet))

	local var0_48 = arg0_48.rtArrow.localScale

	var0_48.x = -var0_48.x
	arg0_48.rtArrow.localScale = var0_48
end

return var0_0
