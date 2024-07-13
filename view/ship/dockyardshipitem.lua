local var0_0 = class("DockyardShipItem")

var0_0.DetailType0 = 0
var0_0.DetailType1 = 1
var0_0.DetailType2 = 2
var0_0.DetailType3 = 3
var0_0.SKILL_COLOR = {
	COLOR_RED,
	COLOR_BLUE,
	COLOR_YELLOW
}

local var1_0 = 0.8

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.hideTagFlags = arg2_1 or {}
	arg0_1.blockTagFlags = arg3_1 or {}
	arg0_1.btn = GetOrAddComponent(arg1_1, "Button")
	arg0_1.content = findTF(arg0_1.tr, "content").gameObject

	setActive(findTF(arg0_1.content, "dockyard"), true)
	setActive(findTF(arg0_1.content, "collection"), false)

	arg0_1.quit = findTF(arg0_1.tr, "quit_button").gameObject
	arg0_1.detail = findTF(arg0_1.tr, "content/dockyard/detail").gameObject
	arg0_1.detailLayoutTr = findTF(arg0_1.detail, "layout")
	arg0_1.imageQuit = arg0_1.quit:GetComponent("Image")
	arg0_1.imageFrame = findTF(arg0_1.tr, "content/front/frame"):GetComponent("Image")
	arg0_1.nameTF = findTF(arg0_1.tr, "content/info/name_mask/name")
	arg0_1.npc = findTF(arg0_1.tr, "content/dockyard/npc")

	setActive(arg0_1.npc, false)

	arg0_1.lock = findTF(arg0_1.tr, "content/dockyard/container/lock")
	arg0_1.maskStatusOb = findTF(arg0_1.tr, "content/front/status_mask")
	arg0_1.iconStatus = findTF(arg0_1.tr, "content/dockyard/status")
	arg0_1.iconStatusMask = arg0_1.iconStatus:GetComponent(typeof(RectMask2D))
	arg0_1.iconStatusTxt = findTF(arg0_1.tr, "content/dockyard/status/Text"):GetComponent("Text")
	arg0_1.selectedGo = findTF(arg0_1.tr, "content/front/selected").gameObject
	arg0_1.energyTF = findTF(arg0_1.tr, "content/dockyard/container/energy")
	arg0_1.proposeTF = findTF(arg0_1.tr, "content/dockyard/propose")

	arg0_1.selectedGo:SetActive(false)

	arg0_1.hpBar = findTF(arg0_1.tr, "content/dockyard/blood")
	arg0_1.expBuff = findTF(arg0_1.tr, "content/expbuff")
	arg0_1.intimacyTF = findTF(arg0_1.tr, "content/intimacy")
	arg0_1.detailType = var0_0.DetailType0
	arg0_1.proposeModel = arg0_1.proposeTF:Find("heartShipCard(Clone)")

	if arg0_1.proposeModel then
		arg0_1.sg = GetComponent(arg0_1.proposeModel, "SkeletonGraphic")
	end

	arg0_1.activityProxy = getProxy(ActivityProxy)
	arg0_1.userTF = findTF(arg0_1.tr, "content/user")

	if arg0_1.userTF then
		arg0_1.userIconTF = arg0_1.userTF:Find("icon"):GetComponent(typeof(Image))
		arg0_1.userIconFrame = arg0_1.userTF:Find("frame")
		arg0_1.userNameTF = findTF(arg0_1.tr, "content/user_name/Text"):GetComponent(typeof(Text))
		arg0_1.levelTF = findTF(arg0_1.tr, "content/dockyard/lv")
	end

	arg0_1.tagRecommand = findTF(arg0_1.tr, "content/recommand")
	arg0_1.palyerId = getProxy(PlayerProxy):getRawData().id

	ClearTweenItemAlphaAndWhite(arg0_1.go)
end

function var0_0.update(arg0_2, arg1_2)
	TweenItemAlphaAndWhite(arg0_2.go)

	if arg0_2.proposeModel then
		LeanTween.cancel(arg0_2.proposeModel)
		LeanTween.value(go(arg0_2.proposeModel), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_3)
			arg0_2.sg.color = Color.New(1, 1, 1, arg0_3)
		end))
	end

	if arg1_2 then
		arg0_2.go.name = arg1_2.configId
	end

	if arg0_2.shipVO ~= arg1_2 then
		arg0_2.shipVO = arg1_2

		arg0_2:flush()
		arg0_2:flushDetail()
	end

	setActive(arg0_2.nameTF, false)
	setActive(arg0_2.nameTF, true)

	if not IsNil(arg0_2.levelTF) then
		setActive(arg0_2.levelTF, false)
		setActive(arg0_2.levelTF, true)
	end
end

function var0_0.updateDetail(arg0_4, arg1_4)
	arg0_4.detailType = arg1_4

	arg0_4:flushDetail()
end

function var0_0.updateSelected(arg0_5, arg1_5)
	arg0_5.selected = arg1_5

	arg0_5.selectedGo:SetActive(arg0_5.selected)

	if arg0_5.selected then
		if not arg0_5.selectedTwId then
			arg0_5.selectedTwId = LeanTween.alpha(arg0_5.selectedGo.transform, 0.5, var1_0):setFrom(0):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId
		end
	elseif arg0_5.selectedTwId then
		LeanTween.cancel(arg0_5.selectedTwId)

		arg0_5.selectedTwId = nil
	end
end

function var0_0.flush(arg0_6)
	local var0_6 = arg0_6.shipVO
	local var1_6 = tobool(var0_6)

	if var1_6 then
		if not var0_6:getConfigTable() then
			return
		end

		flushShipCard(arg0_6.tr, var0_6)

		local var2_6 = var0_6:isActivityNpc()

		setActive(arg0_6.npc, var2_6)

		if arg0_6.lock then
			arg0_6.lock.gameObject:SetActive(var0_6:GetLockState() == Ship.LOCK_STATE_LOCK)
		end

		local var3_6 = var0_6.energy <= Ship.ENERGY_MID

		if var3_6 then
			local var4_6 = GetSpriteFromAtlas("energy", var0_6:getEnergyPrint())

			if not var4_6 then
				warning("找不到疲劳")
			end

			setImageSprite(arg0_6.energyTF, var4_6)
		end

		setActive(arg0_6.energyTF, var3_6)
		setText(arg0_6.nameTF, var0_6:GetColorName(shortenString(var0_6:getName(), PLATFORM_CODE == PLATFORM_US and 6 or 7)))

		local var5_6

		if var0_6.user then
			local var6_6 = Clone(var0_6)

			var6_6.id = GuildAssaultFleet.GetRealId(var6_6.id)
			var5_6 = ShipStatus.ShipStatusToTag(var6_6, arg0_6.hideTagFlags)
		else
			var5_6 = ShipStatus.ShipStatusToTag(var0_6, arg0_6.hideTagFlags)
		end

		if var5_6 then
			arg0_6.iconStatusTxt.text = var5_6[3]

			GetSpriteFromAtlasAsync(var5_6[1], var5_6[2], function(arg0_7)
				setImageSprite(arg0_6.iconStatus, arg0_7, true)
				setActive(arg0_6.iconStatus, true)

				if var5_6[1] == "shipstatus" then
					arg0_6.iconStatus.sizeDelta = Vector2(195, 36)
					arg0_6.iconStatusTxt.fontSize = 30
					arg0_6.iconStatusTxt.transform.sizeDelta = Vector2(195, 36)
				end

				arg0_6.iconStatusMask.enabled = false
			end)
		else
			setActive(arg0_6.iconStatus, false)
		end

		if not LOCK_PROPOSE then
			if arg0_6.proposeModel then
				arg0_6.sg.enabled = arg0_6:CheckHeartState()
			elseif arg0_6:CheckHeartState() and not arg0_6.heartLoading then
				arg0_6.heartLoading = true

				pg.PoolMgr.GetInstance():GetUI("heartShipCard", false, function(arg0_8)
					if arg0_6.proposeModel then
						pg.PoolMgr.GetInstance():ReturnUI("heartShipCard", arg0_8)
					else
						arg0_6.proposeModel = arg0_8
						arg0_6.sg = GetComponent(arg0_6.proposeModel, "SkeletonGraphic")

						arg0_6.proposeModel.transform:SetParent(arg0_6.proposeTF, false)

						arg0_6.sg.enabled = arg0_6:CheckHeartState()
						arg0_6.heartLoading = false
					end
				end)
			end
		end

		if arg0_6.hpBar then
			setActive(arg0_6.hpBar, false)
		end

		arg0_6:UpdateExpBuff()
		arg0_6:updateNpcTfPosY()
	end

	if arg0_6.userTF then
		arg0_6:UpdateUser(var0_6)
	end

	arg0_6.content:SetActive(var1_6)
	arg0_6.quit:SetActive(not var1_6)

	arg0_6.btn.targetGraphic = var1_6 and arg0_6.imageFrame or arg0_6.imageQuit
end

function var0_0.CheckHeartState(arg0_9)
	if tobool(arg0_9.shipVO) then
		local var0_9, var1_9 = arg0_9.shipVO:getIntimacyIcon()
		local var2_9 = arg0_9.shipVO:isActivityNpc()

		return var1_9 and not var2_9
	end

	return false
end

local var2_0 = {
	90,
	60,
	30
}

function var0_0.updateNpcTfPosY(arg0_10)
	if isActive(arg0_10.npc) then
		local var0_10 = 1
		local var1_10 = findTF(arg0_10.tr, "content/energy")

		if isActive(var1_10) then
			var0_10 = var0_10 + 1
		end

		if isActive(arg0_10.intimacyTF) then
			var0_10 = var0_10 + 1
		end

		local var2_10 = arg0_10.npc.anchoredPosition

		var2_10.y = var2_0[var0_10]
		arg0_10.npc.anchoredPosition = var2_10
	end
end

function var0_0.UpdateUser(arg0_11, arg1_11)
	if arg0_11.userIconFrame.childCount > 0 then
		local var0_11 = arg0_11.userIconFrame:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0_11.name, var0_11.name, var0_11)
	end

	local var1_11 = tobool(arg1_11) and arg1_11.user
	local var2_11 = var1_11 and var1_11.id ~= arg0_11.palyerId

	setActive(arg0_11.userTF, var2_11 and arg0_11.detailType == var0_0.DetailType0)
	setActive(arg0_11.userNameTF.gameObject.transform.parent, var2_11)

	if var2_11 and var1_11 ~= arg0_11.user then
		local var3_11 = Ship.New({
			configId = var1_11.icon
		})

		LoadSpriteAsync("qicon/" .. var3_11:getPrefab(), function(arg0_12)
			arg0_11.userIconTF.sprite = arg0_12
		end)

		local var4_11 = AttireFrame.attireFrameRes(var1_11, false, AttireConst.TYPE_ICON_FRAME, var1_11.propose)

		PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var4_11, var4_11, true, function(arg0_13)
			if IsNil(arg0_11.tr) then
				return
			end

			if arg0_11.userIconFrame then
				arg0_13.name = var4_11

				setParent(arg0_13, arg0_11.userIconFrame, false)
			else
				PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var4_11, var4_11, arg0_13)
			end
		end)

		arg0_11.userNameTF.text = var1_11.name
		arg0_11.user = var1_11

		setAnchoredPosition(arg0_11.levelTF, {
			x = -108
		})
	else
		setAnchoredPosition(arg0_11.levelTF, {
			x = -16
		})
	end
end

function var0_0.flushDetail(arg0_14)
	local var0_14 = arg0_14.shipVO
	local var1_14 = tobool(var0_14)

	if var1_14 and arg0_14.detailType > var0_0.DetailType0 then
		local var2_14 = var0_14:getShipProperties()
		local var3_14 = {
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
		local var4_14 = var0_14:getShipCombatPower()
		local var5_14
		local var6_14

		if arg0_14.detailType == var0_0.DetailType3 then
			var5_14 = var0_14:getDisplaySkillIds()
			var6_14 = pg.skill_data_template
		end

		for iter0_14 = 1, 6 do
			local var7_14 = arg0_14.detailLayoutTr:GetChild(iter0_14 - 1)
			local var8_14 = true
			local var9_14 = var7_14:GetChild(0):GetComponent("Text")
			local var10_14 = var7_14:GetChild(1):GetComponent("Text")

			var9_14.alignment = TextAnchor.MiddleLeft
			var10_14.alignment = TextAnchor.MiddleRight

			local var11_14 = var3_14[arg0_14.detailType][iter0_14]

			if arg0_14.detailType == var0_0.DetailType1 then
				if iter0_14 == 6 then
					local var12_14, var13_14 = arg0_14.shipVO:getIntimacyDetail()

					var9_14.text = AttributeType.Type2Name(var11_14)
					var10_14.text = setColorStr(var13_14, var12_14 <= var13_14 and COLOR_GREEN or COLOR_WHITE)
				else
					local var14_14 = tostring(math.floor(var2_14[var11_14]))

					var9_14.text = AttributeType.Type2Name(var11_14)
					var10_14.text = setColorStr(var14_14, arg0_14:canModAttr(var0_14, var11_14, var2_14) and COLOR_GREEN or COLOR_WHITE)
				end
			elseif arg0_14.detailType == var0_0.DetailType2 then
				if iter0_14 == 1 then
					var9_14.alignment = TextAnchor.MiddleCenter
					var9_14.text = var0_14:getShipArmorName()
					var10_14.text = ""
				elseif iter0_14 == 5 then
					local var15_14 = var0_14:getBattleTotalExpend()

					var9_14.text = AttributeType.Type2Name(AttributeType.Expend)
					var10_14.text = tostring(math.floor(var15_14))
				elseif iter0_14 == 6 then
					var9_14.text = setColorStr(i18n("word_synthesize_power"), COLOR_GREEN)
					var10_14.text = tostring(var4_14)
				else
					var9_14.text = AttributeType.Type2Name(var11_14)
					var10_14.text = tostring(math.floor(var2_14[var11_14]))
				end
			elseif arg0_14.detailType == var0_0.DetailType3 then
				local var16_14 = var5_14[iter0_14]

				if var16_14 and var0_14.skills[var16_14] and var6_14[var16_14].max_level ~= 1 then
					local var17_14 = var0_14.skills[var16_14]
					local var18_14 = var0_0.SKILL_COLOR[pg.skill_data_template[var17_14.id].type] or COLOR_WHITE

					var9_14.alignment = TextAnchor.MiddleLeft
					var9_14.text = setColorStr(i18n("skill") .. iter0_14, var18_14)

					local var19_14 = var17_14.level == var6_14[var16_14].max_level and "Lv.Max" or "Lv." .. var17_14.level

					var10_14.text = setColorStr(var19_14, var18_14)
				else
					var8_14 = false
				end
			end

			setActive(var7_14, var8_14)
		end
	end

	arg0_14.detail:SetActive(var1_14 and arg0_14.detailType > var0_0.DetailType0)

	if arg0_14.userTF then
		arg0_14:UpdateUser(var0_14)
	end

	arg0_14:UpdateRecommandTag(var0_14)
end

function var0_0.UpdateRecommandTag(arg0_15, arg1_15)
	if arg1_15 and arg0_15.tagRecommand then
		local var0_15 = defaultValue(arg1_15.guildRecommand, false)

		setActive(arg0_15.tagRecommand, var0_15)
	end
end

function var0_0.canModAttr(arg0_16, arg1_16, arg2_16, arg3_16)
	if arg1_16:isBluePrintShip() then
		return arg1_16:getBluePrint():isMaxIntensifyLevel()
	elseif arg1_16:isMetaShip() then
		return arg1_16:getMetaCharacter():isMaxRepairExp()
	elseif not ShipModAttr.ATTR_TO_INDEX[arg2_16] then
		return true
	elseif arg1_16:getModAttrTopLimit(arg2_16) == 0 then
		return true
	else
		local var0_16 = arg1_16.level >= 100 or arg1_16.level == arg1_16:getMaxLevel()
		local var1_16 = arg1_16:getModAttrBaseMax(arg2_16)

		return var0_16 and var1_16 <= arg3_16[arg2_16]
	end
end

function var0_0.updateBlackBlock(arg0_17, arg1_17)
	local var0_17 = false

	if arg0_17.shipVO then
		for iter0_17, iter1_17 in pairs(arg0_17.blockTagFlags) do
			if iter1_17 and arg0_17.shipVO:getFlag(iter0_17) then
				var0_17 = true

				break
			end
		end

		if not var0_17 and arg1_17 then
			local var1_17 = getProxy(BayProxy)

			for iter2_17, iter3_17 in ipairs(arg1_17) do
				local var2_17 = var1_17:getShipById(iter3_17)

				if var2_17 and arg0_17.shipVO:isSameKind(var2_17) then
					var0_17 = var2_17.id ~= arg0_17.shipVO.id

					break
				end
			end
		end
	end

	if arg0_17.maskStatusOb then
		setActive(arg0_17.maskStatusOb, var0_17)
	end
end

function var0_0.updateWorld(arg0_18)
	local var0_18 = arg0_18.shipVO

	if var0_18:getFlag("inWorld") then
		local var1_18 = WorldConst.FetchWorldShip(var0_18.id)

		setActive(arg0_18.hpBar, true)

		local var2_18 = arg0_18.hpBar:Find("fillarea/green")
		local var3_18 = arg0_18.hpBar:Find("fillarea/red")

		setActive(var2_18, var1_18:IsHpSafe())
		setActive(var3_18, not var1_18:IsHpSafe())

		arg0_18.hpBar:GetComponent(typeof(Slider)).fillRect = var1_18:IsHpSafe() and var2_18 or var3_18

		setSlider(arg0_18.hpBar, 0, 10000, var1_18.hpRant)
		setActive(arg0_18.hpBar:Find("broken"), var1_18:IsBroken())

		if arg0_18.maskStatusOb then
			setActive(arg0_18.maskStatusOb, not var1_18:IsAlive())
		end
	end
end

function var0_0.UpdateExpBuff(arg0_19)
	local var0_19 = arg0_19.shipVO
	local var1_19 = arg0_19.activityProxy:getBuffShipList()[var0_19:getGroupId()]

	setActive(arg0_19.expBuff, false)
	setActive(arg0_19.expBuff, var1_19 ~= nil)

	if var1_19 then
		local var2_19 = var1_19 / 100
		local var3_19 = var1_19 % 100
		local var4_19 = tostring(var2_19)

		if var3_19 > 0 then
			var4_19 = var4_19 .. "." .. tostring(var3_19)
		end

		setText(arg0_19.expBuff:Find("text"), string.format("EXP +%s%%", var4_19))
	end
end

function var0_0.clear(arg0_20)
	ClearTweenItemAlphaAndWhite(arg0_20.go)

	if arg0_20.selectedTwId then
		LeanTween.cancel(arg0_20.selectedTwId)

		arg0_20.selectedTwId = nil
	end
end

function var0_0.updateIntimacy(arg0_21, arg1_21)
	local var0_21 = arg0_21.shipVO

	if not var0_21 then
		return
	end

	local var1_21 = findTF(arg0_21.tr, "content/energy")

	if isActive(var1_21) then
		arg0_21.intimacyTF = findTF(arg0_21.tr, "content/intimacy_with_energy")

		setActive(findTF(arg0_21.tr, "content/intimacy"), false)
	else
		arg0_21.intimacyTF = findTF(arg0_21.tr, "content/intimacy")

		setActive(findTF(arg0_21.tr, "content/intimacy_with_energy"), false)
	end

	local var2_21, var3_21 = var0_21:getIntimacyDetail()

	setText(findTF(arg0_21.intimacyTF, "Text"), var3_21)

	if var3_21 == 100 or var3_21 == 200 then
		setText(findTF(arg0_21.intimacyTF, "Text"), setColorStr(var3_21, "#ff8d8d"))
	end

	setActive(arg0_21.intimacyTF, arg1_21)
	arg0_21:updateNpcTfPosY()
end

function var0_0.updateIntimacyEnergy(arg0_22, arg1_22)
	local var0_22 = arg0_22.tr:Find("content/energy")
	local var1_22 = arg0_22.shipVO

	setActive(arg0_22.tr:Find("content/energy"), var1_22 and arg1_22)

	if arg1_22 and tobool(var1_22) then
		local var2_22 = GetSpriteFromAtlas("energy", var1_22:getEnergyPrint())

		setImageSprite(var0_22:Find("icon/img"), var2_22, true)
		setText(var0_22:Find("Text"), var1_22:getEnergy())
	end
end

return var0_0
