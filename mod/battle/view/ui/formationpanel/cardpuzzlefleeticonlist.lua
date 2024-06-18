ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleCardPuzzleConfig
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent

var0_0.Battle.CardPuzzleFleetIconList = class("CardPuzzleFleetIconList")

local var4_0 = var0_0.Battle.CardPuzzleFleetIconList

var4_0.__name = "CardPuzzleFleetIconList"

function var4_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:init()
end

function var4_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	var0_0.EventListener.AttachEventListener(arg0_2)

	arg0_2._info = arg1_2
	arg0_2._attrManager = arg0_2._info:GetAttrManager()
	arg0_2._buffManager = arg0_2._info:GetBuffManager()

	arg0_2._info:RegisterEventListener(arg0_2, var3_0.UPDATE_FLEET_ATTR, arg0_2.onUpdateFleetAttr)
end

function var4_0.init(arg0_3)
	arg0_3._buffIconList = {}
	arg0_3._attrIconList = {}
	arg0_3._tf = arg0_3._go.transform
	arg0_3._iconTpl = arg0_3._tf:Find("icon_tpl")
	arg0_3._iconContainer = arg0_3._tf:Find("icon_list")
end

function var4_0.AddBuffIcon(arg0_4, arg1_4)
	local var0_4 = cloneTplTo(arg0_4._iconTpl, arg0_4._iconContainer)
	local var1_4 = var0_4:Find("count_bg/count_label")
	local var2_4 = var0_4:Find("icon")
	local var3_4 = var0_4:Find("buff_duration"):GetComponent(typeof(Image))
	local var4_4 = {
		tf = var0_4,
		count = var1_4,
		durationIMG = var3_4,
		buffID = arg1_4
	}

	arg0_4._buffIconList[arg1_4] = var4_4

	arg0_4:updateBuffIcon(var4_4)
end

function var4_0.AddAttrIcon(arg0_5, arg1_5)
	local var0_5 = cloneTplTo(arg0_5._iconTpl, arg0_5._iconContainer)
	local var1_5 = var0_5:Find("count_bg/count_label")
	local var2_5 = var0_5:Find("icon")
	local var3_5 = {
		tf = var0_5,
		count = var1_5,
		attr = arg1_5
	}

	arg0_5._attrIconList[arg1_5] = var3_5

	arg0_5:updateAttrIcon(var3_5)
end

function var4_0.onUpdateFleetAttr(arg0_6, arg1_6)
	local var0_6 = arg1_6.Data.attrName

	if var2_0.FleetIconRegisterAttr[var0_6] then
		local var1_6 = arg0_6._attrIconList[var0_6]

		if var1_6 then
			arg0_6:updateAttrIcon(var1_6)
		else
			arg0_6:AddAttrIcon(var0_6)
		end
	end
end

function var4_0.updateAttrIcon(arg0_7, arg1_7)
	local var0_7 = arg1_7.count
	local var1_7 = arg1_7.attr
	local var2_7 = arg0_7._attrManager:GetCurrent(var1_7)

	setText(var0_7, var2_7)
end

function var4_0.updateBuffIcon(arg0_8, arg1_8)
	local var0_8 = arg1_8.buffID
	local var1_8 = arg0_8._buffManager:GetCardPuzzleBuff(var0_8)
	local var2_8 = arg1_8.count
	local var3_8 = var1_8:GetStack()

	setText(var2_8, var3_8)

	arg1_8.durationIMG.fillAmount = var1_8:GetDurationRate()
end

function var4_0.Update(arg0_9)
	local var0_9 = arg0_9._buffManager:GetCardPuzzleBuffList()

	for iter0_9, iter1_9 in pairs(var0_9) do
		if var2_0.FleetIconRegisterBuff[iter0_9] then
			local var1_9 = arg0_9._buffIconList[iter0_9]

			if var1_9 == nil then
				arg0_9:AddBuffIcon(iter0_9)
			else
				arg0_9:updateBuffIcon(var1_9)
			end
		end
	end
end

function var4_0.Dispose(arg0_10)
	arg0_10._buffIconList = nil
	arg0_10._attrIconList = nil
	arg0_10._tf = nil
	arg0_10._iconTpl = nil
	arg0_10._iconContainer = nil
end
