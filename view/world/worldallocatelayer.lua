local var0_0 = class("WorldAllocateLayer", import("..base.BaseUI"))

var0_0.TeamNum = {
	"FIRST",
	"SECOND",
	"THIRD",
	"FOURTH",
	"FIFTH",
	"SIXTH"
}

function var0_0.getUIName(arg0_1)
	return "WorldAllocateUI"
end

function var0_0.init(arg0_2)
	arg0_2._selectedShipList = {}
	arg0_2._shipTFList = {}
	arg0_2._shipVOList = {}
	arg0_2.cancelBtn = arg0_2:findTF("actions/cancel_button")
	arg0_2.confirmBtn = arg0_2:findTF("actions/compose_button")
	arg0_2.itemTF = arg0_2:findTF("item")
	arg0_2.nameTF = arg0_2:findTF("item/name_container/name")
	arg0_2.descTF = arg0_2:findTF("item/desc")
	arg0_2.fleetInfo = arg0_2:findTF("fleet_info")

	setText(arg0_2.fleetInfo:Find("top/Text"), i18n("world_ship_repair"))

	arg0_2.shipTpl = arg0_2:getTpl("fleet_info/shiptpl")
	arg0_2.emptyTpl = arg0_2:getTpl("fleet_info/emptytpl")
	arg0_2.shipsContainer = arg0_2:findTF("fleet_info/contain")
	arg0_2.descLabel = arg0_2:findTF("fleet_info/top/Text")

	setText(arg0_2.fleetInfo:Find("tip/Text"), i18n("world_battle_damage"))

	arg0_2.countLabel = arg0_2:findTF("count")
	arg0_2.quotaTxt = arg0_2:findTF("count/value")
	arg0_2.btnFleet = arg0_2:findTF("fleets/selected")
	arg0_2.fleetToggleMask = arg0_2:findTF("fleets/list_mask")
	arg0_2.fleetToggleList = arg0_2.fleetToggleMask:Find("list")

	onButton(arg0_2, arg0_2.cancelBtn, function()
		arg0_2:closeView()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.confirmBtn, function()
		if arg0_2.itemVO.count == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end

		local function var0_4()
			local var0_5 = {}

			arg0_2._preSelectedList = {}

			for iter0_5, iter1_5 in ipairs(arg0_2._selectedShipList) do
				var0_5[#var0_5 + 1] = iter1_5.id
				arg0_2._preSelectedList[iter1_5.id] = true
			end

			arg0_2.confirmCallback(arg0_2.itemVO.configId, var0_5)
		end

		if #arg0_2._selectedShipList > 0 then
			local var1_4 = false
			local var2_4 = arg0_2.itemVO:getWorldItemType()

			if var2_4 == WorldItem.UsageBuff then
				local var3_4 = arg0_2.itemVO:getItemBuffID()

				var1_4 = _.any(arg0_2._selectedShipList, function(arg0_6)
					return arg0_6:IsBuffMax()
				end)
			elseif var2_4 == WorldItem.UsageHPRegenerate or var2_4 == WorldItem.UsageHPRegenerateValue then
				var1_4 = _.any(arg0_2._selectedShipList, function(arg0_7)
					return arg0_7:IsHpFull()
				end)
			end

			if var1_4 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_ship_healthy"),
					onYes = var0_4
				})
			else
				var0_4()
			end
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.fleetToggleMask, function()
		arg0_2:showOrHideToggleMask(false)
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnFleet, function()
		arg0_2:showOrHideToggleMask(true)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf:Find("item/reset_btn"), function()
		assert(arg0_2.contextData.onResetInfo, "without reset info callback")
		arg0_2.contextData.onResetInfo(Drop.New({
			count = 1,
			type = DROP_TYPE_WORLD_ITEM,
			id = arg0_2.itemVO.id
		}))
	end)
end

function var0_0.didEnter(arg0_11)
	arg0_11:updateToggleList(arg0_11.fleetList, arg0_11.contextData.fleetIndex or 1)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf, false)
end

function var0_0.showOrHideToggleMask(arg0_12, arg1_12)
	setActive(arg0_12.fleetToggleMask, arg1_12)
	arg0_12:tweenTabArrow(not arg1_12)
end

function var0_0.setFleets(arg0_13, arg1_13, arg2_13)
	arg0_13.fleetList = arg1_13
end

function var0_0.setConfirmCallback(arg0_14, arg1_14)
	arg0_14.confirmCallback = arg1_14
end

function var0_0.setItem(arg0_15, arg1_15)
	arg0_15.itemVO = arg1_15

	updateDrop(arg0_15.itemTF, Drop.New({
		type = DROP_TYPE_WORLD_ITEM,
		id = arg1_15.id,
		count = arg1_15.count
	}))
	setText(arg0_15.nameTF, arg1_15:getConfig("name"))
	setText(arg0_15.descTF, arg1_15:getConfig("display"))

	arg0_15.quota = arg0_15.itemVO:getItemQuota()

	arg0_15:updateQuota()
end

function var0_0.updateQuota(arg0_16)
	setText(arg0_16.quotaTxt, #arg0_16._selectedShipList .. "/" .. arg0_16.quota)
	setActive(arg0_16.countLabel, true)
end

function var0_0.flush(arg0_17, arg1_17)
	if arg1_17.id ~= arg0_17.itemVO.id then
		return
	end

	arg0_17:setItem(arg0_17.itemVO)

	local var0_17 = arg0_17.itemVO:getWorldItemType()

	if var0_17 == WorldItem.UsageBuff then
		arg0_17:OnUpdateShipBuff()
	elseif var0_17 == WorldItem.UsageHPRegenerate or var0_17 == WorldItem.UsageHPRegenerateValue then
		arg0_17:OnUpdateShipHP()
	end
end

function var0_0.updateToggleList(arg0_18, arg1_18, arg2_18)
	setActive(arg0_18.fleetToggleList, true)

	local var0_18

	for iter0_18 = 1, arg0_18.fleetToggleList.childCount do
		local var1_18 = arg0_18.fleetToggleList:GetChild(arg0_18.fleetToggleList.childCount - iter0_18)

		setActive(var1_18, arg1_18[iter0_18])

		if arg1_18[iter0_18] then
			setActive(var1_18:Find("lock"), false)
			setText(var1_18:Find("on/mask/text"), i18n("world_fleetName" .. iter0_18))
			setText(var1_18:Find("on/mask/en"), var0_0.TeamNum[iter0_18] .. " FLEET")
			setText(var1_18:Find("on/mask/number"), iter0_18)
			setText(var1_18:Find("off/mask/text"), i18n("world_fleetName" .. iter0_18))
			setText(var1_18:Find("off/mask/en"), var0_0.TeamNum[iter0_18] .. " FLEET")
			setText(var1_18:Find("off/mask/number"), iter0_18)
			onToggle(arg0_18, var1_18, function(arg0_19)
				if arg0_19 then
					arg0_18:showOrHideToggleMask(false)
					arg0_18:setFleet(arg1_18[iter0_18].id)
					arg0_18:updateQuota()
				end
			end, SFX_UI_TAG)

			if arg1_18[iter0_18].id == arg2_18 then
				var0_18 = var1_18
			end
		end
	end

	if var0_18 then
		triggerToggle(var0_18, true)
	end
end

function var0_0.updateFleetButton(arg0_20, arg1_20)
	setText(arg0_20.btnFleet:Find("fleet/CnFleet"), i18n("world_fleetName" .. arg1_20))
	setText(arg0_20.btnFleet:Find("fleet/enFleet"), var0_0.TeamNum[arg1_20] .. " FLEET")
	setText(arg0_20.btnFleet:Find("fleet/num"), arg1_20)
end

function var0_0.tweenTabArrow(arg0_21, arg1_21)
	local var0_21 = arg0_21.btnFleet:Find("arr")

	setActive(var0_21, arg1_21)

	if arg1_21 then
		LeanTween.moveLocalY(go(var0_21), var0_21.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
	else
		LeanTween.cancel(go(var0_21))

		local var1_21 = var0_21.localPosition

		var1_21.y = 80
		var0_21.localPosition = var1_21
	end
end

function var0_0.setFleet(arg0_22, arg1_22)
	arg0_22:updateFleetButton(arg1_22)

	local var0_22 = arg0_22.itemVO:getWorldItemType()

	for iter0_22, iter1_22 in pairs(arg0_22._shipTFList) do
		local var1_22 = iter1_22:Find("buff/bg/levelup(Clone)")

		if not IsNil(var1_22) then
			PoolMgr.GetInstance():ReturnUI("levelup", var1_22)
		end
	end

	removeAllChildren(arg0_22.shipsContainer)

	arg0_22.currentFleetIndex = arg1_22
	arg0_22._selectedShipList = {}
	arg0_22._shipTFList = {}

	local var2_22 = arg0_22.fleetList[arg0_22.currentFleetIndex]:GetShips(true)
	local var3_22 = underscore.map(var2_22, function(arg0_23)
		return WorldConst.FetchShipVO(arg0_23.id)
	end)
	local var4_22 = arg0_22.quota

	for iter2_22 = 1, 6 do
		local var5_22 = var2_22[iter2_22]
		local var6_22 = var3_22[iter2_22]

		if var2_22[iter2_22] then
			local var7_22 = cloneTplTo(arg0_22.shipTpl, arg0_22.shipsContainer)

			arg0_22._shipTFList[var5_22.id] = var7_22
			arg0_22._shipVOList[var6_22.id] = var6_22

			updateShip(var7_22, var6_22, {
				initStar = true
			})

			local var8_22 = false

			if var0_22 == WorldItem.UsageBuff then
				var8_22 = arg0_22:initBuff(var7_22, var5_22)
			elseif var0_22 == WorldItem.UsageHPRegenerate or var0_22 == WorldItem.UsageHPRegenerateValue then
				var8_22 = arg0_22:initHP(var7_22, var5_22)
			end

			if var4_22 > 0 and var8_22 then
				triggerButton(var7_22)

				var4_22 = var4_22 - 1
			end
		else
			local var9_22 = cloneTplTo(arg0_22.emptyTpl, arg0_22.shipsContainer)
		end
	end

	setActive(arg0_22.fleetInfo:Find("tip"), underscore.any(var2_22, function(arg0_24)
		return arg0_24:IsBroken()
	end))
end

function var0_0.OnUpdateShipHP(arg0_25)
	local var0_25 = arg0_25.fleetList[arg0_25.currentFleetIndex]
	local var1_25 = arg0_25.itemVO:getItemBuffID()

	for iter0_25, iter1_25 in pairs(arg0_25._shipTFList) do
		if arg0_25._preSelectedList[iter0_25] then
			local var2_25 = var0_25:GetShip(iter0_25)
			local var3_25 = iter1_25:Find("hp")
			local var4_25 = var3_25:Find("progress_bg/bar")

			setImageColor(var4_25, var2_25:IsHpSafe() and Color.New(0.615686274509804, 0.917647058823529, 0.235294117647059) or Color.New(0.615686274509804, 0.917647058823529, 0.235294117647059))

			local var5_25 = var4_25:GetComponent(typeof(Image)).fillAmount
			local var6_25 = var2_25.hpRant / 10000

			if var5_25 < var6_25 then
				LeanTween.value(go(var4_25), var5_25, var6_25, var6_25 - var5_25):setOnUpdate(System.Action_float(function(arg0_26)
					var4_25:GetComponent(typeof(Image)).fillAmount = arg0_26
				end))
			end

			setActive(var3_25:Find("broken"), var2_25:IsBroken())

			if var2_25:IsHpFull() then
				triggerButton(iter1_25)
			else
				arg0_25:updateSelectShipHP(iter1_25, true, var2_25)
			end
		end
	end

	arg0_25._preSelectedList = nil
end

function var0_0.OnUpdateShipBuff(arg0_27)
	local var0_27 = arg0_27.fleetList[arg0_27.currentFleetIndex]
	local var1_27 = arg0_27.itemVO:getItemBuffID()

	for iter0_27, iter1_27 in pairs(arg0_27._shipTFList) do
		if arg0_27._preSelectedList[iter0_27] then
			local var2_27 = iter1_27:Find("buff/value")
			local var3_27 = var0_27:GetShip(iter0_27)
			local var4_27 = var3_27:GetBuff(var1_27):GetFloor()
			local var5_27 = var3_27:IsBuffMax(var1_27)

			setText(var2_27, var5_27 and "Lv.MAX" or "Lv." .. var4_27)

			if var5_27 then
				triggerButton(iter1_27)
			else
				arg0_27:updateSelectShipBuff(iter1_27, true)
			end

			local var6_27 = iter1_27:Find("buff/bg/levelup(Clone)")

			if IsNil(var6_27) then
				PoolMgr.GetInstance():GetUI("levelup", true, function(arg0_28)
					if IsNil(arg0_27._tf) then
						PoolMgr.GetInstance():ReturnUI("levelup", arg0_28)
					else
						setParent(arg0_28, iter1_27:Find("buff/bg"))
						setActive(arg0_28, false)
						setActive(arg0_28, true)
					end
				end)
			else
				setActive(var6_27, false)
				setActive(var6_27, true)
			end
		end
	end

	arg0_27._preSelectedList = nil
end

function var0_0.updateSelectShipHP(arg0_29, arg1_29, arg2_29, arg3_29)
	setActive(arg1_29:Find("selected"), arg2_29)

	local var0_29 = arg1_29:Find("hp/progress_bg/bar_preview")

	setActive(var0_29, arg2_29)

	local var1_29 = arg1_29:Find("hp/hp_text")

	setActive(var1_29, arg2_29)

	if arg2_29 then
		local var2_29 = WPool:Get(WorldMapShip)

		var2_29.id = arg3_29.id
		var2_29.hpRant = arg3_29.hpRant
		var2_29.buffs = arg3_29.buffs

		local var3_29 = arg0_29.itemVO:getWorldItemType()

		if var3_29 == WorldItem.UsageHPRegenerate then
			var2_29:Regenerate(arg0_29.itemVO:getItemRegenerate())
		elseif var3_29 == WorldItem.UsageHPRegenerateValue then
			var2_29:RegenerateValue(arg0_29.itemVO:getItemRegenerate())
		else
			assert(false, "world item type error:" .. arg0_29.itemVO.id)
		end

		setImageColor(var0_29, var2_29:IsHpSafe() and Color.New(0.615686274509804, 0.917647058823529, 0.235294117647059, 0.6) or Color.New(0.925490196078431, 0, 0, 0.6))

		var0_29:GetComponent(typeof(Image)).fillAmount = var2_29.hpRant / 10000

		setText(var1_29, math.floor(arg3_29.hpRant / 100) .. "%" .. setColorStr("->" .. math.floor(var2_29.hpRant / 100) .. "%", COLOR_GREEN))
		WPool:Return(var2_29)
	end
end

function var0_0.updateSelectShipBuff(arg0_30, arg1_30, arg2_30)
	setActive(arg1_30:Find("selected"), arg2_30)
end

function var0_0.initHP(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg1_31:Find("buff")
	local var1_31 = arg1_31:Find("hp")

	setActive(var1_31, true)
	setActive(var0_31, false)
	arg0_31:updateSelectShipHP(arg1_31, false)

	local var2_31 = var1_31:Find("progress_bg/bar")

	setImageColor(var2_31, arg2_31:IsHpSafe() and Color.New(0.615686274509804, 0.917647058823529, 0.235294117647059) or Color.New(0.925490196078431, 0, 0))

	var2_31:GetComponent(typeof(Image)).fillAmount = arg2_31.hpRant / 10000

	setActive(var1_31:Find("broken"), arg2_31:IsBroken())
	onButton(arg0_31, arg1_31, function()
		if table.contains(arg0_31._selectedShipList, arg2_31) then
			if #arg0_31._selectedShipList <= 0 then
				return
			end

			arg0_31:updateSelectShipHP(arg1_31, false)

			for iter0_32, iter1_32 in ipairs(arg0_31._selectedShipList) do
				if iter1_32 == arg2_31 then
					table.remove(arg0_31._selectedShipList, iter0_32)

					break
				end
			end
		else
			while #arg0_31._selectedShipList >= arg0_31.quota do
				local var0_32 = arg0_31._shipTFList[arg0_31._selectedShipList[1].id]

				arg0_31:updateSelectShipHP(var0_32, false)
				table.remove(arg0_31._selectedShipList, 1)
			end

			arg0_31:updateSelectShipHP(arg1_31, true, arg2_31)
			table.insert(arg0_31._selectedShipList, arg2_31)
		end

		arg0_31:updateQuota()
	end)

	return not arg2_31:IsHpFull()
end

function var0_0.initBuff(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg1_33:Find("hp")
	local var1_33 = arg1_33:Find("buff")
	local var2_33 = var1_33:Find("icon")
	local var3_33 = var1_33:Find("value")

	setActive(var0_33, false)
	setActive(var1_33, true)
	arg0_33:updateSelectShipBuff(arg1_33, false)

	local var4_33 = arg0_33.itemVO:getItemBuffID()
	local var5_33 = WorldBuff.GetTemplate(var4_33).buff_attr[1]

	GetImageSpriteFromAtlasAsync("attricon", var5_33, var2_33)

	local var6_33 = arg2_33:GetBuff(var4_33):GetFloor()
	local var7_33 = arg2_33:IsBuffMax(var4_33)
	local var8_33 = arg0_33._shipVOList[arg2_33.id]:getBaseProperties()[var5_33] > 0

	setText(var3_33, not var8_33 and "Lv.-" or var7_33 and "Lv.MAX" or "Lv." .. var6_33)
	onButton(arg0_33, arg1_33, function()
		if table.contains(arg0_33._selectedShipList, arg2_33) then
			if #arg0_33._selectedShipList <= 0 then
				return
			end

			for iter0_34, iter1_34 in ipairs(arg0_33._selectedShipList) do
				if iter1_34 == arg2_33 then
					table.remove(arg0_33._selectedShipList, iter0_34)

					break
				end
			end

			arg0_33:updateSelectShipBuff(arg1_33, false)
		else
			if #arg0_33._selectedShipList >= arg0_33.quota then
				return
			end

			arg0_33:updateSelectShipBuff(arg1_33, true)
			table.insert(arg0_33._selectedShipList, arg2_33)
		end

		arg0_33:updateQuota()
	end)

	return var8_33 and not var7_33
end

function var0_0.willExit(arg0_35)
	setParent(arg0_35.shipTpl, arg0_35.fleetInfo, false)
	setParent(arg0_35.emptyTpl, arg0_35.fleetInfo, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_35._tf)
end

return var0_0
