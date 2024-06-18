local var0_0 = class("WSMapTop", import("...BaseEntity"))

var0_0.Fields = {
	map = "table",
	btnBack = "userdata",
	rtGlobalBuffs = "userdata",
	gid = "number",
	rtResource = "userdata",
	rtTime = "userdata",
	cmdSkills = "table",
	rtFleetBuffs = "userdata",
	rtCmdSkills = "userdata",
	entrance = "table",
	fleet = "table",
	rtPoisonRate = "userdata",
	rtMapName = "userdata",
	cmdSkillFunc = "function",
	fleetBuffItemList = "table",
	world = "table",
	transform = "userdata",
	globalBuffItemList = "table",
	cmdSkillItemList = "table",
	globalBuffs = "table",
	poisonFunc = "function",
	fleetBuffs = "table",
	rtMoveLimit = "userdata"
}
var0_0.Listeners = {
	onUpdateFleetBuff = "OnUpdateFleetBuff",
	onUpdateGlobalBuff = "OnUpdateGlobalBuff",
	onUpdateCmdSkill = "OnUpdateCmdSkill",
	onUpdateSelectedFleet = "OnUpdateSelectedFleet"
}

function var0_0.Setup(arg0_1)
	local var0_1 = nowWorld()

	var0_1:AddListener(World.EventUpdateGlobalBuff, arg0_1.onUpdateGlobalBuff)
	var0_1:GetAtlas():AddListener(WorldAtlas.EventUpdateActiveMap, arg0_1.onUpdateFleetBuff)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	local var0_2 = nowWorld()

	var0_2:RemoveListener(World.EventUpdateGlobalBuff, arg0_2.onUpdateGlobalBuff)
	var0_2:GetAtlas():RemoveListener(WorldAtlas.EventUpdateActiveMap, arg0_2.onUpdateFleetBuff)
	arg0_2:RemoveFleetListener(arg0_2.fleet)
	arg0_2:RemoveMapListener()
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

local function var1_0(arg0_3, arg1_3)
	if arg1_3.config.icon and #arg1_3.config.icon > 0 then
		GetImageSpriteFromAtlasAsync("world/buff/" .. arg1_3.config.icon, "", arg0_3:Find("icon"))
	else
		clearImageSprite(arg0_3:Find("icon"))
	end

	setText(arg0_3:Find("floor"), arg1_3:GetFloor())
	setActive(arg0_3:Find("floor"), arg1_3.config.buff_maxfloor > 1)

	local var0_3 = arg1_3:GetLost()

	setText(arg0_3:Find("lost"), var0_3)
	setActive(arg0_3:Find("lost"), var0_3)
	onButton(self, arg0_3, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = "",
			yesText = "text_confirm",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = Drop.New({
				isWorldBuff = true,
				type = DROP_TYPE_STRATEGY,
				id = arg1_3.id
			})
		})
	end, SFX_PANEL)
end

function var0_0.Init(arg0_5)
	local var0_5 = arg0_5.transform

	arg0_5.btnBack = var0_5:Find("back_button")
	arg0_5.rtMapName = var0_5:Find("title/name")
	arg0_5.rtTime = var0_5:Find("title/time")
	arg0_5.rtResource = var0_5:Find("resources")
	arg0_5.rtGlobalBuffs = var0_5:Find("features/status_field/global_buffs")
	arg0_5.rtMoveLimit = var0_5:Find("features/status_field/move_limit")
	arg0_5.rtPoisonRate = var0_5:Find("features/status_field/poison_rate")
	arg0_5.rtFleetBuffs = var0_5:Find("features/fleet_field/fleet_buffs")
	arg0_5.rtCmdSkills = var0_5:Find("features/fleet_field/cmd_skills")

	setText(arg0_5.rtMapName, "")
	setText(arg0_5.rtTime, "")

	arg0_5.globalBuffItemList = UIItemList.New(arg0_5.rtGlobalBuffs, arg0_5.rtGlobalBuffs:GetChild(0))

	arg0_5.globalBuffItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			var1_0(arg2_6, arg0_5.globalBuffs[arg1_6 + 1])
		end
	end)

	arg0_5.fleetBuffItemList = UIItemList.New(arg0_5.rtFleetBuffs, arg0_5.rtFleetBuffs:GetChild(0))

	arg0_5.fleetBuffItemList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			var1_0(arg2_7, arg0_5.fleetBuffs[arg1_7 + 1])
		end
	end)

	arg0_5.cmdSkillItemList = UIItemList.New(arg0_5.rtCmdSkills, arg0_5.rtCmdSkills:GetChild(0))

	arg0_5.cmdSkillItemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_5.cmdSkills[arg1_8 + 1]

			GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0_8:getConfig("icon"), "", arg2_8:Find("icon"))
			setText(arg2_8:Find("floor"), "Lv." .. var0_8:getConfig("lv"))
			setActive(arg2_8:Find("floor"), true)
			setActive(arg2_8:Find("lost"), false)
			onButton(arg0_5, arg2_8, function()
				arg0_5.cmdSkillFunc(var0_8)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.Update(arg0_10, arg1_10, arg2_10)
	if arg0_10.entrance ~= arg1_10 or arg0_10.map ~= arg2_10 or arg0_10.gid ~= arg2_10.gid then
		arg0_10:RemoveMapListener()

		arg0_10.entrance = arg1_10
		arg0_10.map = arg2_10
		arg0_10.gid = arg2_10.gid

		arg0_10:AddMapListener()
		arg0_10:OnUpdateMap()
		arg0_10:OnUpdateSelectedFleet()
		arg0_10:OnUpdateGlobalBuff()
		arg0_10:OnUpdatePoison()
		arg0_10:OnUpdateMoveLimit()
	end
end

function var0_0.AddMapListener(arg0_11)
	if arg0_11.map then
		arg0_11.map:AddListener(WorldMap.EventUpdateFIndex, arg0_11.onUpdateSelectedFleet)
	end
end

function var0_0.RemoveMapListener(arg0_12)
	if arg0_12.map then
		arg0_12.map:RemoveListener(WorldMap.EventUpdateFIndex, arg0_12.onUpdateSelectedFleet)
	end
end

function var0_0.AddFleetListener(arg0_13, arg1_13)
	if arg1_13 then
		arg1_13:AddListener(WorldMapFleet.EventUpdateBuff, arg0_13.onUpdateFleetBuff)
		arg1_13:AddListener(WorldMapFleet.EventUpdateDamageLevel, arg0_13.onUpdateFleetBuff)
		arg1_13:AddListener(WorldMapFleet.EventUpdateCatSalvage, arg0_13.onUpdateCmdSkill)
	end
end

function var0_0.RemoveFleetListener(arg0_14, arg1_14)
	if arg1_14 then
		arg1_14:RemoveListener(WorldMapFleet.EventUpdateBuff, arg0_14.onUpdateFleetBuff)
		arg1_14:RemoveListener(WorldMapFleet.EventUpdateDamageLevel, arg0_14.onUpdateFleetBuff)
		arg1_14:RemoveListener(WorldMapFleet.EventUpdateCatSalvage, arg0_14.onUpdateCmdSkill)
	end
end

function var0_0.OnUpdateMap(arg0_15)
	setText(arg0_15.rtMapName, arg0_15.map:GetName(arg0_15.entrance))
end

function var0_0.OnUpdateSelectedFleet(arg0_16)
	local var0_16 = arg0_16.map:GetFleet()

	if arg0_16.fleet ~= var0_16 then
		arg0_16:RemoveFleetListener(arg0_16.fleet)

		arg0_16.fleet = var0_16

		arg0_16:AddFleetListener(arg0_16.fleet)
		arg0_16:OnUpdateFleetBuff()
		arg0_16:OnUpdateCmdSkill()
	end
end

function var0_0.OnUpdateGlobalBuff(arg0_17)
	arg0_17.globalBuffs = nowWorld():GetWorldMapBuffs()

	arg0_17.globalBuffItemList:align(#arg0_17.globalBuffs)
end

function var0_0.OnUpdateMoveLimit(arg0_18)
	local var0_18 = not arg0_18.map:IsUnlockFleetMode()

	setActive(arg0_18.rtMoveLimit, var0_18)

	if var0_18 then
		local var1_18 = WorldBuff.New()

		var1_18:Setup({
			floor = 0,
			id = WorldConst.MoveLimitBuffId
		})
		var1_0(arg0_18.rtMoveLimit, var1_18)
	end
end

function var0_0.OnUpdatePoison(arg0_19)
	local var0_19, var1_19 = arg0_19.map:GetEventPoisonRate()

	setActive(arg0_19.rtPoisonRate, var1_19 > 0)

	if var1_19 > 0 then
		local var2_19 = calcFloor(var0_19 / var1_19 * 100)
		local var3_19 = Clone(pg.gameset.world_sairen_infection.description)

		table.insert(var3_19, 1, 0)
		table.insert(var3_19, 999)
		eachChild(arg0_19.rtPoisonRate:Find("bg/ring"), function(arg0_20)
			local var0_20 = arg0_20:GetSiblingIndex() + 1

			if var2_19 >= var3_19[var0_20] and var2_19 < var3_19[var0_20 + 1] then
				setActive(arg0_20, true)

				arg0_20:GetComponent(typeof(Image)).fillAmount = var2_19 / 100
			else
				setActive(arg0_20, false)
			end

			setText(arg0_19.rtPoisonRate:Find("bg/Text"), var2_19 .. "%")
		end)
		onButton(arg0_19, arg0_19.rtPoisonRate, function()
			arg0_19.poisonFunc(var2_19)
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateFleetBuff(arg0_22)
	arg0_22.fleetBuffs = arg0_22.fleet:GetBuffList()

	local var0_22 = arg0_22.fleet:GetDamageBuff()

	if var0_22 then
		table.insert(arg0_22.fleetBuffs, 1, var0_22)
	end

	arg0_22.fleetBuffItemList:align(#arg0_22.fleetBuffs)
	setActive(arg0_22.rtFleetBuffs, #arg0_22.fleetBuffs > 0)
end

function var0_0.OnUpdateCmdSkill(arg0_23)
	if arg0_23.fleet:IsCatSalvage() then
		arg0_23.cmdSkills = {}
	else
		arg0_23.cmdSkills = _.map(_.values(arg0_23.fleet:getCommanders()), function(arg0_24)
			return arg0_24:getSkills()[1]
		end)
	end

	arg0_23.cmdSkillItemList:align(#arg0_23.cmdSkills)
	setActive(arg0_23.rtCmdSkills, #arg0_23.cmdSkills > 0)
end

return var0_0
