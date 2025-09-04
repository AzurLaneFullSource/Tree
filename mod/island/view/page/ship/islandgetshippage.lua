local var0_0 = class("IslandGetShipPage", import(".IslandBaseShipDisplayPage"))
local var1_0 = "hi"

function var0_0.getUIName(arg0_1)
	return "IslandGetShipUI"
end

function var0_0.NeedCache(arg0_2)
	return false
end

function var0_0.Preload(arg0_3, arg1_3, arg2_3)
	seriesAsync({
		function(arg0_4)
			arg0_3:PlayTimeline(arg0_4, arg2_3)
		end,
		function(arg0_5)
			arg0_3:PrepareCharacterScene(arg0_5)
		end
	}, function()
		IslandGuideChecker.CheckGuide("ISLAND_GUIDE_12")
		existCall(arg1_3)
	end)
end

function var0_0.PlayTimeline(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg2_7:getConfig("unit_id")

	arg0_7:PlayGetShipTimeline(var0_7, arg1_7)
end

function var0_0.OnLoaded(arg0_8)
	arg0_8.mainPanel = arg0_8._tf:Find("main")
	arg0_8.radarTr = arg0_8._tf:Find("main/rader")
	arg0_8.drawPolygon = arg0_8._tf:Find("main/rader/Quad"):GetComponent("DrawPolygon")
	arg0_8.back = arg0_8._tf:Find("main/back")
	arg0_8.goBtn = arg0_8._tf:Find("main/go")
	arg0_8.chatTr = arg0_8._tf:Find("chat")
	arg0_8.chatTxt = arg0_8._tf:Find("chat/Text"):GetComponent(typeof(Text))
	arg0_8.nameTxt = arg0_8._tf:Find("main/name"):GetComponent(typeof(Text))
	arg0_8.enNameTxt = arg0_8._tf:Find("main/en"):GetComponent(typeof(Text))

	setActive(arg0_8.chatTr, false)

	arg0_8.radarTxts = {
		arg0_8:findTF("main/rader/1/Text"):GetComponent(typeof(Text)),
		arg0_8:findTF("main/rader/2/Text"):GetComponent(typeof(Text)),
		arg0_8:findTF("main/rader/3/Text"):GetComponent(typeof(Text)),
		arg0_8:findTF("main/rader/4/Text"):GetComponent(typeof(Text)),
		arg0_8:findTF("main/rader/5/Text"):GetComponent(typeof(Text)),
		arg0_8:findTF("main/rader/6/Text"):GetComponent(typeof(Text))
	}
end

function var0_0.GetActiveCamName(arg0_9)
	return IslandConst.GET_CHARA_CAMERA_NAME
end

function var0_0.OnInit(arg0_10)
	onButton(arg0_10, arg0_10._tf, function()
		arg0_10:Hide()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.back, function()
		arg0_10:Hide()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.goBtn, function()
		arg0_10:Hide()
		arg0_10:OpenScenePage(IslandShipMainPage)
	end, SFX_PANEL)
	arg0_10:InitRaderTxt()
end

function var0_0.OnShow(arg0_14, arg1_14)
	arg0_14.ship = arg1_14

	setActive(arg0_14.mainPanel, false)
	arg0_14:LoadCharacter(arg0_14.ship:GetModel())
end

function var0_0.OnCharLoaded(arg0_15)
	arg0_15.passTime = 0
	arg0_15.animator = GetOrAddComponent(arg0_15.role.transform:GetChild(0), typeof(Animator))

	if not arg0_15.handle then
		arg0_15.handle = UpdateBeat:CreateListener(arg0_15.Update, arg0_15)
	end

	UpdateBeat:AddListener(arg0_15.handle)
	arg0_15:PlayAnimation()
	arg0_15:UpdateChat(arg0_15.ship)
end

function var0_0.Update(arg0_16)
	arg0_16.passTime = arg0_16.passTime + Time.deltaTime

	local var0_16 = arg0_16.animator:GetCurrentAnimatorStateInfo(0)

	if var0_16:IsName(var1_0) and not arg0_16.endTime then
		local var1_16 = var0_16.length / arg0_16.animator.speed

		arg0_16.endTime = arg0_16.passTime + var1_16
	end

	if arg0_16.endTime and arg0_16.passTime >= arg0_16.endTime then
		arg0_16:OnHelloAnimEnd()

		arg0_16.endTime = nil
	end
end

function var0_0.OnHelloAnimEnd(arg0_17)
	setActive(arg0_17.mainPanel, true)
	arg0_17:InitRader(arg0_17.ship)
	arg0_17:UpdateNames(arg0_17.ship)
	setActive(arg0_17.chatTr, false)

	if arg0_17.handle then
		UpdateBeat:RemoveListener(arg0_17.handle)

		arg0_17.handle = nil
	end
end

function var0_0.PlayAnimation(arg0_18)
	local var0_18 = Animator.StringToHash(var1_0)

	for iter0_18 = 1, arg0_18.animator.layerCount do
		arg0_18.animator:CrossFadeInFixedTime(var0_18, 0.2, iter0_18 - 1)
	end
end

function var0_0.GetSmoothRotateObject(arg0_19)
	return GetOrAddComponent(arg0_19:findTF("main/event"), typeof(SmoothRotateObject))
end

function var0_0.UpdateChat(arg0_20, arg1_20)
	arg0_20.chatTxt.text = arg1_20:GetNewShipWord()
end

function var0_0.InitRaderTxt(arg0_21)
	for iter0_21, iter1_21 in ipairs(IslandShipAttr.ATTRS) do
		local var0_21 = IslandShipAttr.ToChinese(iter1_21)

		arg0_21.radarTxts[iter0_21].text = var0_21
	end
end

function var0_0.InitRader(arg0_22, arg1_22)
	local var0_22 = IslandShipAttr.ATTRS
	local var1_22 = {}
	local var2_22 = {}
	local var3_22 = IslandCalcUtil.GetUnReHexPoints(arg0_22.radarTr.rect.width - 10, arg0_22.radarTr.rect.height - 10, 30)

	table.insert(var1_22, Vector3(0, 0, 0))

	for iter0_22, iter1_22 in ipairs(var0_22) do
		local var4_22 = arg1_22:GetAttr(iter1_22)

		table.insert(var1_22, arg0_22:GetPoint(var3_22[iter0_22], var4_22, 30))
		table.insert(var2_22, 0)
		table.insert(var2_22, iter0_22)

		if iter0_22 + 1 > #var0_22 then
			table.insert(var2_22, 1)
		else
			table.insert(var2_22, iter0_22 + 1)
		end
	end

	local var5_22 = IslandCalcUtil.Vetor3Table2Array(var1_22)

	arg0_22.drawPolygon:draw(var5_22, var2_22)
end

function var0_0.GetPoint(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = Mathf.Clamp01(arg2_23 / arg3_23)

	return Vector2.Normalize(arg1_23) * (Vector2.Magnitude(arg1_23) * var0_23)
end

function var0_0.UpdateNames(arg0_24, arg1_24)
	arg0_24.nameTxt.text = arg1_24:GetName()
	arg0_24.enNameTxt.text = arg1_24:GetEnName()
end

function var0_0.OnDestroy(arg0_25)
	var0_0.super.OnDestroy(arg0_25)

	if arg0_25.handle then
		UpdateBeat:RemoveListener(arg0_25.handle)

		arg0_25.handle = nil
	end
end

return var0_0
