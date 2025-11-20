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

function var0_0.init(arg0_3)
	arg0_3.container = arg0_3._tf:Find("main/bg/container")
	arg0_3.gridContainer = arg0_3.container:Find("grids")
	arg0_3.gridTF = arg0_3.gridContainer:Find("grid_tpl")
	arg0_3.height = arg0_3.gridTF.sizeDelta.y + var5_0
	arg0_3.width = arg0_3.gridTF.sizeDelta.x + var4_0
	arg0_3.startPos = Vector2(-1 * ((var2_0 / 2 - 0.5) * arg0_3.width) + var6_0.x, (var1_0 / 2 - 0.5) * arg0_3.height + var6_0.y)
	arg0_3.containerWidth = var2_0 * arg0_3.gridTF.sizeDelta.x + (var2_0 - 1) * var4_0
	arg0_3.containerHeight = var1_0 * arg0_3.gridTF.sizeDelta.y + (var1_0 - 1) * var5_0
	arg0_3.container.sizeDelta = Vector2(arg0_3.containerWidth, arg0_3.containerHeight)

	setActive(arg0_3.gridTF, false)

	arg0_3.infoPanel = arg0_3._tf:Find("main/info_panel")
	arg0_3.itemContainer = arg0_3.infoPanel:Find("usages/items")
	arg0_3.itemTF = arg0_3.itemContainer:Find("itemTF")
	arg0_3.infoName = arg0_3.infoPanel:Find("name_container/Text"):GetComponent(typeof(Text))
	arg0_3.attrContainer = arg0_3.infoPanel:Find("align/attrs")
	arg0_3.attrTpl = arg0_3:getTpl("attr", arg0_3.attrContainer)
	arg0_3.attrTplD = arg0_3:getTpl("attrd", arg0_3.attrContainer)
	arg0_3.confirmBtn = arg0_3.infoPanel:Find("confirm_btn/activity")
	arg0_3.inactiveBtn = arg0_3.infoPanel:Find("confirm_btn/inactivity")
	arg0_3.completedteBtn = arg0_3.infoPanel:Find("confirm_btn/complete")
	arg0_3.shipTF = arg0_3._tf:Find("main/info_panel/usages/shipTF")
	arg0_3.skillDesc = arg0_3.infoPanel:Find("align/skill_desc/text")
	arg0_3.shipContainer = arg0_3.infoPanel:Find("char_container")
	arg0_3.lineTpl = arg0_3._tf:Find("resources/line")
	arg0_3.lineContainer = arg0_3.container:Find("grids/lines")
	arg0_3.helpBtn = GameObject.Find("/OverlayCamera/Overlay/UIMain/common/help_btn")

	if not IsNil(arg0_3.helpBtn) then
		setActive(arg0_3.helpBtn, false)
	end

	arg0_3.tooltip = arg0_3._tf:Find("tooltip")

	setActive(arg0_3.tooltip, false)
end

function var0_0.setPlayer(arg0_4, arg1_4)
	arg0_4.playerVO = arg1_4

	if arg0_4.curtransformId then
		arg0_4:updateInfo(arg0_4.curtransformId)
	end
end

function var0_0.setItems(arg0_5, arg1_5)
	arg0_5.itemsVO = arg1_5
end

function var0_0.getItemCount(arg0_6, arg1_6)
	return (arg0_6.itemsVO[arg1_6] or Item.New({
		count = 0,
		id = arg1_6
	})).count
end

function var0_0.setShipVO(arg0_7, arg1_7)
	arg0_7.shipVO = arg1_7
	arg0_7.shipGroupId = math.floor(arg0_7.shipVO:getGroupId())
end

function var0_0.getShipTranformData(arg0_8)
	local var0_8 = pg.ship_data_trans[arg0_8.shipGroupId]

	assert(var0_8, "config missed [pg.ship_data_trans] shipGroup>>>." .. arg0_8.shipGroupId)

	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(var0_8.transform_list) do
		for iter2_8, iter3_8 in ipairs(iter1_8) do
			var1_8[iter3_8[2]] = Vector2(iter0_8, iter3_8[1])
		end
	end

	return var1_8
end

function var0_0.didEnter(arg0_9)
	arg0_9:initTranformInfo()
	arg0_9:initShipModel()
end

function var0_0.initTranformInfo(arg0_10)
	arg0_10.transformIds = arg0_10:getShipTranformData()
	arg0_10.grids = {}

	for iter0_10, iter1_10 in pairs(arg0_10.transformIds) do
		local var0_10 = cloneTplTo(arg0_10.gridTF, arg0_10.gridContainer)

		go(var0_10).name = iter0_10
		var0_10.localPosition = Vector2(arg0_10.startPos.x + arg0_10.width * (iter1_10.x - 1), arg0_10.startPos.y - arg0_10.height * (iter1_10.y - 1))

		onToggle(arg0_10, var0_10, function(arg0_11)
			if arg0_11 and arg0_10.curtransformId ~= iter0_10 then
				arg0_10:updateInfo(iter0_10)
			end
		end, SFX_PANEL)

		arg0_10.grids[iter0_10] = var0_10
	end

	arg0_10.lineTFs = {}

	for iter2_10, iter3_10 in pairs(arg0_10.transformIds) do
		arg0_10:initLines(iter2_10)
	end

	arg0_10.posTransId = {}

	arg0_10:updateLines()

	if arg0_10.contextData.transformId then
		assert(arg0_10.grids[arg0_10.contextData.transformId], "without this transform id:" .. arg0_10.contextData.transformId)
		triggerToggle(arg0_10.grids[arg0_10.contextData.transformId], true)
	end
end

function var0_0.initLines(arg0_12, arg1_12)
	local var0_12 = 270
	local var1_12 = 75

	arg0_12.lineTFs[arg1_12] = {}

	local var2_12 = arg0_12.transformIds[arg1_12].x
	local var3_12 = arg0_12.transformIds[arg1_12].y
	local var4_12 = arg0_12.grids[arg1_12]
	local var5_12 = var4_12.sizeDelta
	local var6_12 = var4_12.localPosition
	local var7_12 = arg0_12.lineTpl
	local var8_12 = pg.transform_data_template[arg1_12].condition_id

	for iter0_12, iter1_12 in pairs(var8_12) do
		local var9_12 = arg0_12.transformIds[iter1_12].x
		local var10_12 = arg0_12.transformIds[iter1_12].y
		local var11_12 = Vector2(var9_12 - var2_12, var10_12 - var3_12)

		if var11_12 ~= Vector2.zero then
			local var12_12 = cloneTplTo(var7_12, arg0_12.lineContainer, var2_12 .. "-" .. var3_12 .. "-v")
			local var13_12 = cloneTplTo(var7_12, arg0_12.lineContainer, var2_12 .. "-" .. var3_12 .. "-h")
			local var14_12 = var11_12.y < 0 and 90 or -90

			var12_12.eulerAngles = Vector3(0, 0, var14_12)

			local var15_12 = var11_12.x < 0 and 180 or 0

			var13_12.eulerAngles = Vector3(0, 0, var15_12)

			local var16_12 = math.abs(var11_12.y) > 0 and math.abs(var11_12.x) > 0

			if var16_12 then
				local var17_12 = var6_12.y + (var3_12 - var10_12) * var0_12

				var13_12.localPosition = Vector2(var6_12.x, var17_12, 0)

				local var18_12 = var11_12.y < 0 and var6_12.y + var5_12.y / 2 or var6_12.y - var5_12.y / 2

				var12_12.localPosition = Vector2(var6_12.x, var18_12)
				var13_12.sizeDelta = Vector2(math.abs(var11_12.x) * var0_12, var13_12.sizeDelta.y)
				var12_12.sizeDelta = Vector2(math.abs(var11_12.y) * var0_12 - var5_12.y / 2, var12_12.sizeDelta.y)

				local var19_12 = var11_12.x < 0 and var14_12 < 0 and -1 or 1

				var12_12:Find("corner").localScale = Vector3(1, var19_12, 1)
			else
				var13_12.sizeDelta = Vector2(math.abs(var11_12.x) * var0_12, var13_12.sizeDelta.y)
				var12_12.sizeDelta = Vector2(math.abs(var11_12.y) * var1_12, var12_12.sizeDelta.y)
				var13_12.localPosition = var6_12

				local var20_12 = var11_12.y < 0 and var6_12.y + var5_12.y / 2 or var6_12.y - var5_12.y / 2

				var12_12.localPosition = Vector3(var6_12.x, var20_12, 0)
			end

			setActive(var12_12:Find("arr"), var16_12 or math.abs(var11_12.y) > 0)
			setActive(var12_12:Find("corner"), var16_12)
			setActive(var13_12:Find("arr"), false)
			setActive(var13_12:Find("corner"), false)
			table.insert(arg0_12.lineTFs[arg1_12], {
				id = iter1_12,
				hrz = var13_12,
				vec = var12_12
			})
		end
	end
end

function var0_0.updateLines(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.transformIds) do
		arg0_13:updateGridTF(iter0_13)

		if arg0_13:canRemould(iter0_13) or arg0_13:isFinished(iter0_13) then
			for iter2_13, iter3_13 in ipairs(arg0_13.lineTFs[iter0_13] or {}) do
				iter3_13.hrz:GetComponent("UIGrayScale").enabled = false
				iter3_13.vec:GetComponent("UIGrayScale").enabled = false
			end
		end
	end
end

function var0_0.getLevelById(arg0_14, arg1_14)
	return pg.transform_data_template[arg1_14].level_limit
end

function var0_0.getTransformLevel(arg0_15, arg1_15)
	if not arg0_15.shipVO.transforms[arg1_15] then
		return 0
	else
		return arg0_15.shipVO.transforms[arg1_15].level
	end
end

var0_0.STATE_FINISHED = 1
var0_0.STATE_ACTIVE = 2
var0_0.STATE_LOCK = 3

function var0_0.getTransformState(arg0_16, arg1_16)
	if arg0_16:getTransformLevel(arg1_16) == pg.transform_data_template[arg1_16].max_level then
		return var0_0.STATE_FINISHED
	elseif arg0_16:canRemould(arg1_16) then
		return var0_0.STATE_ACTIVE
	else
		return var0_0.STATE_LOCK
	end
end

function var0_0.updateGridTF(arg0_17, arg1_17)
	local var0_17 = arg0_17.grids[arg1_17]
	local var1_17 = pg.transform_data_template[arg1_17]

	setText(var0_17:Find("name"), var1_17.name)

	local var2_17 = var0_17:Find("icon"):GetComponent(typeof(Image))

	GetSpriteFromAtlasAsync("modicon", var1_17.icon, function(arg0_18)
		if not IsNil(var2_17) then
			var2_17.sprite = arg0_18
		end
	end)

	local var3_17 = arg0_17:getTransformState(arg1_17)

	setActive(var0_17:Find("bgs/finished"), var3_17 == var0_0.STATE_FINISHED)
	setActive(var0_17:Find("bgs/ongoing"), var3_17 == var0_0.STATE_ACTIVE)
	setActive(var0_17:Find("bgs/lock"), var3_17 == var0_0.STATE_LOCK)
	setActive(var0_17:Find("tags/finished"), var3_17 == var0_0.STATE_FINISHED)
	setActive(var0_17:Find("tags/ongoing"), var3_17 == var0_0.STATE_ACTIVE)
	setActive(var0_17:Find("tags/lock"), var3_17 == var0_0.STATE_LOCK)

	local var4_17 = arg0_17:getTransformLevel(arg1_17)
	local var5_17 = var0_17:Find("icon/progress")

	if var3_17 == var0_0.STATE_FINISHED then
		setText(var5_17, var4_17 .. "/" .. var1_17.max_level)
	elseif var3_17 == var0_0.STATE_ACTIVE then
		setText(var5_17, var4_17 .. "/" .. var1_17.max_level)
	elseif var3_17 == var0_0.STATE_LOCK then
		local var6_17, var7_17, var8_17 = arg0_17:canRemould(arg1_17)

		setText(var5_17, "")
		setActive(var0_17:Find("tags/lock/lock_prev"), var8_17 and var8_17[1] == 1)
		setActive(var0_17:Find("tags/lock/lock_level"), var8_17 and var8_17[1] == 2)
		setActive(var0_17:Find("tags/lock/lock_star"), var8_17 and var8_17[1] == 3)

		if var8_17 and var8_17[1] == 2 then
			setText(var0_17:Find("tags/lock/lock_level/Text"), var8_17[2])
		elseif var8_17 and var8_17[1] == 3 then
			setText(var0_17:Find("tags/lock/lock_star/Text"), var8_17[2])
		end
	end

	local var9_17 = arg0_17.transformIds[arg1_17].x .. "_" .. arg0_17.transformIds[arg1_17].y

	if not arg0_17.posTransId[var9_17] then
		arg0_17.posTransId[var9_17] = arg1_17
	elseif arg0_17.posTransId[var9_17] == arg1_17 then
		-- block empty
	elseif var3_17 == var0_0.STATE_ACTIVE or arg0_17:getTransformState(arg0_17.posTransId[var9_17]) ~= var0_0.STATE_ACTIVE and arg1_17 < arg0_17.posTransId[var9_17] then
		if arg0_17.posTransId[var9_17] == arg0_17.curtransformId then
			arg0_17.curtransformId = arg1_17
		end

		setActive(arg0_17.grids[arg0_17.posTransId[var9_17]], false)

		arg0_17.posTransId[var9_17] = arg1_17
	end

	setActive(var0_17, arg1_17 == arg0_17.posTransId[var9_17])

	if arg0_17.curtransformId == arg1_17 then
		arg0_17:updateInfo(arg1_17)
	end
end

function var0_0.initShipModel(arg0_19)
	local var0_19 = arg0_19.shipVO:getPrefab()

	if arg0_19.shipContainer.childCount ~= 0 then
		arg0_19.shipModel:Dispose()
	end

	local function var1_19(arg0_20)
		if not IsNil(arg0_19._tf) then
			arg0_19.shipModel = arg0_20

			arg0_20:SetLayer(Layer.UI)
			arg0_20:SetLocalScale(Vector3(var3_0, var3_0, 1))
			arg0_20:SetParent(arg0_19.shipContainer)
			arg0_20:SetLocalPosition(Vector2(0, 10))
			arg0_20:SetAction("stand2", 0)
		end
	end

	local var2_19 = SpineAnimChar.New()

	var2_19:SetPaint(var0_19)
	var2_19:Load(true, function(arg0_21)
		var1_19(arg0_21)
	end)
end

function var0_0.updateInfo(arg0_22, arg1_22)
	if arg0_22:isFinished(arg1_22) then
		arg0_22:updateFinished(arg1_22)
	else
		arg0_22:updateProgress(arg1_22)
	end
end

function var0_0.updateFinished(arg0_23, arg1_23)
	local var0_23 = arg0_23.shipVO.transforms[arg1_23].level

	arg0_23.curtransformId = arg1_23

	local var1_23 = pg.transform_data_template[arg1_23]

	arg0_23.infoName.text = var1_23.name

	local var2_23 = {}

	for iter0_23 = 1, var0_23 do
		_.each(var1_23.use_item[iter0_23], function(arg0_24)
			local var0_24 = _.detect(var2_23, function(arg0_25)
				return arg0_25.type == DROP_TYPE_ITEM and arg0_25.id == arg0_24[1]
			end)

			if not var0_24 then
				table.insert(var2_23, {
					type = DROP_TYPE_ITEM,
					id = arg0_24[1],
					count = arg0_24[2]
				})
			else
				var0_24.count = var0_24.count + arg0_24[2]
			end
		end)
	end

	table.insert(var2_23, {
		type = DROP_TYPE_ITEM,
		id = id2ItemId(PlayerConst.ResGold),
		count = var1_23.use_gold * var0_23
	})

	for iter1_23 = arg0_23.itemContainer.childCount, #var2_23 - 1 do
		cloneTplTo(arg0_23.itemTF, arg0_23.itemContainer)
	end

	local var3_23 = arg0_23.itemContainer.childCount

	for iter2_23 = 1, var3_23 do
		local var4_23 = arg0_23.itemContainer:GetChild(iter2_23 - 1)

		setActive(var4_23, iter2_23 <= #var2_23)

		if iter2_23 <= #var2_23 then
			updateDrop(var4_23:Find("IconTpl"), var2_23[iter2_23])
			RemoveComponent(var4_23, typeof(Button))
		end
	end

	setActive(arg0_23.shipTF, var1_23.use_ship > 0)

	if var1_23.use_ship > 0 then
		setActive(arg0_23.shipTF:Find("addTF"), false)
		setActive(arg0_23.shipTF:Find("IconTpl"), true)
		updateDrop(arg0_23.shipTF:Find("IconTpl"), {
			type = DROP_TYPE_SHIP,
			id = arg0_23.shipVO.configId
		})
		removeOnButton(arg0_23.shipTF)
	end

	setActive(arg0_23.skillDesc.parent, var1_23.skill_id ~= 0)

	if var1_23.skill_id ~= 0 then
		local var5_23 = pg.skill_data_template[var1_23.skill_id].name

		setText(arg0_23.skillDesc, i18n("ship_remould_material_unlock_skill", var5_23))
	end

	removeAllChildren(arg0_23.attrContainer)

	local var6_23
	local var7_23

	_.each(var1_23.ship_id, function(arg0_26)
		if arg0_26[1] == arg0_23.shipVO.configId then
			var6_23 = arg0_26[2]
		end

		if pg.ship_data_template[arg0_26[1]].group_type == arg0_23.shipVO.groupId then
			var7_23 = pg.ship_data_statistics[arg0_26[2]].type
		end
	end)

	if var7_23 then
		local var8_23 = cloneTplTo(arg0_23.attrTplD, arg0_23.attrContainer)

		setText(var8_23:Find("name"), i18n("common_ship_type"))
		setText(var8_23:Find("value"), ShipType.Type2Name(var7_23))

		local var9_23 = var8_23:Find("quest")

		setActive(var9_23, true)
		onButton(arg0_23, var8_23, function()
			arg0_23:showToolTip(arg1_23)
		end)
	else
		local var10_23 = _.reduce(var1_23.effect, {}, function(arg0_28, arg1_28)
			for iter0_28, iter1_28 in pairs(arg1_28) do
				arg0_28[iter0_28] = (arg0_28[iter0_28] or 0) + iter1_28
			end

			return arg0_28
		end)
		local var11_23 = arg0_23.shipVO:getShipProperties()

		for iter3_23, iter4_23 in pairs(var11_23) do
			if var10_23[iter3_23] then
				local var12_23 = cloneTplTo(arg0_23.attrTplD, arg0_23.attrContainer)

				arg0_23:updateAttrTF_D(var12_23, {
					attrName = AttributeType.Type2Name(iter3_23),
					value = math.floor(iter4_23),
					addition = var10_23[iter3_23]
				})
			end
		end

		local var13_23 = pg.ship_data_template[arg0_23.shipVO.configId]

		for iter5_23 = 1, 3 do
			if var10_23["equipment_proficiency_" .. iter5_23] then
				local var14_23 = EquipType.Types2Title(iter5_23, arg0_23.shipVO.configId)
				local var15_23 = EquipType.LabelToName(var14_23) .. i18n("common_proficiency")
				local var16_23 = cloneTplTo(arg0_23.attrTplD, arg0_23.attrContainer)

				arg0_23:updateAttrTF_D(var16_23, {
					attrName = var15_23,
					value = arg0_23.shipVO:getEquipProficiencyByPos(iter5_23) * 100,
					addition = var10_23["equipment_proficiency_" .. iter5_23] * 100
				}, true)
			end
		end
	end

	setActive(arg0_23.confirmBtn, false)
	setActive(arg0_23.inactiveBtn, false)
	setActive(arg0_23.completedteBtn, arg0_23:isFinished(arg1_23))

	arg0_23.contextData.transformId = arg1_23
end

function var0_0.updateProgress(arg0_29, arg1_29)
	local var0_29 = arg0_29:getTransformLevel(arg1_29) + 1

	arg0_29.curtransformId = arg1_29

	local var1_29 = pg.transform_data_template[arg1_29]

	arg0_29.infoName.text = var1_29.name

	local var2_29, var3_29 = arg0_29:canRemould(arg1_29)
	local var4_29 = var1_29.effect[var0_29] or {}

	setActive(arg0_29.shipTF, false)
	setText(arg0_29.skillDesc, "")

	local var5_29

	if var1_29.use_item[var0_29] then
		var5_29 = Clone(var1_29.use_item[var0_29])
	else
		var5_29 = {}
	end

	if var1_29.use_gold > 0 then
		table.insert(var5_29, {
			id2ItemId(PlayerConst.ResGold),
			var1_29.use_gold
		})
	end

	setActive(arg0_29.shipTF, var1_29.use_ship ~= 0)

	if var1_29.use_ship ~= 0 then
		local var6_29 = arg0_29.contextData.materialShipIds
		local var7_29 = var6_29 and table.getCount(var6_29) ~= 0

		setActive(arg0_29.shipTF:Find("IconTpl"), var7_29)
		setActive(arg0_29.shipTF:Find("addTF"), not var7_29)

		if var7_29 then
			updateDrop(arg0_29.shipTF:Find("IconTpl"), {
				id = getProxy(BayProxy):getShipById(var6_29[1]).configId,
				type = DROP_TYPE_SHIP
			})
		end

		onButton(arg0_29, arg0_29.shipTF, function()
			if var2_29 then
				arg0_29:emit(ShipRemouldMediator.ON_SELECTE_SHIP, arg0_29.shipVO)
			else
				pg.TipsMgr.GetInstance():ShowTips(var3_29)
			end
		end, SFX_PANEL)
	else
		arg0_29.contextData.materialShipIds = nil
	end

	setActive(arg0_29.skillDesc.parent, var1_29.skill_id ~= 0)

	if var1_29.skill_id ~= 0 then
		local var8_29 = pg.skill_data_template[var1_29.skill_id].name

		setText(arg0_29.skillDesc, i18n("ship_remould_material_unlock_skill", var8_29))
	end

	for iter0_29 = arg0_29.itemContainer.childCount, #var5_29 - 1 do
		cloneTplTo(arg0_29.itemTF, arg0_29.itemContainer)
	end

	local var9_29 = arg0_29.itemContainer.childCount

	for iter1_29 = 1, var9_29 do
		local var10_29 = arg0_29.itemContainer:GetChild(iter1_29 - 1)

		setActive(var10_29, iter1_29 <= #var5_29)

		if iter1_29 <= #var5_29 then
			local var11_29 = var5_29[iter1_29]
			local var12_29 = ""

			if var11_29[1] == id2ItemId(PlayerConst.ResGold) then
				local var13_29 = arg0_29.playerVO.gold >= var11_29[2]

				var12_29 = setColorStr(var11_29[2], var13_29 and COLOR_WHITE or COLOR_RED)

				if var13_29 then
					RemoveComponent(var10_29, typeof(Button))
				else
					onButton(arg0_29, var10_29, function()
						ItemTipPanel.ShowGoldBuyTip(var11_29[2])
					end)

					var10_29:GetComponent(typeof(Button)).targetGraphic = var10_29:Find("IconTpl/icon_bg/icon"):GetComponent(typeof(Image))
				end
			else
				local var14_29 = arg0_29:getItemCount(var11_29[1]) >= var11_29[2]

				var12_29 = setColorStr(arg0_29:getItemCount(var11_29[1]), var14_29 and COLOR_WHITE or COLOR_RED)
				var12_29 = var12_29 .. "/" .. var11_29[2]

				if var14_29 or not ItemTipPanel.CanShowTip(var11_29[1]) then
					RemoveComponent(var10_29, typeof(Button))
				else
					onButton(arg0_29, var10_29, function()
						ItemTipPanel.ShowItemTipbyID(var11_29[1])
					end)

					var10_29:GetComponent(typeof(Button)).targetGraphic = var10_29:Find("IconTpl/icon_bg/icon"):GetComponent(typeof(Image))
				end
			end

			updateDrop(var10_29:Find("IconTpl"), {
				id = var11_29[1],
				type = DROP_TYPE_ITEM,
				count = var12_29
			})
		end
	end

	removeAllChildren(arg0_29.attrContainer)

	local var15_29
	local var16_29

	_.each(var1_29.ship_id, function(arg0_33)
		if arg0_33[1] == arg0_29.shipVO.configId then
			var15_29 = arg0_33[2]
		end

		if pg.ship_data_template[arg0_33[1]].group_type == arg0_29.shipVO.groupId then
			var16_29 = pg.ship_data_statistics[arg0_33[2]].type
		end
	end)

	if var16_29 then
		local var17_29 = cloneTplTo(arg0_29.attrTpl, arg0_29.attrContainer)

		setText(var17_29:Find("name"), i18n("common_ship_type"))
		setText(var17_29:Find("pre_value"), ShipType.Type2Name(arg0_29.shipVO:getShipType()))
		setText(var17_29:Find("value"), ShipType.Type2Name(var16_29))
		setActive(var17_29:Find("addtion"), false)

		local var18_29 = var17_29:Find("quest")

		if var15_29 then
			setActive(var18_29, true)
			onButton(arg0_29, var17_29, function()
				arg0_29:showToolTip(arg1_29)
			end)
		else
			setActive(var18_29, false)
		end
	else
		local var19_29 = arg0_29.shipVO:getShipProperties()

		for iter2_29, iter3_29 in pairs(var19_29) do
			if var4_29[iter2_29] then
				local var20_29 = cloneTplTo(arg0_29.attrTpl, arg0_29.attrContainer)

				arg0_29:updateAttrTF(var20_29, {
					attrName = AttributeType.Type2Name(iter2_29),
					value = math.floor(iter3_29),
					addition = var4_29[iter2_29]
				})
			end
		end

		local var21_29 = pg.ship_data_template[arg0_29.shipVO.configId]

		for iter4_29 = 1, 3 do
			if var4_29["equipment_proficiency_" .. iter4_29] then
				local var22_29 = EquipType.Types2Title(iter4_29, arg0_29.shipVO.configId)
				local var23_29 = EquipType.LabelToName(var22_29) .. i18n("common_proficiency")
				local var24_29 = cloneTplTo(arg0_29.attrTpl, arg0_29.attrContainer)

				arg0_29:updateAttrTF(var24_29, {
					attrName = var23_29,
					value = arg0_29.shipVO:getEquipProficiencyByPos(iter4_29) * 100,
					addition = var4_29["equipment_proficiency_" .. iter4_29] * 100
				}, true)
			end
		end
	end

	local var25_29 = arg0_29:isEnoughResource(arg1_29)

	setActive(arg0_29.confirmBtn, var2_29 and var25_29)
	setActive(arg0_29.inactiveBtn, not var2_29 or not var25_29)
	setActive(arg0_29.completedteBtn, false)
	onButton(arg0_29, arg0_29.confirmBtn, function()
		local var0_35, var1_35 = ShipStatus.ShipStatusCheck("onModify", arg0_29.shipVO)

		if not var0_35 then
			pg.TipsMgr.GetInstance():ShowTips(var1_35)

			return
		end

		local var2_35, var3_35 = arg0_29:canRemould(arg1_29)

		if not var2_35 then
			pg.TipsMgr.GetInstance():ShowTips(var3_35)

			return
		end

		local var4_35, var5_35 = arg0_29:isEnoughResource(arg1_29)

		if not var4_35 then
			pg.TipsMgr.GetInstance():ShowTips(var5_35)

			return
		end

		if var15_29 then
			local var6_35 = pg.MsgboxMgr.GetInstance()

			var6_35:ShowMsgBox({
				modal = true,
				content = i18n("ship_remould_warning_" .. var15_29, arg0_29.shipVO:getName()),
				onYes = function()
					arg0_29:emit(ShipRemouldMediator.REMOULD_SHIP, arg0_29.shipVO.id, arg1_29)
				end
			})
			var6_35.contentText:AddListener(function(arg0_37, arg1_37)
				if arg0_37 == "clickDetail" then
					arg0_29:showToolTip(arg1_29)
				end
			end)
		else
			arg0_29:emit(ShipRemouldMediator.REMOULD_SHIP, arg0_29.shipVO.id, arg1_29)
		end
	end, SFX_CONFIRM)

	arg0_29.contextData.transformId = arg1_29
end

function var0_0.isUnlock(arg0_38, arg1_38)
	if not arg0_38:isUnLockPrev(arg1_38) then
		return false
	end

	if arg0_38:getLevelById(arg1_38) > arg0_38.shipVO.level then
		return false
	end

	if not arg0_38:isReachStar(arg1_38) then
		return false
	end

	return true
end

function var0_0.isFinished(arg0_39, arg1_39)
	local var0_39 = pg.transform_data_template[arg1_39]
	local var1_39 = arg0_39:getTransformLevel(arg1_39)

	if var0_39.max_level == var1_39 then
		return true
	end

	return false
end

function var0_0.isReachStar(arg0_40, arg1_40)
	local var0_40 = pg.transform_data_template[arg1_40]

	return arg0_40.shipVO:getStar() >= var0_40.star_limit
end

function var0_0.canRemould(arg0_41, arg1_41)
	if not arg0_41:isUnLockPrev(arg1_41) then
		return false, i18n("ship_remould_prev_lock"), {
			1
		}
	end

	local var0_41 = pg.transform_data_template[arg1_41]

	if arg0_41:getLevelById(arg1_41) > arg0_41.shipVO.level then
		return false, i18n("ship_remould_need_level", var0_41.level_limit), {
			2,
			var0_41.level_limit
		}
	end

	if not arg0_41:isReachStar(arg1_41) then
		return false, i18n("ship_remould_need_star", var0_41.star_limit), {
			3,
			var0_41.star_limit
		}
	end

	if arg0_41:isFinished(arg1_41) then
		return false, i18n("ship_remould_finished"), {
			4
		}
	end

	return true
end

function var0_0.isUnLockPrev(arg0_42, arg1_42)
	local var0_42 = pg.transform_data_template[arg1_42]

	for iter0_42, iter1_42 in pairs(var0_42.condition_id) do
		local var1_42 = pg.transform_data_template[iter1_42]

		if not arg0_42.shipVO.transforms[iter1_42] or arg0_42.shipVO.transforms[iter1_42].level ~= var1_42.max_level then
			return false
		end
	end

	return true
end

function var0_0.isEnoughResource(arg0_43, arg1_43)
	local var0_43 = pg.transform_data_template[arg1_43]
	local var1_43 = arg0_43:getTransformLevel(arg1_43) + 1

	for iter0_43, iter1_43 in ipairs(var0_43.use_item[var1_43] or {}) do
		if not arg0_43.itemsVO[iter1_43[1]] or arg0_43.itemsVO[iter1_43[1]].count < iter1_43[2] then
			return false, i18n("ship_remould_no_item")
		end
	end

	if arg0_43.playerVO.gold < var0_43.use_gold then
		return false, i18n("ship_remould_no_gold")
	end

	if var0_43.use_ship ~= 0 and (not arg0_43.contextData.materialShipIds or #arg0_43.contextData.materialShipIds ~= var0_43.use_ship) then
		return false, i18n("ship_remould_no_material")
	end

	return true
end

function var0_0.updateAttrTF(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44 = arg3_44 and "%" or ""

	setText(arg1_44:Find("name"), arg2_44.attrName)
	setText(arg1_44:Find("pre_value"), arg2_44.value .. var0_44)
	setText(arg1_44:Find("value"), arg2_44.addition + arg2_44.value .. var0_44)
	setText(arg1_44:Find("addtion"), (arg2_44.addition > 0 and "+" .. arg2_44.addition or arg2_44.addition) .. var0_44)
end

function var0_0.updateAttrTF_D(arg0_45, arg1_45, arg2_45, arg3_45)
	local var0_45 = arg3_45 and "%" or ""

	setText(arg1_45:Find("name"), arg2_45.attrName)
	setText(arg1_45:Find("value"), (arg2_45.addition > 0 and "+" .. arg2_45.addition or arg2_45.addition) .. var0_45)
end

function var0_0.showToolTip(arg0_46, arg1_46)
	if not arg0_46.shipVO then
		return
	end

	local var0_46 = pg.transform_data_template[arg1_46]
	local var1_46 = arg0_46:isFinished(arg1_46)

	setActive(findTF(arg0_46.tooltip, "window/scrollview/list/attrs"), not var1_46)

	if not var1_46 then
		local var2_46 = Clone(arg0_46.shipVO)

		_.each(var0_46.ship_id, function(arg0_47)
			if arg0_47[1] == arg0_46.shipVO.configId then
				var2_46.configId = arg0_47[2]
			end
		end)

		var2_46.transforms[arg1_46] = {
			level = 1,
			id = arg1_46
		}

		local var3_46 = {}

		table.insert(var3_46, {
			name = i18n("common_ship_type"),
			from = ShipType.Type2Name(arg0_46.shipVO:getShipType()),
			to = ShipType.Type2Name(var2_46:getShipType())
		})
		table.insert(var3_46, {
			name = i18n("attribute_armor_type"),
			from = arg0_46.shipVO:getShipArmorName(),
			to = var2_46:getShipArmorName()
		})

		local var4_46 = {
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
		local var5_46 = arg0_46.shipVO:getShipProperties()
		local var6_46 = var2_46:getShipProperties()

		for iter0_46, iter1_46 in ipairs(var4_46) do
			local var7_46 = {}

			if iter1_46 == AttributeType.Expend then
				var7_46.name = AttributeType.Type2Name(iter1_46)
				var7_46.from = arg0_46.shipVO:getBattleTotalExpend()
				var7_46.to = var2_46:getBattleTotalExpend()
			else
				var7_46.name = AttributeType.Type2Name(iter1_46)
				var7_46.from = math.floor(var5_46[iter1_46])
				var7_46.to = math.floor(var6_46[iter1_46])
			end

			var7_46.add = var7_46.to - var7_46.from

			table.insert(var3_46, var7_46)
		end

		local var8_46 = UIItemList.New(findTF(arg0_46.tooltip, "window/scrollview/list/attrs"), findTF(arg0_46.tooltip, "window/scrollview/list/attrs/attr"))

		var8_46:make(function(arg0_48, arg1_48, arg2_48)
			if arg0_48 == UIItemList.EventUpdate then
				local var0_48 = var3_46[arg1_48 + 1]

				setText(arg2_48:Find("name"), var0_48.name)
				setText(arg2_48:Find("pre_value"), var0_48.from)

				local var1_48 = arg2_48:Find("addtion")
				local var2_48 = "#A9F548"

				if var0_48.add and var0_48.from ~= var0_48.to then
					setActive(var1_48, true)

					if var0_48.from > var0_48.to then
						var2_48 = "#FF3333"
					end

					local var3_48 = var0_48.from < var0_48.to and "+" or ""

					setText(var1_48, string.format("<color=%s>[%s%s]</color>", var2_48, var3_48, var0_48.add))
					setText(arg2_48:Find("value"), string.format("<color=%s>%s</color>", var2_48, var0_48.to))
				else
					setActive(var1_48, false)
					setText(arg2_48:Find("value"), string.format("<color=%s>%s</color>", var2_48, var0_48.to))
				end
			end
		end)
		var8_46:align(#var3_46)
	end

	setText(findTF(arg0_46.tooltip, "window/scrollview/list/content/"), var0_46.descrip)
	onButton(arg0_46, findTF(arg0_46.tooltip, "window/top/btnBack"), function()
		arg0_46:closeTip()
	end, SFX_CANCEL)
	onButton(arg0_46, arg0_46.tooltip, function()
		arg0_46:closeTip()
	end, SFX_CANCEL)
	setActive(arg0_46.tooltip, true)
	arg0_46:OverlayPanel(arg0_46.tooltip)
end

function var0_0.closeTip(arg0_51)
	setActive(arg0_51.tooltip, false)
	arg0_51:UnOverlayPanel(arg0_51.tooltip, arg0_51._tf)
end

function var0_0.willExit(arg0_52)
	if arg0_52.helpBtn then
		setActive(arg0_52.helpBtn, true)
	end

	arg0_52:UnOverlayPanel(arg0_52.tooltip, arg0_52._tf)
end

function var0_0.onBackPressed(arg0_53)
	if isActive(arg0_53.tooltip) then
		arg0_53:closeTip()

		return
	end

	arg0_53:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0_0
