ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleSkillEditCustomWarning
local var3_0 = class("BattleCommonWarningView")

var0_0.Battle.BattleCommonWarningView = var3_0
var3_0.__name = "BattleCommonWarningView"
var3_0.WARNING_TYPE_SUBMARINE = "submarine"
var3_0.WARNING_TYPE_ARTILLERY = "artillery"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._submarineCount = 0
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._subIcon = arg0_1._tf:Find("submarineIcon")
	arg0_1._tips = arg0_1._tf:Find("warningTips")
	arg0_1._subWarn = arg0_1._tf:Find("submarineWarningTips")
	arg0_1._warningRequestTable = {
		{
			flag = false,
			type = var3_0.WARNING_TYPE_ARTILLERY,
			tf = arg0_1._tips
		},
		{
			flag = false,
			type = var3_0.WARNING_TYPE_SUBMARINE,
			tf = arg0_1._subWarn
		}
	}
	arg0_1._customWarningTpl = arg0_1._tf:Find("customWarningTpl")
	arg0_1._customWarningContainer = arg0_1._tf:Find("customWarningContainer")
	arg0_1._customWarningList = {}
end

function var3_0.UpdateHostileSubmarineCount(arg0_2, arg1_2)
	if arg1_2 > 0 and arg0_2._submarineCount <= 0 then
		arg0_2:activeSubmarineWarning()
	elseif arg0_2._submarineCount > 0 and arg1_2 <= 0 then
		arg0_2:deactiveSubmarineWarning()
	end

	arg0_2._submarineCount = arg1_2
end

function var3_0.GetCount(arg0_3)
	return arg0_3._submarineCount
end

function var3_0.ActiveWarning(arg0_4, arg1_4)
	local var0_4 = false
	local var1_4 = #arg0_4._warningRequestTable

	for iter0_4, iter1_4 in ipairs(arg0_4._warningRequestTable) do
		if arg1_4 == iter1_4.type then
			iter1_4.flag = true

			if not var0_4 then
				SetActive(iter1_4.tf, true)

				var1_4 = iter0_4
			else
				break
			end
		else
			var0_4 = var0_4 or iter1_4.flag

			if iter1_4.flag and var1_4 < iter0_4 then
				SetActive(iter1_4.tf, false)
			end
		end
	end
end

function var3_0.DeactiveWarning(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5._warningRequestTable) do
		if arg1_5 == iter1_5.type then
			iter1_5.flag = false

			SetActive(iter1_5.tf, false)
		elseif iter1_5.flag then
			arg0_5:ActiveWarning(iter1_5.type)

			break
		end
	end
end

function var3_0.EditCustomWarning(arg0_6, arg1_6)
	local var0_6 = arg1_6.op
	local var1_6 = arg1_6.key

	if var0_6 == var2_0.OP_ADD then
		local var2_6 = cloneTplTo(arg0_6._customWarningTpl, arg0_6._customWarningContainer)
		local var3_6 = var0_0.Battle.BattleCustomWarningLabel.New(var2_6)

		var3_6:ConfigData(arg1_6)

		arg0_6._customWarningList[var1_6] = var3_6
	elseif var0_6 == var2_0.OP_REMOVE then
		local var4_6 = arg0_6._customWarningList[var1_6]

		if var4_6 then
			var4_6:SetExpire()
		end
	elseif var0_6 == var2_0.OP_REMOVE_PERMANENT then
		for iter0_6, iter1_6 in pairs(arg0_6._customWarningList) do
			if iter1_6:GetDuration() <= 0 then
				iter1_6:SetExpire()
			end
		end
	elseif var0_6 == var2_0.OP_REMOVE_TEMPLATE then
		for iter2_6, iter3_6 in pairs(arg0_6._customWarningList) do
			if iter3_6:GetDuration() > 0 then
				iter3_6:SetExpire()
			end
		end
	end
end

function var3_0.Update(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7._customWarningList) do
		iter1_7:Update()

		if iter1_7:IsExpire() then
			iter1_7:Dispose()

			arg0_7._customWarningList[iter0_7] = nil
		end
	end
end

function var3_0.activeSubmarineWarning(arg0_8)
	SetActive(arg0_8._subIcon, true)
	arg0_8:ActiveWarning(var3_0.WARNING_TYPE_SUBMARINE)
	LeanTween.cancel(go(arg0_8._subIcon))
	LeanTween.alpha(rtf(arg0_8._subIcon), 1, 2):setFrom(0)
end

function var3_0.deactiveSubmarineWarning(arg0_9)
	LeanTween.cancel(go(arg0_9._subIcon))
	LeanTween.alpha(rtf(arg0_9._subIcon), 0, 1):setFrom(1):setOnComplete(System.Action(function()
		SetActive(arg0_9._subIcon, false)
		arg0_9:DeactiveWarning(var3_0.WARNING_TYPE_SUBMARINE)
	end))
end

function var3_0.Dispose(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11._customWarningList) do
		iter1_11:Dispose()

		arg0_11._customWarningList[iter0_11] = nil
	end

	arg0_11._customWarningList = nil
	arg0_11._go = nil
	arg0_11._tf = nil
	arg0_11._icon = nil
	arg0_11._tips = nil
end
