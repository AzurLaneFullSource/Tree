local var0_0 = class("WinConditionDisplayPanel", BaseSubView)

function var0_0.getUIName(arg0_1)
	return "WinConditionDisplayPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.listTF = arg0_2._tf:Find("window/bg/awards/awardList")
	arg0_2.closeBtn = arg0_2._tf:Find("window/top/btnBack")
	arg0_2.winCondtitle = arg0_2:findTF("window/bg/winCond/title/text")

	setText(arg0_2.winCondtitle, i18n("text_win_condition"))

	arg0_2.winCondDesc = arg0_2:findTF("window/bg/winCond/desc")
	arg0_2.loseCondtitle = arg0_2:findTF("window/bg/loseCond/title/text")

	setText(arg0_2.loseCondtitle, i18n("text_lose_condition"))

	arg0_2.loseCondDesc = arg0_2:findTF("window/bg/loseCond/desc")
	arg0_2.rewardList = arg0_2:findTF("window/bg/awards")
	arg0_2.rewardtip = arg0_2:findTF("text", arg0_2.rewardList)

	setText(arg0_2.rewardtip, i18n("desc_defense_reward"))

	arg0_2.rewardWord = arg0_2:findTF("desc", arg0_2.rewardList)

	setText(arg0_2.rewardWord, i18n("word_reward"))

	arg0_2.rewardCond = arg0_2:findTF("cond", arg0_2.rewardList)

	setText(arg0_2.rewardCond, i18n("text_rest_HP"))
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)
end

local var1_0 = {
	"s",
	"a",
	"b"
}

function var0_0.UpdateList(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5

	if #arg3_5 == 3 then
		arg0_5.listTF:GetChild(1).gameObject:SetActive(true)
		arg0_5.listTF:GetChild(2).gameObject:SetActive(true)
		arg0_5.listTF:GetChild(3).gameObject:SetActive(true)

		var0_5 = {
			3,
			2,
			1
		}
	elseif #arg3_5 == 2 then
		arg0_5.listTF:GetChild(1).gameObject:SetActive(true)
		arg0_5.listTF:GetChild(2).gameObject:SetActive(false)
		arg0_5.listTF:GetChild(3).gameObject:SetActive(true)

		var0_5 = {
			3,
			1
		}
	elseif #arg3_5 == 1 then
		arg0_5.listTF:GetChild(1).gameObject:SetActive(false)
		arg0_5.listTF:GetChild(2).gameObject:SetActive(true)
		arg0_5.listTF:GetChild(3).gameObject:SetActive(false)

		var0_5 = {
			2
		}
	end

	local var1_5 = false

	for iter0_5 = 1, #arg3_5 do
		local var2_5 = arg0_5.listTF:GetChild(var0_5[iter0_5])
		local var3_5 = tostring(arg2_5[iter0_5] - 1)

		if arg2_5[iter0_5] - 1 ~= arg2_5[iter0_5 + 1] then
			var3_5 = tostring(arg2_5[iter0_5 + 1]) .. "-" .. var3_5
		end

		setText(var2_5:Find("text"), var3_5)

		local var4_5 = arg3_5[iter0_5]

		updateDrop(var2_5:Find("award"), var4_5, {
			hideName = true
		})
		onButton(arg0_5, var2_5:Find("award"), function()
			arg0_5:emit(BaseUI.ON_DROP, var4_5)
		end, SFX_PANEL)

		local var5_5 = not var1_5 and arg4_5 >= arg2_5[iter0_5 + 1]

		var1_5 = var1_5 or arg4_5 >= arg2_5[iter0_5 + 1]

		setActive(var2_5:Find("mask"), not var5_5)
	end
end

function var0_0.Enter(arg0_7, arg1_7)
	setText(arg0_7.winCondDesc, i18n(arg1_7:getConfig("win_condition_display")))
	setText(arg0_7.loseCondDesc, i18n(arg1_7:getConfig("lose_condition_display")))

	local var0_7 = arg1_7:getPlayType() == ChapterConst.TypeDefence

	setActive(arg0_7.rewardList, var0_7)

	if var0_7 then
		arg0_7:UpdateRewardList(arg1_7)
	end

	arg0_7:Show()
	Canvas.ForceUpdateCanvases()
end

function var0_0.UpdateRewardList(arg0_8, arg1_8)
	local var0_8 = arg1_8.id
	local var1_8 = pg.chapter_defense[var0_8]

	if not var1_8 then
		return
	end

	local var2_8 = Clone(var1_8.score)

	table.insert(var2_8, 1, var1_8.port_hp + 1)

	local var3_8 = {}

	for iter0_8, iter1_8 in ipairs(var1_0) do
		local var4_8 = var1_8["evaluation_display_" .. iter1_8]

		if #var4_8 > 0 then
			table.insert(var3_8, {
				type = var4_8[1],
				id = var4_8[2],
				count = var4_8[3]
			})
		end
	end

	arg0_8:UpdateList(var1_8, var2_8, var3_8, arg1_8.BaseHP)
end

return var0_0
