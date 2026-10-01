local var0_0 = class("ShipRemouldLayer", import("..base.BaseUI"))
local var1_0 = 5
local var2_0 = 6
local var3_0 = 1
local var4_0 = 9
local var5_0 = 55
local var6_0 = Vector2(-5, 25)

function var0_0.getUIName(arg0_1)
	return "ShipRemouldUI"
end

function var0_0.getGroupName(arg0_2)
	return "ShipMainScene"
end

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = {
		"modicon"
	}

	table.insertto(var0_3, var0_0.super.getResource(arg0_3, arg1_3))

	return var0_3
end

function var0_0.init(arg0_4)
	arg0_4.container = arg0_4._tf:Find("main/bg/container")
	arg0_4.gridContainer = arg0_4.container:Find("grids")
	arg0_4.gridTF = arg0_4.gridContainer:Find("grid_tpl")
	arg0_4.height = arg0_4.gridTF.sizeDelta.y + var5_0
	arg0_4.width = arg0_4.gridTF.sizeDelta.x + var4_0
	arg0_4.startPos = Vector2(-1 * ((var2_0 / 2 - 0.5) * arg0_4.width) + var6_0.x, (var1_0 / 2 - 0.5) * arg0_4.height + var6_0.y)
	arg0_4.containerWidth = var2_0 * arg0_4.gridTF.sizeDelta.x + (var2_0 - 1) * var4_0
	arg0_4.containerHeight = var1_0 * arg0_4.gridTF.sizeDelta.y + (var1_0 - 1) * var5_0
	arg0_4.container.sizeDelta = Vector2(arg0_4.containerWidth, arg0_4.containerHeight)

	setActive(arg0_4.gridTF, false)

	arg0_4.infoPanel = arg0_4._tf:Find("main/info_panel")
	arg0_4.itemContainer = arg0_4.infoPanel:Find("usages/items")
	arg0_4.itemTF = arg0_4.itemContainer:Find("itemTF")
	arg0_4.infoName = arg0_4.infoPanel:Find("name_container/Text"):GetComponent(typeof(Text))
	arg0_4.attrContainer = arg0_4.infoPanel:Find("align/attrs")
	arg0_4.attrTpl = arg0_4:getTpl("attr", arg0_4.attrContainer)
	arg0_4.attrTplD = arg0_4:getTpl("attrd", arg0_4.attrContainer)
	arg0_4.confirmBtn = arg0_4.infoPanel:Find("confirm_btn/activity")
	arg0_4.inactiveBtn = arg0_4.infoPanel:Find("confirm_btn/inactivity")
	arg0_4.completedteBtn = arg0_4.infoPanel:Find("confirm_btn/complete")
	arg0_4.shipTF = arg0_4._tf:Find("main/info_panel/usages/shipTF")
	arg0_4.skillDesc = arg0_4.infoPanel:Find("align/skill_desc/text")
	arg0_4.shipContainer = arg0_4.infoPanel:Find("char_container")
	arg0_4.lineTpl = arg0_4._tf:Find("resources/line")
	arg0_4.lineContainer = arg0_4.container:Find("grids/lines")
	arg0_4.helpBtn = GameObject.Find("/OverlayCamera/Overlay/UIMain/common/help_btn")

	if not IsNil(arg0_4.helpBtn) then
		setActive(arg0_4.helpBtn, false)
	end

	arg0_4.tooltip = arg0_4._tf:Find("tooltip")

	setActive(arg0_4.tooltip, false)
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.playerVO = arg1_5

	if arg0_5.curtransformId then
		arg0_5:updateInfo(arg0_5.curtransformId)
	end
end

function var0_0.setItems(arg0_6, arg1_6)
	arg0_6.itemsVO = arg1_6
end

function var0_0.getItemCount(arg0_7, arg1_7)
	return (arg0_7.itemsVO[arg1_7] or Item.New({
		count = 0,
		id = arg1_7
	})).count
end

function var0_0.setShipVO(arg0_8, arg1_8)
	arg0_8.shipVO = arg1_8
	arg0_8.shipGroupId = math.floor(arg0_8.shipVO:getGroupId())
end

function var0_0.getShipTranformData(arg0_9)
	local var0_9 = pg.ship_data_trans[arg0_9.shipGroupId]

	assert(var0_9, "config missed [pg.ship_data_trans] shipGroup>>>." .. arg0_9.shipGroupId)

	local var1_9 = {}

	for iter0_9, iter1_9 in ipairs(var0_9.transform_list) do
		for iter2_9, iter3_9 in ipairs(iter1_9) do
			var1_9[iter3_9[2]] = Vector2(iter0_9, iter3_9[1])
		end
	end

	return var1_9
end

function var0_0.didEnter(arg0_10)
	arg0_10:initTranformInfo()
	arg0_10:initShipModel()
end

function var0_0.initTranformInfo(arg0_11)
	arg0_11.transformIds = arg0_11:getShipTranformData()
	arg0_11.grids = {}

	for iter0_11, iter1_11 in pairs(arg0_11.transformIds) do
		local var0_11 = cloneTplTo(arg0_11.gridTF, arg0_11.gridContainer)

		go(var0_11).name = iter0_11
		var0_11.localPosition = Vector2(arg0_11.startPos.x + arg0_11.width * (iter1_11.x - 1), arg0_11.startPos.y - arg0_11.height * (iter1_11.y - 1))

		onToggle(arg0_11, var0_11, function(arg0_12)
			if arg0_12 and arg0_11.curtransformId ~= iter0_11 then
				arg0_11:updateInfo(iter0_11)
			end
		end, SFX_PANEL)

		arg0_11.grids[iter0_11] = var0_11
	end

	arg0_11.lineTFs = {}

	for iter2_11, iter3_11 in pairs(arg0_11.transformIds) do
		arg0_11:initLines(iter2_11)
	end

	arg0_11.posTransId = {}

	arg0_11:updateLines()

	if arg0_11.contextData.transformId then
		assert(arg0_11.grids[arg0_11.contextData.transformId], "without this transform id:" .. arg0_11.contextData.transformId)
		triggerToggle(arg0_11.grids[arg0_11.contextData.transformId], true)
	end
end

function var0_0.initLines(arg0_13, arg1_13)
	local var0_13 = 270
	local var1_13 = 75

	arg0_13.lineTFs[arg1_13] = {}

	local var2_13 = arg0_13.transformIds[arg1_13].x
	local var3_13 = arg0_13.transformIds[arg1_13].y
	local var4_13 = arg0_13.grids[arg1_13]
	local var5_13 = var4_13.sizeDelta
	local var6_13 = var4_13.localPosition
	local var7_13 = arg0_13.lineTpl
	local var8_13 = pg.transform_data_template[arg1_13].condition_id

	for iter0_13, iter1_13 in pairs(var8_13) do
		local var9_13 = arg0_13.transformIds[iter1_13].x
		local var10_13 = arg0_13.transformIds[iter1_13].y
		local var11_13 = Vector2(var9_13 - var2_13, var10_13 - var3_13)

		if var11_13 ~= Vector2.zero then
			local var12_13 = cloneTplTo(var7_13, arg0_13.lineContainer, var2_13 .. "-" .. var3_13 .. "-v")
			local var13_13 = cloneTplTo(var7_13, arg0_13.lineContainer, var2_13 .. "-" .. var3_13 .. "-h")
			local var14_13 = var11_13.y < 0 and 90 or -90

			var12_13.eulerAngles = Vector3(0, 0, var14_13)

			local var15_13 = var11_13.x < 0 and 180 or 0

			var13_13.eulerAngles = Vector3(0, 0, var15_13)

			local var16_13 = math.abs(var11_13.y) > 0 and math.abs(var11_13.x) > 0

			if var16_13 then
				local var17_13 = var6_13.y + (var3_13 - var10_13) * var0_13

				var13_13.localPosition = Vector2(var6_13.x, var17_13, 0)

				local var18_13 = var11_13.y < 0 and var6_13.y + var5_13.y / 2 or var6_13.y - var5_13.y / 2

				var12_13.localPosition = Vector2(var6_13.x, var18_13)
				var13_13.sizeDelta = Vector2(math.abs(var11_13.x) * var0_13, var13_13.sizeDelta.y)
				var12_13.sizeDelta = Vector2(math.abs(var11_13.y) * var0_13 - var5_13.y / 2, var12_13.sizeDelta.y)

				local var19_13 = var11_13.x < 0 and var14_13 < 0 and -1 or 1

				var12_13:Find("corner").localScale = Vector3(1, var19_13, 1)
			else
				var13_13.sizeDelta = Vector2(math.abs(var11_13.x) * var0_13, var13_13.sizeDelta.y)
				var12_13.sizeDelta = Vector2(math.abs(var11_13.y) * var1_13, var12_13.sizeDelta.y)
				var13_13.localPosition = var6_13

				local var20_13 = var11_13.y < 0 and var6_13.y + var5_13.y / 2 or var6_13.y - var5_13.y / 2

				var12_13.localPosition = Vector3(var6_13.x, var20_13, 0)
			end

			setActive(var12_13:Find("arr"), var16_13 or math.abs(var11_13.y) > 0)
			setActive(var12_13:Find("corner"), var16_13)
			setActive(var13_13:Find("arr"), false)
			setActive(var13_13:Find("corner"), false)
			table.insert(arg0_13.lineTFs[arg1_13], {
				id = iter1_13,
				hrz = var13_13,
				vec = var12_13
			})
		end
	end
end

function var0_0.updateLines(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.transformIds) do
		arg0_14:updateGridTF(iter0_14)

		if arg0_14:canRemould(iter0_14) or arg0_14:isFinished(iter0_14) then
			for iter2_14, iter3_14 in ipairs(arg0_14.lineTFs[iter0_14] or {}) do
				iter3_14.hrz:GetComponent("UIGrayScale").enabled = false
				iter3_14.vec:GetComponent("UIGrayScale").enabled = false
			end
		end
	end
end

function var0_0.getLevelById(arg0_15, arg1_15)
	return pg.transform_data_template[arg1_15].level_limit
end

function var0_0.getTransformLevel(arg0_16, arg1_16)
	if not arg0_16.shipVO.transforms[arg1_16] then
		return 0
	else
		return arg0_16.shipVO.transforms[arg1_16].level
	end
end

var0_0.STATE_FINISHED = 1
var0_0.STATE_ACTIVE = 2
var0_0.STATE_LOCK = 3

function var0_0.getTransformState(arg0_17, arg1_17)
	if arg0_17:getTransformLevel(arg1_17) == pg.transform_data_template[arg1_17].max_level then
		return var0_0.STATE_FINISHED
	elseif arg0_17:canRemould(arg1_17) then
		return var0_0.STATE_ACTIVE
	else
		return var0_0.STATE_LOCK
	end
end

function var0_0.updateGridTF(arg0_18, arg1_18)
	local var0_18 = arg0_18.grids[arg1_18]
	local var1_18 = pg.transform_data_template[arg1_18]

	setText(var0_18:Find("name"), var1_18.name)

	local var2_18 = var0_18:Find("icon"):GetComponent(typeof(Image))

	GetSpriteFromAtlasAsync("modicon", var1_18.icon, function(arg0_19)
		if not IsNil(var2_18) then
			var2_18.sprite = arg0_19
		end
	end)

	local var3_18 = arg0_18:getTransformState(arg1_18)

	setActive(var0_18:Find("bgs/finished"), var3_18 == var0_0.STATE_FINISHED)
	setActive(var0_18:Find("bgs/ongoing"), var3_18 == var0_0.STATE_ACTIVE)
	setActive(var0_18:Find("bgs/lock"), var3_18 == var0_0.STATE_LOCK)
	setActive(var0_18:Find("tags/finished"), var3_18 == var0_0.STATE_FINISHED)
	setActive(var0_18:Find("tags/ongoing"), var3_18 == var0_0.STATE_ACTIVE)
	setActive(var0_18:Find("tags/lock"), var3_18 == var0_0.STATE_LOCK)

	local var4_18 = arg0_18:getTransformLevel(arg1_18)
	local var5_18 = var0_18:Find("icon/progress")

	if var3_18 == var0_0.STATE_FINISHED then
		setText(var5_18, var4_18 .. "/" .. var1_18.max_level)
	elseif var3_18 == var0_0.STATE_ACTIVE then
		setText(var5_18, var4_18 .. "/" .. var1_18.max_level)
	elseif var3_18 == var0_0.STATE_LOCK then
		local var6_18, var7_18, var8_18 = arg0_18:canRemould(arg1_18)

		setText(var5_18, "")
		setActive(var0_18:Find("tags/lock/lock_prev"), var8_18 and var8_18[1] == 1)
		setActive(var0_18:Find("tags/lock/lock_level"), var8_18 and var8_18[1] == 2)
		setActive(var0_18:Find("tags/lock/lock_star"), var8_18 and var8_18[1] == 3)

		if var8_18 and var8_18[1] == 2 then
			setText(var0_18:Find("tags/lock/lock_level/Text"), var8_18[2])
		elseif var8_18 and var8_18[1] == 3 then
			setText(var0_18:Find("tags/lock/lock_star/Text"), var8_18[2])
		end
	end

	local var9_18 = arg0_18.transformIds[arg1_18].x .. "_" .. arg0_18.transformIds[arg1_18].y

	if not arg0_18.posTransId[var9_18] then
		arg0_18.posTransId[var9_18] = arg1_18
	elseif arg0_18.posTransId[var9_18] == arg1_18 then
		-- block empty
	elseif var3_18 == var0_0.STATE_ACTIVE or arg0_18:getTransformState(arg0_18.posTransId[var9_18]) ~= var0_0.STATE_ACTIVE and arg1_18 < arg0_18.posTransId[var9_18] then
		if arg0_18.posTransId[var9_18] == arg0_18.curtransformId then
			arg0_18.curtransformId = arg1_18
		end

		setActive(arg0_18.grids[arg0_18.posTransId[var9_18]], false)

		arg0_18.posTransId[var9_18] = arg1_18
	end

	setActive(var0_18, arg1_18 == arg0_18.posTransId[var9_18])

	if arg0_18.curtransformId == arg1_18 then
		arg0_18:updateInfo(arg1_18)
	end
end

function var0_0.initShipModel(arg0_20)
	local var0_20 = arg0_20.shipVO:getPrefab()

	if arg0_20.shipContainer.childCount ~= 0 then
		arg0_20.shipModel:Dispose()
	end

	local function var1_20(arg0_21)
		if not IsNil(arg0_20._tf) then
			arg0_20.shipModel = arg0_21

			arg0_21:SetLayer(Layer.UI)
			arg0_21:SetLocalScale(Vector3(var3_0, var3_0, 1))
			arg0_21:SetParent(arg0_20.shipContainer)
			arg0_21:SetLocalPosition(Vector2(0, 10))
			arg0_21:SetAction("stand2", 0)
		end
	end

	local var2_20 = SpineAnimChar.New()

	var2_20:SetPaint(var0_20)
	var2_20:Load(true, function(arg0_22)
		var1_20(arg0_22)
	end)
end

function var0_0.updateInfo(arg0_23, arg1_23)
	if arg0_23:isFinished(arg1_23) then
		arg0_23:updateFinished(arg1_23)
	else
		arg0_23:updateProgress(arg1_23)
	end
end

function var0_0.updateFinished(arg0_24, arg1_24)
	local var0_24 = arg0_24.shipVO.transforms[arg1_24].level

	arg0_24.curtransformId = arg1_24

	local var1_24 = pg.transform_data_template[arg1_24]

	arg0_24.infoName.text = var1_24.name

	local var2_24 = {}

	for iter0_24 = 1, var0_24 do
		_.each(var1_24.use_item[iter0_24], function(arg0_25)
			local var0_25 = _.detect(var2_24, function(arg0_26)
				return arg0_26.type == DROP_TYPE_ITEM and arg0_26.id == arg0_25[1]
			end)

			if not var0_25 then
				table.insert(var2_24, {
					type = DROP_TYPE_ITEM,
					id = arg0_25[1],
					count = arg0_25[2]
				})
			else
				var0_25.count = var0_25.count + arg0_25[2]
			end
		end)
	end

	table.insert(var2_24, {
		type = DROP_TYPE_ITEM,
		id = id2ItemId(PlayerConst.ResGold),
		count = var1_24.use_gold * var0_24
	})

	for iter1_24 = arg0_24.itemContainer.childCount, #var2_24 - 1 do
		cloneTplTo(arg0_24.itemTF, arg0_24.itemContainer)
	end

	local var3_24 = arg0_24.itemContainer.childCount

	for iter2_24 = 1, var3_24 do
		local var4_24 = arg0_24.itemContainer:GetChild(iter2_24 - 1)

		setActive(var4_24, iter2_24 <= #var2_24)

		if iter2_24 <= #var2_24 then
			updateDrop(var4_24:Find("IconTpl"), var2_24[iter2_24])
			RemoveComponent(var4_24, typeof(Button))
		end
	end

	setActive(arg0_24.shipTF, var1_24.use_ship > 0)

	if var1_24.use_ship > 0 then
		setActive(arg0_24.shipTF:Find("addTF"), false)
		setActive(arg0_24.shipTF:Find("IconTpl"), true)
		updateDrop(arg0_24.shipTF:Find("IconTpl"), {
			type = DROP_TYPE_SHIP,
			id = arg0_24.shipVO.configId
		})
		removeOnButton(arg0_24.shipTF)
	end

	setActive(arg0_24.skillDesc.parent, var1_24.skill_id ~= 0)

	if var1_24.skill_id ~= 0 then
		local var5_24 = pg.skill_data_template[var1_24.skill_id].name

		setText(arg0_24.skillDesc, i18n("ship_remould_material_unlock_skill", var5_24))
	end

	removeAllChildren(arg0_24.attrContainer)

	local var6_24
	local var7_24

	_.each(var1_24.ship_id, function(arg0_27)
		if arg0_27[1] == arg0_24.shipVO.configId then
			var6_24 = arg0_27[2]
		end

		if pg.ship_data_template[arg0_27[1]].group_type == arg0_24.shipVO.groupId then
			var7_24 = pg.ship_data_statistics[arg0_27[2]].type
		end
	end)

	if var7_24 then
		local var8_24 = cloneTplTo(arg0_24.attrTplD, arg0_24.attrContainer)

		setText(var8_24:Find("name"), i18n("common_ship_type"))
		setText(var8_24:Find("value"), ShipType.Type2Name(var7_24))

		local var9_24 = var8_24:Find("quest")

		setActive(var9_24, true)
		onButton(arg0_24, var8_24, function()
			arg0_24:showToolTip(arg1_24)
		end)
	else
		local var10_24 = _.reduce(var1_24.effect, {}, function(arg0_29, arg1_29)
			for iter0_29, iter1_29 in pairs(arg1_29) do
				arg0_29[iter0_29] = (arg0_29[iter0_29] or 0) + iter1_29
			end

			return arg0_29
		end)
		local var11_24 = arg0_24.shipVO:getShipProperties()

		for iter3_24, iter4_24 in pairs(var11_24) do
			if var10_24[iter3_24] then
				local var12_24 = cloneTplTo(arg0_24.attrTplD, arg0_24.attrContainer)

				arg0_24:updateAttrTF_D(var12_24, {
					attrName = AttributeType.Type2Name(iter3_24),
					value = math.floor(iter4_24),
					addition = var10_24[iter3_24]
				})
			end
		end

		local var13_24 = pg.ship_data_template[arg0_24.shipVO.configId]

		for iter5_24 = 1, 3 do
			if var10_24["equipment_proficiency_" .. iter5_24] then
				local var14_24 = EquipType.Types2Title(iter5_24, arg0_24.shipVO.configId)
				local var15_24 = EquipType.LabelToName(var14_24) .. i18n("common_proficiency")
				local var16_24 = cloneTplTo(arg0_24.attrTplD, arg0_24.attrContainer)

				arg0_24:updateAttrTF_D(var16_24, {
					attrName = var15_24,
					value = arg0_24.shipVO:getEquipProficiencyByPos(iter5_24) * 100,
					addition = var10_24["equipment_proficiency_" .. iter5_24] * 100
				}, true)
			end
		end
	end

	setActive(arg0_24.confirmBtn, false)
	setActive(arg0_24.inactiveBtn, false)
	setActive(arg0_24.completedteBtn, arg0_24:isFinished(arg1_24))

	arg0_24.contextData.transformId = arg1_24
end

function var0_0.updateProgress(arg0_30, arg1_30)
	local var0_30 = arg0_30:getTransformLevel(arg1_30) + 1

	arg0_30.curtransformId = arg1_30

	local var1_30 = pg.transform_data_template[arg1_30]

	arg0_30.infoName.text = var1_30.name

	local var2_30, var3_30 = arg0_30:canRemould(arg1_30)
	local var4_30 = var1_30.effect[var0_30] or {}

	setActive(arg0_30.shipTF, false)
	setText(arg0_30.skillDesc, "")

	local var5_30

	if var1_30.use_item[var0_30] then
		var5_30 = Clone(var1_30.use_item[var0_30])
	else
		var5_30 = {}
	end

	if var1_30.use_gold > 0 then
		table.insert(var5_30, {
			id2ItemId(PlayerConst.ResGold),
			var1_30.use_gold
		})
	end

	setActive(arg0_30.shipTF, var1_30.use_ship ~= 0)

	if var1_30.use_ship ~= 0 then
		local var6_30 = arg0_30.contextData.materialShipIds
		local var7_30 = var6_30 and table.getCount(var6_30) ~= 0

		setActive(arg0_30.shipTF:Find("IconTpl"), var7_30)
		setActive(arg0_30.shipTF:Find("addTF"), not var7_30)

		if var7_30 then
			updateDrop(arg0_30.shipTF:Find("IconTpl"), {
				id = getProxy(BayProxy):getShipById(var6_30[1]).configId,
				type = DROP_TYPE_SHIP
			})
		end

		onButton(arg0_30, arg0_30.shipTF, function()
			if var2_30 then
				arg0_30:emit(ShipRemouldMediator.ON_SELECTE_SHIP, arg0_30.shipVO)
			else
				pg.TipsMgr.GetInstance():ShowTips(var3_30)
			end
		end, SFX_PANEL)
	else
		arg0_30.contextData.materialShipIds = nil
	end

	setActive(arg0_30.skillDesc.parent, var1_30.skill_id ~= 0)

	if var1_30.skill_id ~= 0 then
		local var8_30 = pg.skill_data_template[var1_30.skill_id].name

		setText(arg0_30.skillDesc, i18n("ship_remould_material_unlock_skill", var8_30))
	end

	for iter0_30 = arg0_30.itemContainer.childCount, #var5_30 - 1 do
		cloneTplTo(arg0_30.itemTF, arg0_30.itemContainer)
	end

	local var9_30 = arg0_30.itemContainer.childCount

	for iter1_30 = 1, var9_30 do
		local var10_30 = arg0_30.itemContainer:GetChild(iter1_30 - 1)

		setActive(var10_30, iter1_30 <= #var5_30)

		if iter1_30 <= #var5_30 then
			local var11_30 = var5_30[iter1_30]
			local var12_30 = ""

			if var11_30[1] == id2ItemId(PlayerConst.ResGold) then
				local var13_30 = arg0_30.playerVO.gold >= var11_30[2]

				var12_30 = setColorStr(var11_30[2], var13_30 and COLOR_WHITE or COLOR_RED)

				if var13_30 then
					RemoveComponent(var10_30, typeof(Button))
				else
					onButton(arg0_30, var10_30, function()
						ItemTipPanel.ShowGoldBuyTip(var11_30[2])
					end)

					var10_30:GetComponent(typeof(Button)).targetGraphic = var10_30:Find("IconTpl/icon_bg/icon"):GetComponent(typeof(Image))
				end
			else
				local var14_30 = arg0_30:getItemCount(var11_30[1]) >= var11_30[2]

				var12_30 = setColorStr(arg0_30:getItemCount(var11_30[1]), var14_30 and COLOR_WHITE or COLOR_RED)
				var12_30 = var12_30 .. "/" .. var11_30[2]

				if var14_30 or not ItemTipPanel.CanShowTip(var11_30[1]) then
					RemoveComponent(var10_30, typeof(Button))
				else
					onButton(arg0_30, var10_30, function()
						ItemTipPanel.ShowItemTipbyID(var11_30[1])
					end)

					var10_30:GetComponent(typeof(Button)).targetGraphic = var10_30:Find("IconTpl/icon_bg/icon"):GetComponent(typeof(Image))
				end
			end

			updateDrop(var10_30:Find("IconTpl"), {
				id = var11_30[1],
				type = DROP_TYPE_ITEM,
				count = var12_30
			})
		end
	end

	removeAllChildren(arg0_30.attrContainer)

	local var15_30
	local var16_30

	_.each(var1_30.ship_id, function(arg0_34)
		if arg0_34[1] == arg0_30.shipVO.configId then
			var15_30 = arg0_34[2]
		end

		if pg.ship_data_template[arg0_34[1]].group_type == arg0_30.shipVO.groupId then
			var16_30 = pg.ship_data_statistics[arg0_34[2]].type
		end
	end)

	if var16_30 then
		local var17_30 = cloneTplTo(arg0_30.attrTpl, arg0_30.attrContainer)

		setText(var17_30:Find("name"), i18n("common_ship_type"))
		setText(var17_30:Find("pre_value"), ShipType.Type2Name(arg0_30.shipVO:getShipType()))
		setText(var17_30:Find("value"), ShipType.Type2Name(var16_30))
		setActive(var17_30:Find("addtion"), false)

		local var18_30 = var17_30:Find("quest")

		if var15_30 then
			setActive(var18_30, true)
			onButton(arg0_30, var17_30, function()
				arg0_30:showToolTip(arg1_30)
			end)
		else
			setActive(var18_30, false)
		end
	else
		local var19_30 = arg0_30.shipVO:getShipProperties()

		for iter2_30, iter3_30 in pairs(var19_30) do
			if var4_30[iter2_30] then
				local var20_30 = cloneTplTo(arg0_30.attrTpl, arg0_30.attrContainer)

				arg0_30:updateAttrTF(var20_30, {
					attrName = AttributeType.Type2Name(iter2_30),
					value = math.floor(iter3_30),
					addition = var4_30[iter2_30]
				})
			end
		end

		local var21_30 = pg.ship_data_template[arg0_30.shipVO.configId]

		for iter4_30 = 1, 3 do
			if var4_30["equipment_proficiency_" .. iter4_30] then
				local var22_30 = EquipType.Types2Title(iter4_30, arg0_30.shipVO.configId)
				local var23_30 = EquipType.LabelToName(var22_30) .. i18n("common_proficiency")
				local var24_30 = cloneTplTo(arg0_30.attrTpl, arg0_30.attrContainer)

				arg0_30:updateAttrTF(var24_30, {
					attrName = var23_30,
					value = arg0_30.shipVO:getEquipProficiencyByPos(iter4_30) * 100,
					addition = var4_30["equipment_proficiency_" .. iter4_30] * 100
				}, true)
			end
		end
	end

	local var25_30 = arg0_30:isEnoughResource(arg1_30)

	setActive(arg0_30.confirmBtn, var2_30 and var25_30)
	setActive(arg0_30.inactiveBtn, not var2_30 or not var25_30)
	setActive(arg0_30.completedteBtn, false)
	onButton(arg0_30, arg0_30.confirmBtn, function()
		local var0_36, var1_36 = ShipStatus.ShipStatusCheck("onModify", arg0_30.shipVO)

		if not var0_36 then
			pg.TipsMgr.GetInstance():ShowTips(var1_36)

			return
		end

		local var2_36, var3_36 = arg0_30:canRemould(arg1_30)

		if not var2_36 then
			pg.TipsMgr.GetInstance():ShowTips(var3_36)

			return
		end

		local var4_36, var5_36 = arg0_30:isEnoughResource(arg1_30)

		if not var4_36 then
			pg.TipsMgr.GetInstance():ShowTips(var5_36)

			return
		end

		if var15_30 then
			local var6_36 = pg.MsgboxMgr.GetInstance()

			var6_36:ShowMsgBox({
				modal = true,
				content = i18n("ship_remould_warning_" .. var15_30, arg0_30.shipVO:getName()),
				onYes = function()
					arg0_30:emit(ShipRemouldMediator.REMOULD_SHIP, arg0_30.shipVO.id, arg1_30)
				end
			})
			var6_36.contentText:AddListener(function(arg0_38, arg1_38)
				if arg0_38 == "clickDetail" then
					arg0_30:showToolTip(arg1_30)
				end
			end)
		else
			arg0_30:emit(ShipRemouldMediator.REMOULD_SHIP, arg0_30.shipVO.id, arg1_30)
		end
	end, SFX_CONFIRM)

	arg0_30.contextData.transformId = arg1_30
end

function var0_0.isUnlock(arg0_39, arg1_39)
	if not arg0_39:isUnLockPrev(arg1_39) then
		return false
	end

	if arg0_39:getLevelById(arg1_39) > arg0_39.shipVO.level then
		return false
	end

	if not arg0_39:isReachStar(arg1_39) then
		return false
	end

	return true
end

function var0_0.isFinished(arg0_40, arg1_40)
	local var0_40 = pg.transform_data_template[arg1_40]
	local var1_40 = arg0_40:getTransformLevel(arg1_40)

	if var0_40.max_level == var1_40 then
		return true
	end

	return false
end

function var0_0.isReachStar(arg0_41, arg1_41)
	local var0_41 = pg.transform_data_template[arg1_41]

	return arg0_41.shipVO:getStar() >= var0_41.star_limit
end

function var0_0.canRemould(arg0_42, arg1_42)
	if not arg0_42:isUnLockPrev(arg1_42) then
		return false, i18n("ship_remould_prev_lock"), {
			1
		}
	end

	local var0_42 = pg.transform_data_template[arg1_42]

	if arg0_42:getLevelById(arg1_42) > arg0_42.shipVO.level then
		return false, i18n("ship_remould_need_level", var0_42.level_limit), {
			2,
			var0_42.level_limit
		}
	end

	if not arg0_42:isReachStar(arg1_42) then
		return false, i18n("ship_remould_need_star", var0_42.star_limit), {
			3,
			var0_42.star_limit
		}
	end

	if arg0_42:isFinished(arg1_42) then
		return false, i18n("ship_remould_finished"), {
			4
		}
	end

	return true
end

function var0_0.isUnLockPrev(arg0_43, arg1_43)
	local var0_43 = pg.transform_data_template[arg1_43]

	for iter0_43, iter1_43 in pairs(var0_43.condition_id) do
		local var1_43 = pg.transform_data_template[iter1_43]

		if not arg0_43.shipVO.transforms[iter1_43] or arg0_43.shipVO.transforms[iter1_43].level ~= var1_43.max_level then
			return false
		end
	end

	return true
end

function var0_0.isEnoughResource(arg0_44, arg1_44)
	local var0_44 = pg.transform_data_template[arg1_44]
	local var1_44 = arg0_44:getTransformLevel(arg1_44) + 1

	for iter0_44, iter1_44 in ipairs(var0_44.use_item[var1_44] or {}) do
		if not arg0_44.itemsVO[iter1_44[1]] or arg0_44.itemsVO[iter1_44[1]].count < iter1_44[2] then
			return false, i18n("ship_remould_no_item")
		end
	end

	if arg0_44.playerVO.gold < var0_44.use_gold then
		return false, i18n("ship_remould_no_gold")
	end

	if var0_44.use_ship ~= 0 and (not arg0_44.contextData.materialShipIds or #arg0_44.contextData.materialShipIds ~= var0_44.use_ship) then
		return false, i18n("ship_remould_no_material")
	end

	return true
end

function var0_0.updateAttrTF(arg0_45, arg1_45, arg2_45, arg3_45)
	local var0_45 = arg3_45 and "%" or ""

	setText(arg1_45:Find("name"), arg2_45.attrName)
	setText(arg1_45:Find("pre_value"), arg2_45.value .. var0_45)
	setText(arg1_45:Find("value"), arg2_45.addition + arg2_45.value .. var0_45)
	setText(arg1_45:Find("addtion"), (arg2_45.addition > 0 and "+" .. arg2_45.addition or arg2_45.addition) .. var0_45)
end

function var0_0.updateAttrTF_D(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = arg3_46 and "%" or ""

	setText(arg1_46:Find("name"), arg2_46.attrName)
	setText(arg1_46:Find("value"), (arg2_46.addition > 0 and "+" .. arg2_46.addition or arg2_46.addition) .. var0_46)
end

function var0_0.showToolTip(arg0_47, arg1_47)
	if not arg0_47.shipVO then
		return
	end

	local var0_47 = pg.transform_data_template[arg1_47]
	local var1_47 = arg0_47:isFinished(arg1_47)

	setActive(findTF(arg0_47.tooltip, "window/scrollview/list/attrs"), not var1_47)

	if not var1_47 then
		local var2_47 = Clone(arg0_47.shipVO)

		_.each(var0_47.ship_id, function(arg0_48)
			if arg0_48[1] == arg0_47.shipVO.configId then
				var2_47.configId = arg0_48[2]
			end
		end)

		var2_47.transforms[arg1_47] = {
			level = 1,
			id = arg1_47
		}

		local var3_47 = {}

		table.insert(var3_47, {
			name = i18n("common_ship_type"),
			from = ShipType.Type2Name(arg0_47.shipVO:getShipType()),
			to = ShipType.Type2Name(var2_47:getShipType())
		})
		table.insert(var3_47, {
			name = i18n("attribute_armor_type"),
			from = arg0_47.shipVO:getShipArmorName(),
			to = var2_47:getShipArmorName()
		})

		local var4_47 = {
			AttributeType.Durability,
			AttributeType.Cannon,
			AttributeType.Torpedo,
			AttributeType.AntiAircraft,
			AttributeType.Air,
			AttributeType.Reload,
			AttributeType.Hit,
			AttributeType.Expend,
			AttributeType.Dodge,
			AttributeType.AntiSub
		}
		local var5_47 = arg0_47.shipVO:getShipProperties()
		local var6_47 = var2_47:getShipProperties()

		for iter0_47, iter1_47 in ipairs(var4_47) do
			local var7_47 = {}

			if iter1_47 == AttributeType.Expend then
				var7_47.name = AttributeType.Type2Name(iter1_47)
				var7_47.from = arg0_47.shipVO:getBattleTotalExpend()
				var7_47.to = var2_47:getBattleTotalExpend()
			else
				var7_47.name = AttributeType.Type2Name(iter1_47)
				var7_47.from = math.floor(var5_47[iter1_47])
				var7_47.to = math.floor(var6_47[iter1_47])
			end

			var7_47.add = var7_47.to - var7_47.from

			table.insert(var3_47, var7_47)
		end

		local var8_47 = UIItemList.New(findTF(arg0_47.tooltip, "window/scrollview/list/attrs"), findTF(arg0_47.tooltip, "window/scrollview/list/attrs/attr"))

		var8_47:make(function(arg0_49, arg1_49, arg2_49)
			if arg0_49 == UIItemList.EventUpdate then
				local var0_49 = var3_47[arg1_49 + 1]

				setText(arg2_49:Find("name"), var0_49.name)
				setText(arg2_49:Find("pre_value"), var0_49.from)

				local var1_49 = arg2_49:Find("addtion")
				local var2_49 = "#A9F548"

				if var0_49.add and var0_49.from ~= var0_49.to then
					setActive(var1_49, true)

					if var0_49.from > var0_49.to then
						var2_49 = "#FF3333"
					end

					local var3_49 = var0_49.from < var0_49.to and "+" or ""

					setText(var1_49, string.format("<color=%s>[%s%s]</color>", var2_49, var3_49, var0_49.add))
					setText(arg2_49:Find("value"), string.format("<color=%s>%s</color>", var2_49, var0_49.to))
				else
					setActive(var1_49, false)
					setText(arg2_49:Find("value"), string.format("<color=%s>%s</color>", var2_49, var0_49.to))
				end
			end
		end)
		var8_47:align(#var3_47)
	end

	setText(findTF(arg0_47.tooltip, "window/scrollview/list/content/"), var0_47.descrip)
	onButton(arg0_47, findTF(arg0_47.tooltip, "window/top/btnBack"), function()
		arg0_47:closeTip()
	end, SFX_CANCEL)
	onButton(arg0_47, arg0_47.tooltip, function()
		arg0_47:closeTip()
	end, SFX_CANCEL)
	setActive(arg0_47.tooltip, true)
	arg0_47:OverlayPanel(arg0_47.tooltip)
end

function var0_0.closeTip(arg0_52)
	setActive(arg0_52.tooltip, false)
	arg0_52:UnOverlayPanel(arg0_52.tooltip, arg0_52._tf)
end

function var0_0.willExit(arg0_53)
	if arg0_53.helpBtn then
		setActive(arg0_53.helpBtn, true)
	end

	arg0_53:UnOverlayPanel(arg0_53.tooltip, arg0_53._tf)
end

function var0_0.onBackPressed(arg0_54)
	if isActive(arg0_54.tooltip) then
		arg0_54:closeTip()

		return
	end

	arg0_54:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0_0
