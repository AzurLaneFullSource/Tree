local var0 = class("WinConditionDisplayPanel", BaseSubView)

function var0.getUIName(arg0)
	return "WinConditionDisplayPanel"
end

function var0.OnInit(arg0)
	arg0.listTF = arg0._tf:Find("window/bg/awards/awardList")
	arg0.closeBtn = arg0._tf:Find("window/top/btnBack")
	arg0.winCondtitle = arg0:findTF("window/bg/winCond/title/text")

	setText(arg0.winCondtitle, i18n("text_win_condition"))

	arg0.winCondDesc = arg0:findTF("window/bg/winCond/desc")
	arg0.loseCondtitle = arg0:findTF("window/bg/loseCond/title/text")

	setText(arg0.loseCondtitle, i18n("text_lose_condition"))

	arg0.loseCondDesc = arg0:findTF("window/bg/loseCond/desc")
	arg0.rewardList = arg0:findTF("window/bg/awards")
	arg0.rewardtip = arg0:findTF("text", arg0.rewardList)

	setText(arg0.rewardtip, i18n("desc_defense_reward"))

	arg0.rewardWord = arg0:findTF("desc", arg0.rewardList)

	setText(arg0.rewardWord, i18n("word_reward"))

	arg0.rewardCond = arg0:findTF("cond", arg0.rewardList)

	setText(arg0.rewardCond, i18n("text_rest_HP"))
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

local var1 = {
	"s",
	"a",
	"b"
}

function var0.UpdateList(arg0, arg1, arg2, arg3, arg4)
	local var0

	if #arg3 == 3 then
		arg0.listTF:GetChild(1).gameObject:SetActive(true)
		arg0.listTF:GetChild(2).gameObject:SetActive(true)
		arg0.listTF:GetChild(3).gameObject:SetActive(true)

		var0 = {
			3,
			2,
			1
		}
	elseif #arg3 == 2 then
		arg0.listTF:GetChild(1).gameObject:SetActive(true)
		arg0.listTF:GetChild(2).gameObject:SetActive(false)
		arg0.listTF:GetChild(3).gameObject:SetActive(true)

		var0 = {
			3,
			1
		}
	elseif #arg3 == 1 then
		arg0.listTF:GetChild(1).gameObject:SetActive(false)
		arg0.listTF:GetChild(2).gameObject:SetActive(true)
		arg0.listTF:GetChild(3).gameObject:SetActive(false)

		var0 = {
			2
		}
	end

	local var1 = false

	for iter0 = 1, #arg3 do
		local var2 = arg0.listTF:GetChild(var0[iter0])
		local var3 = tostring(arg2[iter0] - 1)

		if arg2[iter0] - 1 ~= arg2[iter0 + 1] then
			var3 = tostring(arg2[iter0 + 1]) .. "-" .. var3
		end

		setText(var2:Find("text"), var3)

		local var4 = arg3[iter0]

		updateDrop(var2:Find("award"), var4, {
			hideName = true
		})
		onButton(arg0, var2:Find("award"), function()
			arg0:emit(BaseUI.ON_DROP, var4)
		end, SFX_PANEL)

		local var5 = not var1 and arg4 >= arg2[iter0 + 1]

		var1 = var1 or arg4 >= arg2[iter0 + 1]

		setActive(var2:Find("mask"), not var5)
	end
end

function var0.Enter(arg0, arg1)
	setText(arg0.winCondDesc, i18n(arg1:getConfig("win_condition_display")))
	setText(arg0.loseCondDesc, i18n(arg1:getConfig("lose_condition_display")))

	local var0 = arg1:getPlayType() == ChapterConst.TypeDefence

	setActive(arg0.rewardList, var0)

	if var0 then
		arg0:UpdateRewardList(arg1)
	end

	arg0:Show()
	Canvas.ForceUpdateCanvases()
end

function var0.UpdateRewardList(arg0, arg1)
	local var0 = arg1.id
	local var1 = pg.chapter_defense[var0]

	if not var1 then
		return
	end

	local var2 = Clone(var1.score)

	table.insert(var2, 1, var1.port_hp + 1)

	local var3 = {}

	for iter0, iter1 in ipairs(var1) do
		local var4 = var1["evaluation_display_" .. iter1]

		if #var4 > 0 then
			table.insert(var3, {
				type = var4[1],
				id = var4[2],
				count = var4[3]
			})
		end
	end

	arg0:UpdateList(var1, var2, var3, arg1.BaseHP)
end

return var0
