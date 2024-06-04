local var0 = class("VoteDiaplayPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "VoteDisplay"
end

function var0.OnInit(arg0)
	arg0.paitingTF = findTF(arg0._tf, "painting")
	arg0.numberTxt = findTF(arg0._tf, "filter_bg/Text"):GetComponent(typeof(Text))
	arg0.nameTxt = findTF(arg0._tf, "frame/bg/name"):GetComponent(typeof(Text))
	arg0.enNameTxt = findTF(arg0._tf, "frame/bg/en_name"):GetComponent(typeof(Text))
	arg0.descTxt = findTF(arg0._tf, "frame/bg/scroll/desc"):GetComponent(typeof(Text))
	arg0.valueInput = findTF(arg0._tf, "frame/bg/InputField"):GetComponent(typeof(InputField))
	arg0.addBtn = findTF(arg0._tf, "frame/bg/add")
	arg0.miunsBtn = findTF(arg0._tf, "frame/bg/miuns")
	arg0.maxBtn = findTF(arg0._tf, "frame/bg/max")
	arg0.submitBtn = findTF(arg0._tf, "frame/bg/submit")
	arg0.rankTxt = findTF(arg0._tf, "frame/bg/rank"):GetComponent(typeof(Text))
	arg0.votesTxt = findTF(arg0._tf, "frame/bg/votes"):GetComponent(typeof(Text))
	arg0.shiptypeTxt = findTF(arg0._tf, "frame/bg/shiptype"):GetComponent(typeof(Text))
	arg0.nationImg = findTF(arg0._tf, "frame/bg/nation"):GetComponent(typeof(Image))
	arg0.bg1 = findTF(arg0._tf, "frame/bg/bg1")
	arg0.bg2 = findTF(arg0._tf, "frame/bg/bg2")
end

function var0.Open(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.callback = arg5

	assert(arg0.callback)

	arg0.maxValue = arg3
	arg0.rank = arg2
	arg0.value = 1

	setActive(arg0.bg1, not arg4)
	setActive(arg0.bg2, arg4)

	arg0.votes = arg4 or "-"

	setActive(arg0._tf, true)

	arg0.numberTxt.text = "X" .. arg3

	if arg1 ~= arg0.voteShip then
		arg0.voteShip = arg1

		arg0:Update(arg1)
	end

	onInputEndEdit(arg0, go(arg0.valueInput), function()
		local var0 = getInputText(go(arg0.valueInput))
		local var1 = tonumber(var0)

		if var1 < 1 then
			arg0.value = 1
		elseif var1 > arg0.maxValue then
			arg0.value = math.max(1, arg0.maxValue)
		else
			arg0.value = var1
		end

		arg0:UpdateCnt()
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.UpdateCnt(arg0)
	arg0.valueInput.text = arg0.value
end

function var0.Update(arg0, arg1)
	arg0.nameTxt.text = arg1:getShipName()
	arg0.enNameTxt.text = arg1:getEnName()
	arg0.descTxt.text = arg1:GetDesc()
	arg0.votesTxt.text = arg0.votes
	arg0.rankTxt.text = arg0.rank
	arg0.shiptypeTxt.text = arg1:getShipTypeName()

	local var0 = arg1:getNationality()
	local var1

	if var0 then
		var1 = LoadSprite("prints/" .. nation2print(var0) .. "_0")
	else
		var1 = GetSpriteFromAtlas("ui/VoteUI_atlas", "nation")
	end

	arg0.nationImg.sprite = var1

	arg0:UpdateCnt()
	onButton(arg0, arg0._tf, function()
		arg0:Close()
	end)
	onButton(arg0, arg0.addBtn, function()
		if arg0.value >= arg0.maxValue then
			return
		end

		arg0.value = arg0.value + 1

		arg0:UpdateCnt()
	end, SFX_PANEL)
	onButton(arg0, arg0.miunsBtn, function()
		if arg0.value == 1 then
			return
		end

		arg0.value = arg0.value - 1

		arg0:UpdateCnt()
	end, SFX_PANEL)
	onButton(arg0, arg0.maxBtn, function()
		if arg0.maxValue == 0 then
			return
		end

		arg0.value = arg0.maxValue

		arg0:UpdateCnt()
	end, SFX_PANEL)
	onButton(arg0, arg0.submitBtn, function()
		arg0.callback(arg0.value)
		arg0:Close()
	end, SFX_PANEL)

	arg0.paintingName = arg1:getPainting()

	LoadPaintingPrefabAsync(arg0.paitingTF, arg0.paintingName, arg0.paintingName, "jiesuan")
end

function var0.Close(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parent)
	setActive(arg0._tf, false)
	retPaintingPrefab(arg0.paitingTF, arg0.paintingName)

	arg0.callback = nil
	arg0.maxValue = 0
	arg0.rank = 0
	arg0.value = 1
	arg0.voteShip = nil
end

function var0.OnDestroy(arg0)
	arg0:Close()
end

return var0
