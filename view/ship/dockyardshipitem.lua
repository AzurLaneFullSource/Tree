local var0 = class("DockyardShipItem")

var0.DetailType0 = 0
var0.DetailType1 = 1
var0.DetailType2 = 2
var0.DetailType3 = 3
var0.SKILL_COLOR = {
	COLOR_RED,
	COLOR_BLUE,
	COLOR_YELLOW
}

local var1 = 0.8

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.go = arg1
	arg0.tr = arg1.transform
	arg0.hideTagFlags = arg2 or {}
	arg0.blockTagFlags = arg3 or {}
	arg0.btn = GetOrAddComponent(arg1, "Button")
	arg0.content = findTF(arg0.tr, "content").gameObject

	setActive(findTF(arg0.content, "dockyard"), true)
	setActive(findTF(arg0.content, "collection"), false)

	arg0.quit = findTF(arg0.tr, "quit_button").gameObject
	arg0.detail = findTF(arg0.tr, "content/dockyard/detail").gameObject
	arg0.detailLayoutTr = findTF(arg0.detail, "layout")
	arg0.imageQuit = arg0.quit:GetComponent("Image")
	arg0.imageFrame = findTF(arg0.tr, "content/front/frame"):GetComponent("Image")
	arg0.nameTF = findTF(arg0.tr, "content/info/name_mask/name")
	arg0.npc = findTF(arg0.tr, "content/dockyard/npc")

	setActive(arg0.npc, false)

	arg0.lock = findTF(arg0.tr, "content/dockyard/container/lock")
	arg0.maskStatusOb = findTF(arg0.tr, "content/front/status_mask")
	arg0.iconStatus = findTF(arg0.tr, "content/dockyard/status")
	arg0.iconStatusMask = arg0.iconStatus:GetComponent(typeof(RectMask2D))
	arg0.iconStatusTxt = findTF(arg0.tr, "content/dockyard/status/Text"):GetComponent("Text")
	arg0.selectedGo = findTF(arg0.tr, "content/front/selected").gameObject
	arg0.energyTF = findTF(arg0.tr, "content/dockyard/container/energy")
	arg0.proposeTF = findTF(arg0.tr, "content/dockyard/propose")

	arg0.selectedGo:SetActive(false)

	arg0.hpBar = findTF(arg0.tr, "content/dockyard/blood")
	arg0.expBuff = findTF(arg0.tr, "content/expbuff")
	arg0.intimacyTF = findTF(arg0.tr, "content/intimacy")
	arg0.detailType = var0.DetailType0
	arg0.proposeModel = arg0.proposeTF:Find("heartShipCard(Clone)")

	if arg0.proposeModel then
		arg0.sg = GetComponent(arg0.proposeModel, "SkeletonGraphic")
	end

	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.userTF = findTF(arg0.tr, "content/user")

	if arg0.userTF then
		arg0.userIconTF = arg0.userTF:Find("icon"):GetComponent(typeof(Image))
		arg0.userIconFrame = arg0.userTF:Find("frame")
		arg0.userNameTF = findTF(arg0.tr, "content/user_name/Text"):GetComponent(typeof(Text))
		arg0.levelTF = findTF(arg0.tr, "content/dockyard/lv")
	end

	arg0.tagRecommand = findTF(arg0.tr, "content/recommand")
	arg0.palyerId = getProxy(PlayerProxy):getRawData().id

	ClearTweenItemAlphaAndWhite(arg0.go)
end

function var0.update(arg0, arg1)
	TweenItemAlphaAndWhite(arg0.go)

	if arg0.proposeModel then
		LeanTween.cancel(arg0.proposeModel)
		LeanTween.value(go(arg0.proposeModel), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
			arg0.sg.color = Color.New(1, 1, 1, arg0)
		end))
	end

	if arg1 then
		arg0.go.name = arg1.configId
	end

	if arg0.shipVO ~= arg1 then
		arg0.shipVO = arg1

		arg0:flush()
		arg0:flushDetail()
	end

	setActive(arg0.nameTF, false)
	setActive(arg0.nameTF, true)

	if not IsNil(arg0.levelTF) then
		setActive(arg0.levelTF, false)
		setActive(arg0.levelTF, true)
	end
end

function var0.updateDetail(arg0, arg1)
	arg0.detailType = arg1

	arg0:flushDetail()
end

function var0.updateSelected(arg0, arg1)
	arg0.selected = arg1

	arg0.selectedGo:SetActive(arg0.selected)

	if arg0.selected then
		if not arg0.selectedTwId then
			arg0.selectedTwId = LeanTween.alpha(arg0.selectedGo.transform, 0.5, var1):setFrom(0):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId
		end
	elseif arg0.selectedTwId then
		LeanTween.cancel(arg0.selectedTwId)

		arg0.selectedTwId = nil
	end
end

function var0.flush(arg0)
	local var0 = arg0.shipVO
	local var1 = tobool(var0)

	if var1 then
		if not var0:getConfigTable() then
			return
		end

		flushShipCard(arg0.tr, var0)

		local var2 = var0:isActivityNpc()

		setActive(arg0.npc, var2)

		if arg0.lock then
			arg0.lock.gameObject:SetActive(var0:GetLockState() == Ship.LOCK_STATE_LOCK)
		end

		local var3 = var0.energy <= Ship.ENERGY_MID

		if var3 then
			local var4 = GetSpriteFromAtlas("energy", var0:getEnergyPrint())

			if not var4 then
				warning("找不到疲劳")
			end

			setImageSprite(arg0.energyTF, var4)
		end

		setActive(arg0.energyTF, var3)
		setText(arg0.nameTF, var0:GetColorName(shortenString(var0:getName(), PLATFORM_CODE == PLATFORM_US and 6 or 7)))

		local var5

		if var0.user then
			local var6 = Clone(var0)

			var6.id = GuildAssaultFleet.GetRealId(var6.id)
			var5 = ShipStatus.ShipStatusToTag(var6, arg0.hideTagFlags)
		else
			var5 = ShipStatus.ShipStatusToTag(var0, arg0.hideTagFlags)
		end

		if var5 then
			arg0.iconStatusTxt.text = var5[3]

			GetSpriteFromAtlasAsync(var5[1], var5[2], function(arg0)
				setImageSprite(arg0.iconStatus, arg0, true)
				setActive(arg0.iconStatus, true)

				if var5[1] == "shipstatus" then
					arg0.iconStatus.sizeDelta = Vector2(195, 36)
					arg0.iconStatusTxt.fontSize = 30
					arg0.iconStatusTxt.transform.sizeDelta = Vector2(195, 36)
				end

				arg0.iconStatusMask.enabled = false
			end)
		else
			setActive(arg0.iconStatus, false)
		end

		if not LOCK_PROPOSE then
			if arg0.proposeModel then
				arg0.sg.enabled = arg0:CheckHeartState()
			elseif arg0:CheckHeartState() and not arg0.heartLoading then
				arg0.heartLoading = true

				pg.PoolMgr.GetInstance():GetUI("heartShipCard", false, function(arg0)
					if arg0.proposeModel then
						pg.PoolMgr.GetInstance():ReturnUI("heartShipCard", arg0)
					else
						arg0.proposeModel = arg0
						arg0.sg = GetComponent(arg0.proposeModel, "SkeletonGraphic")

						arg0.proposeModel.transform:SetParent(arg0.proposeTF, false)

						arg0.sg.enabled = arg0:CheckHeartState()
						arg0.heartLoading = false
					end
				end)
			end
		end

		if arg0.hpBar then
			setActive(arg0.hpBar, false)
		end

		arg0:UpdateExpBuff()
		arg0:updateNpcTfPosY()
	end

	if arg0.userTF then
		arg0:UpdateUser(var0)
	end

	arg0.content:SetActive(var1)
	arg0.quit:SetActive(not var1)

	arg0.btn.targetGraphic = var1 and arg0.imageFrame or arg0.imageQuit
end

function var0.CheckHeartState(arg0)
	if tobool(arg0.shipVO) then
		local var0, var1 = arg0.shipVO:getIntimacyIcon()
		local var2 = arg0.shipVO:isActivityNpc()

		return var1 and not var2
	end

	return false
end

local var2 = {
	90,
	60,
	30
}

function var0.updateNpcTfPosY(arg0)
	if isActive(arg0.npc) then
		local var0 = 1
		local var1 = findTF(arg0.tr, "content/energy")

		if isActive(var1) then
			var0 = var0 + 1
		end

		if isActive(arg0.intimacyTF) then
			var0 = var0 + 1
		end

		local var2 = arg0.npc.anchoredPosition

		var2.y = var2[var0]
		arg0.npc.anchoredPosition = var2
	end
end

function var0.UpdateUser(arg0, arg1)
	if arg0.userIconFrame.childCount > 0 then
		local var0 = arg0.userIconFrame:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0.name, var0.name, var0)
	end

	local var1 = tobool(arg1) and arg1.user
	local var2 = var1 and var1.id ~= arg0.palyerId

	setActive(arg0.userTF, var2 and arg0.detailType == var0.DetailType0)
	setActive(arg0.userNameTF.gameObject.transform.parent, var2)

	if var2 and var1 ~= arg0.user then
		local var3 = Ship.New({
			configId = var1.icon
		})

		LoadSpriteAsync("qicon/" .. var3:getPrefab(), function(arg0)
			arg0.userIconTF.sprite = arg0
		end)

		local var4 = AttireFrame.attireFrameRes(var1, false, AttireConst.TYPE_ICON_FRAME, var1.propose)

		PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var4, var4, true, function(arg0)
			if IsNil(arg0.tr) then
				return
			end

			if arg0.userIconFrame then
				arg0.name = var4

				setParent(arg0, arg0.userIconFrame, false)
			else
				PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var4, var4, arg0)
			end
		end)

		arg0.userNameTF.text = var1.name
		arg0.user = var1

		setAnchoredPosition(arg0.levelTF, {
			x = -108
		})
	else
		setAnchoredPosition(arg0.levelTF, {
			x = -16
		})
	end
end

function var0.flushDetail(arg0)
	local var0 = arg0.shipVO
	local var1 = tobool(var0)

	if var1 and arg0.detailType > var0.DetailType0 then
		local var2 = var0:getShipProperties()
		local var3 = {
			{
				AttributeType.Durability,
				AttributeType.Cannon,
				AttributeType.Torpedo,
				AttributeType.Air,
				AttributeType.Reload,
				AttributeType.Intimacy
			},
			{
				AttributeType.ArmorType,
				AttributeType.AntiAircraft,
				AttributeType.Dodge,
				AttributeType.AntiSub,
				AttributeType.Expend
			},
			{}
		}
		local var4 = var0:getShipCombatPower()
		local var5
		local var6

		if arg0.detailType == var0.DetailType3 then
			var5 = var0:getDisplaySkillIds()
			var6 = pg.skill_data_template
		end

		for iter0 = 1, 6 do
			local var7 = arg0.detailLayoutTr:GetChild(iter0 - 1)
			local var8 = true
			local var9 = var7:GetChild(0):GetComponent("Text")
			local var10 = var7:GetChild(1):GetComponent("Text")

			var9.alignment = TextAnchor.MiddleLeft
			var10.alignment = TextAnchor.MiddleRight

			local var11 = var3[arg0.detailType][iter0]

			if arg0.detailType == var0.DetailType1 then
				if iter0 == 6 then
					local var12, var13 = arg0.shipVO:getIntimacyDetail()

					var9.text = AttributeType.Type2Name(var11)
					var10.text = setColorStr(var13, var12 <= var13 and COLOR_GREEN or COLOR_WHITE)
				else
					local var14 = tostring(math.floor(var2[var11]))

					var9.text = AttributeType.Type2Name(var11)
					var10.text = setColorStr(var14, arg0:canModAttr(var0, var11, var2) and COLOR_GREEN or COLOR_WHITE)
				end
			elseif arg0.detailType == var0.DetailType2 then
				if iter0 == 1 then
					var9.alignment = TextAnchor.MiddleCenter
					var9.text = var0:getShipArmorName()
					var10.text = ""
				elseif iter0 == 5 then
					local var15 = var0:getBattleTotalExpend()

					var9.text = AttributeType.Type2Name(AttributeType.Expend)
					var10.text = tostring(math.floor(var15))
				elseif iter0 == 6 then
					var9.text = setColorStr(i18n("word_synthesize_power"), COLOR_GREEN)
					var10.text = tostring(var4)
				else
					var9.text = AttributeType.Type2Name(var11)
					var10.text = tostring(math.floor(var2[var11]))
				end
			elseif arg0.detailType == var0.DetailType3 then
				local var16 = var5[iter0]

				if var16 and var0.skills[var16] and var6[var16].max_level ~= 1 then
					local var17 = var0.skills[var16]
					local var18 = var0.SKILL_COLOR[pg.skill_data_template[var17.id].type] or COLOR_WHITE

					var9.alignment = TextAnchor.MiddleLeft
					var9.text = setColorStr(i18n("skill") .. iter0, var18)

					local var19 = var17.level == var6[var16].max_level and "Lv.Max" or "Lv." .. var17.level

					var10.text = setColorStr(var19, var18)
				else
					var8 = false
				end
			end

			setActive(var7, var8)
		end
	end

	arg0.detail:SetActive(var1 and arg0.detailType > var0.DetailType0)

	if arg0.userTF then
		arg0:UpdateUser(var0)
	end

	arg0:UpdateRecommandTag(var0)
end

function var0.UpdateRecommandTag(arg0, arg1)
	if arg1 and arg0.tagRecommand then
		local var0 = defaultValue(arg1.guildRecommand, false)

		setActive(arg0.tagRecommand, var0)
	end
end

function var0.canModAttr(arg0, arg1, arg2, arg3)
	if arg1:isBluePrintShip() then
		return arg1:getBluePrint():isMaxIntensifyLevel()
	elseif arg1:isMetaShip() then
		return arg1:getMetaCharacter():isMaxRepairExp()
	elseif not ShipModAttr.ATTR_TO_INDEX[arg2] then
		return true
	elseif arg1:getModAttrTopLimit(arg2) == 0 then
		return true
	else
		local var0 = arg1.level >= 100 or arg1.level == arg1:getMaxLevel()
		local var1 = arg1:getModAttrBaseMax(arg2)

		return var0 and var1 <= arg3[arg2]
	end
end

function var0.updateBlackBlock(arg0, arg1)
	local var0 = false

	if arg0.shipVO then
		for iter0, iter1 in pairs(arg0.blockTagFlags) do
			if iter1 and arg0.shipVO:getFlag(iter0) then
				var0 = true

				break
			end
		end

		if not var0 and arg1 then
			local var1 = getProxy(BayProxy)

			for iter2, iter3 in ipairs(arg1) do
				local var2 = var1:getShipById(iter3)

				if var2 and arg0.shipVO:isSameKind(var2) then
					var0 = var2.id ~= arg0.shipVO.id

					break
				end
			end
		end
	end

	if arg0.maskStatusOb then
		setActive(arg0.maskStatusOb, var0)
	end
end

function var0.updateWorld(arg0)
	local var0 = arg0.shipVO

	if var0:getFlag("inWorld") then
		local var1 = WorldConst.FetchWorldShip(var0.id)

		setActive(arg0.hpBar, true)

		local var2 = arg0.hpBar:Find("fillarea/green")
		local var3 = arg0.hpBar:Find("fillarea/red")

		setActive(var2, var1:IsHpSafe())
		setActive(var3, not var1:IsHpSafe())

		arg0.hpBar:GetComponent(typeof(Slider)).fillRect = var1:IsHpSafe() and var2 or var3

		setSlider(arg0.hpBar, 0, 10000, var1.hpRant)
		setActive(arg0.hpBar:Find("broken"), var1:IsBroken())

		if arg0.maskStatusOb then
			setActive(arg0.maskStatusOb, not var1:IsAlive())
		end
	end
end

function var0.UpdateExpBuff(arg0)
	local var0 = arg0.shipVO
	local var1 = arg0.activityProxy:getBuffShipList()[var0:getGroupId()]

	setActive(arg0.expBuff, false)
	setActive(arg0.expBuff, var1 ~= nil)

	if var1 then
		local var2 = var1 / 100
		local var3 = var1 % 100
		local var4 = tostring(var2)

		if var3 > 0 then
			var4 = var4 .. "." .. tostring(var3)
		end

		setText(arg0.expBuff:Find("text"), string.format("EXP +%s%%", var4))
	end
end

function var0.clear(arg0)
	ClearTweenItemAlphaAndWhite(arg0.go)

	if arg0.selectedTwId then
		LeanTween.cancel(arg0.selectedTwId)

		arg0.selectedTwId = nil
	end
end

function var0.updateIntimacy(arg0, arg1)
	local var0 = arg0.shipVO

	if not var0 then
		return
	end

	local var1 = findTF(arg0.tr, "content/energy")

	if isActive(var1) then
		arg0.intimacyTF = findTF(arg0.tr, "content/intimacy_with_energy")

		setActive(findTF(arg0.tr, "content/intimacy"), false)
	else
		arg0.intimacyTF = findTF(arg0.tr, "content/intimacy")

		setActive(findTF(arg0.tr, "content/intimacy_with_energy"), false)
	end

	local var2, var3 = var0:getIntimacyDetail()

	setText(findTF(arg0.intimacyTF, "Text"), var3)

	if var3 == 100 or var3 == 200 then
		setText(findTF(arg0.intimacyTF, "Text"), setColorStr(var3, "#ff8d8d"))
	end

	setActive(arg0.intimacyTF, arg1)
	arg0:updateNpcTfPosY()
end

function var0.updateIntimacyEnergy(arg0, arg1)
	local var0 = arg0.tr:Find("content/energy")
	local var1 = arg0.shipVO

	setActive(arg0.tr:Find("content/energy"), var1 and arg1)

	if arg1 and tobool(var1) then
		local var2 = GetSpriteFromAtlas("energy", var1:getEnergyPrint())

		setImageSprite(var0:Find("icon/img"), var2, true)
		setText(var0:Find("Text"), var1:getEnergy())
	end
end

return var0
