local var0_0 = class("TechnologyTreeNationScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TechnologyTreeCampUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
end

function var0_0.didEnter(arg0_3)
	arg0_3:addListener()
	arg0_3:updateTecItemList()
	arg0_3:updateOneStepBtn()
	arg0_3.nationProxy:setRedPointIgnoreTecCampUpgrade()
end

function var0_0.willExit(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.timerList) do
		iter1_4:Stop()
	end

	arg0_4.nationProxy:refreshRedPoint()
end

function var0_0.initData(arg0_5)
	arg0_5.nationProxy = getProxy(TechnologyNationProxy)
	arg0_5.nationToPoint = arg0_5.nationProxy:getNationPointList()
	arg0_5.tecList = arg0_5.nationProxy:GetTecList()
	arg0_5.panelList = {}
	arg0_5.timerList = {}
end

function var0_0.calculateCurBuff(arg0_6, arg1_6, arg2_6)
	local var0_6

	if arg1_6 == 0 then
		return {}, {}, {}
	else
		var0_6 = pg.fleet_tech_group[arg2_6].techs[arg1_6]
	end

	local var1_6 = pg.fleet_tech_template[var0_6].add
	local var2_6 = {}
	local var3_6 = {}

	for iter0_6, iter1_6 in ipairs(var1_6) do
		local var4_6 = iter1_6[2]
		local var5_6 = iter1_6[3]
		local var6_6 = iter1_6[1]

		for iter2_6, iter3_6 in ipairs(var6_6) do
			if var2_6[iter3_6] then
				table.insert(var2_6[iter3_6], {
					attr = var4_6,
					value = var5_6
				})
			else
				var2_6[iter3_6] = {
					{
						attr = var4_6,
						value = var5_6
					}
				}
				var3_6[#var3_6 + 1] = iter3_6
			end
		end
	end

	local var7_6 = {}
	local var8_6 = {}

	for iter4_6, iter5_6 in pairs(var2_6) do
		if not var7_6[iter4_6] then
			var7_6[iter4_6] = {}
			var8_6[iter4_6] = {}
		end

		for iter6_6, iter7_6 in ipairs(iter5_6) do
			local var9_6 = iter7_6.attr
			local var10_6 = iter7_6.value

			if not var7_6[iter4_6][var9_6] then
				var7_6[iter4_6][var9_6] = var10_6
				var8_6[iter4_6][#var8_6[iter4_6] + 1] = var9_6
			else
				var7_6[iter4_6][var9_6] = var7_6[iter4_6][var9_6] + var10_6
			end
		end
	end

	table.sort(var3_6, function(arg0_7, arg1_7)
		return arg0_7 < arg1_7
	end)

	for iter8_6, iter9_6 in pairs(var8_6) do
		table.sort(iter9_6, function(arg0_8, arg1_8)
			return arg0_8 < arg1_8
		end)
	end

	return var3_6, var8_6, var7_6
end

function var0_0.findUI(arg0_9)
	arg0_9.scrollRect = arg0_9._tf:Find("Scroll View")
	arg0_9.tecItemContainer = arg0_9._tf:Find("Scroll View/Viewport/Content")
	arg0_9.scrollRectCom = GetComponent(arg0_9.scrollRect, "ScrollRect")
	arg0_9.tecItemTpl = arg0_9._tf:Find("CampTecItem")
	arg0_9.typeItemTpl = arg0_9._tf:Find("TypeItem")
	arg0_9.buffItemTpl = arg0_9._tf:Find("BuffItem")
	arg0_9.tecItemTplOriginWidth = arg0_9.tecItemTpl.rect.width
	arg0_9.oneStepBtn = arg0_9._tf:Find("OneStepBtn")

	if not LOCK_TEC_NATION_AWARD then
		arg0_9.awardTpl = Instantiate(GetComponent(arg0_9._tf, "ItemList").prefabItem[0])

		setActive(arg0_9.awardTpl, false)

		local var0_9 = arg0_9.awardTpl:AddComponent(typeof(LayoutElement))

		var0_9.preferredWidth = 204
		var0_9.preferredHeight = 206

		local var1_9 = arg0_9._tf:Find("CampTecItem/AwardPanel/FinishBtn/Text")

		setText(var1_9, i18n("tec_nation_award_finish"))
	else
		setActive(arg0_9.oneStepBtn, false)
	end
end

function var0_0.onBackPressed(arg0_10)
	arg0_10:emit(var0_0.ON_BACK)
end

function var0_0.closeMyself(arg0_11)
	arg0_11:emit(var0_0.ON_CLOSE)
end

function var0_0.addListener(arg0_12)
	onButton(arg0_12, arg0_12.oneStepBtn, function()
		pg.m02:sendNotification(GAME.GET_CAMP_TEC_AWARD_ONESTEP)
	end, SFX_PANEL)
end

function var0_0.updateTecItemList(arg0_14)
	local var0_14 = UIItemList.New(arg0_14.tecItemContainer, arg0_14.tecItemTpl)

	var0_14:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg1_15 + 1

			arg0_14.panelList[var0_15] = arg2_15

			arg0_14:updateTecItem(var0_15)
		end
	end)
	var0_14:align(#pg.fleet_tech_group.all)
	arg0_14:updateAllTecItemRp()
end

function var0_0.updateAllTecItemRp(arg0_16)
	local var0_16 = not getProxy(TechnologyNationProxy):getAnyTecCampStudying()

	for iter0_16, iter1_16 in pairs(arg0_16.panelList) do
		local var1_16 = iter1_16:Find("BaseInfo"):Find("UpLevelBG"):Find("UpLevelBtn"):Find("RedPoint")
		local var2_16 = pg.fleet_tech_group[iter0_16].nation[1]
		local var3_16
		local var4_16
		local var5_16 = not arg0_16.tecList[iter0_16] and 0 or table.indexof(pg.fleet_tech_group[iter0_16].techs, arg0_16.tecList[iter0_16].completeID, 1) or 0
		local var6_16 = arg0_16.nationToPoint[var2_16]
		local var7_16

		if var5_16 == 0 then
			local var8_16 = pg.fleet_tech_group[iter0_16].techs[1]

			var7_16 = pg.fleet_tech_template[var8_16].pt
		elseif var5_16 == #pg.fleet_tech_group[iter0_16].techs then
			local var9_16 = pg.fleet_tech_group[iter0_16].techs[var5_16]

			var7_16 = pg.fleet_tech_template[var9_16].pt
		else
			local var10_16 = pg.fleet_tech_group[iter0_16].techs[var5_16 + 1]

			var7_16 = pg.fleet_tech_template[var10_16].pt
		end

		local var11_16 = var7_16 <= var6_16
		local var12_16 = var5_16 == #pg.fleet_tech_group[iter0_16].techs
		local var13_16 = var11_16 and not var12_16

		setActive(var1_16, var13_16 and var0_16)
	end
end

function var0_0.updateTecItem(arg0_17, arg1_17)
	local var0_17 = arg0_17.panelList[arg1_17]
	local var1_17 = var0_17:Find("AwardPanel")

	arg0_17:updateTecLevelAward(var1_17, arg1_17)

	local var2_17 = var0_17:Find("BaseInfo")
	local var3_17 = var2_17:Find("BG/Title/Text")
	local var4_17 = var2_17:Find("BG/UpLevelColor")
	local var5_17 = var2_17:Find("NationBG")
	local var6_17 = var2_17:Find("Code")
	local var7_17 = var6_17:Find("NationTextImg")
	local var8_17 = var2_17:Find("UpLevelBG")
	local var9_17 = var8_17:Find("UpLevelBtn")
	local var10_17 = var8_17:Find("FinishBtn")
	local var11_17 = var2_17:Find("Uping")
	local var12_17 = var11_17:Find("Text")
	local var13_17 = var2_17:Find("EnglishTextImg")
	local var14_17 = var2_17:Find("ProgressBarBG/Progress")
	local var15_17 = var2_17:Find("CampLogo")
	local var16_17 = var2_17:Find("LevelText/Text")
	local var17_17 = var2_17:Find("PointTextBar")
	local var18_17 = pg.fleet_tech_group[arg1_17].name
	local var19_17 = pg.fleet_tech_group[arg1_17].nation[1]

	setImageSprite(var5_17, GetSpriteFromAtlas("TecNation", "camptec_nation_bar_" .. var19_17))
	setImageSprite(var7_17, GetSpriteFromAtlas("TecNation", "camptec_nation_text_" .. var19_17), true)
	setImageSprite(var13_17, GetSpriteFromAtlas("TecNation", "camp_tec_english_" .. var19_17), true)
	setImageSprite(var15_17, GetSpriteFromAtlas("TecNation", "camptec_logo_" .. var19_17))
	setText(var3_17, var18_17)

	local var20_17
	local var21_17
	local var22_17 = not arg0_17.tecList[arg1_17] and 0 or table.indexof(pg.fleet_tech_group[arg1_17].techs, arg0_17.tecList[arg1_17].completeID, 1) or 0
	local var23_17 = arg0_17.nationToPoint[var19_17]
	local var24_17

	if var22_17 == 0 then
		var21_17 = pg.fleet_tech_group[arg1_17].techs[1]
		var24_17 = pg.fleet_tech_template[var21_17].pt
	elseif var22_17 == #pg.fleet_tech_group[arg1_17].techs then
		var21_17 = pg.fleet_tech_group[arg1_17].techs[var22_17]
		var24_17 = pg.fleet_tech_template[var21_17].pt
	else
		var21_17 = pg.fleet_tech_group[arg1_17].techs[var22_17 + 1]
		var24_17 = pg.fleet_tech_template[var21_17].pt
	end

	BaseUI:setImageAmount(var14_17, 0.1 + 0.8 * var23_17 / var24_17)
	setText(var16_17, var22_17)
	setText(var17_17, var23_17 .. "/" .. var24_17)

	local function var25_17(arg0_18, arg1_18, arg2_18)
		setActive(var6_17, arg0_18)
		setActive(var8_17, arg1_18)
		setActive(var4_17, arg1_18)
		setActive(var9_17, arg1_18)
		setActive(var11_17, arg2_18)
	end

	if not arg0_17.tecList[arg1_17] then
		if var24_17 <= var23_17 then
			var25_17(false, true, false)
		else
			var25_17(true, false, false)
		end
	elseif var22_17 == #pg.fleet_tech_group[arg1_17].techs then
		var25_17(true, false, false)
	elseif arg0_17.tecList[arg1_17].studyID ~= 0 then
		var25_17(false, false, true)

		if arg0_17.timerList[arg1_17] then
			arg0_17.timerList[arg1_17]:Stop()
		end

		local var26_17 = arg0_17.nationProxy:getLeftTime()

		setText(var12_17, pg.TimeMgr.GetInstance():DescCDTime(var26_17))

		arg0_17.timerList[arg1_17] = Timer.New(function()
			var26_17 = var26_17 - 1

			setText(var12_17, pg.TimeMgr.GetInstance():DescCDTime(var26_17))

			if var26_17 == 0 then
				arg0_17.timerList[arg1_17]:Stop()
			end
		end, 1, -1)

		arg0_17.timerList[arg1_17]:Start()
	elseif var24_17 <= var23_17 then
		var25_17(false, true, false)
	else
		var25_17(true, false, false)
	end

	onButton(arg0_17, var9_17, function()
		arg0_17:emit(TechnologyConst.CLICK_UP_TEC_BTN, arg1_17, var21_17)
	end, SFX_PANEL)

	local var27_17 = var0_17:Find("Mask/DetailPanel")
	local var28_17 = GetComponent(var0_17, "LayoutElement")
	local var29_17 = var27_17:Find("Toggle")

	arg0_17:updateDetailPanel(var27_17, var22_17, arg1_17, var19_17, false)
	onToggle(arg0_17, var2_17:Find("BG"), function(arg0_21)
		if arg0_21 then
			triggerToggle(var29_17, false)
			LeanTween.value(go(var0_17), arg0_17.tecItemTplOriginWidth, arg0_17.tecItemTplOriginWidth + var27_17.rect.width, 0.25):setOnUpdate(System.Action_float(function(arg0_22)
				var28_17.preferredWidth = arg0_22

				if arg1_17 == #pg.fleet_tech_group.all then
					arg0_17.scrollRectCom.horizontalNormalizedPosition = 1
				end
			end)):setOnComplete(System.Action(function()
				if arg1_17 == #pg.fleet_tech_group.all then
					arg0_17.scrollRectCom.horizontalNormalizedPosition = 1
				end
			end))
		else
			LeanTween.cancel(go(var0_17))

			local var0_21 = var28_17.preferredWidth

			LeanTween.value(go(var0_17), var0_21, arg0_17.tecItemTplOriginWidth, 0.25):setOnUpdate(System.Action_float(function(arg0_24)
				var28_17.preferredWidth = arg0_24
			end))
		end
	end)
end

function var0_0.updateDetailPanel(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25, arg5_25)
	local var0_25 = arg1_25:Find("TypeItemContainer")
	local var1_25 = arg1_25:Find("BG/Logo")

	setImageSprite(var1_25, GetSpriteFromAtlas("TecNation", "camptec_logo_" .. arg4_25))

	local var2_25 = arg1_25:Find("Toggle")

	if arg2_25 == #pg.fleet_tech_group[arg3_25].techs and arg5_25 == false then
		setActive(var2_25, false)
	end

	local function var3_25(arg0_26, arg1_26, arg2_26)
		local var0_26 = UIItemList.New(var0_25, arg0_25.typeItemTpl)
		local var1_26

		if arg0_26 == 0 then
			var0_26:align(0)

			return
		else
			var1_26 = pg.fleet_tech_group[arg1_26].techs[arg0_26]
		end

		local var2_26
		local var3_26
		local var4_26
		local var5_26 = Color.New(1, 0.933333333333333, 0.192156862745098)

		if arg2_26 then
			var2_26, var3_26, var4_26 = arg0_25:calculateCurBuff(arg0_26 - 1, arg1_26)
		end

		local var6_26 = pg.fleet_tech_template[var1_26].add
		local var7_26 = {}
		local var8_26 = {}

		for iter0_26, iter1_26 in ipairs(var6_26) do
			local var9_26 = iter1_26[2]
			local var10_26 = iter1_26[3]
			local var11_26 = ShipType.FilterOverQuZhuType(iter1_26[1])

			for iter2_26, iter3_26 in ipairs(var11_26) do
				local var12_26

				if arg2_26 then
					if not table.indexof(var2_26, iter3_26, 1) then
						var12_26 = {
							attr = var9_26,
							value = var10_26,
							attrColor = var5_26,
							valueColor = var5_26
						}
					elseif not table.indexof(var3_26[iter3_26], var9_26, 1) then
						var12_26 = {
							attr = var9_26,
							value = var10_26,
							attrColor = var5_26,
							valueColor = var5_26
						}
					elseif var10_26 ~= var4_26[iter3_26][var9_26] then
						var12_26 = {
							attr = var9_26,
							value = var10_26,
							valueColor = var5_26
						}
					else
						var12_26 = {
							attr = var9_26,
							value = var10_26
						}
					end
				else
					var12_26 = {
						attr = var9_26,
						value = var10_26
					}
				end

				if var7_26[iter3_26] then
					table.insert(var7_26[iter3_26], var12_26)
				else
					var7_26[iter3_26] = {
						var12_26
					}
					var8_26[#var8_26 + 1] = iter3_26
				end
			end
		end

		var0_26:make(function(arg0_27, arg1_27, arg2_27)
			if arg0_27 == UIItemList.EventUpdate then
				local var0_27 = arg2_27:Find("TypeIcon")
				local var1_27 = arg2_27:Find("BuffItemContainer")
				local var2_27 = var8_26[arg1_27 + 1]

				setImageSprite(var0_27, GetSpriteFromAtlas("ShipType", "buffitem_tec_" .. var2_27))
				arg0_25:upBuffList(arg2_27, var7_26[var2_27])
			end
		end)
		var0_26:align(#var8_26)
	end

	onToggle(arg0_25, var2_25, function(arg0_28)
		if arg0_28 == true then
			var3_25(arg2_25 + 1, arg3_25, true)
		else
			var3_25(arg2_25, arg3_25)
		end
	end, SFX_PANEL)

	if arg5_25 == false then
		triggerToggle(var2_25, false)
	end
end

function var0_0.upBuffList(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg1_29:Find("BuffItemContainer")
	local var1_29 = UIItemList.New(var0_29, arg0_29.buffItemTpl)

	var1_29:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			local var0_30 = arg2_30:Find("AttrText")
			local var1_30 = arg2_30:Find("ValueText")
			local var2_30 = arg2_29[arg1_30 + 1].attr
			local var3_30 = arg2_29[arg1_30 + 1].value
			local var4_30 = arg2_29[arg1_30 + 1].attrColor
			local var5_30 = arg2_29[arg1_30 + 1].valueColor

			setText(var0_30, AttributeType.Type2Name(pg.attribute_info_by_type[var2_30].name))
			setText(var1_30, "+" .. var3_30)

			if var4_30 then
				setTextColor(var0_30, var4_30)
			else
				setTextColor(var0_30, Color.white)
			end

			if var5_30 then
				setTextColor(var1_30, var5_30)
			else
				setTextColor(var1_30, Color.green)
			end
		end
	end)
	var1_29:align(#arg2_29)
end

function var0_0.updateTecLevelAward(arg0_31, arg1_31, arg2_31)
	if LOCK_TEC_NATION_AWARD then
		setActive(arg1_31, false)

		return
	end

	local var0_31 = arg0_31._tf:Find("AwardItem")
	local var1_31 = arg1_31:Find("ItemContainer")
	local var2_31 = UIItemList.New(var1_31, arg0_31.awardTpl)
	local var3_31 = arg1_31:Find("Level")
	local var4_31 = arg1_31:Find("Level/Num")
	local var5_31 = arg1_31:Find("GetBtn")
	local var6_31 = arg1_31:Find("DisGetBtn")
	local var7_31 = arg1_31:Find("FinishBtn")
	local var8_31 = arg0_31.nationProxy:GetTecItemByGroupID(arg2_31)
	local var9_31 = pg.fleet_tech_group[arg2_31]
	local var10_31 = var8_31 and var8_31.rewardedID or 0
	local var11_31 = var8_31 and var8_31.completeID or 0
	local var12_31 = table.indexof(var9_31.techs, var10_31, 1) or 0
	local var13_31 = table.indexof(var9_31.techs, var11_31, 1) or 0
	local var14_31 = var12_31 + 1
	local var15_31

	if var12_31 < var13_31 then
		var15_31 = var9_31.techs[var14_31]
	elseif var12_31 == var13_31 and var12_31 < #var9_31.techs then
		var15_31 = var9_31.techs[var14_31]
	end

	if var15_31 then
		setActive(var3_31, true)
		setActive(var1_31, true)
		setActive(var5_31, var12_31 < var13_31)
		setActive(var6_31, var12_31 == var13_31)
		setActive(var7_31, false)
		setText(var4_31, var14_31)

		local var16_31 = pg.fleet_tech_template[var15_31].level_award_display

		var2_31:make(function(arg0_32, arg1_32, arg2_32)
			if arg0_32 == UIItemList.EventUpdate then
				arg1_32 = arg1_32 + 1

				local var0_32 = var16_31[arg1_32]
				local var1_32 = {
					type = var0_32[1],
					id = var0_32[2],
					count = var0_32[3]
				}

				updateDrop(arg2_32, var1_32)
			end
		end)
		var2_31:align(#var16_31)

		if var12_31 < var13_31 then
			onButton(arg0_31, var5_31, function()
				pg.m02:sendNotification(GAME.GET_CAMP_TEC_AWARD, {
					groupID = arg2_31,
					tecID = var15_31
				})
			end, SFX_PANEL)
		end
	else
		setActive(var3_31, false)
		setActive(var1_31, false)
		setActive(var5_31, false)
		setActive(var6_31, false)
		setActive(var7_31, true)
	end
end

function var0_0.updateOneStepBtn(arg0_34)
	if LOCK_TEC_NATION_AWARD then
		setActive(arg0_34.oneStepBtn, false)

		return
	end

	setActive(arg0_34.oneStepBtn, arg0_34.nationProxy:isAnyTecCampCanGetAward())
end

function var0_0.updateTecListData(arg0_35)
	arg0_35.tecList = getProxy(TechnologyNationProxy):GetTecList()
end

return var0_0
