ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = class("BattleAirStrikeIconView")

var0_0.Battle.BattleAirStrikeIconView = var2_0
var2_0.__name = "BattleAirStrikeIconView"
var2_0.DEFAULT_ICON_NAME = "99shijianbao"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._iconList = {}

	arg0_1:ConfigIconSkin(arg1_1)
end

function var2_0.ConfigIconSkin(arg0_2, arg1_2)
	arg0_2._iconTpl = arg1_2
	arg0_2._iconContainer = arg1_2.parent
end

function var2_0.AppendIcon(arg0_3, arg1_3, arg2_3)
	local var0_3 = cloneTplTo(arg0_3._iconTpl, arg0_3._iconContainer).gameObject
	local var1_3 = var0_3.transform:Find("FighterIcon")

	var0_3:SetActive(true)
	arg0_3:setIconNumber(var1_3, arg2_3.totalNumber)

	local var2_3 = var1_0.GetAircraftTmpDataFromID(arg2_3.templateID).icon or var2_0.DEFAULT_ICON_NAME
	local var3_3 = var0_0.Battle.BattleResourceManager.GetInstance():GetAircraftIcon(var2_3)

	setImageSprite(var1_3, var3_3)

	arg0_3._iconList[arg1_3] = var0_3
end

function var2_0.RemoveIcon(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4._iconList[arg1_4]

	if not var0_4 then
		return
	end

	if arg2_4.totalNumber <= 0 then
		Object.Destroy(var0_4)

		arg0_4._iconList[arg1_4] = nil
	else
		arg0_4:setIconNumber(var0_4.transform:Find("FighterIcon"), arg2_4.totalNumber)
	end
end

function var2_0.Dispose(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5._iconList) do
		Object.Destroy(iter1_5)
	end

	arg0_5._iconList = nil
end

function var2_0.setIconNumber(arg0_6, arg1_6, arg2_6)
	arg1_6.transform:Find("FighterNum"):GetComponent(typeof(Text)).text = "X" .. arg2_6
end
