local var0 = class("ShipRemouldLayer", import("..base.BaseUI"))
local var1 = 5
local var2 = 6
local var3 = 1
local var4 = 9
local var5 = 55
local var6 = Vector2(-5, 25)

function var0.getUIName(arg0)
	return "ShipRemouldUI"
end

function var0.init(arg0)
	arg0.container = arg0:findTF("main/bg/container")
	arg0.gridContainer = arg0:findTF("grids", arg0.container)
	arg0.gridTF = arg0:findTF("grid_tpl", arg0.gridContainer)
	arg0.height = arg0.gridTF.sizeDelta.y + var5
	arg0.width = arg0.gridTF.sizeDelta.x + var4
	arg0.startPos = Vector2(-1 * ((var2 / 2 - 0.5) * arg0.width) + var6.x, (var1 / 2 - 0.5) * arg0.height + var6.y)
	arg0.containerWidth = var2 * arg0.gridTF.sizeDelta.x + (var2 - 1) * var4
	arg0.containerHeight = var1 * arg0.gridTF.sizeDelta.y + (var1 - 1) * var5
	arg0.container.sizeDelta = Vector2(arg0.containerWidth, arg0.containerHeight)

	setActive(arg0.gridTF, false)

	arg0.infoPanel = arg0:findTF("main/info_panel")
	arg0.itemContainer = arg0:findTF("usages/items", arg0.infoPanel)
	arg0.itemTF = arg0:findTF("itemTF", arg0.itemContainer)
	arg0.infoName = arg0:findTF("name_container/Text", arg0.infoPanel):GetComponent(typeof(Text))
	arg0.attrContainer = arg0:findTF("align/attrs", arg0.infoPanel)
	arg0.attrTpl = arg0:getTpl("attr", arg0.attrContainer)
	arg0.attrTplD = arg0:getTpl("attrd", arg0.attrContainer)
	arg0.confirmBtn = arg0:findTF("confirm_btn/activity", arg0.infoPanel)
	arg0.inactiveBtn = arg0:findTF("confirm_btn/inactivity", arg0.infoPanel)
	arg0.completedteBtn = arg0:findTF("confirm_btn/complete", arg0.infoPanel)
	arg0.shipTF = arg0:findTF("main/info_panel/usages/shipTF")
	arg0.skillDesc = arg0:findTF("align/skill_desc/text", arg0.infoPanel)
	arg0.shipContainer = arg0:findTF("char_container", arg0.infoPanel)
	arg0.lineTpl = arg0:findTF("resources/line")
	arg0.lineContainer = arg0:findTF("grids/lines", arg0.container)
	arg0.helpBtn = GameObject.Find("/OverlayCamera/Overlay/UIMain/common/help_btn")

	if not IsNil(arg0.helpBtn) then
		setActive(arg0.helpBtn, false)
	end

	arg0.tooltip = arg0:findTF("tooltip")

	setActive(arg0.tooltip, false)
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1

	if arg0.curtransformId then
		arg0:updateInfo(arg0.curtransformId)
	end
end

function var0.setItems(arg0, arg1)
	arg0.itemsVO = arg1
end

function var0.getItemCount(arg0, arg1)
	return (arg0.itemsVO[arg1] or Item.New({
		count = 0,
		id = arg1
	})).count
end

function var0.setShipVO(arg0, arg1)
	arg0.shipVO = arg1
	arg0.shipGroupId = math.floor(arg0.shipVO:getGroupId())
end

function var0.getShipTranformData(arg0)
	local var0 = pg.ship_data_trans[arg0.shipGroupId]

	assert(var0, "config missed [pg.ship_data_trans] shipGroup>>>." .. arg0.shipGroupId)

	local var1 = {}

	for iter0, iter1 in ipairs(var0.transform_list) do
		for iter2, iter3 in ipairs(iter1) do
			var1[iter3[2]] = Vector2(iter0, iter3[1])
		end
	end

	return var1
end

function var0.didEnter(arg0)
	arg0:initTranformInfo()
	arg0:initShipModel()
end

function var0.initTranformInfo(arg0)
	arg0.transformIds = arg0:getShipTranformData()
	arg0.grids = {}

	for iter0, iter1 in pairs(arg0.transformIds) do
		local var0 = cloneTplTo(arg0.gridTF, arg0.gridContainer)

		go(var0).name = iter0
		var0.localPosition = Vector2(arg0.startPos.x + arg0.width * (iter1.x - 1), arg0.startPos.y - arg0.height * (iter1.y - 1))

		onToggle(arg0, var0, function(arg0)
			if arg0 and arg0.curtransformId ~= iter0 then
				arg0:updateInfo(iter0)
			end
		end, SFX_PANEL)

		arg0.grids[iter0] = var0
	end

	arg0.lineTFs = {}

	for iter2, iter3 in pairs(arg0.transformIds) do
		arg0:initLines(iter2)
	end

	arg0.posTransId = {}

	arg0:updateLines()

	if arg0.contextData.transformId then
		assert(arg0.grids[arg0.contextData.transformId], "without this transform id:" .. arg0.contextData.transformId)
		triggerToggle(arg0.grids[arg0.contextData.transformId], true)
	end
end

function var0.initLines(arg0, arg1)
	local var0 = 270
	local var1 = 75

	arg0.lineTFs[arg1] = {}

	local var2 = arg0.transformIds[arg1].x
	local var3 = arg0.transformIds[arg1].y
	local var4 = arg0.grids[arg1]
	local var5 = var4.sizeDelta
	local var6 = var4.localPosition
	local var7 = arg0.lineTpl
	local var8 = pg.transform_data_template[arg1].condition_id

	for iter0, iter1 in pairs(var8) do
		local var9 = arg0.transformIds[iter1].x
		local var10 = arg0.transformIds[iter1].y
		local var11 = Vector2(var9 - var2, var10 - var3)

		if var11 ~= Vector2.zero then
			local var12 = cloneTplTo(var7, arg0.lineContainer, var2 .. "-" .. var3 .. "-v")
			local var13 = cloneTplTo(var7, arg0.lineContainer, var2 .. "-" .. var3 .. "-h")
			local var14 = var11.y < 0 and 90 or -90

			var12.eulerAngles = Vector3(0, 0, var14)

			local var15 = var11.x < 0 and 180 or 0

			var13.eulerAngles = Vector3(0, 0, var15)

			local var16 = math.abs(var11.y) > 0 and math.abs(var11.x) > 0

			if var16 then
				local var17 = var6.y + (var3 - var10) * var0

				var13.localPosition = Vector2(var6.x, var17, 0)

				local var18 = var11.y < 0 and var6.y + var5.y / 2 or var6.y - var5.y / 2

				var12.localPosition = Vector2(var6.x, var18)
				var13.sizeDelta = Vector2(math.abs(var11.x) * var0, var13.sizeDelta.y)
				var12.sizeDelta = Vector2(math.abs(var11.y) * var0 - var5.y / 2, var12.sizeDelta.y)

				local var19 = var11.x < 0 and var14 < 0 and -1 or 1

				var12:Find("corner").localScale = Vector3(1, var19, 1)
			else
				var13.sizeDelta = Vector2(math.abs(var11.x) * var0, var13.sizeDelta.y)
				var12.sizeDelta = Vector2(math.abs(var11.y) * var1, var12.sizeDelta.y)
				var13.localPosition = var6

				local var20 = var11.y < 0 and var6.y + var5.y / 2 or var6.y - var5.y / 2

				var12.localPosition = Vector3(var6.x, var20, 0)
			end

			setActive(var12:Find("arr"), var16 or math.abs(var11.y) > 0)
			setActive(var12:Find("corner"), var16)
			setActive(var13:Find("arr"), false)
			setActive(var13:Find("corner"), false)
			table.insert(arg0.lineTFs[arg1], {
				id = iter1,
				hrz = var13,
				vec = var12
			})
		end
	end
end

function var0.updateLines(arg0)
	for iter0, iter1 in pairs(arg0.transformIds) do
		arg0:updateGridTF(iter0)

		if arg0:canRemould(iter0) or arg0:isFinished(iter0) then
			for iter2, iter3 in ipairs(arg0.lineTFs[iter0] or {}) do
				iter3.hrz:GetComponent("UIGrayScale").enabled = false
				iter3.vec:GetComponent("UIGrayScale").enabled = false
			end
		end
	end
end

function var0.getLevelById(arg0, arg1)
	return pg.transform_data_template[arg1].level_limit
end

function var0.getTransformLevel(arg0, arg1)
	if not arg0.shipVO.transforms[arg1] then
		return 0
	else
		return arg0.shipVO.transforms[arg1].level
	end
end

var0.STATE_FINISHED = 1
var0.STATE_ACTIVE = 2
var0.STATE_LOCK = 3

function var0.getTransformState(arg0, arg1)
	if arg0:getTransformLevel(arg1) == pg.transform_data_template[arg1].max_level then
		return var0.STATE_FINISHED
	elseif arg0:canRemould(arg1) then
		return var0.STATE_ACTIVE
	else
		return var0.STATE_LOCK
	end
end

function var0.updateGridTF(arg0, arg1)
	local var0 = arg0.grids[arg1]
	local var1 = pg.transform_data_template[arg1]

	setText(var0:Find("name"), var1.name)

	local var2 = var0:Find("icon"):GetComponent(typeof(Image))

	GetSpriteFromAtlasAsync("modicon", var1.icon, function(arg0)
		if not IsNil(var2) then
			var2.sprite = arg0
		end
	end)

	local var3 = arg0:getTransformState(arg1)

	setActive(var0:Find("bgs/finished"), var3 == var0.STATE_FINISHED)
	setActive(var0:Find("bgs/ongoing"), var3 == var0.STATE_ACTIVE)
	setActive(var0:Find("bgs/lock"), var3 == var0.STATE_LOCK)
	setActive(var0:Find("tags/finished"), var3 == var0.STATE_FINISHED)
	setActive(var0:Find("tags/ongoing"), var3 == var0.STATE_ACTIVE)
	setActive(var0:Find("tags/lock"), var3 == var0.STATE_LOCK)

	local var4 = arg0:getTransformLevel(arg1)
	local var5 = var0:Find("icon/progress")

	if var3 == var0.STATE_FINISHED then
		setText(var5, var4 .. "/" .. var1.max_level)
	elseif var3 == var0.STATE_ACTIVE then
		setText(var5, var4 .. "/" .. var1.max_level)
	elseif var3 == var0.STATE_LOCK then
		local var6, var7, var8 = arg0:canRemould(arg1)

		setText(var5, "")
		setActive(var0:Find("tags/lock/lock_prev"), var8 and var8[1] == 1)
		setActive(var0:Find("tags/lock/lock_level"), var8 and var8[1] == 2)
		setActive(var0:Find("tags/lock/lock_star"), var8 and var8[1] == 3)

		if var8 and var8[1] == 2 then
			setText(var0:Find("tags/lock/lock_level/Text"), var8[2])
		elseif var8 and var8[1] == 3 then
			setText(var0:Find("tags/lock/lock_star/Text"), var8[2])
		end
	end

	local var9 = arg0.transformIds[arg1].x .. "_" .. arg0.transformIds[arg1].y

	if not arg0.posTransId[var9] then
		arg0.posTransId[var9] = arg1
	elseif arg0.posTransId[var9] == arg1 then
		-- block empty
	elseif var3 == var0.STATE_ACTIVE or arg0:getTransformState(arg0.posTransId[var9]) ~= var0.STATE_ACTIVE and arg1 < arg0.posTransId[var9] then
		if arg0.posTransId[var9] == arg0.curtransformId then
			arg0.curtransformId = arg1
		end

		setActive(arg0.grids[arg0.posTransId[var9]], false)

		arg0.posTransId[var9] = arg1
	end

	setActive(var0, arg1 == arg0.posTransId[var9])

	if arg0.curtransformId == arg1 then
		arg0:updateInfo(arg1)
	end
end

function var0.initShipModel(arg0)
	local var0 = arg0.shipVO:getPrefab()

	if arg0.shipContainer.childCount ~= 0 then
		PoolMgr.GetInstance():ReturnSpineChar(var0, go(arg0.shipModel))
	end

	local function var1(arg0)
		if not IsNil(arg0._tf) then
			local var0 = tf(arg0)

			arg0.shipModel = var0
			arg0.spineAnimUI = var0:GetComponent("SpineAnimUI")

			pg.ViewUtils.SetLayer(var0, Layer.UI)

			var0.localScale = Vector3(var3, var3, 1)

			setParent(var0, arg0.shipContainer)

			var0.localPosition = Vector2(0, 10)

			arg0.spineAnimUI:SetAction("stand2", 0)
		end
	end

	PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
		var1(arg0)
	end)
end

function var0.updateInfo(arg0, arg1)
	if arg0:isFinished(arg1) then
		arg0:updateFinished(arg1)
	else
		arg0:updateProgress(arg1)
	end
end

function var0.updateFinished(arg0, arg1)
	local var0 = arg0.shipVO.transforms[arg1].level

	arg0.curtransformId = arg1

	local var1 = pg.transform_data_template[arg1]

	arg0.infoName.text = var1.name

	local var2 = {}

	for iter0 = 1, var0 do
		_.each(var1.use_item[iter0], function(arg0)
			local var0 = _.detect(var2, function(arg0)
				return arg0.type == DROP_TYPE_ITEM and arg0.id == arg0[1]
			end)

			if not var0 then
				table.insert(var2, {
					type = DROP_TYPE_ITEM,
					id = arg0[1],
					count = arg0[2]
				})
			else
				var0.count = var0.count + arg0[2]
			end
		end)
	end

	table.insert(var2, {
		type = DROP_TYPE_ITEM,
		id = id2ItemId(PlayerConst.ResGold),
		count = var1.use_gold * var0
	})

	for iter1 = arg0.itemContainer.childCount, #var2 - 1 do
		cloneTplTo(arg0.itemTF, arg0.itemContainer)
	end

	local var3 = arg0.itemContainer.childCount

	for iter2 = 1, var3 do
		local var4 = arg0.itemContainer:GetChild(iter2 - 1)

		setActive(var4, iter2 <= #var2)

		if iter2 <= #var2 then
			updateDrop(arg0:findTF("IconTpl", var4), var2[iter2])
			RemoveComponent(var4, typeof(Button))
		end
	end

	setActive(arg0.shipTF, var1.use_ship > 0)

	if var1.use_ship > 0 then
		setActive(arg0.shipTF:Find("addTF"), false)
		setActive(arg0.shipTF:Find("IconTpl"), true)
		updateDrop(arg0:findTF("IconTpl", arg0.shipTF), {
			type = DROP_TYPE_SHIP,
			id = arg0.shipVO.configId
		})
		removeOnButton(arg0.shipTF)
	end

	setActive(arg0.skillDesc.parent, var1.skill_id ~= 0)

	if var1.skill_id ~= 0 then
		local var5 = pg.skill_data_template[var1.skill_id].name

		setText(arg0.skillDesc, i18n("ship_remould_material_unlock_skill", var5))
	end

	removeAllChildren(arg0.attrContainer)

	local var6
	local var7

	_.each(var1.ship_id, function(arg0)
		if arg0[1] == arg0.shipVO.configId then
			var6 = arg0[2]
		end

		if pg.ship_data_template[arg0[1]].group_type == arg0.shipVO.groupId then
			var7 = pg.ship_data_statistics[arg0[2]].type
		end
	end)

	if var7 then
		local var8 = cloneTplTo(arg0.attrTplD, arg0.attrContainer)

		setText(var8:Find("name"), i18n("common_ship_type"))
		setText(var8:Find("value"), ShipType.Type2Name(var7))

		local var9 = var8:Find("quest")

		setActive(var9, true)
		onButton(arg0, var8, function()
			arg0:showToolTip(arg1)
		end)
	else
		local var10 = _.reduce(var1.effect, {}, function(arg0, arg1)
			for iter0, iter1 in pairs(arg1) do
				arg0[iter0] = (arg0[iter0] or 0) + iter1
			end

			return arg0
		end)
		local var11 = arg0.shipVO:getShipProperties()

		for iter3, iter4 in pairs(var11) do
			if var10[iter3] then
				local var12 = cloneTplTo(arg0.attrTplD, arg0.attrContainer)

				arg0:updateAttrTF_D(var12, {
					attrName = AttributeType.Type2Name(iter3),
					value = math.floor(iter4),
					addition = var10[iter3]
				})
			end
		end

		local var13 = pg.ship_data_template[arg0.shipVO.configId]

		for iter5 = 1, 3 do
			if var10["equipment_proficiency_" .. iter5] then
				local var14 = EquipType.Types2Title(iter5, arg0.shipVO.configId)
				local var15 = EquipType.LabelToName(var14) .. i18n("common_proficiency")
				local var16 = cloneTplTo(arg0.attrTplD, arg0.attrContainer)

				arg0:updateAttrTF_D(var16, {
					attrName = var15,
					value = arg0.shipVO:getEquipProficiencyByPos(iter5) * 100,
					addition = var10["equipment_proficiency_" .. iter5] * 100
				}, true)
			end
		end
	end

	setActive(arg0.confirmBtn, false)
	setActive(arg0.inactiveBtn, false)
	setActive(arg0.completedteBtn, arg0:isFinished(arg1))

	arg0.contextData.transformId = arg1
end

function var0.updateProgress(arg0, arg1)
	local var0 = arg0:getTransformLevel(arg1) + 1

	arg0.curtransformId = arg1

	local var1 = pg.transform_data_template[arg1]

	arg0.infoName.text = var1.name

	local var2, var3 = arg0:canRemould(arg1)
	local var4 = var1.effect[var0] or {}

	setActive(arg0.shipTF, false)
	setText(arg0.skillDesc, "")

	local var5

	if var1.use_item[var0] then
		var5 = Clone(var1.use_item[var0])
	else
		var5 = {}
	end

	if var1.use_gold > 0 then
		table.insert(var5, {
			id2ItemId(PlayerConst.ResGold),
			var1.use_gold
		})
	end

	setActive(arg0.shipTF, var1.use_ship ~= 0)

	if var1.use_ship ~= 0 then
		local var6 = arg0.contextData.materialShipIds
		local var7 = var6 and table.getCount(var6) ~= 0

		setActive(arg0.shipTF:Find("IconTpl"), var7)
		setActive(arg0.shipTF:Find("addTF"), not var7)

		if var7 then
			updateDrop(arg0:findTF("IconTpl", arg0.shipTF), {
				id = getProxy(BayProxy):getShipById(var6[1]).configId,
				type = DROP_TYPE_SHIP
			})
		end

		onButton(arg0, arg0.shipTF, function()
			if var2 then
				arg0:emit(ShipRemouldMediator.ON_SELECTE_SHIP, arg0.shipVO)
			else
				pg.TipsMgr.GetInstance():ShowTips(var3)
			end
		end, SFX_PANEL)
	else
		arg0.contextData.materialShipIds = nil
	end

	setActive(arg0.skillDesc.parent, var1.skill_id ~= 0)

	if var1.skill_id ~= 0 then
		local var8 = pg.skill_data_template[var1.skill_id].name

		setText(arg0.skillDesc, i18n("ship_remould_material_unlock_skill", var8))
	end

	for iter0 = arg0.itemContainer.childCount, #var5 - 1 do
		cloneTplTo(arg0.itemTF, arg0.itemContainer)
	end

	local var9 = arg0.itemContainer.childCount

	for iter1 = 1, var9 do
		local var10 = arg0.itemContainer:GetChild(iter1 - 1)

		setActive(var10, iter1 <= #var5)

		if iter1 <= #var5 then
			local var11 = var5[iter1]
			local var12 = ""

			if var11[1] == id2ItemId(PlayerConst.ResGold) then
				local var13 = arg0.playerVO.gold >= var11[2]

				var12 = setColorStr(var11[2], var13 and COLOR_WHITE or COLOR_RED)

				if var13 then
					RemoveComponent(var10, typeof(Button))
				else
					onButton(arg0, var10, function()
						ItemTipPanel.ShowGoldBuyTip(var11[2])
					end)

					var10:GetComponent(typeof(Button)).targetGraphic = var10:Find("IconTpl/icon_bg/icon"):GetComponent(typeof(Image))
				end
			else
				local var14 = arg0:getItemCount(var11[1]) >= var11[2]

				var12 = setColorStr(arg0:getItemCount(var11[1]), var14 and COLOR_WHITE or COLOR_RED)
				var12 = var12 .. "/" .. var11[2]

				if var14 or not ItemTipPanel.CanShowTip(var11[1]) then
					RemoveComponent(var10, typeof(Button))
				else
					onButton(arg0, var10, function()
						ItemTipPanel.ShowItemTipbyID(var11[1])
					end)

					var10:GetComponent(typeof(Button)).targetGraphic = var10:Find("IconTpl/icon_bg/icon"):GetComponent(typeof(Image))
				end
			end

			updateDrop(arg0:findTF("IconTpl", var10), {
				id = var11[1],
				type = DROP_TYPE_ITEM,
				count = var12
			})
		end
	end

	removeAllChildren(arg0.attrContainer)

	local var15
	local var16

	_.each(var1.ship_id, function(arg0)
		if arg0[1] == arg0.shipVO.configId then
			var15 = arg0[2]
		end

		if pg.ship_data_template[arg0[1]].group_type == arg0.shipVO.groupId then
			var16 = pg.ship_data_statistics[arg0[2]].type
		end
	end)

	if var16 then
		local var17 = cloneTplTo(arg0.attrTpl, arg0.attrContainer)

		setText(var17:Find("name"), i18n("common_ship_type"))
		setText(var17:Find("pre_value"), ShipType.Type2Name(arg0.shipVO:getShipType()))
		setText(var17:Find("value"), ShipType.Type2Name(var16))
		setActive(var17:Find("addtion"), false)

		local var18 = var17:Find("quest")

		if var15 then
			setActive(var18, true)
			onButton(arg0, var17, function()
				arg0:showToolTip(arg1)
			end)
		else
			setActive(var18, false)
		end
	else
		local var19 = arg0.shipVO:getShipProperties()

		for iter2, iter3 in pairs(var19) do
			if var4[iter2] then
				local var20 = cloneTplTo(arg0.attrTpl, arg0.attrContainer)

				arg0:updateAttrTF(var20, {
					attrName = AttributeType.Type2Name(iter2),
					value = math.floor(iter3),
					addition = var4[iter2]
				})
			end
		end

		local var21 = pg.ship_data_template[arg0.shipVO.configId]

		for iter4 = 1, 3 do
			if var4["equipment_proficiency_" .. iter4] then
				local var22 = EquipType.Types2Title(iter4, arg0.shipVO.configId)
				local var23 = EquipType.LabelToName(var22) .. i18n("common_proficiency")
				local var24 = cloneTplTo(arg0.attrTpl, arg0.attrContainer)

				arg0:updateAttrTF(var24, {
					attrName = var23,
					value = arg0.shipVO:getEquipProficiencyByPos(iter4) * 100,
					addition = var4["equipment_proficiency_" .. iter4] * 100
				}, true)
			end
		end
	end

	local var25 = arg0:isEnoughResource(arg1)

	setActive(arg0.confirmBtn, var2 and var25)
	setActive(arg0.inactiveBtn, not var2 or not var25)
	setActive(arg0.completedteBtn, false)
	onButton(arg0, arg0.confirmBtn, function()
		local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0.shipVO)

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		local var2, var3 = arg0:canRemould(arg1)

		if not var2 then
			pg.TipsMgr.GetInstance():ShowTips(var3)

			return
		end

		local var4, var5 = arg0:isEnoughResource(arg1)

		if not var4 then
			pg.TipsMgr.GetInstance():ShowTips(var5)

			return
		end

		if var15 then
			local var6 = pg.MsgboxMgr.GetInstance()

			var6:ShowMsgBox({
				modal = true,
				content = i18n("ship_remould_warning_" .. var15, arg0.shipVO:getName()),
				onYes = function()
					arg0:emit(ShipRemouldMediator.REMOULD_SHIP, arg0.shipVO.id, arg1)
				end
			})
			var6.contentText:AddListener(function(arg0, arg1)
				if arg0 == "clickDetail" then
					arg0:showToolTip(arg1)
				end
			end)
		else
			arg0:emit(ShipRemouldMediator.REMOULD_SHIP, arg0.shipVO.id, arg1)
		end
	end, SFX_CONFIRM)

	arg0.contextData.transformId = arg1
end

function var0.isUnlock(arg0, arg1)
	if not arg0:isUnLockPrev(arg1) then
		return false
	end

	if arg0:getLevelById(arg1) > arg0.shipVO.level then
		return false
	end

	if not arg0:isReachStar(arg1) then
		return false
	end

	return true
end

function var0.isFinished(arg0, arg1)
	local var0 = pg.transform_data_template[arg1]
	local var1 = arg0:getTransformLevel(arg1)

	if var0.max_level == var1 then
		return true
	end

	return false
end

function var0.isReachStar(arg0, arg1)
	local var0 = pg.transform_data_template[arg1]

	return arg0.shipVO:getStar() >= var0.star_limit
end

function var0.canRemould(arg0, arg1)
	if not arg0:isUnLockPrev(arg1) then
		return false, i18n("ship_remould_prev_lock"), {
			1
		}
	end

	local var0 = pg.transform_data_template[arg1]

	if arg0:getLevelById(arg1) > arg0.shipVO.level then
		return false, i18n("ship_remould_need_level", var0.level_limit), {
			2,
			var0.level_limit
		}
	end

	if not arg0:isReachStar(arg1) then
		return false, i18n("ship_remould_need_star", var0.star_limit), {
			3,
			var0.star_limit
		}
	end

	if arg0:isFinished(arg1) then
		return false, i18n("ship_remould_finished"), {
			4
		}
	end

	return true
end

function var0.isUnLockPrev(arg0, arg1)
	local var0 = pg.transform_data_template[arg1]

	for iter0, iter1 in pairs(var0.condition_id) do
		local var1 = pg.transform_data_template[iter1]

		if not arg0.shipVO.transforms[iter1] or arg0.shipVO.transforms[iter1].level ~= var1.max_level then
			return false
		end
	end

	return true
end

function var0.isEnoughResource(arg0, arg1)
	local var0 = pg.transform_data_template[arg1]
	local var1 = arg0:getTransformLevel(arg1) + 1

	for iter0, iter1 in ipairs(var0.use_item[var1] or {}) do
		if not arg0.itemsVO[iter1[1]] or arg0.itemsVO[iter1[1]].count < iter1[2] then
			return false, i18n("ship_remould_no_item")
		end
	end

	if arg0.playerVO.gold < var0.use_gold then
		return false, i18n("ship_remould_no_gold")
	end

	if var0.use_ship ~= 0 and (not arg0.contextData.materialShipIds or #arg0.contextData.materialShipIds ~= var0.use_ship) then
		return false, i18n("ship_remould_no_material")
	end

	return true
end

function var0.updateAttrTF(arg0, arg1, arg2, arg3)
	local var0 = arg3 and "%" or ""

	setText(arg1:Find("name"), arg2.attrName)
	setText(arg1:Find("pre_value"), arg2.value .. var0)
	setText(arg1:Find("value"), arg2.addition + arg2.value .. var0)
	setText(arg1:Find("addtion"), (arg2.addition > 0 and "+" .. arg2.addition or arg2.addition) .. var0)
end

function var0.updateAttrTF_D(arg0, arg1, arg2, arg3)
	local var0 = arg3 and "%" or ""

	setText(arg1:Find("name"), arg2.attrName)
	setText(arg1:Find("value"), (arg2.addition > 0 and "+" .. arg2.addition or arg2.addition) .. var0)
end

function var0.showToolTip(arg0, arg1)
	if not arg0.shipVO then
		return
	end

	local var0 = pg.transform_data_template[arg1]
	local var1 = arg0:isFinished(arg1)

	setActive(findTF(arg0.tooltip, "window/scrollview/list/attrs"), not var1)

	if not var1 then
		local var2 = Clone(arg0.shipVO)

		_.each(var0.ship_id, function(arg0)
			if arg0[1] == arg0.shipVO.configId then
				var2.configId = arg0[2]
			end
		end)

		var2.transforms[arg1] = {
			level = 1,
			id = arg1
		}

		local var3 = {}

		table.insert(var3, {
			name = i18n("common_ship_type"),
			from = ShipType.Type2Name(arg0.shipVO:getShipType()),
			to = ShipType.Type2Name(var2:getShipType())
		})
		table.insert(var3, {
			name = i18n("attribute_armor_type"),
			from = arg0.shipVO:getShipArmorName(),
			to = var2:getShipArmorName()
		})

		local var4 = {
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
		local var5 = arg0.shipVO:getShipProperties()
		local var6 = var2:getShipProperties()

		for iter0, iter1 in ipairs(var4) do
			local var7 = {}

			if iter1 == AttributeType.Expend then
				var7.name = AttributeType.Type2Name(iter1)
				var7.from = arg0.shipVO:getBattleTotalExpend()
				var7.to = var2:getBattleTotalExpend()
			else
				var7.name = AttributeType.Type2Name(iter1)
				var7.from = math.floor(var5[iter1])
				var7.to = math.floor(var6[iter1])
			end

			var7.add = var7.to - var7.from

			table.insert(var3, var7)
		end

		local var8 = UIItemList.New(findTF(arg0.tooltip, "window/scrollview/list/attrs"), findTF(arg0.tooltip, "window/scrollview/list/attrs/attr"))

		var8:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = var3[arg1 + 1]

				setText(arg2:Find("name"), var0.name)
				setText(arg2:Find("pre_value"), var0.from)

				local var1 = arg2:Find("addtion")
				local var2 = "#A9F548"

				if var0.add and var0.from ~= var0.to then
					setActive(var1, true)

					if var0.from > var0.to then
						var2 = "#FF3333"
					end

					local var3 = var0.from < var0.to and "+" or ""

					setText(var1, string.format("<color=%s>[%s%s]</color>", var2, var3, var0.add))
					setText(arg2:Find("value"), string.format("<color=%s>%s</color>", var2, var0.to))
				else
					setActive(var1, false)
					setText(arg2:Find("value"), string.format("<color=%s>%s</color>", var2, var0.to))
				end
			end
		end)
		var8:align(#var3)
	end

	setText(findTF(arg0.tooltip, "window/scrollview/list/content/"), var0.descrip)
	onButton(arg0, findTF(arg0.tooltip, "window/top/btnBack"), function()
		arg0:closeTip()
	end, SFX_CANCEL)
	onButton(arg0, arg0.tooltip, function()
		arg0:closeTip()
	end, SFX_CANCEL)
	setActive(arg0.tooltip, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.tooltip, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI,
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0.closeTip(arg0)
	setActive(arg0.tooltip, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.tooltip, arg0._tf)
end

function var0.willExit(arg0)
	if arg0.helpBtn then
		setActive(arg0.helpBtn, true)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.tooltip, arg0._tf)
end

function var0.onBackPressed(arg0)
	if isActive(arg0.tooltip) then
		arg0:closeTip()

		return
	end

	arg0:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0
