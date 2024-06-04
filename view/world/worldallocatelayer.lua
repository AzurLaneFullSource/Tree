local var0 = class("WorldAllocateLayer", import("..base.BaseUI"))

var0.TeamNum = {
	"FIRST",
	"SECOND",
	"THIRD",
	"FOURTH",
	"FIFTH",
	"SIXTH"
}

function var0.getUIName(arg0)
	return "WorldAllocateUI"
end

function var0.init(arg0)
	arg0._selectedShipList = {}
	arg0._shipTFList = {}
	arg0._shipVOList = {}
	arg0.cancelBtn = arg0:findTF("actions/cancel_button")
	arg0.confirmBtn = arg0:findTF("actions/compose_button")
	arg0.itemTF = arg0:findTF("item")
	arg0.nameTF = arg0:findTF("item/name_container/name")
	arg0.descTF = arg0:findTF("item/desc")
	arg0.fleetInfo = arg0:findTF("fleet_info")

	setText(arg0.fleetInfo:Find("top/Text"), i18n("world_ship_repair"))

	arg0.shipTpl = arg0:getTpl("fleet_info/shiptpl")
	arg0.emptyTpl = arg0:getTpl("fleet_info/emptytpl")
	arg0.shipsContainer = arg0:findTF("fleet_info/contain")
	arg0.descLabel = arg0:findTF("fleet_info/top/Text")

	setText(arg0.fleetInfo:Find("tip/Text"), i18n("world_battle_damage"))

	arg0.countLabel = arg0:findTF("count")
	arg0.quotaTxt = arg0:findTF("count/value")
	arg0.btnFleet = arg0:findTF("fleets/selected")
	arg0.fleetToggleMask = arg0:findTF("fleets/list_mask")
	arg0.fleetToggleList = arg0.fleetToggleMask:Find("list")

	onButton(arg0, arg0.cancelBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.itemVO.count == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end

		local function var0()
			local var0 = {}

			arg0._preSelectedList = {}

			for iter0, iter1 in ipairs(arg0._selectedShipList) do
				var0[#var0 + 1] = iter1.id
				arg0._preSelectedList[iter1.id] = true
			end

			arg0.confirmCallback(arg0.itemVO.configId, var0)
		end

		if #arg0._selectedShipList > 0 then
			local var1 = false
			local var2 = arg0.itemVO:getWorldItemType()

			if var2 == WorldItem.UsageBuff then
				local var3 = arg0.itemVO:getItemBuffID()

				var1 = _.any(arg0._selectedShipList, function(arg0)
					return arg0:IsBuffMax()
				end)
			elseif var2 == WorldItem.UsageHPRegenerate or var2 == WorldItem.UsageHPRegenerateValue then
				var1 = _.any(arg0._selectedShipList, function(arg0)
					return arg0:IsHpFull()
				end)
			end

			if var1 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_ship_healthy"),
					onYes = var0
				})
			else
				var0()
			end
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.fleetToggleMask, function()
		arg0:showOrHideToggleMask(false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnFleet, function()
		arg0:showOrHideToggleMask(true)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("item/reset_btn"), function()
		assert(arg0.contextData.onResetInfo, "without reset info callback")
		arg0.contextData.onResetInfo(Drop.New({
			count = 1,
			type = DROP_TYPE_WORLD_ITEM,
			id = arg0.itemVO.id
		}))
	end)
end

function var0.didEnter(arg0)
	arg0:updateToggleList(arg0.fleetList, arg0.contextData.fleetIndex or 1)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false)
end

function var0.showOrHideToggleMask(arg0, arg1)
	setActive(arg0.fleetToggleMask, arg1)
	arg0:tweenTabArrow(not arg1)
end

function var0.setFleets(arg0, arg1, arg2)
	arg0.fleetList = arg1
end

function var0.setConfirmCallback(arg0, arg1)
	arg0.confirmCallback = arg1
end

function var0.setItem(arg0, arg1)
	arg0.itemVO = arg1

	updateDrop(arg0.itemTF, Drop.New({
		type = DROP_TYPE_WORLD_ITEM,
		id = arg1.id,
		count = arg1.count
	}))
	setText(arg0.nameTF, arg1:getConfig("name"))
	setText(arg0.descTF, arg1:getConfig("display"))

	arg0.quota = arg0.itemVO:getItemQuota()

	arg0:updateQuota()
end

function var0.updateQuota(arg0)
	setText(arg0.quotaTxt, #arg0._selectedShipList .. "/" .. arg0.quota)
	setActive(arg0.countLabel, true)
end

function var0.flush(arg0, arg1)
	if arg1.id ~= arg0.itemVO.id then
		return
	end

	arg0:setItem(arg0.itemVO)

	local var0 = arg0.itemVO:getWorldItemType()

	if var0 == WorldItem.UsageBuff then
		arg0:OnUpdateShipBuff()
	elseif var0 == WorldItem.UsageHPRegenerate or var0 == WorldItem.UsageHPRegenerateValue then
		arg0:OnUpdateShipHP()
	end
end

function var0.updateToggleList(arg0, arg1, arg2)
	setActive(arg0.fleetToggleList, true)

	local var0

	for iter0 = 1, arg0.fleetToggleList.childCount do
		local var1 = arg0.fleetToggleList:GetChild(arg0.fleetToggleList.childCount - iter0)

		setActive(var1, arg1[iter0])

		if arg1[iter0] then
			setActive(var1:Find("lock"), false)
			setText(var1:Find("on/mask/text"), i18n("world_fleetName" .. iter0))
			setText(var1:Find("on/mask/en"), var0.TeamNum[iter0] .. " FLEET")
			setText(var1:Find("on/mask/number"), iter0)
			setText(var1:Find("off/mask/text"), i18n("world_fleetName" .. iter0))
			setText(var1:Find("off/mask/en"), var0.TeamNum[iter0] .. " FLEET")
			setText(var1:Find("off/mask/number"), iter0)
			onToggle(arg0, var1, function(arg0)
				if arg0 then
					arg0:showOrHideToggleMask(false)
					arg0:setFleet(arg1[iter0].id)
					arg0:updateQuota()
				end
			end, SFX_UI_TAG)

			if arg1[iter0].id == arg2 then
				var0 = var1
			end
		end
	end

	if var0 then
		triggerToggle(var0, true)
	end
end

function var0.updateFleetButton(arg0, arg1)
	setText(arg0.btnFleet:Find("fleet/CnFleet"), i18n("world_fleetName" .. arg1))
	setText(arg0.btnFleet:Find("fleet/enFleet"), var0.TeamNum[arg1] .. " FLEET")
	setText(arg0.btnFleet:Find("fleet/num"), arg1)
end

function var0.tweenTabArrow(arg0, arg1)
	local var0 = arg0.btnFleet:Find("arr")

	setActive(var0, arg1)

	if arg1 then
		LeanTween.moveLocalY(go(var0), var0.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
	else
		LeanTween.cancel(go(var0))

		local var1 = var0.localPosition

		var1.y = 80
		var0.localPosition = var1
	end
end

function var0.setFleet(arg0, arg1)
	arg0:updateFleetButton(arg1)

	local var0 = arg0.itemVO:getWorldItemType()

	for iter0, iter1 in pairs(arg0._shipTFList) do
		local var1 = iter1:Find("buff/bg/levelup(Clone)")

		if not IsNil(var1) then
			PoolMgr.GetInstance():ReturnUI("levelup", var1)
		end
	end

	removeAllChildren(arg0.shipsContainer)

	arg0.currentFleetIndex = arg1
	arg0._selectedShipList = {}
	arg0._shipTFList = {}

	local var2 = arg0.fleetList[arg0.currentFleetIndex]:GetShips(true)
	local var3 = underscore.map(var2, function(arg0)
		return WorldConst.FetchShipVO(arg0.id)
	end)
	local var4 = arg0.quota

	for iter2 = 1, 6 do
		local var5 = var2[iter2]
		local var6 = var3[iter2]

		if var2[iter2] then
			local var7 = cloneTplTo(arg0.shipTpl, arg0.shipsContainer)

			arg0._shipTFList[var5.id] = var7
			arg0._shipVOList[var6.id] = var6

			updateShip(var7, var6, {
				initStar = true
			})

			local var8 = false

			if var0 == WorldItem.UsageBuff then
				var8 = arg0:initBuff(var7, var5)
			elseif var0 == WorldItem.UsageHPRegenerate or var0 == WorldItem.UsageHPRegenerateValue then
				var8 = arg0:initHP(var7, var5)
			end

			if var4 > 0 and var8 then
				triggerButton(var7)

				var4 = var4 - 1
			end
		else
			local var9 = cloneTplTo(arg0.emptyTpl, arg0.shipsContainer)
		end
	end

	setActive(arg0.fleetInfo:Find("tip"), underscore.any(var2, function(arg0)
		return arg0:IsBroken()
	end))
end

function var0.OnUpdateShipHP(arg0)
	local var0 = arg0.fleetList[arg0.currentFleetIndex]
	local var1 = arg0.itemVO:getItemBuffID()

	for iter0, iter1 in pairs(arg0._shipTFList) do
		if arg0._preSelectedList[iter0] then
			local var2 = var0:GetShip(iter0)
			local var3 = iter1:Find("hp")
			local var4 = var3:Find("progress_bg/bar")

			setImageColor(var4, var2:IsHpSafe() and Color.New(0.615686274509804, 0.917647058823529, 0.235294117647059) or Color.New(0.615686274509804, 0.917647058823529, 0.235294117647059))

			local var5 = var4:GetComponent(typeof(Image)).fillAmount
			local var6 = var2.hpRant / 10000

			if var5 < var6 then
				LeanTween.value(go(var4), var5, var6, var6 - var5):setOnUpdate(System.Action_float(function(arg0)
					var4:GetComponent(typeof(Image)).fillAmount = arg0
				end))
			end

			setActive(var3:Find("broken"), var2:IsBroken())

			if var2:IsHpFull() then
				triggerButton(iter1)
			else
				arg0:updateSelectShipHP(iter1, true, var2)
			end
		end
	end

	arg0._preSelectedList = nil
end

function var0.OnUpdateShipBuff(arg0)
	local var0 = arg0.fleetList[arg0.currentFleetIndex]
	local var1 = arg0.itemVO:getItemBuffID()

	for iter0, iter1 in pairs(arg0._shipTFList) do
		if arg0._preSelectedList[iter0] then
			local var2 = iter1:Find("buff/value")
			local var3 = var0:GetShip(iter0)
			local var4 = var3:GetBuff(var1):GetFloor()
			local var5 = var3:IsBuffMax(var1)

			setText(var2, var5 and "Lv.MAX" or "Lv." .. var4)

			if var5 then
				triggerButton(iter1)
			else
				arg0:updateSelectShipBuff(iter1, true)
			end

			local var6 = iter1:Find("buff/bg/levelup(Clone)")

			if IsNil(var6) then
				PoolMgr.GetInstance():GetUI("levelup", true, function(arg0)
					if IsNil(arg0._tf) then
						PoolMgr.GetInstance():ReturnUI("levelup", arg0)
					else
						setParent(arg0, iter1:Find("buff/bg"))
						setActive(arg0, false)
						setActive(arg0, true)
					end
				end)
			else
				setActive(var6, false)
				setActive(var6, true)
			end
		end
	end

	arg0._preSelectedList = nil
end

function var0.updateSelectShipHP(arg0, arg1, arg2, arg3)
	setActive(arg1:Find("selected"), arg2)

	local var0 = arg1:Find("hp/progress_bg/bar_preview")

	setActive(var0, arg2)

	local var1 = arg1:Find("hp/hp_text")

	setActive(var1, arg2)

	if arg2 then
		local var2 = WPool:Get(WorldMapShip)

		var2.id = arg3.id
		var2.hpRant = arg3.hpRant
		var2.buffs = arg3.buffs

		local var3 = arg0.itemVO:getWorldItemType()

		if var3 == WorldItem.UsageHPRegenerate then
			var2:Regenerate(arg0.itemVO:getItemRegenerate())
		elseif var3 == WorldItem.UsageHPRegenerateValue then
			var2:RegenerateValue(arg0.itemVO:getItemRegenerate())
		else
			assert(false, "world item type error:" .. arg0.itemVO.id)
		end

		setImageColor(var0, var2:IsHpSafe() and Color.New(0.615686274509804, 0.917647058823529, 0.235294117647059, 0.6) or Color.New(0.925490196078431, 0, 0, 0.6))

		var0:GetComponent(typeof(Image)).fillAmount = var2.hpRant / 10000

		setText(var1, math.floor(arg3.hpRant / 100) .. "%" .. setColorStr("->" .. math.floor(var2.hpRant / 100) .. "%", COLOR_GREEN))
		WPool:Return(var2)
	end
end

function var0.updateSelectShipBuff(arg0, arg1, arg2)
	setActive(arg1:Find("selected"), arg2)
end

function var0.initHP(arg0, arg1, arg2)
	local var0 = arg1:Find("buff")
	local var1 = arg1:Find("hp")

	setActive(var1, true)
	setActive(var0, false)
	arg0:updateSelectShipHP(arg1, false)

	local var2 = var1:Find("progress_bg/bar")

	setImageColor(var2, arg2:IsHpSafe() and Color.New(0.615686274509804, 0.917647058823529, 0.235294117647059) or Color.New(0.925490196078431, 0, 0))

	var2:GetComponent(typeof(Image)).fillAmount = arg2.hpRant / 10000

	setActive(var1:Find("broken"), arg2:IsBroken())
	onButton(arg0, arg1, function()
		if table.contains(arg0._selectedShipList, arg2) then
			if #arg0._selectedShipList <= 0 then
				return
			end

			arg0:updateSelectShipHP(arg1, false)

			for iter0, iter1 in ipairs(arg0._selectedShipList) do
				if iter1 == arg2 then
					table.remove(arg0._selectedShipList, iter0)

					break
				end
			end
		else
			while #arg0._selectedShipList >= arg0.quota do
				local var0 = arg0._shipTFList[arg0._selectedShipList[1].id]

				arg0:updateSelectShipHP(var0, false)
				table.remove(arg0._selectedShipList, 1)
			end

			arg0:updateSelectShipHP(arg1, true, arg2)
			table.insert(arg0._selectedShipList, arg2)
		end

		arg0:updateQuota()
	end)

	return not arg2:IsHpFull()
end

function var0.initBuff(arg0, arg1, arg2)
	local var0 = arg1:Find("hp")
	local var1 = arg1:Find("buff")
	local var2 = var1:Find("icon")
	local var3 = var1:Find("value")

	setActive(var0, false)
	setActive(var1, true)
	arg0:updateSelectShipBuff(arg1, false)

	local var4 = arg0.itemVO:getItemBuffID()
	local var5 = WorldBuff.GetTemplate(var4).buff_attr[1]

	GetImageSpriteFromAtlasAsync("attricon", var5, var2)

	local var6 = arg2:GetBuff(var4):GetFloor()
	local var7 = arg2:IsBuffMax(var4)
	local var8 = arg0._shipVOList[arg2.id]:getBaseProperties()[var5] > 0

	setText(var3, not var8 and "Lv.-" or var7 and "Lv.MAX" or "Lv." .. var6)
	onButton(arg0, arg1, function()
		if table.contains(arg0._selectedShipList, arg2) then
			if #arg0._selectedShipList <= 0 then
				return
			end

			for iter0, iter1 in ipairs(arg0._selectedShipList) do
				if iter1 == arg2 then
					table.remove(arg0._selectedShipList, iter0)

					break
				end
			end

			arg0:updateSelectShipBuff(arg1, false)
		else
			if #arg0._selectedShipList >= arg0.quota then
				return
			end

			arg0:updateSelectShipBuff(arg1, true)
			table.insert(arg0._selectedShipList, arg2)
		end

		arg0:updateQuota()
	end)

	return var8 and not var7
end

function var0.willExit(arg0)
	setParent(arg0.shipTpl, arg0.fleetInfo, false)
	setParent(arg0.emptyTpl, arg0.fleetInfo, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
