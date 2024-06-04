local var0 = class("WSMapTop", import("...BaseEntity"))

var0.Fields = {
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
var0.Listeners = {
	onUpdateFleetBuff = "OnUpdateFleetBuff",
	onUpdateGlobalBuff = "OnUpdateGlobalBuff",
	onUpdateCmdSkill = "OnUpdateCmdSkill",
	onUpdateSelectedFleet = "OnUpdateSelectedFleet"
}

function var0.Setup(arg0)
	local var0 = nowWorld()

	var0:AddListener(World.EventUpdateGlobalBuff, arg0.onUpdateGlobalBuff)
	var0:GetAtlas():AddListener(WorldAtlas.EventUpdateActiveMap, arg0.onUpdateFleetBuff)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	local var0 = nowWorld()

	var0:RemoveListener(World.EventUpdateGlobalBuff, arg0.onUpdateGlobalBuff)
	var0:GetAtlas():RemoveListener(WorldAtlas.EventUpdateActiveMap, arg0.onUpdateFleetBuff)
	arg0:RemoveFleetListener(arg0.fleet)
	arg0:RemoveMapListener()
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

local function var1(arg0, arg1)
	if arg1.config.icon and #arg1.config.icon > 0 then
		GetImageSpriteFromAtlasAsync("world/buff/" .. arg1.config.icon, "", arg0:Find("icon"))
	else
		clearImageSprite(arg0:Find("icon"))
	end

	setText(arg0:Find("floor"), arg1:GetFloor())
	setActive(arg0:Find("floor"), arg1.config.buff_maxfloor > 1)

	local var0 = arg1:GetLost()

	setText(arg0:Find("lost"), var0)
	setActive(arg0:Find("lost"), var0)
	onButton(self, arg0, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = "",
			yesText = "text_confirm",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = Drop.New({
				isWorldBuff = true,
				type = DROP_TYPE_STRATEGY,
				id = arg1.id
			})
		})
	end, SFX_PANEL)
end

function var0.Init(arg0)
	local var0 = arg0.transform

	arg0.btnBack = var0:Find("back_button")
	arg0.rtMapName = var0:Find("title/name")
	arg0.rtTime = var0:Find("title/time")
	arg0.rtResource = var0:Find("resources")
	arg0.rtGlobalBuffs = var0:Find("features/status_field/global_buffs")
	arg0.rtMoveLimit = var0:Find("features/status_field/move_limit")
	arg0.rtPoisonRate = var0:Find("features/status_field/poison_rate")
	arg0.rtFleetBuffs = var0:Find("features/fleet_field/fleet_buffs")
	arg0.rtCmdSkills = var0:Find("features/fleet_field/cmd_skills")

	setText(arg0.rtMapName, "")
	setText(arg0.rtTime, "")

	arg0.globalBuffItemList = UIItemList.New(arg0.rtGlobalBuffs, arg0.rtGlobalBuffs:GetChild(0))

	arg0.globalBuffItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			var1(arg2, arg0.globalBuffs[arg1 + 1])
		end
	end)

	arg0.fleetBuffItemList = UIItemList.New(arg0.rtFleetBuffs, arg0.rtFleetBuffs:GetChild(0))

	arg0.fleetBuffItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			var1(arg2, arg0.fleetBuffs[arg1 + 1])
		end
	end)

	arg0.cmdSkillItemList = UIItemList.New(arg0.rtCmdSkills, arg0.rtCmdSkills:GetChild(0))

	arg0.cmdSkillItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.cmdSkills[arg1 + 1]

			GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0:getConfig("icon"), "", arg2:Find("icon"))
			setText(arg2:Find("floor"), "Lv." .. var0:getConfig("lv"))
			setActive(arg2:Find("floor"), true)
			setActive(arg2:Find("lost"), false)
			onButton(arg0, arg2, function()
				arg0.cmdSkillFunc(var0)
			end, SFX_PANEL)
		end
	end)
end

function var0.Update(arg0, arg1, arg2)
	if arg0.entrance ~= arg1 or arg0.map ~= arg2 or arg0.gid ~= arg2.gid then
		arg0:RemoveMapListener()

		arg0.entrance = arg1
		arg0.map = arg2
		arg0.gid = arg2.gid

		arg0:AddMapListener()
		arg0:OnUpdateMap()
		arg0:OnUpdateSelectedFleet()
		arg0:OnUpdateGlobalBuff()
		arg0:OnUpdatePoison()
		arg0:OnUpdateMoveLimit()
	end
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
		arg1:AddListener(WorldMapFleet.EventUpdateBuff, arg0.onUpdateFleetBuff)
		arg1:AddListener(WorldMapFleet.EventUpdateDamageLevel, arg0.onUpdateFleetBuff)
		arg1:AddListener(WorldMapFleet.EventUpdateCatSalvage, arg0.onUpdateCmdSkill)
	end
end

function var0.RemoveFleetListener(arg0, arg1)
	if arg1 then
		arg1:RemoveListener(WorldMapFleet.EventUpdateBuff, arg0.onUpdateFleetBuff)
		arg1:RemoveListener(WorldMapFleet.EventUpdateDamageLevel, arg0.onUpdateFleetBuff)
		arg1:RemoveListener(WorldMapFleet.EventUpdateCatSalvage, arg0.onUpdateCmdSkill)
	end
end

function var0.OnUpdateMap(arg0)
	setText(arg0.rtMapName, arg0.map:GetName(arg0.entrance))
end

function var0.OnUpdateSelectedFleet(arg0)
	local var0 = arg0.map:GetFleet()

	if arg0.fleet ~= var0 then
		arg0:RemoveFleetListener(arg0.fleet)

		arg0.fleet = var0

		arg0:AddFleetListener(arg0.fleet)
		arg0:OnUpdateFleetBuff()
		arg0:OnUpdateCmdSkill()
	end
end

function var0.OnUpdateGlobalBuff(arg0)
	arg0.globalBuffs = nowWorld():GetWorldMapBuffs()

	arg0.globalBuffItemList:align(#arg0.globalBuffs)
end

function var0.OnUpdateMoveLimit(arg0)
	local var0 = not arg0.map:IsUnlockFleetMode()

	setActive(arg0.rtMoveLimit, var0)

	if var0 then
		local var1 = WorldBuff.New()

		var1:Setup({
			floor = 0,
			id = WorldConst.MoveLimitBuffId
		})
		var1(arg0.rtMoveLimit, var1)
	end
end

function var0.OnUpdatePoison(arg0)
	local var0, var1 = arg0.map:GetEventPoisonRate()

	setActive(arg0.rtPoisonRate, var1 > 0)

	if var1 > 0 then
		local var2 = calcFloor(var0 / var1 * 100)
		local var3 = Clone(pg.gameset.world_sairen_infection.description)

		table.insert(var3, 1, 0)
		table.insert(var3, 999)
		eachChild(arg0.rtPoisonRate:Find("bg/ring"), function(arg0)
			local var0 = arg0:GetSiblingIndex() + 1

			if var2 >= var3[var0] and var2 < var3[var0 + 1] then
				setActive(arg0, true)

				arg0:GetComponent(typeof(Image)).fillAmount = var2 / 100
			else
				setActive(arg0, false)
			end

			setText(arg0.rtPoisonRate:Find("bg/Text"), var2 .. "%")
		end)
		onButton(arg0, arg0.rtPoisonRate, function()
			arg0.poisonFunc(var2)
		end, SFX_PANEL)
	end
end

function var0.OnUpdateFleetBuff(arg0)
	arg0.fleetBuffs = arg0.fleet:GetBuffList()

	local var0 = arg0.fleet:GetDamageBuff()

	if var0 then
		table.insert(arg0.fleetBuffs, 1, var0)
	end

	arg0.fleetBuffItemList:align(#arg0.fleetBuffs)
	setActive(arg0.rtFleetBuffs, #arg0.fleetBuffs > 0)
end

function var0.OnUpdateCmdSkill(arg0)
	if arg0.fleet:IsCatSalvage() then
		arg0.cmdSkills = {}
	else
		arg0.cmdSkills = _.map(_.values(arg0.fleet:getCommanders()), function(arg0)
			return arg0:getSkills()[1]
		end)
	end

	arg0.cmdSkillItemList:align(#arg0.cmdSkills)
	setActive(arg0.rtCmdSkills, #arg0.cmdSkills > 0)
end

return var0
