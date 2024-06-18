local var0_0 = class("CourtYardRightPanel", import(".CourtYardBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "main/rightPanel"
end

function var0_0.init(arg0_2)
	arg0_2.buffBtn = arg0_2._tf:Find("buff")
	arg0_2.oneKeyBtn = arg0_2._tf:Find("onekey")
	arg0_2.buffPage = CourtYardBuffPage.New(arg0_2._tf.parent.parent, arg0_2.parent)
end

function var0_0.GenBuffData(arg0_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(BuffHelper.GetBackYardPlayerBuffs()) do
		if iter1_3:isActivate() then
			table.insert(var0_3, iter1_3)
		end
	end

	return var0_3
end

function var0_0.OnRegister(arg0_4)
	onButton(arg0_4, arg0_4.buffBtn, function()
		local var0_5 = arg0_4.buffList or arg0_4:GenBuffData()

		if #var0_5 > 0 then
			arg0_4.buffPage:ExecuteAction("Show", var0_5)
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.oneKeyBtn, function()
		arg0_4:emit(CourtYardMediator.ONE_KEY)
	end, SFX_PANEL)
end

function var0_0.OnVisitRegister(arg0_7)
	setActive(arg0_7._tf, false)
end

function var0_0.OnFlush(arg0_8, arg1_8)
	arg1_8 = arg1_8 or bit.bor(BackYardConst.DORM_UPDATE_TYPE_LEVEL, BackYardConst.DORM_UPDATE_TYPE_USEFOOD, BackYardConst.DORM_UPDATE_TYPE_SHIP)

	local var0_8 = arg0_8.dorm

	if bit.band(arg1_8, BackYardConst.DORM_UPDATE_TYPE_USEFOOD) > 0 and arg0_8:IsInner() then
		arg0_8.buffList = arg0_8:GenBuffData()

		setActive(arg0_8.buffBtn, #arg0_8.buffList > 0)
	end

	if bit.band(arg1_8, BackYardConst.DORM_UPDATE_TYPE_SHIP) > 0 then
		setActive(arg0_8.oneKeyBtn, var0_8:AnyShipExistIntimacyOrMoney())
	end
end

function var0_0.GetMoveX(arg0_9)
	return {
		{
			arg0_9._tf,
			1
		}
	}
end

function var0_0.OnDispose(arg0_10)
	if arg0_10.buffPage then
		arg0_10.buffPage:Destroy()

		arg0_10.buffPage = nil
	end
end

return var0_0
