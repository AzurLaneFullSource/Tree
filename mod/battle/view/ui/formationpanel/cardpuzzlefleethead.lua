ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleCardPuzzleEvent

var0_0.Battle.CardPuzzleFleetHead = class("CardPuzzleFleetHead")

local var3_0 = var0_0.Battle.CardPuzzleFleetHead

var3_0.__name = "CardPuzzleFleetHead"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg0_1._go.transform
	arg0_1._mainIcon = arg0_1._tf:Find("main/icon")
	arg0_1._scoutIcon = arg0_1._tf:Find("scout/icon")
	arg0_1._testAttrContainer = arg0_1._tf:Find("test_attr_list")
	arg0_1._testAttrTpl = arg0_1._tf:Find("test_attr_tpl")
	arg0_1._testAttrList = {}
	arg0_1._loader = AutoLoader.New()
end

function var3_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	var0_0.EventListener.AttachEventListener(arg0_2)

	arg0_2._info = arg1_2

	if TEST_ATTR_PANEL then
		arg0_2._info:RegisterEventListener(arg0_2, var2_0.UPDATE_FLEET_ATTR, arg0_2.onUpdateFleetAttr)
		arg0_2:onUpdateFleetAttr()
	end
end

function var3_0.Update(arg0_3)
	return
end

function var3_0.UpdateShipIcon(arg0_4, arg1_4)
	local var0_4
	local var1_4

	if arg1_4 == TeamType.TeamPos.FLAG_SHIP then
		var0_4 = arg0_4._info:GetMainUnit()
		var1_4 = arg0_4._mainIcon
	elseif arg1_4 == TeamType.TeamPos.LEADER then
		var0_4 = arg0_4._info:GetScoutUnit()
		var1_4 = arg0_4._scoutIcon
	end

	local var2_4 = CardPuzzleShip.getPaintingName(var0_4:GetTemplate().id)

	arg0_4._loader:GetSprite("cardtowerselectships/" .. var2_4 .. "_select", "", var1_4)
end

function var3_0.UpdateShipBuff(arg0_5)
	return
end

function var3_0.onUpdateFleetAttr(arg0_6)
	local var0_6 = arg0_6._info:GetAttrManager()._attrList

	for iter0_6, iter1_6 in pairs(var0_6) do
		if arg0_6._testAttrList[iter0_6] == nil then
			local var1_6 = cloneTplTo(arg0_6._testAttrTpl, arg0_6._testAttrContainer)

			arg0_6._testAttrList[iter0_6] = var1_6

			setText(var1_6:Find("name"), iter0_6)
		end

		local var2_6 = arg0_6._testAttrList[iter0_6]
		local var3_6 = arg0_6._info:GetAttrManager():GetCurrent(iter0_6)

		setText(var2_6:Find("value"), var3_6)
	end
end

function var3_0.updateHPBar(arg0_7)
	return
end

function var3_0.Dispose(arg0_8)
	arg0_8._mainIcon = nil
	arg0_8._scoutIcon = nil
	arg0_8._testAttrContainer = nil
	arg0_8._testAttrTpl = nil
	arg0_8._testAttrList = nil

	arg0_8._loader:Clear()
end
