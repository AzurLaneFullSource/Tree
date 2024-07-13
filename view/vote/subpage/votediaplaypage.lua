local var0_0 = class("VoteDiaplayPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "VoteDisplay"
end

function var0_0.OnInit(arg0_2)
	arg0_2.paitingTF = findTF(arg0_2._tf, "painting")
	arg0_2.numberTxt = findTF(arg0_2._tf, "filter_bg/Text"):GetComponent(typeof(Text))
	arg0_2.nameTxt = findTF(arg0_2._tf, "frame/bg/name"):GetComponent(typeof(Text))
	arg0_2.enNameTxt = findTF(arg0_2._tf, "frame/bg/en_name"):GetComponent(typeof(Text))
	arg0_2.descTxt = findTF(arg0_2._tf, "frame/bg/scroll/desc"):GetComponent(typeof(Text))
	arg0_2.valueInput = findTF(arg0_2._tf, "frame/bg/InputField"):GetComponent(typeof(InputField))
	arg0_2.addBtn = findTF(arg0_2._tf, "frame/bg/add")
	arg0_2.miunsBtn = findTF(arg0_2._tf, "frame/bg/miuns")
	arg0_2.maxBtn = findTF(arg0_2._tf, "frame/bg/max")
	arg0_2.submitBtn = findTF(arg0_2._tf, "frame/bg/submit")
	arg0_2.rankTxt = findTF(arg0_2._tf, "frame/bg/rank"):GetComponent(typeof(Text))
	arg0_2.votesTxt = findTF(arg0_2._tf, "frame/bg/votes"):GetComponent(typeof(Text))
	arg0_2.shiptypeTxt = findTF(arg0_2._tf, "frame/bg/shiptype"):GetComponent(typeof(Text))
	arg0_2.nationImg = findTF(arg0_2._tf, "frame/bg/nation"):GetComponent(typeof(Image))
	arg0_2.bg1 = findTF(arg0_2._tf, "frame/bg/bg1")
	arg0_2.bg2 = findTF(arg0_2._tf, "frame/bg/bg2")
end

function var0_0.Open(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	arg0_3.callback = arg5_3

	assert(arg0_3.callback)

	arg0_3.maxValue = arg3_3
	arg0_3.rank = arg2_3
	arg0_3.value = 1

	setActive(arg0_3.bg1, not arg4_3)
	setActive(arg0_3.bg2, arg4_3)

	arg0_3.votes = arg4_3 or "-"

	setActive(arg0_3._tf, true)

	arg0_3.numberTxt.text = "X" .. arg3_3

	if arg1_3 ~= arg0_3.voteShip then
		arg0_3.voteShip = arg1_3

		arg0_3:Update(arg1_3)
	end

	onInputEndEdit(arg0_3, go(arg0_3.valueInput), function()
		local var0_4 = getInputText(go(arg0_3.valueInput))
		local var1_4 = tonumber(var0_4)

		if var1_4 < 1 then
			arg0_3.value = 1
		elseif var1_4 > arg0_3.maxValue then
			arg0_3.value = math.max(1, arg0_3.maxValue)
		else
			arg0_3.value = var1_4
		end

		arg0_3:UpdateCnt()
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.UpdateCnt(arg0_5)
	arg0_5.valueInput.text = arg0_5.value
end

function var0_0.Update(arg0_6, arg1_6)
	arg0_6.nameTxt.text = arg1_6:getShipName()
	arg0_6.enNameTxt.text = arg1_6:getEnName()
	arg0_6.descTxt.text = arg1_6:GetDesc()
	arg0_6.votesTxt.text = arg0_6.votes
	arg0_6.rankTxt.text = arg0_6.rank
	arg0_6.shiptypeTxt.text = arg1_6:getShipTypeName()

	local var0_6 = arg1_6:getNationality()
	local var1_6

	if var0_6 then
		var1_6 = LoadSprite("prints/" .. nation2print(var0_6) .. "_0")
	else
		var1_6 = GetSpriteFromAtlas("ui/VoteUI_atlas", "nation")
	end

	arg0_6.nationImg.sprite = var1_6

	arg0_6:UpdateCnt()
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:Close()
	end)
	onButton(arg0_6, arg0_6.addBtn, function()
		if arg0_6.value >= arg0_6.maxValue then
			return
		end

		arg0_6.value = arg0_6.value + 1

		arg0_6:UpdateCnt()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.miunsBtn, function()
		if arg0_6.value == 1 then
			return
		end

		arg0_6.value = arg0_6.value - 1

		arg0_6:UpdateCnt()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.maxBtn, function()
		if arg0_6.maxValue == 0 then
			return
		end

		arg0_6.value = arg0_6.maxValue

		arg0_6:UpdateCnt()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.submitBtn, function()
		arg0_6.callback(arg0_6.value)
		arg0_6:Close()
	end, SFX_PANEL)

	arg0_6.paintingName = arg1_6:getPainting()

	LoadPaintingPrefabAsync(arg0_6.paitingTF, arg0_6.paintingName, arg0_6.paintingName, "jiesuan")
end

function var0_0.Close(arg0_12)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf, arg0_12._parent)
	setActive(arg0_12._tf, false)
	retPaintingPrefab(arg0_12.paitingTF, arg0_12.paintingName)

	arg0_12.callback = nil
	arg0_12.maxValue = 0
	arg0_12.rank = 0
	arg0_12.value = 1
	arg0_12.voteShip = nil
end

function var0_0.OnDestroy(arg0_13)
	arg0_13:Close()
end

return var0_0
