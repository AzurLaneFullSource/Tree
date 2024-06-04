ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleCardPuzzleEvent

var0.Battle.CardPuzzleFleetHead = class("CardPuzzleFleetHead")

local var3 = var0.Battle.CardPuzzleFleetHead

var3.__name = "CardPuzzleFleetHead"

function var3.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg0._go.transform
	arg0._mainIcon = arg0._tf:Find("main/icon")
	arg0._scoutIcon = arg0._tf:Find("scout/icon")
	arg0._testAttrContainer = arg0._tf:Find("test_attr_list")
	arg0._testAttrTpl = arg0._tf:Find("test_attr_tpl")
	arg0._testAttrList = {}
	arg0._loader = AutoLoader.New()
end

function var3.SetCardPuzzleComponent(arg0, arg1)
	var0.EventListener.AttachEventListener(arg0)

	arg0._info = arg1

	if TEST_ATTR_PANEL then
		arg0._info:RegisterEventListener(arg0, var2.UPDATE_FLEET_ATTR, arg0.onUpdateFleetAttr)
		arg0:onUpdateFleetAttr()
	end
end

function var3.Update(arg0)
	return
end

function var3.UpdateShipIcon(arg0, arg1)
	local var0
	local var1

	if arg1 == TeamType.TeamPos.FLAG_SHIP then
		var0 = arg0._info:GetMainUnit()
		var1 = arg0._mainIcon
	elseif arg1 == TeamType.TeamPos.LEADER then
		var0 = arg0._info:GetScoutUnit()
		var1 = arg0._scoutIcon
	end

	local var2 = CardPuzzleShip.getPaintingName(var0:GetTemplate().id)

	arg0._loader:GetSprite("cardtowerselectships/" .. var2 .. "_select", "", var1)
end

function var3.UpdateShipBuff(arg0)
	return
end

function var3.onUpdateFleetAttr(arg0)
	local var0 = arg0._info:GetAttrManager()._attrList

	for iter0, iter1 in pairs(var0) do
		if arg0._testAttrList[iter0] == nil then
			local var1 = cloneTplTo(arg0._testAttrTpl, arg0._testAttrContainer)

			arg0._testAttrList[iter0] = var1

			setText(var1:Find("name"), iter0)
		end

		local var2 = arg0._testAttrList[iter0]
		local var3 = arg0._info:GetAttrManager():GetCurrent(iter0)

		setText(var2:Find("value"), var3)
	end
end

function var3.updateHPBar(arg0)
	return
end

function var3.Dispose(arg0)
	arg0._mainIcon = nil
	arg0._scoutIcon = nil
	arg0._testAttrContainer = nil
	arg0._testAttrTpl = nil
	arg0._testAttrList = nil

	arg0._loader:Clear()
end
