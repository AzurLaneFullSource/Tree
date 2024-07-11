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
	arg0_9.scrollRect = arg0_9:findTF("Scroll View")
	arg0_9.tecItemContainer = arg0_9:findTF("Scroll View/Viewport/Content")
	arg0_9.scrollRectCom = GetComponent(arg0_9.scrollRect, "ScrollRect")
	arg0_9.tecItemTpl = arg0_9:findTF("CampTecItem")
	arg0_9.typeItemTpl = arg0_9:findTF("TypeItem")
	arg0_9.buffItemTpl = arg0_9:findTF("BuffItem")
	arg0_9.tecItemTplOriginWidth = arg0_9.tecItemTpl.rect.width
	arg0_9.oneStepBtn = arg0_9:findTF("OneStepBtn")

	if not LOCK_TEC_NATION_AWARD then
		arg0_9.awardTpl = Instantiate(GetComponent(arg0_9._tf, "ItemList").prefabItem[0])

		setActive(arg0_9.awardTpl, false)

		local var0_9 = arg0_9.awardTpl:AddComponent(typeof(LayoutElement))

		var0_9.preferredWidth = 204
		var0_9.preferredHeight = 206

		local var1_9 = arg0_9:findTF("CampTecItem/AwardPanel/FinishBtn/Text")

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
end

function var0_0.updateTecItem(arg0_16, arg1_16)
	local var0_16 = arg0_16.panelList[arg1_16]
	local var1_16 = arg0_16:findTF("AwardPanel", var0_16)

	arg0_16:updateTecLevelAward(var1_16, arg1_16)

	local var2_16 = arg0_16:findTF("BaseInfo", var0_16)
	local var3_16 = arg0_16:findTF("BG/Title/Text", var2_16)
	local var4_16 = arg0_16:findTF("BG/UpLevelColor", var2_16)
	local var5_16 = arg0_16:findTF("NationBG", var2_16)
	local var6_16 = arg0_16:findTF("Code", var2_16)
	local var7_16 = arg0_16:findTF("NationTextImg", var6_16)
	local var8_16 = arg0_16:findTF("UpLevelBG", var2_16)
	local var9_16 = arg0_16:findTF("UpLevelBtn", var8_16)
	local var10_16 = arg0_16:findTF("FinishBtn", var8_16)
	local var11_16 = arg0_16:findTF("Uping", var2_16)
	local var12_16 = arg0_16:findTF("Text", var11_16)
	local var13_16 = arg0_16:findTF("EnglishTextImg", var2_16)
	local var14_16 = arg0_16:findTF("ProgressBarBG/Progress", var2_16)
	local var15_16 = arg0_16:findTF("CampLogo", var2_16)
	local var16_16 = arg0_16:findTF("LevelText/Text", var2_16)
	local var17_16 = arg0_16:findTF("PointTextBar", var2_16)
	local var18_16 = pg.fleet_tech_group[arg1_16].name
	local var19_16 = pg.fleet_tech_group[arg1_16].nation[1]

	setImageSprite(var5_16, GetSpriteFromAtlas("TecNation", "camptec_nation_bar_" .. var19_16))
	setImageSprite(var7_16, GetSpriteFromAtlas("TecNation", "camptec_nation_text_" .. var19_16), true)
	setImageSprite(var13_16, GetSpriteFromAtlas("TecNation", "camp_tec_english_" .. var19_16), true)
	setImageSprite(var15_16, GetSpriteFromAtlas("TecNation", "camptec_logo_" .. var19_16))
	setText(var3_16, var18_16)

	local var20_16
	local var21_16
	local var22_16 = not arg0_16.tecList[arg1_16] and 0 or table.indexof(pg.fleet_tech_group[arg1_16].techs, arg0_16.tecList[arg1_16].completeID, 1) or 0
	local var23_16 = arg0_16.nationToPoint[var19_16]
	local var24_16

	if var22_16 == 0 then
		var21_16 = pg.fleet_tech_group[arg1_16].techs[1]
		var24_16 = pg.fleet_tech_template[var21_16].pt
	elseif var22_16 == #pg.fleet_tech_group[arg1_16].techs then
		var21_16 = pg.fleet_tech_group[arg1_16].techs[var22_16]
		var24_16 = pg.fleet_tech_template[var21_16].pt
	else
		var21_16 = pg.fleet_tech_group[arg1_16].techs[var22_16 + 1]
		var24_16 = pg.fleet_tech_template[var21_16].pt
	end

	BaseUI:setImageAmount(var14_16, 0.1 + 0.8 * var23_16 / var24_16)
	setText(var16_16, var22_16)
	setText(var17_16, var23_16 .. "/" .. var24_16)

	local function var25_16(arg0_17, arg1_17, arg2_17)
		setActive(var6_16, arg0_17)
		setActive(var8_16, arg1_17)
		setActive(var4_16, arg1_17)
		setActive(var9_16, arg1_17)
		setActive(var11_16, arg2_17)
	end

	if not arg0_16.tecList[arg1_16] then
		if var24_16 <= var23_16 then
			var25_16(false, true, false)
		else
			var25_16(true, false, false)
		end
	elseif var22_16 == #pg.fleet_tech_group[arg1_16].techs then
		var25_16(true, false, false)
	elseif arg0_16.tecList[arg1_16].studyID ~= 0 then
		var25_16(false, false, true)

		if arg0_16.timerList[arg1_16] then
			arg0_16.timerList[arg1_16]:Stop()
		end

		local var26_16 = arg0_16.nationProxy:getLeftTime()

		setText(var12_16, pg.TimeMgr.GetInstance():DescCDTime(var26_16))

		arg0_16.timerList[arg1_16] = Timer.New(function()
			var26_16 = var26_16 - 1

			setText(var12_16, pg.TimeMgr.GetInstance():DescCDTime(var26_16))

			if var26_16 == 0 then
				arg0_16.timerList[arg1_16]:Stop()
			end
		end, 1, -1)

		arg0_16.timerList[arg1_16]:Start()
	elseif var24_16 <= var23_16 then
		var25_16(false, true, false)
	else
		var25_16(true, false, false)
	end

	onButton(arg0_16, var9_16, function()
		arg0_16:emit(TechnologyConst.CLICK_UP_TEC_BTN, arg1_16, var21_16)
	end, SFX_PANEL)

	local var27_16 = arg0_16:findTF("Mask/DetailPanel", var0_16)
	local var28_16 = GetComponent(var0_16, "LayoutElement")
	local var29_16 = arg0_16:findTF("Toggle", var27_16)

	arg0_16:updateDetailPanel(var27_16, var22_16, arg1_16, var19_16, false)
	onToggle(arg0_16, arg0_16:findTF("BG", var2_16), function(arg0_20)
		if arg0_20 then
			triggerToggle(var29_16, false)
			LeanTween.value(go(var0_16), arg0_16.tecItemTplOriginWidth, arg0_16.tecItemTplOriginWidth + var27_16.rect.width, 0.25):setOnUpdate(System.Action_float(function(arg0_21)
				var28_16.preferredWidth = arg0_21

				if arg1_16 == #pg.fleet_tech_group.all then
					arg0_16.scrollRectCom.horizontalNormalizedPosition = 1
				end
			end)):setOnComplete(System.Action(function()
				if arg1_16 == #pg.fleet_tech_group.all then
					arg0_16.scrollRectCom.horizontalNormalizedPosition = 1
				end
			end))
		else
			LeanTween.cancel(go(var0_16))

			local var0_20 = var28_16.preferredWidth

			LeanTween.value(go(var0_16), var0_20, arg0_16.tecItemTplOriginWidth, 0.25):setOnUpdate(System.Action_float(function(arg0_23)
				var28_16.preferredWidth = arg0_23
			end))
		end
	end)
end

function var0_0.updateDetailPanel(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24, arg5_24)
	local var0_24 = arg0_24:findTF("TypeItemContainer", arg1_24)
	local var1_24 = arg0_24:findTF("BG/Logo", arg1_24)

	setImageSprite(var1_24, GetSpriteFromAtlas("TecNation", "camptec_logo_" .. arg4_24))

	local var2_24 = arg0_24:findTF("Toggle", arg1_24)

	if arg2_24 == #pg.fleet_tech_group[arg3_24].techs and arg5_24 == false then
		setActive(var2_24, false)
	end

	local function var3_24(arg0_25, arg1_25, arg2_25)
		local var0_25 = UIItemList.New(var0_24, arg0_24.typeItemTpl)
		local var1_25

		if arg0_25 == 0 then
			var0_25:align(0)

			return
		else
			var1_25 = pg.fleet_tech_group[arg1_25].techs[arg0_25]
		end

		local var2_25
		local var3_25
		local var4_25
		local var5_25 = Color.New(1, 0.933333333333333, 0.192156862745098)

		if arg2_25 then
			var2_25, var3_25, var4_25 = arg0_24:calculateCurBuff(arg0_25 - 1, arg1_25)
		end

		local var6_25 = pg.fleet_tech_template[var1_25].add
		local var7_25 = {}
		local var8_25 = {}

		for iter0_25, iter1_25 in ipairs(var6_25) do
			local var9_25 = iter1_25[2]
			local var10_25 = iter1_25[3]
			local var11_25 = ShipType.FilterOverQuZhuType(iter1_25[1])

			for iter2_25, iter3_25 in ipairs(var11_25) do
				local var12_25

				if arg2_25 then
					if not table.indexof(var2_25, iter3_25, 1) then
						var12_25 = {
							attr = var9_25,
							value = var10_25,
							attrColor = var5_25,
							valueColor = var5_25
						}
					elseif not table.indexof(var3_25[iter3_25], var9_25, 1) then
						var12_25 = {
							attr = var9_25,
							value = var10_25,
							attrColor = var5_25,
							valueColor = var5_25
						}
					elseif var10_25 ~= var4_25[iter3_25][var9_25] then
						var12_25 = {
							attr = var9_25,
							value = var10_25,
							valueColor = var5_25
						}
					else
						var12_25 = {
							attr = var9_25,
							value = var10_25
						}
					end
				else
					var12_25 = {
						attr = var9_25,
						value = var10_25
					}
				end

				if var7_25[iter3_25] then
					table.insert(var7_25[iter3_25], var12_25)
				else
					var7_25[iter3_25] = {
						var12_25
					}
					var8_25[#var8_25 + 1] = iter3_25
				end
			end
		end

		var0_25:make(function(arg0_26, arg1_26, arg2_26)
			if arg0_26 == UIItemList.EventUpdate then
				local var0_26 = arg0_24:findTF("TypeIcon", arg2_26)
				local var1_26 = arg0_24:findTF("BuffItemContainer", arg2_26)
				local var2_26 = var8_25[arg1_26 + 1]

				setImageSprite(var0_26, GetSpriteFromAtlas("ShipType", "buffitem_tec_" .. var2_26))
				arg0_24:upBuffList(arg2_26, var7_25[var2_26])
			end
		end)
		var0_25:align(#var8_25)
	end

	onToggle(arg0_24, var2_24, function(arg0_27)
		if arg0_27 == true then
			var3_24(arg2_24 + 1, arg3_24, true)
		else
			var3_24(arg2_24, arg3_24)
		end
	end, SFX_PANEL)

	if arg5_24 == false then
		triggerToggle(var2_24, false)
	end
end

function var0_0.upBuffList(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28:findTF("BuffItemContainer", arg1_28)
	local var1_28 = UIItemList.New(var0_28, arg0_28.buffItemTpl)

	var1_28:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			local var0_29 = arg0_28:findTF("AttrText", arg2_29)
			local var1_29 = arg0_28:findTF("ValueText", arg2_29)
			local var2_29 = arg2_28[arg1_29 + 1].attr
			local var3_29 = arg2_28[arg1_29 + 1].value
			local var4_29 = arg2_28[arg1_29 + 1].attrColor
			local var5_29 = arg2_28[arg1_29 + 1].valueColor

			setText(var0_29, AttributeType.Type2Name(pg.attribute_info_by_type[var2_29].name))
			setText(var1_29, "+" .. var3_29)

			if var4_29 then
				setTextColor(var0_29, var4_29)
			else
				setTextColor(var0_29, Color.white)
			end

			if var5_29 then
				setTextColor(var1_29, var5_29)
			else
				setTextColor(var1_29, Color.green)
			end
		end
	end)
	var1_28:align(#arg2_28)
end

function var0_0.updateTecLevelAward(arg0_30, arg1_30, arg2_30)
	if LOCK_TEC_NATION_AWARD then
		setActive(arg1_30, false)

		return
	end

	local var0_30 = arg0_30:findTF("AwardItem")
	local var1_30 = arg0_30:findTF("ItemContainer", arg1_30)
	local var2_30 = UIItemList.New(var1_30, arg0_30.awardTpl)
	local var3_30 = arg0_30:findTF("Level", arg1_30)
	local var4_30 = arg0_30:findTF("Level/Num", arg1_30)
	local var5_30 = arg0_30:findTF("GetBtn", arg1_30)
	local var6_30 = arg0_30:findTF("DisGetBtn", arg1_30)
	local var7_30 = arg0_30:findTF("FinishBtn", arg1_30)
	local var8_30 = arg0_30.nationProxy:GetTecItemByGroupID(arg2_30)
	local var9_30 = pg.fleet_tech_group[arg2_30]
	local var10_30 = var8_30 and var8_30.rewardedID or 0
	local var11_30 = var8_30 and var8_30.completeID or 0
	local var12_30 = table.indexof(var9_30.techs, var10_30, 1) or 0
	local var13_30 = table.indexof(var9_30.techs, var11_30, 1) or 0
	local var14_30 = var12_30 + 1
	local var15_30

	if var12_30 < var13_30 then
		var15_30 = var9_30.techs[var14_30]
	elseif var12_30 == var13_30 and var12_30 < #var9_30.techs then
		var15_30 = var9_30.techs[var14_30]
	end

	if var15_30 then
		setActive(var3_30, true)
		setActive(var1_30, true)
		setActive(var5_30, var12_30 < var13_30)
		setActive(var6_30, var12_30 == var13_30)
		setActive(var7_30, false)
		setText(var4_30, var14_30)

		local var16_30 = pg.fleet_tech_template[var15_30].level_award_display

		var2_30:make(function(arg0_31, arg1_31, arg2_31)
			if arg0_31 == UIItemList.EventUpdate then
				arg1_31 = arg1_31 + 1

				local var0_31 = var16_30[arg1_31]
				local var1_31 = {
					type = var0_31[1],
					id = var0_31[2],
					count = var0_31[3]
				}

				updateDrop(arg2_31, var1_31)
			end
		end)
		var2_30:align(#var16_30)

		if var12_30 < var13_30 then
			onButton(arg0_30, var5_30, function()
				pg.m02:sendNotification(GAME.GET_CAMP_TEC_AWARD, {
					groupID = arg2_30,
					tecID = var15_30
				})
			end, SFX_PANEL)
		end
	else
		setActive(var3_30, false)
		setActive(var1_30, false)
		setActive(var5_30, false)
		setActive(var6_30, false)
		setActive(var7_30, true)
	end
end

function var0_0.updateOneStepBtn(arg0_33)
	if LOCK_TEC_NATION_AWARD then
		setActive(arg0_33.oneStepBtn, false)

		return
	end

	setActive(arg0_33.oneStepBtn, arg0_33.nationProxy:isAnyTecCampCanGetAward())
end

function var0_0.updateTecListData(arg0_34)
	arg0_34.tecList = getProxy(TechnologyNationProxy):GetTecList()
end

return var0_0
