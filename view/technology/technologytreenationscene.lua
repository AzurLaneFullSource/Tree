local var0 = class("TechnologyTreeNationScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "TechnologyTreeCampUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
end

function var0.didEnter(arg0)
	arg0:addListener()
	arg0:updateTecItemList()
	arg0:updateOneStepBtn()
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.timerList) do
		iter1:Stop()
	end
end

function var0.initData(arg0)
	arg0.nationProxy = getProxy(TechnologyNationProxy)
	arg0.nationToPoint = arg0.nationProxy:getNationPointList()
	arg0.tecList = arg0.nationProxy:GetTecList()
	arg0.panelList = {}
	arg0.timerList = {}
end

function var0.calculateCurBuff(arg0, arg1, arg2)
	local var0

	if arg1 == 0 then
		return {}, {}, {}
	else
		var0 = pg.fleet_tech_group[arg2].techs[arg1]
	end

	local var1 = pg.fleet_tech_template[var0].add
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(var1) do
		local var4 = iter1[2]
		local var5 = iter1[3]
		local var6 = iter1[1]

		for iter2, iter3 in ipairs(var6) do
			if var2[iter3] then
				table.insert(var2[iter3], {
					attr = var4,
					value = var5
				})
			else
				var2[iter3] = {
					{
						attr = var4,
						value = var5
					}
				}
				var3[#var3 + 1] = iter3
			end
		end
	end

	local var7 = {}
	local var8 = {}

	for iter4, iter5 in pairs(var2) do
		if not var7[iter4] then
			var7[iter4] = {}
			var8[iter4] = {}
		end

		for iter6, iter7 in ipairs(iter5) do
			local var9 = iter7.attr
			local var10 = iter7.value

			if not var7[iter4][var9] then
				var7[iter4][var9] = var10
				var8[iter4][#var8[iter4] + 1] = var9
			else
				var7[iter4][var9] = var7[iter4][var9] + var10
			end
		end
	end

	table.sort(var3, function(arg0, arg1)
		return arg0 < arg1
	end)

	for iter8, iter9 in pairs(var8) do
		table.sort(iter9, function(arg0, arg1)
			return arg0 < arg1
		end)
	end

	return var3, var8, var7
end

function var0.findUI(arg0)
	arg0.scrollRect = arg0:findTF("Scroll View")
	arg0.tecItemContainer = arg0:findTF("Scroll View/Viewport/Content")
	arg0.scrollRectCom = GetComponent(arg0.scrollRect, "ScrollRect")
	arg0.tecItemTpl = arg0:findTF("CampTecItem")
	arg0.typeItemTpl = arg0:findTF("TypeItem")
	arg0.buffItemTpl = arg0:findTF("BuffItem")
	arg0.tecItemTplOriginWidth = arg0.tecItemTpl.rect.width
	arg0.oneStepBtn = arg0:findTF("OneStepBtn")

	if not LOCK_TEC_NATION_AWARD then
		arg0.awardTpl = Instantiate(GetComponent(arg0._tf, "ItemList").prefabItem[0])

		setActive(arg0.awardTpl, false)

		local var0 = arg0.awardTpl:AddComponent(typeof(LayoutElement))

		var0.preferredWidth = 204
		var0.preferredHeight = 206

		local var1 = arg0:findTF("CampTecItem/AwardPanel/FinishBtn/Text")

		setText(var1, i18n("tec_nation_award_finish"))
	else
		setActive(arg0.oneStepBtn, false)
	end
end

function var0.onBackPressed(arg0)
	arg0:emit(var0.ON_BACK)
end

function var0.closeMyself(arg0)
	arg0:emit(var0.ON_CLOSE)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.oneStepBtn, function()
		pg.m02:sendNotification(GAME.GET_CAMP_TEC_AWARD_ONESTEP)
	end, SFX_PANEL)
end

function var0.updateTecItemList(arg0)
	local var0 = UIItemList.New(arg0.tecItemContainer, arg0.tecItemTpl)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1

			arg0.panelList[var0] = arg2

			arg0:updateTecItem(var0)
		end
	end)
	var0:align(#pg.fleet_tech_group.all)
end

function var0.updateTecItem(arg0, arg1)
	local var0 = arg0.panelList[arg1]
	local var1 = arg0:findTF("AwardPanel", var0)

	arg0:updateTecLevelAward(var1, arg1)

	local var2 = arg0:findTF("BaseInfo", var0)
	local var3 = arg0:findTF("BG/Title/Text", var2)
	local var4 = arg0:findTF("BG/UpLevelColor", var2)
	local var5 = arg0:findTF("NationBG", var2)
	local var6 = arg0:findTF("Code", var2)
	local var7 = arg0:findTF("NationTextImg", var6)
	local var8 = arg0:findTF("UpLevelBG", var2)
	local var9 = arg0:findTF("UpLevelBtn", var8)
	local var10 = arg0:findTF("FinishBtn", var8)
	local var11 = arg0:findTF("Uping", var2)
	local var12 = arg0:findTF("Text", var11)
	local var13 = arg0:findTF("EnglishTextImg", var2)
	local var14 = arg0:findTF("ProgressBarBG/Progress", var2)
	local var15 = arg0:findTF("CampLogo", var2)
	local var16 = arg0:findTF("LevelText/Text", var2)
	local var17 = arg0:findTF("PointTextBar", var2)
	local var18 = pg.fleet_tech_group[arg1].name
	local var19 = pg.fleet_tech_group[arg1].nation[1]

	setImageSprite(var5, GetSpriteFromAtlas("TecNation", "camptec_nation_bar_" .. var19))
	setImageSprite(var7, GetSpriteFromAtlas("TecNation", "camptec_nation_text_" .. var19), true)
	setImageSprite(var13, GetSpriteFromAtlas("TecNation", "camp_tec_english_" .. var19), true)
	setImageSprite(var15, GetSpriteFromAtlas("TecNation", "camptec_logo_" .. var19))
	setText(var3, var18)

	local var20
	local var21
	local var22 = not arg0.tecList[arg1] and 0 or table.indexof(pg.fleet_tech_group[arg1].techs, arg0.tecList[arg1].completeID, 1) or 0
	local var23 = arg0.nationToPoint[var19]
	local var24

	if var22 == 0 then
		var21 = pg.fleet_tech_group[arg1].techs[1]
		var24 = pg.fleet_tech_template[var21].pt
	elseif var22 == #pg.fleet_tech_group[arg1].techs then
		var21 = pg.fleet_tech_group[arg1].techs[var22]
		var24 = pg.fleet_tech_template[var21].pt
	else
		var21 = pg.fleet_tech_group[arg1].techs[var22 + 1]
		var24 = pg.fleet_tech_template[var21].pt
	end

	BaseUI:setImageAmount(var14, 0.1 + 0.8 * var23 / var24)
	setText(var16, var22)
	setText(var17, var23 .. "/" .. var24)

	local function var25(arg0, arg1, arg2)
		setActive(var6, arg0)
		setActive(var8, arg1)
		setActive(var4, arg1)
		setActive(var9, arg1)
		setActive(var11, arg2)
	end

	if not arg0.tecList[arg1] then
		if var24 <= var23 then
			var25(false, true, false)
		else
			var25(true, false, false)
		end
	elseif var22 == #pg.fleet_tech_group[arg1].techs then
		var25(true, false, false)
	elseif arg0.tecList[arg1].studyID ~= 0 then
		var25(false, false, true)

		if arg0.timerList[arg1] then
			arg0.timerList[arg1]:Stop()
		end

		local var26 = arg0.nationProxy:getLeftTime()

		setText(var12, pg.TimeMgr.GetInstance():DescCDTime(var26))

		arg0.timerList[arg1] = Timer.New(function()
			var26 = var26 - 1

			setText(var12, pg.TimeMgr.GetInstance():DescCDTime(var26))

			if var26 == 0 then
				arg0.timerList[arg1]:Stop()
			end
		end, 1, -1)

		arg0.timerList[arg1]:Start()
	elseif var24 <= var23 then
		var25(false, true, false)
	else
		var25(true, false, false)
	end

	onButton(arg0, var9, function()
		arg0:emit(TechnologyConst.CLICK_UP_TEC_BTN, arg1, var21)
	end, SFX_PANEL)

	local var27 = arg0:findTF("Mask/DetailPanel", var0)
	local var28 = GetComponent(var0, "LayoutElement")
	local var29 = arg0:findTF("Toggle", var27)

	arg0:updateDetailPanel(var27, var22, arg1, var19, false)
	onToggle(arg0, arg0:findTF("BG", var2), function(arg0)
		if arg0 then
			triggerToggle(var29, false)
			LeanTween.value(go(var0), arg0.tecItemTplOriginWidth, arg0.tecItemTplOriginWidth + var27.rect.width, 0.25):setOnUpdate(System.Action_float(function(arg0)
				var28.preferredWidth = arg0

				if arg1 == #pg.fleet_tech_group.all then
					arg0.scrollRectCom.horizontalNormalizedPosition = 1
				end
			end)):setOnComplete(System.Action(function()
				if arg1 == #pg.fleet_tech_group.all then
					arg0.scrollRectCom.horizontalNormalizedPosition = 1
				end
			end))
		else
			LeanTween.cancel(go(var0))

			local var0 = var28.preferredWidth

			LeanTween.value(go(var0), var0, arg0.tecItemTplOriginWidth, 0.25):setOnUpdate(System.Action_float(function(arg0)
				var28.preferredWidth = arg0
			end))
		end
	end)
end

function var0.updateDetailPanel(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0:findTF("TypeItemContainer", arg1)
	local var1 = arg0:findTF("BG/Logo", arg1)

	setImageSprite(var1, GetSpriteFromAtlas("TecNation", "camptec_logo_" .. arg4))

	local var2 = arg0:findTF("Toggle", arg1)

	if arg2 == #pg.fleet_tech_group[arg3].techs and arg5 == false then
		setActive(var2, false)
	end

	local function var3(arg0, arg1, arg2)
		local var0 = UIItemList.New(var0, arg0.typeItemTpl)
		local var1

		if arg0 == 0 then
			var0:align(0)

			return
		else
			var1 = pg.fleet_tech_group[arg1].techs[arg0]
		end

		local var2
		local var3
		local var4
		local var5 = Color.New(1, 0.933333333333333, 0.192156862745098)

		if arg2 then
			var2, var3, var4 = arg0:calculateCurBuff(arg0 - 1, arg1)
		end

		local var6 = pg.fleet_tech_template[var1].add
		local var7 = {}
		local var8 = {}

		for iter0, iter1 in ipairs(var6) do
			local var9 = iter1[2]
			local var10 = iter1[3]
			local var11 = ShipType.FilterOverQuZhuType(iter1[1])

			for iter2, iter3 in ipairs(var11) do
				local var12

				if arg2 then
					if not table.indexof(var2, iter3, 1) then
						var12 = {
							attr = var9,
							value = var10,
							attrColor = var5,
							valueColor = var5
						}
					elseif not table.indexof(var3[iter3], var9, 1) then
						var12 = {
							attr = var9,
							value = var10,
							attrColor = var5,
							valueColor = var5
						}
					elseif var10 ~= var4[iter3][var9] then
						var12 = {
							attr = var9,
							value = var10,
							valueColor = var5
						}
					else
						var12 = {
							attr = var9,
							value = var10
						}
					end
				else
					var12 = {
						attr = var9,
						value = var10
					}
				end

				if var7[iter3] then
					table.insert(var7[iter3], var12)
				else
					var7[iter3] = {
						var12
					}
					var8[#var8 + 1] = iter3
				end
			end
		end

		var0:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = arg0:findTF("TypeIcon", arg2)
				local var1 = arg0:findTF("BuffItemContainer", arg2)
				local var2 = var8[arg1 + 1]

				setImageSprite(var0, GetSpriteFromAtlas("ShipType", "buffitem_tec_" .. var2))
				arg0:upBuffList(arg2, var7[var2])
			end
		end)
		var0:align(#var8)
	end

	onToggle(arg0, var2, function(arg0)
		if arg0 == true then
			var3(arg2 + 1, arg3, true)
		else
			var3(arg2, arg3)
		end
	end, SFX_PANEL)

	if arg5 == false then
		triggerToggle(var2, false)
	end
end

function var0.upBuffList(arg0, arg1, arg2)
	local var0 = arg0:findTF("BuffItemContainer", arg1)
	local var1 = UIItemList.New(var0, arg0.buffItemTpl)

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("AttrText", arg2)
			local var1 = arg0:findTF("ValueText", arg2)
			local var2 = arg2[arg1 + 1].attr
			local var3 = arg2[arg1 + 1].value
			local var4 = arg2[arg1 + 1].attrColor
			local var5 = arg2[arg1 + 1].valueColor

			setText(var0, AttributeType.Type2Name(pg.attribute_info_by_type[var2].name))
			setText(var1, "+" .. var3)

			if var4 then
				setTextColor(var0, var4)
			else
				setTextColor(var0, Color.white)
			end

			if var5 then
				setTextColor(var1, var5)
			else
				setTextColor(var1, Color.green)
			end
		end
	end)
	var1:align(#arg2)
end

function var0.updateTecLevelAward(arg0, arg1, arg2)
	if LOCK_TEC_NATION_AWARD then
		setActive(arg1, false)

		return
	end

	local var0 = arg0:findTF("AwardItem")
	local var1 = arg0:findTF("ItemContainer", arg1)
	local var2 = UIItemList.New(var1, arg0.awardTpl)
	local var3 = arg0:findTF("Level", arg1)
	local var4 = arg0:findTF("Level/Num", arg1)
	local var5 = arg0:findTF("GetBtn", arg1)
	local var6 = arg0:findTF("DisGetBtn", arg1)
	local var7 = arg0:findTF("FinishBtn", arg1)
	local var8 = arg0.nationProxy:GetTecItemByGroupID(arg2)
	local var9 = pg.fleet_tech_group[arg2]
	local var10 = var8 and var8.rewardedID or 0
	local var11 = var8 and var8.completeID or 0
	local var12 = table.indexof(var9.techs, var10, 1) or 0
	local var13 = table.indexof(var9.techs, var11, 1) or 0
	local var14 = var12 + 1
	local var15

	if var12 < var13 then
		var15 = var9.techs[var14]
	elseif var12 == var13 and var12 < #var9.techs then
		var15 = var9.techs[var14]
	end

	if var15 then
		setActive(var3, true)
		setActive(var1, true)
		setActive(var5, var12 < var13)
		setActive(var6, var12 == var13)
		setActive(var7, false)
		setText(var4, var14)

		local var16 = pg.fleet_tech_template[var15].level_award_display

		var2:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				arg1 = arg1 + 1

				local var0 = var16[arg1]
				local var1 = {
					type = var0[1],
					id = var0[2],
					count = var0[3]
				}

				updateDrop(arg2, var1)
			end
		end)
		var2:align(#var16)

		if var12 < var13 then
			onButton(arg0, var5, function()
				pg.m02:sendNotification(GAME.GET_CAMP_TEC_AWARD, {
					groupID = arg2,
					tecID = var15
				})
			end, SFX_PANEL)
		end
	else
		setActive(var3, false)
		setActive(var1, false)
		setActive(var5, false)
		setActive(var6, false)
		setActive(var7, true)
	end
end

function var0.updateOneStepBtn(arg0)
	if LOCK_TEC_NATION_AWARD then
		setActive(arg0.oneStepBtn, false)

		return
	end

	setActive(arg0.oneStepBtn, arg0.nationProxy:isAnyTecCampCanGetAward())
end

function var0.updateTecListData(arg0)
	arg0.tecList = getProxy(TechnologyNationProxy):GetTecList()
end

return var0
