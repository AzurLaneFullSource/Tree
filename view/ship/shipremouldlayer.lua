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

function var0_0.init(arg0_2)
	arg0_2.container = arg0_2:findTF("main/bg/container")
	arg0_2.gridContainer = arg0_2:findTF("grids", arg0_2.container)
	arg0_2.gridTF = arg0_2:findTF("grid_tpl", arg0_2.gridContainer)
	arg0_2.height = arg0_2.gridTF.sizeDelta.y + var5_0
	arg0_2.width = arg0_2.gridTF.sizeDelta.x + var4_0
	arg0_2.startPos = Vector2(-1 * ((var2_0 / 2 - 0.5) * arg0_2.width) + var6_0.x, (var1_0 / 2 - 0.5) * arg0_2.height + var6_0.y)
	arg0_2.containerWidth = var2_0 * arg0_2.gridTF.sizeDelta.x + (var2_0 - 1) * var4_0
	arg0_2.containerHeight = var1_0 * arg0_2.gridTF.sizeDelta.y + (var1_0 - 1) * var5_0
	arg0_2.container.sizeDelta = Vector2(arg0_2.containerWidth, arg0_2.containerHeight)

	setActive(arg0_2.gridTF, false)

	arg0_2.infoPanel = arg0_2:findTF("main/info_panel")
	arg0_2.itemContainer = arg0_2:findTF("usages/items", arg0_2.infoPanel)
	arg0_2.itemTF = arg0_2:findTF("itemTF", arg0_2.itemContainer)
	arg0_2.infoName = arg0_2:findTF("name_container/Text", arg0_2.infoPanel):GetComponent(typeof(Text))
	arg0_2.attrContainer = arg0_2:findTF("align/attrs", arg0_2.infoPanel)
	arg0_2.attrTpl = arg0_2:getTpl("attr", arg0_2.attrContainer)
	arg0_2.attrTplD = arg0_2:getTpl("attrd", arg0_2.attrContainer)
	arg0_2.confirmBtn = arg0_2:findTF("confirm_btn/activity", arg0_2.infoPanel)
	arg0_2.inactiveBtn = arg0_2:findTF("confirm_btn/inactivity", arg0_2.infoPanel)
	arg0_2.completedteBtn = arg0_2:findTF("confirm_btn/complete", arg0_2.infoPanel)
	arg0_2.shipTF = arg0_2:findTF("main/info_panel/usages/shipTF")
	arg0_2.skillDesc = arg0_2:findTF("align/skill_desc/text", arg0_2.infoPanel)
	arg0_2.shipContainer = arg0_2:findTF("char_container", arg0_2.infoPanel)
	arg0_2.lineTpl = arg0_2:findTF("resources/line")
	arg0_2.lineContainer = arg0_2:findTF("grids/lines", arg0_2.container)
	arg0_2.helpBtn = GameObject.Find("/OverlayCamera/Overlay/UIMain/common/help_btn")

	if not IsNil(arg0_2.helpBtn) then
		setActive(arg0_2.helpBtn, false)
	end

	arg0_2.tooltip = arg0_2:findTF("tooltip")

	setActive(arg0_2.tooltip, false)
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.playerVO = arg1_3

	if arg0_3.curtransformId then
		arg0_3:updateInfo(arg0_3.curtransformId)
	end
end

function var0_0.setItems(arg0_4, arg1_4)
	arg0_4.itemsVO = arg1_4
end

function var0_0.getItemCount(arg0_5, arg1_5)
	return (arg0_5.itemsVO[arg1_5] or Item.New({
		count = 0,
		id = arg1_5
	})).count
end

function var0_0.setShipVO(arg0_6, arg1_6)
	arg0_6.shipVO = arg1_6
	arg0_6.shipGroupId = math.floor(arg0_6.shipVO:getGroupId())
end

function var0_0.getShipTranformData(arg0_7)
	local var0_7 = pg.ship_data_trans[arg0_7.shipGroupId]

	assert(var0_7, "config missed [pg.ship_data_trans] shipGroup>>>." .. arg0_7.shipGroupId)

	local var1_7 = {}

	for iter0_7, iter1_7 in ipairs(var0_7.transform_list) do
		for iter2_7, iter3_7 in ipairs(iter1_7) do
			var1_7[iter3_7[2]] = Vector2(iter0_7, iter3_7[1])
		end
	end

	return var1_7
end

function var0_0.didEnter(arg0_8)
	arg0_8:initTranformInfo()
	arg0_8:initShipModel()
end

function var0_0.initTranformInfo(arg0_9)
	arg0_9.transformIds = arg0_9:getShipTranformData()
	arg0_9.grids = {}

	for iter0_9, iter1_9 in pairs(arg0_9.transformIds) do
		local var0_9 = cloneTplTo(arg0_9.gridTF, arg0_9.gridContainer)

		go(var0_9).name = iter0_9
		var0_9.localPosition = Vector2(arg0_9.startPos.x + arg0_9.width * (iter1_9.x - 1), arg0_9.startPos.y - arg0_9.height * (iter1_9.y - 1))

		onToggle(arg0_9, var0_9, function(arg0_10)
			if arg0_10 and arg0_9.curtransformId ~= iter0_9 then
				arg0_9:updateInfo(iter0_9)
			end
		end, SFX_PANEL)

		arg0_9.grids[iter0_9] = var0_9
	end

	arg0_9.lineTFs = {}

	for iter2_9, iter3_9 in pairs(arg0_9.transformIds) do
		arg0_9:initLines(iter2_9)
	end

	arg0_9.posTransId = {}

	arg0_9:updateLines()

	if arg0_9.contextData.transformId then
		assert(arg0_9.grids[arg0_9.contextData.transformId], "without this transform id:" .. arg0_9.contextData.transformId)
		triggerToggle(arg0_9.grids[arg0_9.contextData.transformId], true)
	end
end

function var0_0.initLines(arg0_11, arg1_11)
	local var0_11 = 270
	local var1_11 = 75

	arg0_11.lineTFs[arg1_11] = {}

	local var2_11 = arg0_11.transformIds[arg1_11].x
	local var3_11 = arg0_11.transformIds[arg1_11].y
	local var4_11 = arg0_11.grids[arg1_11]
	local var5_11 = var4_11.sizeDelta
	local var6_11 = var4_11.localPosition
	local var7_11 = arg0_11.lineTpl
	local var8_11 = pg.transform_data_template[arg1_11].condition_id

	for iter0_11, iter1_11 in pairs(var8_11) do
		local var9_11 = arg0_11.transformIds[iter1_11].x
		local var10_11 = arg0_11.transformIds[iter1_11].y
		local var11_11 = Vector2(var9_11 - var2_11, var10_11 - var3_11)

		if var11_11 ~= Vector2.zero then
			local var12_11 = cloneTplTo(var7_11, arg0_11.lineContainer, var2_11 .. "-" .. var3_11 .. "-v")
			local var13_11 = cloneTplTo(var7_11, arg0_11.lineContainer, var2_11 .. "-" .. var3_11 .. "-h")
			local var14_11 = var11_11.y < 0 and 90 or -90

			var12_11.eulerAngles = Vector3(0, 0, var14_11)

			local var15_11 = var11_11.x < 0 and 180 or 0

			var13_11.eulerAngles = Vector3(0, 0, var15_11)

			local var16_11 = math.abs(var11_11.y) > 0 and math.abs(var11_11.x) > 0

			if var16_11 then
				local var17_11 = var6_11.y + (var3_11 - var10_11) * var0_11

				var13_11.localPosition = Vector2(var6_11.x, var17_11, 0)

				local var18_11 = var11_11.y < 0 and var6_11.y + var5_11.y / 2 or var6_11.y - var5_11.y / 2

				var12_11.localPosition = Vector2(var6_11.x, var18_11)
				var13_11.sizeDelta = Vector2(math.abs(var11_11.x) * var0_11, var13_11.sizeDelta.y)
				var12_11.sizeDelta = Vector2(math.abs(var11_11.y) * var0_11 - var5_11.y / 2, var12_11.sizeDelta.y)

				local var19_11 = var11_11.x < 0 and var14_11 < 0 and -1 or 1

				var12_11:Find("corner").localScale = Vector3(1, var19_11, 1)
			else
				var13_11.sizeDelta = Vector2(math.abs(var11_11.x) * var0_11, var13_11.sizeDelta.y)
				var12_11.sizeDelta = Vector2(math.abs(var11_11.y) * var1_11, var12_11.sizeDelta.y)
				var13_11.localPosition = var6_11

				local var20_11 = var11_11.y < 0 and var6_11.y + var5_11.y / 2 or var6_11.y - var5_11.y / 2

				var12_11.localPosition = Vector3(var6_11.x, var20_11, 0)
			end

			setActive(var12_11:Find("arr"), var16_11 or math.abs(var11_11.y) > 0)
			setActive(var12_11:Find("corner"), var16_11)
			setActive(var13_11:Find("arr"), false)
			setActive(var13_11:Find("corner"), false)
			table.insert(arg0_11.lineTFs[arg1_11], {
				id = iter1_11,
				hrz = var13_11,
				vec = var12_11
			})
		end
	end
end

function var0_0.updateLines(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.transformIds) do
		arg0_12:updateGridTF(iter0_12)

		if arg0_12:canRemould(iter0_12) or arg0_12:isFinished(iter0_12) then
			for iter2_12, iter3_12 in ipairs(arg0_12.lineTFs[iter0_12] or {}) do
				iter3_12.hrz:GetComponent("UIGrayScale").enabled = false
				iter3_12.vec:GetComponent("UIGrayScale").enabled = false
			end
		end
	end
end

function var0_0.getLevelById(arg0_13, arg1_13)
	return pg.transform_data_template[arg1_13].level_limit
end

function var0_0.getTransformLevel(arg0_14, arg1_14)
	if not arg0_14.shipVO.transforms[arg1_14] then
		return 0
	else
		return arg0_14.shipVO.transforms[arg1_14].level
	end
end

var0_0.STATE_FINISHED = 1
var0_0.STATE_ACTIVE = 2
var0_0.STATE_LOCK = 3

function var0_0.getTransformState(arg0_15, arg1_15)
	if arg0_15:getTransformLevel(arg1_15) == pg.transform_data_template[arg1_15].max_level then
		return var0_0.STATE_FINISHED
	elseif arg0_15:canRemould(arg1_15) then
		return var0_0.STATE_ACTIVE
	else
		return var0_0.STATE_LOCK
	end
end

function var0_0.updateGridTF(arg0_16, arg1_16)
	local var0_16 = arg0_16.grids[arg1_16]
	local var1_16 = pg.transform_data_template[arg1_16]

	setText(var0_16:Find("name"), var1_16.name)

	local var2_16 = var0_16:Find("icon"):GetComponent(typeof(Image))

	GetSpriteFromAtlasAsync("modicon", var1_16.icon, function(arg0_17)
		if not IsNil(var2_16) then
			var2_16.sprite = arg0_17
		end
	end)

	local var3_16 = arg0_16:getTransformState(arg1_16)

	setActive(var0_16:Find("bgs/finished"), var3_16 == var0_0.STATE_FINISHED)
	setActive(var0_16:Find("bgs/ongoing"), var3_16 == var0_0.STATE_ACTIVE)
	setActive(var0_16:Find("bgs/lock"), var3_16 == var0_0.STATE_LOCK)
	setActive(var0_16:Find("tags/finished"), var3_16 == var0_0.STATE_FINISHED)
	setActive(var0_16:Find("tags/ongoing"), var3_16 == var0_0.STATE_ACTIVE)
	setActive(var0_16:Find("tags/lock"), var3_16 == var0_0.STATE_LOCK)

	local var4_16 = arg0_16:getTransformLevel(arg1_16)
	local var5_16 = var0_16:Find("icon/progress")

	if var3_16 == var0_0.STATE_FINISHED then
		setText(var5_16, var4_16 .. "/" .. var1_16.max_level)
	elseif var3_16 == var0_0.STATE_ACTIVE then
		setText(var5_16, var4_16 .. "/" .. var1_16.max_level)
	elseif var3_16 == var0_0.STATE_LOCK then
		local var6_16, var7_16, var8_16 = arg0_16:canRemould(arg1_16)

		setText(var5_16, "")
		setActive(var0_16:Find("tags/lock/lock_prev"), var8_16 and var8_16[1] == 1)
		setActive(var0_16:Find("tags/lock/lock_level"), var8_16 and var8_16[1] == 2)
		setActive(var0_16:Find("tags/lock/lock_star"), var8_16 and var8_16[1] == 3)

		if var8_16 and var8_16[1] == 2 then
			setText(var0_16:Find("tags/lock/lock_level/Text"), var8_16[2])
		elseif var8_16 and var8_16[1] == 3 then
			setText(var0_16:Find("tags/lock/lock_star/Text"), var8_16[2])
		end
	end

	local var9_16 = arg0_16.transformIds[arg1_16].x .. "_" .. arg0_16.transformIds[arg1_16].y

	if not arg0_16.posTransId[var9_16] then
		arg0_16.posTransId[var9_16] = arg1_16
	elseif arg0_16.posTransId[var9_16] == arg1_16 then
		-- block empty
	elseif var3_16 == var0_0.STATE_ACTIVE or arg0_16:getTransformState(arg0_16.posTransId[var9_16]) ~= var0_0.STATE_ACTIVE and arg1_16 < arg0_16.posTransId[var9_16] then
		if arg0_16.posTransId[var9_16] == arg0_16.curtransformId then
			arg0_16.curtransformId = arg1_16
		end

		setActive(arg0_16.grids[arg0_16.posTransId[var9_16]], false)

		arg0_16.posTransId[var9_16] = arg1_16
	end

	setActive(var0_16, arg1_16 == arg0_16.posTransId[var9_16])

	if arg0_16.curtransformId == arg1_16 then
		arg0_16:updateInfo(arg1_16)
	end
end

function var0_0.initShipModel(arg0_18)
	local var0_18 = arg0_18.shipVO:getPrefab()

	if arg0_18.shipContainer.childCount ~= 0 then
		PoolMgr.GetInstance():ReturnSpineChar(var0_18, go(arg0_18.shipModel))
	end

	local function var1_18(arg0_19)
		if not IsNil(arg0_18._tf) then
			local var0_19 = tf(arg0_19)

			arg0_18.shipModel = var0_19
			arg0_18.spineAnimUI = var0_19:GetComponent("SpineAnimUI")

			pg.ViewUtils.SetLayer(var0_19, Layer.UI)

			var0_19.localScale = Vector3(var3_0, var3_0, 1)

			setParent(var0_19, arg0_18.shipContainer)

			var0_19.localPosition = Vector2(0, 10)

			arg0_18.spineAnimUI:SetAction("stand2", 0)
		end
	end

	PoolMgr.GetInstance():GetSpineChar(var0_18, true, function(arg0_20)
		var1_18(arg0_20)
	end)
end

function var0_0.updateInfo(arg0_21, arg1_21)
	if arg0_21:isFinished(arg1_21) then
		arg0_21:updateFinished(arg1_21)
	else
		arg0_21:updateProgress(arg1_21)
	end
end

function var0_0.updateFinished(arg0_22, arg1_22)
	local var0_22 = arg0_22.shipVO.transforms[arg1_22].level

	arg0_22.curtransformId = arg1_22

	local var1_22 = pg.transform_data_template[arg1_22]

	arg0_22.infoName.text = var1_22.name

	local var2_22 = {}

	for iter0_22 = 1, var0_22 do
		_.each(var1_22.use_item[iter0_22], function(arg0_23)
			local var0_23 = _.detect(var2_22, function(arg0_24)
				return arg0_24.type == DROP_TYPE_ITEM and arg0_24.id == arg0_23[1]
			end)

			if not var0_23 then
				table.insert(var2_22, {
					type = DROP_TYPE_ITEM,
					id = arg0_23[1],
					count = arg0_23[2]
				})
			else
				var0_23.count = var0_23.count + arg0_23[2]
			end
		end)
	end

	table.insert(var2_22, {
		type = DROP_TYPE_ITEM,
		id = id2ItemId(PlayerConst.ResGold),
		count = var1_22.use_gold * var0_22
	})

	for iter1_22 = arg0_22.itemContainer.childCount, #var2_22 - 1 do
		cloneTplTo(arg0_22.itemTF, arg0_22.itemContainer)
	end

	local var3_22 = arg0_22.itemContainer.childCount

	for iter2_22 = 1, var3_22 do
		local var4_22 = arg0_22.itemContainer:GetChild(iter2_22 - 1)

		setActive(var4_22, iter2_22 <= #var2_22)

		if iter2_22 <= #var2_22 then
			updateDrop(arg0_22:findTF("IconTpl", var4_22), var2_22[iter2_22])
			RemoveComponent(var4_22, typeof(Button))
		end
	end

	setActive(arg0_22.shipTF, var1_22.use_ship > 0)

	if var1_22.use_ship > 0 then
		setActive(arg0_22.shipTF:Find("addTF"), false)
		setActive(arg0_22.shipTF:Find("IconTpl"), true)
		updateDrop(arg0_22:findTF("IconTpl", arg0_22.shipTF), {
			type = DROP_TYPE_SHIP,
			id = arg0_22.shipVO.configId
		})
		removeOnButton(arg0_22.shipTF)
	end

	setActive(arg0_22.skillDesc.parent, var1_22.skill_id ~= 0)

	if var1_22.skill_id ~= 0 then
		local var5_22 = pg.skill_data_template[var1_22.skill_id].name

		setText(arg0_22.skillDesc, i18n("ship_remould_material_unlock_skill", var5_22))
	end

	removeAllChildren(arg0_22.attrContainer)

	local var6_22
	local var7_22

	_.each(var1_22.ship_id, function(arg0_25)
		if arg0_25[1] == arg0_22.shipVO.configId then
			var6_22 = arg0_25[2]
		end

		if pg.ship_data_template[arg0_25[1]].group_type == arg0_22.shipVO.groupId then
			var7_22 = pg.ship_data_statistics[arg0_25[2]].type
		end
	end)

	if var7_22 then
		local var8_22 = cloneTplTo(arg0_22.attrTplD, arg0_22.attrContainer)

		setText(var8_22:Find("name"), i18n("common_ship_type"))
		setText(var8_22:Find("value"), ShipType.Type2Name(var7_22))

		local var9_22 = var8_22:Find("quest")

		setActive(var9_22, true)
		onButton(arg0_22, var8_22, function()
			arg0_22:showToolTip(arg1_22)
		end)
	else
		local var10_22 = _.reduce(var1_22.effect, {}, function(arg0_27, arg1_27)
			for iter0_27, iter1_27 in pairs(arg1_27) do
				arg0_27[iter0_27] = (arg0_27[iter0_27] or 0) + iter1_27
			end

			return arg0_27
		end)
		local var11_22 = arg0_22.shipVO:getShipProperties()

		for iter3_22, iter4_22 in pairs(var11_22) do
			if var10_22[iter3_22] then
				local var12_22 = cloneTplTo(arg0_22.attrTplD, arg0_22.attrContainer)

				arg0_22:updateAttrTF_D(var12_22, {
					attrName = AttributeType.Type2Name(iter3_22),
					value = math.floor(iter4_22),
					addition = var10_22[iter3_22]
				})
			end
		end

		local var13_22 = pg.ship_data_template[arg0_22.shipVO.configId]

		for iter5_22 = 1, 3 do
			if var10_22["equipment_proficiency_" .. iter5_22] then
				local var14_22 = EquipType.Types2Title(iter5_22, arg0_22.shipVO.configId)
				local var15_22 = EquipType.LabelToName(var14_22) .. i18n("common_proficiency")
				local var16_22 = cloneTplTo(arg0_22.attrTplD, arg0_22.attrContainer)

				arg0_22:updateAttrTF_D(var16_22, {
					attrName = var15_22,
					value = arg0_22.shipVO:getEquipProficiencyByPos(iter5_22) * 100,
					addition = var10_22["equipment_proficiency_" .. iter5_22] * 100
				}, true)
			end
		end
	end

	setActive(arg0_22.confirmBtn, false)
	setActive(arg0_22.inactiveBtn, false)
	setActive(arg0_22.completedteBtn, arg0_22:isFinished(arg1_22))

	arg0_22.contextData.transformId = arg1_22
end

function var0_0.updateProgress(arg0_28, arg1_28)
	local var0_28 = arg0_28:getTransformLevel(arg1_28) + 1

	arg0_28.curtransformId = arg1_28

	local var1_28 = pg.transform_data_template[arg1_28]

	arg0_28.infoName.text = var1_28.name

	local var2_28, var3_28 = arg0_28:canRemould(arg1_28)
	local var4_28 = var1_28.effect[var0_28] or {}

	setActive(arg0_28.shipTF, false)
	setText(arg0_28.skillDesc, "")

	local var5_28

	if var1_28.use_item[var0_28] then
		var5_28 = Clone(var1_28.use_item[var0_28])
	else
		var5_28 = {}
	end

	if var1_28.use_gold > 0 then
		table.insert(var5_28, {
			id2ItemId(PlayerConst.ResGold),
			var1_28.use_gold
		})
	end

	setActive(arg0_28.shipTF, var1_28.use_ship ~= 0)

	if var1_28.use_ship ~= 0 then
		local var6_28 = arg0_28.contextData.materialShipIds
		local var7_28 = var6_28 and table.getCount(var6_28) ~= 0

		setActive(arg0_28.shipTF:Find("IconTpl"), var7_28)
		setActive(arg0_28.shipTF:Find("addTF"), not var7_28)

		if var7_28 then
			updateDrop(arg0_28:findTF("IconTpl", arg0_28.shipTF), {
				id = getProxy(BayProxy):getShipById(var6_28[1]).configId,
				type = DROP_TYPE_SHIP
			})
		end

		onButton(arg0_28, arg0_28.shipTF, function()
			if var2_28 then
				arg0_28:emit(ShipRemouldMediator.ON_SELECTE_SHIP, arg0_28.shipVO)
			else
				pg.TipsMgr.GetInstance():ShowTips(var3_28)
			end
		end, SFX_PANEL)
	else
		arg0_28.contextData.materialShipIds = nil
	end

	setActive(arg0_28.skillDesc.parent, var1_28.skill_id ~= 0)

	if var1_28.skill_id ~= 0 then
		local var8_28 = pg.skill_data_template[var1_28.skill_id].name

		setText(arg0_28.skillDesc, i18n("ship_remould_material_unlock_skill", var8_28))
	end

	for iter0_28 = arg0_28.itemContainer.childCount, #var5_28 - 1 do
		cloneTplTo(arg0_28.itemTF, arg0_28.itemContainer)
	end

	local var9_28 = arg0_28.itemContainer.childCount

	for iter1_28 = 1, var9_28 do
		local var10_28 = arg0_28.itemContainer:GetChild(iter1_28 - 1)

		setActive(var10_28, iter1_28 <= #var5_28)

		if iter1_28 <= #var5_28 then
			local var11_28 = var5_28[iter1_28]
			local var12_28 = ""

			if var11_28[1] == id2ItemId(PlayerConst.ResGold) then
				local var13_28 = arg0_28.playerVO.gold >= var11_28[2]

				var12_28 = setColorStr(var11_28[2], var13_28 and COLOR_WHITE or COLOR_RED)

				if var13_28 then
					RemoveComponent(var10_28, typeof(Button))
				else
					onButton(arg0_28, var10_28, function()
						ItemTipPanel.ShowGoldBuyTip(var11_28[2])
					end)

					var10_28:GetComponent(typeof(Button)).targetGraphic = var10_28:Find("IconTpl/icon_bg/icon"):GetComponent(typeof(Image))
				end
			else
				local var14_28 = arg0_28:getItemCount(var11_28[1]) >= var11_28[2]

				var12_28 = setColorStr(arg0_28:getItemCount(var11_28[1]), var14_28 and COLOR_WHITE or COLOR_RED)
				var12_28 = var12_28 .. "/" .. var11_28[2]

				if var14_28 or not ItemTipPanel.CanShowTip(var11_28[1]) then
					RemoveComponent(var10_28, typeof(Button))
				else
					onButton(arg0_28, var10_28, function()
						ItemTipPanel.ShowItemTipbyID(var11_28[1])
					end)

					var10_28:GetComponent(typeof(Button)).targetGraphic = var10_28:Find("IconTpl/icon_bg/icon"):GetComponent(typeof(Image))
				end
			end

			updateDrop(arg0_28:findTF("IconTpl", var10_28), {
				id = var11_28[1],
				type = DROP_TYPE_ITEM,
				count = var12_28
			})
		end
	end

	removeAllChildren(arg0_28.attrContainer)

	local var15_28
	local var16_28

	_.each(var1_28.ship_id, function(arg0_32)
		if arg0_32[1] == arg0_28.shipVO.configId then
			var15_28 = arg0_32[2]
		end

		if pg.ship_data_template[arg0_32[1]].group_type == arg0_28.shipVO.groupId then
			var16_28 = pg.ship_data_statistics[arg0_32[2]].type
		end
	end)

	if var16_28 then
		local var17_28 = cloneTplTo(arg0_28.attrTpl, arg0_28.attrContainer)

		setText(var17_28:Find("name"), i18n("common_ship_type"))
		setText(var17_28:Find("pre_value"), ShipType.Type2Name(arg0_28.shipVO:getShipType()))
		setText(var17_28:Find("value"), ShipType.Type2Name(var16_28))
		setActive(var17_28:Find("addtion"), false)

		local var18_28 = var17_28:Find("quest")

		if var15_28 then
			setActive(var18_28, true)
			onButton(arg0_28, var17_28, function()
				arg0_28:showToolTip(arg1_28)
			end)
		else
			setActive(var18_28, false)
		end
	else
		local var19_28 = arg0_28.shipVO:getShipProperties()

		for iter2_28, iter3_28 in pairs(var19_28) do
			if var4_28[iter2_28] then
				local var20_28 = cloneTplTo(arg0_28.attrTpl, arg0_28.attrContainer)

				arg0_28:updateAttrTF(var20_28, {
					attrName = AttributeType.Type2Name(iter2_28),
					value = math.floor(iter3_28),
					addition = var4_28[iter2_28]
				})
			end
		end

		local var21_28 = pg.ship_data_template[arg0_28.shipVO.configId]

		for iter4_28 = 1, 3 do
			if var4_28["equipment_proficiency_" .. iter4_28] then
				local var22_28 = EquipType.Types2Title(iter4_28, arg0_28.shipVO.configId)
				local var23_28 = EquipType.LabelToName(var22_28) .. i18n("common_proficiency")
				local var24_28 = cloneTplTo(arg0_28.attrTpl, arg0_28.attrContainer)

				arg0_28:updateAttrTF(var24_28, {
					attrName = var23_28,
					value = arg0_28.shipVO:getEquipProficiencyByPos(iter4_28) * 100,
					addition = var4_28["equipment_proficiency_" .. iter4_28] * 100
				}, true)
			end
		end
	end

	local var25_28 = arg0_28:isEnoughResource(arg1_28)

	setActive(arg0_28.confirmBtn, var2_28 and var25_28)
	setActive(arg0_28.inactiveBtn, not var2_28 or not var25_28)
	setActive(arg0_28.completedteBtn, false)
	onButton(arg0_28, arg0_28.confirmBtn, function()
		local var0_34, var1_34 = ShipStatus.ShipStatusCheck("onModify", arg0_28.shipVO)

		if not var0_34 then
			pg.TipsMgr.GetInstance():ShowTips(var1_34)

			return
		end

		local var2_34, var3_34 = arg0_28:canRemould(arg1_28)

		if not var2_34 then
			pg.TipsMgr.GetInstance():ShowTips(var3_34)

			return
		end

		local var4_34, var5_34 = arg0_28:isEnoughResource(arg1_28)

		if not var4_34 then
			pg.TipsMgr.GetInstance():ShowTips(var5_34)

			return
		end

		if var15_28 then
			local var6_34 = pg.MsgboxMgr.GetInstance()

			var6_34:ShowMsgBox({
				modal = true,
				content = i18n("ship_remould_warning_" .. var15_28, arg0_28.shipVO:getName()),
				onYes = function()
					arg0_28:emit(ShipRemouldMediator.REMOULD_SHIP, arg0_28.shipVO.id, arg1_28)
				end
			})
			var6_34.contentText:AddListener(function(arg0_36, arg1_36)
				if arg0_36 == "clickDetail" then
					arg0_28:showToolTip(arg1_28)
				end
			end)
		else
			arg0_28:emit(ShipRemouldMediator.REMOULD_SHIP, arg0_28.shipVO.id, arg1_28)
		end
	end, SFX_CONFIRM)

	arg0_28.contextData.transformId = arg1_28
end

function var0_0.isUnlock(arg0_37, arg1_37)
	if not arg0_37:isUnLockPrev(arg1_37) then
		return false
	end

	if arg0_37:getLevelById(arg1_37) > arg0_37.shipVO.level then
		return false
	end

	if not arg0_37:isReachStar(arg1_37) then
		return false
	end

	return true
end

function var0_0.isFinished(arg0_38, arg1_38)
	local var0_38 = pg.transform_data_template[arg1_38]
	local var1_38 = arg0_38:getTransformLevel(arg1_38)

	if var0_38.max_level == var1_38 then
		return true
	end

	return false
end

function var0_0.isReachStar(arg0_39, arg1_39)
	local var0_39 = pg.transform_data_template[arg1_39]

	return arg0_39.shipVO:getStar() >= var0_39.star_limit
end

function var0_0.canRemould(arg0_40, arg1_40)
	if not arg0_40:isUnLockPrev(arg1_40) then
		return false, i18n("ship_remould_prev_lock"), {
			1
		}
	end

	local var0_40 = pg.transform_data_template[arg1_40]

	if arg0_40:getLevelById(arg1_40) > arg0_40.shipVO.level then
		return false, i18n("ship_remould_need_level", var0_40.level_limit), {
			2,
			var0_40.level_limit
		}
	end

	if not arg0_40:isReachStar(arg1_40) then
		return false, i18n("ship_remould_need_star", var0_40.star_limit), {
			3,
			var0_40.star_limit
		}
	end

	if arg0_40:isFinished(arg1_40) then
		return false, i18n("ship_remould_finished"), {
			4
		}
	end

	return true
end

function var0_0.isUnLockPrev(arg0_41, arg1_41)
	local var0_41 = pg.transform_data_template[arg1_41]

	for iter0_41, iter1_41 in pairs(var0_41.condition_id) do
		local var1_41 = pg.transform_data_template[iter1_41]

		if not arg0_41.shipVO.transforms[iter1_41] or arg0_41.shipVO.transforms[iter1_41].level ~= var1_41.max_level then
			return false
		end
	end

	return true
end

function var0_0.isEnoughResource(arg0_42, arg1_42)
	local var0_42 = pg.transform_data_template[arg1_42]
	local var1_42 = arg0_42:getTransformLevel(arg1_42) + 1

	for iter0_42, iter1_42 in ipairs(var0_42.use_item[var1_42] or {}) do
		if not arg0_42.itemsVO[iter1_42[1]] or arg0_42.itemsVO[iter1_42[1]].count < iter1_42[2] then
			return false, i18n("ship_remould_no_item")
		end
	end

	if arg0_42.playerVO.gold < var0_42.use_gold then
		return false, i18n("ship_remould_no_gold")
	end

	if var0_42.use_ship ~= 0 and (not arg0_42.contextData.materialShipIds or #arg0_42.contextData.materialShipIds ~= var0_42.use_ship) then
		return false, i18n("ship_remould_no_material")
	end

	return true
end

function var0_0.updateAttrTF(arg0_43, arg1_43, arg2_43, arg3_43)
	local var0_43 = arg3_43 and "%" or ""

	setText(arg1_43:Find("name"), arg2_43.attrName)
	setText(arg1_43:Find("pre_value"), arg2_43.value .. var0_43)
	setText(arg1_43:Find("value"), arg2_43.addition + arg2_43.value .. var0_43)
	setText(arg1_43:Find("addtion"), (arg2_43.addition > 0 and "+" .. arg2_43.addition or arg2_43.addition) .. var0_43)
end

function var0_0.updateAttrTF_D(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44 = arg3_44 and "%" or ""

	setText(arg1_44:Find("name"), arg2_44.attrName)
	setText(arg1_44:Find("value"), (arg2_44.addition > 0 and "+" .. arg2_44.addition or arg2_44.addition) .. var0_44)
end

function var0_0.showToolTip(arg0_45, arg1_45)
	if not arg0_45.shipVO then
		return
	end

	local var0_45 = pg.transform_data_template[arg1_45]
	local var1_45 = arg0_45:isFinished(arg1_45)

	setActive(findTF(arg0_45.tooltip, "window/scrollview/list/attrs"), not var1_45)

	if not var1_45 then
		local var2_45 = Clone(arg0_45.shipVO)

		_.each(var0_45.ship_id, function(arg0_46)
			if arg0_46[1] == arg0_45.shipVO.configId then
				var2_45.configId = arg0_46[2]
			end
		end)

		var2_45.transforms[arg1_45] = {
			level = 1,
			id = arg1_45
		}

		local var3_45 = {}

		table.insert(var3_45, {
			name = i18n("common_ship_type"),
			from = ShipType.Type2Name(arg0_45.shipVO:getShipType()),
			to = ShipType.Type2Name(var2_45:getShipType())
		})
		table.insert(var3_45, {
			name = i18n("attribute_armor_type"),
			from = arg0_45.shipVO:getShipArmorName(),
			to = var2_45:getShipArmorName()
		})

		local var4_45 = {
			AttributeType.Durability,
			AttributeType.Cannon,
			AttributeType.Torpedo,
			AttributeType.AntiAircraft,
			AttributeType.Air,
			AttributeType.Reload,
			AttributeType.Expend,
			AttributeType.Dodge,
			AttributeType.AntiSub
		}
		local var5_45 = arg0_45.shipVO:getShipProperties()
		local var6_45 = var2_45:getShipProperties()

		for iter0_45, iter1_45 in ipairs(var4_45) do
			local var7_45 = {}

			if iter1_45 == AttributeType.Expend then
				var7_45.name = AttributeType.Type2Name(iter1_45)
				var7_45.from = arg0_45.shipVO:getBattleTotalExpend()
				var7_45.to = var2_45:getBattleTotalExpend()
			else
				var7_45.name = AttributeType.Type2Name(iter1_45)
				var7_45.from = math.floor(var5_45[iter1_45])
				var7_45.to = math.floor(var6_45[iter1_45])
			end

			var7_45.add = var7_45.to - var7_45.from

			table.insert(var3_45, var7_45)
		end

		local var8_45 = UIItemList.New(findTF(arg0_45.tooltip, "window/scrollview/list/attrs"), findTF(arg0_45.tooltip, "window/scrollview/list/attrs/attr"))

		var8_45:make(function(arg0_47, arg1_47, arg2_47)
			if arg0_47 == UIItemList.EventUpdate then
				local var0_47 = var3_45[arg1_47 + 1]

				setText(arg2_47:Find("name"), var0_47.name)
				setText(arg2_47:Find("pre_value"), var0_47.from)

				local var1_47 = arg2_47:Find("addtion")
				local var2_47 = "#A9F548"

				if var0_47.add and var0_47.from ~= var0_47.to then
					setActive(var1_47, true)

					if var0_47.from > var0_47.to then
						var2_47 = "#FF3333"
					end

					local var3_47 = var0_47.from < var0_47.to and "+" or ""

					setText(var1_47, string.format("<color=%s>[%s%s]</color>", var2_47, var3_47, var0_47.add))
					setText(arg2_47:Find("value"), string.format("<color=%s>%s</color>", var2_47, var0_47.to))
				else
					setActive(var1_47, false)
					setText(arg2_47:Find("value"), string.format("<color=%s>%s</color>", var2_47, var0_47.to))
				end
			end
		end)
		var8_45:align(#var3_45)
	end

	setText(findTF(arg0_45.tooltip, "window/scrollview/list/content/"), var0_45.descrip)
	onButton(arg0_45, findTF(arg0_45.tooltip, "window/top/btnBack"), function()
		arg0_45:closeTip()
	end, SFX_CANCEL)
	onButton(arg0_45, arg0_45.tooltip, function()
		arg0_45:closeTip()
	end, SFX_CANCEL)
	setActive(arg0_45.tooltip, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_45.tooltip, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI,
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.closeTip(arg0_50)
	setActive(arg0_50.tooltip, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_50.tooltip, arg0_50._tf)
end

function var0_0.willExit(arg0_51)
	if arg0_51.helpBtn then
		setActive(arg0_51.helpBtn, true)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_51.tooltip, arg0_51._tf)
end

function var0_0.onBackPressed(arg0_52)
	if isActive(arg0_52.tooltip) then
		arg0_52:closeTip()

		return
	end

	arg0_52:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0_0
