local var0 = class("SummaryPage2", import(".SummaryAnimationPage"))

function var0.OnInit(arg0)
	local var0 = findTF(arg0._go, "name/Text")

	setText(var0, arg0.summaryInfoVO.firstProposeName)

	local var1 = findTF(arg0._go, "texts")

	arg0.textTFs = {}

	for iter0 = 1, var1.childCount do
		local var2 = var1:GetChild(iter0 - 1)
		local var3 = go(var2).name

		if var3 ~= "label" then
			setText(var2:Find("Text"), arg0.summaryInfoVO[var3])
		end

		table.insert(arg0.textTFs, var2)
	end

	local var4 = findTF(arg0._go, "name/date")

	setText(var4, arg0.summaryInfoVO.firstLadyTime)

	local var5 = findTF(arg0._go, "painting"):Find("mask/painting")
	local var6 = Ship.New({
		configId = arg0.summaryInfoVO.firstLadyId
	}):getPainting()

	setPaintingPrefabAsync(var5, var6, "chuanwu")
	setActive(arg0._go, false)
end

function var0.Clear(arg0)
	return
end

return var0
